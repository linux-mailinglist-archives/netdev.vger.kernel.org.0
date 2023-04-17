Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4CC6E53E8
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjDQVc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDQVcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:32:55 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F328B4EC4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c9so29092746ejz.1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681767171; x=1684359171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Swqr8f5iTSDQJesOkVMR28rdhhUjexNl96oyGcoDwB0=;
        b=ejIQt7d1iTMVcn5XnGgOEE3GOqmjMpU7Icyvksu3rX7yzsct8G5wdlHmkMdAEuINM+
         8P9h8ms8eAFvbsh0kMLsXVVDjAvAYRdm6/gx4rf0T+Y7sRMPJr58LDpnb8pTX2BQq5KS
         sz5v/QqnTPXdVRr/1V4gVqSKn0rMldPOtnXo50KrpKOCOt88YBqRMN0Dd7+3XgVe6t5j
         S8TRm8EtO0yQiSw6+3W4K/LhGMqzirh0q/17aDxTUboP2s980f6RpjR4ELE4fEtp+ScW
         jqQshAkP+1Lfbz/RB9bTPA87Cuet8Fwgn4u8cJwfrnjchdq1Z+U77s51Ks1olU2M1XC9
         mizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767171; x=1684359171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Swqr8f5iTSDQJesOkVMR28rdhhUjexNl96oyGcoDwB0=;
        b=jbjix1X+O48Eb7VcM4MrkJXX+wNYTZT5b0EQ/L+cO2W1UzGNpW5b5DVnS50oWpJDko
         5OPXtqN+qoBY8EKI2mxjplatC0j5w/bKfmcFuVgl69xlh8ZynxGjKZd0weLj6+GwoK94
         7JgaYcYCPDlI2tb+A10sQaNeOrBsdhTI/+YkZKspmBZQiGK5Hfan6sScVMlWqKLRYWo/
         SusE/ag8dEUKqi1iADkccyZV1/bf//PA8Gs4jgN/zdxYRk+qqGDK7mPg2kC2e5eqhaUq
         vEiP5f/32iC0wBH1sp5pvBKehiKyxA29tA1sNh0e3wzOeaJQv5iLc4oHsXXpH2uaJLc6
         IG9A==
X-Gm-Message-State: AAQBX9cEmupD1/1N4v8Phvg5/XEugrCi4wDP6DUNlneGuoblxpd675Mg
        2UiZN87MHgXQBbxQG2vFXyIXrsQq9S/00Zhb
X-Google-Smtp-Source: AKy350bpzWRpvEWGnfYSvVL+5jz4k24m/7916/XsUPp7na2hOhypNJ/OgPHydQ08RjrS/Gv4HEvnAw==
X-Received: by 2002:a17:906:3747:b0:94f:ca5:1a66 with SMTP id e7-20020a170906374700b0094f0ca51a66mr8867521ejc.59.1681767171381;
        Mon, 17 Apr 2023 14:32:51 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id k18-20020a17090632d200b0094f05fee9d3sm4670005ejk.211.2023.04.17.14.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 14:32:51 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v3 3/3] selftests: net: add tc flower cfm test
Date:   Mon, 17 Apr 2023 23:32:33 +0200
Message-Id: <20230417213233.525380-4-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417213233.525380-1-zahari.doychev@linux.com>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
index 236f6b796a52..3938e664d4ce 100644
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

