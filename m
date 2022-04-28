Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2C512AAB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 06:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiD1Es5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 00:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242749AbiD1Esz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 00:48:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55DD7E584;
        Wed, 27 Apr 2022 21:45:31 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so3320471plk.8;
        Wed, 27 Apr 2022 21:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QMVMVn+IZHfrtGyBLE7ozV0kzqRjUfSOXI9JDYurmk=;
        b=kdZGx+bPasdFVsGh1wL6HqEeeqHFc/wGJdD1a3WQUdw5kRM+abybBKCx/zLr8NaPQK
         UhrHErfGwt58Sh5AN4V6zjJow8OG8euf3Kt61cwjaW3vUFpa66KDHaUm6K36aLssEMck
         WFdCoOzllK0k5y/czdviERyeCeL9rd2Twp5CJoFROM4IleUHgxsByoAB+jPABinv+KO6
         vPxP3GIlAkYQO7xcAfsQNiIMRaIiNvviadu41lViW8OkLEMIZwdXpLTLfkEySVnJ10VQ
         aHudkIjLvROK+Yq3CtCu9KNJZ5q7O4IhyX0LY99ZEiONPPhoPtyWdCz8FTMrfxlsFcHX
         kqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QMVMVn+IZHfrtGyBLE7ozV0kzqRjUfSOXI9JDYurmk=;
        b=Dq6hT0LPtn1MgWxSgyzor3sDjoODx8iYfyUUvA3LZi8Mxwy1iV5cnFSm8pMVNtWIp/
         I1vc8P4l1TuiCsguFNwFhf1m/LSg3tAvdgerTd/UmqKVy4Mt4J/BdIxhmYNiPn+X1i13
         hPT9JX81QDWhBENiXkRFwUd/9uHLVRN1GpLWSeVynx7Z/yJ5MxPSkNY99S7/zbkv5tnG
         Q9XlBfUGAuXY+q3wUXvcFxwD3utxLdRvy7MJX/X82ViRcypQWV4TL2esHGqxRpWL5i/O
         reYgpt5hcHqWHAfr4nIheOugHlCjPYpqZ8b4MiX2PcN6Dlo4oGRxOsp3vaKIUWbstTO0
         sa2w==
X-Gm-Message-State: AOAM530V/7plq5A95JU4gBr6PyYt6r1FwVxAC0tTorcvBkE5Ow1rsqQw
        A9tIqg1YLBKOOxdM7cMgrDhQjGorrhg=
X-Google-Smtp-Source: ABdhPJxSglGKMD4y+4r1qwckgHK87sFA1QDZcX94BmWLXHfAQhh3Tf1dP6M8jKH1to/BJHp9UmZeTA==
X-Received: by 2002:a17:90b:1bc3:b0:1d9:5dcd:3468 with SMTP id oa3-20020a17090b1bc300b001d95dcd3468mr23663199pjb.11.1651121130865;
        Wed, 27 Apr 2022 21:45:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050d3aa8c904sm14301162pfg.206.2022.04.27.21.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 21:45:30 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        linux-kselftest@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, lkp-owner@lists.01.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] selftests/net/forwarding: add missing tests to Makefile
Date:   Thu, 28 Apr 2022 12:45:11 +0800
Message-Id: <20220428044511.227416-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428044511.227416-1-liuhangbin@gmail.com>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the fixed tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
  	TARGETS="net/forwarding" INSTALL_PATH=/tmp/kselftests

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/net/forwarding/Makefile | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 8fa97ae9af9e..c87e674b61b1 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -2,15 +2,31 @@
 
 TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
+	bridge_mld.sh \
 	bridge_port_isolation.sh \
 	bridge_sticky_fdb.sh \
 	bridge_vlan_aware.sh \
+	bridge_vlan_mcast.sh \
 	bridge_vlan_unaware.sh \
+	custom_multipath_hash.sh \
+	dual_vxlan_bridge.sh \
+	ethtool_extended_state.sh \
 	ethtool.sh \
+	gre_custom_multipath_hash.sh \
 	gre_inner_v4_multipath.sh \
 	gre_inner_v6_multipath.sh \
+	gre_multipath_nh_res.sh \
+	gre_multipath_nh.sh \
 	gre_multipath.sh \
+	hw_stats_l3.sh \
 	ip6_forward_instats_vrf.sh \
+	ip6gre_custom_multipath_hash.sh \
+	ip6gre_flat_key.sh \
+	ip6gre_flat_keys.sh \
+	ip6gre_flat.sh \
+	ip6gre_hier_key.sh \
+	ip6gre_hier_keys.sh \
+	ip6gre_hier.sh \
 	ip6gre_inner_v4_multipath.sh \
 	ip6gre_inner_v6_multipath.sh \
 	ipip_flat_gre_key.sh \
@@ -34,36 +50,53 @@ TEST_PROGS = bridge_igmp.sh \
 	mirror_gre_vlan_bridge_1q.sh \
 	mirror_gre_vlan.sh \
 	mirror_vlan.sh \
+	pedit_dsfield.sh \
+	pedit_ip.sh \
+	pedit_l4port.sh \
+	q_in_vni_ipv6.sh \
+	q_in_vni.sh \
 	router_bridge.sh \
 	router_bridge_vlan.sh \
 	router_broadcast.sh \
+	router_mpath_nh_res.sh \
 	router_mpath_nh.sh \
 	router_multicast.sh \
 	router_multipath.sh \
+	router_nh.sh \
 	router.sh \
 	router_vid_1.sh \
 	sch_ets.sh \
+	sch_red.sh \
 	sch_tbf_ets.sh \
 	sch_tbf_prio.sh \
 	sch_tbf_root.sh \
+	skbedit_priority.sh \
 	tc_actions.sh \
 	tc_chains.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
 	tc_mpls_l2vpn.sh \
+	tc_police.sh \
 	tc_shblocks.sh \
 	tc_vlan_modify.sh \
+	vxlan_asymmetric_ipv6.sh \
 	vxlan_asymmetric.sh \
+	vxlan_bridge_1d_ipv6.sh \
+	vxlan_bridge_1d_port_8472_ipv6.sh \
 	vxlan_bridge_1d_port_8472.sh \
 	vxlan_bridge_1d.sh \
+	vxlan_bridge_1q_ipv6.sh \
+	vxlan_bridge_1q_port_8472_ipv6.sh
 	vxlan_bridge_1q_port_8472.sh \
 	vxlan_bridge_1q.sh \
+	vxlan_symmetric_ipv6.sh \
 	vxlan_symmetric.sh
 
 TEST_PROGS_EXTENDED := devlink_lib.sh \
 	ethtool_lib.sh \
 	fib_offload_lib.sh \
 	forwarding.config.sample \
+	ip6gre_lib.sh \
 	ipip_lib.sh \
 	lib.sh \
 	mirror_gre_lib.sh \
-- 
2.35.1

