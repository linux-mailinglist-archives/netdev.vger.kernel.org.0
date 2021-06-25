Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A343B447F
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFYNfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhFYNfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624627989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wcBFLIEnFRlhUYdUFMk5RzbFnCLcUMnL7WWScaTtUEs=;
        b=F6D+pRxps01Px6UFsLaVfgG8Aj/Tx3BhLX6eIs8rcwVV9Ko8omw3GdxCQNU0sMXs8tLo7y
        xgw4kRP7/ta0+hW4IgK2NK63c3dQRbDqU2L+jrew3uUsjkdBgk9eqU4vwN8fEo/px9q4NL
        uSiWw6yDaYQIIH3QJbvq4/NEZcTSvOA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-MV_gSHQwMMG-5vo04EwhOA-1; Fri, 25 Jun 2021 09:33:08 -0400
X-MC-Unique: MV_gSHQwMMG-5vo04EwhOA-1
Received: by mail-wm1-f71.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so4224039wmq.0
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wcBFLIEnFRlhUYdUFMk5RzbFnCLcUMnL7WWScaTtUEs=;
        b=JrRU0vidZK+R4PWk7vCEVbUq5zNQF2zXASpX99gqXgOwo40elGcxmbYawJzDxzMxjw
         kIm3g56LTLcfMevhqntD3nb+iboJfPz1Bdf6Zx6y+ftsdBzOfqB9pyunCLF9R5murW/D
         NPYdnTT1cl52ZMUeWzCywZt0TQOSAYXVkmcMYh1VEnL6oXRx4KrcG1dwmwz3wjfdR4Lm
         9C/kJThUWJL/fQ7M8byGPeO0nGSKH9jlZk9i5VP0+arXtHEUgxwTcQkfJ3bVg5LiQWkM
         lToPxJc1RxjeyubxtMOGHdlN0x38SN25KX94y/CVTpPyalt7u7TPk5oBMgt8D53/zlJM
         imjw==
X-Gm-Message-State: AOAM530bfS1l6V8hY03TQW111ATjrtqW8z7CC/mnAiuIFmMpkgyNroHM
        lVknqUprYr+Xz8oCFKdeGJYFd/XT5JgzcF/6m4b8zOFQEPA1JKYUSQCNAW2o315KRqx2ZnMrtc+
        hT2swDAyolrIpSqiD
X-Received: by 2002:a05:600c:3791:: with SMTP id o17mr10943886wmr.187.1624627987085;
        Fri, 25 Jun 2021 06:33:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYHRhgr2JZcHzYrT6lYYqjt4DOLy1JOo/IQgoAZ/fi92SsagIuYPb8hj64/xRrsr05pU7sqg==
X-Received: by 2002:a05:600c:3791:: with SMTP id o17mr10943862wmr.187.1624627986928;
        Fri, 25 Jun 2021 06:33:06 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b18sm7252874wrx.45.2021.06.25.06.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:06 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:04 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 2/6] ipip: allow redirecting ipip and mplsip packets
 to eth devices
Message-ID: <d92a8e72ce9f659c9ef981873bea9995cfac9550.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though ipip transports IPv4 or MPLS packets, it needs to reset the
mac_header pointer, so that other parts of the stack don't mistakenly
access the outer header after the packet has been decapsulated.

This allows to push an Ethernet header to ipip or mplsip packets and
redirect them to an Ethernet device:

  $ tc filter add dev ipip0 ingress matchall         \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Without this patch, push_eth refuses to add an ethernet header because
the skb appears to already have a MAC header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/ipip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index d5bfa087c23a..266c65577ba6 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -242,6 +242,8 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			if (!tun_dst)
 				return 0;
 		}
+		skb_reset_mac_header(skb);
+
 		return ip_tunnel_rcv(tunnel, skb, tpi, tun_dst, log_ecn_error);
 	}
 
-- 
2.21.3

