Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE473078AB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhA1Ovx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:51:53 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46199 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232439AbhA1OuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:50:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8DD2DF76;
        Thu, 28 Jan 2021 09:48:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 28 Jan 2021 09:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=kCENEof4qEDNvnwjhWFaIwzisM1j3llT98XyPi1J59E=; b=X28O0iY0
        RNQQYtfwrrgZEj6cgPJ2WiD7Xy7XVZ0dYC5FH6AbO3F1piKQZdAnKjQy63KnXhgu
        PVf1AlthzHgmpZxjd87hH3Prmlew5U5ANrbxeAy8DeW6cqSdSGe2idb8iYoHOb1m
        P8rucMLkgLveatPKNUZjjG+wCSGf+mm6NoJZvtN5mjDlngPPniztXhEW8tWnx2CF
        j+XcnyLD2CJRHsEsg2KnW15QKidLhGG72Bes5NnCrbd4TEuHSHLib22Vp0Bk3s6S
        SfEncyfBIVhktQiHe0sT2siHNwMI8HhQl2L9iGJyQssz/dyOr9nd+9rI5H4+rnnZ
        LUiiLm9xe4YJEg==
X-ME-Sender: <xms:284SYNebOFbZ-piQJICRvA7RvBEBEo2pEyDzNAVKXSYJ4P3C03EePA>
    <xme:284SYLOgR_bJI-WXdsmDtUVaX0cEu-8jcov2Htxn2XnkGFvGYwF5SfZQHFJ033MFU
    D-hks4tjQWBCu0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:284SYGiWRI2MlKovH9neyXTDoSXU5SQZlVGmJT0cr17WDRaMGBXe9Q>
    <xmx:284SYG_mGOKlmfGXhgGghDY1IeDEQnsTPxDseHityqi6cG58RPf0OQ>
    <xmx:284SYJubOZCigf6CWcRDr4PKB8z-kABIk8shLN_yX91np1Ob_eODJQ>
    <xmx:284SYBK-05up3qj3bRMOi6iQw0F5j3oCA3jXwmoUWgRWw7sBsN_S4w>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C46B240064;
        Thu, 28 Jan 2021 09:48:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] mlxsw: spectrum_span: Do not overwrite policer configuration
Date:   Thu, 28 Jan 2021 16:48:20 +0200
Message-Id: <20210128144820.3280295-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144820.3280295-1-idosch@idosch.org>
References: <20210128144820.3280295-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The purpose of the delayed work in the SPAN module is to potentially
update the destination port and various encapsulation parameters of SPAN
agents that point to a VLAN device or a GRE tap. The destination port
can change following the insertion of a new route, for example.

SPAN agents that point to a physical port or the CPU port are static and
never change throughout the lifetime of the SPAN agent. Therefore, skip
over them in the delayed work.

This fixes an issue where the delayed work overwrites the policer
that was set on a SPAN agent pointing to the CPU. Modifying the delayed
work to inherit the original policer configuration is error-prone, as
the same will be needed for any new parameter.

Fixes: 4039504e6a0c ("mlxsw: spectrum_span: Allow setting policer on a SPAN agent")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index c6c5826aba41..1892cea05ee7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -157,6 +157,7 @@ mlxsw_sp1_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp1_span_entry_ops_cpu = {
+	.is_static = true,
 	.can_handle = mlxsw_sp1_span_cpu_can_handle,
 	.parms_set = mlxsw_sp1_span_entry_cpu_parms,
 	.configure = mlxsw_sp1_span_entry_cpu_configure,
@@ -214,6 +215,7 @@ mlxsw_sp_span_entry_phys_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_phys = {
+	.is_static = true,
 	.can_handle = mlxsw_sp_port_dev_check,
 	.parms_set = mlxsw_sp_span_entry_phys_parms,
 	.configure = mlxsw_sp_span_entry_phys_configure,
@@ -721,6 +723,7 @@ mlxsw_sp2_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp2_span_entry_ops_cpu = {
+	.is_static = true,
 	.can_handle = mlxsw_sp2_span_cpu_can_handle,
 	.parms_set = mlxsw_sp2_span_entry_cpu_parms,
 	.configure = mlxsw_sp2_span_entry_cpu_configure,
@@ -1036,6 +1039,9 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 		if (!refcount_read(&curr->ref_count))
 			continue;
 
+		if (curr->ops->is_static)
+			continue;
+
 		err = curr->ops->parms_set(mlxsw_sp, curr->to_dev, &sparms);
 		if (err)
 			continue;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index d907718bc8c5..aa1cd409c0e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -60,6 +60,7 @@ struct mlxsw_sp_span_entry {
 };
 
 struct mlxsw_sp_span_entry_ops {
+	bool is_static;
 	bool (*can_handle)(const struct net_device *to_dev);
 	int (*parms_set)(struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *to_dev,
-- 
2.29.2

