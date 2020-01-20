Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C8C142338
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 07:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgATGZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 01:25:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44569 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgATGZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 01:25:16 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so972107plo.11;
        Sun, 19 Jan 2020 22:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d5Eadt8gafPSmu+6ZZhsajj1XzECvvpLFOHL6bzhCvE=;
        b=pd4TtqZa/TDq8H3rhUA/D8jxwFSwuZExZvB8kkCdh5lhqZXXL2nRS0NhKqcPVbG7Jt
         Zw6lwxNQk0yz08JBh4GTRgxoj4kLhOxtr82oi2ySUU/kp0UbIraA820X9KHLL1KmlKDd
         T4rcLeRc82gc+JNjfMOLh6IsFtqVz1f2ihQOs5IrQsVclUyg+EO+9tuufaP7W5ZAJG4U
         nC3qJOnbrSy42PFPbYlEM2mKPEqggdorRt/Zjq648gy8bi8z+hAfJ9PNHwGfDiSGHFPO
         61E1MX/zP/3WvDgF+rCw9GhAIQCAyJb10ws4WXQY6NIJri+elG2UxVHgTQToRxGL96To
         zytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d5Eadt8gafPSmu+6ZZhsajj1XzECvvpLFOHL6bzhCvE=;
        b=i5/ltK6NxnmeHti9RXit+4fzlcFet6Z2ciBF5O4dF9yBhNHGqZ7AbX6r6Enz5pKqeZ
         bTYXPb1MRKmDQ/Bt0PJ3eM4iSnVwqNuEv84jrBmsp9P50eks9A6uGHff1joUOk5wcrwJ
         4kZr6nLJaTEuXiJDa2soGtV4QfSjvYwWj9sk8n47tUDt1i0T7KcTJmsb1ItBBNJYS0as
         udnOar5i6UxmvijxjDIhg543xjgOZUjXhL7Sd1fDfdlr5zLCmaXPY6uVrsakPuM7APk4
         SWVgfCdz/reCirJWzuXYIw/IrkjkGXsBjxauInhU5q1tTNx4vOzkEn684fF7c5NXaZJ/
         7xmQ==
X-Gm-Message-State: APjAAAWtEFYECUFFz1vxXDALpdN+Fzk89WwmAOYqdLgKKSsZouQf7IRm
        oK5W+IG+HDtYeFXFwaMk7V4=
X-Google-Smtp-Source: APXvYqyeX89XTVd/d48tgvN0KQjBvCDz09xOQlNHI8Ziia3LWmsq2gBwr1g8Md4IXPLClvRlhcYfWQ==
X-Received: by 2002:a17:902:8a91:: with SMTP id p17mr12598108plo.75.1579501516231;
        Sun, 19 Jan 2020 22:25:16 -0800 (PST)
Received: from ZB-PF11LQ25.360buyad.local ([103.90.76.242])
        by smtp.gmail.com with ESMTPSA id hg11sm7758425pjb.14.2020.01.19.22.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 22:25:15 -0800 (PST)
From:   "xiaofeng.yan" <xiaofeng.yan2012@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ap420073@gmail.com
Cc:     xiaofeng.yan2012@gmail.com, yanxiaofeng7@jd.com
Subject: [PATCH v2] hsr: Fix a compilation error
Date:   Mon, 20 Jan 2020 14:26:39 +0800
Message-Id: <20200120062639.3074-1-xiaofeng.yan2012@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "xiaofeng.yan" <yanxiaofeng7@jd.com>

A compliation error happen when building branch 5.5-rc7

In file included from net/hsr/hsr_main.c:12:0:
net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
 static inline void void hsr_debugfs_rename(struct net_device *dev)

So Removed one void.

Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>
Acked-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index d40de84..754d84b 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -191,7 +191,7 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 void hsr_debugfs_create_root(void);
 void hsr_debugfs_remove_root(void);
 #else
-static inline void void hsr_debugfs_rename(struct net_device *dev)
+static inline void hsr_debugfs_rename(struct net_device *dev)
 {
 }
 static inline void hsr_debugfs_init(struct hsr_priv *priv,
-- 
1.8.3.1

