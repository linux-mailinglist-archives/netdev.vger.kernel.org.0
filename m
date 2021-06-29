Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C663B6CEB
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhF2DWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhF2DWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:22:47 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEF8C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:20:20 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t3so1726284oic.5
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lU8HQMRINQXMDCrK5ufDCNxe5rfpbIc3LM6cX207HzI=;
        b=Zc49tkUF6RSPNhXQOv3yrSZ7/7qnu3mJIAtIxpM9/APIYBvN3J6hMlzDCD/e8W6NLr
         It6yTU1c01XfYK4Q/UEVUJftwECgfWXFyp5ZSAnTvyh6rxY1B4/2PoAhX5+XNlY7ruNo
         1aS6cjbk2Tfs4N65UbGgrKXdE0/erMmEtJmJU/oc873qI+g56EaL1F6O/gb8rSUiQJVW
         rM7HWqpKAi2gPwQl55aCGzNTQiWzN7Y6nOMd7o+w8e+Q6J1lOEUu0iSNfN8vdLkI8CRb
         GZfCA8g0WmYNSSgvJ7/tgXoS2wsHGqDgamM1QJp4s4cvcuKXkevSRXUf+Z/VG4CUpl8Y
         d5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lU8HQMRINQXMDCrK5ufDCNxe5rfpbIc3LM6cX207HzI=;
        b=At9vcPp1cmY85L8Dbc3XLXC8xcljFpvfmxUrEJYTI5ECL2GIPBAySaXRdPS3tBeBZ+
         FSBb4ad59jFcRyQWmjENiEjCuO/8Lus3yoWYRS+XFIPWloGVdrYPiE2xd/p2YbGLR/mI
         yq5UAGCHZntIEX9UkkyKH9V4sjmYdKVqWqlUtXpDN6gGNWI0Ong9YvSpWEQawEahAPvx
         n5zC+cwr0rZ02J4MPiWyRHe46Ci+vWzU1boJLcOknQbfoj9HFBEPdlC5jZ0RMmDKL9Gc
         fi0o1evSldsl9LkPHBnKhCAYZgX1Y1poLVeI2csg1jFHlqDlyel+5YKi0W/T8nEXDSp4
         KEjQ==
X-Gm-Message-State: AOAM530hooGCV+5JBtVar5+RyXV+TAxFrYlmd/xtPedSZI86jP2OIHCA
        7hbyY9E98mui0yU88Iv/ku4=
X-Google-Smtp-Source: ABdhPJwoIDlrc2K/O+oF6zoB6U8/0kNIVPtsn9bt6sbEc0zHuVHOhfuEWdq4zeAltcz89v0E4+r8kw==
X-Received: by 2002:aca:4288:: with SMTP id p130mr20311278oia.80.1624936819349;
        Mon, 28 Jun 2021 20:20:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id s12sm3523944otd.73.2021.06.28.20.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:20:19 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv6: fix return value of ip6_skb_dst_mtu
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210628215431.29156-1-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a6226bd6-8e19-3119-cbf7-93d1d3c642a3@gmail.com>
Date:   Mon, 28 Jun 2021 21:20:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628215431.29156-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/21 3:54 PM, Vadim Fedorenko wrote:
> Commit 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE") introduced
> ip6_skb_dst_mtu with return value of signed int which is inconsistent
> with actually returned values. Also 2 users of this function actually
> assign its value to unsigned int variable and only __xfrm6_output
> assigns result of this function to signed variable but actually uses
> as unsigned in further comparisons and calls. Change this function
> to return unsigned int value.
> 
> Fixes: 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  include/net/ip6_route.h | 2 +-
>  net/ipv6/xfrm6_output.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


