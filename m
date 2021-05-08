Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA33772BF
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEHPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:48:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE49C061574;
        Sat,  8 May 2021 08:47:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m124so9532178pgm.13;
        Sat, 08 May 2021 08:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5x0cYP4Ro/EUkBy43da8rOa0t+0PWrP0bOsvYPqnw2k=;
        b=Al79UDG6blXLP9nVZeG1Ga5v7bg+2lQgKkYthJv7ZvihX2kn5ogJLvJDTPVUUmcw0n
         kxmhOR+goY2exhPOtuVSMv08wKzv+yCggfao2D9Ow843VxQsFQ9HmX+HJJ3gAcORUec3
         xS3cR9UMoDEJgYWM4jl+FVtR6hJWLfpm30wdkAJt2OcS2QcuRPtxKibaN7X31YR8OjmV
         cba3qpRkjP0i10b4ofwEqBJWwm/3LInTvpg6PCub8KiFjy1DdCUl+VPV+L0siSF4TG6r
         BQiqfeLUP4R0A/vecZlPPEaQ/PZ58tEsY8xMCKDtn6QHS7VC43dsN/0GFa/QPjNqgpvL
         53IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5x0cYP4Ro/EUkBy43da8rOa0t+0PWrP0bOsvYPqnw2k=;
        b=NGFqHhLhUiEpFUx3Xoz/hHhNwqTIUaAB3oS0LUivK3oSZB/9xJ+Fx4cHfpGtgpmUYU
         BxHL9iyhcAy8eZO5sbnSKAaSUP2GEX9zNoklussgLa/uZlO1CSN016LNJzK1Blx2E8Hc
         o7Di9KRQR26Z+xbl1edwAd7Cs3jN7UVSrA1OAN8eN7HZk7RLjSg2gdpxl8H5zdpAB41g
         ORfFGE1Oq6HmgtLphkPHPJMx80gkq4smPZIVfMPMGDby2ZYmWwO26RwN731QKpYVgHxs
         auN/cu8asheN0M4uAXJR8O1uIDb7tav+Ztuaa3iPz7njEfJ71lzPw+jtxIAb4pQXtWnw
         ba5g==
X-Gm-Message-State: AOAM530M0YX9KuUn+OLv/OTi4CcNq8LqjVYd4AzRhzB9NqTUH/4t1hOz
        3jVVKMut5nxwPpDOdrNcMWeV9kBmkJ8=
X-Google-Smtp-Source: ABdhPJwIoZNfBe6KgUE8Dyk91PTwvs4/ii1VKO5XMQyrI8TqMT/2wh0aaYV+JmZYl/ZsOz4d7CynWA==
X-Received: by 2002:a63:d507:: with SMTP id c7mr15740388pgg.306.1620488859330;
        Sat, 08 May 2021 08:47:39 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id z25sm7700772pgu.89.2021.05.08.08.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:47:38 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 12/28] net: dsa: qca8k: add support for
 qca8327 switch
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-12-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <245c4747-6f30-781a-6e51-145ff7139cbe@gmail.com>
Date:   Sat, 8 May 2021 08:47:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-12-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> qca8327 switch is a low tier version of the more recent qca8337.
> It does share the same regs used by the qca8k driver and can be
> supported with minimal change.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
