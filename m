Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACE62D36A8
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgLHXDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgLHXDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:03:22 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C458C0613D6;
        Tue,  8 Dec 2020 15:02:42 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id p7so10414172vsf.8;
        Tue, 08 Dec 2020 15:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZI6jg75D1Rbnwo5pzSv8vMYtK7WeuCDWZERKWhOVusU=;
        b=e2tzUjTW5czibXuhvVSscEFKFEETWuTzRDO39qUSnCjmm4ZdNBudDIUPihrNWh/E+c
         ZG76/3vps6G0J6brhVtDPgGaJA+Zpf1577SE967nPunzyOOpZeLDoBDCAxAQEzjY7pFc
         7ESPVaVyxU1lAEAftppKTIPEC82Y+nBJq19U3kWGMLnyhSCxD3bMJpTm7Ncd3rZJlr2/
         B3gClDOXFrt56KmrpOmaVrcckbhBJfDAywuUkZVrySfiMbtrWd/AvnpQqA5gUBsrpyzI
         EhsCD6uiIY9lwvn87Z2c48sg+1Ty63haUKnJ8bNxLzftErBXZh+UMZqvq/Ak5sFcWtwZ
         mMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZI6jg75D1Rbnwo5pzSv8vMYtK7WeuCDWZERKWhOVusU=;
        b=Caoh/5csETgDxNMjmxHkfnL5Jyxyq9gbCy49E9GPuExpWgY8D3Bf7IWxJzh417IGGd
         kM7minXHdxmIZffnsju75JiGAb6uy2uQrFOzNOQFb5MQ4bn8JArpijQNJz2e3rWggB23
         dPG77Ko00bEsy8j0HDxyLuIEymJLGywWGXBTDr21UfAd+VFM+f9ff9Uv8ytiiglnF3NW
         fHC85FvsnoBv/lCGanVoQQbJP80Xh1UIFGmiOFMCcYEIa8NOFqRrfh8F40sWHUOW/Hdi
         5046X5w2N+kTp0IFmcQYnqHfbSoMJCfO1ZYmL9IYE4qMmZOq4l/zsjnwqrBW11d2gnKK
         xAyg==
X-Gm-Message-State: AOAM5319RxsFAs9idFvCGPSsRBcrT7zZSg/CiepAQUD96UTIwPCtIHsd
        G/IxDVafRBbnxAb966sldZ92krRNycbvxW+Rux0=
X-Google-Smtp-Source: ABdhPJweyX2kzClOgxOVodNgBNNbk4c2RzWxVqxC/NXNd3DYRj6gn6eBJPU3FRgZnUcxAzFuoi6l1glxlobm/52X49c=
X-Received: by 2002:a67:e43:: with SMTP id 64mr331279vso.40.1607468561692;
 Tue, 08 Dec 2020 15:02:41 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com> <20201208225125.GA2602479@lunn.ch>
In-Reply-To: <20201208225125.GA2602479@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 18:02:30 -0500
Message-ID: <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Dec 8, 2020 at 5:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> >
> > So I assumed that it's a PCIe dma bandwidth issue, but I could be wrong -
> > I didn't do any PCIe bandwidth measurements.
>
> Sometimes it is actually cache operations which take all the
> time. This needs to invalidate the cache, so that when the memory is
> then accessed, it get fetched from RAM. On SMP machines, cache
> invalidation can be expensive, due to all the cross CPU operations.
> I've actually got better performance by building a UP kernel on some
> low core count ARM CPUs.
>
> There are some tricks which can be played. Do you actually need all
> 9K? Does the descriptor tell you actually how much is used? You can
> get a nice speed up if you just unmap 64 bytes for a TCP ACK, rather
> than the full 9K.
>

Thank you for the suggestion! The original driver developer chose 9K because
presumably that's the largest frame size supported by the chip.

Yes, I believe the chip will tell us via the descriptor how much it has
written, I would have to double-check. I was already looking for a
"trick" to transfer only the required number of bytes, but I was led to
believe that dma_map_single() and dma_unmap_single() always needed to match.

So:
dma_map_single(9K) followed by dma_unmap_single(9K) is correct, and
dma_map_single(9K) followed by dma_unmap_single(1500 bytes) means trouble.

How can we get around that?
