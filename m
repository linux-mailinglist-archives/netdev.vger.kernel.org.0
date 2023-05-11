Return-Path: <netdev+bounces-1896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBA36FF6BE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E8C71C20FC5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C77A4695;
	Thu, 11 May 2023 16:04:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C864656
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:04:58 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EE0559E;
	Thu, 11 May 2023 09:04:56 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34BDwhBL027647;
	Thu, 11 May 2023 16:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=oclf5U2fbDqRPMGAN2WFnMfLQWAlfX8BEQGeiabnnsg=;
 b=Hj5/OYe4tXJkpu6ZGFz2jV9N4BvgDnIwX9LaJMA4siUcWORablkR+oDGMK8GIsu+/aDa
 JPpPkqLtHzjohbE7cCdqgisOCoxTerrzkp1x/c9BIghq2z+bQyhV+Mgwe8R9rpqBvYwb
 rNxghgVWgKdh1NwIYCOSZfTb0ovp8AhP71eXCrclQGcy00Ahimu7dU9EMtr6YjlXWwlo
 2nZbhqu9VBzbPDBHBJN1sdRYI3nAXh7md4lV7hd7d0IjnF71jQJyksdb/fEFqRbB2wik
 QwMVm0HHLqBxeVkBoZ4oxvbT9ztr+3O/QMKLP87aC3P/xH7ZUqooj+ZofEvd6GZCD7VT 2g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7777kbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 May 2023 16:04:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34BEvKrw004678;
	Thu, 11 May 2023 16:04:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qf7pm77kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 May 2023 16:04:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvivyRdH20IBb69AyNT2NeCVYd18zUL4b886Lb8z+RJRO1e5bn7jicPRquhscUUTSAAEnk2SPgbgx0CpW9dpMrlCHnR8sxKth/eAv8E7hdpstHQjBJDko7n+tPT99YiqD3xmnj4PMpJYOXjR5SjwHYEJoU9Efc7eNnFhAYhA7g/9MVPdf0izgKHRkJdSpD6bUWcgntf27aER0yZoN3cyBIvqGExpfAO4YG3Sc5WcbD8IlLPWGp4qPRNyY6kMcJjPxaNdZofwmYc4tMB48DOYR8vSvjGddtDv/ESLR8YFxh+wKE74uZEpl+RC7iNtzElSIXlfYGB41ZuxKcaBgne+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oclf5U2fbDqRPMGAN2WFnMfLQWAlfX8BEQGeiabnnsg=;
 b=C32WwpGQyMiCuPbbBLtr8S2T429VGyFJGOtx8O+fvlOrw8mpB3LjTUNv06J05LS0LWkAzdr/liFY4Com78G/OuCYTxxf+L3SvLHij8lrHB3Ukt+/5Tix+S9n/hEtn1MNFyr+9alZTuZIP1g+PejXHB+a4TdRXtkTZ9F2S7pzBUfh2TxaW7YS/3gSNX9vYufRLrujLA6AdhNFAXo6f2pKXEfAfPaow1anYa71hZFUS8+JRKCy+XLi3j6Ib12zKbhdQwVFIH7xEng9XOIi10TmG8UP6ByDo4GntIbKx4p6IX87uhmfJFZPGhbUEGFYf5USMj5R/sq91dzSJlagkcm4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oclf5U2fbDqRPMGAN2WFnMfLQWAlfX8BEQGeiabnnsg=;
 b=F0SJokRfQ6zi4m19FJjDnt3GEY4m2uSO0ekY9R8bk1ZBJJFZ3VQ+6rE74m4TkQEZDs+5hz8nsxR7sVbhGFhfTV/vRy1KrP+B18zTLabNQbGHx//rw25p8MmhcV/LBhorXJzcQbncmmQyuZiLPbnBtRQ+owRjLkGr6lf8h0q7sRg=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH0PR10MB5896.namprd10.prod.outlook.com (2603:10b6:510:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 16:04:29 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19%7]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 16:04:29 +0000
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
 AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAJFpdAIABHiYAgBXwRAA=
