Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FAB58E4E2
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 04:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiHJCdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 22:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiHJCdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 22:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BE5580F76
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 19:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660098829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBHNVoPSuHO4ONpWmTNbpIare5YGkRQP4M9bKlstoqM=;
        b=C8tpO7to+NH7A0ZjI+GSkaRgeOHGKEmZsouIxW5jRoX8usY0o/cyRKflkbh8d5wLvVx2Rs
        6hLGMh3V8J2TbdTZdcthmNtwppr4zJcHM8Nw6IDkIsmikMksGJbsavoIj4/uJg4bqMv1gu
        CsgHRXSsnCEae/MI3sQAGVBhAozE1Zc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-vUwpujkrOkWl0nje9-zZ-Q-1; Tue, 09 Aug 2022 22:33:46 -0400
X-MC-Unique: vUwpujkrOkWl0nje9-zZ-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 537FA8037B3;
        Wed, 10 Aug 2022 02:33:45 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4982026D4C;
        Wed, 10 Aug 2022 02:33:45 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 1/2] selftests: include bonding tests into the kselftest infra
Date:   Tue,  9 Aug 2022 22:33:21 -0400
Message-Id: <d7902978499da81c6fa8bc530d16e2f71f84c0f1.1660098382.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660098382.git.jtoppins@redhat.com>
References: <cover.1660098382.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This creates a test collection in drivers/net/bonding for bonding
specific kernel selftests.

The first test is a reproducer that provisions a bond and given the
specific order in how the ip-link(8) commands are issued the bond never
transmits an LACPDU frame on any of its slaves.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     * fully integrated the test into the kselftests infrastructure
     * moved the reproducer to under
       tools/testing/selftests/drivers/net/bonding
     * reduced the test to its minimial amount and used ip-link(8) for
       all bond interface configuration

 MAINTAINERS                                   |  1 +
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  6 ++
 .../net/bonding/bond-break-lacpdu-tx.sh       | 82 +++++++++++++++++++
 .../selftests/drivers/net/bonding/config      |  1 +
 .../selftests/drivers/net/bonding/settings    |  1 +
 6 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/config
 create mode 100644 tools/testing/selftests/drivers/net/bonding/settings

diff --git a/MAINTAINERS b/MAINTAINERS
index 386178699ae7..6e7cebc1bca3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3636,6 +3636,7 @@ F:	Documentation/networking/bonding.rst
 F:	drivers/net/bonding/
 F:	include/net/bond*
 F:	include/uapi/linux/if_bonding.h
+F:	tools/testing/selftests/net/bonding/
 
 BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
 M:	Dan Robertson <dan@dlrobertson.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 5047d8eef53e..86f5f6d65526 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -12,6 +12,7 @@ TARGETS += cpu-hotplug
 TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += drivers/s390x/uvdevice
+TARGETS += drivers/net/bonding
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += filesystems
diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
new file mode 100644
index 000000000000..ab6c54b12098
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for net selftests
+
+TEST_PROGS := bond-break-lacpdu-tx.sh
+
+include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
new file mode 100755
index 000000000000..a4f174aeabd9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
@@ -0,0 +1,82 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#   Verify LACPDUs get transmitted after setting the MAC address of
+#   the bond.
+#
+# https://bugzilla.redhat.com/show_bug.cgi?id=2020773
+#
+#       +---------+
+#       | fab-br0 |
+#       +---------+
+#            |
+#       +---------+
+#       |  fbond  |
+#       +---------+
+#        |       |
+#    +------+ +------+
+#    |veth1 | |veth2 |
+#    +------+ +------+
+#
+# We use veths instead of physical interfaces
+
+set -e
+#set -x
+tmp=$(mktemp -q dump.XXXXXX)
+cleanup() {
+	ip link del fab-br0 >/dev/null 2>&1 || :
+	ip link del fbond  >/dev/null 2>&1 || :
+	ip link del veth1-bond  >/dev/null 2>&1 || :
+	ip link del veth2-bond  >/dev/null 2>&1 || :
+	modprobe -r bonding  >/dev/null 2>&1 || :
+	rm -f -- ${tmp}
+}
+
+trap cleanup 0 1 2
+cleanup
+sleep 1
+
+# create the bridge
+ip link add fab-br0 address 52:54:00:3B:7C:A6 mtu 1500 type bridge \
+	forward_delay 15
+
+# create the bond
+ip link add fbond type bond mode 4 miimon 200 xmit_hash_policy 1 \
+	ad_actor_sys_prio 65535 lacp_rate fast
+
+# set bond address
+ip link set fbond address 52:54:00:3B:7C:A6
+ip link set fbond up
+
+# set again bond sysfs parameters
+ip link set fbond type bond ad_actor_sys_prio 65535
+
+# create veths
+ip link add name veth1-bond type veth peer name veth1-end
+ip link add name veth2-bond type veth peer name veth2-end
+
+# add ports
+ip link set fbond master fab-br0
+ip link set veth1-bond down master fbond
+ip link set veth2-bond down master fbond
+
+# bring up
+ip link set veth1-end up
+ip link set veth2-end up
+ip link set fab-br0 up
+ip link set fbond up
+ip addr add dev fab-br0 10.0.0.3
+
+tcpdump -n -i veth1-end -e ether proto 0x8809 >${tmp} 2>&1 &
+sleep 15
+pkill tcpdump >/dev/null 2>&1
+rc=0
+num=$(grep "packets captured" ${tmp} | awk '{print $1}')
+if test "$num" -gt 0; then
+	echo "PASS, captured ${num}"
+else
+	echo "FAIL"
+	rc=1
+fi
+exit $rc
diff --git a/tools/testing/selftests/drivers/net/bonding/config b/tools/testing/selftests/drivers/net/bonding/config
new file mode 100644
index 000000000000..dc1c22de3c92
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/config
@@ -0,0 +1 @@
+CONFIG_BONDING=y
diff --git a/tools/testing/selftests/drivers/net/bonding/settings b/tools/testing/selftests/drivers/net/bonding/settings
new file mode 100644
index 000000000000..867e118223cd
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/settings
@@ -0,0 +1 @@
+timeout=60
-- 
2.31.1

