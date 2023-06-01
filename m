Return-Path: <netdev+bounces-7161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EDD71EF28
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCFBD1C21103
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53858171D6;
	Thu,  1 Jun 2023 16:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4166BD533
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:34:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5268E193;
	Thu,  1 Jun 2023 09:34:29 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E44MF008028;
	Thu, 1 Jun 2023 16:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ninq5w8bfoSDhZQG/aMc82YWsE7QFwrpXxaziYlzcmQ=;
 b=0lVc1LA/aFmu9oVQuzL3jdSTB+jS7a6dXJAXTmBBa42aqzQEHgXPvmLC+LZogscPVXhA
 gNLVhwH5AfOfQskxv5JzAVqrfyr/8UVU8SCUYm0yWHVDuH16P3vO4f+Qmq8uEvfv8vbq
 IrgP/JyC8sPPClpBpG2Yp1klqrJrNbJD4eAnh6N1rq9SXPd3rEXD7Ik0hOLtMLXNH+/1
 wZVErfGfzUuockmKuSfZnbs7zZ+gBT+nTlXRxvsCwwBdwKMeQAhg6APLG07szpDFH6y1
 vtWFKl/lYneGtvnXQE/uNM7JvQizeQrUuQqURy8ve7QtcMzo9YVAxobuDcp28Fu8elpe Vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhda1d4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:34:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351G2Eq9004404;
	Thu, 1 Jun 2023 16:34:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4yf2tp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuXbEl2r2Yjy0aa0FT5ntu9pmwp9FxjzuchwkdaFdie/jn+E0dagDG7L4t4iREGDigvPD1vsUMzolnNIFQXy31qJbrTHcKMH27GLznxqXWya8ZZVfgKeCZTCC8asvEagduhoQFvDPX/DP+dXXeGC7+crbEfycE44S3BUbzqrAfdYKB/BUDnDG2q3SRPI7Vap0Ym2IPUY07Ukl8dVzwlX9oklEYslBDfdqJo5mdYCPYJPXw3QInbRenIumMRJc64x54DFKwzHBVuwxN+1i7T3H9gNeXzzQxY7Gvs9ReopfRO1DW0io3t7KcwUsc7Rt0+UeMnDVkr+aatFsd1C+4QF3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ninq5w8bfoSDhZQG/aMc82YWsE7QFwrpXxaziYlzcmQ=;
 b=Hxgzj1ysUmuOgAIEJCk0INnw/hMW9QLI4axdUKXbK6fibeDdW9PyDxPRbYrNIj7PFwvuYql4IexJHfnB8/YpI5djE9KWKQEyWo9tZfGGacEg8MHiAGFgI0mgHb7m6DK6iqJlqKDETEGWhNbmKxN621pE+zg7lodVQD3/K5T1vAYwHZcO4wOy2HCqgiZqyt2EoqOMa9CzhypmvkVaxvgumq2I3aQfW07g4El8Vl6mMp2+LrWz63qcE/WktHl4kvDP89VqJFa2ZnpQ9TXcifgU3kvpyC+LXUHXzMhgLHZguDkLE7e9QzE1tgnTLQnVffYzzJhyPHDIEgHmFd1FPJgR3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ninq5w8bfoSDhZQG/aMc82YWsE7QFwrpXxaziYlzcmQ=;
 b=mmpGBSo6xz9g+ERZ2r3DQ6VdngU/gg3ptzUeMDnk7NP0YTsZovvkWTt715jWIlPxnrlOde27oW/WMKqfQgmf5I7w6qNw5Ri1sundbWakEAYAencHZQ4Pni8fAD9UUdpTbBbNgf294PElc34VzC3ihoPJS7H6MzY/FFp4hT/WWuU=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 16:34:08 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:34:08 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org"
	<brauner@kernel.org>,
        "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com"
	<ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net"
	<socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: 
 AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAJFpdAIABHiYAgBXwRACAIQQKAIAAApUAgAACn4A=
