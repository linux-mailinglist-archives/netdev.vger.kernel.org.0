Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A095683823
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjAaU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjAaU6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:58:01 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91865A837
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:57:25 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 94A8E442FD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 20:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675198588;
        bh=L9NG4EbGXg9Qd+NeBO29yIJT8Su4mY75m3fPbmvR2Jg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bxxpp32kpWO+p2/SxEIp/2unz7YQikf0KIQqzQK7CUKCNIEjQQqY6+e1/C4V8H3ps
         APLm4fdT1A70l3bd4zE455SDopwqzKVl1ztzW+HD+/c7cJzgO+Am3DGOoVNk58Fyd+
         UG6NVVjAO2vC29/X+jem7uP/HCvwcV7R7h6UdaVJTVzxJ8GnZpdDaPNDOEc5sosdT5
         aNHk0wDShZf/mWqLUz+Kb3HY6lOGi31elRs/A/xdIFFdaknd/uIVTtBAYY405K+RW5
         CSQ0gBoVqFdKH2au7gcYhXu1s6QcQCod94qf9DbnUPHxLufZ/mOY2l2T3P0KTidavv
         QgwDJVlFXX9qg==
Received: by mail-wm1-f72.google.com with SMTP id bg25-20020a05600c3c9900b003da1f6a7b2dso11932590wmb.1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:56:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9NG4EbGXg9Qd+NeBO29yIJT8Su4mY75m3fPbmvR2Jg=;
        b=g2x5NO+cxhjGrLHXQfEnsR4Rszfb4bEcdwxvNZxwhgRs7Qh5QLECJadekJvmaev/0Y
         rsKAfSlhRzWCDnu5e/6TXuk/Rm7SuZ52tpRH6+Ztsu5c83E7P9dyh+DRO9qPFolLW28q
         gxB0T5t+TqwnNk/Tu/C626NJ8llSKMgokR8I1WbaN+UJD2dQqg0Ddvlab14JQw6PxYiZ
         ggCaeBONHe23K+aZ8JgL736H8VKUVvv22fXfsNanU0HbD763fN0kflyONtkQvUzDJkck
         NNRLf0IeTPh3Ktj22QVgVlLphdlk45dpAPSITE47utbxJjhJNovFd3UPNY2dPBMyqfG5
         CWng==
X-Gm-Message-State: AO0yUKVrhnCjqdxNeslxLfF6PZ6MYm4zc5vkAKyrvmlMMui0TWoxfnFE
        hgOkPhNOji4DnKt9p7jEh5+oxEBb3oBvcHmVVFxxZU/ytgRSjGNXGXIXinvOCU6eEvyh49hD35U
        QGXY2+MmNko6Uye/atZTQYp66u4b6p4aXRA==
X-Received: by 2002:a05:600c:1d88:b0:3d1:caf1:3f56 with SMTP id p8-20020a05600c1d8800b003d1caf13f56mr5264266wms.9.1675198587960;
        Tue, 31 Jan 2023 12:56:27 -0800 (PST)
X-Google-Smtp-Source: AK7set8roATM561UQyxsVNW2wm8I8l+avaE281Q660e39LKDsxSG4Kz4Cg8SfMm4SW+xymKyplyr4g==
X-Received: by 2002:a05:600c:1d88:b0:3d1:caf1:3f56 with SMTP id p8-20020a05600c1d8800b003d1caf13f56mr5264250wms.9.1675198587790;
        Tue, 31 Jan 2023 12:56:27 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id bd16-20020a05600c1f1000b003d1f3e9df3csm21316535wmb.7.2023.01.31.12.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 12:56:27 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/4] selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
Date:   Tue, 31 Jan 2023 20:53:20 +0000
Message-Id: <20230131205318.475414-3-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131205318.475414-1-andrei.gherzan@canonical.com>
References: <20230131205318.475414-1-andrei.gherzan@canonical.com>
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
CC: Paolo Abeni <pabeni@redhat.com>
CC: Willem de Bruijn <willemb@google.com>
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

