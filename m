Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A908423B5A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbhJFKTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhJFKTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:19:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D53C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 03:17:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d8so7843577edx.9
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S2t24QUNtRA8K0mj3u032rz0rVFjHS8PRQaJWQAkE9Y=;
        b=oKt3hViuJAywgzH6iY8HaWNaWZph6guec/0WDzWVtHxOsJIwPieMIEFIhkuN6k03WM
         UUN1dhXBnTO9zCn0zfScxirZmiDrFigLlHnzmEetsOhU6PE5KP85RwK49OLevnS/GNW5
         shbqj0Xn8YdbypxR5ODLTDSIfjJqGP5hCOLx9u5qHiaaKDId9tVPsgErVORP1QWRNl97
         n6bZ82Mg/lWPxsI08Oz7bnRItfB9O8+zXYKw2DmPz2G3c8K0k8kFXxDNxti64ImiZ8CV
         Jjp13MsV2lzGi6gVNY9RMk5FCExDL66Dr4mXpD/AZfmOJfH1So3ynUbdsKE+6xjo3WZD
         Nq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S2t24QUNtRA8K0mj3u032rz0rVFjHS8PRQaJWQAkE9Y=;
        b=Pjv/QbN8/Z7h+ke7ITwgClyO92iGThe0H47RzqenGm+qnq18vjnyF6hHYgoajs9Es2
         zumEiTYMCJ2D0yOwZxvOA4suAjCVSqFx1C65gc9PA71Spg6qGb/VeUMdGktw1TtVR+7r
         OptAFoclR7BlNy15kMuWRDth65Pn2dIkFa8/PfueU7NijNhEi6Q7rTIjfyNmMRgcw5qi
         OKJA4kpQ8PPqsJp6C4tvQIQPwYk2qA1FSh9mdinfe+cL4NkkEH//NZN58liclXcYKTB8
         OZPXIq9mi0hPEvTQz1vgQ5Z0O+KDNNoXtCK/kJWDhTIQwaCWmr4QwaZFej5H+T+60wp6
         6hgg==
X-Gm-Message-State: AOAM5320eIoPmqy57Pwlnr4BI4XhPpVM1z7/3mtIzDSm82grN4Vv+VRI
        nEz5UaIuqtzAhyUVId4Zw+Y=
X-Google-Smtp-Source: ABdhPJxquEEtlv2tUk2kXkIr0+ZPskmpG38ALahpEEj5rODS61/IU1nI0FcourWqy0HCvjbdo8xa4w==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr33296761ejc.239.1633515443622;
        Wed, 06 Oct 2021 03:17:23 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id z4sm1077846edd.46.2021.10.06.03.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:17:23 -0700 (PDT)
Date:   Wed, 6 Oct 2021 13:17:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 3/3 v5] net: dsa: rtl8366rb: Support setting STP
 state
Message-ID: <20211006101722.sqoosxdewm7n3xem@skbuf>
References: <20211005194704.342329-1-linus.walleij@linaro.org>
 <20211005194704.342329-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211005194704.342329-4-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 09:47:04PM +0200, Linus Walleij wrote:
> This adds support for setting the STP state to the RTL8366RB
> DSA switch. This rids the following message from the kernel on
> e.g. OpenWrt:
> 
> DSA: failed to set STP state 3 (-95)
> 
> Since the RTL8366RB has one STP state register per FID with
> two bit per port in each, we simply loop over all the FIDs
> and set the state on all of them.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v4->v5:
> - Rename register from RTL8368S* to RTL8366RB as all other
>   registers. (RTL8368S is some similar ASIC maybe the same.)
> - Rename registers from "SPT" to "STP", we assume this is just
>   a typo in the vendor tree.
> - Create RTL8366RB_STP_STATE_MASK() and RTL8366RB_STP_STATE()
>   macros and use these.
> ChangeLog v1->v4:
> - New patch after discovering that we can do really nice
>   bridge offloading with these bits.
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
