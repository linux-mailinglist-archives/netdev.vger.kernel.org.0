Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692FB3AA0B0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhFPQEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:04:20 -0400
Received: from mail-eopbgr60121.outbound.protection.outlook.com ([40.107.6.121]:61575
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231549AbhFPQEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:04:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtFotXCTYf/cRvY6rkvyy7kow9HSD5Gzmoqdz4/fllI8BzHrDHyFYniAqr42G5s5BYAVC7C9+InNVrFhCck6Z41fh/f69Qv7bWxmpxZc3+uZtLj40cLQxaCEqVkhaxOoGjAbQwfMyaYmCRn3laXmspYwxnAdws/dMRBZ2fvaZ9HHC9FTiN+0L46JSndTP3W9zpltb+W5GNqKRzAPDOnrDVEuFiDa34y4+hcVFTPxAq7ZviOdzH/pm9qniaY0cb1KmdN291/YW7k3Y+QTvyvFQ5iJ2/LVLuQnZf/iFb71bET29eLZH1Buk6rLv8mY8WWCzXKC60l3+vUtSqeXGamjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov0eoYvNJJyjtFSNVmV22VW5JBt+R2JXmCjCXkOqbiw=;
 b=HM71iF0oYKxAyN67WsEfVMcA8izW+pJ6XVVAPuZ9D6PP9rJDDHsiMM+YxPH6/zre1r2T++J88vCVhwdOHbTqa4a3hDamgf+MqgkKY+PG087PaTDi14ZiiE23/bBbXUJ9bw2rdKE9iWTXD5uj4P2wxU45TMKmkMIGqXa2Si8Vlk1SuoXoFCs9YIO/Lw1WAsEXnPdb+JKBk6zeCViX5F6IGnAgRLVtcUmu7Icx38dh/M4uz3AV5MDYt8W3GHHUHS3HpyD1OMO5y5XTTz4z7r33m4f7borA01TSUjEWgX0AxH6rTERmhflzVyzdlpSRc3IVDtLxbUuZ+/GrgBOdPm1O0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov0eoYvNJJyjtFSNVmV22VW5JBt+R2JXmCjCXkOqbiw=;
 b=eGnYkUF6DGaTkpv/b5tgHglCpsqKTAGJUWSo10WafamtXDrpiYKfRB+InkIIWTR8Xa11Brpl3yg6PST+6jWelXBCPGUAHdw6ft6FekyhR9cG4xTPeltK5iLYhgMHmFBpIuueSveRp9CgbzepHOVzswO0Ocg7n/kC2buSNgG7FFk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0090.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Wed, 16 Jun 2021 16:02:05 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 16:02:05 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 2/2] net: marvell: prestera: Add matchall support