Date: Thu, 11 May 2023 16:04:29 +0000
Message-ID: <472D6877-F434-4537-A075-FE1AE0ED078A@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
 <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
 <20230403135008.7f492aeb@kernel.org>
 <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
 <20230427100304.1807bcde@kernel.org>
In-Reply-To: <20230427100304.1807bcde@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH0PR10MB5896:EE_
x-ms-office365-filtering-correlation-id: 0335bd04-66d9-4f95-fde9-08db523966b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 3VR/dSfeGqfqxKAgjeeOxITK2DSaMkR/SRIuuMZ/pnWSzOBo0fTJE3xJMJRv0EbhV0ye2IKJwJADWoIoUQ/5PcpHUe5f+IYWcyUNVskLbzb7670titP9JdFHK2go0pyXBGb3wNQVIB9pzGcuIA3NZ7klmUuMkv7exFQlgcCJkXsiJe7ALPzZUO3w44Ce4izDscccxXmaiNAhxsu9YpbRLu9pDf9VcU1sorKHRbCfmxwItuRPbH5fMdqy1vOTwHoXkIpn+AksT3c5cQj0rB4o0vN621+GU7TIkNPS9EYIf9s0LTtZLN8Zsfnsqt48p86XuE/Y4YBNMpqZnjmZPzRhTycNcc1tcTeyowP0ns3Zu/e7XohjT1+63aI1b6Rh3BfkUNfa8gDQm4ktFK64ylOQ0+pXj3ETXZQIM9uzN7LAcyk5ScB99IcYUSJiqY0qF/ITIMKpgMvwp55HRxZrIwn1ujYrNUw2algoWlv5vU2Ij8p2EAqyBM+wsBOKEKYQ6OYAeNx+eOJlDMSCmVKiBOuxF3gA73+jfSu1NNYko+R0AZgSaJIYMZPGXPtGmGK2iyGw+VgUnmIw0Xs/ZFZkM59aNHEtXWs8QF6WklhDMmIU8lTWuh3ZoAmzOrFVFcykM0XqpYk66Ws3FB9OGQpyYDARtQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199021)(5660300002)(7416002)(6486002)(122000001)(36756003)(2616005)(2906002)(38100700002)(41300700001)(8676002)(4744005)(8936002)(86362001)(64756008)(53546011)(66476007)(6506007)(6512007)(38070700005)(6916009)(4326008)(71200400001)(316002)(186003)(33656002)(478600001)(66556008)(76116006)(66446008)(66946007)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?hyt+VA3ex3JvDwcVVQ1hykmAHr4FX1P+Wi2/t8yloZl4hHo/Rre77Jcc5ZyK?=
 =?us-ascii?Q?Tx1wQahMs4teGLEE49LXELzWFshqDINEG0E+qM6jV6r3sZf5/t5xC4ASeQ6F?=
 =?us-ascii?Q?2RkbDqmePWGzrIQPPD5JZD34eJvE48pRS/t9e1uHAk1tL0e7aH9tJ9BCk3CY?=
 =?us-ascii?Q?jeYY82MEBd+T1a7DfakGzXSdRIwm/laNGhJslFkQJedIrZJzfUY0o3iYYweD?=
 =?us-ascii?Q?6L8NamakrQmII26soJ7cGIpfIAGhSk1oN4HOpybmRy0i5pQe2ZZ0XgKkjvkC?=
 =?us-ascii?Q?6gwi5omicffSlEjIAuRcZZ7M9oZFQAjKG+Ooiv42JvZpGlhMAFB+AKGs9F+0?=
 =?us-ascii?Q?qWrwRUs/pRMqPcTyBcQyNEkF/Bl0ti98UECnU3uHweaSn/TMleuyR2dkARaS?=
 =?us-ascii?Q?y4QIDXC7WpYnBauWddJ6vujnjhSjzLGMegjNCdWa+QGPDDReGcZQjyDD8d0D?=
 =?us-ascii?Q?MRqaz/gjNysYEF4T8xen07r58vDD3HM7IN/vfLZoZ0teU+NE60dnSuRzhiYv?=
 =?us-ascii?Q?BRWIff+6ViKFzrQUu9rH9RWMTCNmgGt7YgDx/PLMLsrNYpsAj9ETlm4ACJ3m?=
 =?us-ascii?Q?VwtlfVXV28aaGrEalZqabTtB539iBxx2RTCF2QX1s78OraB1amp3NWicM6Ca?=
 =?us-ascii?Q?FH3kSACKYnqZC4E7yFbsvcWyJfhaS4gP9ScbrBjoCP+jej562nFWBDiMkwqe?=
 =?us-ascii?Q?FmzmYbanLaJsu0xGnmiOBgu3HkQOkTgJbnhl3LwlcnOBfUbvoYCggnJnATdQ?=
 =?us-ascii?Q?BMLmXMGTA4G5AARFZ4MU/JkIvMqaRkEG19Y29rYNckj8hIxTw/9tDmE9cvyW?=
 =?us-ascii?Q?O1Pyx65hcnKx6t1zS0CNxgaBCeE3Z1ggR0ee5bsdbdfIfIpSEypGVINwecP3?=
 =?us-ascii?Q?wvYqWG28w6JP7bJF3DR0rJbQDiYKu8qeVVNP4ZLV0rf4OFgyi5Ea7VYUPu0l?=
 =?us-ascii?Q?hU/YJFj741dHSycBn3vVSC+8IoU1m01e2gbR1OXpJ3Rsq/tGua1QTcvJJDE7?=
 =?us-ascii?Q?KIbg2QGVKqmZxJd7uL0ivVHZzW14QqBP90qS0AYgx7K4FDDvr90vdNooDbpD?=
 =?us-ascii?Q?hV1AcelZbH85oobIQ6a1t4qqmD8NyyuVlQT+J5hwHwdnBEUNZ3dNFmMEIX8q?=
 =?us-ascii?Q?arW/bSas0NeTAZz5NTUqcyuLiTQdEWeync0mldMk1xn3keVdS8cqZLTfKffi?=
 =?us-ascii?Q?hnRngWQI1CEpN1qrR/IlKVD14f7SXMQ7xBi9xbXrrLal4FZY28TMUJVRXcGk?=
 =?us-ascii?Q?BufUg/dCebwH+mglyJIyP/0AXCc3oRi1hImPw5JK1nnyHtyPt2Mb79hucvLX?=
 =?us-ascii?Q?gsKvTDMV+LTJkiyrzsNppOIYVD0Ht30NdJglJ7lBzk6zoRiyTdKhiYFOSbla?=
 =?us-ascii?Q?BDwMrpWoiG2BK0J/febawTrKRL12aq2j8IEl/hbNmhGukpdWtzXdEY6EIg60?=
 =?us-ascii?Q?U6fBq4b46qslQF276b5ExCiqUgw00jOEHrqQxSuBNbAPjrFuE6UweoFB045p?=
 =?us-ascii?Q?w+dAZDX1i9uBCVlbuebvlREa+eSH8NOmsmsWaeelUeRkKyyMYYMkrmGoZ1UH?=
 =?us-ascii?Q?gIyZmOHrXt18iQFhnPoN807GPK0Vk5Kt7Fyv0xVf2qGVdeIz3+R6Nw1loAGI?=
 =?us-ascii?Q?iNppvafU3crZxHTXT76iLWdAsn5XI/koQLiJHKl6d3/ue4I/ujmq+RrvY3kZ?=
 =?us-ascii?Q?jKT2i2/1OLv/beJ/MPwllAJMRGA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1BA2829F5D8B6C49BDB21E69DE4AEE3A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?TtudZrgyvUv54+NHDBnKfzQGzaULFa8yHTCqSYPn+B85WlKddAUehPde9t0c?=
 =?us-ascii?Q?dKSqzoLidHOpmngF2Hb40VCbwvZ8K5OP+KylV/AQQWyEPQAtne/jpK+wl5YS?=
 =?us-ascii?Q?O39v1vpNZpKSif1hI7ky4MK0fkjWM58gX8/iqa+0ndNxalufaT7Alx6CZHOq?=
 =?us-ascii?Q?19+ipGugyswh46Yzms4Wbx23O+e63x/0v2NgWffFYnPL35XNXOfXTi7Ba1To?=
 =?us-ascii?Q?PDhYvgmBZfWuzlzFBPOCVGGCRgqNjfe/b5Es9OC6EGPJFLRwgZQKg3VtUajY?=
 =?us-ascii?Q?ECMH0aR/npxIrxueLOlTZk3KJ45ZnTACniD6hL+yjU/jK+4dD+tYwb8eFSUU?=
 =?us-ascii?Q?ku56v+qdYrsnqA4qra2hj6xM46HgjI8oFYAiGf++Qe5+EpD/162XRMWpyydF?=
 =?us-ascii?Q?7m4Od1o9wOjQQ9C/Vl+t5yOhRu7/7zd1q7GXMJwgGGklBz4X4GkljdJEMz5T?=
 =?us-ascii?Q?gMrRYJkrSTF83uYeDt9Q1VjvO1zLlr4Cphm3Vhk9YCp8q9IM7pEByvFLFiBf?=
 =?us-ascii?Q?RsoX6i25tdZa6YhUeAJPsD3nyPsB5BtvCeFA8ssGPhqzb08fg8fMx3/RgPHJ?=
 =?us-ascii?Q?EkLaUguOtzU05AU4QRfGuwOXnCbpjuYrz4wD4nAfhnHeKQJaev4h+6G38akd?=
 =?us-ascii?Q?gD+e7E2K3ZIyiO9TGz/wAuG2g5wmeVyhZ6aDf4j7G7qVyrhKqPvUbnpWrQ1+?=
 =?us-ascii?Q?jos2i+S6akPoPlW6o5pSDO5EQC8IGpMTvESW4IZqVFpvCSFndYrcM7Lh/B3Y?=
 =?us-ascii?Q?2GwtUrPhtKDfjj97h80aL6J4t2HS0xKtrN8uTQPFTdoGus4b57BI3KZuw2dR?=
 =?us-ascii?Q?AAOuBbp8+A+lC4TTp6T4pVI1gX5k4AFqy9m1l0NGx8l30zhUStvycbLGXb48?=
 =?us-ascii?Q?jagNRXrKwa+V2Z7U/8KTYMxcK5IfvUG4uaiEH69aj9I1s4i6pa/g7TbBeKNt?=
 =?us-ascii?Q?EMC2i2PtkxE8qxBU7hclsi6Q/mt81EDDtYF94A55NfM2DGOVCe5sTvD6c75g?=
 =?us-ascii?Q?yeQCh3r+s5DOH+RR6hBc4cnzDWlj7H1XlzsTxFrvLrm47sXfSuDClfyn6NET?=
 =?us-ascii?Q?xDj3dttnhgqpfKh05Eed5pwuiGLH7Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0335bd04-66d9-4f95-fde9-08db523966b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 16:04:29.2217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0MgE75EKwyTqeoiz51y2t4DPo1pgnBC28gRigUh6qUb3bFx9wUw9TO6oIWgqY4Me72dn6lj/SRYelnC3fjy4ksFxTEBHRFm5ggpcxVJvhMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5896
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-11_13,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305110139
X-Proofpoint-GUID: 4_LypqmEH_e9idxwSSNnoQpFkSAd8Vav
X-Proofpoint-ORIG-GUID: 4_LypqmEH_e9idxwSSNnoQpFkSAd8Vav
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Apr 27, 2023, at 10:03 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Wed, 26 Apr 2023 23:58:55 +0000 Anjali Kulkarni wrote:
>> Jakub, could you please look into reviewing patches 3,4 & 5 as well?
>> Patch 4 is just test code. Patch 3 is fixing bug fixes in current
>> code so should be good to have - also it is not too connector
>> specific. I can explain patch 5 in more detail if needed.
>=20
> I don't have sufficient knowledge to review that code, sorry :(

Is there anyone who can please help review this code?=20
Christian, could you please help take a look?
Thanks
Anjali


