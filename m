Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1F2D0877
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgLGAB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:58 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:53705
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727375AbgLGAB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mz27L0IMzgopmsozqdfTmoV3bSbJNabwMemtft9Vdhu3Ivy3PIOFULzxAJpMa/dcRBoGaPVniHPIqbzubri3Ud+QHEIVjasjpWR+hIwl98Dm7jLlJEw8g+uHdj2fTkfAUXW5Ehzivn8J9RPTKBg6JHwwobt1o13TwA1q3tG2Ug6/D6V+xdCK7LMhmo62DG0smy2e0DzVjcXt+IzuJeQxQqjat38SlxJUYCmudeMq0G6YsrWyCKFLRu8LYXgGQ09U59UFwdF+konvQX9y1bJzu6O7/3fkAB9WhMGWAeEZqQIFxHUuFsIhs1zosSmtc0hLYmbkYOMuWU9cGR2UpRE60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHmGWui+p+DyYtm0DNC+njXgVzJATjXFcBvLMUSA+fw=;
 b=IkB3URV6AyNMZOAaTbDnaDOFkdmPFKCeZwxWxndyjm1s1uAKp25VhQM9IfzWLmFZShXXYb2F5HeWNbjEYBfhBcxJ2HWco059m5MBU5aoek3ycHtbVY485V+aa0WpL2QSJH499zUVwoWILjfVH6IrV/WyR5ZT6Ely/fMx6IgLWDTj0y/mjnl8UgMueHc0i7daBjMln4CYuOTp1TOgtxVp7AOhw+G/eCp/HLrnX2HCDRm88g9Mjpf4LMaP7y+pwu3LsVwJ9eN1IpKaO3qnB7ZsluLtf9W3nsNC9s7EdIqk1UGNXA4zb4piLJfVamaFoLkI23th5AsNrhZOi44h14Q5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHmGWui+p+DyYtm0DNC+njXgVzJATjXFcBvLMUSA+fw=;
 b=Gbgeg8lgnEER1Ltc2K0oxW5NRnbaaxYMH4MFVKBG5xz2knBrmOf2oQMp6zCXKdCgYIiLEdataYvNlXlIipWgEXUtVveOLK0U7F8fx7LwfyUZJE8UXdPIwHG/y8uW7N53HNpvNhBcESapiFpL0YbmwE3n601KmpXQ+4LIs32drU4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 10/13] net: procfs: hold the netdev lists lock when retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:16 +0200
Message-Id: <20201206235919.393158-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21442223-46c4-4839-693e-08d89a430eda
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637BF2683DC060EB82483E9E0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohXlfBm2tX/UpbTrGI/U/qHz9S2JSZ7VuNZ3f9MWJPt+2Hsz8ZAeaZvre84WpGAw33DS0dwhadd71dditj28daVZuJRRzoO5P/ata+0KFt7vtMfLXxzRF9iEgmhxB0ByKKsZCPGnvyFjiHGgk66D3cxxLRFpWvmPEQ8xWnWhSxX59SDr3bW8mt+pC7WgmG/NENod+7J5h6sR2BcSt2gq/dSG4aKLC/JYSYZHpW/nW/ntAoRMft7KPWQ2spmpJjM0jiWu0HWLXIs1YjU6MLM0BmnpRZrB17114Rcfv6vXnSucEL6b4JLttioVzXmPlqM4kwcEf1kIJOcSU+qgQIi7uAUbwNFLwIgoKZxi7F/F+2APX42coawZnnGwPhYtcTzV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?28HdsQhNizOSaoDmVlbgh5kQG1UO1WKw4DUkeQv70NR2kgrOL5U+KxlFRad1?=
 =?us-ascii?Q?Ncf+6yFLjnZacb1ISNXyIf1sry9xVdVPOf/EukwbUux2Ck3DZraZFv/nI+Fg?=
 =?us-ascii?Q?UCFQBqEicdSXjgA8BgtXd3ffAospgxLMkZVYtXEE0f5bKsj81WRfV0ACzsON?=
 =?us-ascii?Q?E0zjDB9hD+ghZOyK/0qTcNIS8zZvv955LYUgiqkGwcAlyS7N7xXYgplKD1Q1?=
 =?us-ascii?Q?sqK8aaW9kU8tE+O5jl6jjY5wZe308jltTLgpPjzSWE5G3dE4rDFDppwv8To0?=
 =?us-ascii?Q?AStLDdIAyFEAgcwvrQddzt9QcPWsndLixGhOMpPWJ4QRkqkgDKhjPBW403+Q?=
 =?us-ascii?Q?xlluLSC2WDhXXPWssC0GvnXzj1mnJm2vDZOCi3nDP4pX6TAgm+K0B3/xVH66?=
 =?us-ascii?Q?1e+/hl8SVonibmJ9p2KkMB6CaRc98AW6HEYMHb34bAWHdahI40bMDe3BBrC6?=
 =?us-ascii?Q?slaQOYxsYAJ2XtDkkKFqDkdtlLzZt2hgKwRedPmrBGxIttznUMwT7jL+ZIDb?=
 =?us-ascii?Q?0c2jvQViAfdKdEamFIkNl4EnhTXllaLKtkp0k6bKqjMUlmkhPpEFlMVwWqUC?=
 =?us-ascii?Q?9z/rDiapC2pD1Fzpgx4rkGdxCsYpFE0+MZr1zlGqhuY4srdo8jlvyZY1l+FW?=
 =?us-ascii?Q?/WTu1b6WRDtV2+HtTrASrWt/cKUHPYqz0GYiIl8R8pt3axIWZUP2mnVXY1EJ?=
 =?us-ascii?Q?QwlbzNoMtBazg13Aue0aap7ptAcAtBRbfu6+mCakHESOoNhVGeF4stJzi+5L?=
 =?us-ascii?Q?8PlGMFlrliH4/rrdzCvwJN6Sx2SB1IRFIc6hWPHWnnMK7ea8DbkF/n+/Lb/F?=
 =?us-ascii?Q?qA9lASBhqlct1csw3Q2sc5+cnMAUo1pHTQWUmjQCrnimUZ229C/QJvNupoPa?=
 =?us-ascii?Q?mDYa/VB7Pj2+aV+Gl3b3IrlIrtnmXy40YSmjw8AE/CmhRBKnlcI65xME+VjF?=
 =?us-ascii?Q?iGKcjaNmQozIL8jRMuiQs8ofNJs0Y66zkLVzzyHfMy/go6Y1okDSqEcdA50t?=
 =?us-ascii?Q?9z/z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21442223-46c4-4839-693e-08d89a430eda
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:07.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ut/FkbzCcTYYtkDNM2qVn4ezT37tRqst9+Ng5slSkqnfnKdezXeAS5yOnLpYS+Jv9DhklounlNZ6/neFH/Cfvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.

To offer the equivalent protection against an interface registering or
deregistering, while also remaining in sleepable context, we can use the
netns mutex for the interface lists.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-procfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..83f8a89dfc5a 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -21,7 +21,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +51,11 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
 {
-	rcu_read_lock();
+	struct net *net = seq_file_net(seq);
+
+	mutex_lock(&net->netdev_lists_lock);
+
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
 {
-	rcu_read_unlock();
+	struct net *net = seq_file_net(seq);
+
+	mutex_unlock(&net->netdev_lists_lock);
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-- 
2.25.1

