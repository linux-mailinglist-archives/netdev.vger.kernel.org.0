Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA763F5D42
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbhHXLm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:26 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:17383
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236805AbhHXLmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvTD5cZlKHA/vC5c0GQrvMDAO9IllX5JgbZ+KjvcX8N3l4BSizHCNKUSHbVTT8wMuPcE4HwqJgNUBbl/zi+s5bKCxeB6sV8PnWo0GGJGIQ/67YLg3VOVIprzbiECe1sRC6xbxGLyY0JI4Y4REwi62eOtQeutDkXiyEXPByXoriKUtfJX6vG0768Q1e2dJTjON6TyItzUro55lq82VOmkVU+sn/t58LXY5OLz4AHdzeIu3hFMJYhy232dn4CSAzolRTBWQezWiXOVmuHKVa1mi52mJnya3VOX3zhJtS8V4ll2rIWkgjdtFhTl4T23EPRMzi6SuYC0dcjeRGXfOFE7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uo7LVho/kFD/bfGRA6FWrHB4Us/8LmkEQ8QHsCtz8Cw=;
 b=aYHR0wrgUkdZoNBEWGeNyXc80m1J8YESymXLpnyXJUEwcCRtZxnGWI9jNHX5dHF8v3I8hSApvwp4C5E940RHa0MxYZNZ/fF/uEp29qqMRl6a43JbzInUIHTzAxVAHssUfxZB7+DTE+nwmo0cFTm9qggwwWKZGO6YS003f0hLC3g7eRm4jgowsR9RFZpzrPHCjsueHBDjTigFKeu93x/dt49TCq0csPpTMnv2oJFIfb0rngNmu0+pkl8z1PLd+8Q7IjlN3EsEtUklEpnD9u+cHwOXciyVzSLXUC3vNTybcOUDWGMCQHqRQOUmCc6uMtRvmsKm0LrTWU7cBePtd77fvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uo7LVho/kFD/bfGRA6FWrHB4Us/8LmkEQ8QHsCtz8Cw=;
 b=FRf0gue1ZuMU3IzNy565eSt4vMYaMtc7GTglbCLkM5MklV0LgB+aSm6VmWwv0gMI7SNTVPEUBSLtZSwWjlqgWMb7oJQWk56ikP9cYYRjODS+IZjQOLEZQrkMjBTgPucNwDjuiQHGaew3SsWT5nYBncLPu/Wm/t9LCPEVK9G0eq8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 6/8] net: dsa: flush switchdev workqueue when leaving the bridge
