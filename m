Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56867E7C8
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjA0OJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbjA0OJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:09:54 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C521CAE3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:09:52 -0800 (PST)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C08973F20B
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674828590;
        bh=nTK+Tg/yAxtPIIDooMityTGjVkS2yxq+KGHsQ1IbSWA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=I7oVur5gLqVs4SPsNhI1PX37a/WmeDtK3TV85pIW365JmB+n5n9ESJV5M/BllXkZ2
         KDkoODBkxcDolFHi2RjYa3OV9mkbf9nVfMlZ/wlRoA7+lzTITGVfx1ic3o24HqqimG
         SO/hzLUwQmhHaeeFTiRrllhyUG+/MpZXxNRAv5TxBnU3YOZr7IwkNP4FA7Qe8QZr4d
         pWd3dlUAH23IIBJ7pnRQPjolscJuq5pfXPzuwBQOXyxhnpHjjrFCVjpf008EQoXS/u
         fwwMyFvMa1TCxDL6tqbxRjWUh5ELStCD2/ISI2OnMu8bUMA7JMfJpn3wbK1FL6ct9e
         K48wGDtR1L6SA==
Received: by mail-wm1-f71.google.com with SMTP id o7-20020a05600c510700b003dc4312bc2bso139481wms.7
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTK+Tg/yAxtPIIDooMityTGjVkS2yxq+KGHsQ1IbSWA=;
        b=Yjf4QwjNTJgyf2tP1Cj1gUycpZ0haCREIa7RCj7D8Skqo3xxfGEhKJtngAhENuUPfA
         wmmSmZgtw5jYJZKQeeW5uIJoqJesYiFf7VQb5fVYFCzFd8YAA6rVTgcfy8naX5iW84g5
         mUl/NLIhJSYHWZTU3x5cDRfjmdhLTCPj4VMe0WnxXVyVSkt3kWJ8HauBwYTPHXRq5jd/
         UzQFx1+N0a6YPCcCqQZ86hVd8F+rE8SgT7xfQlP+vReE6M/atwGKpDFA2T1ScdpgavZJ
         tmBRyPWjeUg12R4wtJDhG5YvB2csf3jgv7qHlGariL4T4hcrdrY61dlPk1giPaR97zC1
         Sbgw==
X-Gm-Message-State: AO0yUKVX+O4vFLCDnHz3YPXmjp8zy9+OdilHuz7lVXK4Lr/za1P5AzVk
        SX9L0Q21MFozIDf50nW/dVzEjVLPTkeWQEmrrGNn35lFnUMjdHXdeoc4T8Nf17j0SQicvva3kTI
        lMfCjFLrmFJnjlFmxZMbbN1CBYcHpIMYjSA==
X-Received: by 2002:a5d:558a:0:b0:2bf:d6fc:580d with SMTP id i10-20020a5d558a000000b002bfd6fc580dmr1138176wrv.69.1674828590581;
        Fri, 27 Jan 2023 06:09:50 -0800 (PST)
X-Google-Smtp-Source: AK7set//BxCF5WT5hBFnMpYOxwv7KjXmz6dU/605p3j/UGBsQ9MaoqHMsAfSDxDHOCpDhi8SeEwdaQ==
X-Received: by 2002:a5d:558a:0:b0:2bf:d6fc:580d with SMTP id i10-20020a5d558a000000b002bfd6fc580dmr1138149wrv.69.1674828590063;
        Fri, 27 Jan 2023 06:09:50 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id f21-20020a5d58f5000000b00236883f2f5csm4105833wrd.94.2023.01.27.06.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 06:09:49 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Maciej enczykowski <maze@google.com>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] selftests: net: Fix udpgro_frglist.sh shellcheck warnings and errors
Date:   Fri, 27 Jan 2023 14:09:44 +0000
Message-Id: <20230127140944.265135-3-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127140944.265135-1-andrei.gherzan@canonical.com>
References: <20230127140944.265135-1-andrei.gherzan@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes the following shellcheck warnings and errors:

* SC2155 (warning): Declare and assign separately to avoid masking return
  values.
* SC2124 (warning): Assigning an array to a string! Assign as array, or use
  instead of @ to concatenate.
* SC2034 (warning): ipv4_args appears unused. Verify use (or export if used
  externally).
* SC2242 (error): Can only exit with status 0-255. Other data should be
  written to stdout/stderr.
* SC2068 (error): Double quote array expansions to avoid re-splitting
  elements.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/udpgro_frglist.sh | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index e1ca49de2491..97bf20e9afd8 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -3,7 +3,8 @@
 #
 # Run a series of udpgro benchmarks
 
-readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+readonly PEER_NS
 
 BPF_FILE="../bpf/xdp_dummy.bpf.o"
 BPF_NAT6TO4_FILE="nat6to4.o"
@@ -19,7 +20,7 @@ trap cleanup EXIT
 
 run_one() {
 	# use 'rx' as separator between sender args and receiver args
-	local -r all="$@"
+	local -r all="$*"
 	local -r tx_args=${all%rx*}
 	local rx_args=${all#*rx}
 
@@ -56,13 +57,13 @@ run_one() {
 }
 
 run_in_netns() {
-	local -r args=$@
+	local -r args="$*"
   echo ${args}
 	./in_netns.sh $0 __subprocess ${args}
 }
 
 run_udp() {
-	local -r args=$@
+	local -r args="$*"
 
 	echo "udp gso - over veth touching data"
 	run_in_netns ${args} -u -S 0 rx -4 -v
@@ -72,7 +73,7 @@ run_udp() {
 }
 
 run_tcp() {
-	local -r args=$@
+	local -r args="$*"
 
 	echo "tcp - over veth touching data"
 	run_in_netns ${args} -t rx -4 -t
@@ -80,7 +81,6 @@ run_tcp() {
 
 run_all() {
 	local -r core_args="-l 4"
-	local -r ipv4_args="${core_args} -4  -D 192.168.1.1"
 	local -r ipv6_args="${core_args} -6  -D 2001:db8::1"
 
 	echo "ipv6"
@@ -90,19 +90,19 @@ run_all() {
 
 if [ ! -f ${BPF_FILE} ]; then
 	echo "Missing ${BPF_FILE}. Build bpf selftest first"
-	exit -1
+	exit 1
 fi
 
 if [ ! -f "$BPF_NAT6TO4_FILE" ]; then
 	echo "Missing nat6to4 helper. Build bpf nat6to4.o selftest first"
-	exit -1
+	exit 1
 fi
 
 if [[ $# -eq 0 ]]; then
 	run_all
 elif [[ $1 == "__subprocess" ]]; then
 	shift
-	run_one $@
+	run_one "$@"
 else
-	run_in_netns $@
+	run_in_netns "$@"
 fi
-- 
2.34.1

