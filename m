Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF32061E5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392941AbgFWUwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392909AbgFWUrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:47:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19759C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so115422wme.5
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTn4YwU+nfTQfkZuPTzGncuZ8rRbBocyqzX19b4wUbA=;
        b=TMhFhm6nfkpXmHPW+lhJe1n7cOAbgmdnyRnYRF08ge1eyJ2DV9spltmSVwZ4VSK4Wc
         Jt+Vztp07cBJUvd//XpdL7CXGrBp15sBWw5RyPDAs6+VDyhZ7be6kNhjp3hxaN0BI85b
         IjevMCed9DomHmDIsfcEaVrrUegwc59D4qWVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTn4YwU+nfTQfkZuPTzGncuZ8rRbBocyqzX19b4wUbA=;
        b=YqeVl/VY6f5jI1Fu9KXLP7gcmI2Dl3U+ZWxqSWZHWaHpPnhH6vNKUDCsmvGY84eJH7
         CLXYqS9+uOfRAuSesdm+YYWLHlTcM167XiAL6PbXBQSWgC8PKabCcy9qwdhKcoQbF7bN
         AnrsYUdzD7XEnrO/EjVD9svi4xWeLD4nJXrCazn0rWOneeQSc1kY2vrFex6yJq12DiGL
         JL+6ahb6Pyb2mOFZmuLKNu7h89pE+Y7GEvHZcrUoxX2jhaL3DoT8kNGMdkaPI1CJ6+IJ
         7wqRln3zQCrRwXtZiaKszkx4AxrZao+myN/CLFpNc+bL5T5B3GTRn2e0viFc79xevFuM
         2BKg==
X-Gm-Message-State: AOAM533hIEqiG7Wa2fhKGEz81YDWsD+Aq7Le9BLxSjdBNFdixNQEpeXP
        9+1LRN2pyO3QIpAhf4T+6bBs2mSqzAHxAQ==
X-Google-Smtp-Source: ABdhPJwAZRWitfLDhWCfV+SJTBcZEhIS7z6ASJYKGDcNe5UxFBpwzSqkCG/Tlq/3z81d9mmT8PZ/Tw==
X-Received: by 2002:a1c:32ca:: with SMTP id y193mr4392078wmy.83.1592945258495;
        Tue, 23 Jun 2020 13:47:38 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j6sm5686924wmb.3.2020.06.23.13.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 13:47:37 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, anuradhak@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/4] net: bridge: fdb_add_entry takes ndm as argument
Date:   Tue, 23 Jun 2020 23:47:15 +0300
Message-Id: <20200623204718.1057508-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
References: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can just pass ndm as an argument instead of its fields separately.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4877a0db16c6..ed80d9ab0fb9 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -793,11 +793,11 @@ int br_fdb_get(struct sk_buff *skb,
 
 /* Update (create or replace) forwarding database entry */
 static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
-			 const u8 *addr, u16 state, u16 flags, u16 vid,
-			 u8 ndm_flags)
+			 const u8 *addr, struct ndmsg *ndm, u16 flags, u16 vid)
 {
-	bool is_sticky = !!(ndm_flags & NTF_STICKY);
+	bool is_sticky = !!(ndm->ndm_flags & NTF_STICKY);
 	struct net_bridge_fdb_entry *fdb;
+	u16 state = ndm->ndm_state;
 	bool modified = false;
 
 	/* If the port cannot learn allow only local and static entries */
@@ -893,8 +893,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
-		err = fdb_add_entry(br, p, addr, ndm->ndm_state,
-				    nlh_flags, vid, ndm->ndm_flags);
+		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid);
 		spin_unlock_bh(&br->hash_lock);
 	}
 
-- 
2.25.4

