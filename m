Return-Path: <netdev+bounces-1027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B32F76FBD8E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98931C20AB1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D9E20F2;
	Tue,  9 May 2023 03:12:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4095256
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:12:29 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72D87ED2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:12:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6436e075166so3974133b3a.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601939; x=1686193939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=kOeeKsuQ00vEMLgss4RT6cm83FEuwEX/53MbDqidwMAq29v5DUa96D2mTIN2V1yI8G
         pjVESI2qNRVoPvlO5wneSRFywMUN9eij5D/7RYY3sY1SSElui35p7gumpbgOH3l/exr0
         hg7XGzv2c4vsGQ65UJ9uUFrxjh1sPCg10eOnfbKGB/UNIQZIDRJRKPf+q3FzHBaPSTCb
         dLub6x82p00bqwaRZ9GrTxbbSYvm62ydWdTfXFNnaLrt4TolWcGSPoF834Ms6pUlst7H
         cY8l4YL20yms84sGTw1hAT7CoMZY5qAuExSnyo9IvwuRLGlEZMfwfb6ExYuaY4kqbwwT
         P8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601939; x=1686193939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=OJyleHqjWk0bLmpw4H+M+irisUxQyeaNC7quye0namaZahSrPqwNjKcHhxtYiAue+U
         XlkeuMCySA1mHexhDST17hd3L06RROn4jXY7eVtRRTbhOHErWywDMXeT+QJK5fkFKRgK
         O7yLYT1HniHpOVcnxQT8pfwzHd5gWNBLpJoersxn/iTI19qpoHcV5LjZXhZ1sf/kv1w8
         k+yLIYphXMZqMXMm/oBZTt5ok6yQvEzG8Cu3cO0Rh7a/qxrQQeqzbxl+QiPXux3KUI/O
         TdD71DdeBBDfbXvSKMMkjsM2PtNJWxU0lkhKFhKVhRandpqiL7A/Idxb7+lThbz88XcQ
         YEVA==
X-Gm-Message-State: AC+VfDzllUkG/nZT2YAKdEmgV3Yoe0Ab1F82FeX5Dx2MYyI84ZUANSNX
	rJNyLackPa312O7sk0NhWYM4ejNUqoIDoM2S
X-Google-Smtp-Source: ACHHUZ5Kg+RkPU/vABzty7mo2Rlulk7V7yNE/ttkhFFCpdd4TR0gEHFdnGvIAhOo4dnME+Pcw48k6A==
X-Received: by 2002:a05:6a20:7348:b0:db:b7:fe3f with SMTP id v8-20020a056a20734800b000db00b7fe3fmr16066348pzc.10.1683601939369;
        Mon, 08 May 2023 20:12:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001ab19724f64sm250768plx.38.2023.05.08.20.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:12:18 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Liang Li <liali@redhat.com>,
	Vincent Bernat <vincent@bernat.ch>,
	Simon Horman <simon.horman@corigine.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 4/4] kselftest: bonding: add num_grat_arp test
Date: Tue,  9 May 2023 11:12:00 +0800
Message-Id: <20230509031200.2152236-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509031200.2152236-1-liuhangbin@gmail.com>
References: <20230509031200.2152236-1-liuhangbin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [ OK ]

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../drivers/net/bonding/bond_options.sh       | 50 +++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     |  2 +
 2 files changed, 52 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index db29a3146a86..607ba5c38977 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -6,6 +6,7 @@
 ALL_TESTS="
 	prio
 	arp_validate
+	num_grat_arp
 "
 
 REQUIRE_MZ=no
@@ -255,6 +256,55 @@ arp_validate()
 	arp_validate_ns "active-backup"
 }
 
+garp_test()
+{
+	local param="$1"
+	local active_slave exp_num real_num i
+	RET=0
+
+	# create bond
+	bond_reset "${param}"
+
+	bond_check_connection
+	[ $RET -ne 0 ] && log_test "num_grat_arp" "$retmsg"
+
+
+	# Add tc rules to count GARP number
+	for i in $(seq 0 2); do
+		tc -n ${g_ns} filter add dev s$i ingress protocol arp pref 1 handle 101 \
+			flower skip_hw arp_op request arp_sip ${s_ip4} arp_tip ${s_ip4} action pass
+	done
+
+	# Do failover
+	active_slave=$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].linkinfo.info_data.active_slave")
+	ip -n ${s_ns} link set ${active_slave} down
+
+	exp_num=$(echo "${param}" | cut -f6 -d ' ')
+	sleep $((exp_num + 2))
+
+	active_slave=$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].linkinfo.info_data.active_slave")
+
+	# check result
+	real_num=$(tc_rule_handle_stats_get "dev s${active_slave#eth} ingress" 101 ".packets" "-n ${g_ns}")
+	if [ "${real_num}" -ne "${exp_num}" ]; then
+		echo "$real_num garp packets sent on active slave ${active_slave}"
+		RET=1
+	fi
+
+	for i in $(seq 0 2); do
+		tc -n ${g_ns} filter del dev s$i ingress
+	done
+}
+
+num_grat_arp()
+{
+	local val
+	for val in 10 20 30 50; do
+		garp_test "mode active-backup miimon 100 num_grat_arp $val peer_notify_delay 1000"
+		log_test "num_grat_arp" "active-backup miimon num_grat_arp $val"
+	done
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
index 4045ca97fb22..69ab99a56043 100644
--- a/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
@@ -61,6 +61,8 @@ server_create()
 		ip -n ${g_ns} link set s${i} up
 		ip -n ${g_ns} link set s${i} master br0
 		ip -n ${s_ns} link set eth${i} master bond0
+
+		tc -n ${g_ns} qdisc add dev s${i} clsact
 	done
 
 	ip -n ${s_ns} link set bond0 up
-- 
2.38.1


