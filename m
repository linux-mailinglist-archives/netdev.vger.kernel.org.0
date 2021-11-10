Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECBA44BD9C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhKJJJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:09:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230468AbhKJJJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 04:09:28 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA8k6jd011843;
        Wed, 10 Nov 2021 09:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ppEKv56etnZKv/gOWMBiTFE6wPfN0ZJq+q9FAH4LgDE=;
 b=N4TWR6AbsY4khWNzn7MyinpygAZLAjepZQZ8xLZMVMOG3AKSig5EVM3ghSV6JbgfmPhA
 WMrfw3f5lgYhKqM/boPLFShVO3wlLmJcvBIhu9vJFxRxajTlS0nS1KA+OuqeG6r04Dlg
 qC3WBF2qklEIfiphogWHYkd8Fq7msoVQRH4oQPXxJjQ1+UIO36ndISEfV/m93AwmFxna
 yPAQsbcqOW2Op8mjn687COVMNjixOog5tAGCgVLIt9g8IPtkKE81r5GFiGQJ5SHGOwEz
 B+ddfYrRDq0TgYP6aK3hzIsrStCkzcttf0T1LijiLtzF/f2gkZcVZPKKPrQkSL4deoHv kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c89bq8jaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 09:06:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA8ohMM021362;
        Wed, 10 Nov 2021 09:06:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 3c63fubn7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 09:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1AEt+58/6aJeWbXp/ReT+oFz38NQWm3XD8scT6b+4poKEo9a8eF3f8tsPtfEiHoYNoKBCDYm4bwmbmTeRPNNitfR7GO7/0bVsp7/CaFgjn66LyN6MVqeUrHUBug0PZg4IV+szikF34wuhM6FEU/DQPJtWBUlYMtYyiMHKKV1jycVWVLMPNwzKIbcLYfJixysSWgbZM8xniIYu3ajVoYntSyvbMcf9FViL7uMXBuntj1Pk7VSqPDMMVXZih/3sym5vqZS0gguYIZhaJM4ULMfRFem3j6QcQSmY5dhNk/hXt+MBg2WZYs5XJkr+ZniWbnqNJNa/u01XZ4owpBJPmenQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppEKv56etnZKv/gOWMBiTFE6wPfN0ZJq+q9FAH4LgDE=;
 b=HYxZzQDjmj82gR7ZUlABCz0qvQpapI3qWdzikqGjU8+02UabQa8l1O3b0aTu3i00mLWtb4FkIAp3TO6m9IFLn1fSvgjlx/tQ5aBybcBQuw9i+5LHQPFi88gGFQYwipClLqvoRSzCFPr0afP06Z/92p3fmj8WZ570ox6emHjBkVIDyAQUXnVptNVfIen5ZHJ9LkTsa9mFnnQEVSB+acRiydRJhJjTAJrxE2gFagTdraFPH4MQngWMx2r3OrexpaUYCjbeTvDTUAF65XNfgHKuoG7c9br+wJpmArt0xdFYJz1LT5EPmbPk0LltCuBqt6hlllbkroadfZatMvIGsL9XYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppEKv56etnZKv/gOWMBiTFE6wPfN0ZJq+q9FAH4LgDE=;
 b=0NDjE7tharusjpzC+pBLSK9GY4qnlsu7XM/WWR9wSO7a0jT7/XdRpLEf2fF255kKErDryTz/bm/4f+NB8psfue0YTBb+gHbZy2yzcRQpZzus6VP7lhBz/XvlU7rGzJwgaNMFtr93nn8/f5H5GzUL+/b6D1uujl+wp8LtnE1Inxo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4691.namprd10.prod.outlook.com
 (2603:10b6:303:92::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 09:06:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 09:06:25 +0000
Date:   Wed, 10 Nov 2021 12:05:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jakub Pawlak <jakub.pawlak@intel.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
 iavf_watchdog_task()
Message-ID: <20211110090557.GL2001@kadam>
References: <20211110081350.GI5176@kili>
 <89022668-5c63-bf19-a768-6bef2a3be3b0@molgen.mpg.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89022668-5c63-bf19-a768-6bef2a3be3b0@molgen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::34)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 09:06:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d99e2ae-200e-4511-7e7d-08d9a4295f7e
