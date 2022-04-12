Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73ED4FCBD8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbiDLBWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243937AbiDLBWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:22:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765BE19038
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:20:17 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso707531wme.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFFBcTCNwl9knCpbtidIdIlm360cTcZn6q5NsNbTv+8=;
        b=YwPJIEicgGMBO7Pn9pA3gpyuZV+1U5rD2CYdAC+5MnV5RxCnTuQiUvTQ9ii0a0A5eO
         r8/nrO4kXjKTO/NOql9u5nmhaWCMPQ/pJXZYnLqY/iaUWF/bfDFHJzTUVyEAaX0KVjzs
         oEiC8s+toPh1P5VqxAqsv1qLFzvpp1DUbg023rMg0MTRCyFCTZsIJacU/4vxaeVbIPHP
         OZVChy8UQHO96kfqu5+aJ0RjMQ8yhp2YIjeqJJvjVj4oaYpzC3KxbZmCKsAGQlfPz80w
         GqdqPZOhnM2A9BbjXvKDXcmQX3xxHZdCYT0fUVQ9LJgod+IW9L4n97ZZDbNP/DkovhVA
         VZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFFBcTCNwl9knCpbtidIdIlm360cTcZn6q5NsNbTv+8=;
        b=wezjMOwaUdVcR9d/NVm2eEyhr84FfDyQ0QqtRcDqlQO/DKvsERMGYucuay0Qutzb4a
         GOgru98/Z14JRQU3tCbvyfZ0s8alGqhdwqYTK5KkZYUBlhtSE5X8U7Q2J9zOW0JsYd5F
         5GSHHNkZIRkafknspQlwBOwjc9vm53h8oSxZr6EdAFx7569dvJ85JZQaL/Oq9PNwcIFh
         nk70Vl7+5tffNkgoE7GovVyNjDQvrV+e1jzOXlcb42Bc9RlftsD0bcqcVZJg5wmk+A3T
         dO91k7LuxJNTsSgOGOHoqpaN9EAmZNr1hMSFafUhbbkk2v6A9IiRlEa5sDl7jJqLqdu0
         3HPQ==
X-Gm-Message-State: AOAM531b0u0My3LFxdfnI3xe6axEP9NfGxqz0G+AzDa+Y2GefXeLgZWt
        qAwBOc0YvousAyw66VcN2r0=
X-Google-Smtp-Source: ABdhPJzdiFcVWqNNmjJofop+osQoJJvHGJ4h4/nLpbKVmTDfuxNHyM4bJxtG4wbpn04j2gmSnAHSbQ==
X-Received: by 2002:a05:600c:2113:b0:38e:bc71:2b0 with SMTP id u19-20020a05600c211300b0038ebc7102b0mr1591389wml.153.1649726415995;
        Mon, 11 Apr 2022 18:20:15 -0700 (PDT)
Received: from alaa-emad ([197.57.239.92])
        by smtp.gmail.com with ESMTPSA id c186-20020a1c35c3000000b0038e6c6fc860sm929472wma.37.2022.04.11.18.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 18:20:15 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, roopa.prabhu@gmail.com, jdenham@redhat.com,
        sbrivio@redhat.com, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH] selftests: net: add support to select a test to run
Date:   Tue, 12 Apr 2022 03:20:12 +0200
Message-Id: <20220412012012.3818-1-eng.alaamohamedsoliman.am@gmail.com>
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

