Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D702C1F1B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgKXHqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:46:48 -0500
Received: from mailout02.rmx.de ([62.245.148.41]:56715 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgKXHqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:46:48 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4CgGLT0rjjzNnGM;
        Tue, 24 Nov 2020 08:46:41 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CgGKV2GWYz2xFT;
        Tue, 24 Nov 2020 08:45:50 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.100) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Nov
 2020 08:45:32 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 2/3] mlxsw: spectrum_ptp: use PTP wide message type definitions
Date:   Tue, 24 Nov 2020 08:44:17 +0100
Message-ID: <20201124074418.2609-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124074418.2609-1-ceggers@arri.de>
References: <20201124074418.2609-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.100]
X-RMX-ID: 20201124-084558-4CgGKV2GWYz2xFT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use recently introduced PTP wide defines instead of a driver internal
enumeration.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Cc: Petr Machata <petrm@mellanox.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h | 7 -------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ca8090a28dec..d6e9ecb14681 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -828,10 +828,10 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_hashtable_init;
 
 	/* Delive these message types as PTP0. */
-	message_type = BIT(MLXSW_SP_PTP_MESSAGE_TYPE_SYNC) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP);
+	message_type = BIT(PTP_MSGTYPE_SYNC) |
+		       BIT(PTP_MSGTYPE_DELAY_REQ) |
+		       BIT(PTP_MSGTYPE_PDELAY_REQ) |
+		       BIT(PTP_MSGTYPE_PDELAY_RESP);
 	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
 				      message_type);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 8c386571afce..1d43a3755285 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -11,13 +11,6 @@ struct mlxsw_sp;
 struct mlxsw_sp_port;
 struct mlxsw_sp_ptp_clock;
 
-enum {
-	MLXSW_SP_PTP_MESSAGE_TYPE_SYNC,
-	MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ,
-	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ,
-	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP,
-};
-
 static inline int mlxsw_sp_ptp_get_ts_info_noptp(struct ethtool_ts_info *info)
 {
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

