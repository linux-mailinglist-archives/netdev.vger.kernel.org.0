Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B016EE97D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbjDYVQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbjDYVQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:16:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31281713
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so47228243a12.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682457404; x=1685049404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqCedDmmF7yBEugz7p/YkDn2MQyPpHbHHpfVId2HMOc=;
        b=EMiv3tM/R+d2KGUzyUk0g1xLyMAdmECJJuI5Mm5KA5XX/yHUuBtv4Wf3TeNEe7MLlZ
         zdjX2N7Srq46BXz5CcgLGlt8ncHDw32F/y9NCKq6iEo+SZKQz38z73Q3WLJpIdC3ckX1
         oo0wXud6Ek/Ch6C+ELBi8Fo5trL8POQuwFv2J4ooSQePfwc1QNTrmbAcdr+gi6qbgbEd
         974GcW6q2hI0Otsle9h/FzoUtPkvIrkRS35e4RLDCHCCW8iumw3u/0uUbdZg7AiXDqZe
         EdtIpkpSy+NWcZ6SvCuXfeB8dPVJ/derydeIgfa7U2xqgbmGzB2i1dsMrPc21s42Zcvi
         jCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682457404; x=1685049404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqCedDmmF7yBEugz7p/YkDn2MQyPpHbHHpfVId2HMOc=;
        b=c8b4msnwYa6lcljL/Ah4PeIHUccYZ3QQw6ncP5ejVMokJi8YctJUSMQp8T+n63FQPi
         iMwQaaDokOTZWfHntyfcxiC2vTLBKg1tgh17OzVn8ALLufhRx+IYH9Ziyxtnk6p7Ueqk
         +vc4UCJbF3US6VI918pTOKar9zUO28qcaQhkoPPgtwx7fIQ9SxSnwwrsAAskPlEqI/IX
         SUgSj+6VS8KuGwzLemHw5olMIifHdhH8d4be8xqwSRHCVQZNakhzOLZS0ettnxMUO5BT
         7Iq50lUnrlnBpolUT1lJm2l13o6mCqS9ambXB8r7vcw7Wuip/Gd5DyTjBJzrqdiAZToq
         p8Zw==
X-Gm-Message-State: AC+VfDzxKaFSg6/hWnXRnDDYaYTA6M0hsSJvRdzrwvQtWO5sFfdVUtZ7
        iZsqUhGB5LpUdCYgrtCuIh6aku6vEsmkuQ==
X-Google-Smtp-Source: ACHHUZ45KFz+ckQSblNEQeJoKT7iMacdepCP05GVatCN/BOjHiJynI5o+GwURmT1Qaz1EwO5CiLEBw==
X-Received: by 2002:a17:906:5e0d:b0:94a:8e19:6aba with SMTP id n13-20020a1709065e0d00b0094a8e196abamr219822eju.21.1682457404180;
        Tue, 25 Apr 2023 14:16:44 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bv7-20020a170907934700b00959c6cb82basm2302896ejc.105.2023.04.25.14.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 14:16:43 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        idosch@idosch.org, Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v4 3/3] selftests: net: add tc flower cfm test
Date:   Tue, 25 Apr 2023 23:16:30 +0200
Message-Id: <20230425211630.698373-4-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425211630.698373-1-zahari.doychev@linux.com>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
index a474c60fe348..11fb97a63646 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -83,6 +83,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_chains.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
+	tc_flower_cfm.sh \
 	tc_mpls_l2vpn.sh \
 	tc_police.sh \
 	tc_shblocks.sh \
diff --git a/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
new file mode 100755
index 000000000000..0509bc3c9f75
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
+	check_err $? "Did not match on correct level"
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

