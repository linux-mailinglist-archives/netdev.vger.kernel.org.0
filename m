Return-Path: <netdev+bounces-8623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EBB724E64
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC8A281069
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784182A9EA;
	Tue,  6 Jun 2023 20:59:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0246BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 20:59:52 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B053D1707
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:59:49 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51478f6106cso266417a12.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 13:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686085188; x=1688677188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qreI1hqUHpp5PA9/eq4tj5bZsD2OeNPiiTS0Og/Hcmc=;
        b=I8iSfoXgkhZljzEzsMGzcJ1jVnvt0fhp0JwItUAJf5+OrAjHyEnGFQV1zQW+I++ZXA
         XJ73fbgE+FPXPy/6RqZb8OAew5YUjmk/jWonNB7C/4IOjgdcrUfIRmQZmk6nuyD1PkZ8
         O335ncDrI6FF8kNeBafy9p4LyHvAmsKadRqFe0D90rLDuPL9pNRz80ZMda9vQ3TByJhD
         NJpBJeiV1CtTUgLnCnTTmiU+DsFlA0NoYvYK0a5ryGRRH5GYA8Y1HulQtQK+keb3hrz7
         j5ytuJ3UtZpZyvbg1Hc/jjg1pIm5o3NyAh4Huu+tGFtw9MZncNGb+gWPGUEjpiSHn5Kq
         2GLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686085188; x=1688677188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qreI1hqUHpp5PA9/eq4tj5bZsD2OeNPiiTS0Og/Hcmc=;
        b=f2L3lHRZIEcmy2035nB2lrM19gR6LLDpjdJKhxi3IgWa5MuGvwiSTE+gziS/UiCjtw
         DFehrc2IIPjX/RGnG42MPG5UXsGIirXHq478SBj/qc5ZQrhqylLOx/SFvpfljS+rCv1A
         WChxX+WcURrHGR3wP8gYRsHzVl6Ue7fLP86YTZyQc9iiqC9M7FqSMYqqzCWPS2rhZEg6
         I0G+DJIhy7lTRKrtm/0YDzMuTKOJyarlOjhIPy36JnCkHc9JHb9MzfsQbTZ/7vEl1/Gu
         ZNCqaXBzRxESqJWigwdmt9UcQ6UtNkWY1Dk2yQMW3foeSDqTp/oxGVX6M42Mb62FqHfo
         +n4A==
X-Gm-Message-State: AC+VfDzIE759VP5Kse/F91+kJEBB5bgNHsTzunyOKGXa7T2ZNgmNsQMK
	t12BAoTj0lUzmz31BriejMdldath2Y5/xQ==
X-Google-Smtp-Source: ACHHUZ6rqwecyLmvgXKPuQ/Ke705Cc3gZXDLA7RrExcyqLxT02l6Itp2Q16GdPUOHYSG1LLVVfYX4w==
X-Received: by 2002:a17:907:6d12:b0:94a:9f9a:b3c4 with SMTP id sa18-20020a1709076d1200b0094a9f9ab3c4mr3643516ejc.49.1686085188104;
        Tue, 06 Jun 2023 13:59:48 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id l1-20020a17090615c100b0096a742beb68sm5926162ejd.201.2023.06.06.13.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 13:59:47 -0700 (PDT)
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
	Zahari Doychev <zdoychev@maxlinear.com>,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v6 3/3] selftests: net: add tc flower cfm test
Date: Tue,  6 Jun 2023 22:59:35 +0200
Message-ID: <20230606205935.570850-4-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230606205935.570850-1-zahari.doychev@linux.com>
References: <20230606205935.570850-1-zahari.doychev@linux.com>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
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
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
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
2.41.0


