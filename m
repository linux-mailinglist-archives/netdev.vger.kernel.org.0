Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2E464953
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347831AbhLAIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52913 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347848AbhLAIQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:48 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 47EBF5C01E1;
        Wed,  1 Dec 2021 03:13:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 01 Dec 2021 03:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=r5dvzfGCX1hf4N7j2OfS1cuFK0KUV/jjTwQeEsaXSUY=; b=GkZbxDTR
        4o5LCxaJI5IfJEfvU4m1NVUx55njKx5t3vjkgw6Fp79HdC3j05sKsuXTMDpYz/88
        4XAw0ZkfiNolahieOX/3bbBvNqO8M0vuwbiYdqUBkvcvEjMLj/Y0eS/6bbkLKrks
        h8ERM2vzOiIkz2rvMXiG+p6JEzYVyIaAhptOITe71ApBi7WSlhH62jCqakFr8aWO
        KtpnC/efimq3Ky6+CQXouJ18TVWKLE5s7ijreNA7YqUYDhYMfF4qJL7dj0Ty7WSb
        YunxKrtYMRAcpzzlpElvzLHYq+LnDbaRPlNyqzIHZUwa13wC8XKIpPBClk4HZH9k
        T9HLRWGemAtFAw==
X-ME-Sender: <xms:py6nYVvC7TuwSU36R1JsFZ0cDpA9jriAvw5_X2iGKeCuaZdJ21Y8cw>
    <xme:py6nYeees365vRpbDXGBJcQsHjUYGl42y3y0QfOnSeoKWKWwiNdvRoBlyzeB6q0Cp
    uXkAIGqh6vgQ-E>
X-ME-Received: <xmr:py6nYYyKkhns_JaRiGulKLniWbYsQ0SvadQzNKFEOjpUSxkqSHPyTXaBgaxBvMfGYDZ0X3g7DRGXbGNDNdd4X_xLIxR1cukQ4pEc2qUewhAC8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:py6nYcMx0vGvjWKNuhbZfCk_5199Td7SJgr6ZLISPcinbG5NoHZp3Q>
    <xmx:py6nYV8mPAXjyb1oZ1qJGGBmYAzLfpyIiM_0VU3mu3zqI-XzpDKGqw>
    <xmx:py6nYcVMkIcLc2d92upseVWetSj1maysFlkVk3aDVuwVhzOj1NQF-w>
    <xmx:py6nYRa0QLy-xPPKborKYNJPqJqFSYqc2fdpUREId9iGjpJsRHBLAg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: reg: Align existing registers to use extended local_port field
Date:   Wed,  1 Dec 2021 10:12:34 +0200
Message-Id: <20211201081240.3767366-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add support for 10-bit local ports in device registers by making use of the
MLXSW_ITEM32_LP() macro that was added in the previous patch.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 98 +++++++++++------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c67f43437158..86146910b9c2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -141,7 +141,7 @@ MLXSW_ITEM32(reg, sspr, m, 0x00, 31, 1);
  *
  * Access: RW
  */
-MLXSW_ITEM32(reg, sspr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, sspr, 0x00, 16, 0x00, 12);
 
 /* reg_sspr_sub_port
  * Virtual port within the physical port.
@@ -763,7 +763,7 @@ MLXSW_REG_DEFINE(spms, MLXSW_REG_SPMS_ID, MLXSW_REG_SPMS_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spms, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spms, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_spms_state {
 	MLXSW_REG_SPMS_STATE_NO_CHANGE,
@@ -815,7 +815,7 @@ MLXSW_ITEM32(reg, spvid, tport, 0x00, 24, 1);
  * When tport = 1: Tunnel port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spvid, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spvid, 0x00, 16, 0x00, 12);
 
 /* reg_spvid_sub_port
  * Virtual port within the physical port.
@@ -893,7 +893,7 @@ MLXSW_ITEM32(reg, spvm, pte, 0x00, 30, 1);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spvm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spvm, 0x00, 16, 0x00, 12);
 
 /* reg_spvm_sub_port
  * Virtual port within the physical port.
@@ -976,7 +976,7 @@ MLXSW_REG_DEFINE(spaft, MLXSW_REG_SPAFT_ID, MLXSW_REG_SPAFT_LEN);
  *
  * Note: CPU port is not supported (all tag types are allowed).
  */
