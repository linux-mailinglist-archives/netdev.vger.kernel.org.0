Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1234208F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhCSPHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhCSPHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:07:19 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEE1C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:07:19 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id w1-20020a4adec10000b02901bc77feac3eso2386118oou.3
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9dZyW4PH/RCe+okH0kjWttL2AU/66WBZAV8tRhYUfOI=;
        b=mXTj1VlEy7dSCkwijCuszSJEhDLu4KslPrEyhZQIPwu1m3aw06aZMfil/yOb2OpKsv
         1oapYaTgIlnZRJy2zOm38lSoT5YHry0t6+sT3UV8KHWtLCBD9NA+U1pb8CNBMzYi+TCC
         KgkcVxRHeR0zXlHhDI1qpyIzBFmPet18UhBop2ty+0X40x1ob7YCpSwHJq/+CyoBBP5s
         VbLuR+vF6ahtJ3L/ykilrq3aaZa5JL3f6zNNVjd+Klx+lGflC8Dfnwx1OiTnTaFW638z
         DE2fH4sDK96g6UMOrZ/SIwxKvfMJ+YrGjjM/J00q8lBB/LZz38hW06MbenrfDAyAlrE7
         QfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9dZyW4PH/RCe+okH0kjWttL2AU/66WBZAV8tRhYUfOI=;
        b=grB8EthoYOBLsYsjeo3evsqRooENesGua5knAlLvWujdJevvwWMGa4sqph4BZ6maia
         LjEToQtKCJC/EurULktMLF2cP0hLttjXWkHsO/Uh7Plwln928foGxobJXyDfVZ9jrULA
         xFHByj4l71BsqMHPq+OACyUeSxkvvJTOzsKkjnYg9OqjbUIAFcFLgkfOgX8Phk9S04PW
         52nTjXwGhyCL+1Dx8ujQ1a/LTXQI/z29S7RSkz4qnig+mBWTGPW22xS2FIvOftGo9y2h
         x3ELB4W+xDTqDq0kEMZXfiFy8fXJwUtVLbWwjtYGTVI7l0NAhHO8AIOTIE63zqcpjaIu
         qCJQ==
X-Gm-Message-State: AOAM533Io/s1ozG7aPPh+8A6Pygc5sP2O93V+eoDdwxmxzyUITG04rhf
        sVfjM2noF43KKX3Ztj0bOM8=
X-Google-Smtp-Source: ABdhPJwsRkckeDhdQFNVg24ipFeHI3cu/mefPOApU8whpNP4Xq+I1XC7FDgeOWFQKXVQ25eyj06/hw==
X-Received: by 2002:a4a:d50b:: with SMTP id m11mr1752448oos.35.1616166438718;
        Fri, 19 Mar 2021 08:07:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e449:7854:b17:d432])
        by smtp.googlemail.com with ESMTPSA id v6sm1279046ook.40.2021.03.19.08.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 08:07:18 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 0/6] ip: nexthop: Support resilient
 groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     Ido Schimmel <idosch@nvidia.com>
References: <cover.1615985531.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c24997ef-92cd-a7c8-3d6a-36334567b622@gmail.com>
Date:   Fri, 19 Mar 2021 09:07:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cover.1615985531.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 6:54 AM, Petr Machata wrote:
> Support for resilient next-hop groups was recently accepted to Linux
> kernel[1]. Resilient next-hop groups add a layer of indirection between the
> SKB hash and the next hop. Thus the hash is used to reference a hash table
> bucket, which is then used to reference a particular next hop. This allows
> the system more flexibility when assigning SKB hash space to next hops.
> Previously, each next hop had to be assigned a continuous range of SKB hash
> space. With a hash table as an intermediate layer, it is possible to
> reassign next hops with a hash table bucket granularity. In turn, this
> mends issues with traffic flow redirection resulting from next hop removal
> or adjustments in next-hop weights.
> 
> In this patch set, introduce support for resilient next-hop groups to
> iproute2.
> 

applied to iproute2-next. Thanks,

