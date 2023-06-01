Return-Path: <netdev+bounces-7224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E337971F1AA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6910C1C210EA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766E848258;
	Thu,  1 Jun 2023 18:21:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6389E47017
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:21:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA671A6;
	Thu,  1 Jun 2023 11:21:35 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4Tn4021265;
	Thu, 1 Jun 2023 18:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=R2+hiT1yeKXnoM79wf8wC0gWqH3kN8MatvGXWoxAd3A=;
 b=l1xRrxQ9+VZgxLXdkKl7n0IHlx67uJozLWErNBB06an1EeEKypCCg0E2958UzF/HP/AY
 IwpjWc8jsZHiPzchaOo3LQ0SF37NZOjrnxVCjdPN1kMSS+oM4Tjh1CQAR2GvlFws2RHU
 czapXUNPx0ydSK0JOhOvDNXGMjP3R90igxlA7EB3NUkgaliiZNSzZz0wFTV8/Z+z0y+m
 BgaM0SlW1YoRcE9ELPsk9RC5Skw5vcATdRteMT9Dw69OlBxYe5SiGZKw10Y/gBq65rI4
 dTCCulRtTkUi9fVa8RwUvjzEDmsfuTA/wAJ9dmc2Aa61yQJpBI3BCP1sWIm1UP2MnLfJ XA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb99e6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:21:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351GtHgA000357;
	Thu, 1 Jun 2023 18:21:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8qc3j9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4cLXJAdI/iUmTS/9F8//kvBecfghUnYN4KWGtvSF+B9vx6xUUGjckXRSl67Eu/hTj8Vk/t7CbT2h6BfKD+Y91fd2Ljv6JAUI5LJ7bRThUnVe5iJdtMcPI3/bLCjQQcTzOXSv2v9ByKDWNbizOuLpFEGTx9g5MnjE470EmcBxUm98j2NBQrpNSTDJugFNynwqZ4WvuGRZpA2q7OIyz/oMc4gj8oVKxswdc8xKmwBlAB2AyNcTbpz1Fj9TThMsnloxL/SwkiymuFQKer77A640GjBxbZKkCgYusn1UKMY5TmYOuhFxyt3ehr0d2fMJua9F58B1xsKXdOmXpDR9xj+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2+hiT1yeKXnoM79wf8wC0gWqH3kN8MatvGXWoxAd3A=;
 b=AwTAePVwx1oddBph2XSLz8bTz1X0mtA9JhCE9yjCMQ4CZXC14D5SSPv2bRFkpWnKXkITJ/FcpJhLkziK0kQ2O9yieFnK6YiHGnoaGgPxSKDsd9g7UGiS8jbcm/WsSEKydyo/lFRIJtNUPAn/rWY1U8rrOho5iqn5qOh4uIheOZdyVbl0U8fEO6+kA1FytxvySeKMmacLYjGYYesQN+zuRq9kVaBc0NXzttfmBO+naaxRGYXYuk48BU/uGM24as8fcE899CBOFBV2YK7uMbG7sWJfYKRm9suAkrXe9pLmxj4XUIuCCjDoP8QsDLZkcfQa1W4g+lkB+Qkab0TnYch0nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2+hiT1yeKXnoM79wf8wC0gWqH3kN8MatvGXWoxAd3A=;
 b=yJYmh87IwovG1hF67hagkIid31GY7A1QvkWiAxWGu8yu+DshnSK8v3UGaOfkVKyDeO6ogoOEPFYTwaFqec2+ITeQgGy+lTxpQOS4rWUyL3X8Qlc0UK6JbqOIKNOvK5S3mG+b/evvcjNXLxOxsO47B09DfubaiYZ+osmS7vJGgRs=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB7107.namprd10.prod.outlook.com (2603:10b6:510:27a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 18:20:58 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d%7]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 18:20:58 +0000
