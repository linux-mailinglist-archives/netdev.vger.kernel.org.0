Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2144311C5E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 10:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBFJ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 04:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBFJ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 04:27:40 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E646AC06174A;
        Sat,  6 Feb 2021 01:26:59 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id y14so10181705ljn.8;
        Sat, 06 Feb 2021 01:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oY7zonC656M9bvmr5dvhg7r5T0AFXB5lSMtTFca7MI=;
        b=Xjgp4TU4CXMrf4sw1J1JNimfIvf8RWq4KFrDP7k6kPAk+188EAWBq3L6PQNPzgWWen
         3/Ap5Eq5J45NqxaVYwoV3BBw5c4s7jS0weLbonmiwdkPMJZV5YiT9+JlPmUJmfGRIwp6
         /EKkQkx8r6q+IZ54vMD52SgOw8TGMBclqmxFafs9kTYrGxkfP8vqRo0ZJDmRPQWUL35c
         TeFYZSUBceQwy/EWuw5PJGNL036PgCcF6UtkhLq3QqtdGaJY0SIcNKGI2gMD4byRNZJ+
         6i3juDB2cYyDxfhjgn4PWofYLCWC0Oes4iV3yP9o+jFKICbEHefrDdIWwpEpfge9xpnI
         eljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oY7zonC656M9bvmr5dvhg7r5T0AFXB5lSMtTFca7MI=;
        b=NyArxPNOvfhNC7FNljpzzTRfj5R5KLq+MK5r01GCdBWErB+0mQB5YKP1IaP3Sg3Vx5
         mq+4IHuCHJqxz5vmei197YSFRfLy1tNrIxxr8LpU4A0xCEPoNzZSynisqbmx53KumEFZ
         ARCPORfqv06gyfx/fHSGaE31xpryKua7VefIYUk4lZZImxTuGFk4VFzMd6W9SD+3q+/N
         xWDLRXsuDmONGQrv293WnGLnJljL84XrGlWyTjar0elAg13awl7ugrOkRtP6lGjabK0t
         x6sUrb+Bt3y2Y1NrdB4/GOLx0h40yk1phrFi0cy6GCKBK74pBJFSh0cigtORLpfgq2X8
         8USQ==
X-Gm-Message-State: AOAM533jeEdD7BLBF5+IrroO0l8xSxPnd9NjG1l0QcNQQkUdAlGZmBM2
        n0TFX9ruLGUYD6LWwyT3CoE=
X-Google-Smtp-Source: ABdhPJwKbsA1v5Wsifdw1oKHCuBMbbQqov5qnie1K0Y5gnLl++9BHaXyYSNDzcLldWr3jPPbCDUthw==
X-Received: by 2002:a2e:888c:: with SMTP id k12mr5090061lji.365.1612603618277;
        Sat, 06 Feb 2021 01:26:58 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id c7sm1267929ljd.95.2021.02.06.01.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 01:26:57 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        u9012063@gmail.com, rdunlap@infradead.org
Subject: [PATCH bpf v2] selftests/bpf: remove bash feature in test_xdp_redirect.sh
Date:   Sat,  6 Feb 2021 10:26:54 +0100
Message-Id: <20210206092654.155239-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The test_xdp_redirect.sh script uses a bash redirect feature,
'&>/dev/null'. Use '>/dev/null 2>&1' instead.

Also remove the 'set -e' since the script actually relies on that the
return value can be used to determine pass/fail of the test.

Acked-by: William Tu <u9012063@gmail.com>
Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
William, I kept your Acked-by.

v2: Kept /bin/sh and removed bashisms. (Randy)
---
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index dd80f0c84afb..4d4887da175c 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -46,20 +46,20 @@ test_xdp_redirect()
 
 	setup
 
-	ip link set dev veth1 $xdpmode off &> /dev/null
+	ip link set dev veth1 $xdpmode off >/dev/null 2>&1
 	if [ $? -ne 0 ];then
 		echo "selftests: test_xdp_redirect $xdpmode [SKIP]"
 		return 0
 	fi
 
-	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
-	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
-	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
-	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
+	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy >/dev/null 2>&1
+	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy >/dev/null 2>&1
+	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 >/dev/null 2>&1
+	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 >/dev/null 2>&1
 
-	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
+	ip netns exec ns1 ping -c 1 10.1.1.22 >/dev/null 2>&1
 	local ret1=$?
-	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
+	ip netns exec ns2 ping -c 1 10.1.1.11 >/dev/null 2>&1
 	local ret2=$?
 
 	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
@@ -72,7 +72,6 @@ test_xdp_redirect()
 	cleanup
 }
 
-set -e
 trap cleanup 2 3 6 9
 
 test_xdp_redirect xdpgeneric

base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
-- 
2.27.0

