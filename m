Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C61459D30
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhKWH5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:57:08 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59707 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233578AbhKWH5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:57:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 42FCC5C0191;
        Tue, 23 Nov 2021 02:54:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Nov 2021 02:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1QDl3ZLRZ0zsahA7oq4TL0jRiFnES/k+Fvpx+yPHCwQ=; b=n4RrS/It
        m5b8CqlkaEPyE6RSNDW1AaZcX29TQxeZDmGMWN64B0eegT+G/aL3sjw65VOjrpIa
        SlUzKcO5XExKMuAt6LEOYRodhVGdG+6WKq4UQtI0oiqXK3S1OOtSF3Gr0Zx83HiA
        iHMdEHpv4i6XbjoVcRxW6DobpKVnxQNTad6UoAtQdLAMTkSCMWa6MRLF0aT9V+OZ
        16L3f9lfE92c/z8j9VUsaQtzStPINgaj33EM1oJc16BesD8p+uIsXSWaGiBjBTjw
        IuZ813M+DSCYbgf2jvKoieQW+hJG/5xqOAgZasKlIpH2qzV4nqpsa1SgnoHQgtUc
        xrj39wR/rjBsqA==
X-ME-Sender: <xms:GJ6cYf1y28GSK9mvMDvrtFrwILzYHyNxzLlR_-eAKawZ-WGEUgKOqw>
    <xme:GJ6cYeFf8WIyfKvjhof7TuKxwuq2eF28w2iAah_Mg5lO56Ey94wH0QMp4Usbbv-ds
    mRyBaRowJaJ120>
X-ME-Received: <xmr:GJ6cYf5QtnXVcZQuoX_grb3arQLdsscIKpp2WsKeAfaLpyoGBEt7Tb6AQ0LQWhqcg3uE7-UiMD-o209w1git7LJymeTkzgsxal-pRCW_p-VJWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GJ6cYU0ccB4moX0pM3O0LkF5G8hwmnHc-JqdpgkNBnC89kwIQXPBNw>
    <xmx:GJ6cYSH_aMioITNVv4YsEIT1T2_SSi1cltMjKm0v4yvb_rxxaxjGmw>
    <xmx:GJ6cYV_jPvsTPlKoiOlnaoxpToC9vFBroRswDrI23YFnUNhK3EpcgQ>
    <xmx:GJ6cYehPRsk8tfysPKRKdHv7G31g2FSJftATP1zvVGPmRx9MZAhtxA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 02:53:58 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] mlxsw: spectrum: Allow driver to load with old firmware versions
Date:   Tue, 23 Nov 2021 09:52:55 +0200
Message-Id: <20211123075256.3083281-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123075256.3083281-1-idosch@idosch.org>
References: <20211123075256.3083281-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The driver fails to load with old firmware versions that cannot report
the maximum number of RIF MAC profiles [1].

Fix this by defaulting to a maximum of a single profile in such
situations, as multiple profiles are not supported by old firmware
versions.

[1]
mlxsw_spectrum 0000:03:00.0: cannot register bus device
mlxsw_spectrum: probe of 0000:03:00.0 failed with error -5

Fixes: 1c375ffb2efab ("mlxsw: spectrum_router: Expose RIF MAC profiles to devlink resource")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4ce07f9905f6..41da3895d97f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3290,10 +3290,10 @@ mlxsw_sp_resources_rif_mac_profile_register(struct mlxsw_core *mlxsw_core)
 	u8 max_rif_mac_profiles;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_RIF_MAC_PROFILES))
-		return -EIO;
-
-	max_rif_mac_profiles = MLXSW_CORE_RES_GET(mlxsw_core,
-						  MAX_RIF_MAC_PROFILES);
+		max_rif_mac_profiles = 1;
+	else
+		max_rif_mac_profiles = MLXSW_CORE_RES_GET(mlxsw_core,
+							  MAX_RIF_MAC_PROFILES);
 	devlink_resource_size_params_init(&size_params, max_rif_mac_profiles,
 					  max_rif_mac_profiles, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-- 
2.31.1

