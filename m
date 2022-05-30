Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD387538722
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbiE3SMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiE3SMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:12:51 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D0A35DF5;
        Mon, 30 May 2022 11:12:49 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o29-20020a05600c511d00b00397697f172dso350745wms.0;
        Mon, 30 May 2022 11:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0pUje48kNAVORkKjnoiyIbQ0POCG7FBl2HRz+ZCcTSE=;
        b=JslR4EqeMQRV4MpQktqt0UrzATodjCoU6sTsjQYIZdSv2SeQOj0Sp0LK4NFsApUm0W
         ZPXrtNjiNyxt+VIjeK5d6DTpnQvX3NVMrfX3AfGqmFmLIAMV4dBKAGhc+yeJ/QX1cJjf
         +1svctAb1TXKCB6XODikwz9xhYfeqc1ol7c9tEV20vRpwTWlsla8IdeE6zveCrX7+e2a
         eKeA0m9Sy6yvdu6wcLckL5wLFbA0LB9FlfJ6grcUgE8YaiJ8tnZxJskAORn+i18z2FGa
         NEbS3tVh5rE+lVLJD6mLeJhrBi/CWXSQsQPqYoM8CYm7ty/cshVuFJ+oCS3mGRvfjTq1
         lQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0pUje48kNAVORkKjnoiyIbQ0POCG7FBl2HRz+ZCcTSE=;
        b=rT1eO6fd01lGLhxwl2YvxVU9t31Ba7mcodgqvepvk0f6ZolN4IseuVIBHYVFylRIlp
         yWbuuTPzYmNmwxGTrT7EFSlTMNeZ8M+TTMxiD7I7xiA6J4Qa5TULJZKUxjvwB3lwyqts
         Rgc6uv9NtQxvkFJ39LCIIEtoQhUXi5mu8XrqmyxxR5P0Z8UJ2blouBflHX8Eeb1oz3vJ
         bWcbRQVwh3Vpfugw0USM04xOjC2gT485CXz6dfjdrRiYYNBgYA5WJOmsI9rSZDkc6S2i
         sdtD2+F14nJQTsk4iqGTz4POBxK/wD6WtnfEBZn4+aBcS2saLqaIeHVEvBKzHt7YXgfy
         j+kQ==
X-Gm-Message-State: AOAM53399nIf5y1n1/lD+9Oj/Pw/0qa6zyx6zPKI8mX1gsjqPD47Hwrv
        wpFj8qPgmxyErtq332n6Ph73x8OtXa0=
X-Google-Smtp-Source: ABdhPJwbepOZafGsplfAk54QBJH5lVhBie4HZYgf6Rtg16shBd21j256GkZn5OLGclBzZNDGWbKwBA==
X-Received: by 2002:a05:600c:3b8f:b0:397:5dc7:6066 with SMTP id n15-20020a05600c3b8f00b003975dc76066mr20076930wms.35.1653934367517;
        Mon, 30 May 2022 11:12:47 -0700 (PDT)
Received: from localhost.localdomain ([197.57.63.83])
        by smtp.gmail.com with ESMTPSA id 9-20020a1c0209000000b00397550b387bsm16958wmc.23.2022.05.30.11.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 11:12:46 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next] selftests: net: fib_rule_tests: add support to run individual tests
Date:   Mon, 30 May 2022 20:12:42 +0200
Message-Id: <20220530181242.8487-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.25.1
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

add -t option to run individual tests in the test with -t option

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index bbe3b379927a..c245476fa29d 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -303,6 +303,29 @@ run_fibrule_tests()
 	log_section "IPv6 fib rule"
 	fib_rule6_test
 }
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts ":t:h" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-- 
2.25.1

