Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0CD1A95D
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEKUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 16:16:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38159 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfEKUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 16:16:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id f2so10310792wmj.3
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 13:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=me4URjANaOIl3VpDy3HEOCBvfiAoVOwXVY6rPvwl+Mw=;
        b=QRBLKxkp03F8iQm+bL/RxTytnuOhCQ0oDwK0Bq2Q79GW+2MIVewEMv64CqzziXO+D4
         E53IEmWsO+kCCVRxBhYS1ydStrV1Y2rVOpoQn8aeZS5LbbdXhOxXWjveOg5aiUflzXSl
         C9qOHELCsWVfVWg1f7cYMvUjfgaeUVAPliMwEIvWRsHQOKisoVeTnXUIIw+oatggsXFe
         lSABSJruucpC/dKU3dYvXbMdBmfexPUyrZLjyvHcLtYw+eernF41nVuTuJ4dvtXxwvzv
         O76Szn3EuQKuWznLuq3EB/94RfQkM0YH2LGjsSN4Z+i28XJGUX6ucG6vcBvyI4lHeort
         PQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=me4URjANaOIl3VpDy3HEOCBvfiAoVOwXVY6rPvwl+Mw=;
        b=W8HcwhadDBeq4zZdXiYouqIW+r7T1QesiAhXdIH6BcIMJTiDvwJ+QsUbZNyYgfIZig
         htdC9i8W6Hjn7fI+axb2FojTixqdHkyRgP2m5UKuw+sQ/tFKeY1Q1XNjnvLH4hC4kkS9
         BBmt5dLSWf4N3pph3mt/e97kZG70M9mN/fNaeuu+Ih0VWqAwRJe6StLOa+0cFYD4VIPW
         Uz4iPubBF//nZvFtjXqeSfEcXOLs6l0TLvbYo5kzzPUafx16ByRkuShJYs69sSbFWAEo
         CyRVLAxJGs3gIH5iQQVwf/BvUHBibvKxtThTOabeyIQgsIPF8xwITDXDSEeg2knc/Lhk
         gvHg==
X-Gm-Message-State: APjAAAW8b0FCQvvzKeuElHsFMueXr/j8deDEYyMv+Xr1bGvZBhg5YvmM
        rs45AypFwb1y+dar7mQrjXu4+6rL
X-Google-Smtp-Source: APXvYqyMunYPnz65A3mxXwR9bFC2SpUSLOj66GxnGJfzfdby13RJTKQ91CBAOuGw6Lh0CHPFKiy/hA==
X-Received: by 2002:a1c:741a:: with SMTP id p26mr11000709wmc.38.1557605771940;
        Sat, 11 May 2019 13:16:11 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id c20sm11853275wre.28.2019.05.11.13.16.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 13:16:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 3/3] net: dsa: Remove the now unused DSA_SKB_CB_COPY() macro
Date:   Sat, 11 May 2019 23:14:47 +0300
Message-Id: <20190511201447.15662-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190511201447.15662-1-olteanv@gmail.com>
References: <20190511201447.15662-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's best to not expose this, due to the performance hit it may cause
when calling it.

Fixes: b68b0dd0fb2d ("net: dsa: Keep private info in the skb->cb")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1f6b8608b0b7..685294817712 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -99,9 +99,6 @@ struct __dsa_skb_cb {
 
 #define DSA_SKB_CB(skb) ((struct dsa_skb_cb *)((skb)->cb))
 
-#define DSA_SKB_CB_COPY(nskb, skb)		\
-	{ *__DSA_SKB_CB(nskb) = *__DSA_SKB_CB(skb); }
-
 #define DSA_SKB_CB_PRIV(skb)			\
 	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
 
-- 
2.17.1

