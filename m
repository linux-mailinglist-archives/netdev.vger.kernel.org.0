Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F0411DFF8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfLMIxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:53:44 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44785 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMIxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:53:44 -0500
Received: by mail-pj1-f66.google.com with SMTP id w5so903852pjh.11;
        Fri, 13 Dec 2019 00:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qwBaor7Lubd10eEEdff3R/Rpqkjv6eZ1ce5RT40xWpI=;
        b=q2h1WHct6ufcnK2ssdRIgGwjG9VZvYFqIYpBI+X5flj34+q/wQgmEzXu0v5Uuz3WEE
         3QoHqpgqtEZGCMe7Wpm1FW7SUxN9xe3U+iquPlrc0V3E/9z1W+aQ5QTSe7mkrMBMFBIZ
         MWOnmr4WrRJPTiLviC58yPgzft8b858qlsHNyt8B6BaDM83moOdCkniIVl5L+I1D5gvQ
         87qFFUdWoAn2UreX+XVt/gDwwIq5p1Sqb+11E1nbhtpwscUkCtnG+tTLaaAS7+eZNoFm
         GFxO1H6EvijbDIRADnVHSNcfvgmcsQGx5RnucCSj8XXdMWTzL5BGmfaPOP4kBdlQRmN7
         6EOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qwBaor7Lubd10eEEdff3R/Rpqkjv6eZ1ce5RT40xWpI=;
        b=HIJxQE2FYtUiueM6EqxmrfCqurMb70h6P7pBqgwci85WzGSVYnynZGrZcp6zF1zV/b
         cnKAEIsznrZLHAwAhg/gZlRE/e299BloM542/m/ddfTebwGOoM9ATKC38jDFvxDcKX6B
         Hm/DaVX5p4b4yE3vbI8KsU8FPRb3fWTF0efz8UqTNVbYe7JPUhcu3De8Bb9hLsZkJg6h
         DDcIeqYrlJJ2aUEv2tRYCZMUFkN4PVO9y+lnjXPDa2ySrksx+Cp7wXoeG069T8g7Na8U
         Yvulb/8ZNJtjTDSrh7OCWlZn9/0F6TKcx9K/C9UMvn6UbL/tF+8PnNIkBL1rnz06oVDx
         1zmg==
X-Gm-Message-State: APjAAAWrzCM9A1BqRA4rPEv2xllML0Sk+ZT/7WjTY4CBALj2bsGFtTlH
        GX1G3lrRyukOrAtkWyP6l5dHk0c5
X-Google-Smtp-Source: APXvYqw5oLmK3altWs1/lB349zJc7mRm1qdslYmRm+ZHW66kwwO9IttIJ0I4xAfgeHod3BAL226O0w==
X-Received: by 2002:a17:902:74cb:: with SMTP id f11mr14226557plt.139.1576227223331;
        Fri, 13 Dec 2019 00:53:43 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm9578420pgc.10.2019.12.13.00.53.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:42 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 3/5] netfilter: nft_tunnel: also dump ERSPAN_VERSION
Date:   Fri, 13 Dec 2019 16:53:07 +0800
Message-Id: <46a6912e0996a23b79a6d52eaf9ed501a1dab86b.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
 <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not necessary, but it'll be easier to parse in userspace,
also given that other places like act_tunnel_key, cls_flower and
ip_tunnel_core are also doing so.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 6538895..b3a9b10 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -479,6 +479,9 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				 htonl(opts->u.vxlan.gbp)))
 			return -1;
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+				 htonl(opts->u.erspan.version)))
+			return -1;
 		switch (opts->u.erspan.version) {
 		case ERSPAN_VERSION:
 			if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
-- 
2.1.0

