Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03DC293366
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbgJTC5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390920AbgJTC5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 22:57:36 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE93C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:57:34 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p15so848685ioh.0
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Mf9+z0Z4bxUiarUaqyzhERSZRBw14WM1/PZZtTnseaE=;
        b=L2n4eQYUJC4eqgVlqTqU4MpZUMAzzpGnuoSNN2f3T3FUVMaQCGrePx6ZKgYkVuI5Tz
         O5xeU4aEDzKs4CmGQG7duGUNBZRvAqXopmgeplRO4uAmuqTzQ0X8TXPwHNQvuz7dvCW2
         kaYEYhjbH3m0/DEqgXySQkX6Vj0SB1I25Pb39w7VNIUfrcPIwVqbyVWQfJpQeK3/aWlz
         f67S43Re8xaKoFv3A9BTnTyvdmHbi86CHnpFjNTxhdANV14OCVtQ8ZdosqDs1oq5+nXr
         Hf1JbFneZ0cc8KJMOsoY/TNgATfwJbH4usaGmq1pvgEUXNjYmSQ48LssqzcsSR/MqIBi
         YBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mf9+z0Z4bxUiarUaqyzhERSZRBw14WM1/PZZtTnseaE=;
        b=GSY3us9mBWhl0uchqbpk1VFg2Ob40zYeTQ3OgLhpAfOKTjTAszHig3gTUCraG3Ib9V
         KRpNdZJ3/vW2gckWi6KxQyMTzlB0iHjYa+H0Pxru8lUQWweVQ/v9vIY/Kv/jTYg1Mf54
         M565hBEClH+GgjL950n9j1ENBffi+6GYjR3od/IaK9avOckxLVuvq8ZZqJXVfE7V4fPQ
         KPAWMSa5kt5GH4Ko1RzKjuJ9/e+2j98iq0j1BKQ0KQsocPdVfvCmQwAurTvxRRa+RPuB
         fNGD/htmvl+zOJ7ceeoPvNIlf6itWuWjblTB14hg58HZoBgrLMz8DtKhdMkwr1ka/9GE
         YHMw==
X-Gm-Message-State: AOAM533MqztT7vyuxY+caLW8/9Chionfo/CpjIRqHmDRNUfpZFrguBzZ
        OYK18U6jJGJ5y5QISzbuH/c=
X-Google-Smtp-Source: ABdhPJwh0cvAICF7wB3qUX0kfNTwY0OUWUIvQfdqM0dEpja8YP0s/8xkB0BWorRFvMfjTWonuxenIA==
X-Received: by 2002:a05:6602:1610:: with SMTP id x16mr655942iow.142.1603162654246;
        Mon, 19 Oct 2020 19:57:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id d26sm555716ill.83.2020.10.19.19.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 19:57:33 -0700 (PDT)
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
To:     Vincent Bernat <vincent@bernat.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
References: <20201017125011.2655391-1-vincent@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <683d467d-1d3e-dafa-f962-a52752ef6fd4@gmail.com>
Date:   Mon, 19 Oct 2020 20:57:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201017125011.2655391-1-vincent@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ fix Andy's address ]

On 10/17/20 6:50 AM, Vincent Bernat wrote:
> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
> ignores a route whose interface is down. It is provided as a
> per-interface sysctl. However, while a "all" variant is exposed, it
> was a noop since it was never evaluated. We use the usual "or" logic
> for this kind of sysctls.
> 
> Tested with:
> 
>     ip link add type veth # veth0 + veth1
>     ip link add type veth # veth1 + veth2
>     ip link set up dev veth0
>     ip link set up dev veth1 # link-status paired with veth0
>     ip link set up dev veth2
>     ip link set up dev veth3 # link-status paired with veth2
> 
>     # First available path
>     ip -4 addr add 203.0.113.${uts#H}/24 dev veth0
>     ip -6 addr add 2001:db8:1::${uts#H}/64 dev veth0
> 
>     # Second available path
>     ip -4 addr add 192.0.2.${uts#H}/24 dev veth2
>     ip -6 addr add 2001:db8:2::${uts#H}/64 dev veth2
> 
>     # More specific route through first path
>     ip -4 route add 198.51.100.0/25 via 203.0.113.254 # via veth0
>     ip -6 route add 2001:db8:3::/56 via 2001:db8:1::ff # via veth0
> 
>     # Less specific route through second path
>     ip -4 route add 198.51.100.0/24 via 192.0.2.254 # via veth2
>     ip -6 route add 2001:db8:3::/48 via 2001:db8:2::ff # via veth2
> 
>     # H1: enable on "all"
>     # H2: enable on "veth0"
>     for v in ipv4 ipv6; do
>       case $uts in
>         H1)
>           sysctl -qw net.${v}.conf.all.ignore_routes_with_linkdown=1
>           ;;
>         H2)
>           sysctl -qw net.${v}.conf.veth0.ignore_routes_with_linkdown=1
>           ;;
>       esac
>     done
> 
>     set -xe
>     # When veth0 is up, best route is through veth0
>     ip -o route get 198.51.100.1 | grep -Fw veth0
>     ip -o route get 2001:db8:3::1 | grep -Fw veth0
> 
>     # When veth0 is down, best route should be through veth2 on H1/H2,
>     # but on veth0 on H2
>     ip link set down dev veth1 # down veth0
>     ip route show
>     [ $uts != H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth0
>     [ $uts != H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth0
>     [ $uts = H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth2
>     [ $uts = H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth2
> 
> Without this patch, the two last lines would fail on H1 (the one using
> the "all" sysctl). With the patch, everything succeeds as expected.
> 
> Also document the sysctl in `ip-sysctl.rst`.
> 
> Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> ---
>  Documentation/networking/ip-sysctl.rst | 3 +++
>  include/linux/inetdevice.h             | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 837d51f9e1fa..fb6e4658fd4f 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1552,6 +1552,9 @@ igmpv3_unsolicited_report_interval - INTEGER
>  
>  	Default: 1000 (1 seconds)
>  
> +ignore_routes_with_linkdown - BOOLEAN
> +        Ignore routes whose link is down when performing a FIB lookup.
> +
>  promote_secondaries - BOOLEAN
>  	When a primary IP address is removed from this interface
>  	promote a corresponding secondary IP address instead of
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 3515ca64e638..3bbcddd22df8 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -126,7 +126,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
>  	  IN_DEV_ORCONF((in_dev), ACCEPT_REDIRECTS)))
>  
>  #define IN_DEV_IGNORE_ROUTES_WITH_LINKDOWN(in_dev) \
> -	IN_DEV_CONF_GET((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
> +	IN_DEV_ORCONF((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
>  
>  #define IN_DEV_ARPFILTER(in_dev)	IN_DEV_ORCONF((in_dev), ARPFILTER)
>  #define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_ORCONF((in_dev), ARP_ACCEPT)
> 

