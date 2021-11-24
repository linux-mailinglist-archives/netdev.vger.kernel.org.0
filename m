Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8931145B1FF
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbhKXCV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:21:29 -0500
Received: from mail-sgaapc01on2109.outbound.protection.outlook.com ([40.107.215.109]:24097
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234152AbhKXCV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 21:21:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsA4jwVCp+olCB8sFPgag37T+o7JSBbgwZ8TieNMg3ouW3zXsgl8mwCN6KLbcVLjswaPWFSpUQgYFFnqTpsJb54apzguQ+4EoS6BJrDMjkIA2sTGrggov0DCUwvJhdklOR5z8ljstIfBm7Rl7R68bGAmjv0/+1Z9XnXqXQgeGh5qazVdBnkWeAB4hEMpXOyfXRJaOcTnqjCaqGxWvzF4HUTXjBv5pRuq4fAD0aCiA/M4xQV1cmgnxpDJITuD5XHBOyv71QMip870KP+hkBQgi6t0+URvCfdYYOwM95wFLgRi/KbCULgjKjO8DnUIsPVHO10i+hdf2b/6fNNjHu80Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQmZqyMh2r6ajGLA6zxiLWBrIUDDjpXNnuTnpGRETG8=;
 b=C7tykBB/Kst6nO4az9cXsCFrFmJfWxfe7dUN1PEj1HPp8UtdJtDRlzfZr+7L1lP4gg9uQT2o778ukAjxgrshWpU7Lyc+1LHArp8vKkJj/iRSgq0gS/96SnbgvBvrSgoqjqn2phYHDEE94Yz/RtgYZzBVr36/fb6b7FmAexE0ie++8Zd1Pvm5XUq0VBlMihmkoB/MHjuEgFC7bQzqByzIaAKCpbU+Rrd4uZzqYWfugJTiiW9io+BUm7bfxLl8fjO8XP9MhWxf+Z1k0uzyUhYT0X88rjoyHrwuCls7Q7QK8P0TEytNFIHIUi7JrO02cYDudovUyUNBqiAtsksCXZ86fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQmZqyMh2r6ajGLA6zxiLWBrIUDDjpXNnuTnpGRETG8=;
 b=hq72znyqgn1c8f3w9nmDZ0JedbeTgrzkCO9Q2+ipS/5Cwt1qStliSmMCRzw41xZtwGJTuOtWiUwFE3UImn6SGJqIwQLFeqUB29z6ZPF6/PbMoICavdI5/ASp7JPaTTr6fB7rgyRcScCE3dxo4Sbo/tgnDMm8JYGj70+RfE0Ebdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB2502.apcprd06.prod.outlook.com (2603:1096:300:4a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 02:18:12 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%4]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 02:18:12 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] net/netfilter: remove useless type conversion to bool
