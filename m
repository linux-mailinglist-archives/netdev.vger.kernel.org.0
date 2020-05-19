Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4581DA4FC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgESWuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgESWuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:50:15 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F299C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:50:15 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 14so1697569qkv.16
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wQt9xodIBscv+XDZRF4BVYbY0dqcZkbWiYM37rY6iUA=;
        b=TlRUIyolSFHWQG5Wj8KWLzTA3MWhp/wF35Tzc2g7eI1KEvpuvtFYbiCgW5E6FkCY/2
         JhHJXX51KaPMB4Br8MdGztjPF8beJ2Yw7sD+Hw8BHAxx7f62XTUEwg9A+yfL8rrAOX7Q
         LSlX0TfZvBvOJhVu0CCMzbcvJc2SgZqtNv2hVSR27n1gDglb+p0a6fJxrmZtRN60tGw/
         bpgj8AaTKzjWpWz0KbS4fDu3b6WnK9N3YqwM9nOm5TwXJsbBXyFeHiQfGa2K5WwU8XY2
         bX+3xBCWaWbPQJ7h2LxiDJXY5XK+p2SIrpkHxUp2sSl/FKv7STXpQUWszcLYv1yhQ9pP
         R+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wQt9xodIBscv+XDZRF4BVYbY0dqcZkbWiYM37rY6iUA=;
        b=OQbI54q43HnDsML2p/sLYnLlnObo0toQNrC4v7Hn+bxnuUIq+oxcAw29O/UTTImYX/
         o3+Sa/z8QhvqDYJFvHdi/lwxVKD8q5pRmfvumd7nR/d0UbdgAgIMOWSfbaFKu3iockHS
         DWP6HCwhLvxN04puoAQhMrePVMPvFWZABUcYJVLSraccpc+lDGyaHMr1d+gju5DYFmYb
         mk2q/hn2WKTmXSy4NZdrV4KhFDmeGXGNGcBrLUV3aSh3330TqDFj4kuKctYSUwVpZJ0F
         MMM1c3xDLAfDZicaOsPxvyhoUvVl4yRdVvJBIbeoisgjIpRufLG6sqWreE3ijUiRxX+o
         Rfeg==
X-Gm-Message-State: AOAM531aJR3myBy+3sdvNC8iVDlCCy3wx3SH/0bvuGJMYDPOxsje5Ycw
        kIc0ntTQoNh3BDZbtvjjJe7kyky3Ka8bMw==
X-Google-Smtp-Source: ABdhPJwaH8qNHLlOv4U6FX4LYeB5IUK24KrCgmRZbmZyKHXlKNPO78cE1tLh3OS2BjCWBP0BgAm6nTuye7OryQ==
X-Received: by 2002:a25:7901:: with SMTP id u1mr2707569ybc.301.1589928614353;
 Tue, 19 May 2020 15:50:14 -0700 (PDT)
Date:   Tue, 19 May 2020 15:50:12 -0700
Message-Id: <20200519225012.159597-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH net] net: unexport skb_gro_receive()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_gro_receive() used to be used by SCTP, it is no longer the case.

skb_gro_receive_list() is in the same category : never used from modules.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7e29590482ce509ea1d3b2306f4796f697b76d4f..4dd13e9b92d61e44ec4cda95fa64f72dcc5f6a71 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3727,7 +3727,6 @@ int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(skb_gro_receive_list);
 
 /**
  *	skb_segment - Perform protocol segmentation on skb.
@@ -4191,7 +4190,6 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->same_flow = 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(skb_gro_receive);
 
 #ifdef CONFIG_SKB_EXTENSIONS
 #define SKB_EXT_ALIGN_VALUE	8
-- 
2.26.2.761.g0e0b3e54be-goog

