Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2FD45DC1B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355462AbhKYOPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355645AbhKYONz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:13:55 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69A5C0613F4
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:30 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so26153985edv.1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmr06pA0TokKoR6jlJic1Isl4JZia+uZ96LV+9m0Xfk=;
        b=qCilOhgU1ExKEZEIAxoiLKHqAkukOP07ZzUuPqR52J7FfCdWqISFFzn//+tHX35VLi
         RTThkXPJTbMU2L4plslbTzWY8aRPsH0tF24AoD+R5TuceouHuzSXojqeuLnfdL9/x297
         iLH3EirHXGckKJC9VJfEUHeyWfSFH7keERCCZ5F2xROX24SOF9/bqptMxXahfbAwAgn5
         2QvuQ3DzhYD1V3SxKgsjSm/ytjfj1Lw+E1EMb0vc7oPeSMNHYUi8CglzsT07EVhyfFw7
         6dNDrYZjmwUV2QHs/Vr2txD/Mx65Bywp5Qu26JlUKHkLwKKw/4ghpJ4rDMU0aO+EEVmL
         iOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmr06pA0TokKoR6jlJic1Isl4JZia+uZ96LV+9m0Xfk=;
        b=l4ur3shVFg/EGdqoAS6hjOz9gh/HE2YanHk9ZMLGXSVfAUknz4XYo1qzl8uKY/CrmR
         TbJGU/ALmq6qBcMMClq2c9Va6AyrLJdPblMLgGMUs+N3hmf5guj+C/iGW3EfYQLHivNR
         7vE5idKj24xqmU9TNQj45BaqiLXRhunrMTOqS4rY0dRdgVPhUt1VOtVKYHdgF+Y1x+08
         7HnXpy98aB4ZCE5E/nYyrGvGdvU+g3MaxV07yB4BF/VmnLODIl3RBH7iN/t0HZO4mat+
         Q6iAG4XszMM3c+O8AFherTvo36qBB7/S86VmkvYjvFT8itts86rWmORCVY71iY8ds8X/
         MFAg==
X-Gm-Message-State: AOAM533UK/VTYR/tIOxqUdXRM11dPu/IvGfStp/dHU18VjXIO1NhQutF
        irwYi6tsI6QkezMeO0vBy/Cdnnoyb/v9c/CO
X-Google-Smtp-Source: ABdhPJxMes8ylLjzMUDK+c/dgBnadUX26SaFHqYxu1GjpM7dPtC1eSEH2LWv4cw+Wn2XVLbyiSgjxA==
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr39092087edw.74.1637849369093;
        Thu, 25 Nov 2021 06:09:29 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:28 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: net: bridge: add test for vlan_filtering dependency
Date:   Thu, 25 Nov 2021 16:08:58 +0200
Message-Id: <20211125140858.3639139-11-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a test for dependency of mcast_vlan_snooping on vlan_filtering. If
vlan_filtering gets disabled, then mcast_vlan_snooping must be
automatically disabled as well.

TEST: Disable multicast vlan snooping when vlan filtering is disabled   [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_vlan_mcast.sh    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 898a70f4d226..5224a5a8595b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -4,7 +4,7 @@
 ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
 	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test \
 	   vlmc_querier_intvl_test vlmc_query_intvl_test vlmc_query_response_intvl_test \
-	   vlmc_router_port_test"
+	   vlmc_router_port_test vlmc_filtering_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -523,6 +523,16 @@ vlmc_router_port_test()
 	bridge vlan set vid 10 dev $swp1 mcast_router 1
 }
 
+vlmc_filtering_test()
+{
+	RET=0
+	ip link set dev br0 type bridge vlan_filtering 0
+	ip -j -d link show dev bridge | \
+	jq -e "select(.[0].linkinfo.info_data.mcast_vlan_snooping == 1)" &>/dev/null
+	check_fail $? "Vlan filtering is disabled but multicast vlan snooping is still enabled"
+	log_test "Disable multicast vlan snooping when vlan filtering is disabled"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

