Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB512FE0A5
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbhAUE1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbhAUE0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:26:45 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBC3C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:26:05 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id i20so436861otl.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xYEMJrUKjfV1e6YHhpo4J6irqiobyKJqmvcKLrT3RrY=;
        b=uG67wT1moq019987IRsaAn0j/8AaZiOpO53RwZk9RyprASRLAHtlxohRooQrQ/yVp2
         eaN1Y1aIjxGjHdMJ5Vy5FS83cAJh7G90SUsMtpUD/aINQphE2QNsQTfym/rZ+p7nn8ts
         6GbeOIMthOMm1L+TN5HEqDeJbwLDQBK1VmjUcNs/hX4ELvNkMJjD9pPadnQ0B3J2/KtA
         FEDKu+ksJDSp0Uw2dziY25wOjvdoYNbtGnH9LVQQcdU/cyFDkMwaK242GfTKNYHYVnqf
         Q9bXJP2mDhSG4WQTfKA9n9cws4435Y3bNray3FMOWlsJfC/5yrWDe6uXJuGWw4Ft1oa+
         F2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xYEMJrUKjfV1e6YHhpo4J6irqiobyKJqmvcKLrT3RrY=;
        b=KXxD4+xKnjOGR2YE6LHJ6WENMTsB6xvgWr8oOVql0I38Vm4a/mxboKpwi0jFx8a/VV
         ZZUvKf6l5ypkbSvzyOFNNNqD4GP0MvSyPjX7YRitSXugENyr43g++vU2jvqR5zggXMl8
         8/hsCxFmoq50wGrlpy1WFJzwrSnBzR9ehm52tqySnrMIuIrXARbb2JEBM3U/4hBuiUQn
         KWtX2mLGMSsbGuQP/7w/ynBmnHg5PAectLn0+f4CxmJLAgigcY4JnQrXidVJeT9+Y8Kq
         z12Aw3qMcHwVaxa3QxGsVRQZvg7IP9MsioMmu9cJN7m/D2FVOszuHnUTN+PDGV3b/mKo
         ISaQ==
X-Gm-Message-State: AOAM5301ZHkHatV8+sclIhDp8scvFJpUR/9myX3D5oiXNt9/5U7AnPKP
        BpovzGOCLC5TIEFqO98j0F7UGdUoKg8=
X-Google-Smtp-Source: ABdhPJxVg+sHtg1tlVneJa0i5hC279KgZDDrbF90f/TPmUDayDdb17Ncnt+3LpjDS75FvLu73ELfqg==
X-Received: by 2002:a9d:27c6:: with SMTP id c64mr9317932otb.313.1611203164600;
        Wed, 20 Jan 2021 20:26:04 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t16sm457040otc.30.2021.01.20.20.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:26:04 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611156111.git.petrm@nvidia.com>
 <4b1e5d244476e8c442e1b42ac5e25667f26af30d.1611156111.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd1452a4-c0db-5f02-8e91-cde08333b6d7@gmail.com>
Date:   Wed, 20 Jan 2021 21:26:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <4b1e5d244476e8c442e1b42ac5e25667f26af30d.1611156111.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/21 8:44 AM, Petr Machata wrote:
> This function uses the global nexthop policy only to then bounce all
> arguments except for NHA_ID. Instead, just create a new policy that
> only includes the one allowed attribute.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     - Do not specify size of the policy array. Use ARRAY_SIZE instead
>       of NHA_MAX
> 
>  net/ipv4/nexthop.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)

Reviewed-by: David Ahern <dsahern@kernel.org>


