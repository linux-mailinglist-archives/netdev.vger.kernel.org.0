Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD94250A5FE
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiDUQnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiDUQnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:43:17 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6433BBCE
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:40:27 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id f14so3692716qtq.1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=NK5AvJGH8CU9PHacyyajo0HKWC+ZEk6dfV4Zh9zjrRA=;
        b=Om9mwG8hMYPViAnILKqcJ/woUp9oHlzR29y/gHeacvnj3oDjwebWfmy+LjPcdbiJhg
         t8hSSlLZ8EmW9j4fk0JkWG9+L9ObhKRGqq/bCtlfv9HuBZLwBgGuN5VG0jjiIHrlBIl3
         i1z/DmlCEPsvMxqB7HjLL/wqxr7kO5xj99DkGwywA+ovnN9qfiGkn4V7PgFEj0/YgnpG
         nwIyuHJbW6OCDsWQLLe8poZLS8AG5KxyM5csD4lHIBdIsOUA/kWhQN3VxFPLxY/Mvkjr
         JNFqQhvKTTAE5jg+FHLDQ2w0+Pe95cLXdBR+Y0cvB3wUK0/eDUeRX0MV1A2pIRBtBuhu
         CAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=NK5AvJGH8CU9PHacyyajo0HKWC+ZEk6dfV4Zh9zjrRA=;
        b=nWTlFlROOqcsVVXgF03NIDP7UF9Y84tQKAQeEo4AKgz3lVoBXfN2xfpqFRphWrTE1E
         Aavkajh9FWhxJU2F5Q83Ofgn92b7FVujzNrqvGjLN6OJkWxcxqbFIY1oWnWRxfuj2FVC
         JbYa7Sf/EOpSWtZhvGJR0CM+xckrf8oITQZWrp49vFiVihsyODkXysC2oHwqRDLUbOL3
         vPixxJTSuj8B3MSuc1+cV+RlXNo7uUiGqO93pRf4EFHW2wmSK+WQ7Q+pNoqMy4/8AB6+
         U2LxyXqbLTG+8WG7iob6yiFIbYwWt+abt0WcHEBWA87VfTE1dvE90huiur4qkYNUtebT
         OneA==
X-Gm-Message-State: AOAM533f8wfJGCI/kKFjiJgB05SRAErderke1UhJjt/0VKkqhnJp+ET7
        c7fxrYfNF3LH1J2teL8Aerg=
X-Google-Smtp-Source: ABdhPJz8jzEks7vWpmxYpuH5St7u0pzx660Ji9GyOUd2FkgsuWt61Wql4HWZvSO1IEAokqlTAcgQkA==
X-Received: by 2002:ac8:110a:0:b0:2f1:ea84:b84 with SMTP id c10-20020ac8110a000000b002f1ea840b84mr234574qtj.463.1650559227033;
        Thu, 21 Apr 2022 09:40:27 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id 19-20020a05620a079300b0069eb4c4e007sm3002275qka.29.2022.04.21.09.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:40:26 -0700 (PDT)
Date:   Thu, 21 Apr 2022 12:40:22 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        jhpark1013@gmail.com, Roopa Prabhu <roopa@nvidia.com>
Subject: [PATCH net-next v2] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Message-ID: <20220421164022.GA3485225@jaehee-ThinkPad-X1-Extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a boilerplate test loop to run all tests in
vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
run.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
---
 .../selftests/net/vrf_strict_mode_test.sh     | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 865d53c1781c..ca4379265706 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 
+TESTS="init testns mix"
+
 log_test()
 {
 	local rc=$1
@@ -353,6 +355,23 @@ vrf_strict_mode_tests()
 	vrf_strict_mode_tests_mix
 }
 
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+	-t <test> Test(s) to run (default: all)
+		  (options: $TESTS)
+EOF
+}
+while getopts ":t:h" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
 vrf_strict_mode_check_support()
 {
 	local nsname=$1
@@ -391,7 +410,17 @@ fi
 cleanup &> /dev/null
 
 setup
-vrf_strict_mode_tests
+for t in $TESTS
+do
+	case $t in
+	vrf_strict_mode_tests_init|init) vrf_strict_mode_tests_init;;
+	vrf_strict_mode_tests_testns|testns) vrf_strict_mode_tests_testns;;
+	vrf_strict_mode_tests_mix|mix) vrf_strict_mode_tests_mix;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+
+	esac
+done
 cleanup
 
 print_log_test_results
-- 
2.25.1