X-MS-TrafficTypeDiagnostic: CO1PR10MB4691:
X-Microsoft-Antispam-PRVS: <CO1PR10MB469101C65DE488CB57AF5E158E939@CO1PR10MB4691.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:308;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EddzQQH4lW3b+1OFA7HOX7QZbJ7SHqINhFXyouge90loKF4sjhNjvEa3N4rWNjJeBk1YJaj2FzQQF7yP+7QYarMafqqiyvd340VDl/o30fp82MxholiOhAE+an9pC5EVGZsXyO2TeUIsV7i3gGoKD73TMLt+1B7uO3GAZAEimCHdJ2oexXfwOz7CH6Y4Hg1I+c98iXPUIQdkPYieX6Y/nWcsfdgBYanS+V1XBK9J2kwnWH+aEqxb7cu70f0RhwP5RjF42DwXpG1vEpfcyFBkzvqhAyWRfXruJFw8AgXS25isuuE+qMfH9RFCtwRdu+TyirBKJlJOAdbmxEWO2d549U4lkg7Ys+A6/vojT8Dxpx9Ht9U5mAAAklxKYXsqkDxShuWc+lu28BPqLakks8422zQiDVQYQeYkwXz3t1AyOe0SDEGpsSCSvZNQgO3YOc8WIZIxlzl2Cx+/f599fahJ8tOBKajPtJDKsbRYuppDKU1mavqZdpzOv+LeARyZXKACYjkAZ0w7bK+/Q1M3Uz+75ZWB0OeIRdouNtmRbqcAuWRQ2+gwmTjWvoBXFDPbLBTQdQfD9s1j/8i4d5KOAQzBaqVmI2wS8uM+jQprfF5MvJDEQWKlsHDtl0ME3uNwrdLYEjltPNpZPNG9a4hn/mvdvltTjYguOJG0nEBUf/8NAp0Dn5qf5u73+houaOWWKwUG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(1076003)(508600001)(52116002)(33656002)(83380400001)(33716001)(6916009)(6496006)(8936002)(4326008)(44832011)(4744005)(6666004)(9686003)(9576002)(8676002)(38100700002)(55016002)(38350700002)(2906002)(66556008)(66946007)(26005)(66476007)(54906003)(186003)(86362001)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXjaGGxckPcV0f9DXmUsRPvDnOXHkPuLUc0z0iEtKuLoAh/RqbMfoXNGyYzK?=
 =?us-ascii?Q?3nyJ493lfBpPjvOnfo73j4XisnINR8fcMvz5Z/ZgXzG9Y6cmYn/6/Xq9cOz1?=
 =?us-ascii?Q?W6sm7gvFnlBDc/WppluOLmKrTknDhx28HaVuJkWpEnkE6Lyx+8/em9kdc8s/?=
 =?us-ascii?Q?c5TasGh2DSv7o8W2F5BjOOXwwt6+s0nujf7fq25rCuTppGPD+3XJT+Rhiy3x?=
 =?us-ascii?Q?hMIDv5ozivWJsslx1Xv/igdK3oxJPhJPk4mfkzoq4LVkU0z1nOY4ABdyFheD?=
 =?us-ascii?Q?hEkoY6FHKtGtABqKt6UkY61t2T2OVs36vJ0AubDif+i+oJk5pPKxboonDey+?=
 =?us-ascii?Q?D596AzqP+42XDXPtmEVGXYs80FuAurz6RaWAsSi7AlXa3Fxbgy9Su4ZWTpCn?=
 =?us-ascii?Q?uC8XSPs8xb9N9eX75HXGkDMaeUXUMDfesR5f7vU73n15sD3Fur1ubnp1lyUX?=
 =?us-ascii?Q?2fhAmsWQhObQVUMwUG5KMPff949GtLjxToxx19bv05v9I4zo5da40YXEr+fp?=
 =?us-ascii?Q?0bSBA/4BYSF1aiMI0U9esO55BqgcUoTusE2rlCR89M75xD2GaqPnDwoxVI2H?=
 =?us-ascii?Q?2uNmxsjRyr/ZhbFefXt7A/iU0EZLkuBWPFRJhj1AQdxQvwrDmtYn1HMC36fu?=
 =?us-ascii?Q?gZEdJBcd9ZoVWAATxLdBcUaFg6CMgK5NV0dMctUFbxynTaSXvouuAGwyjc5s?=
 =?us-ascii?Q?mjShDIkzPKQk1J9dFvJ5XUK1aRaZeAT6d/7zrP/ehn6f3nuFNMbzCxdj3OMb?=
 =?us-ascii?Q?QsPRsjKkg0Lv4Jl1kytlg5lQs4k2WdsuPDus9CqW0Kp3rOiUmvMCHSjJBSLv?=
 =?us-ascii?Q?yCDz/7ewLwMqTrg//zBcBYoM9GehgdaICDpqoAJs0ydPNR+THc+NNG8KFr9o?=
 =?us-ascii?Q?ZswxM1Us4E//afjHYFgv8WkMJNUqqBVPoGkfUTrPit8z/vrQvhxT9Hc3tycN?=
 =?us-ascii?Q?CnZzx6ED9WtrJWgS90B81zCQqkUjjkzHkOY1HBp2HPWJN0Dj63mO8yZ8xt9V?=
 =?us-ascii?Q?tLfJR1i0jY1EaByhuaxXg80wUsrIyxFn6CKDpAjkv0sIu8AMpQ8qmOSei1ml?=
 =?us-ascii?Q?sq8N0Aa85JSEAq/xH5RO5/LjtOXv4Bb/LgYGfP1qh22bhFKZnnVuYYsaMfDB?=
 =?us-ascii?Q?E1bpZqYqJ4YP6FWDlzli/kq0Y5ExGJCGLEj3kCXMhSLa8c7LNGBh1nEO74IF?=
 =?us-ascii?Q?84sT7/P9aHascPTeKdISgSuXcPqSDpT179HqBoLagmBXk2+f3FU8xMYjEoQ1?=
 =?us-ascii?Q?u9d9zKXV73MRbHb/YHkC2C6BCY8yAy+QoCL+10w8FwujWiiIt3cN57ZY3duz?=
 =?us-ascii?Q?s9biTLGqWSB2PvFVo3bTU1nfD2KYbTk+NryzOKhU/jqs7TvCxTOLteTFES+Z?=
 =?us-ascii?Q?2gusT1MzsYN55KxPTZJ5PH9puAQqU5IIjHS/Fxn777zclXX3BEkcLMcDcZKy?=
 =?us-ascii?Q?ZYsnYUW+oXnjqmMb13s0XoNusYlB5HjZveUNqIQ28Q+GddhobxsMb0d02JcA?=
 =?us-ascii?Q?ClTXgyLtTYqc+NzDMdzkxAR/uUbdTzwpQuFetzvoJa4YCKnqwtz3ri7T2FZW?=
 =?us-ascii?Q?np5y5L3ocz2ht3864/PqVJ0sVUDjNOqYrGaMSuykeX1rzP9RbwZYro7cQ22v?=
 =?us-ascii?Q?rGzhg4q4wvH/7fqhzVusg4EeEa3Qw9VFXaAlO+FGG+ot/d9Y/ast7u4TMv5D?=
 =?us-ascii?Q?95TJuv9+BvgAf7aBNSTkJ4tWVeA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d99e2ae-200e-4511-7e7d-08d9a4295f7e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 09:06:25.4184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LemqLcF8halVnuqjMsRqCbKwCoQo2ee+KaUU6A3a7ksHlvCYasM2ZutDdOBf8yBj9cP7/XrAKdl/6jYwTcPgXjsUq2xDpcO08948s/rSEGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=942 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100048
X-Proofpoint-GUID: v468a5DyqFPLH8qxz7fGpk-REPCaKokg
X-Proofpoint-ORIG-GUID: v468a5DyqFPLH8qxz7fGpk-REPCaKokg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 09:53:50AM +0100, Paul Menzel wrote:
> Dear Dan,
> 
> 
> Thank you for your patch.
> 
> For the future, just a nit for the commit message summary. Could you make it
> a statement by adding a verb (in imperative mood) [1].
> 
> > iavf: Add missing unlocks in iavf_watchdog_task()
> 

Imperative shmeritave.

When subsystems get taken over by fussy bureaucrats then I only send
them bug reports instead of patches.

regards,
dan carpenter
