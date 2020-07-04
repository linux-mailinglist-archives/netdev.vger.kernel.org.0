Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BDB2148B2
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 22:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgGDUpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 16:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgGDUpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 16:45:18 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77769C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 13:45:18 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c30so27818820qka.10
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 13:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIyhX1JxyaHZYSe7JSoYRcL7AVWbPUEaf7X4bNRuMs8=;
        b=pg3GxO47vk6HfY6VsN7wCHyWmIpmR4Me8kpZZ+saJCBmnxAJDssymAJjv6igXjcVth
         xVcJGgEDag+f60+8AQWhZ8gNp726LJ1vnDZSuZuYbsMrrguxEac3c0low+B9lCniiDFa
         mxBxRGMeDRp/TO7avqWfAoNtuNlcwx4tzU0E/15F3n5Z4444BlklGUpAgW/3kiAQydDw
         b9ftP6MzBtLj9s29qgugpwX7jNH7UJzUpaa9P5Z2GhRQo3WZYy8vReez+sjyQKOKVaap
         0oPlggQE3QEB0UxbIaZf2PPFO7fjEU+CXZ2G4tG+SBxI87+/52b2grtVw7msiqXxxD9C
         RDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIyhX1JxyaHZYSe7JSoYRcL7AVWbPUEaf7X4bNRuMs8=;
        b=JBRVde6MklQGJV3/f6pXoxa3ewdAV5iqixXhg59Yi9wJqE26yoEx6HEuihyLbCScYw
         8k/iT8/TkLXmntkGHsLvZAZwlYAdYd5EcwOYlHx6fFoJWQLD+b7IUvtSNP/gC5cxgt2Y
         RsCa1RwC28ul4TK8Ztqsz4UKPieoBW5VgvAU1AtP4Gn/Mz0wDh8GAIB+Yo3aKFhK89aA
         zfvkn8C72DclUM73FsRm6FHUlh+OgtQJxIs8Hn7lzyh9TwRD9F2q/6BUPkwvKUqwuZ+1
         iH6RHZEuWIQ/ylRw3bABEzz4lZrAn9hitLZWXuZmJsT/vKIrN+ufQJbIdMaa8KgETltZ
         wzpw==
X-Gm-Message-State: AOAM533xFhNi70l2ZVjbCYlcXyJsqD0RHiHCTRmHVT1Pjq1IQi4nLQf5
        Q0FXAIh1e/bMxzxsgdaIp/BMWUfN
X-Google-Smtp-Source: ABdhPJy2NuualHX/GPiVZsRp6fdvwyEFdHm8snikxZv1Eu9PnL3xw+cOPYh1eBkxKqf88i6ARqOBsQ==
X-Received: by 2002:a05:620a:12b8:: with SMTP id x24mr32476283qki.158.1593895517434;
        Sat, 04 Jul 2020 13:45:17 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id a25sm15253853qtk.40.2020.07.04.13.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 13:45:17 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: update initializer syntax to use c99 designators
Date:   Sat,  4 Jul 2020 16:45:14 -0400
Message-Id: <20200704204514.3800450-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Before, clang version 9 threw errors such as: error:
use of GNU old-style field designator extension [-Werror,-Wgnu-designator]
                { tstamp: true, swtstamp: true }
                  ^~~~~~~
                  .tstamp =
Fix these warnings in tools/testing/selftests/net in the same manner as
commit 121e357ac728 ("selftests/harness: Update named initializer syntax").
N.B. rxtimestamp.c is the only affected file in the directory.

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/rxtimestamp.c | 30 +++++++++++------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index c599d371cbbe..221fdece47d4 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -68,44 +68,44 @@ static struct socket_type socket_types[] = {
 static struct test_case test_cases[] = {
 	{ {}, {} },
 	{
-		{ so_timestamp: 1 },
-		{ tstamp: true }
+		{ .so_timestamp = 1 },
+		{ .tstamp = true }
 	},
 	{
-		{ so_timestampns: 1 },
-		{ tstampns: true }
+		{ .so_timestampns = 1 },
+		{ .tstampns = true }
 	},
 	{
-		{ so_timestamp: 1, so_timestampns: 1 },
-		{ tstampns: true }
+		{ .so_timestamp = 1, .so_timestampns = 1 },
+		{ .tstampns = true }
 	},
 	{
-		{ so_timestamping: SOF_TIMESTAMPING_RX_SOFTWARE },
+		{ .so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE },
 		{}
 	},
 	{
 		/* Loopback device does not support hw timestamps. */
-		{ so_timestamping: SOF_TIMESTAMPING_RX_HARDWARE },
+		{ .so_timestamping = SOF_TIMESTAMPING_RX_HARDWARE },
 		{}
 	},
 	{
-		{ so_timestamping: SOF_TIMESTAMPING_SOFTWARE },
-		warn_on_fail : true
+		{ .so_timestamping = SOF_TIMESTAMPING_SOFTWARE },
+		.warn_on_fail = true
 	},
 	{
-		{ so_timestamping: SOF_TIMESTAMPING_RX_SOFTWARE
+		{ .so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE
 			| SOF_TIMESTAMPING_RX_HARDWARE },
 		{}
 	},
 	{
-		{ so_timestamping: SOF_TIMESTAMPING_SOFTWARE
+		{ .so_timestamping = SOF_TIMESTAMPING_SOFTWARE
 			| SOF_TIMESTAMPING_RX_SOFTWARE },
-		{ swtstamp: true }
+		{ .swtstamp = true }
 	},
 	{
-		{ so_timestamp: 1, so_timestamping: SOF_TIMESTAMPING_SOFTWARE
+		{ .so_timestamp = 1, .so_timestamping = SOF_TIMESTAMPING_SOFTWARE
 			| SOF_TIMESTAMPING_RX_SOFTWARE },
-		{ tstamp: true, swtstamp: true }
+		{ .tstamp = true, .swtstamp = true }
 	},
 };
 
-- 
2.27.0.212.ge8ba1cc988-goog

