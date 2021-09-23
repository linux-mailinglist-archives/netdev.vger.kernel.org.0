Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38FD415E80
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbhIWMj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50201 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241052AbhIWMjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C7AF5C0143;
        Thu, 23 Sep 2021 08:38:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4PpJPjzFBsreLZF+1G4ePG5T6iiURmk33hd/KH/EYFw=; b=CuFc8RLH
        XSpiTy0VoAvmDna8bPRlBbGQo8YQGA1GINhX5PdlfMy9dEy0qCD7fXtZxClms5ET
        pNBLB7EQpRQeiPZG8EyqysZf7pQsdz+eymobbgDBginj85OtdJMS5Q3/p5lQeQH0
        0s8MiW67H1SE35E74YPvfyBn3oefoV9YcwrcGrA/kFmXZ2KZ0dRPpAD4URjEYTJC
        xcsQ/gT258868WaEmsOfvZCJ3dF45CnYwUXiCekH00J6qOHSe7zFAV+/jpYhM+2K
        Fo7Fc/p1Ev7wKRxvYpTZ8FBondMynaKiQCz3PLUHRqjjAX3oFfxDojyA6CoxmTBF
        AWAO8i9R+GiCSg==
X-ME-Sender: <xms:PnVMYan1uhcXrGbIQ_Mv6vhKPQ-Wcn-DjCdMB6K9SqmWOAtaCS_VmA>
    <xme:PnVMYR2LEmGnUBQkAOm6p5zTLfgTWdYMYlAyhKO9Fb7WBwgJ2gR-JJaIpG-7Hywvi
    EF0PUvMIZfeMRU>
X-ME-Received: <xmr:PnVMYYqh_Vn7oHmYNKVSpojJb52Sj7_NjTRUmTl43ry5Ct3s-0eiwxgaF7Xre7yjWKXTddfV8IYeEk5oHGj2UM_kUgemN6xQx6LmIqQxXr6dVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PnVMYekvOwz8U5JNWk0j_3pMd7DTuKM5paE4rdv1NZxLIzpivBfvsQ>
    <xmx:PnVMYY2ATtcXr3UGEwZIfye74nBI6FLbDhF1rwtMxW5BgYPLWGvxlA>
    <xmx:PnVMYVsGznzcHRoARNMDrwtqluEXeio0OYItjqUAWBwVZOOpTIFENQ>
    <xmx:PnVMYc_s0Nrvd5SmI5ihdqW6Jbf4qIypBVU3vQZxiIrBWCPF_M47zQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/14] mlxsw: reg: Add support for ritr_loopback_ipip6_pack()
Date:   Thu, 23 Sep 2021 15:36:55 +0300
Message-Id: <20210923123700.885466-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The RITR register is used to configure the router interface table.

For IP-in-IP, it stores the underlay source IP address for encapsulation
and also the ingress RIF for the underlay lookup.

Add support for IPv6 IP-in-IP configuration.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5cc4b1ee7e7b..c5fad3c94fac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6734,6 +6734,23 @@ mlxsw_reg_ritr_loopback_ipip4_pack(char *payload,
 	mlxsw_reg_ritr_loopback_ipip_usip4_set(payload, usip);
 }
 
+static inline void
+mlxsw_reg_ritr_loopback_ipip6_pack(char *payload,
+				   enum mlxsw_reg_ritr_loopback_ipip_type ipip_type,
+				   enum mlxsw_reg_ritr_loopback_ipip_options options,
+				   u16 uvr_id, u16 underlay_rif,
+				   const struct in6_addr *usip, u32 gre_key)
+{
+	enum mlxsw_reg_ritr_loopback_protocol protocol =
+		MLXSW_REG_RITR_LOOPBACK_PROTOCOL_IPIP_IPV6;
+
+	mlxsw_reg_ritr_loopback_protocol_set(payload, protocol);
+	mlxsw_reg_ritr_loopback_ipip_common_pack(payload, ipip_type, options,
+						 uvr_id, underlay_rif, gre_key);
+	mlxsw_reg_ritr_loopback_ipip_usip6_memcpy_to(payload,
+						     (const char *)usip);
+}
+
 /* RTAR - Router TCAM Allocation Register
  * --------------------------------------
  * This register is used for allocation of regions in the TCAM table.
-- 
2.31.1

