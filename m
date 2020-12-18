Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916092DEBB2
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLRWlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:41:08 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:27453
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgLRWlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 17:41:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mqr1DRCrS+2hHYg9gNiM8DVz44ISSLeKvdthhtcJG/7m32mYhhURX1dc185MEgASGTyk5cqmOVHn0Vkdxz9nlq5A5syDom0RVNRXU8OziLZAmivNQ7vap88wPiXBrLGdv63G1HnGrylmdKqYf7ICAelrjNNhjtugff9bJ9GdziWR42M2o0DypRLGSMj/go/HTsry3xhkm/8z+XTdTepQikbW479ssLe7IedQw2Exepd2Ffh4F7k4ooiVS4GgwnnMWap8rPKJ0imeAyWYHJ6KD353b+cghrVHZeDHKSteyCipLF8U8mJTEEjn/N4ZW+HmVv8oLGkuBgnvPQuNhG2ZYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx3h0y6UYjUygMUCeUWSDtHYQbozDzBvDUymzCWSC/8=;
 b=aMUqmIfVi2C+wUVka2L9j5812GbHWdDlJDKHY3pFZyJQCiuHzaQvSAYa/5uwV9ktWJz/wZI5l5ZKliE4rZUo2Ic0U34i0/VO1CmJhYWDyvMlhEXcAPhPvmQ9Zk1cx7WghRPYhfjFYPLKPa3jO6ueeIAx2lXI3dsuOWifR3+hfoNDrVv5BCFmtxPmqlRoypOq7Muqifi5PxGHFjoTO/F2oZVs6kQplkAumGyYEnGxYtSoYUOht9GcT2m2OVcG4D8ptvksn+FS8sJQdmvzB4nF2pUI8rwc2znVCJTU6j5n9aFUfKFIGDUMFICSpSNFQ/UdzbURSGSrnLTD8MJxE2yTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx3h0y6UYjUygMUCeUWSDtHYQbozDzBvDUymzCWSC/8=;
 b=gtcmBBeNtRCtnmPjCnERIdhKHBna3m3kOqzcZ985fr+0SMbzSjIy2OjSvhYfpVGvjHnBEiNQBnOYmtTzKfrTWwiFvut52B/ovogUQZkn9DNNAdi+T42gvA6mdOt4rVm6RcpMAUGaw5O+1F32GO3XAkQrbd+oIIe4F9cdFI52Rkg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 22:39:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 22:39:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 4/4] net: dsa: remove the DSA specific notifiers
