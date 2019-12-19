Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA1E12686B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfLSRtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:49:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbfLSRtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576777780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s+ovPJ+hvapwys+/gMM51YuhqSLMiuF3aJhHrRXS7YY=;
        b=MY58kUFXkaiLgSZb3gOLAnbB6e1EdCP0FAB5aBuveaYeH2KdvCPRD4b71hj0l9FUtITYow
        YyReoakuP1yJzrGR7hIGvn5HqbxWFIrZpDpE9BKf9jaEZDTk8sP20Y48PjHJk3HBYvpp7v
        rcW8GsMaN8sefTB8szsyJCeR1a1rMvk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-6hbWjCm3NUKwYWuFlfa8MA-1; Thu, 19 Dec 2019 12:49:38 -0500
X-MC-Unique: 6hbWjCm3NUKwYWuFlfa8MA-1
Received: by mail-wr1-f71.google.com with SMTP id b13so2629138wrx.22
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:49:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+ovPJ+hvapwys+/gMM51YuhqSLMiuF3aJhHrRXS7YY=;
        b=ip8ngfFkB3ENuwWzEEzHcgW7yMjPSE5Ey0CE80qpECYNuoNh1OmQi3Clu3oVpv+Wtz
         MK73qUvtmexXafLvbZ2oQUV1KxFGaKV/HA9yqLv0j51lhh89tWDIK+k2w97M8oqJQbWk
         wvudVS1259iLb5qQCTXfLfPz6eojvgZssMBhKtvZYSGhz/mQL1Y6gSJ6ZGTUBP/Qw1GP
         CEed8S481hE49sf/FWQo6CPmMsbsC2XJ7PO01UKRnP8B/E7lrzSDn/d4DA73GkUWxoiF
         WYMiFKnPxJaWATeC3z5z+G/w4GVS18YANMVUmJ+iYJl5tVdoXFMqigtr/0uIqzIeA6gs
         kXgw==
X-Gm-Message-State: APjAAAUv291LNVgCfDCRASIIvedacbkTepvhfxkpOlBNliIxl1HydisI
        S802Ze5KHyviSZaCO4PTr12wnclk0xeo6SsrjmtLiXxp196yFo7RyDFXGdC+S1Yz8OBwZ/B3Zo7
        4JcRZXuUngGG2ZkcZ
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr10345789wrn.251.1576777777753;
        Thu, 19 Dec 2019 09:49:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7+fh+2k3iZKBzT1mog4ewMVa4J0vVG724KQDTW+uGrsTq3tdxOjOZ6P0eQj+DM75Jej4Seg==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr10345774wrn.251.1576777777588;
        Thu, 19 Dec 2019 09:49:37 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id p18sm7132240wmb.8.2019.12.19.09.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 09:49:37 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:49:35 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 8/8] net/dst: do not confirm neighbor for vxlan
 and geneve pmtu update
Message-ID: <20191219174935.GB14566@linux.home>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191218115313.19352-9-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218115313.19352-9-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 07:53:13PM +0800, Hangbin Liu wrote:
> When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> we should not call dst_confirm_neigh() as there is no two-way communication.
> 
> So disable the neigh confirm for vxlan and geneve pmtu update.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/net/dst.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 208e7c0c89d8..626cf614ad86 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -535,7 +535,7 @@ static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
>  	u32 encap_mtu = dst_mtu(encap_dst);
>  
>  	if (skb->len > encap_mtu - headroom)
> -		skb_dst_update_pmtu(skb, encap_mtu - headroom);
> +		skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom);
>  }
>  

Fixes: a93bf0ff4490 ("vxlan: update skb dst pmtu on tx path")
Fixes: 52a589d51f10 ("geneve: update skb dst pmtu on tx path")

