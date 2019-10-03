Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F319CCB0FF
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfJCVWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:22:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35943 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfJCVWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:22:01 -0400
Received: by mail-ed1-f67.google.com with SMTP id h2so3996077edn.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=U/9Eh6X5Sc43sajYoAyDEOIB2h/OjBJ2wmPgaz2KgAg=;
        b=rBobQjxWMCxsFNSJvL6FoF+fQmU8a4AC5Xc2qemZfYBKSA4uk4K1jPYmUUHdWM5KWS
         EMZHwFTfuTgCAunlTn6znDZIM1wWY4GcyxScm1UqNsn2ZLzW/q+tWBcVW+75PgZUgfwo
         FS3sgyevALVgWIAlE/jvk8nPTgRPSyMmf9O6HYHEM5TQouRa0Ha8T1Ca8BTD7gcyG+0B
         etIDjYiEl82joQz1qrdSFn6OatbEKNd6Oe5x8sII9sOW9QezxQVGXHfrRgRNcl54dvOY
         CNPzI36cMz0zOEc7Qrz6YBeW+KoLjTgkHBxdB/pXE6I2e1jO8B6JnswIHBBrK079giJX
         ofgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=U/9Eh6X5Sc43sajYoAyDEOIB2h/OjBJ2wmPgaz2KgAg=;
        b=VYXWwtkE6NplMd8EeDsrXw4IdpQzNgZD8xlnV7bct4iu8Bgm/YRsvtbxnfjEw+QvSt
         JWvXISBOdZtTiygd4/zL/0OS3xcPvAsDwY9XfoJptTQ9TGXwzQTfu5SLnxQlqQmQHxvD
         COX8yTf+M/5RyVz94voyMjx52tOO2vPAV1r7BhWZxcZK6nZd5mXn82BULWjW30ukSZIF
         xbyNPufolIfA4+ap13PEx3t3hJO2pz3ZsApRE/e3kN+b0FoxTn9ykAYSe3A8rK+y2FR5
         oH+hacVpDPSRB3ZdxFNhombIZhXvcNoF6F3s8PI2pUlyH9TBBhxYUP1waLu711hUjaet
         XoRg==
X-Gm-Message-State: APjAAAVSAfxml9eHLXWBep3yhc6sZNe/+B3T/2F+4hZn89E3b5XDY+Ej
        GYkl7fjXosq9u//ziwBZC5twvCM=
X-Google-Smtp-Source: APXvYqyDc7lH8SL2VfS4khnf0qjQ96Y2Afx/5WukiVFaVBnq2NWmDWef8lVbOG8YQhcf4WVD7/vkJw==
X-Received: by 2002:a17:907:205b:: with SMTP id pg27mr9564287ejb.135.1570137720115;
        Thu, 03 Oct 2019 14:22:00 -0700 (PDT)
Received: from avx2 ([46.53.250.203])
        by smtp.gmail.com with ESMTPSA id i5sm678326edq.30.2019.10.03.14.21.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 14:21:59 -0700 (PDT)
Date:   Fri, 4 Oct 2019 00:21:57 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org
Subject: [PATCH] xfrm: ifdef
 setsockopt(UDP_ENCAP_ESPINUDP/UDP_ENCAP_ESPINUDP_NON_IKE)
Message-ID: <20191003212157.GA6943@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPsec is not configured, there is no reason to delay the inevitable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/xfrm.h |    7 -------
 net/ipv4/udp.c     |    2 ++
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1613,13 +1613,6 @@ static inline int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optv
 {
  	return -ENOPROTOOPT;
 }
-
-static inline int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
-{
- 	/* should not happen */
- 	kfree_skb(skb);
-	return 0;
-}
 #endif
 
 struct dst_entry *__xfrm_dst_lookup(struct net *net, int tos, int oif,
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2520,9 +2520,11 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	case UDP_ENCAP:
 		switch (val) {
 		case 0:
+#ifdef CONFIG_XFRM
 		case UDP_ENCAP_ESPINUDP:
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			up->encap_rcv = xfrm4_udp_encap_rcv;
+#endif
 			/* FALLTHROUGH */
 		case UDP_ENCAP_L2TPINUDP:
 			up->encap_type = val;
