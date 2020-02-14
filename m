Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC115F80C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389390AbgBNUtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:13 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34676 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389261AbgBNUtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id n10so10520928wrm.1;
        Fri, 14 Feb 2020 12:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zokGFmAQnm/AR6cG+S2XrobvXP1EFlLQZdpuCKio4jQ=;
        b=Lw4tti9xRk8JkoGG5TkFM+3GVDA+Hs/nJVQ0QLEq6GNCHfOgD/m+pdKocFQ9N9JPs1
         cDzD2ViHTBbAYiJ6mUJMzeYdfQLeKulhWIzulJ6Si5ifzKDE0AT9E9S56PwqH2hPbsOO
         7qd4Z1ZC/vClCtHAv5YxP69YbyngFpkeNphiUKi5ped/4i1KY/TOGnhgBAebfH8NKMkK
         Mxye4gCG5hDoB08qUIYIONrP+ndkN8pfe6dZuhx6AU8k5O5bttu5JBxiBRtElTi606Wy
         tTp+ZfxIuP8v4sz16wHfh5j1hZzZQp0TVRPlKkaL0tOUCTsOeVn7RiyivE+tHyoIy3Z4
         G94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zokGFmAQnm/AR6cG+S2XrobvXP1EFlLQZdpuCKio4jQ=;
        b=LWOVd7GlYSxxqM0icyzp1FVLq4X1pw58TY1aSx3nhlNTOzlX2nwutNTNc2pBkHTVrD
         OkOK0zWGoEVyrXktlFEEsvbYuWQksj04EeMQefvEGYd+mZCzpih68RP4990/9XpYre9r
         dY5MHlM1udzzIJNFh5MC5UyYZMDCVu0fIpZ6/Iu5Evr4qsvGpKoIGOaE4Y6E5bL9o+ib
         JDdurl30TLQBCbGcDVhliITplVxXFOu31Y9nUMyQWWzRXl5z2OFHak6Q68l4ilUQfSFC
         JxLX6bz7mP2BYG7uWBl3yzWVy6JurPCfkMe3Nb0d8uOXTf9CcC6F0yiAL1onOs6IO/aI
         R9pQ==
X-Gm-Message-State: APjAAAUmZbX1vEFAUu8bTUrdCo3jZAbxReW+aKQFypgHq7vJWm56UjE2
        RoYO4W3PWlQtTDkKZHmHHwdUaA/KRpDn
X-Google-Smtp-Source: APXvYqzLgpp/QKTGfIyFd6Dn18j27VDyJT0VjPC+uNJm4uZUYJas215kLN3BotUyZmh8IsKtbFJOxQ==
X-Received: by 2002:adf:f103:: with SMTP id r3mr5807536wro.295.1581713349761;
        Fri, 14 Feb 2020 12:49:09 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:49:09 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Patrick Talbert <ptalbert@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Li RongQing <lirongqing@baidu.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 30/30] net: Add missing annotation for netlink_walk_stop()
Date:   Fri, 14 Feb 2020 20:47:41 +0000
Message-Id: <20200214204741.94112-31-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at netlink_walk_stop()

warning: context imbalance in netlink_walk_stop()
	 - unexpected unlock

The root cause is the missing annotation at netlink_walk_stop()
A close look at rhashtable_walk_stop()
shows that an __releases(RCU) is needed here
Add the missing __releases(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a3fddc845538..7a287dc73f63 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2545,7 +2545,7 @@ static void netlink_walk_start(struct nl_seq_iter *iter) __acquires(RCU)
 	rhashtable_walk_start(&iter->hti);
 }
 
-static void netlink_walk_stop(struct nl_seq_iter *iter)
+static void netlink_walk_stop(struct nl_seq_iter *iter) __releases(RCU)
 {
 	rhashtable_walk_stop(&iter->hti);
 	rhashtable_walk_exit(&iter->hti);
-- 
2.24.1

