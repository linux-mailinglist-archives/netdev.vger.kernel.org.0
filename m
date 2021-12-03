Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B58467326
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 09:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356924AbhLCISa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:18:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3988 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238936AbhLCIS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:18:29 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B384ljO026887;
        Fri, 3 Dec 2021 08:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Ril83m5H5eW+/SxClO3hLdGJkJqECMC7+PCVVmhYC4s=;
 b=Yk4ZsE1zoKIO25rJIk47LIQDIu8HEF72ITMdavxmgog7JGZdyqsl8x5d6Cce4u9XIQ1n
 IzkibDM1rGbASxNoYyXhw19YJF97lX++dI8bB047jM1fqhosra6xMtZunLpVlEcXNLiG
 aHCgLr4va3U2IN2B4AUs5FP4PL07sjJynCfa/umbHkaXk2YWZGpRyqYkOLQi815+Ynbm
 CIl0mUJYS+6Gk6QWD9/phMwg7sPNwTBy6I2BVSc+ZwaCAthoGEhH8N2XxK5ag5w3WKo8
 5UWPS36SrvHcjxqfkhcSVqJvHCQKqGivbgWVJlNk/0eFb0XhNjjeh5LKDe7MpPDPQ83b vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp7wexeew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 08:14:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B385m0E014919;
        Fri, 3 Dec 2021 08:14:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3ckaqkxbua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 08:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cl+5gaoW52R3DlhiN92y8y3+zZ499PtGmvt851lHPZec/CUEkyEAQKBU1QQJZa1NpS+J9IqKqXL2YJO+7IcBBla3OjXW2s7izdVAk0UuiJvbMZxZk4t6wxva3UF+xp6VNrGr+sGUFHm8eA0jkj9+8y5ukV+cAr1qiTZ0qyzchxR6QdmwA1Xj9qfp84fCST5jzcqucdl9aDreR+cPeNRaSDYotf7JPQ9GlSLgfayr/BEFydLYV43HMLyZsm9H2Q3bviLIuTfGWGDbuS9mxJHqJ5qiaaT45QLtyuF9rsZWupjEVUegoLluPsEGB0WVZOgdR9UznpyrVmC834Zj/hCY4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ril83m5H5eW+/SxClO3hLdGJkJqECMC7+PCVVmhYC4s=;
 b=Opz/siJCA4uFmulOhDfwOWCY35gR+W3GdyJMapAuwdEdi8M+9wRuf+rH5/ARZ5F5dQ2EY98ItkLdJlb3CifYqC+6JdMm9ot4SqmTezKXYW+mfxt+duV5SGhXOa07f3f0sBj99LXEfSMHoErZYrt6FwuXyKtxUGtFQIcylEDeARFDQz/wiTrXvbobUrlUugUo4CMU4yADSTU83s7mSe0IRRyvNCcfopOQ1iLFZgrjElgKubvyi0sIQUwAH2jPr/icY5sIE6g0s/QDssuPAQ0lZONLmep1Oh3eUBP5OSt3HvvErzHt3ZmXTDeVhyMqMfE2Vfj+ibd4VcU+X41fGaOMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ril83m5H5eW+/SxClO3hLdGJkJqECMC7+PCVVmhYC4s=;
 b=Lv3oAsMEm6QhRd3rdARkoPPO2ffw0E72Mf8UicixHR90qB7tWoM2LadYS8xnWnUlkwynfrxYcEiCvHZvUu0VND8MVmXPLIF5+AHZHBuaW2qNgRH1C6TTu8JS8pL4YWuwwfv2WS4o+QmAwVjMeLjOO3aBBmmaaC8ZgS79VR2LaXs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2256.namprd10.prod.outlook.com
 (2603:10b6:301:31::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Fri, 3 Dec
 2021 08:14:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.027; Fri, 3 Dec 2021
 08:14:20 +0000
Date:   Fri, 3 Dec 2021 11:14:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Adam Kandur <rndd@tuta.io>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] QLGE: qlge_main: Fix style
Message-ID: <20211203081401.GF9522@kadam>
References: <MpqQpIa--F-2@tuta.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MpqQpIa--F-2@tuta.io>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Fri, 3 Dec 2021 08:14:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af824ae2-bf11-42e0-a9f5-08d9b634e882
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2256:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22562E18EBCD0F23E73040518E6A9@MWHPR1001MB2256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ZuyEggkyZdBh71e+eY6Wl/wzCZh+oWZ4xKM1zWYGZdNez+upRxC1k4koIK+0/OCJR7WYNhk6p5GkxUmdiMKbh2XeyilVN3mNcJca3GzM8opVpt6LHtnk2aRItFKeRJfTRp/1LA17USg7XtXxj9RLyW7JFLn0WjLOv/hV0/mcbFXttN8xK9ow8XKkFjJfM899rz82JLPVZkuTgh8FinyCIMXwyYki2GlClDG5RiKOHvTTUyUjTO+x0igEGLdq3hpMi7qvp3OGza0I2jvkrX3Ot0lAfZ3eWVxJ0+GkyrHm3bWFHxUujJVF7n9c/qcZ5PBINFFKsM25+TkE0J7A4Bl6+ZYaDUG3BGDn759ZkXvrcuI2gBxRvfo7GDZGaGODpCPyhZ3L8nmq+abllEOpQP+A2m+OTmtxDR4/Oq4BAYva/i+IYOuDtGOSK/dMKzJnvMJEsV75cD8Iqm5BO/BceVB8xPkeGVTYqzq4W6rX1GexzzLEspDDOvbvmvSfrvArB65h2vOtO/US+eFq1TMCuUK4W2YdE739J4UAjbQg7ZX9nwXPYpoTcjBmJ6wofiHULbiU5lVrVmi9kzs2R61bCg3EYhDxq7E55GLyXABTrFckQKy9jwvmB82Yg0J86gGm2XbB5yfPlFQInLyaKFQ+NKPFRVz+V9j/EZRhSw/eCrWY7/p79xa/WMZjDcm9LZIrmeQhjJJTFtS4SebHmTkQ87VqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(6666004)(1076003)(26005)(6916009)(55016003)(8676002)(4326008)(66476007)(38100700002)(956004)(316002)(5660300002)(186003)(38350700002)(86362001)(66556008)(66946007)(9686003)(33716001)(558084003)(8936002)(52116002)(9576002)(6496006)(44832011)(508600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8y5YhWk5/0wltr/Jz/6520m1ChPd2cOiagZimIGe0qo7K+niZV80vwdHLHut?=
 =?us-ascii?Q?NaRV0tzuRNOYWDnNnDtQKmruCddqfGbJMFitTopTn94aQgcGPCrRQmZuLPEV?=
 =?us-ascii?Q?b4XcUhY0AKYvZ3tZNCh4bnpSbRWJhxgf0/CLR176Zv+2qyVJG3OCxLcD3nRn?=
 =?us-ascii?Q?0Y+8Q5icUwIHkjSjAndQyxpb8reoLXFW+xhjGjt9WHNoAFZyFriSQPatV2Uf?=
 =?us-ascii?Q?jc8UpXk9bJtaZhFn9if6r0D2GDqtgshKRKhqPpJifkZi5FPWwvcfLLulorQ6?=
 =?us-ascii?Q?XUINoDjcpOfp3H/wU6PU7iB8BnJI6nCRBlUxrQSM0GT797TVcv9cYXmOItFt?=
 =?us-ascii?Q?TeceFG3PAlQzekYaOOzyy2l7UeacmYD9mb7HgDyv3uVMJXge7xT8QE8SWXqW?=
 =?us-ascii?Q?lRQKRcZ2hhYKXU/T9fzaGp7ZFlftCRlmMIqiwE10d+C58mCU7J1ouYnBprNu?=
 =?us-ascii?Q?FnYFflg9m/W7A7F9xRJQ/vHEGD4XMBb5KF3JWMRG1dscnE1GkT003tt1oknn?=
 =?us-ascii?Q?rriFex05ELS3PJENk5PMT5ubhrNt0P9UVdukPUp4F1D2gdsOWr/X/tPvNgLd?=
 =?us-ascii?Q?xL54T2pm+FsdsY8/Pk76BJa4hUw9I2l7eaibr3N8dFtcjpmwIag24+Lsap/Y?=
 =?us-ascii?Q?+qACVqP0FLYsANvmCBbDQOStVqAPuVFqp8IG68/ALZVeTHmhbANXAx3Q/JcG?=
 =?us-ascii?Q?b5kEJF75TRNoIbNBHDQ6lFwIdGpDwEQSCG2XfKKRjbUekilrTCvIhsEKWc0r?=
 =?us-ascii?Q?C0zwKph1smTxDl8Nj5opmyTOCUy2+aDDOPt78qRLAhKNY443aZgrKOWxYRPw?=
 =?us-ascii?Q?9aKcHWnr//D0KRwfm2jYTMsqqDKjNUEw9VuO+A3+tzRDW/3qKSuE4HzLoqDQ?=
 =?us-ascii?Q?6lQ2KYrcjVKKknQWvQ16/D89zvy17w1vg4oFyPjYjfIGohJiqjQkv6pXmiZF?=
 =?us-ascii?Q?CYBOq5SVtJ9qbu+Q8rQzFuvz3r22Uah/GUTc+uEUtGNEtywvPvomsl9i1pcu?=
 =?us-ascii?Q?4OJClcGzjG3lG8bC+o1kAvzsbHmB1zdex+OGz1PkazStawqn/7ajXSVQt/Wi?=
 =?us-ascii?Q?1iU0scD6aMCNttkzqeTBZ/D5ypkTFj3zzhnWeHoiTe20uFl47lT3MOXg2DuF?=
 =?us-ascii?Q?WrQdKBXmXEG9q5oyxTyU+V+OrpvP7iGRfqHo7/wCnFMjZsUQM9sT58rGK7WO?=
 =?us-ascii?Q?5XBKvJnmyN91K7PBgbnRHNa4yvpntedfNUvsyMIFJKiETNqGmX38tdZTqpzO?=
 =?us-ascii?Q?ACMu3wLoU28f7A+LLMiDfE0KLLv+F3H7DlTrfltoRZe5yKjgZTMDOyTrELlB?=
 =?us-ascii?Q?0AbWDBRdj3NxUOVTxThIxbXW0YgRaZ8s5maPFJdJRWqXuzH1sXZyop9VSGPY?=
 =?us-ascii?Q?SVoLvEKsqSJJDD8Mo21dqk5d/AzYLOfz8abmg6mzUb6ErKWnBoAP+vZAsZ+f?=
 =?us-ascii?Q?3pPLECl+JcJDdhopmqluGlN/nUG6Iwu9KNzhIYaN0MvmdjkJPuWU146H2emp?=
 =?us-ascii?Q?ZbT+thzyWPSLs53QzyEQMWNxuCaIbK8tsufaDWOMMh0xuJhhbRzBHAn64QBc?=
 =?us-ascii?Q?d1v/UV1BZLTR5ZH+NVsFL8BlZ3r8MW0Tmuaf9lipIX/iUrnh/oh1tvOboase?=
 =?us-ascii?Q?lHf7Xu3NXZ1KAQHbEdyVH/e8BRWIr8czLGtm1ws/cw8HJRGytwoAlVdNpgju?=
 =?us-ascii?Q?R03zwQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af824ae2-bf11-42e0-a9f5-08d9b634e882
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 08:14:20.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zL66lG20B0KwfYW7gjW+WWjPdmaADYFBNbm8Oz1o07pA+4qykhJndlk8d2/NTuHGolJAKAz9ZdVzgrbIIO4iOoiES1U4dv1Xrke/9MPRL5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2256
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=693 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030050
X-Proofpoint-ORIG-GUID: TtzaYMd2FXYJinyT2oONFFY5TxEB5V58
X-Proofpoint-GUID: TtzaYMd2FXYJinyT2oONFFY5TxEB5V58
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 03:39:08PM +0100, Adam Kandur wrote:
> 
> 

The original style was better.  Multi-line indents get curly braces for
readability even though they're not required by the C standard.

regards,
dan carpenter
