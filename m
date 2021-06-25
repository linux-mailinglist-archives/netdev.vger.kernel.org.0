Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71B73B4482
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhFYNfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231710AbhFYNfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624628002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nv53atI+/3xq82pcVecJPgLExtd+IzeYGeaDiAVjnpY=;
        b=B0dTb2PtWVcFC42XpaqtKSwtEM7yoMNjQAsvooZ+DTs+kVYQY+zENy9ut4ktY6K6A3zAAe
        MPolh4bvLkLhMbr0NJ2Q4lcrPSyJZ6VfN3/f5ceC2gXSkVZUDV6zb2gYcNhjHnepibH4IN
        u0mnz4c2aY3CWsqUiKjgxFQfI0KtQQ4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-wFVvX7hiOfOExMJ7yf3EfA-1; Fri, 25 Jun 2021 09:33:21 -0400
X-MC-Unique: wFVvX7hiOfOExMJ7yf3EfA-1
Received: by mail-wr1-f70.google.com with SMTP id l6-20020a0560000226b029011a80413b4fso3484500wrz.23
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nv53atI+/3xq82pcVecJPgLExtd+IzeYGeaDiAVjnpY=;
        b=pFyebMhanPaeegds+ViMu1B1JtlMmhu8HQPpNb2pRTqdzWkASaiXxt/9cVsyPBMvgM
         jPbcXTgXrAQtV94S7KIW3obm4An5Kx/FXl3AERr7VBXDEZ9g4r53THzlo1vPeiGC8kqL
         plLkvH4NIZO+By3F9m4pXAQ/hU1B6XenhETYccjDpNJIEJEt0GLPznmQ3FyfMBbgNda/
         /9EH6tXT8Yfhfe1s4s27KtKs0ynKSDof/2Z353xYXCXQqQnm6XuSPYOAovrgLx+nqta/
         dMZAuEYzrD0IhsmklT9ZxZjOYdKMSz3Wfhb30NWbwvyrMKTtIZhTt+8oyB7xpIRW3/xO
         DaiA==
X-Gm-Message-State: AOAM531MYADoo4Wg1RlcCuac19GUVi5sFnpfepiGnw7qeuyaUCFUklet
        QCOGliqXSf+hhW48Ws3tO9JrBQ07jVCFSgwfrNSPl6r3tDro7Q6YQ7eo+3riuHqdlBcHmi58C6H
        QvRb4sd8vZbYDgvne
X-Received: by 2002:a05:6000:1245:: with SMTP id j5mr10967358wrx.371.1624628000216;
        Fri, 25 Jun 2021 06:33:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymH3WMVfjoPhIqwGJfKuPDEEh38Z+WK7RGQyNJFzedbPufv2FEYPEwbiYNkhvVxPhQI2VA2Q==
X-Received: by 2002:a05:6000:1245:: with SMTP id j5mr10967345wrx.371.1624628000103;
        Fri, 25 Jun 2021 06:33:20 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id y66sm5769906wmy.39.2021.06.25.06.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:19 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:17 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tom Herbert <tom@herbertland.com>
Subject: [PATCH net-next 5/6] ip6_tunnel: allow redirecting ip6gre and ipxip6
 packets to eth devices
Message-ID: <0d7669824973cb3825c00553ca912997e4a1f2be.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset the mac_header pointer even when the tunnel transports only L3
data (in the ARPHRD_ETHER case, this is already done by eth_type_trans).
This prevents other parts of the stack from mistakenly accessing the
outer header after the packet has been decapsulated.

In practice, this allows to push an Ethernet header to ipip6, ip6ip6,
mplsip6 or ip6gre packets and redirect them to an Ethernet device:

  $ tc filter add dev ip6tnl0 ingress matchall       \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Without this patch, push_eth refuses to add an ethernet header because
the skb appears to already have a MAC header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv6/ip6_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 288bafded998..0b8a38687ce4 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -837,6 +837,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
 	} else {
 		skb->dev = tunnel->dev;
+		skb_reset_mac_header(skb);
 	}
 
 	skb_reset_network_header(skb);
-- 
2.21.3

