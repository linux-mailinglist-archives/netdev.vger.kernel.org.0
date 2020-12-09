Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A912D3952
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 04:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgLIDuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 22:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLIDuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 22:50:09 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6EDC0613CF;
        Tue,  8 Dec 2020 19:49:29 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id h6so168729vsr.6;
        Tue, 08 Dec 2020 19:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bbQPAUhEn79unHC+6i9IygFJQzgAmAIFRZdGi63vF3A=;
        b=UST7Fm5l3GLRX1xPHx0vSpfDp3SymUAQ9j1g/KC4Bp8khLjWIR3S+0kvYQw8cvV9cB
         GEevGA4Rdgh+lWsJkN8VHrZQpv7YxU54rftOd+64MwOH2GjxY6HnN3BiAxdGvCxbSrH7
         1TZSRrhDfYdfSS6nJZlotAvH8ipN2XrJVYieXqsO63ViKgIfoN+kYwnWcwFITHFchk9k
         uvKF8qwwsmaH2vmL7nTjwCDDDT5lxbhlKgKJf60UXe5cugr0WcgmFsDVl/TP7AEOGsd/
         hGiFJCFJYluX7FWQBy+f+jF6wwssKEjktGgzNGXIXDpZU8/N+hYbpPDnX45dZDN6ZOH7
         tH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bbQPAUhEn79unHC+6i9IygFJQzgAmAIFRZdGi63vF3A=;
        b=sz5BvDQkJR6JVNHWw+LovA2TE0/ZOFprTagIwRlyePg4VsLAEKbzIwqSbtu5h/pLyU
         uVT3QoxiT5Zw6JwZF1LjhnVttMNkZ4tspleanZf3hmzEDXG99BkEibZhV31ZSTCS7HZc
         ZmBCBcUwdvlZrQeL9k130orUlasXLtwfNcOWUVL5yrrzWYiKj5M18K7n/dUkPF26UJpz
         w96j/BtT+vaU3OJwahjOTaMJbyV5a+YzFHpanyAuJwlAVa7jTqCyGRrDV3MqYie5d6Vj
         3Bi6Vbf5Rp98pkHFSe3mLuE62ZdDo0QIU32eq2U2q9z9O8/+ypYwzcLF8y8bquS0IR2v
         Nz6w==
X-Gm-Message-State: AOAM530RjU+g3qjhwVhlkfwLZcG5Can4NuNO6nKRl3DuS3xPBkzwWvQ8
        w1iVec+DILljgxlgNPxAUSuCCBiESLmM/L0rkE0=
X-Google-Smtp-Source: ABdhPJyEhFI2RN4K8U6MCsutGojXGqc4NKJVLs1FZVCH9ZW4/lb99g16+yO6h3aGanjphhEqpUZRXC1WXVHcpqfFEwY=
X-Received: by 2002:a67:e217:: with SMTP id g23mr276040vsa.15.1607485767975;
 Tue, 08 Dec 2020 19:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
 <20201208225125.GA2602479@lunn.ch> <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
 <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com>
In-Reply-To: <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 22:49:16 -0500
Message-ID: <CAGngYiUvJE+L4-tw91ozPaq7mGUbh0PS0q7MpLnHVwDqGrFwEw@mail.gmail.com>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 6:36 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> dma_sync_single_for_{cpu,device} is what you would need in order to make
> a partial cache line invalidation. You would still need to unmap the
> same address+length pair that was used for the initial mapping otherwise
> the DMA-API debugging will rightfully complain.

I tried replacing
    dma_unmap_single(9K, DMA_FROM_DEVICE);
with
    dma_sync_single_for_cpu(received_size=1500 bytes, DMA_FROM_DEVICE);
    dma_unmap_single_attrs(9K, DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);

and that works! But the bandwidth is still pretty bad, because the cpu
now spends most of its time doing
    dma_map_single(9K, DMA_FROM_DEVICE);
which spends a lot of time doing __dma_page_cpu_to_dev.

When I try and replace that with
    dma_map_single_attrs(9K, DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
Then I get lots of dropped packets, which seems to indicate data corruption.

Interestingly, when I do
    dma_map_single_attrs(9K, DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
    dma_sync_single_for_{cpu|device}(9K, DMA_FROM_DEVICE);
then the dropped packets disappear, but things are still very slow.

What am I missing?
