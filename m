Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46579698474
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBOT0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:26:15 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA693E612
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:26:12 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id s13-20020a05600c45cd00b003ddca7a2bcbso2358197wmo.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaznaxhk9gZfQ+TI/Y8cvfWf4/Negg6OESJST+OGz9k=;
        b=CEAeGDQlIhCLdWyRp6aTGiOZfiqXTgsl10n5xOO3yeMNqoJ+GWVkfpTlXMBB9OwrIG
         xcaAFp8PpcVCl5unWjaB04Bg5k88efPHxZYK6IGe0kOmfnxo0NSTGCMatIz2f29F0iJo
         W/9e6iZoui1Q49BdcjNvs0IBSAj2Sog6lVAB88Y52v2SQ9oPOr4Zgc/woYTn9ckr5EQY
         aNoIAFCCLFj20/+pc/e7+NS1Wc3JAxBXrR4cQLJBqnTG66HC7ZTmQNmdYscd5sb4i+ql
         UY3ODAeWZOo3NBjnH96/PQ+YvUzAb+sg7cK1+L86O6sfrfj5fdPOTLUOz1GhDpam2upG
         a2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kaznaxhk9gZfQ+TI/Y8cvfWf4/Negg6OESJST+OGz9k=;
        b=4kNAmSaX167dqssC8SfprFu87GBW1zXRtGtx7xf6u2RyFruenw9oTXLHvXIcxt1pBd
         +LSLfEEEnuXvHV/8UtGXAUV4HYefK1TO13DQ2eY81glLsQjl3axixDcA/QQo75vuJoDb
         Y56DSL3x3ZY5uoEU2cN3tGMg0kV96XYiSvL9qPHe0tuuiCj4V20S/zs+QQN6CWlFI1OC
         PF/J7JcZR5HfuIDeelYJazHBPChwK5xmOkc9eQdn2BHZN1DoP1I16xOFaYxw37FhToS2
         fYYVwQTIJk6WWJB4YUSG9PrjOBo/gl+Q7FrinJjWg8qkPxbn0D5BgnPmx8jQjgkpD6td
         r45A==
X-Gm-Message-State: AO0yUKXJv9hptq8irBIadv4rcANF+/SmCbzNOb4mweOVM3iIwjGgi3t1
        TziYVhh//0QGc/sjdnXHAWGbsHlxBFaBiw==
X-Google-Smtp-Source: AK7set9qu3ELm3Lgeagji5PXQ6mZeSGnER5c/IRxJEWVyfuTyglyBKe02Up/ESJwDR8TrwsqBjxkMQ==
X-Received: by 2002:a05:600c:3b17:b0:3df:efdc:6505 with SMTP id m23-20020a05600c3b1700b003dfefdc6505mr4119241wms.0.1676489171475;
        Wed, 15 Feb 2023 11:26:11 -0800 (PST)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id u1-20020a7bc041000000b003d1d5a83b2esm3024399wmc.35.2023.02.15.11.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:26:11 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next 2/2] selftests: net: add tc flower cfm test
Date:   Wed, 15 Feb 2023 20:25:54 +0100
Message-Id: <20230215192554.3126010-3-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215192554.3126010-1-zahari.doychev@linux.com>
References: <20230215192554.3126010-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
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
 .../selftests/net/forwarding/tc_flower_cfm.sh | 168 ++++++++++++++++++
 2 files changed, 169 insertions(+)
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
index 000000000000..c536a3bba8e7
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
@@ -0,0 +1,168 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="match_cfm_opcode match_cfm_level match_cfm_level_and_opcode"
+
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
+
+	pkt="$ethtype $(cfm_mdl_opcode 5 42 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 6 1 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
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
2.39.1

