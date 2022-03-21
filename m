Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6B4E1F19
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 03:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbiCUCnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 22:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbiCUCnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 22:43:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58173B714E
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 19:41:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c11so9342930pgu.11
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 19:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VSQdMHnDLCfoDEqwkGmxAp1cOvVF2vm1WaAGZDPvKJI=;
        b=eOHXg2L+mlmY9JWCKNHpttqyaok3kt4MXyHzB586x7ISLH6D5R3RT2Uyw1KFy/vtWS
         GfUSebZJnJ4FRu3EntWSVbQpMPgFbXJ6p7jdHgCIx+cIjuv/xrQ7Z1CVal/nu+jPmfYd
         usxDteTXau0SgByad1CwwecGdt3kTwlr+ww26Y1/uNA5ym9CnwEJ+5RMyKEWOYPC5x56
         FUDQbZW7zBjXHBH8gvXh7jxG5YmyX+goju/jk1E7J3q1yq9lli7yQ/uQEZ6hnhQVKRTw
         kW0yFry0Fr09wkgTU7kX8W0g/a2/b/qo97XKSAmtDkqcIL/zKzzyHWKKsUDrmFHrYM0o
         3saw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VSQdMHnDLCfoDEqwkGmxAp1cOvVF2vm1WaAGZDPvKJI=;
        b=H/P/QAP56jRJyKulYDGNAbWuwASMlDLv+TdQPDBfzDQcFcmgngGw4PWVUttxX6cYuv
         z22IEQ1nZN3ooNlskDYsq9BPCPbMcUzWdBxIZ5/Hu5s0Y9MEG436GGC+14q5UwgoGAEY
         qytviF3/QoxVp68RvdsittW6PaUXm31d2I6/1uOGIMq/S5oS6yQuo5fp1y51qX0FOUKe
         EhyCoGg4YCOQr5d+eL+zkJWM3wUSI8CpFW2GAZ8JX2T0YxIag3uhIjqP69yzxeZyCHOn
         FEGU3ldrn6s3bE0R0Ykv+P7HE9oPKEzKvF5ckh9UhqJN4TCQLtSlxZ8BO2I8ipjGaoD3
         OLdw==
X-Gm-Message-State: AOAM532WLPrQVIn+wgXNpJ7hW6O+6y775SvzUXgY8tmxXU9g/03J/uJo
        YYIUgAvQS/4QDcbYXOS4clBqMMwdiaU=
X-Google-Smtp-Source: ABdhPJzdiFTUZfr46CmKzzCtkefQWRncvpG1F9dvUSneLUld034z+X3g6AO6qDyAlgZ/2rJYtRiOgA==
X-Received: by 2002:a63:2051:0:b0:382:9ad9:d8ff with SMTP id r17-20020a632051000000b003829ad9d8ffmr65481pgm.454.1647830517607;
        Sun, 20 Mar 2022 19:41:57 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090a119000b001bfa3a0d21asm14178478pja.40.2022.03.20.19.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 19:41:57 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf] selftests/bpf/test_lirc_mode2.sh: exit with proper code
Date:   Mon, 21 Mar 2022 10:41:49 +0800
Message-Id: <20220321024149.157861-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317071805.43121-1-liuhangbin@gmail.com>
References: <20220317071805.43121-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When test_lirc_mode2_user exec failed, the test report failed but still
exit with 0. Fix it by exiting with an error code.

Another issue is for the LIRCDEV checking. With bash -n, we need to quote
the variable, or it will always be true. So if test_lirc_mode2_user was
not run, just exit with skip code.

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_lirc_mode2.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
index ec4e15948e40..5252b91f48a1 100755
--- a/tools/testing/selftests/bpf/test_lirc_mode2.sh
+++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
@@ -3,6 +3,7 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+ret=$ksft_skip
 
 msg="skip all tests:"
 if [ $UID != 0 ]; then
@@ -25,7 +26,7 @@ do
 	fi
 done
 
-if [ -n $LIRCDEV ];
+if [ -n "$LIRCDEV" ];
 then
 	TYPE=lirc_mode2
 	./test_lirc_mode2_user $LIRCDEV $INPUTDEV
@@ -36,3 +37,5 @@ then
 		echo -e ${GREEN}"PASS: $TYPE"${NC}
 	fi
 fi
+
+exit $ret
-- 
2.35.1

