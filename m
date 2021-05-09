Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEB3377917
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhEIWyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhEIWyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:54:06 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83382C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:53:02 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w16so6004093oiv.3
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z9uj1hqmuXaYURGRLik6dJ+QWGOKsSu+5FD6+SvZfks=;
        b=Ou41nqAG7CUPnQTviMWSliyaOn8F7aTO62h1fCNwz5Jvy76pg0Ji8I+yQGRyh1Ejwr
         CwiQh/pL46KMB1OJkBakSkNFOByR8pVXtXkC/0+zD35B4i7kE1eKzRYriSKQqXJNoGWK
         DyU12XYW61CqCrayCP0Vu4tdkIwWYzM2ceS4BJAWO9idVVUWlS2IB63sMsyBRfmf7zU0
         Qgr/Uo2xldHOoVlgQ/5PjFA6XsHjA2M+ixStZstgZaBb+J5UYvyMlhjrdT53Ik4j5XZY
         WnMjDLapE2wu4/w8aE9SCAsPcLnT9/rZb551DxyV8OHvepYtYaeJb0dACzRwcxPr1xXP
         mE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z9uj1hqmuXaYURGRLik6dJ+QWGOKsSu+5FD6+SvZfks=;
        b=RfJ2ngI7tCUzMQBmOKFnbVUtnXF8sysuAvsMGmmelA7gXpfWYq8krdo/8Q6OVleMO+
         banDceCd/ehFxkoQOfBYvlLgb+LXWCY52ErxSFpPyuU2jG7JsFntOTkLBAmMbgHByrbe
         QyT15MlYOu0BmUgw0V1TiGFtAkyl3VS79QRTnqXPk2qgNhVpikVcGK4+Xwqtsd+d4VZF
         hLrezyR2QaybtJHbST29J28LgJXiqftabxAInT0F0/ov3icElVpNUPXwfxGce71jYXhQ
         4D4rTW7sLumhUf4JSR5qr/b6+oYSHAWk1SfAfkFts0PNO5slp5h9jV469NOlmV3MG160
         n3kw==
X-Gm-Message-State: AOAM53103YONnNGfjS5YxD4P7GSC9qN8GLcbqYlzcCBdgCMqx5Gb8Gi2
        yoxcaIKmE+Mm9iMDDrH1Y39WMTpqLE0=
X-Google-Smtp-Source: ABdhPJy61Nn/QpPRczreF34IOqeJ9u0UC3J1qfncnjGx1eF6imJ0CEnzGO66J8swcsRcrgsjMw+hKg==
X-Received: by 2002:a05:6808:68e:: with SMTP id k14mr15736163oig.175.1620600781807;
        Sun, 09 May 2021 15:53:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id u201sm2308876oia.10.2021.05.09.15.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:53:01 -0700 (PDT)
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when printing
 stats
To:     Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20210501031059.529906-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ae8aee40-4987-0554-e415-0922aca85cd6@gmail.com>
Date:   Sun, 9 May 2021 16:53:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210501031059.529906-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 9:10 PM, Jakub Kicinski wrote:
> This change makes ip -s -s output size the columns
> automatically. I often find myself using json
> output because the normal output is unreadable.
> Even on a laptop after 2 days of uptime byte
> and packet counters almost overflow their columns,
> let alone a busy server.
> 
> For max readability switch to right align.
> 
> Before:
> 
>     RX: bytes  packets  errors  dropped missed  mcast
>     8227918473 8617683  0       0       0       0
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     691937917  4727223  0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       10
> 
> After:
> 
>     RX:  bytes packets errors dropped  missed   mcast
>     8228633710 8618408      0       0       0       0
>     RX errors:  length    crc   frame    fifo overrun
>                      0      0       0       0       0
>     TX:  bytes packets errors dropped carrier collsns
>      692006303 4727740      0       0       0       0
>     TX errors: aborted   fifo  window heartbt transns
>                      0      0       0       0      10
> 
> More importantly, with large values before:
> 
>     RX: bytes  packets  errors  dropped overrun mcast
>     126570234447969 15016149200 0       0       0       0
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     126570234447969 15016149200 0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       10
> 
> Note that in this case we have full shift by a column,
> e.g. the value under "dropped" is actually for "errors" etc.
> 
> After:
> 
>     RX:       bytes     packets errors dropped  missed   mcast
>     126570234447969 15016149200      0       0       0       0
>     RX errors:           length    crc   frame    fifo overrun
>                               0      0       0       0       0
>     TX:       bytes     packets errors dropped carrier collsns
>     126570234447969 15016149200      0       0       0       0
>     TX errors:          aborted   fifo  window heartbt transns
>                               0      0       0       0      10
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Note - this patch does depend on the trivial nohandler print fix.
> 
>  ip/ipaddress.c | 146 +++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 106 insertions(+), 40 deletions(-)
> 

good improvement. applied. Thanks,

