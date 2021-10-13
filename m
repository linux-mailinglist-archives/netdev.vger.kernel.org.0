Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A692F42BD34
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhJMKka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35833 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229516AbhJMKk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 44D805C00CF;
        Wed, 13 Oct 2021 06:38:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 13 Oct 2021 06:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=O4oBXtvzJw7NYkkSbdFWUDzupiX7DCbf1LIsd9tINd0=; b=DSh26OzB
        PJ4nIPeFOC0N+dr+r/2b7tCMIb/V4xxPVyrkP2Il6Fl0NoMBTXneI0K6DR6iQghu
        0uIt/Cqx0LKrCeUWkvQrxoOSMDOkctRVjokyi7NMyFNy1OiDYkXMds1Pb4ifxFMI
        JpeYwIQJUTjWE3LX+E/ThHaxqJR5X+evG5QTTJbcm2XNOjOzKGxjs1cC/Qf5uEID
        1RLqnKbVk69kbTXO/mlLH3fxCeBdRH0p4QerJy6wYDxENoT8w8YId+caNom0eDQx
        sUhR2IbJ4nWwiYvB4EtC20enj+F7f9VmrX+zloFxCwc75mbs8Q+RWCswj2vNWFX2
        V3kIGkuNnSibow==
X-ME-Sender: <xms:IrdmYVuIW4NSsn7uqhT0h6KQHFLEkT-GH1eFKoj1h-esvQbK11ofzA>
    <xme:IrdmYefsVBAwzr8hfk1INQLUsh2x4Yzi7hH8v6Y306PcAP8PsIf6SGclpykdPS-_E
    rFaOWspzQz2I2g>
X-ME-Received: <xmr:IrdmYYzAVO9GxigRUYzotciaTfphF9cGjkSl9UC4nt2gOOwhQLCkMSr-2_r_uGbDmvI-ov_INptMekuLv-3PdrYFrC3_pj2cgzuiFfNU9x9WBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IrdmYcMvBzotes24e5JZbqc2S5EanTM-Wq68Pe5Ck9C6O7Cj3v48kw>
    <xmx:IrdmYV9MAIg2uDg06waYUU9otaN_4MoraaX13MGHqAXl4Soq3oTNbw>
    <xmx:IrdmYcV6OHdZK_VM3UtJLeRUnmqMHoq_CqTVQp8QDgY4F5bIcYXlqw>
    <xmx:IrdmYRYKTUJWDLAXmY7vkBU_lzmCO7-H7arwbZnGIvyPSnw6hK62UQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_qdisc: Introduce per-TC ECN counters
Date:   Wed, 13 Oct 2021 13:37:47 +0300
Message-Id: <20211013103748.492531-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
References: <20211013103748.492531-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The Qdisc code in mlxsw used to report a number of packets ECN-marked on a
port. Because reporting a per-port value as a per-TC value was misleading,
this was removed in commit 8a29581eb001 ("mlxsw: spectrum: Move the
ECN-marked packet counter to ethtool").

On Spectrum-3, a per-TC number of ECN-marked packets is available in per-TC
congestion counter group. Add a new array for the ECN counter, fetch the
values from the per-TC congestion group, and pick the value indicated by
tclass_num as appropriate.

On Spectrum-1 and Spectrum-2, this per-TC value is not available, and
zeroes will be reported, as they currently are.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       | 10 +++++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h       |  1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |  9 +++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 67529e9537a6..d05850ff3a77 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -826,10 +826,14 @@ mlxsw_sp_port_get_hw_xstats(struct net_device *dev,
 		err = mlxsw_sp_port_get_stats_raw(dev,
 						  MLXSW_REG_PPCNT_TC_CONG_CNT,
 						  i, ppcnt_pl);
-		if (!err)
-			xstats->wred_drop[i] =
-				mlxsw_reg_ppcnt_wred_discard_get(ppcnt_pl);
+		if (err)
+			goto tc_cnt;
+
+		xstats->wred_drop[i] =
+			mlxsw_reg_ppcnt_wred_discard_get(ppcnt_pl);
+		xstats->tc_ecn[i] = mlxsw_reg_ppcnt_ecn_marked_tc_get(ppcnt_pl);
 
+tc_cnt:
 		err = mlxsw_sp_port_get_stats_raw(dev, MLXSW_REG_PPCNT_TC_CNT,
 						  i, ppcnt_pl);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index aae1aed5345b..3ab57e98cad2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -285,6 +285,7 @@ struct mlxsw_sp_port_vlan {
 /* No need an internal lock; At worse - miss a single periodic iteration */
 struct mlxsw_sp_port_xstats {
 	u64 ecn;
+	u64 tc_ecn[TC_MAX_QUEUE];
 	u64 wred_drop[TC_MAX_QUEUE];
 	u64 tail_drop[TC_MAX_QUEUE];
 	u64 backlog[TC_MAX_QUEUE];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index e367c63e72bf..6d1431fa31d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -519,6 +519,7 @@ mlxsw_sp_setup_tc_qdisc_red_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					       mlxsw_sp_qdisc->prio_bitmap,
 					       &stats_base->tx_packets,
 					       &stats_base->tx_bytes);
+	red_base->prob_mark = xstats->tc_ecn[tclass_num];
 	red_base->prob_drop = xstats->wred_drop[tclass_num];
 	red_base->pdrop = mlxsw_sp_xstats_tail_drop(xstats, tclass_num);
 
@@ -618,19 +619,22 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *res = xstats_ptr;
-	int early_drops, pdrops;
+	int early_drops, marks, pdrops;
 
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 
 	early_drops = xstats->wred_drop[tclass_num] - xstats_base->prob_drop;
+	marks = xstats->tc_ecn[tclass_num] - xstats_base->prob_mark;
 	pdrops = mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
 		 xstats_base->pdrop;
 
 	res->pdrop += pdrops;
 	res->prob_drop += early_drops;
+	res->prob_mark += marks;
 
 	xstats_base->pdrop += pdrops;
 	xstats_base->prob_drop += early_drops;
+	xstats_base->prob_mark += marks;
 	return 0;
 }
 
@@ -648,7 +652,8 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 
 	mlxsw_sp_qdisc_get_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc, stats_ptr);
-	overlimits = xstats->wred_drop[tclass_num] - stats_base->overlimits;
+	overlimits = xstats->wred_drop[tclass_num] +
+		     xstats->tc_ecn[tclass_num] - stats_base->overlimits;
 
 	stats_ptr->qstats->overlimits += overlimits;
 	stats_base->overlimits += overlimits;
-- 
2.31.1

