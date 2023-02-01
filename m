Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38244685C17
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBAAS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjBAASx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:18:53 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361CE4FACE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:18:43 -0800 (PST)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0C2373F2D1
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675210722;
        bh=dgwEfLtKcE1+A8pxiJOsLVtOJAST1XtfQUhBF4j2P0E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Mk9q9gT/t3SV/+f79dS17dKpOdn1qi08NaRnSl+ZUGjHh4VqAt0AzYZogp1dN8nYS
         3M13wae16+HVtngSImLA3RIbfwusfoNHnYd4QpEOEAs9v9FRbPqgpGOKZxTi3o+Bv9
         JiwS+/S/YdiR5lvnedkCKjoGLyZ9SzcecVxSRSIhCzy3LlkRr5chBSZqSlGxAwN5jN
         1BnZqfW7jWPzZ+ftpCgXo95hsLMXoi49IOAVE1x12qTvtSMNtJ6hle+cmFsesDL1mX
         ubr2hy1qQJeR4iJa4jAC25tS9jgMQbrM5mcX7jG9eoYXlWq3/OvoErpBNctUD7W/o+
         qvAuFiNjeKmaA==
Received: by mail-wm1-f71.google.com with SMTP id o42-20020a05600c512a00b003dc5341afbaso151435wms.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:18:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgwEfLtKcE1+A8pxiJOsLVtOJAST1XtfQUhBF4j2P0E=;
        b=OTT8JjAXRrbAkdrD1ZnMiPbHs4n3mjiCqstyEDmLuqTP2XEGeM0ozcjb32gHE1dAKh
         p1lRsgNzyxXlP84R8hyiv5Wj10pibq2eAtbNUFDXW9TXqztXokVPuPTheUIoSfRRGhKH
         2ntLVZVdOIGhYZBmJoE3YRcqbzLmZHB5tqKGHTGcNwpENBGA2ppDOIM1H4rGJO2GteoL
         pgTr7JTbeXw3uPSrE3QdnLCYhmFliBL67bBfDDL+rja8+6WC4h1t+GwicVH3v/J+mDsS
         6TLA/w2q8GuSxvd7XLpo+m6trmdsR5JiH8N91StM4kFTuDqp4sH+RY0NK9SUN2xahGNH
         +X1g==
X-Gm-Message-State: AO0yUKVYMHTLSt6in67RnSAx2njtHOx879M9E9Sui4hNA5vQb0rZj0dQ
        /EhJ5210wy3bRXRmWVhvYi6N6b2NW1tD327KCRsSa1Wk0/Sp+h9QeIm4ePWMWEP+WEZsSUyFYtJ
        W4wIwGwLnvhuLJzMky2oCsthuMtPd7AhF5Q==
X-Received: by 2002:a05:600c:354c:b0:3db:1a41:6629 with SMTP id i12-20020a05600c354c00b003db1a416629mr105942wmq.22.1675210721714;
        Tue, 31 Jan 2023 16:18:41 -0800 (PST)
X-Google-Smtp-Source: AK7set9LaXifnlkC7InO8/h7kccJP2n5FYY32pcHw9EtuXxE/QBheUoELSj8Zzng27BuKrGEsioHuA==
X-Received: by 2002:a05:600c:354c:b0:3db:1a41:6629 with SMTP id i12-20020a05600c354c00b003db1a416629mr105937wmq.22.1675210721559;
        Tue, 31 Jan 2023 16:18:41 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003d237d60318sm108925wmi.2.2023.01.31.16.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:18:26 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4 3/4] selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
Date:   Wed,  1 Feb 2023 00:16:14 +0000
Message-Id: <20230201001612.515730-3-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201001612.515730-1-andrei.gherzan@canonical.com>
References: <20230201001612.515730-1-andrei.gherzan@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"udpgro_bench.sh" invokes udpgso_bench_rx/udpgso_bench_tx programs
subsequently and while doing so, there is a chance that the rx one is not
ready to accept socket connections. This racing bug could fail the test
with at least one of the following:

./udpgso_bench_tx: connect: Connection refused
./udpgso_bench_tx: sendmsg: Connection refused
./udpgso_bench_tx: write: Connection refused

This change addresses this by making udpgro_bench.sh wait for the rx
program to be ready before firing off the tx one - up to a 10s timeout.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/udpgso_bench.sh | 24 +++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index dc932fd65363..640bc43452fa 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -7,6 +7,7 @@ readonly GREEN='\033[0;92m'
 readonly YELLOW='\033[0;33m'
 readonly RED='\033[0;31m'
 readonly NC='\033[0m' # No Color
+readonly TESTPORT=8000
 
 readonly KSFT_PASS=0
 readonly KSFT_FAIL=1
@@ -56,11 +57,26 @@ trap wake_children EXIT
 
 run_one() {
 	local -r args=$@
+	local nr_socks=0
+	local i=0
+	local -r timeout=10
+
+	./udpgso_bench_rx -p "$TESTPORT" &
+	./udpgso_bench_rx -p "$TESTPORT" -t &
+
+	# Wait for the above test program to get ready to receive connections.
+	while [ "$i" -lt "$timeout" ]; do
+		nr_socks="$(ss -lnHi | grep -c "\*:${TESTPORT}")"
+		[ "$nr_socks" -eq 2 ] && break
+		i=$((i + 1))
+		sleep 1
+	done
+	if [ "$nr_socks" -ne 2 ]; then
+		echo "timed out while waiting for udpgso_bench_rx"
+		exit 1
+	fi
 
-	./udpgso_bench_rx &
-	./udpgso_bench_rx -t &
-
-	./udpgso_bench_tx ${args}
+	./udpgso_bench_tx -p "$TESTPORT" ${args}
 }
 
 run_in_netns() {
-- 
2.34.1

