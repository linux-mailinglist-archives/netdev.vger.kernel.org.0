Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA681134A80
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgAHSdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:33:49 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37732 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgAHSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:33:48 -0500
Received: by mail-io1-f65.google.com with SMTP id k24so4299456ioc.4
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 10:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ic1yzLj6jS4K82GVDuR1fkWy1ahtIt4c+ixfQPaqbMU=;
        b=BHwZUvg2wf4EZyTvnUGApJ17yYBUbcMaKnJVeeBJJBa45MGhzcNbWJpAsWzLSuWfsE
         FSyrsKRqmVe2138lXj3P4zc09r8ioK9vcK0IIEj2KKB4Fg2RfpZu0UJFyI7v4HZto+s6
         A3FrHW70lTWYW3SsUKPqE3+CH+VJxLbcy5H+zPBY5+paHgAfIHEN5kbEX1kyFHjvyXha
         gj+JAPZovwRW/tVfuoz61DB5Ut+lxCl0eDKT6LLwAzV8oLPOREFLunInXb2uAW3jFFQk
         PG2mjb+0kl9PfB78cx5ijvymy4NCkh8g/ECbbPLXTCYgn/6PCQ7kNGZZfGfKLyAE/QDC
         4big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ic1yzLj6jS4K82GVDuR1fkWy1ahtIt4c+ixfQPaqbMU=;
        b=tlXc4LqdwRP5eadZhclG5y6/dr9CimpLdLhJQEHxnWD8byT2NDUzAGhwUXc1AqOOIT
         5Xnl3VoP0hRzXLhd3Incs3DJJCO5YWaPLTMx5Hpx7DCFLj3YaEzgugdRp3nXz+axrkq/
         aj1kTLyeogPqYQL7oI+CrTGmpSgiki7xaNtgl03PtK1I4ntCHSsgmb4PhHBA6UfXRx6e
         dxhDw+gnbqLFf/bx/OPfU26nkWI6fgKxDe+tJjiLZOtWzuJi2c3S0YdpB+oStmLjaoW/
         tbGH/uHQQpLZDb3WdB6A3ohk7YwiQyzj99/vJWRGUFU7E2zMBCzCD4ChOewP+4Nrmkr1
         fCeg==
X-Gm-Message-State: APjAAAU9/AzN5PNzQKhaRVPnN8QDHA4wV7yvJqMrdZ2SLzsf2Pk+QBP2
        JLX1UglGBTGda+kZqNyQHQTG6V3wr7g=
X-Google-Smtp-Source: APXvYqwkPgrIPTeFkL6GdAQlpti+fVp/YtsSacO+PVBtbTgTpvWb0Prp7LEQAnWpOfS6IZh+MoUykw==
X-Received: by 2002:a5e:9243:: with SMTP id z3mr4540304iop.259.1578508428110;
        Wed, 08 Jan 2020 10:33:48 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:601d:4dc7:bf1b:dae9? ([2601:282:800:7a:601d:4dc7:bf1b:dae9])
        by smtp.googlemail.com with ESMTPSA id u29sm1183356ill.62.2020.01.08.10.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 10:33:47 -0800 (PST)
Subject: Re: [PATCH net-next 01/10] ipv4: Replace route in list before
 notifying
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20200107154517.239665-1-idosch@idosch.org>
 <20200107154517.239665-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1d1ecb8e-e753-0f2c-7463-721d1aadee83@gmail.com>
Date:   Wed, 8 Jan 2020 11:33:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107154517.239665-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 8:45 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Subsequent patches will add an offload / trap indication to routes which
> will signal if the route is present in hardware or not.
> 
> After programming the route to the hardware, drivers will have to ask
> the IPv4 code to set the flags by passing the route's key.
> 
> In the case of route replace, the new route is notified before it is
> actually inserted into the FIB alias list. This can prevent simple
> drivers (e.g., netdevsim) that program the route to the hardware in the
> same context it is notified in from being able to set the flag.
> 
> Solve this by first inserting the new route to the list and rollback the
> operation in case the route was vetoed.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


