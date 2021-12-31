Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3204824A5
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhLaPvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLaPvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 10:51:23 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EFC061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 07:51:22 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s1so56587319wra.6
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 07:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjM5whpDKnB20qr1HtfNc4eWFSkoRcQB9gRpqMMWsyc=;
        b=Mz8PuWffaA7WvDQhkie4aQwA+wvUGfSJTHyuifl0UbJP0S6RaUPLrffNipnkiqMeIE
         GTIHKZuITWf+mAm50xfGHqfBonW0Gye8II5cYr5IpIqSWmzcA1D2fQ4Zzy/iuUAQYGGf
         wAial9YM274olnjQcr0cZHWlacOSet+RaamZIBrYjhyZB53gRP2CqaC5JEfx2HwmceSW
         EAJCsP4mr+EGqpLS40RjwpQ3iH3IiNAjuRP+XDfa2y3Z55L93EQkehApQ9z1xKTGMqcZ
         zsDb/fTFxUrsFGqP1+I6wMq0SI9uOw/fwmWbZKDlSpqVACip0RpK5sDxPtBTpMbm86UE
         LxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZjM5whpDKnB20qr1HtfNc4eWFSkoRcQB9gRpqMMWsyc=;
        b=x48QhhtNP6XfRbVGhHDcfVzqSML3TRqMiW80dR4EzRbwpTHc5md38kWA+y7i9d401G
         YiOgq2xqz8Vekf1MpJDiTsoUZ54zk8j1Fw3m9/Y1g+X98lx4KmAXi7wFyOXOWAYghoNl
         P3xrFeSDQo/KsQyPl4g8zZIiyFO0NQl/wVtVJL6s1A8mil5ygjbKKIZRUlmWMNm8gP+T
         qQMI4icjgEdxib/8kY65rfIDw97ltH9zI33jK6+hXRgnOFysoOqKpx9oM8PV4CuLhpRg
         MFElyXjTzpQed90+SDx1MA/yx1MPl9VQ/FTvd9cyM1NGRE+iVQcFdeTMPdzX1uJtYcV5
         vVlA==
X-Gm-Message-State: AOAM530Ko+uW3yQmV9J5Jx46TDgeTuxoFXHDtcQ0z8wDU9Fdn0WSQy8a
        CcSk043KP10E079Z2kzK9HF+tw==
X-Google-Smtp-Source: ABdhPJzaDsg6lomdgXKs9oFYrDVRZSU7bZRvgFzSVBmzYsntB2y6Mho7r73yIEFfv2GXc/RIx6MhNQ==
X-Received: by 2002:adf:82f6:: with SMTP id 109mr29565495wrc.169.1640965880728;
        Fri, 31 Dec 2021 07:51:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:5dbe:5ed1:d547:31e6? ([2a01:e0a:b41:c160:5dbe:5ed1:d547:31e6])
        by smtp.gmail.com with ESMTPSA id o10sm18044752wmq.31.2021.12.31.07.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Dec 2021 07:51:20 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 4/5] ipv6: Check attribute length for RTA_GATEWAY when
 deleting multipath route
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     idosch@idosch.org, Roopa Prabhu <roopa@nvidia.com>
References: <20211231003635.91219-1-dsahern@kernel.org>
 <20211231003635.91219-5-dsahern@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <4a07b6b0-f414-84db-5689-16901de54460@6wind.com>
Date:   Fri, 31 Dec 2021 16:51:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211231003635.91219-5-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 31/12/2021 à 01:36, David Ahern a écrit :
> Make sure RTA_GATEWAY for IPv6 multipath route has enough bytes to hold
> an IPv6 address.
> 
> Fixes: 6b9ea5a64ed5 ("ipv6: fix multipath route replace error recovery")
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> ---
>  net/ipv6/route.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index d16599c225b8..b311c0bc9983 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5453,7 +5453,11 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
>  
>  			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
>  			if (nla) {
> -				nla_memcpy(&r_cfg.fc_gateway, nla, 16);
> +				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
> +							extack);
> +				if (err)
> +					return err;
When ip6_route_del() fails, the loop continue. For consistency, maybr it could
be good to do the same for this error.