Date: Thu, 1 Jun 2023 14:20:55 -0400
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 6/6] connector/cn_proc: Allow non-root users access
Message-ID: <20230601182055.xkcxmz5x5rc6fxzj@revolver>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-7-anjali.k.kulkarni@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420202709.3207243-7-anjali.k.kulkarni@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0031.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b62411-c30d-4fd4-3fec-08db62ccf297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	quDsiAH5sMdmVfcKgJUMKPVpZuBLZvCuLL3MoqFbcgQ/HkQSVSdpdD2XripsM676JlDAeDn/rFjZ0UlULBgfeT+tZ/SJl24QH6Rla7CNaQEDiDvuRcBxO6v3+4e6wE+YCcKgUS51d091N/6/jZznUp+ks3dtJkIwUmNCJYEYUAyngf+sjAVhn6VE+CS+oKGOeEY6pvzSH0FJ0Kh/L7H39qiuy3kMKHWzFqg6lnyy1iWD6IaqfgZnklcA1TtlSy4fQCEl44HdAKJl+98AT432Q5hWwhrXyBr4dL2oGicfXGLJkLd5rRDZ+mgQQFGUYhuYJfisYiRnvEhqAvCmHXCoj23H4rueo11qQOq9CGT1AeVJmb1VO1dkqslkGvQDXmK8O/ul+54Y3ILbvWGEmDGPdtOadu+BkkRkVExE3pF4F/Op4wp5vt1ISwiJy0QimL++nw3YM43TLB7XjXXavK9pzcmn3+RonmY2Us4HqEaHmn66WVIahqBaY4YQ+E6VFTWL3znFfZu4reR11Uw0lOH8o9C45+N1HDVVVMxu1J9d4kc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199021)(966005)(6512007)(38100700002)(2906002)(478600001)(66556008)(66476007)(66946007)(6636002)(4326008)(316002)(9686003)(26005)(186003)(7416002)(6666004)(33716001)(1076003)(6486002)(83380400001)(41300700001)(5660300002)(6862004)(8676002)(6506007)(8936002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?G7k7gX6KxIXneUsyJVTw/4vNusHYRTXSolhy+SMycLKacxNw7zELPe+RmL+6?=
 =?us-ascii?Q?erf+1K9C6IW411LpTfK4CajN6MYG4jha8dIo32/mA4ZX32KV67QMODncWYGe?=
 =?us-ascii?Q?cYL9vWDyE0m5pMuak/05Suls2XW1TuWthFcPyjZ7lAHNMyPIUKsuG6p4ReFx?=
 =?us-ascii?Q?tvBHxRghfhvBmDRfN0Rb2iVRRi2dCz0EdB8uUDkuVYARlHvTvYd5KrgMinAS?=
 =?us-ascii?Q?GKPhi3C3xFtM6PlOsOZ0BVnnEiQkZKZnX+gfyzHAFGSbRURhCyLLOQ5exx3k?=
 =?us-ascii?Q?N3YHq+fXl9SukTlktmzJkFRECZIdRb2PsDFFAv66/BNj+Rc+0pBIpT61QhfT?=
 =?us-ascii?Q?fIC5TvEveY3Bc1q83EEMRzt1zDNeZsE5VfxQKY1UAizme1tZ/K1OZj+CxPn+?=
 =?us-ascii?Q?GPRsoP3fW0lvNT7T0ZgXe9Cqp/+yhCsulbthB3oLPdTBqgJndLxjP+CHWpM+?=
 =?us-ascii?Q?wFLi+qxld+vBMFzsZ5wt0KqeNlfWWgwbhpqv0g8VazfQYYNT2zQDNXr96WdV?=
 =?us-ascii?Q?eTL25NJ6G4N3gi8WQyXpHHrZ+VtDXQqLvTfZF1w7s2+ms1+lshbPtkY+wNqj?=
 =?us-ascii?Q?Y8w7qLKavM/+a7pUd7GupkRT2M17yxQp8Em/4TSO50u4RNKSkxooX/kamwWU?=
 =?us-ascii?Q?5prZvvzCXfgJkVhW4WkPJ6JhcrtH6pWk5x7UJoRbSfhhtrpElM247ywVo3qP?=
 =?us-ascii?Q?dZM9JKy0jyx4KYCnkGn4L03t6N/aap/w84o4e+FpcTrom1A1fmIJ7cIRN8NZ?=
 =?us-ascii?Q?drcoVuEeJfDqBTGAgGpxS/IOHZm9ydnQagVdBO14zldRL5I+qTzed+KnOYjh?=
 =?us-ascii?Q?Z9ISXdhY99Qp57piDupUGdpQenwgpFETGBE4RoMh9xZuC77VROxW3lo10lqo?=
 =?us-ascii?Q?3EhllRblquhzr6v0WoTU6UaS7pNCxXzTWb+RgpvLM9exSoOc25HFn0yUyIoP?=
 =?us-ascii?Q?I5yFMcnVMcv+E4hxtDsyefZeqeaN1TLsbNQib9bjvSHi2OlJOfWaMyERu27R?=
 =?us-ascii?Q?Jtzn4Q9L0ylJsemNuLtDPD2nmGPpnr9jashDqQMQI5/2Aou5es2A+FxZ7dvn?=
 =?us-ascii?Q?RXSoZXCZYlXhEH0Oh3948Yz7IrXRffmTajhiRoCJ5q6IAt79BdFUIpV5+sat?=
 =?us-ascii?Q?lp22f5+JzmFG+UlOU3rJRz+sCTiSE/X+t9PDxYvJHWTqrc1v1C3bLqtcFoJy?=
 =?us-ascii?Q?rV+O0/2sfSRaY0DPIpvLfg33brgqng/Cmirr78mFxr+XRgX+SQoMfEvnyVMx?=
 =?us-ascii?Q?U76Km3FmMfaXHF4FXYg9piSnXKHn/T7qKVAfkFlVOMxXGrKJobGBEc4q44vl?=
 =?us-ascii?Q?QtOyjLh6j8e9C6XCTIA/b4NJLO2jSuI8L7RV4ZUYiAaaJ1AiVNdMuTIpVX+Y?=
 =?us-ascii?Q?gg7cQt0Jj8eg01l5EsKgFRw/2i9imG49Kbwb3Kay7NVkgoXC9SGdEiP1cKap?=
 =?us-ascii?Q?74JAgXZ2Kr0b/ezNSr3gBAMfznqCUzBgs78ARu/VTIqQoQvecnl2lKqNeRye?=
 =?us-ascii?Q?bcJP5iPah+34egmEzYb0HiQwcXzpW8JXmv+FORUS/g9PbYlaJrzBHtWptF+U?=
 =?us-ascii?Q?MTrYLeaHQLTyB04PTR+8ZiDMY6hoKM15YbVRsOXoPcmuvQGbWAWgtayNazvO?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?8ZTU0SBzN3yKRw9Kjfa7YRvqdh1n79L4d12TLBM1fGOPgAzeXzPOk38pO8ge?=
 =?us-ascii?Q?IfWPTGcpjrkCwkHIHBTewtUw7sihW6h2g/Jq3gpx6Crl5tCUBcST+c55QBNJ?=
 =?us-ascii?Q?JEq5wJAkW3HUcdNfGau7zQu5cXK/Z/6BpH6Dmf2iwLcFb3VmW502sGLfA7mx?=
 =?us-ascii?Q?JdfEE7QikQpcZKfRITTYog6/WWkEKTL78jiGyCygM5Sim9Gn/xycU4Jer77R?=
 =?us-ascii?Q?rc+qaCUbPl4UX15ooFlZuSMjLtyiJj6adzOBid1wvWER5/lUtyIdHdx/FUH2?=
 =?us-ascii?Q?rE2CR2lJn+Dk394EfpCM7mcauhEZc9kklwb1cR3C8dKglLZi24Bnv8B4ofWr?=
 =?us-ascii?Q?xY6scl7YMPMpe4X+XBC92oCO+EL88NyUCHzURpujp0Uo/ZH1PWwFM/+b10Ic?=
 =?us-ascii?Q?3L9WQKHg+zcUSrD+WFvKu8ItyA9gkl6c+ZB3jKRGN1+4h3yAf+DRm71NhSDX?=
 =?us-ascii?Q?6NBaX1IdhV3e/Ost/D6ZzwssYAGQQbbGo2H1ymO4Ut/xzur5ssMZmq7UQdBt?=
 =?us-ascii?Q?1eGhuVly6wKAFdCtBb66I1do4cCqdLFimOTAy+ibG/ZmU4yyTwysW2q/3CQf?=
 =?us-ascii?Q?KOkanGcAbURgMAUByyrRlcKRt3OrlpyzHZ2Ms9rT+fcc3sd7Fl66X7U3jg8C?=
 =?us-ascii?Q?vVb5uZdZuCHl341gJv/e8bq8O/bemTdmX/I7kD9nq/hw0Wd4Ys6p6AHFEPar?=
 =?us-ascii?Q?ltH/7Wx31jtvWia2yX5/UGWeV4Ko/TJP4w7qfOzkWw6Iy0SfCjO/w726Nen9?=
 =?us-ascii?Q?zz8La2icbg7+8IGeKKvAtZc2hfKCTqEegeKQ7SmCZ4Txqblcifif0AACStxz?=
 =?us-ascii?Q?m+r6VATQNZeMT0cpuNi4fgZBKytsZwrecxOAGJrfJFOEXPeukILCA2ZjtGYr?=
 =?us-ascii?Q?r3KO6DCeLgw945ATqCiscVb4f92L200eiI8bl8cbH8Iu020Ez4DQFGK1V+Qz?=
 =?us-ascii?Q?Q+45gyrDeik9ji3pQx3bOhrPOZawy9YvwwClDBG+racfe2FYu1p3bgYwH2VU?=
 =?us-ascii?Q?DRDc5ZTPr8NA8C1RMdOjW8RJBK3abcCFl77MpFr9neei1Vf77cBzwA4rJ1ZL?=
 =?us-ascii?Q?230jNrbZq+OLwsnALtP1zeTmaSRomy/qIF9IL0inObLvfhpP0fo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b62411-c30d-4fd4-3fec-08db62ccf297
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 18:20:58.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5KuIBrcRpHTrIAW0XDU8MYwD/ClF8LbUUtgLGZT4MBbngP1J8tol947cIn29AGoTEmYh56ZoetgwvC2uQKlyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010158
X-Proofpoint-GUID: 2u6PJyJ5oHDLEOVEnkJISyD7YCRqCr1_
X-Proofpoint-ORIG-GUID: 2u6PJyJ5oHDLEOVEnkJISyD7YCRqCr1_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
> There were a couple of reasons for not allowing non-root users access
> initially  - one is there was some point no proper receive buffer
> management in place for netlink multicast. But that should be long
> fixed. See link below for more context.
> 
> Second is that some of the messages may contain data that is root only. But
> this should be handled with a finer granularity, which is being done at the
> protocol layer.  The only problematic protocols are nf_queue and the
> firewall netlink. Hence, this restriction for non-root access was relaxed
> for NETLINK_ROUTE initially:
> https://lore.kernel.org/all/20020612013101.A22399@wotan.suse.de/
> 
> This restriction has also been removed for following protocols:
> NETLINK_KOBJECT_UEVENT, NETLINK_AUDIT, NETLINK_SOCK_DIAG,
> NETLINK_GENERIC, NETLINK_SELINUX.
> 
> Since process connector messages are not sensitive (process fork, exit
> notifications etc.), and anyone can read /proc data, we can allow non-root
> access here. However, since process event notification is not the only
> consumer of NETLINK_CONNECTOR, we can make this change even more
> fine grained than the protocol level, by checking for multicast group
> within the protocol.
> 
> Allow non-root access for NETLINK_CONNECTOR via NL_CFG_F_NONROOT_RECV
> but add new bind function cn_bind(), which allows non-root access only
> for CN_IDX_PROC multicast group.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
> ---
>  drivers/connector/cn_proc.c   |  7 -------
>  drivers/connector/connector.c | 14 ++++++++++++++
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index 35bec1fd7ee0..046a8c1d8577 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -408,12 +408,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  	    !task_is_in_init_pid_ns(current))
>  		return;
>  
> -	/* Can only change if privileged. */
> -	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
> -		err = EPERM;
> -		goto out;
> -	}
> -
>  	if (msg->len == sizeof(*pinput)) {
>  		pinput = (struct proc_input *)msg->data;
>  		mc_op = pinput->mcast_op;
> @@ -460,7 +454,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  		break;
>  	}
>  
> -out:
>  	cn_proc_ack(err, msg->seq, msg->ack);
>  }
>  
> diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
> index d1179df2b0ba..193d3056de64 100644
> --- a/drivers/connector/connector.c
> +++ b/drivers/connector/connector.c
> @@ -166,6 +166,18 @@ static int cn_call_callback(struct sk_buff *skb)
>  	return err;
>  }
>  

Should there be a comment here about non-root access?

> +static int cn_bind(struct net *net, int group)
> +{
> +	unsigned long groups = 0;
> +	groups = (unsigned long) group;

I don't understand why you have this cast on a second line or why you
zero groups before the assignment?  It would all fit on one line.

> +
> +	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
> +		return 0;

New line here please

> +	if (test_bit(CN_IDX_PROC - 1, &groups))
> +		return 0;

New line here please

> +	return -EPERM;
> +}
> +
>  static void cn_release(struct sock *sk, unsigned long *groups)
>  {
>  	if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
> @@ -261,6 +273,8 @@ static int cn_init(void)
>  	struct netlink_kernel_cfg cfg = {
>  		.groups	= CN_NETLINK_USERS + 0xf,
>  		.input	= cn_rx_skb,
> +		.flags  = NL_CFG_F_NONROOT_RECV,
> +		.bind   = cn_bind,
>  		.release = cn_release,
>  	};
>  
> -- 
> 2.40.0
> 

