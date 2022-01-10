Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC1489A36
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiAJNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233105AbiAJNnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KRMzzDKvCk0n9/fmg3Sw0HSY9kEMaWLYnTYPkINVTN0=;
        b=EnYThBZPxrUDmqaIkuoPjp7ZPZy9lscegV0rhSlNi3O0vcZyB542xwhPxVYlH+6U3I5DXv
        sqwzi7ZFY4viNq5Ef+LjMWwsXujCY9f5L0pHicmZxqF9u5au44oFzVXc368Svzu3PvvLkz
        axD+UNMv77AT3np/P6LOPfRMa83CZDk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-lv8_HBidN6uAzcZ7Z2p3LQ-1; Mon, 10 Jan 2022 08:43:12 -0500
X-MC-Unique: lv8_HBidN6uAzcZ7Z2p3LQ-1
Received: by mail-wr1-f69.google.com with SMTP id w25-20020adf8bd9000000b001a255212b7cso4138040wra.18
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:43:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KRMzzDKvCk0n9/fmg3Sw0HSY9kEMaWLYnTYPkINVTN0=;
        b=aO+OqG2ak3zO9CqFc3BHDngULbQjQhJQg6KeaezlweMgMErQOcgRDHZHpydXAkLGvV
         7joZrQtMot/A5aiEy4oDuexJt0U2PHgylikOH03+2+yp+mQMFEqOddOUhBwvbd4Q7ovn
         Dfy3m6b7/dQGS1HKtRgnBkXSJZOsVBikKbO707920Tu+2J/j/kanKBJd224W2kCEwfbz
         vElRuTHaZUSnBMDhu0yoAXzc4GPfhhTQwzhOYeYnWmKKyWZunWe67e+uxHkQKpZ4qh08
         +BsiWsrOzI6N0BXF3PPObf30CKt6CLXgB9T5S+D9WYmFrXWG3YQrs7rBiLG7w1dV7d+i
         huiw==
X-Gm-Message-State: AOAM531GAZTStt5ubaDyoGXkRCWZ5fjoY+ej5CzD7+jmkS/tSpJD5YIk
        jKFMCV4syxGEvoA/HbINzGZg+IekKxDSud6VUp+RqSmUjFGlEjAe/hZ/X3E7YqY4hJwRxEJCp1l
        XOz1aW1A1UL4r53CF
X-Received: by 2002:a05:600c:4e46:: with SMTP id e6mr22357214wmq.132.1641822191361;
        Mon, 10 Jan 2022 05:43:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwgPvhtwzMJfslSftacaZiyWZ7tedj9VaxEyhfO0qhSFGkm5wJjTckLirAB6oASbyPWWpr6A==
X-Received: by 2002:a05:600c:4e46:: with SMTP id e6mr22357201wmq.132.1641822191236;
        Mon, 10 Jan 2022 05:43:11 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id d16sm2548307wrq.27.2022.01.10.05.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:43:10 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:43:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>
Subject: [PATCH v2 net 2/4] gre: Don't accidentally set RTO_ONLINK in
 gre_fill_metadata_dst()
Message-ID: <e0a893384e426c2c94de8b2d440b0c6a02da6409.1641821242.git.gnault@redhat.com>
References: <cover.1641821242.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641821242.git.gnault@redhat.com>
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

