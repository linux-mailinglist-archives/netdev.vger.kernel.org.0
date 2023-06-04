Return-Path: <netdev+bounces-7758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF6672167F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BBBD1C209CE
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80E2610B;
	Sun,  4 Jun 2023 11:58:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B816E6105
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 11:58:43 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFEFDB
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 04:58:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-514924b4f8cso5823154a12.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 04:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1685879919; x=1688471919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ii6auBWFOcts3/7J6XdecyIokJCCV6x8hc4jAPM7Jc=;
        b=LI2lErtq4/C+beeBNmOY4dAmXE0zHMgJWE+ulpwLYs2MAdE61ja+6sfibU8IL2qlOk
         zSbArhtm8UoL1stiokmguT8hfdJz17zvvki+7UwhPBrAarLqsgPHzc7xgIXKB1K6GQXf
         4cHQaiH1SkLfSUPImsKqstdH7/CPRhPss0FoI6YVV9UP/yO8EJb1bWGEkGHJ2gzTi/Mn
         uDeGNA5GOTE6uYB3ycxqM8nNbYo0J7NQwnhI/Yj6yPO6m/KMB6QUgl4nSFaxz6Ab/zno
         1L2vDoFOc6dVbP5Z1neogcKP3J7aV0rhrG3cvYZFROiilZ9yurKybNhf02H1NIfnAby0
         VNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685879919; x=1688471919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3ii6auBWFOcts3/7J6XdecyIokJCCV6x8hc4jAPM7Jc=;
        b=FFzuxohL9eLDbo3NH+zaC2nP1wi/OQR2uXgBe/kiOi8ye06cd+T5RcMAOP54zUgcIO
         dn7/4NOvQ23r5rZ1OCRfmPMQxbMsYe/mB+OBZIUznXl4Edxiaf8XXwIspn22f1YCOhSy
         7xyaRhoOWAt+FnJyhriWStdIpWZWZMp3EVb5DtN5KxD5NRyMjEIrxHYPO8HNTa3JIwOF
         FW5k3DVf+CyWJxPHCRW/5SngYmL1TQR7vWEUP85hsS1kymlD3fuX1Bcg1S6EP30PUkHZ
         HbdKVKgWo/ONWaeeU7PMHoZSN6h+i6WOBmEO0crM4hCRU3tExnZWgFJN0LLVzYO9qDRT
         QMDA==
X-Gm-Message-State: AC+VfDzwfdQdKnHDtQ8kmwUFxxzH0JnAKSNuwEBrS9wTOSWVyb06Pov0
	ky2AvgmmhEQilrUDnmVTOjoCd+Hn5/dT2g==
X-Google-Smtp-Source: ACHHUZ7F+z6UQDIKxz52CJ8lOBk+xrGcbFKI+Rv2iXoLDfoAiu17uWC4dX6CW25VpKyDiHMJTIDzTg==
X-Received: by 2002:a05:6402:8c6:b0:514:92d8:54b3 with SMTP id d6-20020a05640208c600b0051492d854b3mr5323861edz.12.1685879919535;
        Sun, 04 Jun 2023 04:58:39 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bc10-20020a056402204a00b00510de087302sm2706489edb.47.2023.06.04.04.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 04:58:39 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From: Zahari Doychev <zahari.doychev@linux.com>
To: netdev@vger.kernel.org
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com,
	simon.horman@corigine.com,
	idosch@idosch.org,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v5 3/3] selftests: net: add tc flower cfm test
Date: Sun,  4 Jun 2023 13:58:25 +0200
Message-Id: <20230604115825.2739031-4-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230604115825.2739031-1-zahari.doychev@linux.com>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

New cfm flower test case is added to the net forwarding selfttests.

Example output:

 # ./tc_flower_cfm.sh p1 p2
 TEST: CFM opcode match test                                         [ OK ]
 TEST: CFM level match test                                          [ OK ]
 TEST: CFM opcode and level match test                               [ OK ]

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 206 ++++++++++++++++++
 2 files changed, 207 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 9d0062b542e5..770efbe24f0d 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -84,6 +84,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
 	tc_flower_l2_miss.sh \
+	tc_flower_cfm.sh \
 	tc_mpls_l2vpn.sh \
 	tc_police.sh \
 	tc_shblocks.sh \
diff --git a/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
new file mode 100755
index 000000000000..3ca20df952eb
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
@@ -0,0 +1,206 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="match_cfm_opcode match_cfm_level match_cfm_level_and_opcode"
+NUM_NETIFS=2
+source tc_common.sh
+source lib.sh
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
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2
+}
+
+u8_to_hex()
+{
+	local u8=$1; shift
+
+	printf "%02x" $u8
+}
+
+generate_cfm_hdr()
+{
+	local mdl=$1; shift
+	local op=$1; shift
+	local flags=$1; shift
+	local tlv_offset=$1; shift
+
+	local cfm_hdr=$(:
+	               )"$(u8_to_hex $((mdl << 5))):"$( 	: MD level and Version
+	               )"$(u8_to_hex $op):"$(			: OpCode
+	               )"$(u8_to_hex $flags):"$(		: Flags
+	               )"$(u8_to_hex $tlv_offset)"$(		: TLV offset
+	               )
+
+	echo $cfm_hdr
+}
+
+match_cfm_opcode()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm op 47 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 102 \
+	   flower cfm op 43 action drop
+
+	pkt="$ethtype $(generate_cfm_hdr 7 47 0 32)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(generate_cfm_hdr 6 5 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong opcode"
+
+	pkt="$ethtype $(generate_cfm_hdr 0 43 0 12)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Matched on the wrong opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 102 flower
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
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 102 \
+	   flower cfm mdl 3 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 103 \
+	   flower cfm mdl 0 action drop
+
+	pkt="$ethtype $(generate_cfm_hdr 5 42 0 12)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(generate_cfm_hdr 6 1 0 70)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(generate_cfm_hdr 0 1 0 70)"
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
+	pkt="$ethtype $(generate_cfm_hdr 3 0 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Matched on the wrong level"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct level"
+
+	tc_check_packets "dev $h2 ingress" 103 1
+	check_err $? "Matched on the wrong level"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 102 flower
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 103 flower
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
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 102 \
+	   flower cfm mdl 7 op 42 action drop
+
+	pkt="$ethtype $(generate_cfm_hdr 5 41 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(generate_cfm_hdr 7 3 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(generate_cfm_hdr 3 42 0 12)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level and opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level and opcode"
+
+	pkt="$ethtype $(generate_cfm_hdr 7 42 0 12)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Matched on the wrong level and opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct level and opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 102 flower
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
+exit $EXIT_STATUS
-- 
2.40.1