-MLXSW_ITEM32(reg, spaft, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spaft, 0x00, 16, 0x00, 12);
 
 /* reg_spaft_sub_port
  * Virtual port within the physical port.
@@ -1379,7 +1379,7 @@ MLXSW_ITEM32(reg, slcr, pp, 0x00, 24, 1);
  * Reserved when pp = Global Configuration
  * Access: Index
  */
-MLXSW_ITEM32(reg, slcr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, slcr, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_slcr_type {
 	MLXSW_REG_SLCR_TYPE_CRC, /* default */
@@ -1497,7 +1497,7 @@ MLXSW_ITEM32(reg, slcor, col, 0x00, 30, 2);
  * Not supported for CPU port
  * Access: Index
  */
-MLXSW_ITEM32(reg, slcor, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, slcor, 0x00, 16, 0x00, 12);
 
 /* reg_slcor_lag_id
  * LAG Identifier. Index into the LAG descriptor table.
@@ -1565,7 +1565,7 @@ MLXSW_REG_DEFINE(spmlr, MLXSW_REG_SPMLR_ID, MLXSW_REG_SPMLR_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spmlr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spmlr, 0x00, 16, 0x00, 12);
 
 /* reg_spmlr_sub_port
  * Virtual port within the physical port.
@@ -1624,7 +1624,7 @@ MLXSW_ITEM32(reg, svfa, swid, 0x00, 24, 8);
  *
  * Note: Reserved for 802.1Q FIDs.
  */
-MLXSW_ITEM32(reg, svfa, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, svfa, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_svfa_mt {
 	MLXSW_REG_SVFA_MT_VID_TO_FID,
@@ -1715,7 +1715,7 @@ MLXSW_ITEM32(reg, spvtr, tport, 0x00, 24, 1);
  * When tport = 1: tunnel port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spvtr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spvtr, 0x00, 16, 0x00, 12);
 
 /* reg_spvtr_ippe
  * Ingress Port Prio Mode Update Enable.
@@ -1810,7 +1810,7 @@ MLXSW_REG_DEFINE(svpe, MLXSW_REG_SVPE_ID, MLXSW_REG_SVPE_LEN);
  *
  * Note: CPU port is not supported (uses VLAN mode only).
  */
-MLXSW_ITEM32(reg, svpe, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, svpe, 0x00, 16, 0x00, 12);
 
 /* reg_svpe_vp_en
  * Virtual port enable.
@@ -1930,7 +1930,7 @@ MLXSW_REG_DEFINE(spvmlr, MLXSW_REG_SPVMLR_ID, MLXSW_REG_SPVMLR_LEN);
  *
  * Note: CPU port is not supported.
  */
-MLXSW_ITEM32(reg, spvmlr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spvmlr, 0x00, 16, 0x00, 12);
 
 /* reg_spvmlr_num_rec
  * Number of records to update.
@@ -1991,7 +1991,7 @@ MLXSW_REG_DEFINE(spvc, MLXSW_REG_SPVC_ID, MLXSW_REG_SPVC_LEN);
  * through Rx port i and a Tx port j then port i and port j must have the
  * same configuration.
  */
-MLXSW_ITEM32(reg, spvc, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spvc, 0x00, 16, 0x00, 12);
 
 /* reg_spvc_inner_et2
  * Vlan Tag1 EtherType2 enable.
@@ -2086,7 +2086,7 @@ MLXSW_REG_DEFINE(spevet, MLXSW_REG_SPEVET_ID, MLXSW_REG_SPEVET_LEN);
  * Not supported to CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, spevet, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, spevet, 0x00, 16, 0x00, 12);
 
 /* reg_spevet_et_vlan
  * Egress EtherType VLAN to push when SPVID.egr_et_set field set for the packet:
@@ -2121,7 +2121,7 @@ MLXSW_REG_DEFINE(cwtp, MLXSW_REG_CWTP_ID, MLXSW_REG_CWTP_LEN);
  * Not supported for CPU port
  * Access: Index
  */
-MLXSW_ITEM32(reg, cwtp, local_port, 0, 16, 8);
+MLXSW_ITEM32_LP(reg, cwtp, 0x00, 16, 0x00, 12);
 
 /* reg_cwtp_traffic_class
  * Traffic Class to configure
@@ -2199,7 +2199,7 @@ MLXSW_REG_DEFINE(cwtpm, MLXSW_REG_CWTPM_ID, MLXSW_REG_CWTPM_LEN);
  * Not supported for CPU port
  * Access: Index
  */
-MLXSW_ITEM32(reg, cwtpm, local_port, 0, 16, 8);
+MLXSW_ITEM32_LP(reg, cwtpm, 0x00, 16, 0x00, 12);
 
 /* reg_cwtpm_traffic_class
  * Traffic Class to configure
@@ -2345,7 +2345,7 @@ MLXSW_ITEM32(reg, ppbt, op, 0x00, 28, 3);
  * Local port. Not including CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, ppbt, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, ppbt, 0x00, 16, 0x00, 12);
 
 /* reg_ppbt_g
  * group - When set, the binding is of an ACL group. When cleared,
@@ -3495,7 +3495,7 @@ MLXSW_REG_DEFINE(qpts, MLXSW_REG_QPTS_ID, MLXSW_REG_QPTS_LEN);
  *
  * Note: CPU port is supported.
  */
-MLXSW_ITEM32(reg, qpts, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qpts, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_qpts_trust_state {
 	MLXSW_REG_QPTS_TRUST_STATE_PCP = 1,
@@ -3699,7 +3699,7 @@ MLXSW_REG_DEFINE(qtct, MLXSW_REG_QTCT_ID, MLXSW_REG_QTCT_LEN);
  *
  * Note: CPU port is not supported.
  */
-MLXSW_ITEM32(reg, qtct, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qtct, 0x00, 16, 0x00, 12);
 
 /* reg_qtct_sub_port
  * Virtual port within the physical port.
@@ -3748,7 +3748,7 @@ MLXSW_REG_DEFINE(qeec, MLXSW_REG_QEEC_ID, MLXSW_REG_QEEC_LEN);
  *
  * Note: CPU port is supported.
  */
-MLXSW_ITEM32(reg, qeec, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qeec, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_qeec_hr {
 	MLXSW_REG_QEEC_HR_PORT,
@@ -3926,7 +3926,7 @@ MLXSW_REG_DEFINE(qrwe, MLXSW_REG_QRWE_ID, MLXSW_REG_QRWE_LEN);
  *
  * Note: CPU port is supported. No support for router port.
  */
-MLXSW_ITEM32(reg, qrwe, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qrwe, 0x00, 16, 0x00, 12);
 
 /* reg_qrwe_dscp
  * Whether to enable DSCP rewrite (default is 0, don't rewrite).
@@ -3967,7 +3967,7 @@ MLXSW_REG_DEFINE(qpdsm, MLXSW_REG_QPDSM_ID, MLXSW_REG_QPDSM_LEN);
  * Local Port. Supported for data packets from CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, qpdsm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qpdsm, 0x00, 16, 0x00, 12);
 
 /* reg_qpdsm_prio_entry_color0_e
  * Enable update of the entry for color 0 and a given port.
@@ -4053,7 +4053,7 @@ MLXSW_REG_DEFINE(qpdp, MLXSW_REG_QPDP_ID, MLXSW_REG_QPDP_LEN);
  * Local Port. Supported for data packets from CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, qpdp, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qpdp, 0x00, 16, 0x00, 12);
 
 /* reg_qpdp_switch_prio
  * Default port Switch Priority (default 0)
@@ -4088,7 +4088,7 @@ MLXSW_REG_DEFINE(qpdpm, MLXSW_REG_QPDPM_ID, MLXSW_REG_QPDPM_LEN);
  * Local Port. Supported for data packets from CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, qpdpm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qpdpm, 0x00, 16, 0x00, 12);
 
 /* reg_qpdpm_dscp_e
  * Enable update of the specific entry. When cleared, the switch_prio and color
@@ -4139,7 +4139,7 @@ MLXSW_REG_DEFINE(qtctm, MLXSW_REG_QTCTM_ID, MLXSW_REG_QTCTM_LEN);
  * No support for CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, qtctm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, qtctm, 0x00, 16, 0x00, 12);
 
 /* reg_qtctm_mc
  * Multicast Mode
@@ -4282,7 +4282,7 @@ MLXSW_ITEM32(reg, pmlp, rxtx, 0x00, 31, 1);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pmlp, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pmlp, 0x00, 16, 0x00, 12);
 
 /* reg_pmlp_width
  * 0 - Unmap local port.
@@ -4332,7 +4332,7 @@ MLXSW_REG_DEFINE(pmtu, MLXSW_REG_PMTU_ID, MLXSW_REG_PMTU_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pmtu, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pmtu, 0x00, 16, 0x00, 12);
 
 /* reg_pmtu_max_mtu
  * Maximum MTU.
@@ -4394,7 +4394,7 @@ MLXSW_ITEM32(reg, ptys, an_disable_admin, 0x00, 30, 1);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, ptys, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, ptys, 0x00, 16, 0x00, 12);
 
 #define MLXSW_REG_PTYS_PROTO_MASK_IB	BIT(0)
 #define MLXSW_REG_PTYS_PROTO_MASK_ETH	BIT(2)
@@ -4654,7 +4654,7 @@ MLXSW_ITEM32(reg, ppad, single_base_mac, 0x00, 28, 1);
  * port number, if single_base_mac = 0 then local_port is reserved
  * Access: RW
  */
-MLXSW_ITEM32(reg, ppad, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, ppad, 0x00, 16, 0x00, 24);
 
 /* reg_ppad_mac
  * If single_base_mac = 0 - base MAC address, mac[7:0] is reserved.
@@ -4693,7 +4693,7 @@ MLXSW_ITEM32(reg, paos, swid, 0x00, 24, 8);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, paos, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, paos, 0x00, 16, 0x00, 12);
 
 /* reg_paos_admin_status
  * Port administrative state (the desired state of the port):
@@ -4764,7 +4764,7 @@ MLXSW_REG_DEFINE(pfcc, MLXSW_REG_PFCC_ID, MLXSW_REG_PFCC_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pfcc, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pfcc, 0x00, 16, 0x00, 12);
 
 /* reg_pfcc_pnat
  * Port number access type. Determines the way local_port is interpreted:
@@ -4914,7 +4914,7 @@ MLXSW_ITEM32(reg, ppcnt, swid, 0x00, 24, 8);
  * for Set() operation.
  * Access: Index
  */
-MLXSW_ITEM32(reg, ppcnt, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, ppcnt, 0x00, 16, 0x00, 12);
 
 /* reg_ppcnt_pnat
  * Port number access type:
@@ -5412,7 +5412,7 @@ MLXSW_REG_DEFINE(plib, MLXSW_REG_PLIB_ID, MLXSW_REG_PLIB_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, plib, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, plib, 0x00, 16, 0x00, 12);
 
 /* reg_plib_ib_port
  * InfiniBand port remapping for local_port.
@@ -5450,7 +5450,7 @@ MLXSW_ITEM32(reg, pptb, mm, 0x00, 28, 2);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pptb, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pptb, 0x00, 16, 0x00, 12);
 
 /* reg_pptb_um
  * Enables the update of the untagged_buf field.
@@ -5527,7 +5527,7 @@ MLXSW_REG_DEFINE(pbmc, MLXSW_REG_PBMC_ID, MLXSW_REG_PBMC_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pbmc, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pbmc, 0x00, 16, 0x00, 12);
 
 /* reg_pbmc_xoff_timer_value
  * When device generates a pause frame, it uses this value as the pause
@@ -5643,7 +5643,7 @@ MLXSW_ITEM32(reg, pspa, swid, 0x00, 24, 8);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pspa, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pspa, 0x00, 16, 0x00, 0);
 
 /* reg_pspa_sub_port
  * Virtual port within the local port. Set to 0 when virtual ports are
@@ -5754,7 +5754,7 @@ MLXSW_REG_DEFINE(pplr, MLXSW_REG_PPLR_ID, MLXSW_REG_PPLR_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pplr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pplr, 0x00, 16, 0x00, 12);
 
 /* Phy local loopback. When set the port's egress traffic is looped back
  * to the receiver and the port transmitter is disabled.
@@ -5897,7 +5897,7 @@ MLXSW_REG_DEFINE(pddr, MLXSW_REG_PDDR_ID, MLXSW_REG_PDDR_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pddr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pddr, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_pddr_page_select {
 	MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO = 1,
@@ -5996,7 +5996,7 @@ MLXSW_REG_DEFINE(pllp, MLXSW_REG_PLLP_ID, MLXSW_REG_PLLP_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pllp, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pllp, 0x00, 16, 0x00, 12);
 
 /* reg_pllp_label_port
  * Front panel label of the port.
@@ -10227,7 +10227,7 @@ MLXSW_REG_DEFINE(mpar, MLXSW_REG_MPAR_ID, MLXSW_REG_MPAR_LEN);
  * The local port to mirror the packets from.
  * Access: Index
  */
-MLXSW_ITEM32(reg, mpar, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, mpar, 0x00, 16, 0x00, 4);
 
 enum mlxsw_reg_mpar_i_e {
 	MLXSW_REG_MPAR_TYPE_EGRESS,
@@ -10368,7 +10368,7 @@ MLXSW_REG_DEFINE(mlcr, MLXSW_REG_MLCR_ID, MLXSW_REG_MLCR_LEN);
  * Local port number.
  * Access: RW
  */
-MLXSW_ITEM32(reg, mlcr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, mlcr, 0x00, 16, 0x00, 24);
 
 #define MLXSW_REG_MLCR_DURATION_MAX 0xFFFF
 
@@ -10760,7 +10760,7 @@ MLXSW_REG_DEFINE(mpsc, MLXSW_REG_MPSC_ID, MLXSW_REG_MPSC_LEN);
  * Not supported for CPU port
  * Access: Index
  */
-MLXSW_ITEM32(reg, mpsc, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, mpsc, 0x00, 16, 0x00, 12);
 
 /* reg_mpsc_e
  * Enable sampling on port local_port
@@ -10985,7 +10985,7 @@ MLXSW_REG_DEFINE(momte, MLXSW_REG_MOMTE_ID, MLXSW_REG_MOMTE_LEN);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, momte, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, momte, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_momte_type {
 	MLXSW_REG_MOMTE_TYPE_WRED = 0x20,
@@ -11080,7 +11080,7 @@ MLXSW_REG_DEFINE(mtpptr, MLXSW_REG_MTPPTR_ID, MLXSW_REG_MTPPTR_LEN);
  * Not supported for CPU port.
  * Access: Index
  */
-MLXSW_ITEM32(reg, mtpptr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, mtpptr, 0x00, 16, 0x00, 12);
 
 enum mlxsw_reg_mtpptr_dir {
 	MLXSW_REG_MTPPTR_DIR_INGRESS,
@@ -11674,7 +11674,7 @@ MLXSW_REG_DEFINE(tnqdr, MLXSW_REG_TNQDR_ID, MLXSW_REG_TNQDR_LEN);
  * Local port number (receive port). CPU port is supported.
  * Access: Index
  */
-MLXSW_ITEM32(reg, tnqdr, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, tnqdr, 0x00, 16, 0x00, 12);
 
 /* reg_tnqdr_dscp
  * For encapsulation, the default DSCP.
@@ -12010,7 +12010,7 @@ MLXSW_REG_DEFINE(sbcm, MLXSW_REG_SBCM_ID, MLXSW_REG_SBCM_LEN);
  * For Egress: excludes IP Router
  * Access: Index
  */
-MLXSW_ITEM32(reg, sbcm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, sbcm, 0x00, 16, 0x00, 4);
 
 /* reg_sbcm_pg_buff
  * PG buffer - Port PG (dir=ingress) / traffic class (dir=egress)
@@ -12096,7 +12096,7 @@ MLXSW_REG_DEFINE(sbpm, MLXSW_REG_SBPM_ID, MLXSW_REG_SBPM_LEN);
  * For Egress: excludes IP Router
  * Access: Index
  */
-MLXSW_ITEM32(reg, sbpm, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, sbpm, 0x00, 16, 0x00, 12);
 
 /* reg_sbpm_pool
  * The pool associated to quota counting on the local_port.
@@ -12335,7 +12335,7 @@ MLXSW_REG_DEFINE(sbib, MLXSW_REG_SBIB_ID, MLXSW_REG_SBIB_LEN);
  * Not supported for CPU port and router port
  * Access: Index
  */
-MLXSW_ITEM32(reg, sbib, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, sbib, 0x00, 16, 0x00, 12);
 
 /* reg_sbib_buff_size
  * Units represented in cells
@@ -12538,7 +12538,7 @@ MLXSW_ITEM32(reg, pude, swid, 0x00, 24, 8);
  * Local port number.
  * Access: Index
  */
-MLXSW_ITEM32(reg, pude, local_port, 0x00, 16, 8);
+MLXSW_ITEM32_LP(reg, pude, 0x00, 16, 0x00, 12);
 
 /* reg_pude_admin_status
  * Port administrative state (the desired state).
-- 
2.31.1