Date: Thu, 1 Jun 2023 16:34:08 +0000
Message-ID: <6A9C1580-8B7B-42DB-B37A-A948F68E3FFF@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
 <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
 <20230403135008.7f492aeb@kernel.org>
 <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
 <20230427100304.1807bcde@kernel.org>
 <472D6877-F434-4537-A075-FE1AE0ED078A@oracle.com>
 <BF7B6B37-10BF-41C0-BA77-F34C31ED886E@oracle.com>
 <20230601092444.6b56b1db@kernel.org>
In-Reply-To: <20230601092444.6b56b1db@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA0PR10MB7349:EE_
x-ms-office365-filtering-correlation-id: 0adf40e7-83e3-4970-0082-08db62be05f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 mULXPsqjQFuLddCpZ+ZEkP8Hei0qimPMvqRgYTRsS96PZLIsTgeLQu2CKpFZRFvuS1EJ/pzn7fqDmCrT8EKLWcEyWg5oWE05I1DsqFGgrLQ0wr4xetB3rRdq5UVG5qst5H4wOwFYk378Co6pdBEbCdV67qJpTaDQBc92J7oPyyocoPTK2UmUCCar44ro78Lxbb/DMajiYaNfUmoeBML1cuMCyK7yKNHok37ylOXizVgNUj6wX0Wje4w70gQdUXIYPp1Gp8HudSeD3Opd9DrLh1dGzPFcMs2bcMT0eXrANzIErbymHuTr8KmkPWC5XV1vrxfbxaLn2HYZWPwblbb/y5gWlpI82Jw4zNt5yd8ug71Px6v9DVPQA2EC0tujYghK/SQZ+VgB7xjoEzunJQAx3zYLDlcIkFcZeGMDl/0Tf175xdz0vYa+V5FkmjrNAFinKHNjDJ40zqHxE9hN5l9HYe4mFKy+NmzQx1GQ6IK41qQfY/HcPEzSW2z3R/g7h/jsrzyOTQQNfxwnafHqCHhXtNtRSeFqiU9vP0hEAebMYm3I1nlHNkWyy1t5hrT6QfarrnB6SrhgL/6qWJ1qg1d7VSgAzBrn+GFyNK1tOeXItkaXqrPs5JhjtDQxgEyiiBhmyLEFIe3U/9F91KXQ968JEg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(83380400001)(26005)(6506007)(6512007)(53546011)(41300700001)(38100700002)(186003)(6486002)(2616005)(71200400001)(478600001)(54906003)(4326008)(6916009)(76116006)(66446008)(64756008)(66556008)(122000001)(66476007)(66946007)(316002)(7416002)(2906002)(5660300002)(8676002)(8936002)(33656002)(86362001)(38070700005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?b4kZu+zW5A2RevgBZJ/Ms2y+TyH12UzMZ+pHAnLu8Gb2P6ktB2ENpfC7n4je?=
 =?us-ascii?Q?aeLP0sfiRK2OSBp9F5ORV29jQKOt2fUGdy/nYdhInNdbkbDcf7vWjlymPn4E?=
 =?us-ascii?Q?AsoI6LYoZIYgFk6o8D04vcP9b8wQehuvFkEw5m7MiN+JF691OlND681w+nfZ?=
 =?us-ascii?Q?aDt4eI3IuroTjaZLtsIK7NNcF8bK5pzfT3SdBXz32mdWhm4tDLIl3Dg6eDlZ?=
 =?us-ascii?Q?CvNpFCqNKlqwUBHBiwaeB3CZvIUjbxsxgEyEyNIaeXKSQNZ5iLFbrOdfKxOG?=
 =?us-ascii?Q?80VKWqCLbaYU67FreK9o2Ossk18urs/m/GkHLkmD7Lh29VoyLK/VuRlLpGjm?=
 =?us-ascii?Q?d4sK0slTVQw59xx/3tb+yZoaFlzaVbUBmhWsnhWCyVu2AxDLizIw/wX8cebx?=
 =?us-ascii?Q?IeQlqn0z+QDBs+QRtm3WYNocppi4NwRc4pQYDwMv21+FUL0eHyfNc3vLvYb+?=
 =?us-ascii?Q?jiBYxpuOEv3NCyyjdPadw6sLR4u26HQhfS5ileQ6bn2xfcDOa3asO4mIT0m0?=
 =?us-ascii?Q?K1F2Es3q1D8iFfpfia7ILNLWGrEcsO7c/dRKCNOyqS09fp3sQ7P3/PjkOiCQ?=
 =?us-ascii?Q?JWgBx/N9p0zruGxPEj+s9HH43qWlgsijUFsHLOEbXzWj7R2MM4iTXGT4PYTZ?=
 =?us-ascii?Q?dJRLoIlAOFfH3gU4iz0yhuDwqxs3jwLRRxWfGt9g2+G/IbmB4zMhP6X+H9D7?=
 =?us-ascii?Q?vGCSsIeKgkhvMRYhJRw/7T23neme10TA+FNqg1J12MtSLeJTcoUTGxe9fI4C?=
 =?us-ascii?Q?mO+0uuSkDqEfCBStJDyYGhYXuLK4IY/NONNy8wGZJ64Vte1SU79lqj40QSnO?=
 =?us-ascii?Q?WVbwlHlLQcWvyLlHOJZpTtq4c8/iDHcpruaElqw0Q8q8BoZanNiOCCwJd0Vk?=
 =?us-ascii?Q?cmUbIpP2+oQNgAkj+zIMsIL/26WODLDR7iUjwUPCKTab9PCmuAFmqcg4un4h?=
 =?us-ascii?Q?d+qVEUatd6nLOygrkGUkJP1PP4snwMSMRjehS1oIlf3Xc72ExYCRJkJZ558V?=
 =?us-ascii?Q?MzME90xYXCtuf4mHvhB3iFKEl+ane635IJWsuF+yOlbS6q28xuavrc5d79Sw?=
 =?us-ascii?Q?yCKjpSytvRuVu2sOkiO5HVA1kWl9YgToYY4A0NxLJ4z/x2htrzxGs9CKyodw?=
 =?us-ascii?Q?wXmfcdcTrT5g2vgl6COie/yJ9AzVo8v0LzwtWYJidDdR/lkxm6Far32XTYee?=
 =?us-ascii?Q?LyooMDzeS9nBTkc+wy5PQTsKgQfz2nT3z2skY7XXTRxPp94mVsFwlYoIi8d1?=
 =?us-ascii?Q?9zH35M/QI2IctjUIxsybgo5pJWvep7ey1q2NzU3Un2/V1EMpR4xRlU4kqSb1?=
 =?us-ascii?Q?Yaj/ICgMFabQykMRvV4cFWs4cvnUaT/1CkNkNhkLrwLpXPF39X81WQo6oJ/4?=
 =?us-ascii?Q?ry5WA2dHHFOLjozaKoKdezooMeo7sLvCi+ftDP6Gm9koT2x7Thax1pnYdu1Z?=
 =?us-ascii?Q?BBXbzDzlS5PVgJjJWL475c7td/iuCLWqSQJHXgOjgSno95xat2Mp9DTG2KAh?=
 =?us-ascii?Q?85eU/mdTAxyfXstXjK24i0TUyFKC+6sVVni+u/aKuAVTSLFmUdNQeyebM/8s?=
 =?us-ascii?Q?M13t85rCO6IehTjvld0UDfALywfTRm31kDhVDdOmKKhO4BMy5ZgS4suhHJQR?=
 =?us-ascii?Q?HQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5EFC1BF7947BF46845277690A578CC4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?NEiDt4uncPA/mpRIEAu2TGvx+CxLiN7qiMLucn0PEhOc/TfJqCYtymj+Xw12?=
 =?us-ascii?Q?7IFYuD/PFxkOf7QG3wXCBUsi3C6zUFvvQBwZ78f9aatEyQSWjzcTrr+98Yeh?=
 =?us-ascii?Q?Fp1emZH3swPewcff9ka38dOzSevEeJbFIm3jDCPnGco5TmwbqkHJeLrMRwGv?=
 =?us-ascii?Q?epgxWS7VBC2K8yiDqHSAJsYopk/2WtcyfxZ4bLWMIsw1tvdzd8ItZLdqkMYV?=
 =?us-ascii?Q?yYcsCY3PoT7kxKIfo1Y5ierhVeF3cJmT9BWlk9MWKVjfjGqSRh+MwveHjTJ+?=
 =?us-ascii?Q?4oaV+B7RT+lpuXBHtcZN8XOZofGZyNb0nbScHIYQ0Y1Fuy+6hEJX4W1dVzET?=
 =?us-ascii?Q?sPbbzeLt+qKWlqyW2m54cqnGoa8pBNc9+mGmKcZkTKuWGf9+aUXPX5Oxdosx?=
 =?us-ascii?Q?dqNT5Sihnt/RZ8AhVX4MSbGOzBD0HdIQ2VcDeqYfB5WmxeC/ILtiD1AB3f5K?=
 =?us-ascii?Q?obeYqIGoslAdOfGb+xdr9075+hsfyt7XVoLCPhzwkOan1KOtdHuqJiufEJTR?=
 =?us-ascii?Q?UrG7U0KinrlA2DOCm6ywiS6JED1+zcLZtyzeuUEeOWbbHHs9bEDHil3tTLAk?=
 =?us-ascii?Q?xl7nO/k4KLgsxHYXfrpTvdJgS5vY6VY59K4C/Is1fdehWBfSSkynrJlAJZvn?=
 =?us-ascii?Q?CfswiUp8iqonBfTfQMR89b6ytbUMflWyMGz6KCEcVe6McIfM0uVz0cVggdqE?=
 =?us-ascii?Q?0Ealhpcnsyx/MDS/B+ZBd0UVe4j5f5XJ2kERis56KWx8RrWA8Fra/vnTeguU?=
 =?us-ascii?Q?oA2/5j80VMc1gAzFrm7DcFns2adWni2oeosvd6jPXQbllRZwITB1yDJqpJj0?=
 =?us-ascii?Q?SC1zR/BTGUQ6zydN1Kpf2aQVpSVHUNez9UeIQ8A642tRc5HAIUfG9e4Vv01Q?=
 =?us-ascii?Q?IVMX8RbcyWPxl5QpCc2FoThYrBBIQrVew2hg2iX7ktJ0yXnGmR+cM4MGzz4s?=
 =?us-ascii?Q?/FCg/wTQjZZNbqF4Y6YhE2wrtAmZPHNHITL3ueaDfLvVB9uSLRcgjpXzSny1?=
 =?us-ascii?Q?m7Zq0Cx9mnLOpVVr/Z4pDXPmCKOi8lYx80GfbL84LaFeb8kK/3OllzZFwZ5R?=
 =?us-ascii?Q?Kd1HZkLlBNg785f+D22U7Hg9wLNimQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0adf40e7-83e3-4970-0082-08db62be05f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:34:08.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7630hP+aLQBF1owZswOpwKi5xqA8zWY8wXf0g9eI7QyAKpf9DETy8j7z8wd0eOLzNmQgN29ZC7jaEYDq7auNmVpEvfLrQrHz6U33E6Y6FSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010144
X-Proofpoint-GUID: S_Jc5FDxDchcHa8Fl6Yuf7XZhQ2jReL0
X-Proofpoint-ORIG-GUID: S_Jc5FDxDchcHa8Fl6Yuf7XZhQ2jReL0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 9:24 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 1 Jun 2023 16:15:31 +0000 Anjali Kulkarni wrote:
>>>> I don't have sufficient knowledge to review that code, sorry :( =20
>>>=20
>>> Is there anyone who can please help review this code?=20
>>> Christian, could you please help take a look?
>>=20
>> Gentle ping again - Christian could you please help review?
>=20
> The code may have security implications, I really don't feel like I can
> be the sole reviewer. There's a bunch of experts working at Oracle,
> maybe you could get one of them to put their name on it? I can apply
> the patches, I just want to be sure I'm not the _only_ reviewer.

Thanks so much for your response. There is someone at Oracle who looked at =
this some time ago and is familiar enough with this to review the code - bu=
t he is not a kernel committer - he sends occasional patches upstream which=
 get committed - would it be ok if he reviewed it along with you and then y=
ou could commit it? If you know of someone from Oracle who could also poten=
tially review it, please let me know.=20