Date:   Wed, 16 Jun 2021 19:01:45 +0300
Message-Id: <20210616160145.17376-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210616160145.17376-1-vadym.kochan@plvision.eu>
References: <20210616160145.17376-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0027.eurprd04.prod.outlook.com (2603:10a6:20b:310::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 16:02:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 619f3d8d-0f32-45b8-1f1e-08d930e01628
X-MS-TrafficTypeDiagnostic: HE1P190MB0090:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0090B6365692414B65299EBC950F9@HE1P190MB0090.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/NIVncm+44EEidpzcMp7TobmhFOIE/82dIWl9ieBCGJ5Oi6uVzytzd10+zKJX2Ipdhe5y1IY4pJU1XNGHU1E3HOG7v0pgHTcOd1D2WV2TRRBRvhbkCwKNqLf5U1/SPnhjYsXmNjknpPapzIRjw61WpXpdcVqp3A3MI8/1ejI6NzR5g28PyKXkDpa5+q80zrM7QKiHMDx2hZY8Ln34bBP7Pv4OVka8LNVuxJpLMMCNbBezXA5AxaS9RxXJ86/ASxF0GnAKGwiNOkJdfo8HhXIQZIJrVzGU8RnkDMiU3NbGvUOsqiqeNuyca+Tvu+cZBU2/xH5oD1HAt6LQ0DILDLvLHeXWxgTl4+nrbwLtbm2sqsfcLijMjundJxIHdGodriOr4637JbWpB/Q3n2nH72jjWOsc01T1xbYiiaJaa+eR/TFLtgXiCf7ly/wTXWQp2dx3VEq73WUPowUQtgY7RWCWQ/Cn89SPtQUZGmhiTJm/r2AWF4JXNzLgwQQFUmVQazHxYfhLSpdHi1FVTD2ftTimQYdIeDl/woX6OsIOeWewoDW2z9RJWi+u4S2QIO0e8Hbh4mbFcp+MICOIqI4UCY/pK0tM3jTomcnoSYZi1iftp5hGlRmAsdBTNUwWQELHY4qbkj9PByZBbrXSiMURg8ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(136003)(396003)(376002)(1076003)(5660300002)(54906003)(2616005)(956004)(4326008)(6506007)(52116002)(44832011)(83380400001)(16526019)(38350700002)(30864003)(38100700002)(2906002)(26005)(6666004)(36756003)(66946007)(8676002)(86362001)(316002)(8936002)(66556008)(110136005)(6486002)(7416002)(6512007)(66476007)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YO6LZGxMZV4V/UjtvfQxe8REm0+bDbumJBZ31W13h5B3pmjQS5Xlo4dMyB/Z?=
 =?us-ascii?Q?ziweLxVBFJq/PDiW8kcyEIoQpDDyE0HNF/YgY+TM/TXd2rE9p3f1vpTX+wYI?=
 =?us-ascii?Q?MJK9X+LPuQ3dmoqFXK/T2/rVPylUqXljcnJH5HKV0EVvRgssAqQouI9q9X21?=
 =?us-ascii?Q?02OWGF/uU+ae9P6+Gapvt0etaAsuAbF1GW+aIq38hm+NL5Q9UgaEHLhA2DTK?=
 =?us-ascii?Q?2gyvvD6+39/EWKq2lbt9Ard151YsJsc8f+hsHABuatKpHbAgHzbLghOXfSg7?=
 =?us-ascii?Q?TTYPxzrLR/LQlmkrr33lpt+veAyz6EjZaJiIGoT1lJX1mF7unwB2S5CKa/0+?=
 =?us-ascii?Q?+gXL3JQwxkTOU65XJesgXAj1XrhLMJ0OMQyAV7xt+0anpG3Be1dQsB+ptB5q?=
 =?us-ascii?Q?3Fuo3S2kneS1Mqwy5b4GwCi6D+bqzCTTgT9oHzVcxdJxyM/M67Yle0MjbAZh?=
 =?us-ascii?Q?dhSr+lJmCQQmbDsb3u2wCU39V5PreTXNjafBd2vIgnwzwmeGnQdF1/mtEOJL?=
 =?us-ascii?Q?6s9nyYRM0gomE3gSmOAX0df64koQe+mZOxYmTH+86/IZCU+A1swLis2T6miX?=
 =?us-ascii?Q?+9ODTgmWWYwpVLfdfGtDXOITLYDxZW5g2UueamPEx+vjV9iIrtnISCK3gYwx?=
 =?us-ascii?Q?20KSKER/n7NjOo9qiOp13+X1NOLxhHnjVeB59KeBqt0XHpxnEJLRRhFMSQpd?=
 =?us-ascii?Q?avHAYSjU/OwlawX3A/mxrn2JfSKsyq2Au/JRiay+Z0HTyfFYF7O92Wucv61A?=
 =?us-ascii?Q?kj1/9qBT05VcLUBSGmO2ldkBgqpO42g3lh+ednC6owgDKLqKaT5C4UVWmMMQ?=
 =?us-ascii?Q?flDspP9YHXvusx4WRXxSsTMUxTI32n5ocDeVe/76o6p84LlpzJm5Of48ozpM?=
 =?us-ascii?Q?LWYk6mMA4KowCr1mOdaCWA1Et21tQD0Qkc83G5nCydFZsdMBN09xzsaKud7g?=
 =?us-ascii?Q?lnERZGMXcBR8K+yx5yYGFLWAHp2VymX2IfoBAi+PgUFb8EdFykbPORfiwZRX?=
 =?us-ascii?Q?C3PBYB861xE/7gJevkgsYjLxCMD/XgvPbi0zYstajEYDcUFTYTrBD4gYXm5M?=
 =?us-ascii?Q?CnAWZUpjMYN5fEyn+R9DX83hiq81t6WbL3IcY2E8nJHMDi+Q4NO5hWTnfwQ4?=
 =?us-ascii?Q?FyjR0lhkPJe/tskqBEgcs6hUdIztBeGyTJLkokgd3HPH0h3BSG0PWfo2UhS4?=
 =?us-ascii?Q?0JGJ++rf/fhzAugEgnluM3WlJpiXuJ1l5Ph6zGACRPM3EAwoSkVB/zyAVwun?=
 =?us-ascii?Q?phiHLmZhavQMll79CpfGkTlDEnwSRbXQDlzRkUS/ruGnfxI39P5vpYmwmAzg?=
 =?us-ascii?Q?WU+O5tg4NmOcto1Z8d46ioSD?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 619f3d8d-0f32-45b8-1f1e-08d930e01628
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:02:05.4030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+QUZLSpTxkniBCvzEGsH+vKSwz9IDyE6xFCwVDEZ8UJw3e9/l1og1Pwwm7XBtxigPvCPyuLBra6zf8wB9vwmkyGHMbeyyjpfcYxPWz+Jpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

- Introduce matchall filter support
- Add SPAN API to configure port mirroring.
- Add tc mirror action.

At this moment, only mirror (egress) action is supported.

Example:
    tc filter ... action mirred egress mirror dev DEV

Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
v2:
    1) Removed extra not needed diff with prestera_port and    [suggested by Vladimir Oltean]
       prestera_switch  lines exchanging in prestera_acl.h

    2) Fix local variables ordering to reverse chrostmas tree  [suggested by Vladimir Oltean]

    3) Use tc_cls_can_offload_and_chain0() in                  [suggested by Vladimir Oltean]
       prestera_span_replace()

    4) Removed TODO about prio check                           [suggested by Vladimir Oltean]

    5) Rephrase error message if prestera_netdev_check()       [suggested by Vladimir Oltean]
       fails in prestera_span_replace()

 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../ethernet/marvell/prestera/prestera_acl.c  |   2 +
 .../ethernet/marvell/prestera/prestera_acl.h  |   1 +
 .../ethernet/marvell/prestera/prestera_flow.c |  19 ++
 .../ethernet/marvell/prestera/prestera_hw.c   |  69 +++++
 .../ethernet/marvell/prestera/prestera_hw.h   |   6 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +
 .../ethernet/marvell/prestera/prestera_span.c | 239 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_span.h |  20 ++
 10 files changed, 367 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 42327c4afdbf..0609df8b913d 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -3,6 +3,6 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
