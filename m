Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0108B44BCA1
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhKJIOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:14:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22676 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhKJIOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:14:18 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA7A9nS027722;
        Wed, 10 Nov 2021 08:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=KzrtXaZ0354b/3Qdz7aaBzPgteaSOVHGjDgw/+ZG8Mk=;
 b=gFiZx7QDk3Kx/Fq0oJml1VSjICKtVAlGQMncjWxxOKPiLghBgzzbHMUTSCZlXutEPZCw
 3eIJ3kEXcytj2eo8/96NOPoFGmLkS4xF4tDSswXXeui6tpUQVqcnTzHEyn7u3FLwNQRF
 lGa6VVX2qPglMssJBfXQTtIKh+PmL3s/KMXM1n88WPkb8JCr4ag+6FAzcXfPZ3ezwFv6
 SIOqhYz3U7uNnctPaxZklBNy7uq8LdHLEMM9oPIXF2HYRnnNbyUsM5LcwUXXDw4Ixfcc
 axllbp5stRM/xm7l1c1Ym9Kayy5EPXnGKH24fPj6GTxePyOCrUvZ3f6jcr0SEK7e1N7L tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c880rrpye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:11:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA8A3xF157328;
        Wed, 10 Nov 2021 08:11:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3c5frf8qfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoLmXFXYXsCEFROqW029cnsf+LlenTBrO+a5KU2owhxaRWc5cqwa6oMmqdyrplxDcD6zzmwhMkIuHoKEZ1LmPzsdzbtqa5s7vd1pQBefkLZB+n6LSX+zglpU0QiBAZzbQeWvM/EJ6O4EKpnqEhAT5h3aU7KMDA8Cov74mHVGRioqtLbocWwsFmvg7lSc5WLvSlEq8rWQ4WC+3UefwjlnoB9/I3KWlqwDRemmTekWsgTOYT5IHKa/xkNztPFlx1TkAzdzzGt+yUFKU3ij+dZzdhX4YiMHluL9l4RiXOQcRlN4zsFW/m/BIoHwXvKdGhMb7KCbA1/P7YWs3Y6cb7QK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzrtXaZ0354b/3Qdz7aaBzPgteaSOVHGjDgw/+ZG8Mk=;
 b=Kx1rDsQFmeR7zLTzrYkvlqZ7Y/rAb3KeftwN3T7cBO8f6IzVD5RWVmVmTXkpMpLltNT5UrrgXAHd3AyGgC9FyIHEMWa8aC4ooJMkHcrv7fkWRUkvNKXJOGuo/560rRYWy1fCpB4aFP5urcoMD90GfvbRADu3jUuCUtcr1C1PQts3nSZDhCcvAUJiNsKkI9s5ND48iKEerOHIAPnUOxPXWXJGKnEB/4QA6zxUB1jcIifSf6ga/rCFsFvdJmORzzxig6ICyqcZ/5MLFWXpkeT+fFcmCdkpwYHRHWFLb3KHA3abQ/npKRWw0dElVxy5hpRP26Efacn7Md2pQDQzaiJRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzrtXaZ0354b/3Qdz7aaBzPgteaSOVHGjDgw/+ZG8Mk=;
 b=a9bzpzcklb2nRqNDoIy7yXVOBNQdajqKAg3Vfumm5rWD825RNUA4UC5iSgl8pHi8cjtKppEFjaXSDEXFApQRAVy5s5aILNTzaD47vbr6fUlZFhmXDYOx9SBaQUuzqAhJ8eXxphrFBFd+aPQ0/urSC6A1mVQFkAKYmlzMC6btCAw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1727.namprd10.prod.outlook.com
 (2603:10b6:301:8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 08:11:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 08:11:24 +0000
Date:   Wed, 10 Nov 2021 11:11:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeroen de Borst <jeroendb@google.com>,
        David Awogbemila <awogbemila@google.com>
Cc:     Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bailey Forrest <bcf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jordan Kim <jrkim@google.com>,
        Yangchun Fu <yangchun@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] gve: fix unmatched u64_stats_update_end()
