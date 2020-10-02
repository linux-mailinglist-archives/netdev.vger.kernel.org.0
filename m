Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9AE281593
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbgJBOoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:44:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851CEC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:44:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so2130809wrm.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1A9jI+VaPDDVBdITdlgxHOTgNu594Pqaj60IZFv19HE=;
        b=CofEcvHaXOlbLxVf0nj6/tdvhTDeaxNstnO4p6c7u/0f1WQOM4W5j2iO2TXcZm+xT5
         NoHP7qPnpBShI2FyR7z4OWwc7AVb31GvDbDKtNSdvOky2IxCBtVJyyF2sRUiHjF53Efv
         5dZwXufsJY5IuD2a4FU00rcXFh3pA6Ro3kONP7z/AZIYwLh/tYl+W5/Mwo0FfVhjf+FI
         8WMU1An5N9MFtr8CHKaWQJ4eBLebYCdGFZ8L0cwlpc1GJsG2o4SPly1G1/zwPivMQ9AX
         VEEJERvfdZaPWAus05HuJAh6uQRuyvitI80DqLuSRK1vwDcwzLKe9BvsDiAWJDqswE1x
         yJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1A9jI+VaPDDVBdITdlgxHOTgNu594Pqaj60IZFv19HE=;
        b=P1yNj2cxHukpBe8OjeBkcurarNKF5XqncyvPJCjvwoZ8Nc6aFgkDLJwZ/Qn6a3koyd
         RFKfgwufDVGWso3yMHz+jYbnOOWkP8ifeodeG1/L7DTwMkgiOqBhtcNzpTLXV/0E3sn7
         K9E28aqhxyrekEebEQZXX3ijW4xb1H0Xa0MY/Pl/4TbFQHSskW7cUiHXcQbW2V9jdWQC
         c5Gqxb6NJhObBQBb40B+dYvfoWWT6NB6Ljorm3uxrWNb6IbfZXhBhfak2fhUJqeBSlAv
         VLvCsGJcRSuxGAgcwU86q6abMYm6CBoGmBlciyb5kizXXdpUZ+i9fNqlOBIRi3vkK1ZM
         pasg==
X-Gm-Message-State: AOAM533HTp9PrhUA1827FFLDmjdOlBWi3tUaBjkWMXD/+9LK35vKf+t1
        +BploTDw+pwy/xMvIvsQbNJXs2FhiWRwkQ==
X-Google-Smtp-Source: ABdhPJzmFwN1ZfNfwfse5Vzloa5mkkb5OuWoV+ncB7yyRGpD15CuT1T6WiRE0dIOMOsqqE1vjgZAhA==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr3427157wrc.193.1601649891663;
        Fri, 02 Oct 2020 07:44:51 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:e5bb:a207:757e:7c39? ([2a01:e0a:410:bb00:e5bb:a207:757e:7c39])
        by smtp.gmail.com with ESMTPSA id t16sm2267033wmi.18.2020.10.02.07.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 07:44:51 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
Date:   Fri, 2 Oct 2020 16:44:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730054130.16923-11-steffen.klassert@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/07/2020 à 07:41, Steffen Klassert a écrit :
> From: Xin Long <lucien.xin@gmail.com>
> 
> Similar to ip6_vti, IP6IP6 and IP6IP tunnels processing can easily
> be done with .cb_handler for xfrm interface.
> 
> v1->v2:
>   - no change.
> v2-v3:
>   - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
>     the build error, reported by kbuild test robot.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---

This patch broke standard IP tunnels. With this setup:
+ ip link set ntfp2 up
+ ip addr add 10.125.0.2/24 dev ntfp2
+ ip tunnel add tun1 mode ipip ttl 64 local 10.125.0.2 remote 10.125.0.1 dev ntfp2
+ ip addr add 192.168.0.2/32 peer 192.168.0.1/32 dev tun1
+ ip link set dev tun1 up

incoming packets are dropped:
$ cat /proc/net/xfrm_stat
...
XfrmInNoStates                  31
...

Xin, can you have a look?

>  net/xfrm/xfrm_interface.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index c407ecbc5d46..b9ef496d3d7c 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -798,6 +798,26 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
>  	.priority	=	10,
>  };
>  
> +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> +static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
> +{
> +	const xfrm_address_t *saddr;
> +	__be32 spi;
> +
> +	saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
> +	spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
> +
> +	return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
> +}
> +
> +static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
> +	.handler	=	xfrmi6_rcv_tunnel,
> +	.cb_handler	=	xfrmi_rcv_cb,
> +	.err_handler	=	xfrmi6_err,
> +	.priority	=	-1,
> +};
> +#endif
> +
>  static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
>  	.handler	=	xfrm4_rcv,
>  	.input_handler	=	xfrm_input,
> @@ -866,9 +886,23 @@ static int __init xfrmi6_init(void)
>  	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
>  	if (err < 0)
>  		goto xfrm_proto_comp_failed;
> +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> +	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
> +	if (err < 0)
> +		goto xfrm_tunnel_ipv6_failed;
> +	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
> +	if (err < 0)
> +		goto xfrm_tunnel_ip6ip_failed;
> +#endif
>  
>  	return 0;
>  
> +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> +xfrm_tunnel_ip6ip_failed:
> +	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
> +xfrm_tunnel_ipv6_failed:
> +	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
> +#endif
>  xfrm_proto_comp_failed:
>  	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
>  xfrm_proto_ah_failed:
> @@ -879,6 +913,10 @@ static int __init xfrmi6_init(void)
>  
>  static void xfrmi6_fini(void)
>  {
> +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> +	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
> +	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
> +#endif
>  	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
>  	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
>  	xfrm6_protocol_deregister(&xfrmi_esp6_protocol, IPPROTO_ESP);
> 
