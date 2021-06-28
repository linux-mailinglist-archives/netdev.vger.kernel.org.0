Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3980E3B5F68
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhF1Nwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhF1Nwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:52:44 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85896C061760;
        Mon, 28 Jun 2021 06:50:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 65so9985058qko.5;
        Mon, 28 Jun 2021 06:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgGEFkMArwto/hguJ5jTwXsSU4L7A/FJ08JPCBZFdjo=;
        b=QplwyV5rzaOnfqkvF1RDY68wW2yI1YFYhMRcU7pWOqgNs/N/bZvgTUibr8EterCWA4
         Ekg4bqUy8nZitFIyD419HvXNIRp46zq4M5rpXAU1sTVnIHOB/jZcNETK1LaVya0ndlz/
         2jURLQCARDMBzkUm73devoFH3rv3GVs0S9EuwybXuNTlIkt9SjGd5YnIcQ8p1zQ5C4WA
         tHGfcXJdoX8RM98TqBtqr4tQAM+TmEZ1uZHacFdNgH27MCoKwYMmfQ6XmMcXb6OULz9i
         3v5uvBtUZPWB6F0S9ahtFlX2goc73mwKRU5f6BJSq6pyCNLIN/hOL5tlTDzI+fma8VN+
         x5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgGEFkMArwto/hguJ5jTwXsSU4L7A/FJ08JPCBZFdjo=;
        b=te+7dZ2Oe1NaC50X1ojoarY4fP7S0U2KwAH3q5AVzZEAT83B85s2rqCxJYKiLo6rQR
         HwZlV/cYvDtpaO3AdiWprn3+1gOLwBFS3QA/iLBKlLizmH63srKror/4WMArd/YyNYox
         rOEHolKV+P43Pimg+YmjJTuJtsh8v7gMtR3Ru6a7BpW0HErfpr7fwl9sDfsh3CRxTpGY
         uEqq6xQDifJIisEx3XzLEbmPi/rKaBYBtrJ/wbEY2YW6/tcfBejDu4KZMIHDGrodq8DR
         odrOulEsPnHLIZy2DbZxJFIXqkRx42fB+y80BQaXgM5NhWKI91Dt++YNNyUBfxbxiUSX
         ijbw==
X-Gm-Message-State: AOAM532SDzDzBQsZ0SRGWRpmlbFvU4lDvjjqx2Nn5ituExgAe0y1KMR8
        wuRs93+Vs9kyk2rGYuxZ29QxadUxLgo=
X-Google-Smtp-Source: ABdhPJzmqYPGHZdApMOX5+0nI7tsbDj4KOUWei4oAqv0gB0IybDgSBjUSm8hGAP3XRTJk4pw3udWYg==
X-Received: by 2002:a37:b8b:: with SMTP id 133mr8863456qkl.44.1624888213665;
        Mon, 28 Jun 2021 06:50:13 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:8502:d4aa:337:d4d])
        by smtp.gmail.com with ESMTPSA id f19sm10760518qkg.70.2021.06.28.06.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 06:50:13 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v3 2/2] net: update netdev_rx_csum_fault() print dump only once
Date:   Mon, 28 Jun 2021 09:50:07 -0400
Message-Id: <20210628135007.1358909-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
References: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Printing this stack dump multiple times does not provide additional
useful information, and consumes time in the data path. Printing once
is sufficient.

Changes
  v2: Format indentation properly

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/core/dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 991d09b67bd9..d609366da95c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -148,6 +148,7 @@
 #include <net/devlink.h>
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
+#include <linux/once_lite.h>
 
 #include "net-sysfs.h"
 
@@ -3487,13 +3488,16 @@ EXPORT_SYMBOL(__skb_gso_segment);
 
 /* Take action when hardware reception checksum errors are detected. */
 #ifdef CONFIG_BUG
+static void do_netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
+{
+	pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
+	skb_dump(KERN_ERR, skb, true);
+	dump_stack();
+}
+
 void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
 {
-	if (net_ratelimit()) {
-		pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
-		skb_dump(KERN_ERR, skb, true);
-		dump_stack();
-	}
+	DO_ONCE_LITE(do_netdev_rx_csum_fault, dev, skb);
 }
 EXPORT_SYMBOL(netdev_rx_csum_fault);
 #endif
-- 
2.32.0.93.g670b81a890-goog

