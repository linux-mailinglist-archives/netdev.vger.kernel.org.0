Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F745617D8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiF3K0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiF3K0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EA97E031;
        Thu, 30 Jun 2022 03:24:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o4so22638645wrh.3;
        Thu, 30 Jun 2022 03:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6AzkA8havxcJ97cev8Fn2QmW59hqm7h1z8/O75RMTU=;
        b=aoylw+Bm3d7bRynQXm1EtMpfdeC3Ct+tlDTFFxO9i2qmx573vK4ardA3U9kXEdcQET
         1sFm6BKkYBZwjRU/xFlfrScK6BBIJ0hYPo8E2gMIYjh7XPtJzFf3+/S+0a37sFw+/V6b
         qQFzBCNh01mzHMtxlwUPES3E5L9bND1WZtmrCpG038w+4ZD1lSsBxwz8jKkt+BrdwqfN
         HGnYehdN508RV+jJJt+Os77+bsQLKUceNEUdjNlJybNFpAV8E5BU4wIj6wxMtmjvsesE
         TDYKi7kGWznsxOxHTWRUTlaATFrdlkU4zwvRW+8HRZW/22rB8s1l7pmkVGONx5NUI7mv
         Y5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6AzkA8havxcJ97cev8Fn2QmW59hqm7h1z8/O75RMTU=;
        b=Mu2MR8/kiMCC1WaP/wyApqnpid9IGOxyH5yxoZTXT+A+VEK8eTcKDM4qmIzlpFKz2w
         VnmNZxzC7w53LYFxpYsMPM2hHq5Xc9McidoJmz8I7cE3K/PVtCrW68qGOZhsxj5LKdrW
         Gw118QTRQaPcLN2uhwShzKlR0170AmrXCpksAXev29bA0/a2cb5cq+ZQhY0IweF9kHvZ
         IjKvlYvRkDB8f2JrV3Empht30Uskmg8EJFIwTOz41HuI+1Ef8p3KZNvgpZG9d03bfAuU
         u2qtL2j7F1hDaZlYj0MXH1BuQ8bfbRRWgqgwc9eO0kaYbo6ZwLrBlTHRmhpJFXu/kHXG
         dXBQ==
X-Gm-Message-State: AJIora+aMEtbdMuSPB07+6zcTARwpuXIGYKmT+8NZ2/6tRtGRcQnEVBp
        9MkUGTNgMXkKI2cLK/XwCMMzbMT8oIeMpQ==
X-Google-Smtp-Source: AGRyM1sjWvYm+qQ4BW2cd3W6CjjSosbZ8CrO2mQYHT8N8FG4tQSn/tZEdcqpOsHusA0PlUD+TEqBiQ==
X-Received: by 2002:a5d:48ce:0:b0:21b:9f34:f297 with SMTP id p14-20020a5d48ce000000b0021b9f34f297mr7654918wrs.351.1656584693134;
        Thu, 30 Jun 2022 03:24:53 -0700 (PDT)
Received: from localhost.localdomain ([41.232.197.17])
        by smtp.gmail.com with ESMTPSA id g1-20020adffc81000000b00213ba3384aesm19536954wrr.35.2022.06.30.03.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 03:24:52 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v3] selftests: net: fib_rule_tests: fix support for running individual tests
Date:   Thu, 30 Jun 2022 12:24:49 +0200
Message-Id: <20220630102449.9539-1-eng.alaamohamedsoliman.am@gmail.com>
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

parsing and usage of -t got missed in the previous patch.
this patch fixes it

Fixes: 816cda9ae531 ("selftests: net: fib_rule_tests: add support to
select a test to run")
Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in v2:
	edit commit subject and message.
---
changes in v3:
	add Fixes tag
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

