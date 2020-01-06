Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97826131B9D
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgAFWjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:39:33 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45254 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgAFWjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:39:33 -0500
Received: by mail-lj1-f195.google.com with SMTP id j26so52582968ljc.12
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 14:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07zlX+H29sRJ3AJ8SvCHhQOTkPmEgPj83Nwb6icZWb8=;
        b=EOm68nppN9qux1GagxLZoNYO8ddrUvdzobIgInbfbRL6IZSf9TwHZ58kWTijC2STnt
         nujkqCkj8yacEyl2sG8mN2LB+G3IzzEldIBzUTPGkmDjzqsGmRtbPgfvCGbbCVkvguJE
         yjMze4G71JXboOKJ1ao4h5ljTWwB6UEtsZQbSiDAD1OborXdMliRD8fUj20OjIxhboeX
         VtVS+ATfIojnrGgtcxNrs8OZaNpMrPT7KREXtR8/9D0ZDnsE8xkPJgifRcVkBx6pSE30
         d/dPXcoh3/jv4cFc54gByUCvwFl05GVHsPoGz8mp1qLnLTxmTppyq9UVXEVrNI1gXxOr
         7DXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07zlX+H29sRJ3AJ8SvCHhQOTkPmEgPj83Nwb6icZWb8=;
        b=dyxaKTUO7uGfB7XGLamOZdMdQ/1o3poEAG8zVeF0SdL2aeXOakae6j1XIHxNC01P1F
         AUCNLA2o9q6XPTsY3RVG2Nv8j80gZfM6URJZEUQTDjGvYhqmLOICOLvnFLEz9STt/YhR
         hDBh9Fwa+u7kAkjQ0z/D+NpA1IabLZYh9mC0ojyMhO8228Ke5IgMZ5lzQCSxHN+/bFJe
         8grDkgnbOI5cgLwDMp1VUSYT3GgDpo0lFhxXlmoWaHeierx79zWuw+5oKxHV6b1PzSTO
         uGIbhNs/NhevH0QyqFA2x0xbkbIQVjbkISjHcuKpNUWEPKxpt5vVbEjnGmUL8n04lZIu
         RomQ==
X-Gm-Message-State: APjAAAUYZ6VFXzyRoK1A/W1/zQ4ia1hwCzwpiO0+857Wru3kHl5NXM3R
        cW59baIX6dFdt6Ce1dMVxpriVZs1yUWGNfk4c+hUiw==
X-Google-Smtp-Source: APXvYqwa8kyOiB0BFPlfSQi4xAoOqx3MF+yAl5BjHD8wy6O4fkOsmNNstDvCmZaQcjLZ4cNC+nua3HaeEINT69H23Jo=
X-Received: by 2002:a2e:b4f6:: with SMTP id s22mr62576921ljm.218.1578350371341;
 Mon, 06 Jan 2020 14:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20200106074647.23771-1-linus.walleij@linaro.org>
 <20200106074647.23771-10-linus.walleij@linaro.org> <20200106.140130.1426441348209333206.davem@redhat.com>
In-Reply-To: <20200106.140130.1426441348209333206.davem@redhat.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Jan 2020 23:39:19 +0100
Message-ID: <CACRpkdagGWBcQz8mVj9OqH+xL_tr1hbVv7sTnJ9GeLVq0dRamw@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9 v3] net: ethernet: ixp4xx: Use parent dev for
 DMA pool
To:     David Miller <davem@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 6, 2020 at 11:01 PM David Miller <davem@redhat.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Mon,  6 Jan 2020 08:46:47 +0100
>
> > Use the netdevice struct device .parent field when calling
> > dma_pool_create(): the .dma_coherent_mask and .dma_mask
> > pertains to the bus device on the hardware (platform)
> > bus in this case, not the struct device inside the network
> > device. This makes the pool allocation work.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Networking changes don't use CC:'ing stable, please see the netdev
> FAQ under Documentation/

Oh yeah I actually knew that now, just that the patch was written
before I knew and I missed that was still in there.

> If you want to submit this bug fix, submit to 'net' and provide an
> appropriate Fixes: tag.

It's no big deal so let's skip that, do you want me to resend the lot
or can you just strip the stable tag when applying?

Yours,
Linus Walleij
