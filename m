Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880D86CD784
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjC2KTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjC2KT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:19:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0165E1BFC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso18114987pjb.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680085161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyDsFywFCd6WqmKjeh/An22gklCrWTW6n6drcMwOH7U=;
        b=gSiaDA8F++P5mR5F++3hEReL7T3Mn71YbMODjNPUaa8+Mm17s4NKgBn7Opm7L1BUUU
         8mw1ZI9KGgbIUyRf7xe2sBFKsDxIDsxK3kH3d03l6g1t+uh6FewZh6seObcgVBPFivq4
         SiSXYGudwnMC+oBHoj2n5U7yBhQ/qSaAdUp77sFOq9ZkEn9LAP/Bv2ysi4OnGKd15PTF
         dExDECYr4R6KlyfA02OPJW9oWOZulEQNz9iN5I7wkyQRD3aayR5DwxVXNmZeN8gVFITA
         yfD5KnSXhxISMPwja2GEDVYI0/26YLVyWJzZzj18TIIRtOEUl9cW3tjo0f+vL1ICTzgX
         nHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680085161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyDsFywFCd6WqmKjeh/An22gklCrWTW6n6drcMwOH7U=;
        b=xIiAYRJVWctUsrBqFt9vMNZc/DfujuKlMcmrQvdnbj+CMeY+aiqXhUt15oWcJYidtL
         mEV/qB0cMQt8glRPDMkeorew+dXioS/bEabyBiRVKBkj64BsGYxtJG6DX93+qQ2R4HaJ
         9qjeB7WfF3BKbryio8Z0/gsK6T6rFDuti7eJx9y64K7oSq5FwdnTwmcXSbfZ+//r0hPD
         /vno3wLwkZBl+qvUsAfSje0M1WxykrDb4onW/z0cU552Xj4NxgedijaqtVrV321l4axp
         ZddAAlREoNSt9Urhc5/NcO0VzPf3KZvgtQaKm5g916x9c8tNY08yNiLe83Wfbxy2ZywL
         TBTg==
X-Gm-Message-State: AAQBX9dyB3o0HO/yTgHhuiAo686wliLkVm+7LScvp7BcgJEEWRCDlMLY
        HKb+0N2Rn6y9SpbwQD+t4UNmBPu6DE1Z1A==
X-Google-Smtp-Source: AKy350aEvOmxg2ZGdYsUt6Ljy1sMt8cirN+VcgPTasLn5ROjo9krUP890+bOEys4i4AbkQ7SHtDbLw==
X-Received: by 2002:a05:6a20:cf45:b0:de:d3ce:9d14 with SMTP id hz5-20020a056a20cf4500b000ded3ce9d14mr11914248pzb.60.1680085160618;
        Wed, 29 Mar 2023 03:19:20 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id a17-20020a631a11000000b0051322ab5ccdsm9304653pga.28.2023.03.29.03.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 03:19:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 3/3] selftests: bonding: add arp validate test
Date:   Wed, 29 Mar 2023 18:18:59 +0800
Message-Id: <20230329101859.3458449-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230329101859.3458449-1-liuhangbin@gmail.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add bonding arp validate tests with mode active backup,
monitor arp_ip_target and ns_ip6_target. It also checks mii_status
to make sure all slaves are UP.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../drivers/net/bonding/bond_options.sh       | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index 431ce0e45e3c..4909d529210c 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -5,6 +5,7 @@
 
 ALL_TESTS="
 	prio
+	arp_validate
 "
 
 REQUIRE_MZ=no
@@ -207,6 +208,60 @@ prio()
 	done
 }
 
+arp_validate_test()
+{
+	local param="$1"
+	RET=0
+
+	# create bond
+	bond_reset "${param}"
+
+	bond_check_connection
+	[ $RET -ne 0 ] && log_test "arp_validate" "$retmsg"
+
+	# wait for a while to make sure the mii status stable
+	sleep 5
+	for i in $(seq 0 2); do
+		mii_status=$(cmd_jq "ip -n ${s_ns} -j -d link show eth$i" ".[].linkinfo.info_slave_data.mii_status")
+		if [ ${mii_status} != "UP" ]; then
+			RET=1
+			log_test "arp_validate" "interface eth$i mii_status $mii_status"
+		fi
+	done
+}
+
+arp_validate_arp()
+{
+	local mode=$1
+	local val
+	for val in $(seq 0 6); do
+		arp_validate_test "mode $mode arp_interval 1000 arp_ip_target ${sw_ip4} arp_validate $val"
+		log_test "arp_validate" "mode $mode arp_ip_target arp_validate $val"
+	done
+}
+
+arp_validate_ns()
+{
+	local mode=$1
+	local val
+
+	if skip_ns; then
+		log_test_skip "arp_validate ns" "Current iproute or kernel doesn't support bond option 'ns_ip6_target'."
+		return 0
+	fi
+
+	for val in $(seq 0 6); do
+		arp_validate_test "mode $mode arp_interval 1000 ns_ip6_target ${sw_ip6} arp_validate $val"
+		log_test "arp_validate" "mode $mode ns_ip6_target arp_validate $val"
+	done
+}
+
+arp_validate()
+{
+	arp_validate_arp "active-backup"
+	arp_validate_ns "active-backup"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.38.1

