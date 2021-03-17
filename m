Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3CA33EE6E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCQKjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51653 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229946AbhCQKjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F8285C014E;
        Wed, 17 Mar 2021 06:39:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YJKf75UtXpvMRUsVC7eRoSY//WeMzqX8I9F5+PMXwN0=; b=SUYpMdBu
        NfaaOA2cNdcdxSsiZoKz3BsP3d2HTWYtsq5UrvhoW4t+d8Z6wSlducRbrqWjx7Ak
        AjTk9FiDsFdzJ5d/7UZN3AeOdOTQDILFBYYcKIvaAoV87KLEwF78W7iMJDHTX919
        mX9xTZPOxJP5iyfVbU0C1mWhJrrG3PXbDVZMswgWHYsoWKwP02SbgO8hgp+H8+6I
        JvCI3VY92SR0fzV/H40uA+l5fBHCUF8xoZ7dk3VstwudeNXXQqvqi7akE84UGz0Q
        1Efbz52cqweA7T9SZQAkFbZYBfusPs3NCR3seSsmHpZDIawf1nO0irEyqlQuelDE
        JhXm7Es2jaOpCw==
X-ME-Sender: <xms:V9xRYCrAFUiM0il0gjfChfyo-8v23jTOrjK-WcJRMjjb_I-stdV90A>
    <xme:V9xRYAqqlhZZzoIfJKU-pRVMtub9NcDP_EtPwUqCGlTqZe8F7JO32Wg5eFrxnZkXW
    uOtGNXMPMAcPYY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:V9xRYHO6g18AsI5NKex2kfMHdyQdokbDvW2FDETol7EOPquht6Rk8w>
    <xmx:V9xRYB4hgeVjGkSoOoU-CE4AfmoBdvtRc0aZBesLCk71GbCHg0MiIw>
    <xmx:V9xRYB7Sp4MRs11HNXmTwVKQpHZA6T4hz0MRkeO3KhX4z4YRSOtkog>
    <xmx:V9xRYE2P3hhPHiLCJ8K5uQQYlxiW6t-82gQeQjqEKRNYMsBles_LRg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E2171080063;
        Wed, 17 Mar 2021 06:39:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] mlxsw: reg: Add Switch Port Egress VLAN EtherType Register
Date:   Wed, 17 Mar 2021 12:35:24 +0200
Message-Id: <20210317103529.2903172-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SPEVET configures which EtherType to push at egress for packets incoming
through a local port for which 'SPVID.egr_et_set' is set.

The next patches will use SPEVET to configure EtherType 0x88A8 and
0x8100 for local ports member in 802.1ad and 802.1q bridges,
respectively. This allows using dual VxLAN bridges (802.1d and 802.1ad at
the same time).

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 36 +++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 626f5e5c8a93..d33c79ad1810 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2088,6 +2088,41 @@ static inline void mlxsw_reg_spvc_pack(char *payload, u8 local_port, bool et1,
 	mlxsw_reg_spvc_et0_set(payload, et0);
 }
 
+/* SPEVET - Switch Port Egress VLAN EtherType
+ * ------------------------------------------
+ * The switch port egress VLAN EtherType configures which EtherType to push at
+ * egress for packets incoming through a local port for which 'SPVID.egr_et_set'
+ * is set.
+ */
+#define MLXSW_REG_SPEVET_ID 0x202A
+#define MLXSW_REG_SPEVET_LEN 0x08
+
+MLXSW_REG_DEFINE(spevet, MLXSW_REG_SPEVET_ID, MLXSW_REG_SPEVET_LEN);
+
+/* reg_spevet_local_port
+ * Egress Local port number.
+ * Not supported to CPU port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, spevet, local_port, 0x00, 16, 8);
+
+/* reg_spevet_et_vlan
+ * Egress EtherType VLAN to push when SPVID.egr_et_set field set for the packet:
+ * 0: ether_type0 - (default)
+ * 1: ether_type1
+ * 2: ether_type2
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, spevet, et_vlan, 0x04, 16, 2);
+
+static inline void mlxsw_reg_spevet_pack(char *payload, u8 local_port,
+					 u8 et_vlan)
+{
+	MLXSW_REG_ZERO(spevet, payload);
+	mlxsw_reg_spevet_local_port_set(payload, local_port);
+	mlxsw_reg_spevet_et_vlan_set(payload, et_vlan);
+}
+
 /* CWTP - Congetion WRED ECN TClass Profile
  * ----------------------------------------
  * Configures the profiles for queues of egress port and traffic class
@@ -12026,6 +12061,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(sfmr),
 	MLXSW_REG(spvmlr),
 	MLXSW_REG(spvc),
+	MLXSW_REG(spevet),
 	MLXSW_REG(cwtp),
 	MLXSW_REG(cwtpm),
 	MLXSW_REG(pgcr),
-- 
2.29.2

