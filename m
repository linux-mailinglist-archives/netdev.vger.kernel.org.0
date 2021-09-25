Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165C5417FEE
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbhIYGMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347874AbhIYGMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:12:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7956DC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:11:00 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n2so7989165plk.12
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5sX9xO/2hSpjvIzG6eC88NJjr5moEKiSgfCjBQ+wv/s=;
        b=QcsmDcg3PxST+XST91rCsNZjQD/FfSCgtw1YDU1C6PoWiSsrrxO9YikfwYGwN8t03L
         SprDdthfBQwo3kkj+/J28bOUxutZWsfp/VN0sim1YFm8chWOG9HhNZl21WaUaBlhjS7d
         5nw5SZmxAx7elgy6e/ztDrqlzdfOqyYox6yPEB5vFD5+gZzuh5aZP6RPO+dQ0VaenHEi
         uHb5IsztIDLlu8XTYrGFpxYhJleerbAmDaUKrBGDWRJStNnKJweNaUHSoFoDqeCjhWOU
         I6Pz9issuOUbr9okzcCB9xMGRdgw2EaKozUwdOGmSrvfAUxt5N6ndA1Gf1YpV1UKz9AP
         j7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5sX9xO/2hSpjvIzG6eC88NJjr5moEKiSgfCjBQ+wv/s=;
        b=YHLpKjWSbVYlJlOAmYkhkcFYKB7S3j40qEvg6YsZJtBrx/mZ5dUeJ5UChK2s6ZUjkM
         GbNDPFQacUVU2EXyhfcn1G4VDY2rwhbB9YGg/7S1naJagAE7hmNhPPaRrxJPUO/6nCDp
         GdIo+2UsqBc3Xz8RRY/KXnXu1tcX+KBgdfI9VwteSRbRtweS1cTo5ttvd0he5YDKZ94k
         Lqt17YEn05zWASjCziEk4lPrNRYJmySYV4A74dpV0ZXtRAztcB3RtzqSSUCnwUDl/oun
         drGI6gt9gCWllTwAs+Kj8/ttiAKXCnVGSaKsB6jDE5uGUb3kKxc35XjQrfXQlMWxHSut
         535g==
X-Gm-Message-State: AOAM531rQ+U8qZRhzagqAnd4lCar1sr6JXyo3e9HkT0JU1h1L3wetiY7
        ROS1FNmDhtciIntYNy4qzJY=
X-Google-Smtp-Source: ABdhPJxKihJ8fjCClilisnqMvO3ELUz0A0vrI++JkrepnzRJY4/Z7OfTBjr5aKGi5NRqkbV0mXR5Tw==
X-Received: by 2002:a17:902:784c:b0:138:f4e5:9df8 with SMTP id e12-20020a170902784c00b00138f4e59df8mr12787668pln.14.1632550259968;
        Fri, 24 Sep 2021 23:10:59 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id s10sm12948169pjn.38.2021.09.24.23.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:10:59 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: mac80211: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:10:37 +0000
Message-Id: <20210925061037.4555-4-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925061037.4555-1-shjy180909@gmail.com>
References: <20210925061037.4555-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---

v1->v2:
 - change commit message
 - fix possible memory leaks
v2->v3:
 - nothing changed

 net/mac80211/mesh_pathtbl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index efbefcbac3ac..7cab1cf09bf1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,7 +60,10 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
-	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
+	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
+		kfree(newtbl);
+		return NULL;
+	}
 
 	return newtbl;
 }
-- 
2.25.1

