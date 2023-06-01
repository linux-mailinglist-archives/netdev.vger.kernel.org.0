Return-Path: <netdev+bounces-7167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C83BD71EF86
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70FD1281745
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64F81C773;
	Thu,  1 Jun 2023 16:50:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B288413AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:50:03 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856271AC;
	Thu,  1 Jun 2023 09:49:59 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4sDx008555;
	Thu, 1 Jun 2023 16:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CdyeVqEO9ilsV7vOKJ4Jl7M/LhNSssdqQOVLqi37LMs=;
 b=lcRdozx1lwBJYb47QKQ/y/4FsbJN8zuKx+bZYpuLaidR9gTwvzlN7F5iX4ozrNt7O+6q
 Tzw+EMkuR3+EuDg3T8Jq7Ko7USkOgWDAQPEhNX6ngIvKKpqgcU9n8EZ12wfHhdlS3qOQ
 9RsPrBZvfuv5+da6BE5r8jju+Uv6IVAFW2JWL+Th2cG/fuAk7s0Znwn6HGPVso8ec2Hf
 NQS5yX8jKrurwviDrLB+3UTJBSTF4Lg0gGlEyhDZMiUEK3eyd1Ib6DFxqW6WHUvWiWN2
 5DGtCAp/mryrw0xW7C+NEoWas59H9DQTEO+i76hJORIWZDPXX3N9mentfc8W23wKtR79 Qg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjh98x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:49:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351FVZ3O019823;
	Thu, 1 Jun 2023 16:49:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7ps7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:49:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QU5Oav5lNqKeQsXxcfUKpUWBiKZkqAhxdJdJ68f+QZtim+MSMpeIox9E2NsAsFXFt6a4Cun1x+vqw/TZUFLMXZo4TtSK33TUXSBM3HIht8yNKmGc16u9JMkajiCnnvv6ufzo7qtPjDfOTGmha05Ghat8X37MCNN1lNZe6351qXDNXSIp/2JhGHGCx+3FdFSkBCsCBd8Np3TbFI2MtdxIbmc6L/WQPJBnNqG8kAdxusf/xB3tTagpRjLNZkYlpacRf03ais55HFTC0GK+n4sti9PxBGVCjta7yukzPvuA6mBih8OdvU0S2tZ1wODvAsG0MUNK4UgJXTnKglcMZhYaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdyeVqEO9ilsV7vOKJ4Jl7M/LhNSssdqQOVLqi37LMs=;
 b=gjquiZytvXRjpvlo+7XTf1WebE1vdRMxhxgYVBAuzU9wI3rKZr2cbK9gLvHP9EChClxvfPMLEsnV01eNJovk7OdVIa3SOqvR1a9tlGlOxCcD0LzSK7vDI85ePYFdyA995z4uorJn5u3KvDSyaAg0BNHONARNX5cz0Lf/nfhNWoOtf+4It1YA47tKe8TtW9HP8w+fTMMoFhpjHhBoxfR6E70qDR50cNcDPMaAMD+tZvxlQUWp8kGAZp/D25NqGvm/WiaVKCz9MEai6EGD/HgCFqBTHKwUiePHHofBfDWE5+NAUKUqsRbL91J8WMfi8HmDwg+fSluD4IfS3pIaWyli+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdyeVqEO9ilsV7vOKJ4Jl7M/LhNSssdqQOVLqi37LMs=;
 b=ZrY9AZ+8UeaZrcgpkCJO9XPGvzYA5qddTAvQYxGes+turYFtnRogOxrKfk4uClmm5S/Kh3p1ZFLuqlO07e0c2fKRhuoDAmqZKSS5D7OeZyKPfMeU4khuEnIwOTd4BxQWQPU8t6JrbPvfT3xDsbPXSyQ7IMHjvYDRjUP4qM6dzNQ=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by DS0PR10MB7051.namprd10.prod.outlook.com (2603:10b6:8:147::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 16:49:35 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:49:34 +0000
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
 AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAJFpdAIABHiYAgBXwRACAIQQKAIAAApUAgAACn4CAAAKMAIAAAcGA
Date: Thu, 1 Jun 2023 16:49:34 +0000
Message-ID: <B8F9063A-8121-4D32-99AE-C547B653A57D@oracle.com>
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
 <6A9C1580-8B7B-42DB-B37A-A948F68E3FFF@oracle.com>
 <20230601094314.61aa2d5b@kernel.org>
In-Reply-To: <20230601094314.61aa2d5b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|DS0PR10MB7051:EE_
x-ms-office365-filtering-correlation-id: 511f3ccb-94b6-4603-d555-08db62c02e07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 f27l/a1vsWn9BgZSaLOeQtg+crYSPhi1HY3hwfZT3vC2qa382EmYmN9KvjqNDD4xoTfzPP+39nN8A0JTyoO+woK/7ZaRZrPwYLE2tadRt8M2HUk9RRqyxZm/0wDR1EBWY/u8AUJnE1JTjtdOtbKqdU0DQRbeqOCA+Vhqlb40wwO2j/4qlW+MMyH+OChJkzl5mtfHEl45xS2ysNBS+UneK7zDwcki/diJFeW68wFTe9FV8bCkLuRv0++kXa5azLT2dGRCkPKzMcU2+OcLzxqVa87kV0YS/TRKWy8g2MC3uC9q3QsXF+jQe+SVDv5a4O1Ml9XZ5StNtdJKjk9n8vEsfUQMZ1FbVhTci68m9fICsAQ+h+Ag/dji0nquxTNkJDH5mXYhm/IP4f9tOLIQ9Jl4UkmkCeKaINzfrraCYNCHKSmsCGse34x3wWu6tmuDtO8vxtrBN9Qfsy6oAF67cK5U/x30A9aXdAZGru4DJOhqC6R0IhdxMYQN/BP40XzYIQXHkSYDO/1B7wboIP36vpxTVIA8RePRLzo98dTUmjXqckOVXAg7wRNiMtA94VJTDZ84+sYnTNRNk00dcgXOBzckAlBuTmgF3Z9H0Li//pjx9BhvMebT0KRwh+usxoTAR280p+mPuhI+ckQ3rqfCDFtqow==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(71200400001)(6486002)(86362001)(36756003)(83380400001)(2616005)(38100700002)(38070700005)(53546011)(33656002)(122000001)(6512007)(6506007)(26005)(186003)(2906002)(76116006)(66476007)(66556008)(4326008)(91956017)(66946007)(6916009)(64756008)(54906003)(66446008)(8936002)(8676002)(7416002)(5660300002)(41300700001)(478600001)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?p7PXwYXO3xgvacYfKcliss4872KxcnANt9sLn4C4PorOZe+j1FZH4ukeSCXD?=
 =?us-ascii?Q?FibMzwj+qMIk1geQcV0P/9JVbKNks0xQy2/1C+M8zkclpruDfxqb6+Emw7Ae?=
 =?us-ascii?Q?lANBnrYYz/6hl98DZU5AsohR7a4lFZSSYFNTnlV6tP/uzm1rvriIJt+Bpo+J?=
 =?us-ascii?Q?QG4Mw2kqcUD1uZWv/wz05kGCxWGhHyuhRa/rI4wChCtkbPt9L1Ff2VqqGjXT?=
 =?us-ascii?Q?vCYO6GwNkqhJLTBvMhT69wOii9J9gdhiNLfFynB2U+j5EP7mLZaofaVSIVqG?=
 =?us-ascii?Q?OveaSox0z3f2TvJ71/1kPl78LSB0X/HXrjl36oTEnklo2QoHgm+lvJ+Q6LMH?=
 =?us-ascii?Q?r+hXo0ErQk2ADVq+RF9IUH8gSw9SHcXxCs1WZI66QFUA6O8F81fWiXX6JFRh?=
 =?us-ascii?Q?oSCqNQ9L2kfTHt+xeFRHJGcq+bGm+0JyoHhFUmof6Nym+ZbGLaghcToX54ZR?=
 =?us-ascii?Q?kJsr4UBb62ZYuMhzNIE0huY2+7gXdvtMRIkZk4OKXhK0JvunAXCzLC6DjmqG?=
 =?us-ascii?Q?uyiRtEWhU7yaMPnTkIhtqpI+sFSM8udHRPeTvFgx/O0L3c1HvF2WBJ3iv99N?=
 =?us-ascii?Q?hVpBcV/h2oiAVOlRN5jBIh6HAOVr5LL5cX7pPHuzLQpIoZn8y7WvEXzenUzC?=
 =?us-ascii?Q?Nt2dKR4mbeyxWDg+DTWezRsMjWFd2mnghTQ5pgSqtX51gG5kuJLPRRzXI44D?=
 =?us-ascii?Q?6SgmdpHOmUybCd6UqYISzWZbOC+G7dgi8Rcx0WfZUkx9SO4FFN4opIs7MkMb?=
 =?us-ascii?Q?zUwTgMvmiFG5dSEvwEyFEVkOqglzQVHxasgo4OJj1jvcoUo2O9OawLS85cWA?=
 =?us-ascii?Q?Bldlwtcdgm8SByFCi5PKbDdvdIMVjpYY+CmTCB8H8TmxXFJ17otHtXjXtQbP?=
 =?us-ascii?Q?q3YMX2gmugC+lIOkXCop8gY4d3Qa4ik5zz5hzAF8UHHhw19PHI3fOG4ck3On?=
 =?us-ascii?Q?REHzB4SKYtEHTKQ7quNjcGR8jqPG2j5rotTG9Ok1oQMom+5p/5OJ/RO8hb30?=
 =?us-ascii?Q?OfvBKk68vWYMcdKC/bi+/DwarVbGmY3cDXbPFl8QsTKu+nJXRgSNrZzA+bPj?=
 =?us-ascii?Q?7shZdjkL7s94Hzs3kmoH2u/BcCuak23M2rnwWqM5W+Tpu+YGsNZwDeMsPQUH?=
 =?us-ascii?Q?TgOhxxAOD2lFt70UR/Lsb5J8YzY/FHicFQFTp5Z5QTkpxKfuw3IWm/MsJVVE?=
 =?us-ascii?Q?gHe0HfAFROBomF4d9Ia82did38EKlvb+ff/A6c94i41O8r+D/vPh3tFM+uxy?=
 =?us-ascii?Q?uSOC0LHKlTmq97tT6z+Yppy4HvcF2iH0jOtZkg76sF0RXgWl3M+E4jkI9e9j?=
 =?us-ascii?Q?teHDBGcQXiX/z8oc+wcSpfRBeJtVFLsqOmjEAmeBgkL77aNNrp8SlEzQFi4X?=
 =?us-ascii?Q?rhg8LTlo5TRtbn9DJiZal7iQr0iX4m6Au814jz0s/fQeae9S74rulgt6UC1j?=
 =?us-ascii?Q?iKt6WQBQE2rpQaaV9KHPqmyeOJPwLNp3A7Qm1FRR8CSzOCvpgizao1cRLRWq?=
 =?us-ascii?Q?iDmX/evkOIfTFZl3f0RgZV86j2tlfvhUHwasQN0KIPVtRUm4crYJ2Lzs0vnA?=
 =?us-ascii?Q?zFVhWwjx68a4jqGBdJgVgGYgc30019j9w467bzGMxtJugiJ6tp0I/8wRIoX2?=
 =?us-ascii?Q?cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <880204913DA4D34CAA59953D230D9B51@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?h/bt3CCPAvRnykY4PL7+vuAxgZYlKJzFhZNvDAbWuEBbisprKv+tS/QuSf2G?=
 =?us-ascii?Q?06A4qniqMw6rV3gyWkBqpaccua/gRG9hgEZh6iOA9ml408TbcxpAQKPchfSn?=
 =?us-ascii?Q?ot93686ca+x4jtJCCBJ8u3ZutmuUUDPl6iHHweLhyfJpBYW4WhbiMlxgKA0e?=
 =?us-ascii?Q?aADqm6nQDtgaNWMYzIkCts1aGjBKfpSwZwaOD0ioAqMVLWEKvl9C8v1wQURj?=
 =?us-ascii?Q?C5AHc7Q0obPtaTBiETAveC/HLYCUy+Db6yrSw7jWECttmkXdZc0C6KUVVR6b?=
 =?us-ascii?Q?Ev48uNhtUOZ8YmW6XlE28ri+K+btrNcJqYpCTcNhLcIACQYMG+lgbEmIAMSe?=
 =?us-ascii?Q?6glogpB01XT6zONnOg3JDL4Ezm8BUcUoeoVRnwAq3A1ElM/jzH4UweQlrV+k?=
 =?us-ascii?Q?4lsmX4hmsxkd/jT9jt9lZNLGT8LbiNvXRNfOA0Noe0yRHNcgiKn5uE63Z5d4?=
 =?us-ascii?Q?mLuYVeh8QqpccJnswp+wrB56I1omLY4iDFZKWyRsDFMy3AOogW9u8sgKbrB2?=
 =?us-ascii?Q?uOnKvisAIP69z2MCZTlhNa9GuoZG38uVX2WscbNx3huDJjgyX8fTrBkjm8iU?=
 =?us-ascii?Q?60ws0xuETQZ0B6YE7pJx7vWhbRFIFz1gG5amyyYMcwtGEIa27q33AtQfkjJc?=
 =?us-ascii?Q?IUECDrC1FEhpYT5cdcoKgvUZUSqSCxpO9OLzvfY07qZfsqoPyYIWACPeUxJ2?=
 =?us-ascii?Q?OO/m4oaL4fzpxVLYpRJjnBpGIY1lZwxdPBeyV2gQsAoMKEWa+8JUQ0sWDxG9?=
 =?us-ascii?Q?OpOSPH2Qa32jIa2iixWlQu8cn5ijo+Zby0tUIqMzaYMpUHCItHo7JFVcvWbp?=
 =?us-ascii?Q?q8UlIhEAAGTkjBzQj0NdOWbPFpZA1oAf/IoG0aAaaKbbqISgeAe1lCFPitT3?=
 =?us-ascii?Q?ccRBcmgKVnT1KFCCDKnab7dXtaJFu7zVSTeDlaFOHJYDfuX5MHMtZ3rjlG3M?=
 =?us-ascii?Q?7DXKS9afPdkCSc7M4tL8OxcKh7wTXGetf5mU/6U+PMpOuR/RtDIp6dMKy4t8?=
 =?us-ascii?Q?aqKt7BBcN42JBfrOWom1SjA0g2NUZKeV6IBh+uDqude5d6SHmJCf/bl9LASg?=
 =?us-ascii?Q?MZQitWxp5O/AAqmF9C+5ZE/zh4vGhA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511f3ccb-94b6-4603-d555-08db62c02e07
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:49:34.8147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +okbV9ThH9o8GoZHCyrlohoX6fGLGM6s3bwOKjRcAXDG/Ff7qgOphbOskSx974AuoqAjZkTeRJTF+cBNFyhrMqds3mgmHFBy8PXi9MkdNpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010146
X-Proofpoint-GUID: rflO_LeNT7BWZZD8Km_SBFXm6tEVh8ew
X-Proofpoint-ORIG-GUID: rflO_LeNT7BWZZD8Km_SBFXm6tEVh8ew
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 9:43 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 1 Jun 2023 16:34:08 +0000 Anjali Kulkarni wrote:
>>> The code may have security implications, I really don't feel like I can
>>> be the sole reviewer. There's a bunch of experts working at Oracle,
>>> maybe you could get one of them to put their name on it? I can apply
>>> the patches, I just want to be sure I'm not the _only_ reviewer. =20
>>=20
>> Thanks so much for your response. There is someone at Oracle who
>> looked at this some time ago and is familiar enough with this to
>> review the code - but he is not a kernel committer - he sends
>> occasional patches upstream which get committed - would it be ok if
>> he reviewed it along with you and then you could commit it? If you
>> know of someone from Oracle who could also potentially review it,
>> please let me know.=20
>=20
> I meant someone seasoned. IMHO one of the benefits of employing
> upstream experts for corporation like Oracle should be that you
> can lean on them for reviews:
>=20
> $ git log --format=3D'%ae' --author=3D'Oracle' --since=3D'2 years ago' | =
sort | uniq -c | sort -rn
>    811 willy@infradead.org
>    312 rmk+kernel@armlinux.org.uk
>     91 Liam.Howlett@Oracle.com
>     60 vishal.moola@gmail.com
>=20
> $ git log --format=3D'%ae' --author=3D'@oracle.com' --since=3D'2 years ag=
o' | sort | uniq -c | sort -rn | head -10
>    451 chuck.lever@oracle.com
>    154 michael.christie@oracle.com
>    118 nick.alcock@oracle.com
>     71 martin.petersen@oracle.com
>     59 mike.kravetz@oracle.com
>     58 sidhartha.kumar@oracle.com
>     55 liam.howlett@oracle.com
>     53 anand.jain@oracle.com
>     32 dai.ngo@oracle.com
>     32 allison.henderson@oracle.com

Thanks, let me check.
Anjali


