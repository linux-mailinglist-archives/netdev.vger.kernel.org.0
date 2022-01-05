Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714E7485995
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243782AbiAET4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:56:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243777AbiAET43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:56:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641412588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KRMzzDKvCk0n9/fmg3Sw0HSY9kEMaWLYnTYPkINVTN0=;
        b=MH60ytBIv5Jxdnv+tvFbseDFh1k+9IMWt0UyWogHWQP003hT8rhlVHMegnquXZJ6aUHom1
        ZdQwTXJm4lsLwbFESTQFaRhyrwulhd3CxgeWwZBsXHIN21NzEgaqvlWqUv5bShpRKoSUSr
        SXCR/1XSPNh2bIvOlCSfqOzhWFsN9fE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-dRHm8bOuNIW3zZpbbisEwg-1; Wed, 05 Jan 2022 14:56:27 -0500
X-MC-Unique: dRHm8bOuNIW3zZpbbisEwg-1
Received: by mail-wm1-f69.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so2326999wmq.0
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KRMzzDKvCk0n9/fmg3Sw0HSY9kEMaWLYnTYPkINVTN0=;
        b=bsviS7b4UOC+qUhPjvZKdzlAWe2U1UPmaIZMccop+BT3CxthkNgEKqqIdkF0tzoXSh
         rfiR6gF85KXRbrAYxq/Ydf/P6D9immKakZkFTYfR8fRXAqbWXBKUnupPplQZU4QNuhRC
         TP9klIm/aljiX4UIpAyA8bbtHX1TcU1Bf0R4HR0+0HefN9LB/8vAmvcb3hOQLr60NeHj
         ke56jcIdI13krEzqBbNWDPe8Y4P+GTRUQlpZDHo6DJz2dlJ8DPe9aOkmlvVXRM9sQ3VO
         Qv4adkeCTiSm9xIgL3PXOLgKbz5dS+2XzuS7w0nFbEkSgrz8z1SpmcoVVWYH7HwcjqZl
         Mf8A==
X-Gm-Message-State: AOAM532duYTqWxFSr0BQckV/3TLkPKetgrDCRoPXiPgthefVAI70pzAq
        1QPcCRIGjI3wAa5xRkb5/Jx5lIuct8M1v1PeQ2FqcvCvRoTIV8Dp5ecjCyKHIMpNnscplhyR40k
        KFxEeG/xqi+gZBf7h
X-Received: by 2002:a5d:5049:: with SMTP id h9mr49178591wrt.382.1641412585136;
        Wed, 05 Jan 2022 11:56:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzts8Ykxm9yBWPs7FJMhiWD414YF6mUIeoCDT0AIp1Qu9EXyn8qSyPMDKXV/u1Ayfa7VXKbcg==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr49178584wrt.382.1641412585007;
        Wed, 05 Jan 2022 11:56:25 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id m35sm7448302wms.1.2022.01.05.11.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:56:24 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:56:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>
Subject: [PATCH net 2/4] gre: Don't accidentally set RTO_ONLINK in
 gre_fill_metadata_dst()
Message-ID: <feb518d5c08e14898acda274a01b73f3715eb810.1641407336.git.gnault@redhat.com>
References: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641407336.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mask the ECN bits before initialising ->flowi4_tos. The tunnel key may
have the last ECN bit set, which will interfere with the route lookup
process as ip_route_output_key_hash() interpretes this bit specially
(to restrict the route scope).

Found by code inspection, compile tested only.

Fixes: 962924fa2b7a ("ip_gre: Refactor collect metatdata mode tunnel xmit to ip_md_tunnel_xmit")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/ip_gre.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 2ac2b95c5694..99db2e41ed10 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -604,8 +604,9 @@ static int gre_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 
 	key = &info->key;
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
-			    tunnel_id_to_key32(key->tun_id), key->tos, 0,
-			    skb->mark, skb_get_hash(skb));
+			    tunnel_id_to_key32(key->tun_id),
+			    key->tos & ~INET_ECN_MASK, 0, skb->mark,
+			    skb_get_hash(skb));
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
-- 
2.21.3

