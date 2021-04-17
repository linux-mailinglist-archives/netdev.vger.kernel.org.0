Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BDE362C44
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhDQAJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhDQAJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 20:09:12 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10864C061574;
        Fri, 16 Apr 2021 17:08:46 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id k18so24641465oik.1;
        Fri, 16 Apr 2021 17:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l+SBgGodGdq7Avc2jggMLnF2zV3Ob0afS8608XVNpnw=;
        b=X26QAbdeJzDMr4hktMfF9kTny7p9YNbmXTueSTq0SXht1I3YmMlxDGzfy2OoIcpt04
         WEp++OLYgzjNRP+DkEWERKyELwA0AynhvBM67f4ciMUlQ9HjrO0M0cmMMxhRri1NX+5H
         nAWv4ZeqLw7LpV7m1PAdwTOabPcySmhQDKU+TXcIt7zmG+7ueDcLMe1nnDonR8M6dXY2
         hWbUvY9LLAhbXF5UQavH4NYMBAeHFfAvHuk97aU0Sr5x+WoKJVxF3DHqmgrtJYDAjWwm
         MeoJ3WzHucYu4OMxYqhgIipsoavdpFiI7OngFlE9dLD4/kO95JCdgZWqbLfVQujBNiMs
         DCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l+SBgGodGdq7Avc2jggMLnF2zV3Ob0afS8608XVNpnw=;
        b=oDuqI0qjkelXDNX3wuBr9+TwMPf3q5RS+/B0Ew0xquCtXtLY73FUMmLqtYw2sUQ8Vg
         tMPkmH+oRjdczT7GnckvRHqRRquKHirHFbw7/+G9FaBqEW+4ZGpPA543OjvDqyw2fKPE
         Rm403lz1qxEE+It2qhf8HcfUE5SvOUWMtF0oLttEUZshfEmynDPt3/q4ac7IuW3fIxNN
         lfL01MgHjG0ej9d9afcqQ3BF1AEYQn+U8vknjxt+tdjHYf/GP3EvtcYz6RQSUOYLB4AR
         BSfRJgIXf+LfEtfEMoH9VEujzaNlR+rNTVuZYNHFrvQgWapnP8OGsUof3uEsRN8AB94l
         q8zQ==
X-Gm-Message-State: AOAM5332HtnoVqlysFETI65393f/kFxRJ+TGTa2GG+s3RdfJGenrDlNx
        TYPPOZ+pHrA7wCnrjZHXsmM=
X-Google-Smtp-Source: ABdhPJz6ulZHPqYgcA72j40r5a/JKii+fnmlAoNA9VjfIor3LYVdBlZRvtOpxPSJbzpH/hcWRuG8zQ==
X-Received: by 2002:a05:6808:28b:: with SMTP id z11mr8509958oic.3.1618618125077;
        Fri, 16 Apr 2021 17:08:45 -0700 (PDT)
Received: from shane-XPS-13-9380.attlocal.net ([2600:1700:4ca1:ade0:7fc9:3f8c:9a56:c021])
        by smtp.gmail.com with ESMTPSA id l203sm1713585oig.41.2021.04.16.17.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 17:08:44 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Slaby <jslaby@suse.cz>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH net] net/core/dev.c: Ensure pfmemalloc skbs are correctly handled when receiving
Date:   Fri, 16 Apr 2021 17:08:38 -0700
Message-Id: <20210417000839.6618-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an skb is allocated by "__netdev_alloc_skb" in "net/core/skbuff.c",
if "sk_memalloc_socks()" is true, and if there's not sufficient memory,
the skb would be allocated using emergency memory reserves. This kind of
skbs are called pfmemalloc skbs.

pfmemalloc skbs must be specially handled in "net/core/dev.c" when
receiving. They must NOT be delivered to the target protocol if
"skb_pfmemalloc_protocol(skb)" is false.

However, if, after a pfmemalloc skb is allocated and before it reaches
the code in "__netif_receive_skb", "sk_memalloc_socks()" becomes false,
then the skb will be handled by "__netif_receive_skb" as a normal skb.
This causes the skb to be delivered to the target protocol even if
"skb_pfmemalloc_protocol(skb)" is false.

This patch fixes this problem by ensuring all pfmemalloc skbs are handled
by "__netif_receive_skb" as pfmemalloc skbs.

"__netif_receive_skb_list" has the same problem as "__netif_receive_skb".
This patch also fixes it.

Fixes: b4b9e3558508 ("netvm: set PF_MEMALLOC as appropriate during SKB processing")
Cc: Mel Gorman <mgorman@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f79b9aa9a3f..3e6b7879daef 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5479,7 +5479,7 @@ static int __netif_receive_skb(struct sk_buff *skb)
 {
 	int ret;
 
-	if (sk_memalloc_socks() && skb_pfmemalloc(skb)) {
+	if (skb_pfmemalloc(skb)) {
 		unsigned int noreclaim_flag;
 
 		/*
@@ -5507,7 +5507,7 @@ static void __netif_receive_skb_list(struct list_head *head)
 	bool pfmemalloc = false; /* Is current sublist PF_MEMALLOC? */
 
 	list_for_each_entry_safe(skb, next, head, list) {
-		if ((sk_memalloc_socks() && skb_pfmemalloc(skb)) != pfmemalloc) {
+		if (skb_pfmemalloc(skb) != pfmemalloc) {
 			struct list_head sublist;
 
 			/* Handle the previous sublist */
-- 
2.27.0

