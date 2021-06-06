Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4839CE23
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 10:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhFFI1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 04:27:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35513 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhFFI1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 04:27:11 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CAA215C01AE;
        Sun,  6 Jun 2021 04:25:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 06 Jun 2021 04:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=84kLIDzoa3JgNM6hauLK0/KbxKUqqROPBrOa3lXSSc4=; b=Tem6VjeQ
        hRz5iTZAHQ35kRCgaHD608+4EvpSDPdI+me/e3MnDPuKDNh3Z1aDc4BrQQ+6NJHJ
        uCnha+zASlVDLmTE+RnJZfaMQOGHkfjq6bu/SdkxOxKn3wYX57a0Eki9dy2bVusY
        xTSBCGBWegf1S+mUzFZS+JCXDQm2MFSPgcmJX+I0enpUNFIwi/gAB7sYDhcToiHr
        u1bnamiA768TIKzD588SQ6NcZK5XChsRUpiWVTvS0k7xKGtC8j08MUYd2Lm71P2A
        Kj5Jrxgv/e+QLcnx97juccEfrW8G8DGSk6SwGO5Ehf4vfd8Pp63vYTcaAMLCE6W6
        hWbYyUYDQX666A==
X-ME-Sender: <xms:cYa8YDX3tXLiU8p9viV16C10XEXIgkuKhfcIVnn02ERUFe7pwX2LKw>
    <xme:cYa8YLn7ZXbLYG5888LyEkI01e2Vd9vdsR_EOkke1LpYIYmZoIAaYE_3lE8zccwHp
    aPKALgHKD79nNk>
X-ME-Received: <xmr:cYa8YPa7gH3p_RTL6DxsIGFxBuOEnzG6xPrZUqKN6zOWQNhM7EJVnIpamOIxq4O6pKScRs09nELt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedthedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:cYa8YOV3Wvi68g3A6TRLcTCXuvzo9fKDSTL5TBum2s9K6GqacCCtDw>
    <xmx:cYa8YNmOnF_BFbjMPQ1EOPGWxzNS7ECN6qLVWQiRonf5wfzKJwIUvw>
    <xmx:cYa8YLdk8ry4sNPu1hnQwAaB7-u1bJRF5gfj4yZ-XimW7WkZY-E2Kw>
    <xmx:cYa8YLaTkxupZCxvc9z8e_dsC_bdEqVDnW0qvCF4CPJkKC1m44R3gA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Jun 2021 04:25:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Mykola Kostenok <c_mykolak@nvidia.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 3/3] mlxsw: core: Set thermal zone polling delay argument to real value at init
Date:   Sun,  6 Jun 2021 11:24:32 +0300
Message-Id: <20210606082432.1463577-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210606082432.1463577-1-idosch@idosch.org>
References: <20210606082432.1463577-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

Thermal polling delay argument for modules and gearboxes thermal zones
used to be initialized with zero value, while actual delay was used to
be set by mlxsw_thermal_set_mode() by thermal operation callback
set_mode(). After operations set_mode()/get_mode() have been removed by
cited commits, modules and gearboxes thermal zones always have polling
time set to zero and do not perform temperature monitoring.

Set non-zero "polling_delay" in thermal_zone_device_register() routine,
thus, the relevant thermal zones will perform thermal monitoring.

Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Fixes: 5d7bd8aa7c35 ("thermal: Simplify or eliminate unnecessary set_mode() methods")
Fixes: 1ee14820fd8e ("thermal: remove get_mode() operation of drivers")
Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index dfea14399607..85f0ce285146 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -693,7 +693,8 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
-							NULL, 0, 0);
+							NULL, 0,
+							module_tz->parent->polling_delay);
 	if (IS_ERR(module_tz->tzdev)) {
 		err = PTR_ERR(module_tz->tzdev);
 		return err;
@@ -815,7 +816,8 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 						MLXSW_THERMAL_TRIP_MASK,
 						gearbox_tz,
 						&mlxsw_thermal_gearbox_ops,
-						NULL, 0, 0);
+						NULL, 0,
+						gearbox_tz->parent->polling_delay);
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
 
-- 
2.31.1

