Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8B2E0B0B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgLVNpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:45:49 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:47333
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbgLVNps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:45:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHHQ2T3iT/dx90wXB4/CCyr1Uzo2nv6P1kilMpTSSDULLh++1gcx2QnZckpy27Du/9f1PNOGC35os8txMYGjNjZsREMQ9PVdHFKQNPo9K7cNx0Mt5Blwbj9SOxjhWn4rZt9OBZlPoDLmTlsmt3wdMClYrotfoGR8dq5/7zLcTx2mMK09FEsVsRiFYBkHxnYfxtCid+TLaMk9aqL3ecw+3ArtuP3+jOi8On4Kyy9u9cZqWeo/x6Jb0u+TVX+OONuTV2iZclDpNZiS9eLIm4bfnEj8srle001OY24vvn8FtIpJStb8QE11FrKTiX930iZn7q5t+kVl/yXDPrsuYpMbug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+d5xhPj/GLMd7MBwU51JpSFrsa12OAlDAimbUaMw+o=;
 b=OM4WfBxKc8/dwW7Zj5LrDu/QUh9jU+a6KQKhWaqa1PxcH+jA9yaJUHMhRzeNM7ElSOMz85Wy2vpgR6GjEZMWSZRqg9lCfnDxibAsDCtdyP7Te10m2nDXqOBM+2ezWS8oTKw86uh0pcw55F1nxMIeOO/TC1uTysDhAvcXY7FFHzs75AF4Ss61GKRlsDce/fWyarn8nVtMfBkof2eaPJIYKJQKafBQb3DrECbv8vItiAqtH4gS36njEGKU5CImkVSgDZLEkVuUTqPtRsVbFBs0cMGDL8jo+PPna+zqfYfLEWTcGQOI9VrECahCBlFh2Jn5A1s3TxGQfXFsT272BNORzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+d5xhPj/GLMd7MBwU51JpSFrsa12OAlDAimbUaMw+o=;
 b=BnbB6MmLzF2f65EmMvvk6xTFlf+UulF1YaRLtsiFH+ywQPLUf4dLg2FJzHWu1zqGPVu5QuE0mVHUDceUrUjSqbl4xUUtVG8c0Z8U4Hi928mwULxlGZ9iJKx1y1RurR3qDL+i6gBpg5VNlq91vdPKBe8dDyjL+rU9z2VN/kbYp/k=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 01/15] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Tue, 22 Dec 2020 15:44:25 +0200
Message-Id: <20201222134439.2478449-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf8bf1e7-ab52-4945-5741-08d8a67fc37e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74083422BF70CC8FCB4B4225E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kcJ8ijFLpp7mIowqMqypG/b0v7VsCq2oFkuy/hP/yPUxevqE6pkHQWuA/y6uVbGQ3Y12N5wKKPxRAckzD5PfupJHEOabuFVICIuF7y++cGck6mSrbXkPOA6Q4uTVw+/88j9woY2qo0kUJb7kZEC3V1TlB0uzEkNt06AMxaJf79Lw86BGsTwom1YdU3ewE0yDJ0XV+m11X1PncA9alLZq2gjm652BhzZPCFj/LAT4wew85uqi6eNjCgQo0mPzVJR1V8z+YAz4XxPeZSDDOGbgL04JQfjR9d1YFQxrh19pxwJ0B+umP2sy09WEzL4r1G8IeD6yje3VnwieIxcUllug6J3TiMXUUB5OQorDWdQO6soRPN6opQ5dPKmi1l131tiax+GhltJZlBHPtojCfm4fXriaRIWNaSF3D5hSb+ZsjP6R31i7V/xlnxfOiaqYVG2W03FBv0pa0yqrg1CzXGqfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IennnJH/udpkBQSizJgX1eiWU6haMYy0I7vqhofW7SNsvr+rEcVhGjPxxhV+?=
 =?us-ascii?Q?TQzUQ33PHXR/h8NyOUvZCZZI+wMosanf9yhen0X0SbhzV+mveVYsG1EAJwL8?=
 =?us-ascii?Q?SzpTTRpbPTXM7tZ0T/ETZvX/kofPmgyafD0d8ic4Yh77EVP15yIsILD67rV+?=
 =?us-ascii?Q?3UqYvP0WCDh7jrTQ7ReqVnXFHl/kCvxPoXFyPWoxUsx3k5plE4pGWOwzjoeY?=
 =?us-ascii?Q?lRWhZrq1NtPLj7uAktrTbf1gg9NNkasrn7qSseD7aun1aUoF3yhNN3u6aG+v?=
 =?us-ascii?Q?19PBMuTmMFTSGpjuugLQZTtk9aS75mEXqzyl739WBkfphMxsNi9c9CITCNHl?=
 =?us-ascii?Q?NWwSnYaFiuHkkES8RHgevev1g+ilYMByJN3WnEV6cot2hTYWW9Fwxsz1/cE3?=
 =?us-ascii?Q?uKQaXzJ1sY1mYI6SUqJim1ztLcFALSWZXooTiNEiAar4uAENgvol1G0n0M9J?=
 =?us-ascii?Q?AOxPe3mbmaVWQvojK+Umu29nUnNgeXb6LlLUhnBWj6Gp2SsXj4hOO4d4oGab?=
 =?us-ascii?Q?o0+o3C0BsoXm5VPPAdQvZXdHxQJEMG/AnQ1H+uJ9JH9Fv23v9OFbfmwSoJav?=
 =?us-ascii?Q?kBxYo1/1zKq4Ne1pfhIAlAJYaqoLcyo+8gXli0tJFwxuV3IutDDBlXOIJHyd?=
 =?us-ascii?Q?k0pMC8rDtUjN6A1JI4c2Cf8y32IxoxVu+TcAczI/Uiz9otTewlze+oDwOEvd?=
 =?us-ascii?Q?cXvgCgGB2CstIovoRMBheIVcZX6CJ/ksHsJY25H+Aw5EmfJUTKiZh/L94gNb?=
 =?us-ascii?Q?vmFQESQy2iWXV9gAhg95bRBZJRKE6TAihZP6sxWdozzekqZuJlpU9wnvxHCn?=
 =?us-ascii?Q?aKCraZ7Ji/upFWgk0eaMe3q4Bby1fEzahDvOsCH9bBKcxwLmsQGoS94KBlFS?=
 =?us-ascii?Q?L9PCy5TC2sjC21e4ADNMX/o/CFfYjcUfSNYxrzcP9EK59CTHhhNDJJGfKKme?=
 =?us-ascii?Q?9Lehyy9r8ugTNc7gxDAosyd2L7jNl9z1NBnmJMv52Eslsck73jArKtebRcqC?=
 =?us-ascii?Q?KX5w?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:54.2830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8bf1e7-ab52-4945-5741-08d8a67fc37e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0GJKHNqd6i2NBtxcPt3FCvanUoWQnJNm7Ws1eVCEWZKLmzrNrmpfN6YXni51L0/25Bnsxf4pqhcsrdygJLK4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 implementation can be blind about this, but the felix driver
doesn't do exactly what it's being told, so it needs to know whether it
is a TX or an RX VLAN, so it can install the appropriate type of TCAM
rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 include/linux/dsa/8021q.h | 14 ++++++++++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 88cd72dfa4e0..b12b05f1c8b4 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -64,6 +64,10 @@ int dsa_8021q_rx_source_port(u16 vid);
 
 u16 dsa_8021q_rx_subvlan(u16 vid);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -123,6 +127,16 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return false;
+}
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return false;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..008c1ec6e20c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -133,10 +133,21 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-- 
2.25.1

