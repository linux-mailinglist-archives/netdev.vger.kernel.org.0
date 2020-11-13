Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2FB2B1AB5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgKMMEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgKMLf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:35:58 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5798C061A48
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 03:35:57 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y7so7367947pfq.11
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 03:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bueBjhTpqUKjS9jxHJGqHsIOsYGFZLXQ7NH/5MiUfa4=;
        b=MJnCkhhvldE/3sTC8i+9pnoRLX5+U8HSUTG3UXRQg8DIMrnjZ/bF/nFujoG4sj0tFu
         CeVbRA6Zxby7B9YPNYmRDG0/Q2+3UxyEser6WVvIFLfFAYyHnSUpZwfngieWdGoMZXgk
         3igzOPkv9Jt9gYmyq6I4l+Beuw0RsyN0htMz+hQT1Z95TNSOEMKdFLaObWYRymvX+8C6
         fzrHjC/0VbhE7ck4uoDPlGlrj3NrD3r9wt5AXdY+g52z+mqfB8peZY4zSYJvN/j1JRRH
         qV4lMeqOoh8mIzvxJfr+jEerZ12KzyozpL7EE1ZditzgEteD+u3rsaqtWDrjSNe7+zuX
         rPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bueBjhTpqUKjS9jxHJGqHsIOsYGFZLXQ7NH/5MiUfa4=;
        b=hAbE0yzRbrxC8YW7RtuiFQVj7GB9IJz08o6OD8J9jNdmLw4d9/5Jj1cx+J/6llWwS+
         1CBL8py2gECUnLs7fTr20dDcpTyNX2paoAVMQ6n/6Dn+u9VkdqPSF7G+ivfS0eR3kZ71
         RDFnKURQAcUCwdIYwU7UzCiTkAkJAB1NWpTg+vkxH5N2sBov5JTMcpGg1uMWwSp69yFH
         V5VkAPCQzVBul3PqJ6WIJwAQYtZhixaQUBLpJzRbsjMwDc5vbY0NVPF1DlN2GQrW1QfQ
         OrymKPSlxg8H3uGvQRbdZIhkilJPwxajzwvemEQPUmuZpAtHjAdiCYKJCxOSZrKz+hcR
         31EA==
X-Gm-Message-State: AOAM530Lj1PLO/UWUFL17ZX4PnAjkuarkiRe0zxneeZ4MQjootpmweZC
        u7S/0Lt114cCp2haQCCt3cbn3nVQ8TI=
X-Google-Smtp-Source: ABdhPJxkJ8Uo+bM7H2+czkSS7Wf1EgEK+H/86lVhtNb1dJ1NF96KpVD81RZaDoI+glXlwE062JPzAA==
X-Received: by 2002:a17:90b:100f:: with SMTP id gm15mr2346983pjb.63.1605267357390;
        Fri, 13 Nov 2020 03:35:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id gf17sm10415641pjb.15.2020.11.13.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:35:56 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] inet: unexport udp{4|6}_lib_lookup_skb()
Date:   Fri, 13 Nov 2020 03:35:53 -0800
Message-Id: <20201113113553.3411756-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

These functions do not need to be exported.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/udp.c | 1 -
 net/ipv6/udp.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c732f5acf720d14285bc851d965851a572643051..a3f105227ccca132a8479e3ee3580495731b530b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -550,7 +550,6 @@ struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 iph->daddr, dport, inet_iif(skb),
 				 inet_sdif(skb), &udp_table, NULL);
 }
-EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
 
 /* Must be called under rcu_read_lock().
  * Does increment socket refcount.
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e152f8000db4d0487afb2966d7f978e804fce281..9008f5796ad424937ca5a1df9542afc7d313b7e4 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -285,7 +285,6 @@ struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 &iph->daddr, dport, inet6_iif(skb),
 				 inet6_sdif(skb), &udp_table, NULL);
 }
-EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
 
 /* Must be called under rcu_read_lock().
  * Does increment socket refcount.
-- 
2.29.2.299.gdc1121823c-goog

