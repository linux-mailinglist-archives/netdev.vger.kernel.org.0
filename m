Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8202C33EE6D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhCQKjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53677 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229944AbhCQKjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A4505C0150;
        Wed, 17 Mar 2021 06:39:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=J2wKOlLuSXLSlw6J/ZfbbWr9AZq2jNaX+9rf7DJScCE=; b=hVCqA4GE
        +90e+Hio9ftbOeTh44Dn0h5XvbonMTCyhAg6eoPfNax01wF/WqKvVmRXqCERV+KC
        3KfAONFdwR0vQdW4TDcb4OIYHvrOp6B8rARJ0WmfelCIrFEmZhq2ngfs3ka3vBmc
        FNiJ5rHcG8Ioo9frHAqIqdB6JqtGyl0ghHt/71jfbWmedNKXrzQGvq4KkrsTUy9v
        UZ7e+f7aPkPvMMeY6mGfe6JPWu4j8Hmh70DgjmYHa7vyH8wz4DcGKKj5tmfPZcDI
        p2ervC6RGNDE7yWI6jKEEUWkoZIBWuNYFWgrU9w2sVEO+yxcn9vHYwooHxSz1QhD
        dXhEsqEneIJ8XA==
X-ME-Sender: <xms:VdxRYMsr-quSJUA61bxrtMhiOCYDmiSmTlFiF7FZVhgBm73Yek4x5g>
    <xme:VdxRYJcj962NK9Yhn05QuuEu0RCz8B2fjKPHZAEwdknMUA6AMCkFrzYcN7Xqz2fYc
    wxvJX8_erKYg44>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VdxRYHwpyNQB7ztYqqEBlQKy3mS6YAEjh4CtYNPi--8BhWr1dSsP-g>
    <xmx:VdxRYPN9snkP52Xn_e_ZQu60ET44mwhAjcXKCCp8ngc8wMKXtjzwRw>
    <xmx:VdxRYM-2b0DHm-wnC4lIskXn8B55BBloBTvlkMvJ6a_MuFA8-_ZNSw>
    <xmx:VdxRYAYgJ2c26nqGgNkwNMAsjwjZG2lDj73eFfNh0mYV7J9pXGUpUw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 350FC1080066;
        Wed, 17 Mar 2021 06:39:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] mlxsw: reg: Add egr_et_set field to SPVID
Date:   Wed, 17 Mar 2021 12:35:23 +0200
Message-Id: <20210317103529.2903172-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SPVID.egr_et_set=1 means that when VLAN is pushed at ingress (for untagged
packets or for QinQ push mode) then the EtherType is decided at the egress
port.

The next patches will use this field for VxLAN devices (tunnel port) in
order to allow using dual VxLAN bridges (802.1d and 802.1ad at the same
time).

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 44f836246e33..626f5e5c8a93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -842,6 +842,14 @@ MLXSW_ITEM32(reg, spvid, local_port, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, spvid, sub_port, 0x00, 8, 8);
 
+/* reg_spvid_egr_et_set
+ * When VLAN is pushed at ingress (for untagged packets or for
+ * QinQ push mode) then the EtherType is decided at the egress port.
+ * Reserved when Spectrum-1.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, spvid, egr_et_set, 0x04, 24, 1);
+
 /* reg_spvid_et_vlan
  * EtherType used for when VLAN is pushed at ingress (for untagged
  * packets or for QinQ push mode).
@@ -849,6 +857,7 @@ MLXSW_ITEM32(reg, spvid, sub_port, 0x00, 8, 8);
  * 1: ether_type1
  * 2: ether_type2 - Reserved when Spectrum-1, supported by Spectrum-2
  * Ethertype IDs are configured by SVER.
+ * Reserved when egr_et_set = 1.
  * Access: RW
  */
 MLXSW_ITEM32(reg, spvid, et_vlan, 0x04, 16, 2);
-- 
2.29.2

