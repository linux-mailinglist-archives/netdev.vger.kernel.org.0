Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5B195D58
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgC0SPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:15:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54417 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0SPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:15:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id c81so12402528wmd.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=821/BnFfXuS61JTCsAKxyDA/PtisxC4yGBAsoD9Fu9g=;
        b=Gqp8t++I3KT6aNj8GeixHis4fBrV8MPe7hCb1jLAWAU+2mls2mYYkA/ul6U7Yw9WNH
         NhbLdo3NiwxmMkxAdIdkaOg89rBYyvIacCCTuJXUkwZUwX432AqcKMpypXZg8gf+BrCu
         wDu9GQx9aW2gLSYqQUN2H1bjToXDGLFGq98xPw+Z9OPSbrULfSprggZE5JFVjRXPDUyt
         lS/DF+Iltg/xj3eyi5ZZ+2/GwLaYbeWhXDL1NxqrOUGAhIbEWjWaTsQ5oJp94my7qII0
         dPkX7KVquX3FQSQrT18h7JLQ+2EjLD3zXGbkrQL89ORXYmkSHxqG1FHbM4gaCwe85icR
         tXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=821/BnFfXuS61JTCsAKxyDA/PtisxC4yGBAsoD9Fu9g=;
        b=RMjRxos3IvXs+ioVuSilowsvT2cVz1VQtvg/M4gLaKUV9/QIuB3iZb8pbdht/DCO1R
         /WJNHa9lxkWwJySW9zRj76ItaPsz4NW0f8QkfbLecaAD09SnvspDWRpXPmu7y5G2QlKC
         e6iKy+7xKlceFS1q/tR+pIUKtf/pHDW38pMwV6WJTNXwjgJMkmH9BgfbUVXPdRuwIjMa
         LEzZZnKefLYRvWWWlBCpS2dKA1O+x2blpdBY9v09PdWDSMbho4ylZq6nA6E6pkUphZtu
         XcQQJxBG34/kckN/MYG+no5pSgsvC1uhkLDtgOYdlCrDdWmEVKkaDiOXbjDa6Yme0j6D
         dtyQ==
X-Gm-Message-State: ANhLgQ2479QiIvTfx8d4h97YnhAtueexRxG/bzM5ZbyakSbrde4QTq0n
        cV8DZCPBNtD/mbh/DJbywK+jFseb7qI=
X-Google-Smtp-Source: ADFU+vtPJh1XcURHd263QSPoq32B7KzIcdrGaaj3E6YaMXZsERt4oIVurZHcB0bBCRnFtNxeXjjhBQ==
X-Received: by 2002:a1c:e914:: with SMTP id q20mr6482445wmc.105.1585332937387;
        Fri, 27 Mar 2020 11:15:37 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:2428:7eec:ef62:1393? ([2a01:e0a:410:bb00:2428:7eec:ef62:1393])
        by smtp.gmail.com with ESMTPSA id n1sm9166769wrj.77.2020.03.27.11.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 11:15:36 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 net] net, ip_tunnel: fix interface lookup with no key
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <20200325150304.5506-1-w.dauchy@criteo.com>
 <20200327145444.61875-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <13f3cb64-4e5a-7792-91b6-795c89903fe3@6wind.com>
Date:   Fri, 27 Mar 2020 19:15:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200327145444.61875-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/03/2020 à 15:54, William Dauchy a écrit :
> when creating a new ipip interface with no local/remote configuration,
> the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
> match the new interface (only possible match being fallback or metada
> case interface); e.g: `ip link add tunl1 type ipip dev eth0`
> 
> To fix this case, adding a flag check before the key comparison so we
> permit to match an interface with no local/remote config; it also avoids
> breaking possible userland tools relying on TUNNEL_NO_KEY flag and
> uninitialised key.
> 
> context being on my side, I'm creating an extra ipip interface attached
> to the physical one, and moving it to a dedicated namespace.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
> ---
>  net/ipv4/ip_tunnel.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 74e1d964a615..b30485615426 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -142,11 +142,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  			cand = t;
>  	}
>  
> -	if (flags & TUNNEL_NO_KEY)
> -		goto skip_key_lookup;
> -
>  	hlist_for_each_entry_rcu(t, head, hash_node) {
> -		if (t->parms.i_key != key ||
> +		if ((flags & TUNNEL_KEY && t->parms.i_key != key) ||
I saw this flag, and frankly, having a flag named TUNNEL_KEY and another named
TUNNEL_NO_KEY is an horrible API design.

But I prefer to be conservative and avoid (ugly) surprise, thus I think it's
better to keep TUNNEL_NO_KEY.


Regards,
Nicolas
