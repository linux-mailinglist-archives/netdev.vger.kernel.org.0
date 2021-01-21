Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD1B2FEA87
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbhAUMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731457AbhAUMne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:43:34 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A5CC061786
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 04:42:53 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ke15so2349337ejc.12
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 04:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MjMz3jMAmx31vHLhBLdAj2dWwGBMusldt+HkpMNKmQY=;
        b=PIvsyyqJHeqQO7jzw+mvK9KLxFNZUrt+UuboEguS4ntJr3xlwtFlie5wULEeRWHuPZ
         e9u3iSmmG4IjxzInVqF6ZqqqC3KNhqErekOrdO/MBuYh7jq3WSanq6weAf7kzawP+t34
         4AsT4xsQTZEw54R4/mqAjWvZrKAqlmQhpihWk/HeI4BZYs9HuTzHfRZ3f/33YBzznwiU
         TwuYEsOoPiT6zVkIXDO2i5SgHsmbh15/FEnNRK2CaIkj5b9TnmqKQHmNpdJsb96qQx8P
         5gvdlI02dpnHlV+jzKVK+bblUY+ZyYFcxBV9DPN+jPzKLbAQHJbDq+KUYKlb36zE8kxy
         G6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MjMz3jMAmx31vHLhBLdAj2dWwGBMusldt+HkpMNKmQY=;
        b=n6kSpMQwkhf91CGU09hZEcpHRD/BUvhIS/vrQnFGfXjZGqx+HfQzFS6qiMH+khxFYZ
         QjqmjEc8ssM6714oVbSFdm1FmoA3KuXHwTESra8+T8VuRWtlaKnJWa5towb73+MRx9BB
         2YSE5SqHjNopi7XaACNr1XBgL3DHgwcaoL82cjroNAHI8M4PXhhTo5R2QRwDcyHvMqLp
         rtxM/T9fCXhk3MZm6fF4OYzBgSZ7M+LDmKvExCr7qFVRKaFR8+bIQh1cE+9ARKzJJa0g
         wyo6qAd5CTZfKm7lHgbCAqeKLMeMpm3SMXJXkrnAOWTw1/FMqoa8vWOPFP9ltz2rJRZ4
         pg0Q==
X-Gm-Message-State: AOAM532yDV9wWolEhIGqwS8eJvwUhX4glp7atVByeVjRa/MNCwn5upfR
        Z/KzQdXx5PqOkY1CA5BLMy25O58xWejmKk0lKjY=
X-Google-Smtp-Source: ABdhPJxeK7mgxp09GsGz6mR8TCwb7ZFueOlAjY5tyCx2iv1CnRZA7vX3E9Oo1UlOm69RvE/XLRMulufUcHjF0NlBOAc=
X-Received: by 2002:a17:906:2e9a:: with SMTP id o26mr9175030eji.77.1611232972084;
 Thu, 21 Jan 2021 04:42:52 -0800 (PST)
MIME-Version: 1.0
References: <20210121070906.25380-1-haokexin@gmail.com> <8a9fdef33fd54340a9b36182fd8dc88e@AcuMS.aculab.com>
 <20210121115141.GA472545@pek-khao-d2.corp.ad.wrs.com>
In-Reply-To: <20210121115141.GA472545@pek-khao-d2.corp.ad.wrs.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 21 Jan 2021 18:12:39 +0530
Message-ID: <CA+sq2CeOUWvmrQ36JkO9VHvkWOf=ONYzitXRp+ZHE+U1JbU4Lg@mail.gmail.com>
Subject: Re: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
To:     Kevin Hao <haokexin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 5:26 PM Kevin Hao <haokexin@gmail.com> wrote:
>
> On Thu, Jan 21, 2021 at 09:53:08AM +0000, David Laight wrote:
> > From: Kevin Hao
> > > Sent: 21 January 2021 07:09
> > >
> > > The octeontx2 hardware needs the buffer to be 128 byte aligned.
> > > But in the current implementation of napi_alloc_frag(), it can't
> > > guarantee the return address is 128 byte aligned even the request size
> > > is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> > > use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
> > >
> > > Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
> > > Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > > ---
> > >  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > > index bdfa2e293531..5ddedc3b754d 100644
> > > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > > @@ -488,10 +488,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
> > >     dma_addr_t iova;
> > >     u8 *buf;
> > >
> > > -   buf = napi_alloc_frag(pool->rbsize);
> > > +   buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
> > >     if (unlikely(!buf))
> > >             return -ENOMEM;
> > >
> > > +   buf = PTR_ALIGN(buf, OTX2_ALIGN);
> > >     iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> > >                                 DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> > >     if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> > > --
> > > 2.29.2
> >
> > Doesn't that break the 'free' code ?
> > Surely it needs the original pointer.
>
> Why do we care about the original pointer? The free code should work with
> the mangling poiner. Did I miss something?
>
> >

I too agree, put_page(buf) or put_page(buf + OTX2_ALIGN) is same.
