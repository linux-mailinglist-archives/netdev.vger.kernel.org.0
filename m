Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A914BCFB5
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 17:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244290AbiBTP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244286AbiBTP72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:59:28 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612F1443D3;
        Sun, 20 Feb 2022 07:59:07 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id l17so1329234plg.0;
        Sun, 20 Feb 2022 07:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pyq6u+oy+fqZeW/hecUnoAg2DOu5MbfwxNlJm6r1Xhc=;
        b=nhNXKjiu6EaOKVNgwNWDgMQAPqgMwsRFUEymL567UuWUK/arrTFPbe44ACR42cYIBL
         bsN0eLNtzre4HgEeRuF8ScM8yxmTEfo2b/QbVuK9VD5j6gDvzMA0qfrn5zGdCT7n5fBR
         myLeaYTe2aqFcjbJEqxFrWBr+5poGn3GlFM9xQ8vAYNWQJ01KmsBNXZOGnXeyjWB2lBr
         L8OPTmlMzBsDz3M87LeFQtVljORl+JOQ0YQsELxbxgMckEycSdeX1WBRCvkcf9RHzpmx
         /zpv3O2GTASPwelzwWD7l7Je6mHKpMpYv0WRF/8ZHcjhVSk8SqfFwHQVpIbku+sqcuKD
         7CsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pyq6u+oy+fqZeW/hecUnoAg2DOu5MbfwxNlJm6r1Xhc=;
        b=T+S/0YM2LumXjw04abeU/w8S2IwXO6C41bA3eEjhIP6JA9ED6OZ0ZXmGnRWXO1WYeT
         Ub0iBSHI8JhnTz6nucjuo8T1c64w9IQm0JJ4W/6ucHcT3kNcKBr4MR4dmxZVDUO0savY
         HWS6ssozW5N7JjWlEMVtIw4HPIahXPp4y9QJZYJ4jwMMEg0JWoOELYyHQQe0zS2ApCA+
         6rwyiY192R+OFN2iTBWwgJd3ieHO7QeYKelrBGo0Z/VtZCuPGuev1u/v6/zGOLqrWmAT
         D59ZWZ8TCj7yYPzcztMNbGG8u9h+5CeTbume4aDxwK7AiKXxOzjn67YmgtuEtg7vLDOv
         2I+g==
X-Gm-Message-State: AOAM533mB7nho57eX2d1lUOWhn2mzQFdq0tQ5l8JrlaKWzgJmXnUpWXD
        fjBuKdDxrnxkkczHR2CCeq4=
X-Google-Smtp-Source: ABdhPJyDvTw5u1Ag3PqOeCX1fHbyL3QF88xpCu/Gh3BQO2dQKLD7HyGzmy1YoZhB7ui8yKZigMidAQ==
X-Received: by 2002:a17:903:192:b0:14d:8b5a:5446 with SMTP id z18-20020a170903019200b0014d8b5a5446mr15649776plg.46.1645372746931;
        Sun, 20 Feb 2022 07:59:06 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id o14sm5001927pfw.121.2022.02.20.07.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:59:06 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: neigh: add skb drop reasons to arp_error_report()
Date:   Sun, 20 Feb 2022 23:57:05 +0800
Message-Id: <20220220155705.194266-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220155705.194266-1-imagedong@tencent.com>
References: <20220220155705.194266-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

When neighbour become invalid or destroyed, neigh_invalidate() will be
called. neigh->ops->error_report() will be called if the neighbour's
state is NUD_FAILED, and seems here is the only use of error_report().
So we can tell that the reason of skb drops in arp_error_report() is
SKB_DROP_REASON_NEIGH_FAILED.

Replace kfree_skb() used in arp_error_report() with kfree_skb_reason().

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4db0325f6e1a..8e4ca4738c43 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -293,7 +293,7 @@ static int arp_constructor(struct neighbour *neigh)
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb)
 {
 	dst_link_failure(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
 }
 
 /* Create and send an arp packet. */
-- 
2.35.1

