Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB69045DC19
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355717AbhKYOO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355613AbhKYOMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:55 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40FDC0613ED
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:28 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id t5so26452971edd.0
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MKmLffX+pWU4FoGNzKjM0jOIw2aMhpVyY+HZhQGjnqg=;
        b=vd141DjmUJYTiCdsz/2wy8xA6ToZUseMArv0IPAnwB33JcVmD1P7Egx4igtP6nHk7I
         L63haVNgajhvJcUOyK79pW4cXv5dDb2diGLW/ginf6KSt/Trk2ZsK0fnfAJ9NeoDaiTE
         ULVHgWXIxT9MSFApIgDJ5TnzBEgbKTxkaejeH9VYisrleBVxr+o8/Qy1rjaf/84mys6M
         ypxIMEZwowA6JgNik8J77MaXrviVEf/ZurQhQ9+tshwSGkwaYvbnf3uLvmx03CSAIWAo
         gMsyj/XBfkSRLA/qTUBqGxgpFmHLEs9r/Udp/Wao1WiLNkaS9jaAF9FZPeQx3xJFxCuD
         TbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MKmLffX+pWU4FoGNzKjM0jOIw2aMhpVyY+HZhQGjnqg=;
        b=D1HAyuauMj/x4d1A1+2Vo/OP3jCOLWx/qQgsY2X0tnU8emabmwFAntvj+8xC2uPS4a
         nskX3sqZ2kn3el2QieyN8q0hZvI1frB6mNUob/559LZUkM4Mxg8Brkqi7alBZSr8ANcH
         wOjHMzsoE69i1hugOmFnwTNsPAVwEIFEH7A7zsmRMc/4HB26NdW1c5X2Bs0ycjJJWcI3
         OR/j3OCHpnAlUbchiRH1Oq9tUjSUvKgzN0zkemSH/5i3hDNMMqDiD4C+31Z1i8MDBduz
         VhyakvY43ValKPJaTAVgV/bmHq7g24+RtR8qB1ctWOj7KWavRpMhyA7GaH2mEy+zk+I9
         2TwQ==
X-Gm-Message-State: AOAM532InjRKMEjGgEJBLSIsg66WakaPF8xOXtX9E7oqrqNdpSzFYgHc
        l6QY3zx1gdIls/qWPoyzFkOoyBLIe5AOhGLc
X-Google-Smtp-Source: ABdhPJwniuJBKU+PVv6obhV3udo2IGHvk1LZKXEkE/eNwX+erbMBETrUkSC8jFxwpI/TeCqrolsh4A==
X-Received: by 2002:a50:e683:: with SMTP id z3mr39673718edm.206.1637849367088;
        Thu, 25 Nov 2021 06:09:27 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:26 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 08/10] selftests: net: bridge: add vlan mcast query and query response interval tests
Date:   Thu, 25 Nov 2021 16:08:56 +0200
Message-Id: <20211125140858.3639139-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests which change the new per-vlan mcast_query_interval and verify
the new value is in effect, also add a test to change
mcast_query_response_interval's value.

TEST: Vlan mcast_query_interval global option default value         [ OK ]
TEST: Vlan 10 mcast_query_interval option changed to 200            [ OK ]
TEST: Vlan mcast_query_response_interval global option default value   [ OK ]
TEST: Vlan 10 mcast_query_response_interval option changed to 200   [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 51 ++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 9a68d56fd74c..fbc7f5045b26 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
 	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test \
-	   vlmc_querier_intvl_test"
+	   vlmc_querier_intvl_test vlmc_query_intvl_test vlmc_query_response_intvl_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -422,6 +422,55 @@ vlmc_querier_intvl_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_querier_interval 25500
 }
 
+vlmc_query_intvl_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_query_interval == 12500) " &>/dev/null
+	check_err $? "Wrong default mcast_query_interval global vlan option value"
+	log_test "Vlan mcast_query_interval global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_count 0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_interval 200
+	check_err $? "Could not set mcast_query_interval in vlan 10"
+	# 1 is sent immediately, then 2 more in the next 5 seconds
+	vlmc_check_query igmp 2 $swp1 3 5
+	check_err $? "Wrong number of tagged IGMPv2 general queries sent"
+	log_test "Vlan 10 mcast_query_interval option changed to 200"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_count 2
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_interval 12500
+}
+
+vlmc_query_response_intvl_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_query_response_interval == 1000) " &>/dev/null
+	check_err $? "Wrong default mcast_query_response_interval global vlan option value"
+	log_test "Vlan mcast_query_response_interval global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_response_interval 200
+	check_err $? "Could not set mcast_query_response_interval in vlan 10"
+	log_test "Vlan 10 mcast_query_response_interval option changed to 200"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_response_interval 1000
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

