Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3471B2B1C85
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 14:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKMNvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 08:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgKMNuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 08:50:24 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4761DC061A04;
        Fri, 13 Nov 2020 05:50:24 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so13528804ejb.3;
        Fri, 13 Nov 2020 05:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EO37OAJNAbmZmGUhAeyjfYFiO66b5FlhyGH1+SemRIc=;
        b=BbzicZpiGaE2YQjZhlr8r9r8+LJ1YvlfarJx6O14McwTt7deIy0GDIRHlEFPLw14y8
         u2HywTB8JkgkcnMsr4ArHWl4vNVnqx1eCv43hBQUVkYZWcnj5tC/oRIqYhNhzRAH1xlD
         7k7L7EP4IbWLl25MrLidnnIXDNAuy6PsJ0rl/0oeyRY2bY0Qqv4p6QjImnqjicPPzH+J
         2zJECPh8R4hM2ZytYgDcq9NYOWNKXOeL5wrvqR+by/z/A4gqxBzIgwKqlggP1Z++uaxn
         TJzfZHHdXp7gw9nYXxc9TP/iVT0dvSOZ/AYQUs2c+Z81KotFWavBegZkq4M2l1G66uB3
         fKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EO37OAJNAbmZmGUhAeyjfYFiO66b5FlhyGH1+SemRIc=;
        b=MUkVL357Q1TSP/xhJ0Xkds8TMWXBBAO7mkGfrZ3iaTDoh01R3JcGqTlgHKW299u8E6
         e8Z/3vBziSzvt+XZCUVekBB4tU+yOWmNj0/3IQFZgV4VWxkVQqpeQKzfy0FEbQj7dp+x
         t0x6CeHOvcYjwFXZqUvHR0MONm95ar6sD5ULfCnBuZMhA+jg5leCm93hVAXavlCy0O+5
         Y6ge2+kPU3BGHpg8Aa1V8UzumPZB1+cRkuPI+DSrKx2eZSoJn1/r87VP1N5ujrPRfPRB
         AKywtGySM5hTVw5bo5VS4LVmEEnVQSXRsmY6/66Gw+FPBZ0FXZyVe9qudzCvQxJeFdd5
         XZFg==
X-Gm-Message-State: AOAM530FtuwNhhU/iGFZwr+QLXm1jDs2XGe7/v7ZU3XJdO1kQH1M4v/g
        41V6aRD9fGaIZIxNCyHgbsrFCY3Dovpuctoj
X-Google-Smtp-Source: ABdhPJwCiN1IhzDUmykftILZUE+1nPETpYWuOraunwhwZRNk6s+PGuUWEvwGxGCf+NHtYTf1whfzgw==
X-Received: by 2002:a17:906:14d:: with SMTP id 13mr1935709ejh.516.1605275422982;
        Fri, 13 Nov 2020 05:50:22 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2de6:6700:4456:5b6d:36a2:24a6])
        by smtp.gmail.com with ESMTPSA id n16sm3687783ejz.46.2020.11.13.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 05:50:22 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] ipv6: remove unused function ipv6_skb_idev()
Date:   Fri, 13 Nov 2020 14:50:12 +0100
Message-Id: <20201113135012.32499-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bdb7cc643fc9 ("ipv6: Count interface receive statistics on the
ingress netdev") removed all callees for ipv6_skb_idev(). Hence, since
then, ipv6_skb_idev() is unused and make CC=clang W=1 warns:

  net/ipv6/exthdrs.c:909:33:
    warning: unused function 'ipv6_skb_idev' [-Wunused-function]

So, remove this unused function and a -Wunused-function warning.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Alexey, Hideaki-san, please ack.

David, Jakub, please pick this minor non-urgent clean-up patch.

 net/ipv6/exthdrs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 374105e4394f..584d1b06eb90 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -906,10 +906,6 @@ void ipv6_exthdrs_exit(void)
 /*
  * Note: we cannot rely on skb_dst(skb) before we assign it in ip6_route_input().
  */
-static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
-{
-	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) : __in6_dev_get(skb->dev);
-}
 
 static inline struct net *ipv6_skb_net(struct sk_buff *skb)
 {
-- 
2.17.1

