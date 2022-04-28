Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F544513A4E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245096AbiD1Qvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbiD1Qvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:51:51 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A2FB3C6E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:48:36 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b20so1462802qkc.6
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=jIsF3rtsv3dyUOQ/FdznlMAXrqwzsrDR2DOibUIzDjk=;
        b=fygncZzLsSXOIjgmndzq6gFHu5FVcSIXjY/5VfO5Ml+kfVO2NSFjbKnKQhcj+lLBMr
         f7Ht2rWB0MJjT3tijmBhWbaZvBIylennOHxMTd0sgve/QzD51NQkB/yfVFj2/ZJJIENQ
         UqY5l1w7QyT/x3NwSuPo5J1ACcO8FwOT3kx6ZYmfvZIeYeMywAVOMTWxP0jCWijjNQOM
         qL6poXSywzG0MLhSJYfBOy244ZMZoYBB/hOecJiRGgvXDBwvMZ+UDTckiO/+05IqOUZD
         Czlxs9kydBib5JbE2xz0je2aeqgl7Nd8e1YhlCH0Ew+6klAR2vCAWmp7jKt3tIkjkKdK
         aXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=jIsF3rtsv3dyUOQ/FdznlMAXrqwzsrDR2DOibUIzDjk=;
        b=blEsdylK/jLQp5CGD3IJTfAaiLVZS4zhvUHtSMJdifTj+bO47uCnALARnlNjbiTxmw
         +M56s9ij1J6kUj/xfpz4wUohoppk6DdS8fOWB4j2nvLt2wpqwNdaOBQSIBGM7fF4Yatt
         BV/jBzj2mgXMkJRh2EpMLhJs/ETASOOkDwJcnRR9J+WAvnScgYTVE+tAmCXKgYTXFgw5
         Y9qNe7AZfpGOcW+s8INWmsQo3hZoYuC+rbi8wOAC9tZ+voksdgzwhwdIE/VR2tV/alT8
         foKsY2l8V2oa7RvazdlR6GxMTxs8eEAaDKOcptRI0E0ubdHkrRafk7aUOh/bG18dmxsx
         FHIQ==
X-Gm-Message-State: AOAM531cm8AazL/j+8vhskWxZnFrDY8iKXswRRwhjYQydUMPDbxc7r/c
        ftot71E7FFw4o7SJokfizm2MYsF60uy9gQ==
X-Google-Smtp-Source: ABdhPJyTgs6wVjajO/KKaxckAlLrkI9QsItKrEQqXeaY3UrkJ3Ttegn4SEE7JTNw8EC0rMhN8wFvrQ==
X-Received: by 2002:a37:6b07:0:b0:69f:6115:3c9e with SMTP id g7-20020a376b07000000b0069f61153c9emr12125327qkc.508.1651164515689;
        Thu, 28 Apr 2022 09:48:35 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id t125-20020a372d83000000b0069c1df12422sm195423qkh.84.2022.04.28.09.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 09:48:34 -0700 (PDT)
Date:   Thu, 28 Apr 2022 12:48:31 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        jhpark1013@gmail.com, Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Message-ID: <20220428164831.GA577338@jaehee-ThinkPad-X1-Extreme>
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
version 3:
- Added commented delineators to section the code for improved 
readability.
- Moved the log_section() call into the functions handling the tests.
- Removed unnecessary spaces.


 .../selftests/net/vrf_strict_mode_test.sh     | 47 +++++++++++++++++--
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 865d53c1781c..423da8e08510 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 
+TESTS="init testns mix"
+
 log_test()
 {
 	local rc=$1
@@ -262,6 +264,8 @@ cleanup()
 
 vrf_strict_mode_tests_init()
 {
+	log_section "VRF strict_mode test on init network namespace"
+
 	vrf_strict_mode_check_support init
 
 	strict_mode_check_default init
@@ -292,6 +296,8 @@ vrf_strict_mode_tests_init()
 
 vrf_strict_mode_tests_testns()
 {
+	log_section "VRF strict_mode test on testns network namespace"
+
 	vrf_strict_mode_check_support testns
 
 	strict_mode_check_default testns
@@ -318,6 +324,8 @@ vrf_strict_mode_tests_testns()
 
 vrf_strict_mode_tests_mix()
 {
+	log_section "VRF strict_mode test mixing init and testns network namespaces"
+
 	read_strict_mode_compare_and_check init 1
 
 	read_strict_mode_compare_and_check testns 0
@@ -343,16 +351,37 @@ vrf_strict_mode_tests_mix()
 
 vrf_strict_mode_tests()
 {
-	log_section "VRF strict_mode test on init network namespace"
 	vrf_strict_mode_tests_init
 
-	log_section "VRF strict_mode test on testns network namespace"
 	vrf_strict_mode_tests_testns
 
-	log_section "VRF strict_mode test mixing init and testns network namespaces"
 	vrf_strict_mode_tests_mix
 }
 
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+	-t <test>	Test(s) to run (default: all)
+			(options: $TESTS)
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
+
 vrf_strict_mode_check_support()
 {
 	local nsname=$1
@@ -391,7 +420,17 @@ fi
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