Message-ID: <20211110081109.GG5176@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM6PR05CA0017.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::30) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AM6PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:20b:2e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 08:11:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1d0c0b6-437b-4d69-6f01-08d9a421afee
X-MS-TrafficTypeDiagnostic: MWHPR10MB1727:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17271F381ECEC14F8EB94D0A8E939@MWHPR10MB1727.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNGKP6Eg4UUTpXPT5incqfEd40jtzTanHeuCX0p6HKZGqdcLv9Exk7wz7OvaB1VRE+oje00jenIV//M2fRPqgAHqpOukssScWEVkZSdf87VOrOBh4+jDgTCzTSCoYcPro/zMUFAwONKcGb79pxEdyvNuL3ib6MkDZXRCkxU52c0WSykIdi7TbfYFzdOTSP4yxsFUvP6Xd2rQXdfVpzX0Jch4GHQWbSPiRphZPpWPar7kd6o0eyZe+Yy/Z6aax1CaVofUhlTyAx8bAQb/XPwSx+bd28INw2Xats9HQdZeWWfs1KtfAC+S5dMkdjf90iibx2flTUBRKdHecYhU0RfBddKX9ErlLPGz+yNDNwP3PotQFhdLPW5lttfYySzZ07tcdpRbbubjw0wHu6ve/NuKMugQwso2WQno+toqCfjbTCCg4vCYrgZOOg2wvsC3M3MEIreflo4/1QpstCW174yE3BaV576RMgwCXihLrW0Po+Btcpf9hiJHnya/7OfYFr6P+HqoAHw1PxWZqnyYOIpyzsMYDc1/ySymYUU96SZxe8vIMtsqC8uFK1qmbwJ8bre04B/ur4g0fI5DZ6rz36oVxoUPKkA83kXFG/fV3gZ7lkbwknzKMW8DoO1f0EuiH0nKCQ2fteYHjFpFA70KbzJ7pOq+wfEFkdP/qygO2Vp4xE4UoceM+CzCtHRSyoMw7rQ4nrfiRpR2dXs81sd91n3biw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8936002)(26005)(6496006)(66946007)(52116002)(5660300002)(66476007)(55016002)(8676002)(54906003)(9686003)(6666004)(1076003)(186003)(44832011)(33656002)(316002)(86362001)(38100700002)(110136005)(38350700002)(508600001)(956004)(4744005)(7416002)(4326008)(33716001)(2906002)(66556008)(9576002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uxv3eo77hAnEfcuat/kRc7uXt3+iX6ibxo+KgNuV1mns7br0P8gHJTgdasrE?=
 =?us-ascii?Q?Vzq6vw39jcD4jmOn1qsFDMuJacVv0kaicOkhNDnXk/GZAGArpzOHqcuTbQis?=
 =?us-ascii?Q?+kymQWYVNjbgB676yAJ/ihtNUFmRAH/tJPafBKmE1hBHOweraXTW4mlgIX6a?=
 =?us-ascii?Q?+WN6Z9vIAXOHgSQ22c6HtisNLZ7EtnuHpPaWb18Zcz2WglKklMULB2tIfYuf?=
 =?us-ascii?Q?RopFeYL1xt8MGmN5eQ6m0H+mzrrDJ2TDXtQwHgOcHIA6DoM/aerNrzkvGn8s?=
 =?us-ascii?Q?ENOHAz349ddEjxojvsOImE0jJFxpWZCYEz/E+teQG+BvfEGqGgFmiROvnCad?=
 =?us-ascii?Q?OmJTbaADm03MAJIhWNOGXJeyXuxMr8zzJCHR9DCj/cCxI/oUbweXm3EE53Ep?=
 =?us-ascii?Q?rTKFfH3RieYlMcPcZPicFSLOlSekO57OmAAnQ4hFH5AzV8x/F2Ij+0+egcgR?=
 =?us-ascii?Q?mIeQJowmC186l2rG95+Eayv1h+AB7A18PDRYvJT327Vzi31G+121hihCWxDc?=
 =?us-ascii?Q?xKeCg1rUFM4zbfbCh5+ISal65pOz9SdYSgtuuWob9cWNkMH59yOwPJd31TlV?=
 =?us-ascii?Q?K/owUtz4YdEYhA3cdklEgx5VHZjiWUa+d5qEm24kCqvJwrCpReUU6Rh/SKmu?=
 =?us-ascii?Q?I4Eeoatqp8YEo7kn9DTFXW62IjEmy+mzOahj+zlSZe1N9bvHWqqu1AYZ+uMU?=
 =?us-ascii?Q?itb5WWjdUCuj4xwYsHSA2CiptKorIFCst7PnULIkVrkn9Ko7dzkM4O/jGmfX?=
 =?us-ascii?Q?ocylVFPpz2KZOIJXQEc9HnTH9Iyc1phklNMxLoVMJHxBuu8nfOhkS27BQz33?=
 =?us-ascii?Q?NL/IgYn3b3wnkM0+Qx/XoJIOiCrLynEtiMeebNC47nurLU8XYl+w3TSiBg18?=
 =?us-ascii?Q?bj7Ds/FP0pB+0DJjMVFIgplaYPKMKooFmNwbllF+EzKIq7vLxkHKKgafDax+?=
 =?us-ascii?Q?qGzEvjVKNOTV6k81p7Mre2FuBKeaq86qF8ycxLq0NxwJ9I6Axtfd0q9X85ji?=
 =?us-ascii?Q?QVJlhiKxTFGsi/4tx+91IKcMSUuu3Pg3yH151Rzsfh7eIF+yu3ZK8qn7YQ7b?=
 =?us-ascii?Q?/sojMalFTRKuP9RmTiE4Kt069DEmyiSKtPtxNw1nfdWMdWhsn+DU4eeuby9+?=
 =?us-ascii?Q?XkaPnZU8mo3dYoGSoOYRtmdjmyx5PY3BtRKFNYP/Rlt6QC/nbzPq1wHme2Mg?=
 =?us-ascii?Q?DPMtxGqUTAyd2f4Lh1HtWxlujrTc7fH9m6kh8jaUpzKtyB9KRU5HgECsbfRj?=
 =?us-ascii?Q?Kjnk7z7sMPPpLAk3EXAgyjR/J4wrAt18sw212vC13NgkaAQywiSAORAlqxo1?=
 =?us-ascii?Q?TD8LjLeJJSb+XrHNvN23ek95os5JvmK6oADuLfbJ6dnf/UpLKiU7Owh7L91c?=
 =?us-ascii?Q?xo0joaLrqcH2EjvqDmb8Hmv28nXJytOdDGT0USSirc5T+d7Dh+eOUL0ip697?=
 =?us-ascii?Q?R6snQPvbI533jn+p/2skaWl2QSH9GmFxtkgYR/XZj7UZVV7XDI4mO9Qtpz2X?=
 =?us-ascii?Q?lsYjycRwrLH0Fx7cSq0aiTlwQDSZ5RSIq+7w93mne4n3YYr1q+WoofFAx0M7?=
 =?us-ascii?Q?OhKyUNBuj0v3F72t8zhDZtkDBFV6o/X9mTv14DR1abJ3z6v0ERTua97JWFXy?=
 =?us-ascii?Q?zzCFaIOvLtFF3w3puZgaZ+XpJ/MO5/CpjKBOEyYxVjFFPeNDKf9keAV8I0FI?=
 =?us-ascii?Q?MHhd+Q2BCWUdW0HlKxIpbS3CAjk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d0c0b6-437b-4d69-6f01-08d9a421afee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 08:11:24.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juFkoZlXj9/sSrJxg81R6OSMBM2pSDqAI+MTeVIg/4gCG+hxsd2UARMNVBFPaIcCMadI+fk8ryWBARsgbe9TJMAIckGww8JThCBnupkhpKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1727
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100044
X-Proofpoint-GUID: ArJ8NhDpXf8vQYgRIBM5dZ54j9y_rsWI
X-Proofpoint-ORIG-GUID: ArJ8NhDpXf8vQYgRIBM5dZ54j9y_rsWI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The u64_stats_update_end() call is supposed to be inside the curly
braces so it pairs with the u64_stats_update_begin().

Fixes: 37149e9374bf ("gve: Implement packet continuation for RX.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Based on the indenting.  Not tested.

 drivers/net/ethernet/google/gve/gve_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c8500babbd1d..3d04b5aff331 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -500,7 +500,8 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 			rx->rx_copied_pkt++;
 			rx->rx_frag_copy_cnt++;
 			rx->rx_copybreak_pkt++;
-		}	u64_stats_update_end(&rx->statss);
+			u64_stats_update_end(&rx->statss);
+		}
 	} else {
 		if (rx->data.raw_addressing) {
 			int recycle = gve_rx_can_recycle_buffer(page_info);
-- 
2.20.1

