Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAEB1535A9
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBEQy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:54:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42013 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgBEQy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:54:57 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so3591794wrd.9
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3NP1jd/PWu2o3VZGYD8UbdZwy6Kd+7mItBo+9p9VRfA=;
        b=bkW465nUVHIu4dId9QrWVYVAc7bMnz+BB1fYdvb4hPEupsIdh8fmTSVLZLupT222rq
         ZD9Zvy+h2QaAURsIFrnKDKpHz1X6BKnQ27cip8Sj4snz5MSLNOSJ1/GYHbVN66VARZbV
         gq1qgmYnUd2LCa0J5s7Qnx5PYuVK0GmQdbI4p9lfrWbrHzc1qGJQegZCug5rhMVI0U7B
         wIFzWctKYnx4dDmVNmoICgLvGVKZ2/1zLqTQ7Bw7o3JdSXcpvmwQlLyrAnV4jPqNsTsU
         j5iFepexZ952G6+s1QYM3YRj4keCDayY7SYC38o8DRBDGWPjRWxO0tyuhHvLQN7wbGoG
         uXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3NP1jd/PWu2o3VZGYD8UbdZwy6Kd+7mItBo+9p9VRfA=;
        b=ifLfUbRiSblC+YH4lVolJU06j7QEM1Bu5BF7mprexutqTwCCWpQWKFhCbSvbIxiNho
         pTTh0t5VI0wi40Ur5jdxkh86jfMDpYsHIOp1Vix75IT6DxI01fpgWAmU+mU0+96TdwA2
         bJAGezKVfCzFdjNhTwK5K4oRoAjSSwT3rVeHHkuzIcGPZsiFI2n1DNvEaUc7j40qBY8D
         fcHdizhzdKWSCOtjdnDPzKRl7fJptqME2FUclt0ay5t8ZBEZ/dvy9ZHV1z6bCFc+NRSP
         twMovGnZbpqDSkhmZmuw8Llik10SV55j9DlGIl97bWrt3054OfNWDeCjPo9pdcr5deCW
         oGoQ==
X-Gm-Message-State: APjAAAUXMCwq1LsVioK/7qfqnBOdVwQnCGErLW3zKGdNdHUVLf5mKShJ
        98U24wRnZMcKHPWhj45Bg038Pv92kzw=
X-Google-Smtp-Source: APXvYqz+E+TGvAaVxCUdh8DX/YaMMGtEYX2yEqjKpJ7egXu+u/LW0cG6nM8x8I8DqqNu1ekp9Y/cMQ==
X-Received: by 2002:a5d:5403:: with SMTP id g3mr31084900wrv.302.1580921695586;
        Wed, 05 Feb 2020 08:54:55 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:9c0f:f129:76a:d5c? ([2a01:e0a:410:bb00:9c0f:f129:76a:d5c])
        by smtp.gmail.com with ESMTPSA id o189sm224289wme.1.2020.02.05.08.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 08:54:55 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 1/2] net, ip6_tunnel: enhance tunnel locate with link
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
 <20200205162934.220154-2-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
Date:   Wed, 5 Feb 2020 17:54:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205162934.220154-2-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/02/2020 à 17:29, William Dauchy a écrit :
[snip]
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index b5dd20c4599b..053f44691cc6 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -351,7 +351,8 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *net,
>  	     (t = rtnl_dereference(*tp)) != NULL;
>  	     tp = &t->next) {
>  		if (ipv6_addr_equal(local, &t->parms.laddr) &&
> -		    ipv6_addr_equal(remote, &t->parms.raddr)) {
> +		    ipv6_addr_equal(remote, &t->parms.raddr) &&
> +		    p->link == t->parms.link) {
>  			if (create)
>  				return ERR_PTR(-EEXIST);
This is probably not so easy. If link becomes part of the key, at least
ip6_tnl_lookup() should also be updated.
You can also look at ip_tunnel_bind_dev() to check how the mtu is calculated.
