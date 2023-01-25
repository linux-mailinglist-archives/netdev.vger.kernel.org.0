Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B5C67BDE4
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbjAYVOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbjAYVOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:14:37 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1223E4EE7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:14:34 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9C63D3F2D8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 21:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674681272;
        bh=zuLI4Bp627ZhHkhqlP1iDRjahT6gPWQWdVEKJTBWAPw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=milhjyYU/VIlfgLs7mYOiy1Qk5ePQycjQFWZfpnudW9pm930ztrrA00v+0UoNnMDk
         kTSYhLsNVqhWyhydUiCRVG3lFNktTNJUty5pFIWQeELWb4/R5NpMkAHJHFNoYMKOFb
         ECwQfFqEkwz29fwvAXiFF0/J009gRlGb/HEF84ekHvB6v/L7Hxi2CESWaYQvwXTrc4
         nq4kq3T49StRw/ut0QGJfAdjaCor5zEjmT83C1MNJJO+xBnH1WVBcSXOJFqS6SlZxW
         jMmVFWNqdETKyEQaiuLDfrZhv4fRcU8M+kStB9AWuFmOhS8QT0LZL9scTrCGA2GQ+V
         rO3ZAW3ApAqRQ==
Received: by mail-wm1-f72.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so1727734wmq.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zuLI4Bp627ZhHkhqlP1iDRjahT6gPWQWdVEKJTBWAPw=;
        b=lkZLGGT/VEJ1mq8U/DFJYjSER9BKGXZ8Lv1A/DrQH0haficC/EiBMCFSBVJME84gZI
         +BLGlqL7gclpvdk8OPI2dbfjTH17JPaOFdCztRdVeR6BBQAauKeKc0ODjq7c9PgKDYHT
         817bQSGaK+5g8/czA2K9MSwHJHXONA+RJtFzl1+uKZ1TmM0NSqCO/WMARaFnhePyjelo
         RbKxY39umLIDWsK+indahFGUH6dK5EtNmqtKpGs/BEDfG0WF+JbgJjiqpdkPYTFqJpjO
         MWV6ViXCKcOT24VqmG6KKVcaCv8uYlrjpEURSZ7mOq3XuUjB+kGjGrCjoFPwtK9Mjnve
         oD5g==
X-Gm-Message-State: AFqh2krXmcOrPBboHF1a2/2KmSgwchR1vHFyJsi6OhsvDBt6VAvX0FhL
        z/5vQJH6+kA8s3ogc7rspyriexC7BiugeGRrluDNxjpHU9idH0X/mCOUF4gBvPK0qGRyfMp8laY
        disODbNPlfsmQM7p8cL1XGxIZe3m0Otvptg==
X-Received: by 2002:adf:f0c7:0:b0:2bd:e18d:c9e5 with SMTP id x7-20020adff0c7000000b002bde18dc9e5mr30002379wro.40.1674681272278;
        Wed, 25 Jan 2023 13:14:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsEXTSteavR2oIdqHFpmfgQvV0sc0iT8QGFY/uEQuvNeO8SmPQBaIfEVUScik9B0mqdVFu5KA==
X-Received: by 2002:adf:f0c7:0:b0:2bd:e18d:c9e5 with SMTP id x7-20020adff0c7000000b002bde18dc9e5mr30002370wro.40.1674681272108;
        Wed, 25 Jan 2023 13:14:32 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id l10-20020a05600012ca00b002bfb02153d1sm5738146wrx.45.2023.01.25.13.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 13:14:31 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 1/2] selftests: net: Fix missing nat6to4.o when running udpgro_frglist.sh
Date:   Wed, 25 Jan 2023 21:13:49 +0000
Message-Id: <20230125211350.113855-1-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
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

The udpgro_frglist.sh uses nat6to4.o which is tested for existence in
bpf/nat6to4.o (relative to the script). This is where the object is
compiled. Even so, the script attempts to use it as part of tc with a
different path (../bpf/nat6to4.o). As a consequence, this fails the script:

Error opening object ../bpf/nat6to4.o: No such file or directory
Cannot initialize ELF context!
Unable to load program

This change refactors these references to use a variable for consistency
and also reformats two long lines.

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/udpgro_frglist.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index c9c4b9d65839..1fdf2d53944d 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -6,6 +6,7 @@
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
 BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_NAT6TO4_FILE="./bpf/nat6to4.o"
 
 cleanup() {
 	local -r jobs="$(jobs -p)"
@@ -40,8 +41,12 @@ run_one() {
 
 	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
 	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
-	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
-	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol \
+		ipv6 bpf object-file "$BPF_NAT6TO4_FILE" section \
+		schedcls/ingress6/nat_6 direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol \
+		ip bpf object-file "$BPF_NAT6TO4_FILE" section \
+		schedcls/egress4/snat4 direct-action
         echo ${rx_args}
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
@@ -88,7 +93,7 @@ if [ ! -f ${BPF_FILE} ]; then
 	exit -1
 fi
 
-if [ ! -f bpf/nat6to4.o ]; then
+if [ ! -f "$BPF_NAT6TO4_FILE" ]; then
 	echo "Missing nat6to4 helper. Build bpfnat6to4.o selftest first"
 	exit -1
 fi
-- 
2.34.1

