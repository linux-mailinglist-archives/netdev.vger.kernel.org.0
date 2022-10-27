Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA62610375
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiJ0Uxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiJ0UwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:52:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59A192F59
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:25 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k8so4195316wrh.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPlBRtPqc4jzRch7GuGBGnWek2G+euBxO7Wx+7kBlaA=;
        b=bVK6qkkmlZm2eCfia56EiPyJWBNvSCSN65vuXmZMwv60c1riUqwoyFm4oXCLyqdWEj
         HZJ2IyHeUII0+db20y55ElVHgVl+Me9JXeWiVips4MimCekYNrxcW5uwfADYtmFU170z
         kKgoH8tIctGOaKe05NevvYz028QTHVNviQLU0btxNJVmjM9Aw9trwGYLpctf+L3JBXkM
         o/9Rs0JCpJIhS9XPU4g7jeLUCdUPLEoF53RA3X+qS2sT4SD2VjiR3MRKoZ2KKJmORuil
         TgBfc1nWz8Ugk+G4Cr9K41yJ9ZLQzIROOdUUcxU7miwZVLrZ5zPnRmx8hui09mlg720C
         KuiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPlBRtPqc4jzRch7GuGBGnWek2G+euBxO7Wx+7kBlaA=;
        b=6hQ59g8Z9Qki8GVDRdH9aYC0AZaZymNHuIuFPNsePA/irXNhB5b7hn6lYkF8TD6SFk
         ccxysC2Hrcg8xZDt0gqm0308FGJ3cQm+pwXuwTyYUFVoffBJz5xsJeQrPGw4W3pvcsDU
         W5XIAOe8Y31gVtnLKDXeeQ0pyyWPrZOdBtmz2ktG/cp03/l2WaNQxy830P6X23yIOh5N
         s6UIWbLM31hOwuUTnlIw9mRaKxwcWkcaLu6H5SkI0MKLL7gMQDgSDhjQhEkoMyk6UdbS
         mkiPCY+dP1pVuOFqHpcIQBkBlcwK7TkBAap9N2ihVYHHEGwbLah1RCs9BbXkgrqFEvWT
         fDuA==
X-Gm-Message-State: ACrzQf2l9k5WSManRpKMqYoo1uAYBY6hDp/aqdbKWm2p7s/o/dT2mZWK
        ZiF3YhsXUZl6hZDxK4K5wyY+lw==
X-Google-Smtp-Source: AMsMyM6PjJo4hCL2xynqIB6BUfr++/O3XcYk16cYAEN2pOoiEFtkf0IAQpCLIfGfr9AYEXWinvpSeA==
X-Received: by 2002:a5d:4b51:0:b0:236:88a2:267f with SMTP id w17-20020a5d4b51000000b0023688a2267fmr7863025wrs.461.1666903485174;
        Thu, 27 Oct 2022 13:44:45 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:44 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 33/36] selftests/nettest: Remove client_pw
Date:   Thu, 27 Oct 2022 21:43:44 +0100
Message-Id: <20221027204347.529913-34-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use -X to set md5 password string and -M to set authentication method as
TCP-MD5. Remove client_pw as not needed. This will allow to add an
option to use TCP-AO as authentication method.
Note, that use_md5 is a bit, rather than an enum member like
`authentication_method` - this will allow to call nettest the way that
it'll try to connect with both tcp-md5 and tcp-ao setsocketopt()
[which shouldn't be allowed].

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 232 +++++++++++-----------
 tools/testing/selftests/net/nettest.c     |  26 ++-
 2 files changed, 128 insertions(+), 130 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 31c3b6ebd388..d4516c755858 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -843,9 +843,9 @@ ipv4_tcp_md5_novrf()
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
@@ -853,23 +853,23 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -s &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_LO_IP} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
@@ -878,25 +878,25 @@ ipv4_tcp_md5_novrf()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -911,9 +911,9 @@ ipv4_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
@@ -921,23 +921,23 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since server does not have MD5 auth"
 	run_cmd nettest -s -I ${VRF} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
@@ -946,25 +946,25 @@ ipv4_tcp_md5()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
@@ -972,74 +972,74 @@ ipv4_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsc nettest  -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsc nettest  -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M -X ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP}
+	run_cmd nettest -s -I ${NSA_DEV} -M -X ${MD5_PW} -m ${NSB_IP}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
+	run_cmd nettest -s -I ${NSA_DEV} -M -X ${MD5_PW} -m ${NS_NET}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
 	test_ipv4_md5_vrf__vrf_server__no_bind_ifindex
