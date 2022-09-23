Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFD5E8373
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiIWUTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiIWURW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:17:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1852A72D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:43 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay36so915945wmb.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MBUbVFEwLKRBMspXhOcGFGb+XB56PAssdDrUuZX7LcI=;
        b=BUoIFDeYrIxQrj3hU9Z4alXjH8JiNKMCggSBFtQw0j1YHnb99sszOxDOrTCxrPvDaQ
         l20BxkdZwnekHZXcQ+m9IKbP40Q/Owkf05BqWOAHja877GCa+pocNjc20uUcQyGd4HXr
         u52B6+A2xqenAbuha4N8TBmTy752uVW6RqSXyk1SPhJi05UAsFVobLKTbTuYvPeHeXF7
         KGvZjSGQ0tKWE5asp0k0vyyPfB7gTnBrCXtNNRXKCftP/Wwn0jvsfqF7CboK1UXsFFj0
         CK4F55hqTKDRTszut8xIwYSz3TjXsg5kSbPRq59RoCXlXH4gTg76WHDY50i5S0DpLFgB
         dEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MBUbVFEwLKRBMspXhOcGFGb+XB56PAssdDrUuZX7LcI=;
        b=ei7L6Cv16xpOarlZFxhF+SwpffzAAP0BXuixjqvhxKyjuH9CZIxbGxwZbr+KerW9at
         e5pFuGdFIZneyRCVQ8JJ5UXADi017IvQshpKrm1snCVPvSfZiFVQ2Ub2zYnUiAh5cs2A
         NJr3r5RtaKrbE0bc4pfe1mkdAxi/8+Ih1NdD99jTm23SuDXH3h3+mXht+kijcss6A3YX
         6kwPmY07+nYbG8Y2yLmkptOx1QlI1lRVTJwJpPXSk1oy2CGV25iAL5hEWw8PtxKggZjp
         GguNKgFe3JzaH65KWDiP/lNtqJlUhzEBI4lh6u0wgKlAsiulWKujjcX52FKrQg9JqTZd
         Om5w==
X-Gm-Message-State: ACrzQf2vP6mOc1aofsDJGluJikH1Xr6h9R0wO95LiI4v0CP3FXynBT/c
        UM0bgJnPXzB9c/uTChuaG9FrEw==
X-Google-Smtp-Source: AMsMyM5xGXGdrqU8YiG6eAh4VWNw66yB4OS1OY8oEL31WrISPTZ956Il8jxnH0YNLIbaXO/C1IAgmQ==
X-Received: by 2002:a05:600c:6026:b0:3b5:b00:3a5a with SMTP id az38-20020a05600c602600b003b50b003a5amr4045888wmb.108.1663964056743;
        Fri, 23 Sep 2022 13:14:16 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:16 -0700 (PDT)
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
Subject: [PATCH v2 32/35] selftests/nettest: Remove client_pw
Date:   Fri, 23 Sep 2022 21:13:16 +0100
Message-Id: <20220923201319.493208-33-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 03b586760164..321cbb0b55c4 100755
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
@@ -2431,9 +2431,9 @@ ipv6_tcp_md5_novrf()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
@@ -2441,23 +2441,23 @@ ipv6_tcp_md5_novrf()
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
@@ -2466,25 +2466,25 @@ ipv6_tcp_md5_novrf()
 
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
 
@@ -2499,9 +2499,9 @@ ipv6_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M -X ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
@@ -2509,23 +2509,23 @@ ipv6_tcp_md5()
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
@@ -2534,25 +2534,25 @@ ipv6_tcp_md5()
 
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
@@ -2560,74 +2560,74 @@ ipv6_tcp_md5()
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
index d9a6fd2cd9d3..35831bc3da24 100644
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
@@ -1538,7 +1538,7 @@ static int do_server(struct sock_args *args, int ipc_fd)
 		return rc;
 	}
 
-	if (args->password && tcp_md5_remote(lsd, args)) {
+	if (args->use_md5 && tcp_md5_remote(lsd, args)) {
 		close(lsd);
 		goto err_exit;
 	}
@@ -1662,7 +1662,7 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (args->type != SOCK_STREAM)
 		goto out;
 
-	if (args->password && tcp_md5sig(sd, addr, alen, args))
+	if (args->use_md5 && tcp_md5sig(sd, addr, alen, args))
 		goto err;
 
 	if (args->bind_test_only)
@@ -1743,8 +1743,6 @@ static int do_client(struct sock_args *args)
 		break;
 	}
 
-	args->password = args->client_pw;
-
 	if (args->has_grp)
 		sd = msock_client(args);
 	else
@@ -1854,7 +1852,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:MX:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1897,8 +1895,8 @@ static void print_usage(char *prog)
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
@@ -2010,7 +2008,7 @@ int main(int argc, char *argv[])
 			msg = random_msg(atoi(optarg));
 			break;
 		case 'M':
-			args.password = optarg;
+			args.use_md5 = 1;
 			break;
 		case OPT_FORCE_BIND_KEY_IFINDEX:
 			args.bind_key_ifindex = 1;
@@ -2019,7 +2017,7 @@ int main(int argc, char *argv[])
 			args.bind_key_ifindex = -1;
 			break;
 		case 'X':
-			args.client_pw = optarg;
+			args.password = optarg;
 			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
@@ -2080,14 +2078,14 @@ int main(int argc, char *argv[])
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
2.37.2

