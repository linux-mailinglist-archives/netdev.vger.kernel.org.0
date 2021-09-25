Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508B1417FE9
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhIYGHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347885AbhIYGHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:07:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB79C06161E
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g2so6664170pfc.6
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5sX9xO/2hSpjvIzG6eC88NJjr5moEKiSgfCjBQ+wv/s=;
        b=KvL9vwahiW2tgW7Y4sbstDLbEyXdzi6MSTQKda0NGBJYeoIAoxRO0tb/Gdhz5n6uiE
         Hvh/i1H/OvXh72jSdgHkyrSYDK3O2mLbkThKqkNqLxDBe9tiSS24MDH6oY34/9HdWxJJ
         1LmDM+PhEQMhNDh1ZJ6mfzMPf3iCYT7M+MnUuE9SEhlBj94Y1dBlnf8a3rRESsyAFKCf
         baKT+JGFNPDLLelD50NMJ87LSyVBQ8EDJ7ThbP884HsNqef1MH/sr7K2fgFVg6AsDw99
         Qp/L/okNCq4wSN4+KnOlAOgaPRPPUvTCoa9iaN7d59t0XakFj6LaV+5qPyPXsvEl6mFu
         DRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5sX9xO/2hSpjvIzG6eC88NJjr5moEKiSgfCjBQ+wv/s=;
        b=a0yNrCcJ4SEVNMhuJk9d2A2aRG7GEb9Gt/BCHWcUz09TxPhuYvH5bMAEdTU6ZXp6bw
         +L9feRVe1/QBjrpEO21+LXTJgjExENTp2zrDKTm2UdYsLBIxk6E8BHGHEto6iReNN9EA
         SXwVSsP68HEPPv8gvGtTRnIyXSpMudDlMjBHXtXh1vnrD0Ocrd+GAahJs24zyFC3+sXz
         WV90Nxeg4KVyfGgttVFsJh7nzlUX2p2h3bbKm6czyfN7rXbVnRwrMpJ+i5AciFXxgYps
         zX1CU9Lk9i1NoUNZ7WgLHqrs7TMkgRdZr1XCvMv3u7aAaWMY89mNBOHYiMm3tUqlRSiX
         iBww==
X-Gm-Message-State: AOAM5332237NdozgbHQtR/m24gn/wFsErUAstPatAkkUt9xcJHuQ6CGV
        cTgivvnWWPjlH0oL7F6NL+Q=
X-Google-Smtp-Source: ABdhPJzZb3vUT7fWNzKKcewQPTko7B7Bi4cVGDaXS96inV0rIzP1WRxD4Ere6fNM5RseqQJ4nmiS5g==
X-Received: by 2002:a63:33c7:: with SMTP id z190mr6952247pgz.413.1632549977592;
        Fri, 24 Sep 2021 23:06:17 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id 26sm13650587pgx.72.2021.09.24.23.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:06:17 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     avem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: mac80211: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:05:09 +0000
Message-Id: <20210925060509.4297-4-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925060509.4297-1-shjy180909@gmail.com>
References: <20210925060509.4297-1-shjy180909@gmail.com>
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

