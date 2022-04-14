Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D33501CC3
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346716AbiDNUiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346680AbiDNUhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:37:55 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3A9E9C7;
        Thu, 14 Apr 2022 13:35:28 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id e10so5116014qka.6;
        Thu, 14 Apr 2022 13:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6tya+7Pipp+G6uiG0uiTPHOi0maM1UZVUL8Hqjtezc=;
        b=hjtqVqLFstSFSKzQuFhXglK+JAMGuth9p83fpMWUzU1KBc9qysdV65pFA7YbGu2dRH
         qMhOuRdkclAdsEz6j4D8QtuhrNiLxOX06dYRv/nXY3BOQE9v+I8S/W+ohoMSLLTZ6j0A
         YraYd9cncwS+aGRtVazuHLnVhsjRu7cSgAq9vCpxJq7NEFmkbFhQJIt2SLcrwyMukeEZ
         eNVZTo+B2ywpbkIhoX6lGc8AUXpg4HQZwO4Si39CFlCLn2PrC5PBBax9qHbVDpY+INGG
         WDojRuNMNk7U1zXQ3YMmT+MLVfUcGd5M2AVkz6dBFvBrU5+DOBRanTKzdAvNg4jlko1c
         oOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6tya+7Pipp+G6uiG0uiTPHOi0maM1UZVUL8Hqjtezc=;
        b=PyAXF9oa1crjxZogbtreKz91y55pPsRZT162UKNiH8dj3iLTzEFVQr0AUpT8CEtqBh
         74hHC87SfvkqLBsPzXPN2d7Mb3EjNBByHtn//AlLQEsYErYgzG+o6nXT+q1pZv4wtxJp
         dLoebA88ta0+JtYDMomU85JBN022L8wtMpKH2qwHBIks0EG4mMPQQMSwTdz6E04d/FBV
         3U3vsFX15NHRU3ONyPBna7SlxaEyBo2lzJT1+IipijpHl7F2NzzSogKP681t9ObdrXN9
         40Yncr2CixBi3MUqvFjDgg5PMKoJTNOYHm5SMYDbZ1mhBKcKJEFoVGnT4/bBums+40Uz
         W/Ag==
X-Gm-Message-State: AOAM5325vsuJj1Wy6j+ujAwgmaFNPKpJgjD5N5+GG49DrT9YAIR8wJSg
        +a5DjjG6LBMZ0seBfoDzIwjOd9TMRA==
X-Google-Smtp-Source: ABdhPJz/MAwi4rkTcjb+Wvt+whIxOdZdH//Ta0n2eUHs00k22g9r+gkuCJ8ff2G9GHCTx9h92+Xrmg==
X-Received: by 2002:a05:620a:4620:b0:69c:486c:efd2 with SMTP id br32-20020a05620a462000b0069c486cefd2mr3198584qkb.277.1649968527581;
        Thu, 14 Apr 2022 13:35:27 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a201700b0069c7c8d1b9fsm1048404qka.21.2022.04.14.13.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:35:27 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/2] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
Date:   Thu, 14 Apr 2022 13:34:26 -0700
Message-Id: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649967496.git.peilin.ye@bytedance.com>
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
v1: https://lore.kernel.org/netdev/c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com

(no change since v1)

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

