Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219755EF638
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiI2NQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiI2NQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7C81231F2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664457406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgrINOfcxeJJIUlMnY1pAPSmuM/+JURmRQNsIh0o73s=;
        b=h9RsqEKS/KrfpOn5qE2Oop/LLIA5+Rdfi2AwDlXyyfaPJ799Jyb09myL+ioy9+uKpp/JMB
        karkKopCGDKUq15juNhKFp+kHAc4fbdSwimMtR7YLEktTn2d+H7HpCiRNs6piJMEuZlTwN
        lE88x49AOiD5rPcq9CGKwmeBjQwSLbU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-326-KxgcDVXsOD2xQnkEeiF1mQ-1; Thu, 29 Sep 2022 09:16:44 -0400
X-MC-Unique: KxgcDVXsOD2xQnkEeiF1mQ-1
Received: by mail-wm1-f71.google.com with SMTP id r9-20020a1c4409000000b003b3f017f259so655736wma.3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date;
        bh=rgrINOfcxeJJIUlMnY1pAPSmuM/+JURmRQNsIh0o73s=;
        b=AGNcvUxF/+d66JXM5IPeL5Oy3uMLluqaxI4jcCuJcnwrwEomCnOmYcXtVIAH4iXe4x
         5ygr8aA31+7fHD0ILfzIUnl03bOZm3dlVlS8brBQkLBsNAB/dKGxQCjmkT8he8MSiywD
         ghC8HPN4wd0LUQZuFu1d/0bJED081pykFK56rWAkFLAc90RQ/apN2fSnErJtm9sp9Ba3
         wClZ21SPjenv4mVla5Sg9xAAuF597sk4eQBNxvxs1IRVTo+SB1X2wJf4lXK6Grs61d/2
         dSctw7+EUiYlcuDVV+rGF2Jn5mKGa7Xni2hsQH4HH47qbOTmKg5mw+2dMixVd7B6cGuL
         eZ/w==
X-Gm-Message-State: ACrzQf0D59lo8Dip3JHr+VQF9yckITYVB7x30oyaPWBm33zOsjdLVEaF
        fvMiIRwzHDDw26B8WzrUahqvAGb4k3fnGKxxPqAPLfpyDWQg8gbAk2vQMSf7NU11k65LHa9X0lt
        cxj2Ko8B2y25OqZEt
X-Received: by 2002:a5d:64c2:0:b0:228:cb2b:f38d with SMTP id f2-20020a5d64c2000000b00228cb2bf38dmr2312856wri.491.1664457403737;
        Thu, 29 Sep 2022 06:16:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5C/Vml7IotNi9OWe2Z2QTivUP+8cFzDlg/wmCcz1IjLDXElHvAWMJmdai3Erz+Y/IQN9UkXw==
X-Received: by 2002:a5d:64c2:0:b0:228:cb2b:f38d with SMTP id f2-20020a5d64c2000000b00228cb2bf38dmr2312833wri.491.1664457403480;
        Thu, 29 Sep 2022 06:16:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003b4931eb435sm4827360wmq.26.2022.09.29.06.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 06:16:42 -0700 (PDT)
Message-ID: <432c0ab0943320affa092d93868973c7c9b060b8.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] net: Add helper function to parse
 netlink msg of ip_tunnel_parm
From:   Paolo Abeni <pabeni@redhat.com>
To:     Liu Jian <liujian56@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Date:   Thu, 29 Sep 2022 15:16:41 +0200
In-Reply-To: <20220928033917.281937-3-liujian56@huawei.com>
References: <20220928033917.281937-1-liujian56@huawei.com>
         <20220928033917.281937-3-liujian56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-28 at 11:39 +0800, Liu Jian wrote:
> Add ip_tunnel_netlink_parms to parse netlink msg of ip_tunnel_parm.
> Reduces duplicate code, no actual functional changes.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: Move the implementation of the helper function to ip_tunnel_core.c
>  include/net/ip_tunnels.h  |  3 +++
>  net/ipv4/ip_tunnel_core.c | 32 ++++++++++++++++++++++++++++++++
>  net/ipv4/ipip.c           | 24 +-----------------------
>  net/ipv6/sit.c            | 27 +--------------------------
>  4 files changed, 37 insertions(+), 49 deletions(-)
> 
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 51da2957cf48..fca357679816 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -305,6 +305,9 @@ void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
>  bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
>  				   struct ip_tunnel_encap *encap);
>  
> +void ip_tunnel_netlink_parms(struct nlattr *data[],
> +			     struct ip_tunnel_parm *parms);
> +
>  extern const struct header_ops ip_tunnel_header_ops;
>  __be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
>  
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 526e6a52a973..1e1217e87885 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -1114,3 +1114,35 @@ bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
>  	return ret;
>  }
>  EXPORT_SYMBOL(ip_tunnel_netlink_encap_parms);
> +
> +void ip_tunnel_netlink_parms(struct nlattr *data[],
> +			     struct ip_tunnel_parm *parms)
> +{
> +	if (data[IFLA_IPTUN_LINK])
> +		parms->link = nla_get_u32(data[IFLA_IPTUN_LINK]);
> +
> +	if (data[IFLA_IPTUN_LOCAL])
> +		parms->iph.saddr = nla_get_be32(data[IFLA_IPTUN_LOCAL]);
> +
> +	if (data[IFLA_IPTUN_REMOTE])
> +		parms->iph.daddr = nla_get_be32(data[IFLA_IPTUN_REMOTE]);
> +
> +	if (data[IFLA_IPTUN_TTL]) {
> +		parms->iph.ttl = nla_get_u8(data[IFLA_IPTUN_TTL]);
> +		if (parms->iph.ttl)
> +			parms->iph.frag_off = htons(IP_DF);
> +	}
> +
> +	if (data[IFLA_IPTUN_TOS])
> +		parms->iph.tos = nla_get_u8(data[IFLA_IPTUN_TOS]);
> +
> +	if (!data[IFLA_IPTUN_PMTUDISC] || nla_get_u8(data[IFLA_IPTUN_PMTUDISC]))
> +		parms->iph.frag_off = htons(IP_DF);
> +
> +	if (data[IFLA_IPTUN_FLAGS])
> +		parms->i_flags = nla_get_be16(data[IFLA_IPTUN_FLAGS]);
> +
> +	if (data[IFLA_IPTUN_PROTO])
> +		parms->iph.protocol = nla_get_u8(data[IFLA_IPTUN_PROTO]);
> +}
> +EXPORT_SYMBOL(ip_tunnel_netlink_parms);

The same here, I think it should be EXPORT_SYMBOL_GPL()

Thanks,

Paolo

