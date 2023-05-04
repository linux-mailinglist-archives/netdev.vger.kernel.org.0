Return-Path: <netdev+bounces-416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D346F7687
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FFC21C214AB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21754171D8;
	Thu,  4 May 2023 19:48:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF9171B8
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:48:47 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E096C31B1F;
	Thu,  4 May 2023 12:48:31 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-61aecee26feso4298426d6.2;
        Thu, 04 May 2023 12:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683229650; x=1685821650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6VXMMoQpmmLLTqAMK/HVD6CSjpNQIit8KTC+MR0S3So=;
        b=kC+uuqSY01yFv7otF/TCzd5ztxBa3KWC+PzsGqMUr+4fuCZYgDUbctV5Vu8D8kbpaI
         QCJBlq3XnAHiRV8eGxrg/lHtwErOvEck6ejQNn8yek0DFvCPnwQN0shWSe2iswQ28Tz0
         S9VQRisxTkJfiqZxi+QBeYqXw3UR5MPLoFQMgQoENRQBG9t7KD0wrOzLHHVGCmwmoDf3
         QlUSBzA7NWmuW3tLOcPgycXjLZ8/V6AqMpESI5hrfvPeAjVyjhRORMYtyQRDMaKaDyZv
         IIPeEP6XfQKRH4X/Tiy+rjefrVruq9O5+7Q+WlSqXJ22b9vRvrlrn1rl7Tkc6+8VgLET
         Lzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683229650; x=1685821650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6VXMMoQpmmLLTqAMK/HVD6CSjpNQIit8KTC+MR0S3So=;
        b=UteTEpHSb00GWVXm9TwZBcuG93FWCPsDDnuuHSshezfkuhphTk1iB080MY0zskc1Qx
         L9hTAynED92pOo8x+j52h/vNc4Znlr86uF2e2WaozYoyy7pPHfl0BB2tn9gBhhkg2Q6C
         Q743MfDtt5pQWIgUev5V6SajIfRySYiCmSR3nnnIskqDDrOg0MdjKIgTAPZeNRy9NTg6
         jbF78qGeaqPqcIelEAYSB/ebtURt5v8Qc8fC5BJqhRJlMvNZdz3Opuv0OaHpJhIP9dNu
         tADjTQ++8wEewnlM/mw8NNTeZ7mZPF0SCLsR1/tH3NDGQKNYgNvF5k1S86RYLkqiNUxq
         XbLA==
X-Gm-Message-State: AC+VfDzOGJBcIDb4TYthKQFqyCXEjx9q0Y2xJQNngW7rrgGRF3zT5iLi
	69h5Q0FlxUEPi01IrxnKq+M=
X-Google-Smtp-Source: ACHHUZ4uWSbbxncNGTC0bS6QLcwxmysVOskKXs82cMchY6pJ8W2C2JSPuNmQJKbRNVwTySact/rF3Q==
X-Received: by 2002:a05:6214:1307:b0:5ef:4ecb:cf9d with SMTP id pn7-20020a056214130700b005ef4ecbcf9dmr19293065qvb.6.1683229650575;
        Thu, 04 May 2023 12:47:30 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com (207-172-141-204.s8906.c3-0.slvr-cbr1.lnh-slvr.md.cable.rcncustomer.com. [207.172.141.204])
        by smtp.gmail.com with ESMTPSA id k12-20020a0cf58c000000b0061eaef8ff84sm354723qvm.28.2023.05.04.12.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 12:47:29 -0700 (PDT)
From: Jason Andryuk <jandryuk@gmail.com>
To: Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	v9fs@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3] 9p: Remove INET dependency
Date: Thu,  4 May 2023 15:47:23 -0400
Message-Id: <20230504194725.546460-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

9pfs can run over assorted transports, so it doesn't have an INET
dependency.  Drop it and remove the includes of linux/inet.h.

NET_9P_FD/trans_fd.o builds without INET or UNIX and is usable over
plain file descriptors.  However, tcp and unix functionality is still
built and would generate runtime failures if used.  Add imply INET and
UNIX to NET_9P_FD, so functionality is enabled by default but can still
be explicitly disabled.

This allows configuring 9pfs over Xen with INET and UNIX disabled.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
---
v3
s/unusable/usable/

v2
Add imply INET and UNIX
---
 fs/9p/Kconfig          | 2 +-
 fs/9p/vfs_addr.c       | 1 -
 fs/9p/vfs_dentry.c     | 1 -
 fs/9p/vfs_dir.c        | 1 -
 fs/9p/vfs_file.c       | 1 -
 fs/9p/vfs_inode.c      | 1 -
 fs/9p/vfs_inode_dotl.c | 1 -
 fs/9p/vfs_super.c      | 1 -
 net/9p/Kconfig         | 2 ++
 9 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index d7bc93447c85..0c63df574ee7 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config 9P_FS
 	tristate "Plan 9 Resource Sharing Support (9P2000)"
-	depends on INET && NET_9P
+	depends on NET_9P
 	select NETFS_SUPPORT
 	help
 	  If you say Y here, you will get experimental support for
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 6f46d7e4c750..425956eb9fde 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -12,7 +12,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 65fa2df5e49b..f16f73581634 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 3d74b04fe0de..52bf87934650 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -13,7 +13,6 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/sched.h>
-#include <linux/inet.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
 #include <linux/fscache.h>
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 44c15eb2b908..367a851eaa82 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -14,7 +14,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/list.h>
 #include <linux/pagemap.h>
 #include <linux/utsname.h>
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 1d523bec0a94..502ac74e4959 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -15,7 +15,6 @@
 #include <linux/pagemap.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 331ed60d8fcb..a7da49906d99 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 266c4693e20c..10449994a972 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -12,7 +12,6 @@
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index deabbd376cb1..00ebce9e5a65 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -17,6 +17,8 @@ if NET_9P
 
 config NET_9P_FD
 	default NET_9P
+	imply INET
+	imply UNIX
 	tristate "9P FD Transport"
 	help
 	  This builds support for transports over TCP, Unix sockets and
-- 
2.40.1


