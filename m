Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E990931863E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBKIVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhBKIVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:21:43 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CF6C061574;
        Thu, 11 Feb 2021 00:21:03 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m22so6914936lfg.5;
        Thu, 11 Feb 2021 00:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D8VsKTsNEuZP6ZxpKofqGw/kZ1i+lqPcBD6ub/pSfiM=;
        b=vcUqTSaTWOwECmpxABRkAgSesfrI9GmRSnYyG05orb1SNIVz8YZPYXjlmtNre5c5i0
         F9u0dIvVuBciXMrYoLTm9fTcB1cs9ZN3Elg5tUfEIrhjBTO7L/w8Y97DIpGBwS19nDmk
         o2MAQwmXSaTRSgwHfKSAroVk/018s9/EjVIdpfvHpXsMu2sY6LRTeI4RCx9YBY7GlrCE
         PJmmCHkJ5jpDRqV6CzqcDQYjfsR7OpMmbiCHNWo6UuMh+doz2bcM/EVO6vT8+tcmqa20
         lkWHLyUr7MLBUbY8NpKVsk+Gp2h9tB0S3ajyG3BgFcd1h/CVw3AK2hWPaDgfB6CxSizb
         fRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D8VsKTsNEuZP6ZxpKofqGw/kZ1i+lqPcBD6ub/pSfiM=;
        b=l5TDiDhLz9pRxvHJBNhUZYBRJLk4qOA+iPkFu3ULfFShKyTFb6RfHNygArqx0vO3nV
         44qvGy8rjxRJ3KCbQtIoN26diuMMDlmC1Bhd06kOmvJF8/lu0nW7iNje81sfH3jd26XK
         epOY224RatAJCrhsnnxgVNNkT58BdUqDh99ogByv9c8DPVe6iGF+rmaRVHJivNIxzf8K
         5qBg3G+pIgQvTmuXkflXuGTZSbNFIOyw7nejqDkePUONDpWluMiwKA1KFobF9OxzbGrB
         Nyme45Zvr0jkPw4okpL6K8jsN0v5DyvilZeeDkTqLesvO/KwMua1OTwyravYsfyVh3LY
         mpFg==
X-Gm-Message-State: AOAM531KygDpjodp1O7651JSoAqv2iRGlFxUG/s8BuMuic3ej/tGoQEc
        iFQa3cEQmwakGq6Y9+iyOoM=
X-Google-Smtp-Source: ABdhPJxCZgafsiYM/5b7TRQ/D2LTMzVfjB0If5VCCDfzYTQ3F30N/W9Fg1oM1VBmcSgZy5FVkv+rvQ==
X-Received: by 2002:a05:6512:453:: with SMTP id y19mr3606129lfk.329.1613031661936;
        Thu, 11 Feb 2021 00:21:01 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id k16sm585285lfm.39.2021.02.11.00.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 00:21:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        u9012063@gmail.com, rdunlap@infradead.org,
        andrii.nakryiko@gmail.com, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf v4] selftests/bpf: convert test_xdp_redirect.sh to bash
Date:   Thu, 11 Feb 2021 09:20:29 +0100
Message-Id: <20210211082029.1687666-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The test_xdp_redirect.sh script uses a bash feature, '&>'. On systems,
e.g. Debian, where '/bin/sh' is dash, this will not work as
expected. Use bash in the shebang to get the expected behavior.

Further, using 'set -e' means that the error of a command cannot be
captured without the command being executed with '&&' or '||'. Let us
restructure the ping-commands, and use them as an if-expression, so
that we can capture the return value.

v4: Added missing Fixes:, and removed local variables. (Andrii)
v3: Reintroduced /bin/bash, and kept 'set -e'. (Andrii)
v2: Kept /bin/sh and removed bashisms. (Randy)

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index dd80f0c84afb..c033850886f4 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Create 2 namespaces with two veth peers, and
 # forward packets in-between using generic XDP
 #
@@ -57,12 +57,8 @@ test_xdp_redirect()
 	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
 	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
 
-	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
-	local ret1=$?
-	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
-	local ret2=$?
-
-	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
+	if ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null &&
+	   ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null; then
 		echo "selftests: test_xdp_redirect $xdpmode [PASS]";
 	else
 		ret=1

base-commit: 291009f656e8eaebbdfd3a8d99f6b190a9ce9deb
-- 
2.27.0

