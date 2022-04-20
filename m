Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B1D508044
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 06:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359330AbiDTEti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 00:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347823AbiDTEth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 00:49:37 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD40D26ADF
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 21:46:51 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id j6so458693qkp.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 21:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=1ylqEqxzb9r+YeMoJNAalBpdnk8Al8y9yQpbE6jYWN8=;
        b=ePQtUR0CT/pXx6sb2HBbfZFx3TyruHPu1U/fHrtcjobRnqdpSw9NZYm7B0uhmGJJZp
         IM4T0mFJwQxroQgOl55UY+rnSD71PJPd54SFICQe0uDW2E2MtGigv3agCYkGDJZgOTsN
         wugqfPLu0axe1YENOfrYtUzxGV0HJjTTZpWDpQ85/VdwM0RcMJ0x+WiP+LH4Z5zM3GPu
         kytAFF9wq9wdhYAulcnFv24lsrLqEBxuk/cvDzTUXZp6IvAP50YlG+rXtFwUD2EU26S9
         kiyeFeyF1GXs1G7GVxAD4eSapPJx1Q45QwRi+KO/H/zh3nWERgX6/iOW0iDQEPp7fO8p
         G86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=1ylqEqxzb9r+YeMoJNAalBpdnk8Al8y9yQpbE6jYWN8=;
        b=4wXBhcSAdn+ycdoUVWNc6JqEwlSjJHMCL0hPr6546PQs8K1NFk99HT3w+R/xvB3FUV
         lM5cZEyU7Rlv/WWbgKVDQ5K/zzriFpA/UV4k/s34uRvVIbF7ZBmqC7SA6wzT5Suyf+qo
         2tYR++MQzJvfpK8yQKdRkvZxLFi0PwapYB4hU7lmxNRL7lZAlvWdJOnka2iFxdjIPezJ
         hoUs0Qzk86tsGrDMLVPGK1dpzwYQFg1G5rhm7r11ocn9VNyc7PlgPv+UPhQvuunpUt2b
         /wTQzc80gXjCFZmWEYu05YNOJhoFksPcg0vgSdAoo9Sa4m1mOkjjoup6oDJFs+FU1QIH
         TuHw==
X-Gm-Message-State: AOAM532MreQmkSg1HLUZoDSBG1RcFaWR8ov1lEnO5dcGSDgOFEn/v9uh
        wp+a99u8Au0dQmbI2p82PA4=
X-Google-Smtp-Source: ABdhPJwBdEI+HlfQ3U4jcPWiC4cWilA2sEUfPfvPJFZ44Qb6cJ/Q5f6ItzIb8ocTORISD7hybvhY5g==
X-Received: by 2002:a05:620a:6ce:b0:69c:c0b4:ed2b with SMTP id 14-20020a05620a06ce00b0069cc0b4ed2bmr11647512qky.718.1650430011072;
        Tue, 19 Apr 2022 21:46:51 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([2607:fb90:50e7:2813:787e:11ec:44cf:aee6])
        by smtp.gmail.com with ESMTPSA id c10-20020ac87dca000000b002f2067229bcsm1184223qte.77.2022.04.19.21.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 21:46:50 -0700 (PDT)
Date:   Wed, 20 Apr 2022 00:46:47 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        jhpark1013@gmail.com
Subject: [PATCH] [net-next] selftests: net: vrf_strict_mode_test: add support
 to select a test to run
Message-ID: <20220420044647.GA1288137@jaehee-ThinkPad-X1-Extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a boilerplate test loop to run all tests in
vrf_strict_mode_test.sh.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
---
 .../testing/selftests/net/vrf_strict_mode_test.sh  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 865d53c1781c..116ca43381b5 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 
+TESTS="vrf_strict_mode_tests_init vrf_strict_mode_tests_testns vrf_strict_mode_tests_mix"
+
 log_test()
 {
 	local rc=$1
@@ -391,7 +393,17 @@ fi
 cleanup &> /dev/null
 
 setup
-vrf_strict_mode_tests
+for t in $TESTS
+do
+	case $t in
+	vrf_strict_mode_tests_init|vrf_strict_mode_init) vrf_strict_mode_tests_init;;
+	vrf_strict_mode_tests_testns|vrf_strict_mode_testns) vrf_strict_mode_tests_testns;;
+	vrf_strict_mode_tests_mix|vrf_strict_mode_mix) vrf_strict_mode_tests_mix;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+
+	esac
+done
 cleanup
 
 print_log_test_results
-- 
2.25.1

