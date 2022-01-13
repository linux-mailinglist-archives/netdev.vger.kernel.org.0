Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895B848D372
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiAMIOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:14:24 -0500
Received: from woodpecker.gentoo.org ([140.211.166.183]:38584 "EHLO
        smtp.gentoo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiAMIOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:14:24 -0500
From:   Sam James <sam@gentoo.org>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>
Subject: [PATCH] lib: fix ax25.h include for musl
Date:   Thu, 13 Jan 2022 08:14:13 +0000
Message-Id: <20220113081413.3522102-1-sam@gentoo.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ax25.h isn't guaranteed to be avilable in netax25/*;
it's dependent on our choice of libc (it's not available
on musl at least) [0].

Let's use the version from linux-headers.

[0] https://sourceware.org/glibc/wiki/Synchronizing_Headers
Bug: https://bugs.gentoo.org/831102

Signed-off-by: Sam James <sam@gentoo.org>
---
 lib/ax25_ntop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ax25_ntop.c b/lib/ax25_ntop.c
index cfd0e04b..3a72a43e 100644
--- a/lib/ax25_ntop.c
+++ b/lib/ax25_ntop.c
@@ -2,7 +2,7 @@
 
 #include <errno.h>
 #include <sys/socket.h>
-#include <netax25/ax25.h>
+#include <linux/ax25.h>
 
 #include "utils.h"
 
-- 
2.34.1

