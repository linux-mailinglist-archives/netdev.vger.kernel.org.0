Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE12B20B3
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKMQos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgKMQor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:44:47 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A2CC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 08:44:46 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z2so9005686ilh.11
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 08:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D59DkPB6jM5WZkn6kYVVru0vtD8y/CuhW1DhMYIMK5E=;
        b=J4ufN12NUjeR6mc9ilSD2aML2OCqVLWycddpNi3SS4N6lUlVr78UZqBKGP0ZGn8eeA
         FtZ+gApl2/cNQoofzK1v+91sdFDSaA48usEkhFo9oIgL9KYAtFJ2O6JhsIX3Ij8UJ4er
         csfYIIkFQ9mcw666r3wiPA61MN+vGIc0J/ce8ce7mNtLyE2z25jXqetC8bnTYyQDCNLA
         Iz2G0b49TE/aV8fRJh6+Qs5i7BCbtI60DI+q2cwVixsXOywaQCwpuAyqW6+776tK3HA8
         a1YSYyA/girH19jZEEkge5eP7g+IxuV5vLugp9Fp2f0kycK/bXwZlAUhmZZTyoxsfyP5
         kQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D59DkPB6jM5WZkn6kYVVru0vtD8y/CuhW1DhMYIMK5E=;
        b=EcUluz7GCaSkEEHRUvlMKY0IM3Uh31BbnwQYsNQsu2G2iaIZ/mYRF0AaS0o7BK2SRT
         AujPiVUQMFeCTkc6cF1WPY6H1YPJkV5KjVif67PbsOFioQeeRbzRrBeKBiCmRcKlOe9K
         IOnWfcs8cVmDTd2mLczl9z4b2URWrRce1OVw1NGjtqZ4xU7TaFFIwD9Bk3tro0ihIVNZ
         JbL+brto5kKtbJR1V81sgahLkxMOd6cvWOpH0tG+mNIOJ3Wl8qbQiAel3YVevtn9dXqa
         RpuWNueIu7aPfjx7cwQeVdHi9LNz4+ZW/gkMy4WnFbeO/mCpAit2XGp1r/Isqu86HmP2
         BESw==
X-Gm-Message-State: AOAM5327M7Xy7v9xa4wqTHDCNLfkW0oZ9AAoosvzEprBfOQ7jf9Nhbbm
        +wKJ5jLcphanTkT/VKd8iQU=
X-Google-Smtp-Source: ABdhPJzVQ7nsAF3celEq8EmdaVPkY4xddt+aP/XDhXHdm1enSuypSk/glCzdHow/VR5UuzrNtBjBUQ==
X-Received: by 2002:a92:c64b:: with SMTP id 11mr567530ill.224.1605285880577;
        Fri, 13 Nov 2020 08:44:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id i16sm4691258ioh.30.2020.11.13.08.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:44:40 -0800 (PST)
Subject: Re: [PATCH v2] IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20201113085517.GA1307262@tws>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <44d5ba9e-999d-85c3-38c9-e33e2efbeed9@gmail.com>
Date:   Fri, 13 Nov 2020 09:44:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201113085517.GA1307262@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 1:55 AM, Oliver Herms wrote:
> This patch adds an IPv4 routes encapsulation attribute
> to the result of netlink RTM_GETROUTE requests
> (e.g. ip route get 192.0.2.1).
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv4/route.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 1d7076b78e63..0fbb4adee3d4 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2860,6 +2860,9 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  	if (rt->dst.dev &&
>  	    nla_put_u32(skb, RTA_OIF, rt->dst.dev->ifindex))
>  		goto nla_put_failure;
> +	if (rt->dst.lwtstate &&
> +	    lwtunnel_fill_encap(skb, rt->dst.lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
> +		goto nla_put_failure;
>  #ifdef CONFIG_IP_ROUTE_CLASSID
>  	if (rt->dst.tclassid &&
>  	    nla_put_u32(skb, RTA_FLOW, rt->dst.tclassid))
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