Date:   Sat, 19 Dec 2020 00:38:52 +0200
Message-Id: <20201218223852.2717102-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM8P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::35) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 22:39:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45dba43f-6b65-4cae-b416-08d8a3a5c6a3
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26864CF69ACCAC01947F68CEE0C30@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44PrIBsO4D56649aRCaJOVMg5+p5Cv/YiklPx1TF0PCToOp+7npfQqIgrNuGfuXdokYjl6D78A0RiMxv7AaGEKqUTMQ2P5J8289i1xbWxw5vNvGPYxR7V63H1x9jOLnc2x9XsbDej1Zug2Iu3bU0UL8RyAtlNyukaTgKQAxYQ3NHXeTdarwT7Du/CRxlJXnbY/ojGFiY+ZR4xR/zcILDLiWfX6tUZCIJad7WxLa3mGLaOoEIVQl4qqdlPOvoB2NWN91gky5gqROdnf1D6IfgDgpqtnnt0thJKst2UxyQh/V8fdF7qQmaJGG90S0hYldwbAasWVfxpLCHHqzMAdyhcARhDlsnYZ5p78BDj9kLpCcfWqkYaIm3JzwtU1531NhbTW2aEjbGvex3EhZcDt4VPNarwgdQUVpiL5GHObgKrpEPnYDKG/iCLft5pifUiMcoQjI10xuGJ7D3yQYauJI79Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(52116002)(2616005)(66476007)(66556008)(956004)(83380400001)(478600001)(8936002)(69590400008)(86362001)(44832011)(66946007)(6512007)(36756003)(316002)(5660300002)(110136005)(16526019)(186003)(8676002)(26005)(6666004)(1076003)(6486002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4V29wezfnIIxjTxruEmVX7FPhzIljOUZLif7ReP1vW6bAhRrYpiPZEkS7g5H?=
 =?us-ascii?Q?8GGbMYziX2pYhjqB2Lr2zEphnKRCCi+WtC1DNnV/pW58AGLhTxXbBsjdkv8C?=
 =?us-ascii?Q?VZhWOLdELZiWq5UD3kV7o/3UUrSILgxVI5lwuuJEYa7XgC7dAjtM1WNvLN96?=
 =?us-ascii?Q?lCYWiRviqFsbAjPtd48VpixqnoXvwcZpoOkzm0/QxN4e7OVsRRdkq4kX9WTc?=
 =?us-ascii?Q?INSnLcgxR9SDtm1zo54S4RmEcvRLCU9ruuI/D1IGI/cbRuK35bUev+BMVMie?=
 =?us-ascii?Q?IqYpSQeIS7DajsnEc4D/okgHmNicmSJtVuh/Nb2RtBOVMlW3Wiz4o6FlaYcs?=
 =?us-ascii?Q?4zqf/fDhqYLlgxPAQ9dMJ52C1PSEpTu57PcRLRKSmiW8wO4jWZYVoIFdjZxX?=
 =?us-ascii?Q?m1KTr3YHmUSdkxEAcgHoKkpY98pW1+lL6unvCU+LJ9c5bzC5adqPA/aYP72J?=
 =?us-ascii?Q?WlibYtMxna5Oa05W4Qe0uiMohixcARAoOUACUwo2cUDoU7QlMeRoHgf3cUXN?=
 =?us-ascii?Q?zRvLN1TvRrr3L1gTQ11PS/Wyxd/PWrXq+2uXRxQdiWcx6trpEWpKynFEytSS?=
 =?us-ascii?Q?VNqwhpyWKtxBJYmRXjuyeCoy6C8B3o45dBTKCmFeXHUE84AMEFjytzatRSHj?=
 =?us-ascii?Q?Q6yuoTkSjRYs40DqFhvv8McIcNcgOS5JhEeAVFhZ62PgJn1C1XIlczA8/345?=
 =?us-ascii?Q?P7l9T/tdpwa5aLW94IrFg/DD4zc6QSIreVjPLskyS/LKPFliBwe4UiAXVoCs?=
 =?us-ascii?Q?Lxd6dEaeGfOQ2DdejNJZ1R6MDXGG4qtCsZfHSk9/tcxiGoGwYipULTEJa8p7?=
 =?us-ascii?Q?b4GlwwF/Ux6Rr6uoaqMWNz8U5bYGVKl4q833efzn/MGQYBnd0nAIAPHQrl3I?=
 =?us-ascii?Q?QuoSjkY9e0noUJtXoPwc/eGSkxpVsnkg4+cyc8ie5e6hgbi4pMn44yIiFXpu?=
 =?us-ascii?Q?WWACmYkzY4YTfEzjRWCPIFLAEMArQqnLQbq2/kUes94=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 22:39:26.9564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dba43f-6b65-4cae-b416-08d8a3a5c6a3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zp3t6Gz0aya6B2eJLMORdqlBcLrlteF5hTcJH9g1F/0TG0UtIPDBBJySIN4lzE43XSJH49CmNqPDGhOvXjbK+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This effectively reverts commit 60724d4bae14 ("net: dsa: Add support for
DSA specific notifiers"). The reason is that since commit 2f1e8ea726e9
("net: dsa: link interfaces with the DSA master to get rid of lockdep
warnings"), it appears that there is a generic way to achieve the same
purpose. The only user thus far, the Broadcom SYSTEMPORT driver, was
converted to use the generic notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 42 ------------------------------------------
 net/dsa/dsa.c     | 22 ----------------------
 net/dsa/slave.c   | 17 -----------------
 3 files changed, 81 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5badfd6403c5..3950e4832a33 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -828,51 +828,9 @@ static inline int dsa_switch_resume(struct dsa_switch *ds)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-enum dsa_notifier_type {
-	DSA_PORT_REGISTER,
-	DSA_PORT_UNREGISTER,
-};
-
-struct dsa_notifier_info {
-	struct net_device *dev;
-};
-
-struct dsa_notifier_register_info {
-	struct dsa_notifier_info info;	/* must be first */
-	struct net_device *master;
-	unsigned int port_number;
-	unsigned int switch_number;
-};
-
-static inline struct net_device *
-dsa_notifier_info_to_dev(const struct dsa_notifier_info *info)
-{
-	return info->dev;
-}
-
 #if IS_ENABLED(CONFIG_NET_DSA)
-int register_dsa_notifier(struct notifier_block *nb);
-int unregister_dsa_notifier(struct notifier_block *nb);
-int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-		       struct dsa_notifier_info *info);
 bool dsa_slave_dev_check(const struct net_device *dev);
 #else
-static inline int register_dsa_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
-static inline int unregister_dsa_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
-static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-				     struct dsa_notifier_info *info)
-{
-	return NOTIFY_DONE;
-}
-
 static inline bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return false;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..df75481b12ed 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -309,28 +309,6 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
-static ATOMIC_NOTIFIER_HEAD(dsa_notif_chain);
-
-int register_dsa_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&dsa_notif_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_dsa_notifier);
-
-int unregister_dsa_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&dsa_notif_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_dsa_notifier);
-
-int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-		       struct dsa_notifier_info *info)
-{
-	info->dev = dev;
-	return atomic_notifier_call_chain(&dsa_notif_chain, val, info);
-}
-EXPORT_SYMBOL_GPL(call_dsa_notifiers);
-
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c01bc7ebeb14..1b511895e7a5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1764,20 +1764,6 @@ int dsa_slave_resume(struct net_device *slave_dev)
 	return 0;
 }
 
-static void dsa_slave_notify(struct net_device *dev, unsigned long val)
-{
-	struct net_device *master = dsa_slave_to_master(dev);
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_notifier_register_info rinfo = {
-		.switch_number = dp->ds->index,
-		.port_number = dp->index,
-		.master = master,
-		.info.dev = dev,
-	};
-
-	call_dsa_notifiers(val, dev, &rinfo.info);
-}
-
 int dsa_slave_create(struct dsa_port *port)
 {
 	const struct dsa_port *cpu_dp = port->cpu_dp;
@@ -1863,8 +1849,6 @@ int dsa_slave_create(struct dsa_port *port)
 		goto out_gcells;
 	}
 
-	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
-
 	rtnl_lock();
 
 	ret = register_netdevice(slave_dev);
@@ -1913,7 +1897,6 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
-	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
 	free_percpu(slave_dev->tstats);
-- 
2.25.1

