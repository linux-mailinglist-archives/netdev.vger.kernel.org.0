Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5624C262A3E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIII1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgIII1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:27:50 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8047AC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:27:49 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id a16so1292702qtj.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Nrol5QvORbVebPKDXu/TylKijLjqx2MAX2IhRSF5IoY=;
        b=K4a0aSNx87Im1mAuzjR7rMSBiXgyOAyTnB04toXfX7efVfCjcON/V8EAJQARiDQOJD
         7AriGogCzTjSMFVGRxHLKNCN1qeeiOz7yDnHqAb1p3XZ/h7u/yMcEfzF3nS0uhViw2Ys
         Z+8m6fbwE2q2fHLW1Q5nvVvkZJ73mqkUTtD7bkWpUFPeX/uJ5UR/aMcYy4EweoTBZuYo
         hOapCVkYwIwfLb5ctCCt5xECrQQnZ3Ogdm7Y4rMhg3iCIyt6xk4esXUi23n3YhavkUA/
         kfqHA6jBNcDlxUIg5nqOxPxMr7x0TMHO+5BRp0hA76C6wBZP+4F/5x2zch8Mcw16B5pl
         0qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Nrol5QvORbVebPKDXu/TylKijLjqx2MAX2IhRSF5IoY=;
        b=evWIeGC7jCD5dqlZYpB0Ssn3mEPlY+6N3W3nPY1JIqwn+eK5ifES4ltO+gQcRGnE4w
         TNO1Q0aGEdfO8/YSDTa0gdu9z3l14UEgAtlXUkYnfWYwE6IxMlOcluFcMbqt6tlP+ZHt
         +iODwfpsGxa1vVOPH1LuyxYK04LFf1pEz9W7XWbXgFvZzfC+YZvP9Sc3E7Gr3E/SuAYW
         qK4j5iH18Z4oYJ53xDZkcJbSThEWTvbkTeH6hYrf3TjmKNpElWerX45n3QO2G00IH4pP
         QOYQ1FCkON73A1v1ReeOMBLL8/ckMGXsoCu3tisgc5/Br916jzpHN4PUn8Rr/GshdfIT
         PeGQ==
X-Gm-Message-State: AOAM533L2aV/BSfhj/Tt8WZUtvXQWuV7p5YIHAO8SPVpgtsTkHY7k5oR
        GIZLkg/jmIr/uVjDYJfQeg+GMMTzrYVcdA==
X-Google-Smtp-Source: ABdhPJz1CrFg0CIM5SAJRfxAdxh6zAkMTwoPgj6Ovd7IzvB4anibtZXCc4BGvxnflqkFJtbWdMhIu+xdm3PIHg==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a0c:d443:: with SMTP id
 r3mr2988321qvh.20.1599640068652; Wed, 09 Sep 2020 01:27:48 -0700 (PDT)
Date:   Wed,  9 Sep 2020 01:27:40 -0700
In-Reply-To: <20200909082740.204752-1-edumazet@google.com>
Message-Id: <20200909082740.204752-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200909082740.204752-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net 2/2] net: add __must_check to skb_put_padto()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_put_padto() and __skb_put_padto() callers
must check return values or risk use-after-free.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ed9bea924dc3e2cac674da7a4d1f7ed1fd741f9e..04a18e01b362e3f113168e7a21cb9e900394db43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3223,8 +3223,9 @@ static inline int skb_padto(struct sk_buff *skb, unsigned int len)
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error if @free_on_error is true.
  */
-static inline int __skb_put_padto(struct sk_buff *skb, unsigned int len,
-				  bool free_on_error)
+static inline int __must_check __skb_put_padto(struct sk_buff *skb,
+					       unsigned int len,
+					       bool free_on_error)
 {
 	unsigned int size = skb->len;
 
@@ -3247,7 +3248,7 @@ static inline int __skb_put_padto(struct sk_buff *skb, unsigned int len,
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error.
  */
-static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
+static inline int __must_check skb_put_padto(struct sk_buff *skb, unsigned int len)
 {
 	return __skb_put_padto(skb, len, true);
 }
-- 
2.28.0.526.ge36021eeef-goog