@@ -1050,16 +1050,16 @@ test_ipv4_md5_vrf__vrf_server__no_bind_ifindex()
 {
 	log_start
 	show_hint "Simulates applications using VRF without TCP_MD5SIG_FLAG_IFINDEX"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: VRF-bound server, unbound key accepts connection"
 
 	log_start
 	show_hint "Binding both the socket and the key is not required but it works"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	run_cmd nettest -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: VRF-bound server, bound key accepts connection"
 }
 
@@ -1071,27 +1071,27 @@ test_ipv4_md5_vrf__global_server__bind_ifindex0()
 	set_sysctl net.ipv4.tcp_l3mdev_accept=1
 
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Global server, Key bound to ifindex=0 rejects VRF connection"
 
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Global server, key bound to ifindex=0 accepts non-VRF connection"
 	log_start
 
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts VRF connection"
 
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	run_cmd nettest -s -M -X ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts non-VRF connection"
 
 	# restore value
@@ -2454,9 +2454,9 @@ ipv6_tcp_md5_novrf()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
@@ -2464,23 +2464,23 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -6 -s &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_LO_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
@@ -2489,25 +2489,25 @@ ipv6_tcp_md5_novrf()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -2522,9 +2522,9 @@ ipv6_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
@@ -2532,23 +2532,23 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since server does not have MD5 auth"
 	run_cmd nettest -6 -s -I ${VRF} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
@@ -2557,25 +2557,25 @@ ipv6_tcp_md5()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
@@ -2583,74 +2583,74 @@ ipv6_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M -X ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -6 -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP6}
+	run_cmd nettest -6 -s -I ${NSA_DEV} -M -X ${MD5_PW} -m ${NSB_IP6}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
-	run_cmd nettest -6 -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET6}
+	run_cmd nettest -6 -s -I ${NSA_DEV} -M -X ${MD5_PW} -m ${NS_NET6}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
 }
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 7900fa98eccb..b9e600899cf6 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -76,7 +76,8 @@ struct sock_args {
 		     has_grp:1,
 		     has_expected_laddr:1,
 		     has_expected_raddr:1,
-		     bind_test_only:1;
+		     bind_test_only:1,
+		     use_md5:1;
 
 	unsigned short port;
 
@@ -95,7 +96,6 @@ struct sock_args {
 	const char *serverns;
 
 	const char *password;
-	const char *client_pw;
 	/* prefix for MD5 password */
 	const char *md5_prefix_str;
 	union {
@@ -1546,7 +1546,7 @@ static int do_server(struct sock_args *args, int ipc_fd)
 		return rc;
 	}
 
-	if (args->password && tcp_md5_remote(lsd, args)) {
+	if (args->use_md5 && tcp_md5_remote(lsd, args)) {
 		close(lsd);
 		goto err_exit;
 	}
@@ -1670,7 +1670,7 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (args->type != SOCK_STREAM && !args->datagram_connect)
 		goto out;
 
-	if (args->password && tcp_md5sig(sd, addr, alen, args))
+	if (args->use_md5 && tcp_md5sig(sd, addr, alen, args))
 		goto err;
 
 	if (args->bind_test_only)
@@ -1751,8 +1751,6 @@ static int do_client(struct sock_args *args)
 		break;
 	}
 
-	args->password = args->client_pw;
-
 	if (args->has_grp)
 		sd = msock_client(args);
 	else
@@ -1862,7 +1860,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:MX:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1906,8 +1904,8 @@ static void print_usage(char *prog)
 	"    -L len        send random message of given length\n"
 	"    -n num        number of times to send message\n"
 	"\n"
-	"    -M password   use MD5 sum protection\n"
-	"    -X password   MD5 password for client mode\n"
+	"    -M            use MD5 sum protection\n"
+	"    -X password   MD5 password\n"
 	"    -m prefix/len prefix and length to use for MD5 key\n"
 	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
 	"    --force-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
@@ -2019,7 +2017,7 @@ int main(int argc, char *argv[])
 			msg = random_msg(atoi(optarg));
 			break;
 		case 'M':
-			args.password = optarg;
+			args.use_md5 = 1;
 			break;
 		case OPT_FORCE_BIND_KEY_IFINDEX:
 			args.bind_key_ifindex = 1;
@@ -2028,7 +2026,7 @@ int main(int argc, char *argv[])
 			args.bind_key_ifindex = -1;
 			break;
 		case 'X':
-			args.client_pw = optarg;
+			args.password = optarg;
 			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
@@ -2092,14 +2090,14 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (args.password &&
-	    ((!args.has_remote_ip && !args.md5_prefix_str) ||
+	if (args.password && (!args.use_md5 ||
+	      (!args.has_remote_ip && !args.md5_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if (args.md5_prefix_str && !args.password) {
+	if ((args.md5_prefix_str || args.use_md5) && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
-- 
2.38.1

