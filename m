Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35222169F61
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgBXHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35829 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbgBXHgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so8197390wmb.0
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QIBnSyisFGoyU92NrZYmt3lkoKC6qVADY8n5u6raGs0=;
        b=iB/YTT5wNrDCP+iRGbHhHUfeysp/OCe9Wv7pNxnujTB3tf3X9Qnxn1NDZJsPBiXXB+
         e6JHbNd1V8WKz2gXFJlRLmEigZ11QFuUkZomZc+z/Kh3OpnOg52chKK7iPcNLuQ89G8i
         W8RVz03F01DeKSgFQyeyDsf1oc6W7knS8D9tHbCmZz3kHqQM7vj+QsC0LdJB7VP9JszJ
         TWlXpYyF2EERjg5hcGCXCYTv29WZOb4yCPSvYTpiXgaSukQCFpgSLJL4OkL7wddPfHJv
         aTddQFgx25gbwcQjYExGJx6NsYFC+KaGbDn9lC2SrXr97PehohPfPLpvDO6mp0Dix4V5
         jwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QIBnSyisFGoyU92NrZYmt3lkoKC6qVADY8n5u6raGs0=;
        b=sqLt6ZSpaOhrGx8F3cuem8Ib/h1r2yXxsTos5fjMd4BBQ0/homw9t4wo4H/mQHv2Eq
         O7vGhRWUjouhqus/8lMTFAX9aZbI/Nj6fGUPlppAh+SMSfF8vr7NrATUMm27teg9sAyH
         O7NkOU242OCc83m9JrE8JW3CTtagTRfICkuHoyjCIyT/j37bO8h8IQErAZFHis9m/dxp
         bsrfwAOcmSJQuDWAptOadopQiKIBpiu1kyZhHjzihE3Ps+QiW322b4qXdzyoIFSxKdc0
         3nKzknS6/UuShb+6XuMr3FZ659Ggr0l0oOnCGkGMhZynkAtkU7Ab8E+QdrZelvGu1pxa
         kOHg==
X-Gm-Message-State: APjAAAUy6Dilf3vA+C204dK+JoeYvxDRNK24wYx1QNBc9myMGx2scu9c
        w+NE8hj9q+NFPDw89zHhQWe6Dqf/sa0=
X-Google-Smtp-Source: APXvYqzv4eQNL7/oynEi4RyHjkns3QiDGQxs5ZUYhgNT6M9QxTXa17t1vkn2YqrZ0HrA9AA66YPBMw==
X-Received: by 2002:a7b:c204:: with SMTP id x4mr20588901wmi.20.1582529778328;
        Sun, 23 Feb 2020 23:36:18 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q10sm17217329wme.16.2020.02.23.23.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:17 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 16/16] selftests: devlink_trap_acl_drops: Add ACL traps test
Date:   Mon, 24 Feb 2020 08:35:58 +0100
Message-Id: <20200224073558.26500-17-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add a test to check functionality of ACL traps.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_acl_drops.sh       | 151 ++++++++++++++++++
 1 file changed, 151 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
new file mode 100755
index 000000000000..26044e397157
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
@@ -0,0 +1,151 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap ACL drops functionality over mlxsw.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	ingress_flow_action_drop_test
+	egress_flow_action_drop_test
+"
+NUM_NETIFS=4
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge vlan_filtering 1 mcast_snooping 0
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp1 clsact
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ingress_flow_action_drop_test()
+{
+	local mz_pid
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower src_mac $h1mac action pass
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 \
+		flower dst_ip 192.0.2.2 action drop
+
+	$MZ $h1 -c 0 -p 100 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -d 1msec -q &
+	mz_pid=$!
+
+	RET=0
+
+	devlink_trap_drop_test ingress_flow_action_drop acl_drops $swp2 101
+
+	log_test "ingress_flow_action_drop"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
+}
+
+egress_flow_action_drop_test()
+{
+	local mz_pid
+
+	tc filter add dev $swp2 egress protocol ip pref 2 handle 102 \
+		flower src_mac $h1mac action pass
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_ip 192.0.2.2 action drop
+
+	$MZ $h1 -c 0 -p 100 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -d 1msec -q &
+	mz_pid=$!
+
+	RET=0
+
+	devlink_trap_drop_test egress_flow_action_drop acl_drops $swp2 102
+
+	log_test "egress_flow_action_drop"
+
+	tc filter del dev $swp2 egress protocol ip pref 1 handle 101 flower
+
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 2 102
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.1