Date:   Tue, 24 Aug 2021 14:40:47 +0300
Message-Id: <20210824114049.3814660-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a225940b-0d0d-4a56-9fdb-08d966f418f7
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56967826EDDEEC3FAE767D7AE0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8MgFHXJMLLKfwkH80Yg+a5dqRPdPgEAo6u/IrwTvdnebaNSO/Sg9rwmHMIygX56G3xCaCuqZNt5lkBTVmBW+zLc2hNP/XIryhiV9vyrUuorYe6gDjZzhoIvj2GPaOCXQ2K7RqTtmPbCIlx5R2vSpC976p7VEp8GAVNcRQsgTI99Z8ddYdwsZHtEBrSTkLTFvyWTp/9ahipCgRrmxT5JrBr6sRXmfWWB8mGg2lCsyfm+ZDIf5OOB5D+jkI0WGaDs3kwu/1NXhslYCScxiMOEtk3i8fXwPTrLLr8PU39sFV22uPZgTXrJyqswDZhiBvAf6rIfTrywx86C/E2HJ1qinkSH1kCdJKRaXwu5HlDiVxVGIhGSyYwLDyFQUwpQMqUOukZloyJnIQfCGC4FB0oT5xYYoGK9vRifGVBhA9Jo3c0w/eqIC1nPRBL/sfAoc6vh08G2lI3IVxsgRYWp1R2EoGY+SgBbosZC1N8FbLr29KvGAxAHbVfYZVVIPXUwr22zxmhhFAUjPkvlbsC/CcXq3hGhk+z6E5ZglfOLPU7ORFZEm2j2D/nEW4scSXlnDfjtpDRK6GXzRTlkYtDbc3T9jvirFwhKIAj5O71e6+bT1o95XYV9vtb6wTrawe/e2yxMB6xQ0PX4A+6zcU8SmNExjjvQKkkXxD/5Mus+DIdVU9ISXUh6IF7LP6gWOKDtd2gKyT31qdRdxCZsI6vQAH/lNAxQYHT1mta0+xnGvkShtvTG4z90xD+/coUB8ULaVodtkotwRkRziDH5qGD1D7aztA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(966005)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hDySbr6IwGD3RR2FyUZHYgcqOQTQnaQUMdjfaLoUBRUORwesUvlfMuRCrW+g?=
 =?us-ascii?Q?du9Ukv7LXuA73xTXrf+wamLIelTpbCp9369KUx6UosK0LuICOTSn8OsVITIq?=
 =?us-ascii?Q?XRdTVv4HDfsXQ7Wc6nqPNUx+5Vgtu2ARd5NXWuN48W9fbRKDUQtZPIs/mz8T?=
 =?us-ascii?Q?Y3kp8+j4hAzDPvne6QwBv0Di/jICHMjMOTIsmEy2z7mMT6pEieHpjxPtdEWa?=
 =?us-ascii?Q?1lrBVZLeiLSblay/km6mpLUs19mLkc6/fz3xEPcBY+m9VBRAnWuvFED2SU9I?=
 =?us-ascii?Q?UALs6XxtutBjIGmHl9/BmTPU6cJeqZwbWQ1craDVlXLvSrSaAg2hL+xENE3O?=
 =?us-ascii?Q?svDEe04PL+tgkcNwwsFCsh9un0EzmeSiSU6q9yaCZLAevURj2N2G/0zYOCFf?=
 =?us-ascii?Q?B7zxvZwo8QUf2/FlYhVpk2VHbvhtmlVvJH+5TJ3J5USwCaHPYh3+9XSJfb2y?=
 =?us-ascii?Q?Gz6sm/YSTqmueX9QEi1wluUwubApoN+VX+Rl8Jzn1Ti53DkqECHJ2LYH3BHn?=
 =?us-ascii?Q?Az4+TX1SoAneloyNk1KZTlL4ZyZ/yEDsddS4RQ9N061xH53nxqG1UjAz2gqW?=
 =?us-ascii?Q?zQxekat7iYSlOn5Z7YdC7kH1nLvfKV2j8HSY5oLmXGfMtrwHTw//0q9T5IQM?=
 =?us-ascii?Q?k9RSyQBjYEpwlunTINSPAq1Kx4QcnEaoAF9nuYhITpL5whdfNnXxvo7mmnVG?=
 =?us-ascii?Q?zpInKkZudzbjV8/uEGKpD/moQ1oeJHGTu8uaBpdShgB6B79OjkgTmEGE8Mnq?=
 =?us-ascii?Q?qkOcOvJnBFWOp9/EpYm68997qmHucSFPK4CWq2zo5VSnKu7651KtpogP2w4L?=
 =?us-ascii?Q?Npd9+BJU0TpgDNFbFUIIkvJAaWxOLVaIUXyglY8oh5KrNM9sCJN1gyl6kwIl?=
 =?us-ascii?Q?jkkjjOPxmLHNXUvFWQYLqkoioPtePZanAkxvHSVcQe/FcrTjnhee+SfDfSx6?=
 =?us-ascii?Q?rZH1naV08WBMu7CnWfZ6yoSnYcV/sY6aCFTr2UvSGirpg9LwRLHiAyFbsDSZ?=
 =?us-ascii?Q?qVA/zsAS988vdeTsHkebrHvtcTyqvZaTN/Y0qQZn6YdRz6hhU+ovIywsKexE?=
 =?us-ascii?Q?9tKF0QTozsuZh7AIW1gs7ti3UY+RyP1rGRDmtyhSokTM+jwt0zjbGlT62+dW?=
 =?us-ascii?Q?rSOCevz1FS2o+C/8spzVamuB+cYL0YS39hsplNmTzmX+2+s9U3jqH3F3T6Qw?=
 =?us-ascii?Q?Muzhucj0UA28cmZBrGwxEUIWrSMIcAaFxndCLuhXMhv3fRSqOdv8U0CPtKYu?=
 =?us-ascii?Q?TTpvmYj1c3AzZTbF6pgQpe7qSfQmeEaLaNI0IszKP+n1iMaI3OWhhwd0wEa3?=
 =?us-ascii?Q?WeZnwSDyV83Tns+yQl+gZ+Nn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a225940b-0d0d-4a56-9fdb-08d966f418f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:22.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Xq92tuHw4qCTver4AnC/qAtem2YqeWG8ZjTpXc22hRyhJL35LJ6Ja+X78OawygQ+qA6GRasjv+XZ5bp8wuSAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA is preparing to offer switch drivers an API through which they can
