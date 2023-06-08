Return-Path: <netdev+bounces-9196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DBF727D5D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9DCC2816D7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469F510958;
	Thu,  8 Jun 2023 10:57:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9CD11183
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:57:07 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B8DE57
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:57:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-977d7bdde43so106293166b.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 03:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686221821; x=1688813821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qreI1hqUHpp5PA9/eq4tj5bZsD2OeNPiiTS0Og/Hcmc=;
        b=oXv5eI8PDzw7cg8EvQOGwAGJgwV1dR8cyPgRKRMI1PBw0ySQ8GOTLUdxlTm+8ej4Ao
         /kQJStfvxyiJZ1W4CuIZHzIeJjr7fydxABbPcPxlgr0dkmrKlyxaej+mp9bT0hg4I+cv
         cZFAy23Njv7xf2pqK/8DCHHLtA6xVg0cwuK6sblFpXpSozmmmsDuXxtW1MLsb2gjavFm
         Ma+cNxYdZHFdH20om9cBMTtja6Pyflytu3CS7CXj5YEAtDZ8jQGx84BvQBM7qNfXP8AE
         Ttu3zdcUbUOZhlnII9+hhYlYyn/otaOcmcaClYLLVBvzzuCjx6l4RxyB96V5G6ktXBUS
         Mlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686221821; x=1688813821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qreI1hqUHpp5PA9/eq4tj5bZsD2OeNPiiTS0Og/Hcmc=;
        b=YFjTdz1TC7nn41rURclwN2kj8oHY+N5VPQNrUx1zbKyoDedH2ykGM75MBrEe+aS5eY
         ah/mHKNW7ZtGz1QjrbG7BdUUzbicvsw8kf02/dYgG4jbxBQC0JelI1N1W1+SSZjprA8G
         qSwkOgWArDEdvzStSLzzuFv6/jU9iewBdNegn7i4Gr7ve+WVs9761K7O7JQf4VwGBAJ1
         HODvQvZ7aFvpK94PmG6Hi2fwNin+2B5BTlhm3HGnQF9/29y0JtZ3vUV0TpihpRnC5ZJC
         GIkZCoVepD7TKM+oyo91THXypl9wpmrJcD9hRex9qN8k8UinHdoJHIxJQLeLgaHmYyng
         T4aA==
X-Gm-Message-State: AC+VfDz8BZU5z6O0X1woLpIVl+qsfKh57zA9DVb9wmPrhmQOiJTQSJ5o
	83o2BkYdAMtOBqWQ17n2SQa+wdNEUWtSZQ==
X-Google-Smtp-Source: ACHHUZ4jI0rSHLFtIJ+mphiZEm8hvQah16RNQhVE1x5ooXtr/cP+coo8/HOFzucHAeIzHaMLyk4RYw==
X-Received: by 2002:a17:907:3d9f:b0:973:87d3:80d4 with SMTP id he31-20020a1709073d9f00b0097387d380d4mr1811631ejc.18.1686221821507;
        Thu, 08 Jun 2023 03:57:01 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id t23-20020a1709064f1700b0094f07545d40sm522719eju.220.2023.06.08.03.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 03:57:01 -0700 (PDT)
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
Subject: [PATCH net-next v7 3/3] selftests: net: add tc flower cfm test
Date: Thu,  8 Jun 2023 12:56:48 +0200
Message-ID: <20230608105648.266575-4-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230608105648.266575-1-zahari.doychev@linux.com>
References: <20230608105648.266575-1-zahari.doychev@linux.com>
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


