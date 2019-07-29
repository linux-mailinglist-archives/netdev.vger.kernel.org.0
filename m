Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D479076
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfG2QMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:12:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40730 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfG2QMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:12:18 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7556920035A;
        Mon, 29 Jul 2019 18:12:16 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 68CDB200344;
        Mon, 29 Jul 2019 18:12:16 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 02902205F3;
        Mon, 29 Jul 2019 18:12:15 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@mellanox.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 1/5] staging: fsl-dpaa2/ethsw: remove unused structure
Date:   Mon, 29 Jul 2019 19:11:48 +0300
Message-Id: <1564416712-16946-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpsw_cfg structure is only used when creating a new dpsw DPAA2
object. In the DPAA2 architecture, objects are created at boot time by
the firmware or dynamically from userspace while drivers on the fsl-mc
bus only configure those objects.
Remove the structure since it's of no use.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 25635259ce44..0d9330e01915 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -75,37 +75,6 @@ enum dpsw_component_type {
 	DPSW_COMPONENT_TYPE_S_VLAN
 };
 
-/**
- * struct dpsw_cfg - DPSW configuration
- * @num_ifs: Number of external and internal interfaces
- * @adv: Advanced parameters; default is all zeros;
- *	 use this structure to change default settings
- * @adv.options: Enable/Disable DPSW features (bitmap)
- * @adv.max_vlans: Maximum Number of VLAN's; 0 - indicates default 16
- * @adv.max_meters_per_if: Number of meters per interface
- * @adv.max_fdbs: Maximum Number of FDB's; 0 - indicates default 16
- * @adv.max_fdb_entries: Number of FDB entries for default FDB table;
- *	0 - indicates default 1024 entries.
- * @adv.fdb_aging_time: Default FDB aging time for default FDB table;
- *	0 - indicates default 300 seconds
- * @adv.max_fdb_mc_groups: Number of multicast groups in each FDB table;
- *	0 - indicates default 32
- * @adv.component_type: Indicates the component type of this bridge
- */
-struct dpsw_cfg {
-	u16 num_ifs;
-	struct {
-		u64 options;
-		u16 max_vlans;
-		u8 max_meters_per_if;
-		u8 max_fdbs;
-		u16 max_fdb_entries;
-		u16 fdb_aging_time;
-		u16 max_fdb_mc_groups;
-		enum dpsw_component_type component_type;
-	} adv;
-};
-
 int dpsw_enable(struct fsl_mc_io *mc_io,
 		u32 cmd_flags,
 		u16 token);
-- 
1.9.1

