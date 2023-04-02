Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87EC6D38AF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDBPLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjDBPLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:11:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E81B767
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:10:59 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so12956670wmq.3
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680448257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8t7j97MK9v/+tIuuC4p3ufXUEIanyVdCBJOsXLD3j8=;
        b=Jb5hMs6uOtdYnhBkr+m+i22kfBLkH9ExotPQ6ZnzGtkkj+T/x//y8gW1XARpqTX9Aw
         OsuTsQ8X1xePszy4aZCbChNRUwmFkIsP3Jj/kNDC9OoiURV15T6c/upCGh/xkX03eUeX
         ms7IVkLQSxCTGWERPDqS7mcIgZb4EyMYptmbvd0EpM2FQTgdsCNG0YIs6Gxe4VDvgETf
         BewlH6NaR/0gpiO8iZPbELQW69AZHHj3uhp1FvJONgOGMmRteuLfv9QX+yaierrO761s
         8H6nQUQJoYpgyW8Qltt0pjzDn+gGxV3dHFKNCJNhwsqU5rzGlkHzCDgZg85FZxzrXyc5
         7pyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/8t7j97MK9v/+tIuuC4p3ufXUEIanyVdCBJOsXLD3j8=;
        b=OS/CzJXlZkAK3xGzXk/H4DhqM5wQSkAPLLyRah4L/uY7yTPCIHCMkjPqhDYYVdGG7V
         N38boBB7/N6t9iasXAKEDfUC17AD+slzA71etLnYsRNe6almsJ5dK9yC7aQVGKW6VOSf
         Fvg3CVNgZcGdJRLP4cZleMOdRo851CgTgnxsTnm5Xt35xB6LF4tNfIKmgHM5EqFZ39J3
         04xHcub36n0DGeDQv1euPx77r5m26HCZxLlfM57EISwfhZmDFVMjNsHOOi7FfXNkSVop
         1YYeE2srnfaq0AXi3jKbxJ3yWpagUYOXMDUYIIdOs+RBreiZZ371F9byBnDMeqUvX4se
         eSow==
X-Gm-Message-State: AO0yUKWn/PwYhHyyQ6seN9XL4xQtRIynW/rUTh3PrUKZbJ0cpVvGkt6T
        EPZC/4M4w3yMj0KvF3ksGB70S4gKt1vWNezA
X-Google-Smtp-Source: AK7set/P+oolzHTrwrgRhR/VJcd07vKdY7v6a3rLMrnkkQWweMuUSeVVxFOAuXak7L6z/kwI0NFhiw==
X-Received: by 2002:a05:600c:2046:b0:3e9:f15b:935b with SMTP id p6-20020a05600c204600b003e9f15b935bmr25217852wmg.32.1680448257104;
        Sun, 02 Apr 2023 08:10:57 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id y5-20020a1c4b05000000b003edd1c44b57sm9307529wma.27.2023.04.02.08.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 08:10:56 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v2 2/2] selftests: net: add tc flower cfm test
Date:   Sun,  2 Apr 2023 17:10:31 +0200
Message-Id: <20230402151031.531534-3-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230402151031.531534-1-zahari.doychev@linux.com>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

New cfm flower test case is added to the net forwarding selfttests.

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 175 ++++++++++++++++++
 2 files changed, 176 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 91201ab3c4fc..72ed9b18ba28 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -82,6 +82,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_chains.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
+	tc_flower_cfm.sh \
 	tc_mpls_l2vpn.sh \
 	tc_police.sh \
 	tc_shblocks.sh \
diff --git a/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
new file mode 100755
index 000000000000..c93cab2d7876
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
@@ -0,0 +1,175 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="match_cfm_opcode match_cfm_level match_cfm_level_and_opcode"
+NUM_NETIFS=2
+source tc_common.sh
+source lib.sh
+
+tcflags="skip_hw"
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 198.51.100.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24 198.51.100.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24 198.51.100.2/24
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2 192.0.2.2/24 198.51.100.2/24
+}
+
+cfm_mdl_opcode()
+{
+	local mdl=$1
+	local op=$2
+	local flags=$3
+	local tlv_offset=$4
+
+	printf "%02x %02x %02x %02x"    \
+		   $((mdl << 5))             \
+		   $((op & 0xff))             \
+		   $((flags & 0xff)) \
+		   $tlv_offset
+}
+
+match_cfm_opcode()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm op 47 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm op 43 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 7 47 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 6 5 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+
+	log_test "CFM opcode match test"
+}
+
+match_cfm_level()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm mdl 5 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm mdl 3 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 3 handle 103 \
+	   flower cfm mdl 0 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 5 42 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 6 1 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 0 1 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level"
+
+	tc_check_packets "dev $h2 ingress" 103 1
+	check_err $? "Did not match on corret level"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol cfm pref 3 handle 103 flower
+
+	log_test "CFM level match test"
+}
+
+match_cfm_level_and_opcode()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm mdl 5 op 41 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm mdl 7 op 42 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 5 41 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 7 3 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 3 42 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level and opcode"
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level and opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+
+	log_test "CFM opcode and level match test"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+tc_offload_check
+if [[ $? -ne 0 ]]; then
+	log_info "Could not test offloaded functionality"
+else
+	tcflags="skip_sw"
+	tests_run
+fi
+
+exit $EXIT_STATUS
-- 
2.40.0

