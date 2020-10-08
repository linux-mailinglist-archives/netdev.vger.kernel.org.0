Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7313B28781C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgJHPwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbgJHPwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE97C061755;
        Thu,  8 Oct 2020 08:52:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so4670421pgl.2;
        Thu, 08 Oct 2020 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2c1uAx6+iuSHRTfrTgLik1ZGlp05d/a6YUIfd7rJvig=;
        b=MDZg+iZXvxibY145xyajbHVbBb2Aunu3IknflImWqoYYMhAe2iJ4uYQ/qAcpFYj+O7
         xIDaYaW+c+/53NeWwFLh7AQVnI+dd1o1loU56IIyFUUtbie/QRPZjpnBf4FIZA8fpaaF
         sC2E5p764LGU8hfsQhxopC+A1PGwW1iAiyfyDrJUF7hmwB4O+syCJlYVeLvbvfoV8N9h
         xN3/1KoGGORWE9T9TP3FRUSU0bf2+ddCUNYSl3cEKd6Gvg5jUnlGMGL5fHNBn7IkRXsw
         t8PFxnkeVMp4CJ0sDBhcScj6DnHfxL14YBVnynvgtVYVaWOXbhYQ6H3oqFFa4MYTS0PG
         2Tyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2c1uAx6+iuSHRTfrTgLik1ZGlp05d/a6YUIfd7rJvig=;
        b=BKSfuV6L5tiasYu+4n6DOVKNoULHwcf84Wyv8uiwub4Wv+hLuMkleNk6uzgQZvYaXg
         q/1AEu7pILKxAekEqjeJuBiMGpaqw0twU0o+ZITJ81k1XaPCSdIsPzCoYpmr3D7g3QRd
         rv6/JOiJtAIFc+XYcmlT7/+NVevgNNLUE7WRQtSZ8kEqbhrbtRWZso4zvnNnJQK+OhHX
         tc2+24L4bzTGK9HSjUgg2DYk/h2CmbbiVk1hL3GDXDi0lkmz4LT9NpIXRr4Fi8F14PWE
         gy7M0RiosOjk9/Ps5aOXwkBPjUD06qzh/dzf/UjJCOKUKt/whY2P3JmykHIZ339Ev5QJ
         8rkQ==
X-Gm-Message-State: AOAM533sjih5wYhCQtSE3qxPD/GwGJcGkqZ0M6J7w2IwZl/35EgkX3Nz
        0LXeuOuqNZHgspyjl0BfH9E4rSu1N2k=
X-Google-Smtp-Source: ABdhPJyBspy96ram6A5gKOhArjt3bAXzQ3LDnLFdG9bMLfn0bxxeoVbGe9GUbIuuMr1Ce2eKimA7qA==
X-Received: by 2002:a17:90a:67cb:: with SMTP id g11mr9094102pjm.56.1602172350521;
        Thu, 08 Oct 2020 08:52:30 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 003/117] mac80211: set minstrel_ht_stat_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:15 +0000
Message-Id: <20201008155209.18025-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ec8aa669b839 ("mac80211: add the minstrel_ht rate control algorithm")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index bebb71917742..6021e394e5da 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -173,6 +173,7 @@ static const struct file_operations minstrel_ht_stat_fops = {
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
 	.llseek = no_llseek,
+	.owner = THIS_MODULE,
 };
 
 static char *
-- 
2.17.1

