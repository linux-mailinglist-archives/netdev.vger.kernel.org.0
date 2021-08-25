Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F803F71D8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhHYJik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhHYJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A609C061757;
        Wed, 25 Aug 2021 02:37:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id f5so35369868wrm.13;
        Wed, 25 Aug 2021 02:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TFxXv+JEDyBSP+0ivETIiLsWzQlD0yqEZGyjBoEiO6s=;
        b=rk2wAWkvRRrfHFqQk50LBGj4qn4gRz98DzLHgJkM7IvMIXnrK6zcYxxtYX88CQs39h
         9TiPUq1Xe0SPDwAn9sOntpdPu5hn8KIQ9M9L6QbyrWMPsJzl5FVndqx4SrwZvj2WeiR2
         EpJbrRWtePaA5RGX2IQd4aumXVj8oHRpG0kGKEqJOr3YylIi0wQe9TS+vZUyTgtltGgo
         n/Kr8IwxQtx/oxCryBmC9VLt7RWDabxMHldA56y9ttAnKu6xIPP/NzlNdrdEG0vgEhq3
         IgjnDigF9f7P8VGbkrCFq7sBGLa5RrN1u2dDKV2D7TyW0vZ1WvzvycC1grWwZt82PqdE
         yDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TFxXv+JEDyBSP+0ivETIiLsWzQlD0yqEZGyjBoEiO6s=;
        b=cO9ieexDsqACFaWMMAXACslz0q6uMeO6d0YSF7pKDiIEuZjTCcgO3HGlKQynhfneZc
         hwMpJTmzHpOBLGBGZXRFTh0NbPG/docBgaVW18QU1njAaPo27pkNPdMy4dl4dyVuV3H2
         BbEjCj3X3aITAOll4Wjw5UTHNGB4Pkl7fbJFsbckrjhUlEjLtZTu/mctNxiaY1CGK1rn
         S7f2GXM+bjC1HKXL04NAfRscgdvSKOHbLoOIId+/8HKnZIBU3wC2cORr+T44CIVUqBdB
         RvFxVYwVmWhWehkpM1yw2aB1vsZDhHDBB9/d6iVE8XZaRlYCp2EoBXyI8HfMzRP3hKwv
         +yTg==
X-Gm-Message-State: AOAM532e/x1F8q4SiKrBzB91DZjcFepjxtjSBypZo45Q1hVGDCRRsldr
        o9+ZB/20RqnKPSpPVlPzJZI=
X-Google-Smtp-Source: ABdhPJwy0mx1HNys6N5qbZkTCm3nyQddm0xlHj0aTf94JvekvFggkoXMggUHfKomd+m+jiRz3v6ZSA==
X-Received: by 2002:adf:e801:: with SMTP id o1mr22167273wrm.128.1629884272930;
        Wed, 25 Aug 2021 02:37:52 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 01/16] selftests: xsk: remove color mode
Date:   Wed, 25 Aug 2021 11:37:07 +0200
Message-Id: <20210825093722.10219-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove color mode since it does not add any value and having less code
means less maintenance which is a good thing.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 10 +++-----
 tools/testing/selftests/bpf/xsk_prereqs.sh | 27 +++++-----------------
 2 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 46633a3bfb0b..cd7bf32e6a17 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -63,14 +63,11 @@
 # ----------------
 # Must run with CAP_NET_ADMIN capability.
 #
-# Run (full color-coded output):
-#   sudo ./test_xsk.sh -c
+# Run:
+#   sudo ./test_xsk.sh
 #
 # If running from kselftests:
-#   sudo make colorconsole=1 run_tests
-#
-# Run (full output without color-coding):
-#   sudo ./test_xsk.sh
+#   sudo make run_tests
 #
 # Run with verbose output:
 #   sudo ./test_xsk.sh -v
@@ -83,7 +80,6 @@
 while getopts "cvD" flag
 do
 	case "${flag}" in
-		c) colorconsole=1;;
 		v) verbose=1;;
 		D) dump_pkts=1;;
 	esac
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index dac1c5f78752..8fe022a4dbfa 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -8,11 +8,6 @@ ksft_xfail=2
 ksft_xpass=3
 ksft_skip=4
 
-GREEN='\033[0;92m'
-YELLOW='\033[0;93m'
-RED='\033[0;31m'
-NC='\033[0m'
-STACK_LIM=131072
 SPECFILE=veth.spec
 XSKOBJ=xdpxceiver
 NUMPKTS=10000
@@ -50,22 +45,12 @@ validate_veth_spec_file()
 test_status()
 {
 	statusval=$1
-	if [ -n "${colorconsole+set}" ]; then
-		if [ $statusval -eq 2 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${RED}FAIL${NC} ]"
-		elif [ $statusval -eq 1 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${RED}SKIPPED${NC} ]"
-		elif [ $statusval -eq 0 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${GREEN}PASS${NC} ]"
-		fi
-	else
-		if [ $statusval -eq 2 ]; then
-			echo -e "$2: [ FAIL ]"
-		elif [ $statusval -eq 1 ]; then
-			echo -e "$2: [ SKIPPED ]"
-		elif [ $statusval -eq 0 ]; then
-			echo -e "$2: [ PASS ]"
-		fi
+	if [ $statusval -eq 2 ]; then
+		echo -e "$2: [ FAIL ]"
+	elif [ $statusval -eq 1 ]; then
+		echo -e "$2: [ SKIPPED ]"
+	elif [ $statusval -eq 0 ]; then
+		echo -e "$2: [ PASS ]"
 	fi
 }
 
-- 
2.29.0

