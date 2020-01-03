Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7691C12F511
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgACHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:41:43 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38782 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgACHln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 02:41:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so18772895plj.5
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 23:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ddIne0bfNS9Nhf6Wt7zeMAdPt+8BXs7JsrM7RnJhLZc=;
        b=oPDiSJugJ4QFEvdLc6GSzvfwGq2qjCFf9grpMaAgSGEmMUUjg4jxLASLVhGmjshtt4
         I9Ec8fJP6Lt0K0ni1AAJ+mk9FcplO9pRqRpGmphIBPtzfcOYuES/AFEmlhz2w9UBDfX9
         sx7S10TVe23vRejkekfMl6Z35lE9yDMobeXBOLENm9zSvr9zFaOZeTyaV6MvSIAo1kla
         ZHx3A+RUHSottGlXD3l5KWhaAE7xoc7LVshbb/OewAU3A2J2Cg9MoKdGkY/Tr4i9IhtD
         yL7/4A7v+yEAbgUFRQEjm0yi3d2lMzE83eDvjdORjOGl2ddwOm6wh+iTtDmP2UD1lGI1
         ctSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ddIne0bfNS9Nhf6Wt7zeMAdPt+8BXs7JsrM7RnJhLZc=;
        b=tgdLtcwRj3B675+Y99H0nmT+OiILsOG150s+33ZkxIA2VnPPaNksKHx/4QrNNnM8yu
         eessgkXt/1oD74JUersGfy05+gbJYijq6Dq3QxZnYMA3n2lrTI48Z6CUkc0ytG82a4bq
         +1q0Fxk+aiTEhDGliStRq8lx/UprgSwW50afUo/N0siAvx/upQ2cQDy/cyKMGn3w3Zez
         mx08ld9mXgNtpsnRqIAW2Y7bOEWWE147TKDBux/1ec9uUT8v7B8J0B8aVJNu+vjICh9W
         +YBbb/OsCxwoKJOYIVqpJQsdOXtHwaOSD9Md+sYKTHwcwdhsYRQMoLIz6XC9jIh5OTRC
         ZXig==
X-Gm-Message-State: APjAAAUBzWP5bN6jeFDMS/NDn7M5ah1VbZUSZ65kmR8uasRuvbiooJKL
        dUSqMJMhxMlsR+ga/qU1te8Jvnp9egQ=
X-Google-Smtp-Source: APXvYqyxcFQHRX/dcjGj4jyCXItji1SCbpfXyLUmT8BKK3aBEgGnyv8izWrQv7QIwBSHyJk3jdr1sA==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr47092634plb.78.1578037302287;
        Thu, 02 Jan 2020 23:41:42 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r2sm60792609pgv.16.2020.01.02.23.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 23:41:41 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: loopback.sh: skip this test if the driver does not support
Date:   Fri,  3 Jan 2020 15:41:24 +0800
Message-Id: <20200103074124.30369-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The loopback feature is only supported on a few drivers like broadcom,
mellanox, etc. The default veth driver has not supported it yet. To avoid
returning failed and making the runner feel confused, let's just skip
the test on drivers that not support loopback.

Fixes: ad11340994d5 ("selftests: Add loopback test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/loopback.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/loopback.sh b/tools/testing/selftests/net/forwarding/loopback.sh
index 6e4626ae71b0..8f4057310b5b 100755
--- a/tools/testing/selftests/net/forwarding/loopback.sh
+++ b/tools/testing/selftests/net/forwarding/loopback.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 ALL_TESTS="loopback_test"
 NUM_NETIFS=2
 source tc_common.sh
@@ -72,6 +75,11 @@ setup_prepare()
 
 	h1_create
 	h2_create
+
+	if ethtool -k $h1 | grep loopback | grep -q fixed; then
+		log_test "SKIP: dev $h1 does not support loopback feature"
+		exit $ksft_skip
+	fi
 }
 
 cleanup()
-- 
2.19.2