associate each FDB entry with a struct net_device *bridge_dev. This can
be used to perform FDB isolation (the FDB lookup performed on the
ingress of a standalone, or bridged port, should not find an FDB entry
that is present in the FDB of another bridge).

In preparation of that work, DSA needs to ensure that by the time we
call the switch .port_fdb_add and .port_fdb_del methods, the
dp->bridge_dev pointer is still valid, i.e. the port is still a bridge
port.

Currently this is true for .port_fdb_add, but not guaranteed to be true
for .port_fdb_del. This is because the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
API requires drivers that must have sleepable context to handle those
events to schedule the deferred work themselves. DSA does this through
the dsa_owq.

It can happen that a port leaves a bridge, del_nbp() flushes the FDB on
that port, SWITCHDEV_FDB_DEL_TO_DEVICE is notified in atomic context,
DSA schedules its deferred work, but del_nbp() finishes unlinking the
bridge as a master from the port before DSA's deferred work is run.

Fundamentally, the port must not be unlinked from the bridge until all
FDB deletion deferred work items have been flushed. The bridge must wait
for the completion of these hardware accesses.

I have tried to address this issue centrally in switchdev by making
SWITCHDEV_FDB_DEL_TO_DEVICE deferred (=> blocking) at the switchdev
level, which would offer implicit synchronization with del_nbp:

https://patchwork.kernel.org/project/netdevbpf/cover/20210820115746.3701811-1-vladimir.oltean@nxp.com/

but it seems that any attempt to modify switchdev's behavior and make
the events blocking there would introduce undesirable side effects in
other switchdev consumers.

The most undesirable behavior seems to be that
switchdev_deferred_process_work() takes the rtnl_mutex itself, which
would be worse off than having the rtnl_mutex taken individually from
drivers which is what we have now.

So to offer the needed guarantee to DSA switch drivers, I have come up
with a compromise solution that does not require switchdev rework:
we already have a hook at the last moment in time when the bridge is
still an upper of ours: the NETDEV_PRECHANGEUPPER handler. We can flush
the dsa_owq manually from there, which makes all FDB deletions
synchronous.

Major problem: the NETDEV_PRECHANGEUPPER event runs with rtnl_mutex held,
so flushing dsa_owq would deadlock if dsa_slave_switchdev_event_work
would take the rtnl_mutex too.

So not only would it be desirable to drop the rtnl_lock from DSA, it is
actually mandatory to do so.

This change requires ACKs from driver maintainers, since we expose
switches to a method which is now unlocked and can trigger concurrency
issue in the access to hardware.

I've eyeballed the existing drivers, and have needed to patch sja1105
and felix/ocelot. I am also looking at the b53 driver where the ARL ops
are unlocked. The other drivers do seem to have a mutex of sorts, but I
am fairly skeptical that its serialization features have really been put
to the test (knowing that the rtnl_mutex serialized accesses already).
So any regression test from drivers that implement:
- .port_fdb_add
- .port_fdb_del
- .port_fdb_dump
- .port_mdb_add
- .port_mdb_del
- .port_fast_age

is appreciated.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      | 5 +++++
 net/dsa/dsa_priv.h | 2 ++
 net/dsa/port.c     | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..8e7207c85d61 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -345,6 +345,11 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
+void dsa_flush_work(void)
+{
+	flush_workqueue(dsa_owq);
+}
+
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 33ab7d7af9eb..1dc28ad4b8a8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,6 +170,8 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
+void dsa_flush_work(void);
+
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 616330a16d31..65ce114b9fc8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -380,6 +380,8 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
+
+	dsa_flush_work();
 }
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
-- 
2.25.1

