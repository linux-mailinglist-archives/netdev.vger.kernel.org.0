Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87650192300
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgCYIl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:41:26 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:45407 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgCYIl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:41:26 -0400
Received: by mail-qt1-f180.google.com with SMTP id t17so1460122qtn.12;
        Wed, 25 Mar 2020 01:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dHRlnhY1cOlvjbJYjummY3c5LxWJZBhIeQ+KSRDH04=;
        b=USZcfatjfcqBXt2wkzXFWaCMkG5ETt1RVFLHlsS0TadNf80KGUntRge35mdebhVmcd
         ftpo3VZpvl2C7q2+mLc01DrgI9W+sXwIwgWCpC2HgpmXo64vUePP+EA+gl4fwysLQJj0
         ywJHpAMW7zUqWLOsrdLOjMDNPO824bM/hE3VE3AzUh6CC3i8Pwbg4B1q+ff5HNBZCR8k
         yqYQLkHNU5Rqv/SmBd5lGAA/l+0k2ipdcP6miCJi7PC8iTXQiCPGieTkUowkXNiWK0mN
         q4b5dwwWGO5C42fCuXQMhzCFE+qyq0jYz/ug4yIOtrVoCWU0QmJJUVfeXK0k26HXfEzW
         YyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dHRlnhY1cOlvjbJYjummY3c5LxWJZBhIeQ+KSRDH04=;
        b=M090SIKwXbL3jE9qgspr4RIWPgY7EE14W4QD/xVhlW4BA3fyf9qQ7xCb5AbkyIWxf4
         xIngqCJBfcF5BpgI8RM/7k9ofWqgIk4sRsdYXP+PAqEXdxiCJCJ0IH63mMD9wSmfeCkQ
         xmM3ODcNOYztVka9ouzdeaEJuzadQfCy58G3FGCYX+gNe0pp/hLy4U+UOCo+kpYT3YwC
         4S2nO00Gcl5Fn42G2zTqDlbGldYD9dkfVCI67LzN0datuyE9t4RqrNJsODRZsaaMmkdz
         uUVod3jwDTeFLXJyX4/OohoyNbMcl0CKRDKJ+gALmZTTe/+XwE/ZD9TOSCZ/jk0RoG6H
         N8UA==
X-Gm-Message-State: ANhLgQ2v2nSfHeA1a3VI9jbmJ5J6EayVCsm9lmaOSVJ+71vPms4aZoxf
        I4GNK3VjzY494qMQC1QKFC3r6rsPznU=
X-Google-Smtp-Source: ADFU+vuYMb7BRkGxgfrtEsrlAc/ydYu4DWbeUCH+6m3WqRqX0SFUO1wQYgu/36rd0ofpOkv+6k1VvA==
X-Received: by 2002:ac8:23ed:: with SMTP id r42mr1866634qtr.372.1585125682987;
        Wed, 25 Mar 2020 01:41:22 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16sm15259907qkk.79.2020.03.25.01.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 01:41:22 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/net/forwarding: define libs as TEST_PROGS_EXTENDED
Date:   Wed, 25 Mar 2020 16:41:01 +0800
Message-Id: <20200325084101.9156-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lib files should not be defined as TEST_PROGS, or we will run them
in run_kselftest.sh.

Also remove ethtool_lib.sh exec permission.

Fixes: 81573b18f26d ("selftests/net/forwarding: add Makefile to install tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/net/forwarding/Makefile | 31 ++++++++++---------
 .../selftests/net/forwarding/ethtool_lib.sh   |  0
 2 files changed, 16 insertions(+), 15 deletions(-)
 mode change 100755 => 100644 tools/testing/selftests/net/forwarding/ethtool_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 44616103508b..250fbb2d1625 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -5,11 +5,7 @@ TEST_PROGS = bridge_igmp.sh \
 	bridge_sticky_fdb.sh \
 	bridge_vlan_aware.sh \
 	bridge_vlan_unaware.sh \
-	devlink_lib.sh \
-	ethtool_lib.sh \
 	ethtool.sh \
-	fib_offload_lib.sh \
-	forwarding.config.sample \
 	gre_inner_v4_multipath.sh \
 	gre_inner_v6_multipath.sh \
 	gre_multipath.sh \
@@ -21,8 +17,6 @@ TEST_PROGS = bridge_igmp.sh \
 	ipip_hier_gre_key.sh \
 	ipip_hier_gre_keys.sh \
 	ipip_hier_gre.sh \
-	ipip_lib.sh \
-	lib.sh \
 	loopback.sh \
 	mirror_gre_bound.sh \
 	mirror_gre_bridge_1d.sh \
@@ -32,15 +26,11 @@ TEST_PROGS = bridge_igmp.sh \
 	mirror_gre_changes.sh \
 	mirror_gre_flower.sh \
 	mirror_gre_lag_lacp.sh \
-	mirror_gre_lib.sh \
 	mirror_gre_neigh.sh \
 	mirror_gre_nh.sh \
 	mirror_gre.sh \
-	mirror_gre_topo_lib.sh \
 	mirror_gre_vlan_bridge_1q.sh \
 	mirror_gre_vlan.sh \
-	mirror_lib.sh \
-	mirror_topo_lib.sh \
 	mirror_vlan.sh \
 	router_bridge.sh \
 	router_bridge_vlan.sh \
@@ -50,17 +40,12 @@ TEST_PROGS = bridge_igmp.sh \
 	router_multipath.sh \
 	router.sh \
 	router_vid_1.sh \
-	sch_ets_core.sh \
 	sch_ets.sh \
-	sch_ets_tests.sh \
-	sch_tbf_core.sh \
-	sch_tbf_etsprio.sh \
 	sch_tbf_ets.sh \
 	sch_tbf_prio.sh \
 	sch_tbf_root.sh \
 	tc_actions.sh \
 	tc_chains.sh \
-	tc_common.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
 	tc_shblocks.sh \
@@ -72,4 +57,20 @@ TEST_PROGS = bridge_igmp.sh \
 	vxlan_bridge_1q.sh \
 	vxlan_symmetric.sh
 
+TEST_PROGS_EXTENDED := devlink_lib.sh \
+	ethtool_lib.sh \
+	fib_offload_lib.sh \
+	forwarding.config.sample \
+	ipip_lib.sh \
+	lib.sh \
+	mirror_gre_lib.sh \
+	mirror_gre_topo_lib.sh \
+	mirror_lib.sh \
+	mirror_topo_lib.sh \
+	sch_ets_core.sh \
+	sch_ets_tests.sh \
+	sch_tbf_core.sh \
+	sch_tbf_etsprio.sh \
+	tc_common.sh
+
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
old mode 100755
new mode 100644
-- 
2.19.2

