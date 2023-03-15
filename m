Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B85C6BAF19
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjCOLUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjCOLUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:20:31 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5615167
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:20:02 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id by8so19033957ljb.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678879195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXQWN74HCU9Dmrt/5yZK3bP0Ur89GICfyK+cwzWVwF8=;
        b=E1o037GmRAccOukldze0HdzPNNRd6ihn7YdqYDuo/qN1+lA97J61MUf16FM8Ip6aKq
         3CuGep0van2KhAmDhV1qKtY/eM1j3uh9UCT1HW8FPcM+pm13TNUgo4iKabt9N1lvhEBF
         Obf6nERlIOzGILEnMasvCiWUQJahWxmBa9RPWy0M7jlTihaBsAZQhQl0Ks2TMJUKyaQG
         GuW2B9VMO56FRn4mHPUo6G4vowVefgh54exv+JpRB47xMnMBLRYu4eF0L8RajBbRTZsx
         jktKgohKVDuF6V86fnATuc21rbh62ZhgfE2UFibst0LqIOSzkGQo1Qk+NxJsQQEtORjS
         1Zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678879195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXQWN74HCU9Dmrt/5yZK3bP0Ur89GICfyK+cwzWVwF8=;
        b=tsGGounrga+SkkBrIkNRQATAPY1Avjf+AggKqRtXVlEBjto/LwhOorCeOyqfRpFEjS
         25EBe77BtfnnFLVksI7bDONozHfkYwphUhywEPjBr+gF9R5Oscg1Vej5jnF8PJf8xmvm
         npwHPLDvc3szubrtbeF2KQcbe4bgwvIFY2mpPU81P2bQANOA4BWB/GaT6thnFK/uP7ca
         UhNIzV9RPyb8tQcRvwFOQZdR9v5bueoOs9Hfdi5pY4VTuQZeVpmUaHJAhX92Li3Xdpwh
         OJ84NHrsVkzV9Tda+CaWLu4Ui0Natl/vpnJHyXwukimi8XJVZLPeY5A/2akRAWqcxvGd
         FLRg==
X-Gm-Message-State: AO0yUKV6xuVAfjLUO+OsBQk059ZHchQskTkax0598f3JO3AEi03w1OYq
        42nLKlcxvZk49iDB0Uq4SM2uAXj2Rh2Gt9wjU/iOSA==
X-Google-Smtp-Source: AK7set8eaSc9x48dtXYRgnmi6HzBAyzznIieMbC7BPupT7ItcPJHXElLQjREjGlorvxtbvD4Mew2pA==
X-Received: by 2002:a2e:bea0:0:b0:295:9d9c:24aa with SMTP id a32-20020a2ebea0000000b002959d9c24aamr952107ljr.11.1678879195089;
        Wed, 15 Mar 2023 04:19:55 -0700 (PDT)
Received: from kofa.. ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id 20-20020a2e1654000000b00295a8d1ecc7sm829218ljw.18.2023.03.15.04.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:19:54 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        michal.kubiak@intel.com, jtoppins@redhat.com,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH net v3 3/3] selftests: bonding: add tests for ether type changes
Date:   Wed, 15 Mar 2023 13:18:42 +0200
Message-Id: <20230315111842.1589296-4-razor@blackwall.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230315111842.1589296-1-razor@blackwall.org>
References: <20230315111842.1589296-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new network selftests for the bonding device which exercise the ether
type changing call paths. They also test for the recent syzbot bug[1] which
causes a warning and results in wrong device flags (IFF_SLAVE missing).
The test adds three bond devices and a nlmon device, enslaves one of the
bond devices to the other and then uses the nlmon device for successful
and unsuccesful enslaves both of which change the bond ether type. Thus
we can test for both MASTER and SLAVE flags at the same time.

If the flags are properly restored we get:
TEST: Change ether type of an enslaved bond device with unsuccessful enslave   [ OK ]
TEST: Change ether type of an enslaved bond device with successful enslave   [ OK ]

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
v3: no changes

 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 8e3b786a748f..a39bb2560d9b 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -8,7 +8,8 @@ TEST_PROGS := \
 	dev_addr_lists.sh \
 	mode-1-recovery-updelay.sh \
 	mode-2-recovery-updelay.sh \
-	option_prio.sh
+	option_prio.sh \
+	bond-eth-type-change.sh
 
 TEST_FILES := \
 	lag_lib.sh \
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
new file mode 100755
index 000000000000..5cdd22048ba7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
@@ -0,0 +1,85 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bond device ether type changing
+#
+
+ALL_TESTS="
+	bond_test_unsuccessful_enslave_type_change
+	bond_test_successful_enslave_type_change
+"
+REQUIRE_MZ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/net_forwarding_lib.sh
+
+bond_check_flags()
+{
+	local bonddev=$1
+
+	ip -d l sh dev "$bonddev" | grep -q "MASTER"
+	check_err $? "MASTER flag is missing from the bond device"
+
+	ip -d l sh dev "$bonddev" | grep -q "SLAVE"
+	check_err $? "SLAVE flag is missing from the bond device"
+}
+
+# test enslaved bond dev type change from ARPHRD_ETHER and back
+# this allows us to test both MASTER and SLAVE flags at once
+bond_test_enslave_type_change()
+{
+	local test_success=$1
+	local devbond0="test-bond0"
+	local devbond1="test-bond1"
+	local devbond2="test-bond2"
+	local nonethdev="test-noneth0"
+
+	# create a non-ARPHRD_ETHER device for testing (e.g. nlmon type)
+	ip link add name "$nonethdev" type nlmon
+	check_err $? "could not create a non-ARPHRD_ETHER device (nlmon)"
+	ip link add name "$devbond0" type bond
+	if [ $test_success -eq 1 ]; then
+		# we need devbond0 in active-backup mode to successfully enslave nonethdev
+		ip link set dev "$devbond0" type bond mode active-backup
+		check_err $? "could not change bond mode to active-backup"
+	fi
+	ip link add name "$devbond1" type bond
+	ip link add name "$devbond2" type bond
+	ip link set dev "$devbond0" master "$devbond1"
+	check_err $? "could not enslave $devbond0 to $devbond1"
+	# change bond type to non-ARPHRD_ETHER
+	ip link set dev "$nonethdev" master "$devbond0" 1>/dev/null 2>/dev/null
+	ip link set dev "$nonethdev" nomaster 1>/dev/null 2>/dev/null
+	# restore ARPHRD_ETHER type by enslaving such device
+	ip link set dev "$devbond2" master "$devbond0"
+	check_err $? "could not enslave $devbond2 to $devbond0"
+	ip link set dev "$devbond1" nomaster
+
+	bond_check_flags "$devbond0"
+
+	# clean up
+	ip link del dev "$devbond0"
+	ip link del dev "$devbond1"
+	ip link del dev "$devbond2"
+	ip link del dev "$nonethdev"
+}
+
+bond_test_unsuccessful_enslave_type_change()
+{
+	RET=0
+
+	bond_test_enslave_type_change 0
+	log_test "Change ether type of an enslaved bond device with unsuccessful enslave"
+}
+
+bond_test_successful_enslave_type_change()
+{
+	RET=0
+
+	bond_test_enslave_type_change 1
+	log_test "Change ether type of an enslaved bond device with successful enslave"
+}
+
+tests_run
+
+exit "$EXIT_STATUS"
-- 
2.39.1

