Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A5320404
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhBTFbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhBTFax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:30:53 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60406C061797;
        Fri, 19 Feb 2021 21:29:38 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id r75so8241092oie.11;
        Fri, 19 Feb 2021 21:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RcbluTouVB6/rFLYgmpItY/JPds73C5Ori6pD1ifdmo=;
        b=lVncbfGbUBfUQrrG9HksMtUt9mnGr5O66FjLav9ZXz6/Uj/NynPR2kyAlBEiyxTJwz
         R6XhVJliXx0dpI5mXFwgvSCTeW699Z8OnXGGVAtVQ9S8WnrFQtFLXr+VkKJJoiYeHvKF
         dx0zK0mzpWhXMX0WQJZZOfqviVYubbzBf68PoazTrX0HAdWQwyo9TPUSOeWGRG6xVdpi
         VupibcUaP5Oyu2g18bbLo537Jhq1OwWEMMcrxB6xgW9pyX7aboqIQ/HLlJdzdovfjVfq
         aQEZR+RegJafNnKSURWQPQBq0MAsbCSS5EVae4aRcJzKuvxHuKXBpZVYNHFstB5OJeju
         euJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RcbluTouVB6/rFLYgmpItY/JPds73C5Ori6pD1ifdmo=;
        b=FrtbfYGo/XB2A+UYkSXWv9FQh1iu+11lWa1U3QH79MF9XcrkPORBABD4+LjxqH9Va6
         Yhm15zLl+tnlrpGohvt+hvyiB19gBy4MbyyA/F3dk/0JPLc3PKlE3jpgh0psVJSjSx6K
         28dFV5hhZ0ekTFX7Vn7f8y6U6Mkq3dM0+cBXsSz6zaie07msshUxgvU6vxzf832Mk1ow
         hrYVRo+Ep4q2UjkqBrN+UM0u2TStHsi0jGMSqeZWeLIQQhUhImAWGW7pZHqy2nphtrQ5
         OueKJqHsCArVMp00dr47KnQRJ4Q88tDA5/Lhz/ke/4/+syzUx23RSlaZMXpk3PrdkgVk
         EDxA==
X-Gm-Message-State: AOAM532Y5VQcbrB+7yNh0WHm2izseD2XeJ07IRfl8cEVcZmP/s0vm7GL
        gWMvLC9yu7gS4sANEXtfNjVxx/GPriL3Vw==
X-Google-Smtp-Source: ABdhPJyyepoWGtxQqr5rocZOzFx35j1nUFwBRyaXkCeGX7OZtGH6vra/tGFZbW7jFpii0nibBTVX/Q==
X-Received: by 2002:aca:307:: with SMTP id 7mr9030393oid.174.1613798977753;
        Fri, 19 Feb 2021 21:29:37 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id v20sm945955oie.2.2021.02.19.21.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 21:29:37 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v6 7/8] skmsg: make __sk_psock_purge_ingress_msg() static
Date:   Fri, 19 Feb 2021 21:29:23 -0800
Message-Id: <20210220052924.106599-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is only used within skmsg.c so can become static.

Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 2 --
 net/core/skmsg.c      | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ab3f3f2c426f..9f838bdf2db3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -344,8 +344,6 @@ static inline void sk_psock_free_link(struct sk_psock_link *link)
 
 struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock);
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock);
-
 static inline void sk_psock_cork_free(struct sk_psock *psock)
 {
 	if (psock->cork) {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index dbb176427c14..286a95304e03 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -620,7 +620,7 @@ struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock)
 	return link;
 }
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
+static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 {
 	struct sk_msg *msg, *tmp;
 
-- 
2.25.1

