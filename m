Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18D1CF22D
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfJHFfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:35:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43037 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJHFfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:35:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id a2so10119193pfo.10
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ykroU922u8YwCK1ILzYKVRvy0yOrLZY+XxHnLXIbfI=;
        b=t9vOsUlGNjUjiKVf4cHrS0oXSs5RTOQwtGelXeIQSx32pkZ1G9QZhhYiOMKCuwXUZM
         JqwQneAAzWxLgX6wNSk757jBnceCQDOMMvcyCJg+IM8/chLeGIT3aYWnGKafgMm9FOEm
         UYVzYg6RL6NQq4aQvP33a1LBxkDizkWbCKQpAJGjeS0MSId7ouRzEC657bSj6XIwJ9Dh
         na+30hBIw2joDXxA0sIqacJX4pGNm5Ww10obTJeq/3bPKoP0/1Zyi5iI+DmJ1fLfd6QW
         953neOC/nrlCYVALUq0Qvh9lkQevftM7OiGyKu++UzSJMN9UsMqB4agz40vtN6FHS8Wz
         vGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ykroU922u8YwCK1ILzYKVRvy0yOrLZY+XxHnLXIbfI=;
        b=DFYll8XctFiOO4Oi1H3AVIJH0kLlCUBVj/z8vPwZ1TUIKhzdG4F15LDyvHzn7F9w3H
         eKCBn5rRLCzfB7JCFXSGftifWQ6cUa7p/BypxDMp1gnE00nSA8JRNTOLH/OOb3K87aRN
         ZLvv+ilT60GxKhqucthFJI9W/SQLqIhzZJy8z7wcX5A0XrzDheOiwXXMSek2J+Yt9Chy
         Hxf07Jnrful8ijTkF3TCiGlYe/UZV/VZyyEOpF9coKBrDp2rO78gKXRZy2RjUspQXkpy
         3CojXj0AjHGrk3umWbnipTp6qotTuXGuEOvLIpSrvqBzERL7OdXKH8YIbwTb8iEJlppy
         Qlvg==
X-Gm-Message-State: APjAAAWnWIxhHpo1Kp1oOtIoCUYf2elz1tGR+XjhWp5z8aMhuWqvqAxO
        zHGaumTZBJOH2ARsExVxocQ=
X-Google-Smtp-Source: APXvYqyA3u1j/qJ3UZwpPI4OCtudG8EAmkLVu3cRCZ+g1zwhjntTdEX3WIArlsi27Vokv6XUKU061g==
X-Received: by 2002:a63:5552:: with SMTP id f18mr24522196pgm.437.1570512946556;
        Mon, 07 Oct 2019 22:35:46 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id e9sm13806806pgs.86.2019.10.07.22.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 22:35:45 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
Date:   Mon,  7 Oct 2019 22:35:07 -0700
Message-Id: <20191008053507.252202-2-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
In-Reply-To: <20191008053507.252202-1-zenczykowski@gmail.com>
References: <20191008053507.252202-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reverts commit 114aa35d06d4920c537b72f9fa935de5dd205260.

By my understanding of kmemleak the reasoning for this patch
is incorrect.  If kmemleak couldn't handle rcu we'd have it
reporting leaks all over the place.  My belief is that this
was instead papering over a real leak.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/netfilter/nf_conntrack_extend.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index d4ed1e197921..fb208877338a 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -68,7 +68,6 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	rcu_read_unlock();
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
-	kmemleak_not_leak(old);
 	new = __krealloc(old, alloc, gfp);
 	if (!new)
 		return NULL;
-- 
2.23.0.581.g78d2f28ef7-goog

