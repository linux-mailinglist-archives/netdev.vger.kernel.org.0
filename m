Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5B423D4C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhJFLuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238666AbhJFLuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:50:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E58BC0613EC;
        Wed,  6 Oct 2021 04:48:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v18so8714078edc.11;
        Wed, 06 Oct 2021 04:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MPgQCPkYaOpHja7N0AhXNyX4WW/+9TkQblRPZxpVE+k=;
        b=JubygY18ja+WTyxK/Qi/6q9linLjbd9murzVIylYEOxlbXvystozejq4NTkBBM2E2v
         BMwy9oVkPhXVNMaqM1QG/p9CVRjE1t/I5isyLv2CYzxd3c6WE8p5gT9wTd4aEU9QEqap
         sW2lbQ0L4tzqGaZitdlOYznPtxjbipIX9cZfm40VmkrfxTq+ubvFy458UxreVMg6lW0w
         K++zoGFb4LexRTiNQPa34XQXtdFgnSwg4rM0N6np5ASb41w6IWdlwvuioaJAePT+Gsis
         dvd73znCNjxwJcbbkAnH/a8FZjhVrfKsz7VwpPHUNYl4uYGWvz/LsNEnmpIb6fnkWLGo
         GtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MPgQCPkYaOpHja7N0AhXNyX4WW/+9TkQblRPZxpVE+k=;
        b=noVaYCmpXgHPt97ey3iCK71mLkGmnxMRg/zpXisy6UcDtbMB8q1gZ/Z7LiPIFrGHXK
         D3zJWu3fjaNqxu9Tv39Kz2qFlv8K3fnS/K5KXj0/kAeTJ25JekVvpMUnNr79K0/E4WcO
         p4t/+HtY2H1+wnQJYmhjEca5kfSkL/DeEFL3Fqz+6J44kXEdeG+30VcfqkHJxr3cCE2o
         E+jVHbCjtIA3kzYE9f0G3X0m2KciSwiVL39T5cNd9ckYdQzhFxOrDVjw+RHBk0UalMAJ
         gaGOfL+3EV8UXU06eSPifT6DDPUwHkjV9bLCcKUSCaSaUwu1Df27rWI9khB4ni2EJX0Y
         HWCg==
X-Gm-Message-State: AOAM533wkJ6T6MbqeSq9ABinX9TP8seIyWl5n64jJ+Hsnuu/XU37Ex/m
        fyxfqQ+sRf2xFapWFE/M1qA=
X-Google-Smtp-Source: ABdhPJzcXNMGEkbglUaY0+ODWsOSt1MyLzG2w26hG7IaQVJQHB3jkf/SXKWp75mDlJ3aDjwfNd20DQ==
X-Received: by 2002:a17:906:1146:: with SMTP id i6mr32022529eja.12.1633520885218;
        Wed, 06 Oct 2021 04:48:05 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:48:04 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] selftests: net/fcnal: Reduce client timeout
Date:   Wed,  6 Oct 2021 14:47:27 +0300
Message-Id: <516043441bd13bc1e6ba7f507a04362e04c06da5.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce default client timeout from 5 seconds to 500 miliseconds.
Can be overridden from environment by exporting NETTEST_CLIENT_TIMEOUT=5

Some tests need ICMP timeouts so pass an explicit -t5 for those.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index e73aeb3884c5..cf5dd96bb9db 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -40,10 +40,15 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
 VERBOSE=0
 
+# Use a reduced client timeout by default
+# Can be overridden by user
+NETTEST_CLIENT_TIMEOUT=${NETTEST_CLIENT_TIMEOUT:-0.5}
+export NETTEST_CLIENT_TIMEOUT
+
 NSA_DEV=eth1
 NSA_DEV2=eth2
 NSB_DEV=eth1
 NSC_DEV=eth2
 VRF=red
@@ -1076,11 +1081,11 @@ ipv4_tcp_novrf()
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
 		run_cmd nettest -s -k
-		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		run_cmd nettest -r ${a} -d ${NSA_DEV} -t5
 		log_test_addr ${a} $? 1 "Global server, device client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
@@ -1379,23 +1384,23 @@ ipv4_udp_novrf()
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
 		run_cmd nettest -D -s -k
-		run_cmd nettest -D -r ${a} -d ${NSA_DEV}
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -t5
 		log_test_addr ${a} $? 2 "Global server, device client, local connection"
 
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
 		run_cmd nettest -D -s -k
-		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C -t5
 		log_test_addr ${a} $? 1 "Global server, device send via cmsg, local connection"
 
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
 		run_cmd nettest -D -s -k
-		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -t5
 		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
@@ -3443,11 +3448,11 @@ netfilter_icmp()
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
 		run_cmd nettest ${arg} -s -k
-		run_cmd_nsb nettest ${arg} -r ${a}
+		run_cmd_nsb nettest ${arg} -r ${a} -t5
 		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
 	done
 }
 
 ipv4_netfilter()
@@ -3498,11 +3503,11 @@ netfilter_icmp6()
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
 		run_cmd nettest -6 -s ${arg} -k
-		run_cmd_nsb nettest -6 ${arg} -r ${a}
+		run_cmd_nsb nettest -6 ${arg} -r ${a} -t5
 		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
 	done
 }
 
 ipv6_netfilter()
-- 
2.25.1

