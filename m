Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E64842B9D9
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhJMIHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:07:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23502 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232769AbhJMIHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 04:07:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D6ubWP023311;
        Wed, 13 Oct 2021 08:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=IIfHdu0DWGDNtQTIU9C8GXqEcUKKfuRnaG3Es7T3p7A=;
 b=c+QL5ZxEzKyqBzaeIaal96qi3BfE3jSjSB+iBpZazeeyGaW28zfPR7lLBOL2Toxymsz9
 /vT8NoT+DwICA611jNe9CGfRIV0AefF+AJiQB/WVzgr47H3ygNY+3+/2kSvvKlcyO3lH
 3gS5mSxpaEscnks2g51s+aLQR8ShQStRNSzwSsemsJgmiHcF+wlF3eQgdDD9W5Fyjf4B
 Yj0GB++W2mPOjcD4PE4Z2SkMMQjZr6KvBV90lzJBTqPV2gTlIcx0Xo3DxNJo92kZIVqG
 8EJagOvzBTuU5gB3WrdPfoWKxYgW8MefV5iKXvfE8N4KUBLexpSAdEjPSgAzap+fGics 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbj27ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:05:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D858Ls062032;
        Wed, 13 Oct 2021 08:05:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 3bkyvabu6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLqeMe9rBog+DlVDetfSMzscp2lSMTUEjg1RONK0U2pz8cgjiJ5BeAbo/GQuju0Yu55FVk9flwIYScMgT5rtHrVJXfrnDGyRste7B/eEggqvacEFG89PnQGz6VXV3H2oSHqJ7BgYRduqcc4hDPNwTjc/29ovDS9i2IooMznAxjMCthjA9GvoA4NQVVHKxtMgdt5zwOvwL8puQL46y30IxIJZHijHQEUdNttog16ztKs7J/oiUCkTeqBfzixbG+JEYBHVpdDKgO2e4muiGlb0bEdMubfao2zivRn44FI3XiZbAoyuoRXYUvoC9z01ZH0xTLu6UWCVXqyHFmXi/ooc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIfHdu0DWGDNtQTIU9C8GXqEcUKKfuRnaG3Es7T3p7A=;
 b=kVTsDKErE/EDg4aK9oRqs3suCGuSFqWRrSTKexCRUNzi/g1AQRmcoePFL/L2zvDa4m9qeBWrHAA7GGxGKrctILQ2wGPYkPFJQzfZqSQrpFFwfSde6n6YOF0TrkmOv7TenWgemqknxKdO2BnpTGSpehAuFHv0qxGxk+yBU2zmVEwIYBjpQ5jz9CZAGLbe3zt2Tkba7GcNrN9sIlBoo2aq7oJnuFMNJR8zDP7ULhQ7ucm7vnKYiVYDB35Tmcdfp28TLFO61vzAkns74GGNwcfWMjPoEMyfDd2MupLdRzwFS+CcFrbEzEbp34isXW4bddMJ7ygfgMP8ctYto+ld/nyCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIfHdu0DWGDNtQTIU9C8GXqEcUKKfuRnaG3Es7T3p7A=;
 b=o+MEulTmZxZjhO+bnfPd2WG6iPn3UnDzyiLphbxcz+40i81TRuzEYsxjjQmyh+52FtFcipUJdo5iyG5nh04hbND4iEf+7mfCouZTMsIddA47WbLns8dA7MVksZn8IVyiZy7rwXpeVup049wQ6P9JtmhHGhqFbLcHth1zPteykrw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 08:05:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 08:05:06 +0000