-			   prestera_flower.o
+			   prestera_flower.o prestera_span.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index bbbe780d0886..f18fe664b373 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -172,6 +172,7 @@ struct prestera_event {
 };
 
 struct prestera_switchdev;
+struct prestera_span;
 struct prestera_rxtx;
 struct prestera_trap_data;
 struct prestera_acl;
@@ -181,6 +182,7 @@ struct prestera_switch {
 	struct prestera_switchdev *swdev;
 	struct prestera_rxtx *rxtx;
 	struct prestera_acl *acl;
+	struct prestera_span *span;
 	struct list_head event_handlers;
 	struct notifier_block netdev_nb;
 	struct prestera_trap_data *trap_data;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 64b66ba1c43f..83c75ffb1a1c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -6,6 +6,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_acl.h"
+#include "prestera_span.h"
 
 struct prestera_acl {
 	struct prestera_switch *sw;
@@ -127,6 +128,7 @@ int prestera_acl_block_bind(struct prestera_flow_block *block,
 	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
 	if (!binding)
 		return -ENOMEM;
+	binding->span_id = PRESTERA_SPAN_INVALID_ID;
 	binding->port = port;
 
 	err = prestera_hw_acl_port_bind(port, block->ruleset->id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 1b3f516778e5..39b7869be659 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -36,6 +36,7 @@ struct prestera_acl_ruleset;
 struct prestera_flow_block_binding {
 	struct list_head list;
 	struct prestera_port *port;
+	int span_id;
 };
 
 struct prestera_flow_block {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index 12a36723e2a5..c9891e968259 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -7,10 +7,25 @@
 #include "prestera.h"
 #include "prestera_acl.h"
 #include "prestera_flow.h"
+#include "prestera_span.h"
 #include "prestera_flower.h"
 
 static LIST_HEAD(prestera_block_cb_list);
 
+static int prestera_flow_block_mall_cb(struct prestera_flow_block *block,
+				       struct tc_cls_matchall_offload *f)
+{
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return prestera_span_replace(block, f);
+	case TC_CLSMATCHALL_DESTROY:
+		prestera_span_destroy(block);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
 					 struct flow_cls_offload *f)
 {
@@ -38,6 +53,8 @@ static int prestera_flow_block_cb(enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return prestera_flow_block_flower_cb(block, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return prestera_flow_block_mall_cb(block, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -143,6 +160,8 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
 
 	block = flow_block_cb_priv(block_cb);
 
+	prestera_span_destroy(block);
+
 	err = prestera_acl_block_unbind(block, port);
 	if (err)
 		goto error;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 42b8d9f56468..c1297859e471 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -56,6 +56,11 @@ enum prestera_cmd_type_t {
 
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
+	PRESTERA_CMD_TYPE_SPAN_GET = 0x1100,
+	PRESTERA_CMD_TYPE_SPAN_BIND = 0x1101,
+	PRESTERA_CMD_TYPE_SPAN_UNBIND = 0x1102,
+	PRESTERA_CMD_TYPE_SPAN_RELEASE = 0x1103,
+
 	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
 
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
@@ -377,6 +382,18 @@ struct prestera_msg_acl_ruleset_resp {
 	u16 id;
 };
 
+struct prestera_msg_span_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u8 id;
+} __packed __aligned(4);
+
+struct prestera_msg_span_resp {
+	struct prestera_msg_ret ret;
+	u8 id;
+} __packed __aligned(4);
+
 struct prestera_msg_stp_req {
 	struct prestera_msg_cmd cmd;
 	u32 port;
@@ -1055,6 +1072,58 @@ int prestera_hw_acl_port_unbind(const struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
+{
+	struct prestera_msg_span_resp resp;
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_SPAN_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*span_id = resp.id;
+
+	return 0;
+}
+
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
+{
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.id = span_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_BIND,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_span_unbind(const struct prestera_port *port)
+{
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_UNBIND,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id)
+{
+	struct prestera_msg_span_req req = {
+		.id = span_id
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SPAN_RELEASE,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 {
 	struct prestera_msg_port_attr_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index c01d376574d2..546d5fd8240d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -188,6 +188,12 @@ int prestera_hw_acl_port_bind(const struct prestera_port *port,
 int prestera_hw_acl_port_unbind(const struct prestera_port *port,
 				u16 ruleset_id);
 
+/* SPAN API */
+int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
+int prestera_hw_span_unbind(const struct prestera_port *port);
+int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index c3319d19c910..226f4ff29f6e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera_hw.h"
 #include "prestera_acl.h"
 #include "prestera_flow.h"
+#include "prestera_span.h"
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
 #include "prestera_ethtool.h"
@@ -845,6 +846,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_acl_init;
 
+	err = prestera_span_init(sw);
+	if (err)
+		goto err_span_init;
+
 	err = prestera_devlink_register(sw);
 	if (err)
 		goto err_dl_register;
@@ -864,6 +869,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 err_lag_init:
 	prestera_devlink_unregister(sw);
 err_dl_register:
+	prestera_span_fini(sw);
+err_span_init:
 	prestera_acl_fini(sw);
 err_acl_init:
 	prestera_event_handlers_unregister(sw);
@@ -883,6 +890,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_destroy_ports(sw);
 	prestera_lag_fini(sw);
 	prestera_devlink_unregister(sw);
+	prestera_span_fini(sw);
 	prestera_acl_fini(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
new file mode 100644
index 000000000000..3cafca827bb7
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_acl.h"
+#include "prestera_span.h"
+
+struct prestera_span_entry {
+	struct list_head list;
+	struct prestera_port *port;
+	refcount_t ref_count;
+	u8 id;
+};
+
+struct prestera_span {
+	struct prestera_switch *sw;
+	struct list_head entries;
+};
+
+static struct prestera_span_entry *
+prestera_span_entry_create(struct prestera_port *port, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&entry->ref_count, 1);
+	entry->port = port;
+	entry->id = span_id;
+	list_add_tail(&entry->list, &port->sw->span->entries);
+
+	return entry;
+}
+
+static void prestera_span_entry_del(struct prestera_span_entry *entry)
+{
+	list_del(&entry->list);
+	kfree(entry);
+}
+
+static struct prestera_span_entry *
+prestera_span_entry_find_by_id(struct prestera_span *span, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+
+	list_for_each_entry(entry, &span->entries, list) {
+		if (entry->id == span_id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static struct prestera_span_entry *
+prestera_span_entry_find_by_port(struct prestera_span *span,
+				 struct prestera_port *port)
+{
+	struct prestera_span_entry *entry;
+
+	list_for_each_entry(entry, &span->entries, list) {
+		if (entry->port == port)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static int prestera_span_get(struct prestera_port *port, u8 *span_id)
+{
+	u8 new_span_id;
+	struct prestera_switch *sw = port->sw;
+	struct prestera_span_entry *entry;
+	int err;
+
+	entry = prestera_span_entry_find_by_port(sw->span, port);
+	if (entry) {
+		refcount_inc(&entry->ref_count);
+		*span_id = entry->id;
+		return 0;
+	}
+
+	err = prestera_hw_span_get(port, &new_span_id);
+	if (err)
+		return err;
+
+	entry = prestera_span_entry_create(port, new_span_id);
+	if (IS_ERR(entry)) {
+		prestera_hw_span_release(sw, new_span_id);
+		return PTR_ERR(entry);
+	}
+
+	*span_id = new_span_id;
+	return 0;
+}
+
+static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+	int err;
+
+	entry = prestera_span_entry_find_by_id(sw->span, span_id);
+	if (!entry)
+		return false;
+
+	if (!refcount_dec_and_test(&entry->ref_count))
+		return 0;
+
+	err = prestera_hw_span_release(sw, span_id);
+	if (err)
+		return err;
+
+	prestera_span_entry_del(entry);
+	return 0;
+}
+
+static int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
+				  struct prestera_port *to_port)
+{
+	struct prestera_switch *sw = binding->port->sw;
+	u8 span_id;
+	int err;
+
+	if (binding->span_id != PRESTERA_SPAN_INVALID_ID)
+		/* port already in mirroring */
+		return -EEXIST;
+
+	err = prestera_span_get(to_port, &span_id);
+	if (err)
+		return err;
+
+	err = prestera_hw_span_bind(binding->port, span_id);
+	if (err) {
+		prestera_span_put(sw, span_id);
+		return err;
+	}
+
+	binding->span_id = span_id;
+	return 0;
+}
+
+static int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
+{
+	int err;
+
+	err = prestera_hw_span_unbind(binding->port);
+	if (err)
+		return err;
+
+	err = prestera_span_put(binding->port->sw, binding->span_id);
+	if (err)
+		return err;
+
+	binding->span_id = PRESTERA_SPAN_INVALID_ID;
+	return 0;
+}
+
+int prestera_span_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f)
+{
+	struct prestera_flow_block_binding *binding;
+	__be16 protocol = f->common.protocol;
+	struct flow_action_entry *act;
+	struct prestera_port *port;
+	int err;
+
+	if (!flow_offload_has_one_action(&f->rule->action)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &f->rule->action.entries[0];
+
+	if (!prestera_netdev_check(act->dev)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only Marvell Prestera port is supported");
+		return -EINVAL;
+	}
+	if (!tc_cls_can_offload_and_chain0(act->dev, &f->common))
+		return -EOPNOTSUPP;
+	if (act->id != FLOW_ACTION_MIRRED)
+		return -EOPNOTSUPP;
+	if (protocol != htons(ETH_P_ALL))
+		return -EOPNOTSUPP;
+
+	port = netdev_priv(act->dev);
+
+	list_for_each_entry(binding, &block->binding_list, list) {
+		err = prestera_span_rule_add(binding, port);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(binding,
+					     &block->binding_list, list)
+		prestera_span_rule_del(binding);
+	return err;
+}
+
+void prestera_span_destroy(struct prestera_flow_block *block)
+{
+	struct prestera_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		prestera_span_rule_del(binding);
+}
+
+int prestera_span_init(struct prestera_switch *sw)
+{
+	struct prestera_span *span;
+
+	span = kzalloc(sizeof(*span), GFP_KERNEL);
+	if (!span)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&span->entries);
+
+	sw->span = span;
+	span->sw = sw;
+
+	return 0;
+}
+
+void prestera_span_fini(struct prestera_switch *sw)
+{
+	struct prestera_span *span = sw->span;
+
+	WARN_ON(!list_empty(&span->entries));
+	kfree(span);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.h b/drivers/net/ethernet/marvell/prestera/prestera_span.h
new file mode 100644
index 000000000000..f0644521f78a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_SPAN_H_
+#define _PRESTERA_SPAN_H_
+
+#include <net/pkt_cls.h>
+
+#define PRESTERA_SPAN_INVALID_ID -1
+
+struct prestera_switch;
+struct prestera_flow_block;
+
+int prestera_span_init(struct prestera_switch *sw);
+void prestera_span_fini(struct prestera_switch *sw);
+int prestera_span_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f);
+void prestera_span_destroy(struct prestera_flow_block *block);
+
+#endif /* _PRESTERA_SPAN_H_ */
-- 
2.17.1