Date:   Tue, 23 Nov 2021 18:18:00 -0800
Message-Id: <20211124021801.223309-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (203.90.234.87) by HK2PR02CA0173.apcprd02.prod.outlook.com (2603:1096:201:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 24 Nov 2021 02:18:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06099841-9e2d-456a-9cee-08d9aef0aa17
X-MS-TrafficTypeDiagnostic: PS2PR06MB2502:
X-Microsoft-Antispam-PRVS: <PS2PR06MB25023BD1471A87CCE39A91EFDF619@PS2PR06MB2502.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wp45HhNCnZEi1J6cRdl43j96JPddwsRZ/z6dAxWO5ApBfvTNBHVTpjIE0sf15HevyhtV9u1NSR3K3VR6BWcfLfIzVdF9iiCXw8tuolIVwPBHtXJllAINIwuTQ1yN9rMqJd3VatZuqrp5aSFT8YXQa/SWkjtluMGihnXU4nRFCt5njErATUDtqRqEcIMr7Aa7EOojw4pM3CeH1wEze0FnxFlYv6zDXdwHmVc+ukhoVf0IxcQmN2n+MAwXQ9ow1OTN0Xgz9uKLJjdpBjpVFXtfQVJOqsNVFCwZzwASoWYt1CbDIvfyqC2pjSCFi8kpgs79SHwI/L1aKkV86DEOlWP+mDQii1egPjB3BL94VGxfdTBz0nfBQ8VaKyW+t8gUbXLfwVHXL71AI+L9HqnynxCc2XtkX3TknODzt4Gd8zyCP/gCRC7YY7URkQqlD0+0AYrIyL7LQG7ygdS4K7vVnWbIcecf7l2+7+NqUu5uWNAWdR16dLty+AK+QhoLAtG6g8PBUdiTN0djbIXSTC0kjpSzhoHjFvg7YE0ReV2MoOnxRCsv3ZyxvNmH1O6SUAY13trM9B3BdHVlEo5DW9bFjngsUBSlN4PnVs/t5chU2W4dhV71A1yXTFbnD1xiQShz4uBrwtxQQKba3WH/+lQWb8lluWYuJV2wwYvQ3XHyI1OCsoQ2vNj/84EYK4UbCQ3xs7tr5b9erANoTgH34WpbRBhhkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6506007)(4744005)(86362001)(26005)(1076003)(107886003)(6512007)(83380400001)(6666004)(66556008)(4326008)(66946007)(2616005)(52116002)(6486002)(66476007)(186003)(38350700002)(316002)(8676002)(38100700002)(956004)(508600001)(8936002)(5660300002)(36756003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JPKURGaLRjS08gKaUgjq/0ecU1pH6oo6IothekEnNS4j7UuleuQU/9bABHS7?=
 =?us-ascii?Q?P7HYhsFYQojUNL6QI/6HXtekC0y4UCugwxyuyFg0Cc+hlBySF+bnAnthzHXU?=
 =?us-ascii?Q?rDPaCRs10lU1gPohcQG/TDg/j8MwTN0xzb1/zxOW/t2hNpN0RiBs//Y4LMck?=
 =?us-ascii?Q?DMQCNt7bbBqVw4FP5F6ir5fOJtgLF95sJiNP/j2v86FH0Cu6qKxp8W7781/e?=
 =?us-ascii?Q?SVEFkiltQhvfz+RxKJ8UEMiws8FS1ymBgeqt+A/nE1Jj0GCdG1OtYAzhyiLm?=
 =?us-ascii?Q?cKEMGjzMIgGxVFI/uCK69YqdJmYWlyFvt9Ch05GMJy9Nd4KbW3xCcehInd0b?=
 =?us-ascii?Q?hQlORpJDoT7mofUOL0uOJ4DYhLhqrh3zlXDgIQuLZPGmb6wo1I1BI7LRLrc7?=
 =?us-ascii?Q?dWyC69arfr78u4QVzBJqUvABY+YiR8cwip5FNftjjCGeMWRJNvxoG7DxoIjT?=
 =?us-ascii?Q?dsYlzgq/Se3Yv/Zr0d8JjMbRN/7m4CPIigU2/fQcbwA628EdmcGqB8AH/lCT?=
 =?us-ascii?Q?ogQMKxHaBTEVEEF/otctMmJnCPS6F9AenrQlLwvUKuLiSuCjbit3kCIMce11?=
 =?us-ascii?Q?0IBnBi6aV9gXMdn4Hs5DKs1uxSaLuFY7gGLDRtcX2IqblK8zybD+BiDN8fcY?=
 =?us-ascii?Q?cPmF5uGDiDFNvF3k3gDfXet3KUY3GWHlXOv5hlSA41CXjJ/i1cMh6SC2po/W?=
 =?us-ascii?Q?VIMwJmiG9/ThiKvfNv8e1aUX2fEDs7pZ6J8FEBfJVhg8QFh0OsjRUYQAGFpF?=
 =?us-ascii?Q?i8KPOy37lCfToNXyUXnDGzcdNAp2bKEhElSux7KkbzObVx8B5IyTrxGtM1DN?=
 =?us-ascii?Q?an4wBjnxEAQLtMI4v2X6YJmSOim1WSo5tbgco7ntxPW7rrkCMwE3Bp59gT1b?=
 =?us-ascii?Q?j1oq+qznM11FmkTASU1D4MrHbzJqQv/vxBPvojjSeI3hSZ0roYeUGFiYQImf?=
 =?us-ascii?Q?7TksUJHWJV/l52m01T58IU6i4DaEPHnN7XGqb9E3qqwqF4CSAAag28hy2PKl?=
 =?us-ascii?Q?BC1D/58jdVOqEs2yZzTsL3/cLf7meYsh+N0B3DdwjeBVuPpxj+9NxhVixhld?=
 =?us-ascii?Q?T5OSdZLTfU4uBh0MGZeujjy5oH+g0bM92d/rO3jlRVeo0MF03MGAmpjgaMK2?=
 =?us-ascii?Q?B/qldDmodblaj/soALzMkjOCQ7zRsQ4nKnOH2zYnbDYxIC0EiLvByui5fCtF?=
 =?us-ascii?Q?fjWoe4TLlckeqpwHzYhMZJqoobIu9uu3BzRjljQYef5/mcXc0h99nvnE/syn?=
 =?us-ascii?Q?rQqDuOym1u3VcGUvCg+AyXt6FQ3dogC9kIWKotm2AUcTxZ4o6t9Wgb0Sbbo9?=
 =?us-ascii?Q?+1GwRWyjTPM9ZHwnmJVkR2+FWLue7mhelb4+dhhUa1oAQJx/bzP8DNflvB/N?=
 =?us-ascii?Q?C4rxxXtYuDKOM31MWLcPH/MW2OZetGdKRFt/E6iVBVrRHIUVc5njrxfs8JTV?=
 =?us-ascii?Q?B1sotPwS319uN2RA8PNJMdwQgtS9R9WDa8BWYfmdmL2+bWo3+XePJMh7s66H?=
 =?us-ascii?Q?aY0SKDI/Pqjx6xWyPCC1d7Y+aAYph/jFysvBTwrgF3ZAg5fXgehdIXNILHQ2?=
 =?us-ascii?Q?jRnD6ZPSMgWRqhEpjvX/5wUYQVoLRracqEdMNUqUF5CFUFb/yrt0fR0TUeKz?=
 =?us-ascii?Q?rDtkt2UYRB38nN1DN5vNBpY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06099841-9e2d-456a-9cee-08d9aef0aa17
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 02:18:12.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlpEsHl57IRdOAjuWtZl88K+Gy/7Ejt9SmtIAPRsNt+beu72i/iZkEOaAhrZDtre3+/j/C08O+9OqUWVQ1VMmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dying is bool, the type conversion to true/false value is not
needed.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f1e5443fe7c7..a6503bd188e3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1748,7 +1748,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq,
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying ? true : false, 0);
+						  ct, dying, 0);
 			if (res < 0) {
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
-- 
2.33.1

