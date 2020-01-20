Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4171421F5
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 04:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgATDZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 22:25:23 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47081 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgATDZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 22:25:22 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so12541191pll.13;
        Sun, 19 Jan 2020 19:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gGTltzfrdckJmMP0SmbR/3670dsenUvBc1hdDm8j+Co=;
        b=PlzVDVIVTYL+JvwV8Jivonm8IKSry0nGRLpyb41XKV64sw14IXqFXP0KBNUvAUasmh
         sH6hrK+/CndaAbTha23UoL6t4mg94f3dyLgm1wYq5MnfbNPt5RVhOd+DHoF/2FQ6uYd2
         PIL5rCiztacJ2sxELOkNZmdaIxcgrwxrIieV53Mmpn7MzoRZ96uJUBxITxWew+TpJ8Jv
         nF9EbTRrzV3phT6GGptkpVktkihXTGRcC92Vw5J/W6a76cv5AVmsKAxxs781FvyRsh7W
         /Oyqo+v4tu6se3dWBBK4DeLH1OdRB/Y9+X6SbHaj48PfIn5oL7umCuweerN3mXbK9juH
         dGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gGTltzfrdckJmMP0SmbR/3670dsenUvBc1hdDm8j+Co=;
        b=UPneMEwa+X8cIyYf6ODjS+PWyVaBjCvZadDg+HUYEefQk2Yvzlr4myLWd/M4QLVEmR
         8xtM4eS1qsKZ+BeaEMrYiK8sPGSLZUZQoI1NPPm2JzmdfKe1M3mIF4XH88KIOJikjjav
         V0cjng2yz4ULrTV6EvQnzturkcC/JI82B4/2duQ4rT0Kg2MmwU8jvHTl61sQsw0ZF0ij
         9kXLk6tH1AytHjU1XW8RIm3NdGCi7YUScHpLdd/fkoL/v+mFIiQFB+2WdwXcYdMHq+b9
         9eOi+jGRI13Rfn9QIJ9YWWQRVvZxJyonF5n/uz0Epjg+F7gQenMPpTL+NNC/xgmJM33G
         UZfw==
X-Gm-Message-State: APjAAAWG9frmB3cmqkjZgjtIB1C2HC09z/nPHpLDweshksyi/AU/mkkD
        it5QXqFTJ8kwLk6mTzh2ID0=
X-Google-Smtp-Source: APXvYqxkf/BUOusDpiYDUNsBIuxzh5pWYB7+AVHM5lunzVYC7OtQorC1S2H37IiMbr2g1HMudSsKIQ==
X-Received: by 2002:a17:902:bd96:: with SMTP id q22mr12244457pls.318.1579490722243;
        Sun, 19 Jan 2020 19:25:22 -0800 (PST)
Received: from ZB-PF11LQ25.360buyad.local ([103.90.76.242])
        by smtp.gmail.com with ESMTPSA id k44sm491901pjb.20.2020.01.19.19.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 19:25:21 -0800 (PST)
From:   "xiaofeng.yan" <xiaofeng.yan2012@gmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     xiaofeng.yan2012@gmail.com, yanxiaofeng7@jd.com
Subject: [PATCH] hsr: Fix a compilation error
Date:   Mon, 20 Jan 2020 11:26:39 +0800
Message-Id: <20200120032639.2963-1-xiaofeng.yan2012@gmail.com>
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

Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>
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

