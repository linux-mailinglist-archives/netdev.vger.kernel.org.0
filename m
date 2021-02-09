Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B145C3149A8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBIHqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhBIHqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 02:46:10 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF6EC061786;
        Mon,  8 Feb 2021 23:45:29 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id f23so9837397lfk.9;
        Mon, 08 Feb 2021 23:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVGO03k2Z5yA4pdbSwOMiuVKk12UBVJV+7eU9tK1wzM=;
        b=nHvL/Knlnninm+KzRwrYuDWpNUPbvgIVKyEYdaE+B6uEvBhM9pBQBHZ0e7vxrzJ2lF
         XYjtTQpOtgZv45eRsBwzi5BoNL5vnqMCxlVb6wPfzeIml/FAREZm5VjknjcLaSoxf7K+
         AAAhPoL37DAmcQGWsQhLWd4kVsBmQQQt0lzZOWEsy/EZEYRqkOFsh3qMYpcXv8wnHzQQ
         8MSH+hCgQ/r+DQ7f+8AvYlKV2O9gQBRpF02SNWwvU/1U6RJFljw0S+Pr7WeI6Zzjl6LK
         DAbWvsXpmznjr3+y8y1Gnx8+L+4ql2CjmbVPSAjzNMf6a+7q8u2pbuXl0x6QJyPP2Kc+
         gV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVGO03k2Z5yA4pdbSwOMiuVKk12UBVJV+7eU9tK1wzM=;
        b=oviFt6VROkoSTMgW8G0IeOIHwyesix2e6nWvKDnxzIBBwXc9zc2Xn6DE0DI+Uv3Eia
         JqU3Gps0fViZfg1pir0qSpM29BccKnx0vjMy2LZ00cBlSf+cAk5FVzCMLtPX6xr41luZ
         LjshSfJy9PNwmy4CC5+EF7ooxy8pTTYhv2I0LOJ+1fbk9xWPXgWOIpdd9ld+VVA56DWY
         RneiAeEYQiwjSZJc8mdgfDew63IQaDaQYEo1ddiDdt9pzV+2U+TXiGWqCcH8L3cofhmf
         d1AEDklfVkOGEVeLCbTCkQaTfBSg02G3nangKiwnNQcnMplY7b0rJTgznEY5NdnMN2C4
         Qc9g==
X-Gm-Message-State: AOAM532jV9xdM284we8PjPHnWOvT43o3G4sjQG11jERxOxVJALvvJxJK
        AQh4pjRcRoSbE25aQZpcvgIe9Af9uwR9Pw==
X-Google-Smtp-Source: ABdhPJxb5AH6hnF74CRYu6EPI59CITRtGct5St7XKQFLKO2L6ndLWdjXYgQ/9p2XPJ+mFoe9uPa03w==
X-Received: by 2002:a19:7001:: with SMTP id h1mr12405270lfc.513.1612856728247;
        Mon, 08 Feb 2021 23:45:28 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id c9sm2396186lji.121.2021.02.08.23.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 23:45:27 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        u9012063@gmail.com, rdunlap@infradead.org,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf v3] selftests/bpf: convert test_xdp_redirect.sh to bash
Date:   Tue,  9 Feb 2021 08:45:18 +0100
Message-Id: <20210209074518.849999-1-bjorn.topel@gmail.com>
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
use '||' to capture the return value of a failed command.

v3: Reintroduced /bin/bash, and kept 'set -e'. (Andrii)
v2: Kept /bin/sh and removed bashisms. (Randy)

Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index dd80f0c84afb..3f85a82f1c89 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Create 2 namespaces with two veth peers, and
 # forward packets in-between using generic XDP
 #
@@ -43,6 +43,8 @@ cleanup()
 test_xdp_redirect()
 {
 	local xdpmode=$1
+	local ret1=0
+	local ret2=0
 
 	setup
 
@@ -57,10 +59,8 @@ test_xdp_redirect()
 	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
 	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
 
-	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
-	local ret1=$?
-	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
-	local ret2=$?
+	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null || ret1=$?
+	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null || ret2=$?
 
 	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
 		echo "selftests: test_xdp_redirect $xdpmode [PASS]";

base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
-- 
2.27.0

