Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5E6CA14E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjC0KYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbjC0KYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:24:24 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EBD618C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:24:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r29so8143148wra.13
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679912657;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VW3IChK5d/LMd19IisgoH//5UFlp1VHM94HpnaBU+Yc=;
        b=MHjCaeveR0nLvCez0W14hOk+lY88zGiY+MtGz7b37omDe49MRW//+Jh3ZX+LhPr0xf
         s38b+FeFevyydUSnJvBS9fnLrUofHcA8omadWCa31JPR4lCjzeWL3pNqmKUsXy9FpY7f
         PGBtJm4HVfSgIIp434awf4kpHGCJqZBQY9EvwL/CwRAx8eG3EuiXslx/hutQmuJXwveP
         /tzIs6Neyad/ysb/ObQKKswcmV5A3bzkqXKVmGuAlUopwt258xASbe5muXa9NQTtarM8
         LUyTmSjnRR645SKYQIIZC4garvFLy4rbiZYzDpVHd+/SeCbHXuN9YSRz5oJT8rpG7UfO
         nxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679912657;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VW3IChK5d/LMd19IisgoH//5UFlp1VHM94HpnaBU+Yc=;
        b=6sTwp39ZGlJieFfVK96pDcfKDWGyzU7yJCM8RLas0egUCtakWlT9zTfMVoArgYtKaL
         aWRnpiw7n00w3/N5ZDcv21Pvd0oLCaNpcgBI6nFRtSj4TqD7EtRIYLVewFhtzewU6b4P
         jOR00mksn+qiR0dkEHIVXqmtUCynKTsIDxE4Vf/fyfl7SOkAvgmouq9eTvcU8U+kbzI9
         Y+h7ojX2vGg22Uh0foKMUF+rfYVo/7ecGHKAHyh9Zu6iG2w9KeYdyKJi10EcuV4BKUF3
         WEWlwEvnMKD0C8tAch0Xzj31Ol2iXnBwwroYG4f2zg2yx5ZDuNHlJC3bAepZ5C9xEKKT
         PtrA==
X-Gm-Message-State: AAQBX9eKZpZ7DQ2zAFFoPYOqdVYvlUfWQxEjGHGG/bCuS4OhiasOTccn
        A/4PVeaEftqzgPquZ709L/lmjw==
X-Google-Smtp-Source: AKy350ZnTqf78NEN7xNAnvWTczWnbazaiB3XMXvoI9TF3wdfUBYXs4wNYne4EP6hBB0f6Yxpet1vwQ==
X-Received: by 2002:a5d:420d:0:b0:2cf:d25a:635b with SMTP id n13-20020a5d420d000000b002cfd25a635bmr8804536wrq.62.1679912657412;
        Mon, 27 Mar 2023 03:24:17 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c358500b003ef6f87118dsm2220615wmq.42.2023.03.27.03.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 03:24:17 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Mar 2023 12:22:24 +0200
Subject: [PATCH net-next v2 4/4] selftests: mptcp: add mptcp_info tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v2-4-fca1471efbaa@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2389;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=QeiNRTK3EtggzUHbWnfSGf4g3uU4Ocezndf67d7El5Q=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkIW7NXKdb4dxMlhzSbDAHfngN3I6Tno49jBB1w
 9wkpMWGEhGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZCFuzQAKCRD2t4JPQmmg
 c92dD/4zNxMiqdjA6KqIPL1tAFlRl6VCTI2idiN6Z8PkYq3y0q07BFbQ3otEDtfcVqcWc3C5r8V
 BOn2ssLS34vGjWxMofBz3E4L7CmUpgVBPuaLKHq0S8w/cM0nBuvCsqoyDM8XaHvGqlyYEIdkhcq
 FkjwM4Ut40WYZbZfeeMPtR9AzYSVwHrTIj0a9U++UV3Bw51bOVI3T3KqctrGf+YNEL//byka15o
 h+eSU4pZ5dZcWj/ohiSaBKZ7bmKaGBoE2ttG/Dp5NQftUakEdWEVy4jNumKOSIVjBx+TWbGeicU
 ObkYtZF+OxWdfCuPjc5vNJIkzBh5vmziu89eiEclc7l17/2bacpfVX0he1F7l7jfx8heml1bMbJ
 KcFhuB2CbjK4btrsgRaWWD1gCcof6AvTBSoE5cIMIrH2RWo9aNZJ2XL+KAg+5XCOopi0CNniWdG
 1bjehBk62nXEKfp5jMsK6qH777uJPKRQs6M575gSI1Fd9ZBV6VC+UWGaZ99b5dztnzIHZd+YS3t
 5mtb/xFZ/mm0LA7hLqpHCNiyFUIf0A9NvspXvQ3jEpCYG1vSkcb3mKA6YbFi3bXxjUJVeOW5ZJD
 t9Fp+30MyxxZeJ+AaVHnhWfrFJhRTATxYf7ZDPxB+oPBVluRzNl40Bbs+ajQ4A95dszExXBfj5J
 /5v6Gn9hz8U7XFQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds the mptcp_info fields tests in endpoint_tests(). Add a
new function chk_mptcp_info() to check the given number of the given
mptcp_info field.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/330
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 47 ++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 42e3bd1a05f5..fafd19ec7e1f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1719,6 +1719,46 @@ chk_subflow_nr()
 	fi
 }
 
+chk_mptcp_info()
+{
+	local nr_info=$1
+	local info
+	local cnt1
+	local cnt2
+	local dump_stats
+
+	if [[ $nr_info = "subflows_"* ]]; then
+		info="subflows"
+		nr_info=${nr_info:9}
+	else
+		echo "[fail] unsupported argument: $nr_info"
+		fail_test
+		return 1
+	fi
+
+	printf "%-${nr_blank}s %-30s" " " "mptcp_info $info=$nr_info"
+
+	cnt1=$(ss -N $ns1 -inmHM | grep "$info:" |
+		sed -n 's/.*\('"$info"':\)\([[:digit:]]*\).*$/\2/p;q')
+	[ -z "$cnt1" ] && cnt1=0
+	cnt2=$(ss -N $ns2 -inmHM | grep "$info:" |
+		sed -n 's/.*\('"$info"':\)\([[:digit:]]*\).*$/\2/p;q')
+	[ -z "$cnt2" ] && cnt2=0
+	if [ "$cnt1" != "$nr_info" ] || [ "$cnt2" != "$nr_info" ]; then
+		echo "[fail] got $cnt1:$cnt2 $info expected $nr_info"
+		fail_test
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	if [ "$dump_stats" = 1 ]; then
+		ss -N $ns1 -inmHM
+		ss -N $ns2 -inmHM
+		dump_stats
+	fi
+}
+
 chk_link_usage()
 {
 	local ns=$1
@@ -3118,13 +3158,18 @@ endpoint_tests()
 		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
 		wait_mpj $ns2
+		chk_subflow_nr needtitle "before delete" 2
+		chk_mptcp_info subflows_1
+
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
 		sleep 0.5
-		chk_subflow_nr needtitle "after delete" 1
+		chk_subflow_nr "" "after delete" 1
+		chk_mptcp_info subflows_0
 
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 2
+		chk_mptcp_info subflows_1
 		kill_tests_wait
 	fi
 }

-- 
2.39.2

