Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB171FE9AB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgFRDxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:39 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E44C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:38 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y2so3183651qvp.1
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SDeYkckQM2DOazZCNWpIB/WKaZkfa+VmdFmYqfni9L0=;
        b=hBlupq8g+heYwTYC5YH+F6gyIUzxckeUJnMkYnxhMDuPB+t6nn29XWTWSdKSz4IR5H
         rtgmtAzWMAdQbqD3e5MMRSana8n24koa3mbi021Xy8fcYnvBLh7BvLhXgVWzVs9Oxfrf
         adsqcj9WZEP6eZcHvl4PiN1IAQkUUZcJrOY+YW/Bm4BW+wnfFq7G0et9jDi4HYDf5BnN
         ChPAR1aG6MBvoHeJ4YY4HIdw5Qt8MzxC9m4rTkDVrVaiZBvXtpl3gR4mRJ1GjFY0lL3l
         w/CNM8V3r8YoMRDCJAZ0DHUuVJufYLzF/D6X+NLHbNXMl07MhqfvP594O+KG0BDQe4qI
         Yihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SDeYkckQM2DOazZCNWpIB/WKaZkfa+VmdFmYqfni9L0=;
        b=Rti5RSPtpAoq99ebgkmJQCTlwSJW0zM8+1ZEUHMBYThKrMts7J+plThOxQxhM2/rT6
         lNN0N+riFOMd40I11mK7x8oDTr0kRIhmi6gJZXENyaC8HJi9sSi1L9+C/TkEYwZU8EeS
         hdfaYqYiDB+sAWSRSGfW/rKTnPdGU4gN8nguQ9cI91Ue2i70lpfw3Q96ZSLWzH1unHXi
         9r5crLhq/BbdFWoYC6ZKV+gf18n+c1OgHjUQyGvj4wLo6xUspOSnEBpfms35cMvnkgjK
         xgEukVLnJiH/v1nzfU1hEKMj0Ndf+tX3w5/neneYsncj/+bvUeLFnG+XLI9T061J8Z3Q
         uU1A==
X-Gm-Message-State: AOAM531feOhWXL+i5JVzipkzvXAwM+x25sYtJbUacrZ1hebb57yOMPfF
        hlogSzuwQu8Ml4EdP2Mzz0viC9I1Kw9l4Q==
X-Google-Smtp-Source: ABdhPJxfKGpYtfgRZkmcHdDZSEcu7NBd5Lx3Jfnv3nBWzhe9vuJ0IXtGNaAiog5cOd1OoeWVa+hA9HcaswBzlw==
X-Received: by 2002:a0c:e9cd:: with SMTP id q13mr1891853qvo.23.1592452416867;
 Wed, 17 Jun 2020 20:53:36 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:23 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 3/6] net: tso: shrink struct tso_t
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

size field can be an int, no need for size_t

Removes a 32bit hole on 64bit kernels.

And align fields for better readability.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tso.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index c33dd00c161f7a6aa65f586b0ceede46af2e8730..d9b0a14b2a57b388ae4518fc63497ffd600b8887 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -7,12 +7,12 @@
 #define TSO_HEADER_SIZE		256
 
 struct tso_t {
-	int next_frag_idx;
-	void *data;
-	size_t size;
-	u16 ip_id;
-	bool ipv6;
-	u32 tcp_seq;
+	int	next_frag_idx;
+	int	size;
+	void	*data;
+	u16	ip_id;
+	bool	ipv6;
+	u32	tcp_seq;
 };
 
 int tso_count_descs(struct sk_buff *skb);
-- 
2.27.0.290.gba653c62da-goog

