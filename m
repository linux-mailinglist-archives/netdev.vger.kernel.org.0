Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3526C14989F
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 04:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAZD7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 22:59:23 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33164 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgAZD7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 22:59:23 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so2477099plb.0;
        Sat, 25 Jan 2020 19:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RuJpjVfRtmd6PBmsFbM+f7LVOKZDRhAzmDczWQcb+9w=;
        b=TUfvWKI5NBhNGh9WPdEDenZBKQQQdQCy2ky3j1mifZzMBngl+BMOqKmWpPpI9Mybnj
         J7fcHe/QgTwFgHN2hwmozTfPWgP44POVkrE/hkCDfRohfxBngrXfNlR9XnVLCYUaIC9N
         ReAXtknX/+RPT4Ehej6YiEc9q8g6ga1817HAQHL39oljPr9S4u/32171dhSOiXWPnIrC
         xqXVU4h6h2v141CuuaOw3QJDf7UXgwU1iI10sTPH7Edmh1vao0buQZPJaGZ9vjy6JbIF
         omUDm+94w1uG97Q4B3zi9OY8hQvllI/GpxXnGublk0v4ZU4sZgIdL+nBbdOayVbgK7tR
         l/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RuJpjVfRtmd6PBmsFbM+f7LVOKZDRhAzmDczWQcb+9w=;
        b=BtMFjXEYsXSJ4El0Ts2FEjXDCOpGMCn8IHjVVfsPwP7jONKKAvXMWcAVdhhG2avxcs
         AcR9jxroxOdMrf1sdeuFIP0LVq6qXNyyaRTULtWx7/KukfYfTxsHWlsiXU8Pqw4nVwQb
         gsA7YJebg4c+4BWf+7CgLTodnd3pbmMPvJm0cwhjlPh0nteva2Icmy9PDrMyZB4aNaK1
         OQY5XqTn40YXnZ4WNe4xwzokkoKntc7P47V8RnJbKOl6UXq58ZaOSJZfkJ5aNHNNhwrS
         +yqwdGcPHh86COLEr9+38pgjW/+g+jl1DGYAH6hS5MEHNJol6kbCNq9NY/fjMpsaBtGO
         S7eg==
X-Gm-Message-State: APjAAAVKmMZAbwPTHuAclancMwpv28yTRicIt9XJHV6cur9/TLs3LF0f
        +LSPEipOT1EJO84dMzrWZdZZeleh
X-Google-Smtp-Source: APXvYqxuev402Y4Q6hYmF62LKOFfZzlnuXv8B87c3b4eL1Hz87XSk3E2yyYwE3ia+ZttSNfe5if8YA==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr11787996plp.324.1580011162479;
        Sat, 25 Jan 2020 19:59:22 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 64sm11078650pfd.48.2020.01.25.19.59.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 25 Jan 2020 19:59:22 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 1/3] bpf: xdp, update devmap comments to reflect napi/rcu usage
Date:   Sat, 25 Jan 2020 19:58:51 -0800
Message-Id: <1580011133-17784-2-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
References: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we rely on synchronize_rcu and call_rcu waiting to
exit perempt-disable regions (NAPI) lets update the comments
to reflect this.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/devmap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index da9c832..f0bf525 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -193,10 +193,12 @@ static void dev_map_free(struct bpf_map *map)
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete. The rcu critical section only guarantees
-	 * no further reads against netdev_map. It does __not__ ensure pending
-	 * flush operations (if any) are complete.
+	 * disconnected from events. The following synchronize_rcu() guarantees
+	 * both rcu read critical sections complete and waits for
+	 * preempt-disable regions (NAPI being the relavent context here) so we
+	 * are certain there will be no further reads against the netdev_map and
+	 * all flush operations are complete. Flush operations can only be done
+	 * from NAPI context for this reason.
 	 */
 
 	spin_lock(&dev_map_lock);
@@ -498,12 +500,11 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
 		return -EINVAL;
 
 	/* Use call_rcu() here to ensure any rcu critical sections have
-	 * completed, but this does not guarantee a flush has happened
-	 * yet. Because driver side rcu_read_lock/unlock only protects the
-	 * running XDP program. However, for pending flush operations the
-	 * dev and ctx are stored in another per cpu map. And additionally,
-	 * the driver tear down ensures all soft irqs are complete before
-	 * removing the net device in the case of dev_put equals zero.
+	 * completed as well as any flush operations because call_rcu
+	 * will wait for preempt-disable region to complete, NAPI in this
+	 * context.  And additionally, the driver tear down ensures all
+	 * soft irqs are complete before removing the net device in the
+	 * case of dev_put equals zero.
 	 */
 	old_dev = xchg(&dtab->netdev_map[k], NULL);
 	if (old_dev)
-- 
2.7.4

