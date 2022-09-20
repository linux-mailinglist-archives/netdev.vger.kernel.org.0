Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C5C5BDADA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 05:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiITDbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 23:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiITDbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 23:31:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73DB57273
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 20:30:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l10so1092425plb.10
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 20:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lW13UkQP9cVsvxeXKaV/SWI78ZW+g6LMlqH+WhaVN6s=;
        b=JB5rK/m0CuFywVVaXhNI2sq2VPYNM41kRLKnbt8sbdrw9AAXUNuVuocgPfrimul3/I
         23CPahkuoeA5e5poZmqDLYSJ2A4OTQepEqfee1gTma63xHXGXRpl2sWEy72pxfdoaz4i
         6szplDdIeNIRrLYFkRI043ovHxnb+DYahCJDTK2H+jDup7drFsjTFJ7DQE6fuP6Z0BTP
         GnSLYcWAPuuRI8LJTotXMYdrOba+kTx/GHuL4A2KeByfQoTxMf4OkNWf1x08gvz+LcJl
         u9ou0iyUsY/gvcgH2ZKEJkCA5dlSFSVtzi3PkPZC01NGbFGAdRS6q6+n25qqMYFKRM2R
         OCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lW13UkQP9cVsvxeXKaV/SWI78ZW+g6LMlqH+WhaVN6s=;
        b=sWsLOVFX6MoH+TcOwi3Ft1UCZl01mUeDlNl+c1OvDQSN0LHJiv8blPShZAoWF9UdEU
         vCR3IwaAimWGTm/MLrifj4M14CZzt+DUnR+i/qWxs7EfuOLXMbbo2C4cCqGDrQRwuEEw
         jauVdScz0mmruBCMSHPX3njzBegH2TPg+fTEBJtxaQtCG08jJY10YdDSXs3QA6L8OmJH
         jRqj9occaCch7Y/7OkBa1cYmL7bmQTNANM9ke5RXhu6fJlY/fKtWc2UQbdP9TVGCwo5z
         1mmuQBrMOI0JouyJvZ/t7E39/PXeY6T0n9EAuhkTWI5jYdZOipU3ReVt3RMy1cCLZPUW
         AD8w==
X-Gm-Message-State: ACrzQf2ezwf+puaC3maNYQccZv/C1uGkvc3GknzvWad4Rl4XuSgktEkQ
        oyskKtfSW+pX3dQWo5sFsDdea9eOyNQzDg==
X-Google-Smtp-Source: AMsMyM7kfj2/ZPLwstybddVIXn/CEJTyFHS361HKyJc88gLfkpsDSXIKCmzGPhJ0tTLflCfRkaN7eg==
X-Received: by 2002:a17:902:c7d2:b0:178:8e76:c78a with SMTP id r18-20020a170902c7d200b001788e76c78amr2948582pla.116.1663644657953;
        Mon, 19 Sep 2022 20:30:57 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z22-20020a630a56000000b00434651f9a96sm224545pgk.15.2022.09.19.20.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 20:30:57 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH (repost) net-next] selftests/bonding: add a test for bonding lladdr target
Date:   Tue, 20 Sep 2022 11:30:47 +0800
Message-Id: <20220920033047.173244-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
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

This is a regression test for commit 592335a4164c ("bonding: accept
unsolicited NA message") and commit b7f14132bf58 ("bonding: use unspecified
address if no available link local address"). When the bond interface
up and no available link local address, unspecified address(::) is used to
send the NS message. The unsolicited NA message should also be accepted
for validation.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/drivers/net/bonding/Makefile    |  1 +
 .../drivers/net/bonding/bond-lladdr-target.sh | 65 +++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index ab6c54b12098..d209f7a98b6c 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -2,5 +2,6 @@
 # Makefile for net selftests
 
 TEST_PROGS := bond-break-lacpdu-tx.sh
+TEST_PROGS += bond-lladdr-target.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
new file mode 100755
index 000000000000..89af402fabbe
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#   Verify bond interface could up when set IPv6 link local address target.
+#
+#  +----------------+
+#  |      br0       |
+#  |       |        |    sw
+#  | veth0   veth1  |
+#  +---+-------+----+
+#      |       |
+#  +---+-------+----+
+#  | veth0   veth1  |
+#  |       |        |    host
+#  |     bond0      |
+#  +----------------+
+#
+# We use veths instead of physical interfaces
+sw="sw-$(mktemp -u XXXXXX)"
+host="ns-$(mktemp -u XXXXXX)"
+
+cleanup()
+{
+	ip netns del $sw
+	ip netns del $host
+}
+
+trap cleanup 0 1 2
+
+ip netns add $sw
+ip netns add $host
+
+ip -n $host link add veth0 type veth peer name veth0 netns $sw
+ip -n $host link add veth1 type veth peer name veth1 netns $sw
+
+ip -n $sw link add br0 type bridge
+ip -n $sw link set br0 up
+sw_lladdr=$(ip -n $sw addr show br0 | awk '/fe80/{print $2}' | cut -d'/' -f1)
+# sleep some time to make sure bridge lladdr pass DAD
+sleep 2
+
+ip -n $host link add bond0 type bond mode 1 ns_ip6_target ${sw_lladdr} \
+	arp_validate 3 arp_interval 1000
+# add a lladdr for bond to make sure there is a route to target
+ip -n $host addr add fe80::beef/64 dev bond0
+ip -n $host link set bond0 up
+ip -n $host link set veth0 master bond0
+ip -n $host link set veth1 master bond0
+
+ip -n $sw link set veth0 master br0
+ip -n $sw link set veth1 master br0
+ip -n $sw link set veth0 up
+ip -n $sw link set veth1 up
+
+sleep 5
+
+rc=0
+if ip -n $host link show bond0 | grep -q LOWER_UP; then
+	echo "PASS"
+else
+	echo "FAIL"
+	rc=1
+fi
+exit $rc
-- 
2.37.2

