Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220BD2EF43B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbhAHOxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:53:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48373 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbhAHOxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:53:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E5E85C02C0;
        Fri,  8 Jan 2021 09:52:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 08 Jan 2021 09:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=n7ZV//HxK19udrI8a5sOZAQ+DSCDuSzroWTDmGb2V80=; b=Q4AxLpP3
        klFuPrs9E/XU0AhqUobScn7rakxw2OppVFKE+diQw+7JPUxS7MGxxYfKZm3bbOQn
        pg4Aj3CgL/wUYx22lS6PibGuM/Jpuk9U3tQ+FmHezLfaJFA7H5Xu41B1qPzmXKQV
        sVgjiPFzMlGrlQ/KPX7OWmo/Npp/U/4TufPZDr44h5zAprJbJsvEGQg9rZUdwVjT
        FNTOFjUxflKUfQHbBHGx9bwK1wQR5hYoOGeqGNohtgRSFxVtpihhsGt8bYpZDwB/
        xmT14ExN8X8SuAM6teAJ6jBn5ijnWzNbxNOHnK9eGNBW3M7KoGcSh4jceoF6E3N+
        t3QFhgp3t2Q3KA==
X-ME-Sender: <xms:x3H4X26h5D_RFK8Pa5F3ThWgWvHYQvHCMaTnZrg3CnAFzDMDH-nXnw>
    <xme:x3H4X7HNyKKM8rWF2-Ee1QDqbeYY0sP1cRV84zxe_05Q_udfWKsjhVzJe9TYWZJfK
    c8UK9tHPAq-CSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:x3H4X5QYsRH2_1bJcJ-seoQOMIPUFOW63FaR8HDMKYKzyMe3oDMS_w>
    <xmx:x3H4X9d0mYNp8eZl-htUVROTqbqeB7rgIQuyo_lvSZKebf0XmDGMgQ>
    <xmx:x3H4X3izBb2ohBf2FWvudJY9mDm-lcYprp0EJZk0SS0YUwmbYk9g6Q>
    <xmx:yHH4X-kEl05MOGf5o5y4gBlflT5J_5Ur-oKuqfez5G9Vybk73H9jkA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B319124005C;
        Fri,  8 Jan 2021 09:52:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, vadimp@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] mlxsw: core: Add validation of transceiver temperature thresholds
Date:   Fri,  8 Jan 2021 16:52:09 +0200
Message-Id: <20210108145210.1229820-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108145210.1229820-1-idosch@idosch.org>
References: <20210108145210.1229820-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Validate thresholds to avoid a single failure due to some transceiver
unreliability. Ignore the last readouts in case warning temperature is
above alarm temperature, since it can cause unexpected thermal
shutdown. Stay with the previous values and refresh threshold within
the next iteration.

This is a rare scenario, but it was observed at a customer site.

Fixes: 6a79507cfe94 ("mlxsw: core: Extend thermal module with per QSFP module thermal zones")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 8fa286ccdd6b..250a85049697 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -176,6 +176,12 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	if (err)
 		return err;
 
+	if (crit_temp > emerg_temp) {
+		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
+			 tz->tzdev->type, crit_temp, emerg_temp);
+		return 0;
+	}
+
 	/* According to the system thermal requirements, the thermal zones are
 	 * defined with four trip points. The critical and emergency
 	 * temperature thresholds, provided by QSFP module are set as "active"
@@ -190,11 +196,8 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = emerg_temp;
-	if (emerg_temp > crit_temp)
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp +
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp +
 					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
-	else
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp;
 
 	return 0;
 }
-- 
2.29.2

