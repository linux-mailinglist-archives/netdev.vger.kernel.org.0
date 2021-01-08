Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FF2EF43C
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbhAHOxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:53:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34559 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbhAHOxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:53:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D724A5C02E3;
        Fri,  8 Jan 2021 09:52:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 08 Jan 2021 09:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=fqlqPFT9FgUnhyI5sLeqwH906yHCiqH5VWEUeqUKZi8=; b=TSaglgC8
        3Jcn1ibPwJ2batMun6JSrInNrY4OXvnhG3gdcDJTotPPL+EuHmkqeNhvZEESNUog
        h6/PjXAGEaNiJhrGy/6ywBHdxI+ZH/EW54SnqlaHQarfAYxMMMoX0V78VShZL5FC
        gW+ty5w2wVBLM6N+2B+oZdd47yTqfaKkrvZ+s0O0R7Ww9Vj7Bc/VvEsFNP79ddBY
        cmi3M+57XP/8pv76dX8vdo2L89sH2yrid6ipJoKmA3e4Mz87DFHgiPtqTa9RTBc3
        Jb/BwDrRSTTDmwzMKKFzs/DIFpaOfhjj3e4USKC23jJH+P5hw61ayT/SBfTbQ6Cb
        q+7zlA6rD2O6uQ==
X-ME-Sender: <xms:yXH4X8Kvc7K1ej673k7xR3qBZ7Y9BMD5Pq-2Bnlcd3dYV3_WemzGAg>
    <xme:yXH4X3kzSy3nghSG9yWHcUU7vR0SRT5hroDUHndxGz-78ercczcWEwcy8gfLLhd0j
    kqoKDU_n5dgqJ0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yXH4X7bGwIqn8LQFCVEyiVG2A8toxAkqBvI3jy85di5SgsW_Nk6ZCw>
    <xmx:yXH4X2hOBqOXlaId9IXxgAtDUaKulaiOz5MBxbgdM2PowkTuCBWCbA>
    <xmx:yXH4X5weS7TmWqbzwmW46MJR-vzV4L2vKpcrMS6AvFvT2gE2Atn1EQ>
    <xmx:yXH4X2t004_kT42ge3nF1hPwUVi4wG1RwCmPzRXNB4tBn6_co4pN0g>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0AF924005D;
        Fri,  8 Jan 2021 09:52:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, vadimp@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] mlxsw: core: Increase critical threshold for ASIC thermal zone
Date:   Fri,  8 Jan 2021 16:52:10 +0200
Message-Id: <20210108145210.1229820-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108145210.1229820-1-idosch@idosch.org>
References: <20210108145210.1229820-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Increase critical threshold for ASIC thermal zone from 110C to 140C
according to the system hardware requirements. All the supported ASICs
(Spectrum-1, Spectrum-2, Spectrum-3) could be still operational with ASIC
temperature below 140C. With the old critical threshold value system
can perform unjustified shutdown.

All the systems equipped with the above ASICs implement thermal
protection mechanism at firmware level and firmware could decide to
perform system thermal shutdown in case the temperature is below 140C.
So with the new threshold system will not meltdown, while thermal
operating range will be aligned with hardware abilities.

Fixes: 41e760841d26 ("mlxsw: core: Replace thermal temperature trips with defines")
Fixes: a50c1e35650b ("mlxsw: core: Implement thermal zone")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 250a85049697..bf85ce9835d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -19,7 +19,7 @@
 #define MLXSW_THERMAL_ASIC_TEMP_NORM	75000	/* 75C */
 #define MLXSW_THERMAL_ASIC_TEMP_HIGH	85000	/* 85C */
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
-#define MLXSW_THERMAL_ASIC_TEMP_CRIT	110000	/* 110C */
+#define MLXSW_THERMAL_ASIC_TEMP_CRIT	140000	/* 140C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16
-- 
2.29.2

