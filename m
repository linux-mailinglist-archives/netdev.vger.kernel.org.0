Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964CD2DCA3E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 02:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgLQA6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgLQA6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:58:21 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FC5C06179C;
        Wed, 16 Dec 2020 16:57:41 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id x26so14057983vsq.1;
        Wed, 16 Dec 2020 16:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=euybVxxM7EXhNr0jh3ZiR93jYB6lZp7ZVLZdtiF+Stc=;
        b=dkkHBW1KWRJt7520F0htUV0xuxcwt/oGdQpq2ryed+sFoy7wHDXivE6+LwPdh8Ecza
         1Iz2veR/H29I7B+d+HuVugAeeyRNVozvTb7ABDSv12jo9KtAAdsJufRHtoctNiA4LvUR
         JmPjWRKBtJeFzaKgOvrDHqnqfs1zZl1NTgcf4kmC2gevwJ9q1SHrDolzneclHhCZOhl9
         uKrhIVpRA8JBmgoNZSqUMEm9gnR3kKIYDpu/6x/HFpDIOwV0Gp7kiUZtI57SvJi25ikx
         o/C3nNq/caEEi9wTQprw98iDPD0Cle62PXpx+uq+TMKcV4s6oA+gD8Cidsc6w7iaJl+L
         7moA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=euybVxxM7EXhNr0jh3ZiR93jYB6lZp7ZVLZdtiF+Stc=;
        b=Yb2RkqHgFNZpLys5A4at4auUOPvOvuUgWmkfSNr0uR0jBgAgwNrJHdyqS88Cm4sqqL
         qGMaWOUDpmwTSUObYuF5qa3tABS1K/4ZjptA4endfRLJjvJLqW+n8Wv3juacEFY/wvbl
         Eg0RtmyvSVTQO0BlNlTtBNxvt5zp9UTbGqI8qXV5MqzDBrr1fFGkYm42eB4bAUVno4IV
         NqF6c5gylBJXFfdYfNvMvNq6uiTQ0BN1bFm5KRF3XgpTT5lZ9svBfGB6CH9Esi//YCS+
         4pHrexduM290CTXd4t8FEfUwN/yWaA7KXikT3p0KgMLjNgmGBQw4RPfr6TNyll+6rZ10
         5e9g==
X-Gm-Message-State: AOAM533YqlEXrPJZ/wMuoeyvVcJL2TrMazvOdYT11CgEmn+tP9mrkhH9
        sFb12RJOujYlkS1CWRKPtWzoucA1+tpYgG11hJw=
X-Google-Smtp-Source: ABdhPJx9KMF/vMzk77FlYfvwXvpKrhKKNYIudUV0I+/d3bch1b/mIoVo1PmJak881wy/xbmx2XqXWqDCvKN39C6O5VM=
X-Received: by 2002:a67:507:: with SMTP id 7mr27395596vsf.42.1608166660043;
 Wed, 16 Dec 2020 16:57:40 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
 <20201208225125.GA2602479@lunn.ch> <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
 <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com> <CAGngYiUvJE+L4-tw91ozPaq7mGUbh0PS0q7MpLnHVwDqGrFwEw@mail.gmail.com>
 <20201209140956.GC2611606@lunn.ch>
In-Reply-To: <20201209140956.GC2611606@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 16 Dec 2020 19:57:28 -0500
Message-ID: <CAGngYiV=bzc72dpA6TJ7Bo2wcTihmB83HCU63pK4Z_jZ2frKww@mail.gmail.com>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Wed, Dec 9, 2020 at 9:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> 9K is not a nice number, since for each allocation it probably has to
> find 4 contiguous pages. See what the performance difference is with
> 2K, 4K and 8K. If there is a big difference, you might want to special
> case when the MTU is set for jumbo packets, or check if the hardware
> can do scatter/gather.
>
> You also need to be careful with caches and speculation. As you have
> seen, bad things can happen. And it can be a lot more subtle. If some
> code is accessing the page before the buffer and gets towards the end
> of the page, the CPU might speculatively bring in the next page, i.e
> the start of the buffer. If that happens before the DMA operation, and
> you don't invalidate the cache correctly, you get hard to find
> corruption.

Thank you for the guidance. When I keep the 9K buffers, and sync
only the buffer space that is being used (mtu when mapping, received
packet size when unmapping), then there is no more corruption, and
performance improves. But setting the buffer size to the mtu size
still provides much better performance. I do not understand why
(yet).

It seems that caching and dma behaviour/performance on arm32
(armv7) is very different compared to x86.