Date:   Wed, 13 Oct 2021 11:04:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: enetc: fix check for allocation failure
Message-ID: <20211013080456.GC6010@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Wed, 13 Oct 2021 08:05:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0950e20-1623-4601-c409-08d98e202b10
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4754DEBAC7EE96A239AC55928EB79@CO1PR10MB4754.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSPi6e6Gwyjdfm9oK9yCgIWkrEkiSVYkkTk1pRmKDQx7UsUtzkISEcjDhN5sFKzDdJCBDmR6xbEfNskrHEvRsQD+aJ3ZUdaW3XzBYlm0ntftPP7i8bW08iAgdgKvH3FFISzPUMVNzNaxkyH2np1DnE1lU4Z/mqLe1vBRMfAdOWypEpe5thgCcqxeDzswHgoIgolRWRchDKpktsi8jj7Gwr9QuAKfnWaHwOP7Cv4DhTDeNXvDImfUmABGYmfG3cnCTQt0l9RpmOyVipXCwTccmxIhzoNilRQQ7Jk13D49v8E3kHrQ41SgeqITmEtH0dDJUhLODJAr+BjJ9et2if8fIwR4K8Ts4bquIJMQKe0VQScakXKQ5T/1sqgmKSlSj9VAbM9nPGn5dDQsWjiuOe83vroFOjdlSGv9j4WcgmdjzYktp/13HMpT27+BbUL7Hd2Np4tKN2nRVlLwY8LGqe4BVbGqHMc01pDw3zPPAiF9jJZ6Tfd9Sa0VdtcRMfT4heMtxJrKG+yxs/ncf8YdTMTENpZukfdFbA48Hd7Crbfq2d6BXaOrQXf4+CFP9lrzcwLtykaYsX0RzunKWtZckvOR8fP30GQydrOQlmySZi1fK3JY7flb2xW1LxRygP8n2zVheRrrM+O4FmD4kKF9r+2pqMNI9wlepIyzEKVamJd8t4nqU4QukbGY3lGrINi54bj1ApH4+n+Qw2EWM3prmdVjSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(66556008)(66946007)(186003)(316002)(4326008)(52116002)(9686003)(38350700002)(66476007)(9576002)(86362001)(38100700002)(6666004)(8936002)(44832011)(956004)(110136005)(55016002)(5660300002)(508600001)(33656002)(33716001)(26005)(4744005)(6496006)(54906003)(1076003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Q72/NLhDPwoK40DqM4kHrf8rZfqnpr0V2zRA3W1IBSlMpsfeAHEuF0mpJ8b?=
 =?us-ascii?Q?CkpokkHR1KX2p657Z574Fumn0QrKAjb2D2E4Qo/ZWYjsRbT4wHFrR4jbPFFr?=
 =?us-ascii?Q?P+VqwnODCzgAE0fW+JISefu/bdCrwqfgvGqLUpXNOBgHTt2vyVb/w1FNLSVW?=
 =?us-ascii?Q?cJEoRPzEpAM9FDRC3gl5Es1+dqKnrC5x+gRyyeo/U5SnupyudG3lh5a4wFKq?=
 =?us-ascii?Q?4P+kaA7WthFimL5l8ATwr2WhS7HaHcffoYqKvJC4VL7coIj+EEdCvz+ReO2T?=
 =?us-ascii?Q?EueR86AU+BTzTt8qXWC9ka8WPy9HLQkFUfUg3Y4fncjwfLF3j2g0JUyPB6rl?=
 =?us-ascii?Q?91581ZGrV1+mpbm7APWsiGiBPFXtadlVD7Hj2V7b0uet6X9EYM3IFPx7WXE4?=
 =?us-ascii?Q?h7teiihNjw/wBBp/21TRCP1uOw6SRXP2CTV9/xaTjtN8bc+c6o14BSM5+SUt?=
 =?us-ascii?Q?g9JBZyL252PKFgv61XD4Pj93fJwGteuuIQFojaJnAUTcoD82bAsz25rauklY?=
 =?us-ascii?Q?K0t09Wl/aNMDUx1ukZ7qnGRIiP7ZJV/WZHYgL4n6v4vEEUZdoH4upzEwV6Si?=
 =?us-ascii?Q?GSVDb1kL+E9kBLXKKJ/DDBoTTpvZIdN17vv5BIw+w0NxVwX2jlB3gIaTzt7+?=
 =?us-ascii?Q?ZcmhHiKGEMLPDNKd4Ofi5oAvkRKYkw5CcTydQMeZEVzyBTzYgOva4DcNmBh/?=
 =?us-ascii?Q?c2fsEoIe/MPsN8UcDOjhn84Eh/mZI/ALo9wQeNRXZXctXSiPz9N0pTj8dfTY?=
 =?us-ascii?Q?n2GW2F+u1A4sSPHUuZSIW2IUIMSGAVry7B0oSVv8btBueuHfOT5PpyYvKDDn?=
 =?us-ascii?Q?tTesebGJuwtTWCHRTnuAbGyHGtoh0CUhP4jL+OnS+tQ/H21UEupvYmo56Jbb?=
 =?us-ascii?Q?clOqwERJXcgn3235z1x/xZ5aEkJmg02WDrdUOrgElnAjZpVFys3Waum6dDtI?=
 =?us-ascii?Q?Y3ppXvxxWpz+eaQvTwOHkZPSXEUK0Zj1qJW3ZcGZq9eOLeFHYk+Cu1bV6cdV?=
 =?us-ascii?Q?LvE2bEJI8N7qZrWxUaDhc/Br9yVvEnxKgw2ozfAi84X/dBF/0bctSLorHRgU?=
 =?us-ascii?Q?S+v0RqaYJWPaoABsC6zrcISmZKAC7CkqoBjY1ZY32x9g2Ux+CTY2mKJKde/d?=
 =?us-ascii?Q?X7uAkRd+IjpIkZMlLbRM5dKlRUQxeEslGQMW9v+3hYcwg9EfERFkDttrAumO?=
 =?us-ascii?Q?/bKFvgJo7JLwmBC3JVT0Ex8Wc+R/17KIwXMi+WcPYowArm8BOh3AN869rAVD?=
 =?us-ascii?Q?e2xM2kupjKh7B2pm5/qks3qOZwPmQZRf/mrPFFhWTP3uqtfIahmg7Jv3Fg5T?=
 =?us-ascii?Q?ZSfRQrwkYT/LjQ6yscmloojC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0950e20-1623-4601-c409-08d98e202b10
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 08:05:06.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWwIFIwXY1co4pDqeW7BMLFIXMLzy81NK8MnPLE5KUqDF+Ificj9dZg0/glGcG1Q2QejRkxCFxEL/NEAQaUUqLcX3NwKJbaBs/KuVPAsiQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4754
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130054
X-Proofpoint-ORIG-GUID: B1ratbnNGmRsuHBNXhUtItaRoTFgKsVL
X-Proofpoint-GUID: B1ratbnNGmRsuHBNXhUtItaRoTFgKsVL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was supposed to be a check for if dma_alloc_coherent() failed
but it has a copy and paste bug so it will not work.

Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 09193b478ab3..beecb1a1276e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1766,8 +1766,10 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 					      txr->bd_count * TSO_HEADER_SIZE,
 					      &txr->tso_headers_dma,
 					      GFP_KERNEL);
-	if (err)
+	if (!txr->tso_headers) {
+		err = -ENOMEM;
 		goto err_alloc_tso;
+	}
 
 	txr->next_to_clean = 0;
 	txr->next_to_use = 0;
-- 
2.20.1

