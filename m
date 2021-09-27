Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EAC418DFB
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 05:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhI0DhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 23:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhI0Dg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 23:36:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C26C061570;
        Sun, 26 Sep 2021 20:35:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso12289539pjb.3;
        Sun, 26 Sep 2021 20:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8lwQC5CtdK50mFU0zB09Pdklmp5zNmyWjC5W17/O0I=;
        b=YcSSPeP8hdBlnjQPVmyuLpNxPmXrTUu9QNWRzZ7qd+RFnQvB+Nepijb0ZIWpVReSCb
         CU/4gJ4t1EF21XrnNK7UvkoL4XkThdXiDJeN3er9dBAP58CUcwG5lA7qlRkghGI1NolT
         cdD9U3XLeEubpcJ/aE25PE/0aKuhNCLBBXelRiAilo6P+5XFmr6L4rN/PWdpv7n8iNRc
         jCPHigsTnGoHUEYiw7R/3CFiy83F0hZFgeZ9TH7giSJNOlbcf7AxRy6Cdy4lcV58Q1R+
         e3bSgf3/0K2MYWXJZ6lMSHmfpdqpIY/S6eXR/h1KNz5ElXkOOjb75H0vqw+CGH36jkow
         bUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8lwQC5CtdK50mFU0zB09Pdklmp5zNmyWjC5W17/O0I=;
        b=6e4TvQSoC5uukccwS6bbsIPpR0FZEhsBjl3+Haz33LzmYpLm7qhVgAtza/2hVQjhbI
         PnkmjBBG1oMx7zwZb8ziWqDK4uRhWrk6SW3NiFmk4BBVKrL54pGLmkoQ+aXm1/QRJa7y
         9uRKikf808vFYlbILbTCzd7JvdTCP/MUF3DsQEY8uGPg/slBF8aT6OjHsytVQwuh74cw
         YG/5VtiaJvObSnPdZ6PmaJcJY+yMeoSZEanMFnSHYrCAQQ7Gb/nBmzFMS0f61aD2V/9Y
         4mgk2mbU4zXukPbITz6HEJ5JVufW0Pt0s9DJROEhs8sY9WQgCxbfE7Pn6EMakaJjL+w+
         s5SA==
X-Gm-Message-State: AOAM531fuOiV3GjTLg8KavT8AbWfh02TS7+SuMYtMvfXHIhIchBIc72B
        2HFKJs2DcqjjQ2J8cjwg2ts=
X-Google-Smtp-Source: ABdhPJywH6xwy7TFmWZjSl9IAk4nkwohPB/1fyxngIhJwsU6b3voy3eqpu6+Wm5LG3Ck/l/wZ5Ww4g==
X-Received: by 2002:a17:902:6e02:b0:13a:41f5:1666 with SMTP id u2-20020a1709026e0200b0013a41f51666mr20719619plk.39.1632713721297;
        Sun, 26 Sep 2021 20:35:21 -0700 (PDT)
Received: from localhost.localdomain ([210.99.160.97])
        by smtp.googlemail.com with ESMTPSA id r206sm1404320pfc.218.2021.09.26.20.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:35:20 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, lariel@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next v4 3/3] net: mac80211: check return value of rhashtable_init
Date:   Mon, 27 Sep 2021 03:34:57 +0000
Message-Id: <20210927033457.1020967-4-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927033457.1020967-1-shjy180909@gmail.com>
References: <20210927033457.1020967-1-shjy180909@gmail.com>
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
v3-> v4:
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

