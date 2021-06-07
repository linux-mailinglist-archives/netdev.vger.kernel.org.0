Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED4A39E6D5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhFGStH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGStH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:49:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B74C061766;
        Mon,  7 Jun 2021 11:47:00 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id o8so23635148ljp.0;
        Mon, 07 Jun 2021 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RnVSYa8KmSC+D4hybHKk0N49dZJgKOnqAO4kqqQejg4=;
        b=iUk1eWS24K6tQyGg/c7OF9rrUprxfqed1/+TJ4wlWwyrdr862kG/xi5D/UFutwfYzj
         oYCK5udNGILB87uB4QfbKOIWjeq2yrISMF3NtEdyNz7l//IOeWDNFbPATWBBhsXfgx3D
         euuZxcqU0bKQgM2C2mQ6Zu+z/YR8ngbCN23KhzUgVIWnua5zydZhbh+zVjJ2ptfSWGCN
         PoE4ErhAqsCb9GUjHHAZfzXDg2zwyT7ur5mnuo5dkd8pXBhFcl5ZfVOYfxcM8q80ZqGX
         tzT4gssII4BUOookNlCc0hbF2MIBavz3GBCESX+V1viC3WY1OIR/vDniczcz9WeaAVli
         H8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnVSYa8KmSC+D4hybHKk0N49dZJgKOnqAO4kqqQejg4=;
        b=B/0r+1ERotv7L5n+rtJAuT3sCDZScR6UpBgR4niBX2+/O9klI8gMzbLwietVA2D7K3
         B9RmxGDDhyZadIhX34CBjJVr12X+yxJNXFy1YUUTSqcWhr7no4HjJjT3ULLvKz3ayPU7
         0KNg3qNcOOrw6q9EX+HEhCN5jtSDowaDaO118I+uR8uJv5tKnRYRowpN5JfJXpt3JDbW
         iw3VNs9tUKL0kYKeULSlInLEXlpY0ZiNAJiMeLYfsHuk11MRkS78x6LKg0DXybZHRLbL
         ArZ2siFOliZkxiOlQX/sdw9FzxkhbBs7c11pT8RHRURWt1TK88bicgF7Nzex4+rpdAMV
         U7FQ==
X-Gm-Message-State: AOAM533yijdamRn+s0XjYXeHIxdlN1fxZSDnQfb6sMKLnm9PWU/IKl9+
        5HOTWNIp00xI9+nsYN1Cq8I=
X-Google-Smtp-Source: ABdhPJy5hxakMNChRHCPYJLBM9n75f4qTZnN+Sh4MwyJV+PnHFrP73qK/cUoYhh92y9MkTp+CxnbhQ==
X-Received: by 2002:a2e:a612:: with SMTP id v18mr6541693ljp.358.1623091618494;
        Mon, 07 Jun 2021 11:46:58 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id y26sm1583098lfj.298.2021.06.07.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 11:46:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Subject: [PATCH v2] revert "net: kcm: fix memory leak in kcm_sendmsg"
Date:   Mon,  7 Jun 2021 21:46:23 +0300
Message-Id: <20210607184623.6914-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210607172015.19265-1-paskripkin@gmail.com>
References: <20210607172015.19265-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c47cc304990a ("net: kcm: fix memory leak in kcm_sendmsg")
I misunderstood the root case of the memory leak and came up with
completely broken fix.

So, simply revert this commit to avoid GPF reported by
syzbot.

Im so sorry for this situation.

Fixes: c47cc304990a ("net: kcm: fix memory leak in kcm_sendmsg")
Reported-by: syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Added Fixes tag
	Improved commit message

---
 net/kcm/kcmsock.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1c572c8daced..6201965bd822 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1066,11 +1066,6 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto partial_message;
 	}
 
-	if (skb_has_frag_list(head)) {
-		kfree_skb_list(skb_shinfo(head)->frag_list);
-		skb_shinfo(head)->frag_list = NULL;
-	}
-
 	if (head != kcm->seq_skb)
 		kfree_skb(head);
 
-- 
2.31.1

