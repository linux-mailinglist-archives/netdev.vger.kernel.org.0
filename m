Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D1745DC14
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355676AbhKYOOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353039AbhKYOMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51107C0613DD
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z5so26317900edd.3
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qBrpPJsVudI6ySyaIY5TvYiAoJvmZq0zlu3qsVbGJw=;
        b=zkTCHhDPo6CeblP4zt7GKTJrhkAYeyHazgOcLJLN1Oy5SxnoWqzP10cvSZmh6t1EdB
         UD3x1kc6WaksgP3/QN+U3lZoZZ86ae3yhTwj4bRZDW4osGRd4F0pXTr21jkAi4ORy9LR
         vU234HOsyTi1nLApmLURc2RP2XBWXuD2wFsGLdCU/bQEzFA8U7AqaR1zqfEdAluM78d0
         pD3EHIRcNQZ6Q+gs8EKsIHxVu8014eFit2XUvfImxo5sbA2vz1giXpuOTnl6oUClTWil
         koFMY8GB5J1w1ITzMHNr90MvnSnFe4Osfetqqi7a1UuSWRopTqbMKSpEnFfXfblsDgdw
         /Fpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qBrpPJsVudI6ySyaIY5TvYiAoJvmZq0zlu3qsVbGJw=;
        b=Kv/oIowvbaCeBZRJ78XhK1yjoAoaN6SE0eeR0ayfvF12B+BCU4AMR//VGz3e+hRuvF
         WmV4JNOY/+8I7lAzx9m1lzhDAwBSZ1yTaQsMXvIyXjKQvs89/ulXd29OJz1653ODgUlP
         jVLmixZkeLEp0Ly5E3D4Upcv9an946Jd2q2fGf9rT45+wvgVbQS21uJfKKULJV08tKCL
         iUELzXOHGj8Qq0G80uUWI5jUPw4ZQj3GKu0/V7mlGlD9UNOYh4x63GN8SZaEcMOifFUQ
         fEcPkxrCji6QonccQzv0DGZkznR3cQgQX6pFuEgcZcB9zgmm8RWy+Qn7VRW0Mm7cvrik
         N7yA==
X-Gm-Message-State: AOAM530u/FzDoM3DcmV60dXfDQWq6l+MvCY3Xhb1XM6RgWF4/gLl966N
        cSSByq2o3+kbAkLnkTSSZVrsZdJmRKLM9r7o
X-Google-Smtp-Source: ABdhPJx9pJ1h5f1zet4iWkjJRsBMnfn84hmVUiJ+4VBsrzm9yqnDq0Jpeo2MiBWwKJnuv5HjppC1Eg==
X-Received: by 2002:a17:907:7f8f:: with SMTP id qk15mr31334914ejc.455.1637849357975;
        Thu, 25 Nov 2021 06:09:17 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:17 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/10] selftests: net: bridge: add vlan mcast_last_member_count/interval tests
Date:   Thu, 25 Nov 2021 16:08:52 +0200
Message-Id: <20211125140858.3639139-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests which verify the default values of mcast_last_member_count
mcast_last_member_count and also try to change them.

TEST: Vlan mcast_last_member_count global option default value      [ OK ]
TEST: Vlan mcast_last_member_interval global option default value   [ OK ]
TEST: Vlan 10 mcast_last_member_count option changed to 3           [ OK ]
TEST: Vlan 10 mcast_last_member_interval option changed to 200      [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 1b91778fac2f..85146c998316 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test"
+ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test vlmc_last_member_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -284,6 +284,40 @@ vlmc_igmp_mld_version_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_mld_version 1
 }
 
+vlmc_last_member_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_last_member_count == 2) " &>/dev/null
+	check_err $? "Wrong default mcast_last_member_count global vlan option value"
+	log_test "Vlan mcast_last_member_count global option default value"
+
+	RET=0
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_last_member_interval == 100) " &>/dev/null
+	check_err $? "Wrong default mcast_last_member_interval global vlan option value"
+	log_test "Vlan mcast_last_member_interval global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_last_member_count 3
+	check_err $? "Could not set mcast_last_member_count in vlan 10"
+	log_test "Vlan 10 mcast_last_member_count option changed to 3"
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_last_member_count 2
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_last_member_interval 200
+	check_err $? "Could not set mcast_last_member_interval in vlan 10"
+	log_test "Vlan 10 mcast_last_member_interval option changed to 200"
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_last_member_interval 100
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

