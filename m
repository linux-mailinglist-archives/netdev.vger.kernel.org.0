Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2313C298C5B
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774101AbgJZLyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:54:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34148 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770594AbgJZLyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 07:54:37 -0400
X-Greylist: delayed 1296 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 07:54:37 EDT
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kX0kG-00CutW-3w; Mon, 26 Oct 2020 12:33:00 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] libnetlink: define __aligned conditionally
Date:   Mon, 26 Oct 2020 12:32:52 +0100
Message-Id: <20201026113252.18018-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems (e.g. current Debian/stable) the inclusion
of utils.h pulled in some other things that may end up
defining __aligned, in a possibly different way than what
we had here.

Use our own definition only if there isn't one already.

Fixes: d5acae244f9d ("libnetlink: add nl_print_policy() helper")
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 lib/libnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index a7b60d873afb..c958aa57d0cd 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -30,7 +30,9 @@
 #include "libnetlink.h"
 #include "utils.h"
 
+#ifndef __aligned
 #define __aligned(x)		__attribute__((aligned(x)))
+#endif
 
 #ifndef SOL_NETLINK
 #define SOL_NETLINK 270
-- 
2.26.2

