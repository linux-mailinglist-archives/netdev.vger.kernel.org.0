Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C863F6C8304
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjCXRMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjCXRMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:12:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CECF21953
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso3610257wms.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679677925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VW3IChK5d/LMd19IisgoH//5UFlp1VHM94HpnaBU+Yc=;
        b=o/wu2Jp3AliRkeMPA3jrM6zYirVq78icMef0YJjAEAOIjono/Q1XQsI5GyyrPoG4Mn
         /zplq16SxtbGB00v1S0EpbjE6TuahnUvhbFvBEzK7EOEtFxWBCiB0ZM/SjFdOLZb7+L0
         fGXj2wQ3OoheKWQEOdTU3hWsrjGx3ffbfyJyRQk2b1QoJHXgACaWbJmzE+Um0J6PVQec
         m+XE4Urk/DSEjihv4hwjNOrwe5HYdSicRPPGqjP5fEiG8+dFtJfuST6Ju64clJeaPDj6
         1cAOw6vCNCxNd6KrMhGwSUGW04FVB6FsUkx0rk8h5F1fMJSjiTvNIl9WKAXRrzzBpFS0
         x9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VW3IChK5d/LMd19IisgoH//5UFlp1VHM94HpnaBU+Yc=;
        b=Xnx0HvRhFsvTrwdiynE8yFn7wnal+cMEp5o23o+sIap3UumGo4o7ff+iIz/OjhjanX
         /jHw73Gqs8jwrgfTTIbJ8r1DZCIcZQVEG93Lcfmx2DADAogK1zoWV6aydoDXMhqxdW7T
         4lN1kqlkVY2JDHgOb1h8c1sToDgbophGRxOjT+Cp3MOXMwYRRsiWZr4A4XHxLmV0g2pN
         nnxkuOXUZjGX/GQw3H0L0SqQQ/SRHV5HVZ8V6kr1yTpJJWVC/0lfTM3BUhw4fiOlzdYV
         yZuNvni4LqtzxTeMrFIo08YCaX8lrLY5eX0/IaOURiq7qwpHHs2lb2mcefr86JMmqm5l
         iU8g==
X-Gm-Message-State: AO0yUKUGfQbl+56dUJ3l2e1+lZ4ElV+dqSMcXiW3dehooBj67r5ozEGO
        OstqJ1fuMoXko22DdfeZwXUhbQ==
X-Google-Smtp-Source: AK7set9Ddt+oGDRksDZIet8cWvyZ3RtRihrRR2neOLbD2Y/AfLIHD+sypzV44DVmnrIeiPFDthtSNQ==
X-Received: by 2002:a7b:cb92:0:b0:3ed:88f5:160a with SMTP id m18-20020a7bcb92000000b003ed88f5160amr2989596wmi.11.1679677925645;
        Fri, 24 Mar 2023 10:12:05 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003edf2dc7ca3sm5336285wmc.34.2023.03.24.10.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:12:05 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 24 Mar 2023 18:11:33 +0100
Subject: [PATCH net-next 4/4] selftests: mptcp: add mptcp_info tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v1-4-5a29154592bd@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
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
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHdnhcKy+LEHHWVyW1OaYzW6ZE+zvu5rKivgtO
 i0d5UuW2PuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZB3Z4QAKCRD2t4JPQmmg
 cyO4D/0RGtWOVhnnPQw0U6tE5JDXBeBt38aOFdVXXGVKAaMChT/ipA+MJbbPLyLu55o1ZdX2YKm
 rLWSbnRvM8yU7ghzyEpHXk2tbX8LQYKw1p7ouIavViGk3Ocf0Y27jHIiHL9T+N5QHglV0nEfof/
 gR4yEYzo1Mp+V+Ci6ZVERiNRcPHfQ5sLf20NmRFuE5C20uI7RjoJQXE0oudnQHsLfeiSOhum0mr
 vbYcyou76rwW9PBaxETfRp7Mkm5rYJDG+v47PTNqM0u4YLgQZ6IiZmsjxEeKmosXYZHoTSsVTgF
 9AEX7ELhm1ZkwSrQNAhkuF60MQunJji7lTNqgqPPE9Zp597vtRJu+imWBIJ9ufTodR/tz99OeOx
 1AfHatFbnhs+/6kWxJZbCq8wqsnDWX+0Pn0ek13120mQi3xxzBViF7jpFNpgHMteasE2Mk43kr2
 AciC8ehADjSHMKYCYgXPbxshPleFBHhGaD3L0lL2Laavb1P9hKlga1HjVW2GcKreG/EvNF9m3WB
 R94iWn3cOSnIhguBkrICbDQbiNzjfYBuOK3ub/dHr8ZKlz6ak31vrkRiYXRiAA5Uc53gybtFuJl
 GcTOKQR2d4Kh4OpVsFDd2G7Hn1B9uGwsUuY4JKXAJ4w0lbshwNSd//jnoM2K1quptCELI4w8KhV
 Fm+mtOuhlL84RMw==
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

