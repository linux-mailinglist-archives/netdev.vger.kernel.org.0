Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A0207753
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404323AbgFXPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXPYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 11:24:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EACC061573;
        Wed, 24 Jun 2020 08:24:19 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so2866465ejb.4;
        Wed, 24 Jun 2020 08:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D5fcBmctUqkWRaCAlEquaCo151xfdRO5uLvWNbrg/T4=;
        b=lneLGurgH4ESLltEQrI6RKR+MKIH5cMowieW6nb3PawBpUTe8dVgXXy8oMVUK4D+zC
         61WQaa5yJ1WzosFIDyQOD1CeZNhfkijfHCaT6mJAdif+JAeN342vfOojjhY8ewmYPOzq
         I4kosKQDArhuQ2/XphencidtJupidiJX+nZ5H6E7oaqCqRewZQ3U+4o3EzmxXdA3Rr7j
         4qmsbilXgqZ0HMl8Ur1ZL0mPzVIuxqRV1viDITxeKOkGQl11bsqz6AevPORWx6Bp15Vr
         TjnOlBl9Mn2pzwKcOnHs6/3+0411yKC2rOwo5wP78mP9XfNzXPI6N131Rmc32t+nTZth
         gmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D5fcBmctUqkWRaCAlEquaCo151xfdRO5uLvWNbrg/T4=;
        b=pX5G4sSYWmn+mPK4+7RfzNCfl/J284ocKLVLy3MDgiNGoV6rgdGlVMnShRPDz2vDEQ
         Pfi6o2VuqiTuGBiYuC1b+bogHdmPOpmA9MvYlw7vLOR3qXkMFdwayPLwoOjfuzR9TM4e
         OSPY6DSyXV5PELv6LuKV6JS7gWwamVXQeL2rZzf0XYRqFQHpubZbpCNeld5rLRpK46ss
         HC+iSZaEQaYwZFsZRDDW/mY55lNDRp2GAbwp1bb5dqC+V0s4z2GRhMcQSPtKBEtgQJe9
         kqsrXB03ZXT8Jd5m/QRfBtw1H9Q1S8CZfbco0GvGP+KRrbjcn/dZAW8iqXh8WKGeO7qj
         niXw==
X-Gm-Message-State: AOAM530SiHeud6uFxSRQ+YDj7se6d+W/LUM/h3K+m33jSE5jPosw/fGD
        5fu1rSi/0ZEKSRmHvIv/4Y9HuGC/GC98PjZvs4YQxw==
X-Google-Smtp-Source: ABdhPJxXGFYEUDzodXY4S+pGgiGRko+o5hHsygS3MwblQ/K5dQVLFwuQYt/iX5NoNFt1e3/nk2D1FtPqKZ2S2whWJAI=
X-Received: by 2002:a17:906:5949:: with SMTP id g9mr7426231ejr.305.1593012258194;
 Wed, 24 Jun 2020 08:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200623090541.2964760-1-horatiu.vultur@microchip.com>
 <20200623.143821.491798381160245817.davem@davemloft.net> <20200624113156.hsutqewk4xntmkld@soft-dev3.localdomain>
In-Reply-To: <20200624113156.hsutqewk4xntmkld@soft-dev3.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 24 Jun 2020 18:24:07 +0300
Message-ID: <CA+h21hogZsJZUksYY66_=-qkdG3kDA+byfX0tV=C-80M6mfYMA@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] bridge: mrp: Update MRP_PORT_ROLE
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     David Miller <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Wed, 24 Jun 2020 at 14:34, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 06/23/2020 14:38, David Miller wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Date: Tue, 23 Jun 2020 11:05:39 +0200
> >
> > > This patch series does the following:
> > > - fixes the enum br_mrp_port_role_type. It removes the port role none(0x2)
> > >   because this is in conflict with the standard. The standard defines the
> > >   interconnect port role as value 0x2.
> > > - adds checks regarding current defined port roles: primary(0x0) and
> > >   secondary(0x1).
> > >
> > > v2:
> > >  - add the validation code when setting the port role.
> >
> > Series applied, thank you.
>
> Thanks. Will these patches be applied also on net-next?
> Because if I start now to add support for the interconnect port, these
> patches are needed on net-next. Or do I need to add these patches to the
> patch series for the interconnect port?
> What is the correct way of doing this?
>
> --
> /Horatiu

The "net" tree is merged weekly (or so) by David into "net-next". So,
your patches should be available at the beginning of the next week.

Cheers,
-Vladimir
