Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ECF4FCC22
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 04:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiDLCGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 22:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241355AbiDLCGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 22:06:52 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDA92CE2A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:04:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s28so9709098wrb.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7HiZoNKYwhR0YbrYRz+Uo5dLeYLk95V30dgWM5HBFw=;
        b=G3raJIRj4Peb6RNf3cEGN1DXfwApDWhqwUrB+CM/ZJl4Ikc0IPN6HRD+07w44uoIUO
         FCBqzK9pH65ihtLyabK5K9Yfx76dBLVyHkL9shMIf430wqBEHkKyhL6tweJRjGN5M2uL
         /5CbbPbE4spyFd3A9Wl+f8y0vAt0vVDwRsL4bP82tg95FzIfa6pk5VJ4vGYzFSigIvIK
         SfN62u962gCS9MTMRlYdkxllyrTIBAeIG4FmZMMOuIFBTLEo59hRwbwEHnEIP5W47Kch
         r8KdizIctnaZTyK7Gn/EIGiKU4KaIzrVNyttymHtcdLI9zJbXiPlZGRb+0fralV8iyWx
         Kxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7HiZoNKYwhR0YbrYRz+Uo5dLeYLk95V30dgWM5HBFw=;
        b=C8N5AAknupYm/QViOEDknabudNZYGtOFQul3yJazwTk9g9tUObLUdyLJdNb4C7DmFu
         uX43eh0OOEYPS3OcBcmBJRfezKu3h8YypJ1aZIslmhbLd0ftVLHwHpa+uzCPpdXRaZXS
         HWuoW1NKcRbmbMVDoaLBkZm7XskY2RzUqERFbD0RO6JltfbPdAHbguIM6s/XMfEaL/rJ
         Vtoaadyy69TOYJY3vgsIeWFKJW79kY62wnpwETLKC++DSibuVdXEnj3lJQN3Q/FIZUNt
         C4FbbKBgUqvJGcof7EIsgId5nGytbP7DnnT9PkILgJP4+n0qC15wNn75lZaC7zGcQcKt
         CvnQ==
X-Gm-Message-State: AOAM531QIQBpuKx93I52VlE6FeCf7ogj3ic3z/jGva+ArDtpJnVnD/hI
        5REPVWLZ428J/BgGUYJXojM=
X-Google-Smtp-Source: ABdhPJwoaqBy6yFxfQzxzdzzCPMV0/GiaMlWOJze35TpL4XB5K8sWW21vVsJIrayS/p63McaCMrTcQ==
X-Received: by 2002:adf:9111:0:b0:206:c9b:ce0d with SMTP id j17-20020adf9111000000b002060c9bce0dmr27387761wrj.418.1649729074599;
        Mon, 11 Apr 2022 19:04:34 -0700 (PDT)
Received: from alaa-emad ([197.57.239.92])
        by smtp.gmail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm39670692wry.72.2022.04.11.19.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 19:04:34 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, roopa.prabhu@gmail.com, jdenham@redhat.com,
        sbrivio@redhat.com, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2] selftests: net: fib_rule_tests: add support to select a test to run
Date:   Tue, 12 Apr 2022 04:04:31 +0200
Message-Id: <20220412020431.3881-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Add boilerplate test loop in test to run all tests
in fib_rule_tests.sh

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in v2:
	edit commit subject to be clearer
---
 tools/testing/selftests/net/fib_rule_tests.sh | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 4f70baad867d..bbe3b379927a 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -20,6 +20,7 @@ SRC_IP6=2001:db8:1::3
 DEV_ADDR=192.51.100.1
 DEV_ADDR6=2001:db8:1::1
 DEV=dummy0
+TESTS="fib_rule6 fib_rule4"
 
 log_test()
 {
@@ -316,7 +317,16 @@ fi
 # start clean
 cleanup &> /dev/null
 setup
-run_fibrule_tests
+for t in $TESTS
+do
+	case $t in
+	fib_rule6_test|fib_rule6)		fib_rule6_test;;
+	fib_rule4_test|fib_rule4)		fib_rule4_test;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+
+	esac
+done
 cleanup
 
 if [ "$TESTS" != "none" ]; then
-- 
2.35.1

