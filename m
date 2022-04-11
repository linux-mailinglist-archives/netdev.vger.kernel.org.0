Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE994FC7B3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiDKWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiDKWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:35:02 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EB22C65D;
        Mon, 11 Apr 2022 15:32:45 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id n11so3967657qvl.0;
        Mon, 11 Apr 2022 15:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QoG6vUiayFYqH1XXsHOZKFN1YxyIK1XRGOiWo3lp9DA=;
        b=a6c5xNw5tCxYOgELJUdAKUj2HMuCVMvpnNM0/W0NVcs77tv88Agir7iC+NUiY9ZQDw
         6eWidZA+cCkWe16j1WBh5rHzcA2xUGGcwpJWD/h/c1RoVzhBs6BZxAFtjv+oB1Xwu3Ad
         ZrMdAsybnW1unQ8kePjzx1Nti2qLMlIZkFO1zjatonmBjM46XHdEot2JCtLZO8doJ4xi
         KyWKF4f4eGUjBuQGev03inNBxhOGYN+Y+Wl5/JvSvebSrVtFWdDX4qF/Oliy9iexjeTq
         hfRL+4TbNQrNOgzrj4g5yTWan/2NTUJmNx3H6RNffFM32/YNHga3euUQ7Gm/MCyQNGYY
         FmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QoG6vUiayFYqH1XXsHOZKFN1YxyIK1XRGOiWo3lp9DA=;
        b=Ck6kAyNjJumnsMlh/3uyaO9Co900ZEe6cUlDpT0uTavrP9PY482K4ZVGRqtTDLr56j
         euJkcwl3Yg7IuSYVj/Twauptts9Rg22aftL9hfjcICGl1jN84eTa/UaL0lvwAU7aYsXj
         ojCGUCX2wa3UNVNZBcm2XkrmMjhIvsIsxGjCnbuq3zPsu8YtfncSymZr+MkcmRuyY6ko
         EYoF7pdVPc8yR66v1uZQwGeOF4ba91wIICXD1BCCztd+s169JgXejU9M+zhjWGZ79X72
         3bD1OYE7Frn/dmtfDEplb9WR4SVARD9jdKJEYcqX88OEfwu2mCk44MvPAvIs1wtoVsV8
         ItgA==
X-Gm-Message-State: AOAM533BAO+ETzVP5zNdtnWZUhayZSCfujD+yBKsvMRXHfKnH6H4Nzut
        /1KHL+YRfOiH0VkfTAsZxkxnydDaWrOR
X-Google-Smtp-Source: ABdhPJzz5EBOCdiUO1OyLAeAf3u5C2yxwxlVVQ0oWrnLye5QaFFrzzyR5b5/Yia6u3X9tMOs2g/Ibw==
X-Received: by 2002:a05:6214:d8c:b0:441:6597:6da2 with SMTP id e12-20020a0562140d8c00b0044165976da2mr29143491qve.116.1649716364659;
        Mon, 11 Apr 2022 15:32:44 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id t7-20020a05622a180700b002e0ccf0aa49sm26733697qtc.62.2022.04.11.15.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:32:43 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 1/2] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
Date:   Mon, 11 Apr 2022 15:32:28 -0700
Message-Id: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
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

From: Peilin Ye <peilin.ye@bytedance.com>

Do not update tunnel->tun_hlen in data plane code.  Use a local variable
instead, just like "tunnel_hlen" in net/ipv4/ip_gre.c:gre_fb_xmit().

Co-developed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv6/ip6_gre.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 8753e9cec326..b43a46449130 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -743,6 +743,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
 		__be16 flags;
+		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
 		if (IS_ERR(tun_info) ||
@@ -760,9 +761,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		dsfield = key->tos;
 		flags = key->tun_flags &
 			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
-		tunnel->tun_hlen = gre_calc_hlen(flags);
+		tun_hlen = gre_calc_hlen(flags);
 
-		gre_build_header(skb, tunnel->tun_hlen,
+		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
 				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
-- 
2.20.1

