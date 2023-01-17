Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5717966E612
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjAQSdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjAQSa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:30:58 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD64391F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:02:38 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-15f64f2791dso2510201fac.7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NukCC4d4QJEDgfsOL/cdaVgghldPnWrPw2w2tKfD+uY=;
        b=VvnN3QFGrGjHMdoaWWpco2m+snxvy3UVxV1K+wJ6B9ExTsOzvvuLTtkLbMgnyNr4LP
         pMR0jGgbHwlQLSDz/4rzD90n0aRAxxo570PND+oKrlA4Y3bc0fFrJqsILnm6Qpul5dWe
         XEHudFeDMQ+XQZJegue7T1zHD0nTQDZHFLhcy+be7NV/O7+C470lRO49e1xMgilFQGED
         eiALN95KegtB8G8EQvSEYic1OozQeKs8rbEbB16kW5aIRRvopBZOw6AXhYbDsj82WwYu
         A7zRWsTD0eg5uq2f4Ozcoqg/ZmMajDhvewrD/OfVFpEInN4ggWxOMyUKYa1RmcC7uRXq
         YKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NukCC4d4QJEDgfsOL/cdaVgghldPnWrPw2w2tKfD+uY=;
        b=ZgO1XgVtLExEWra4qQU7kW6w1w5ga6G0iPujxe5Fg1wQ6yTAUvPXinBJWvK+EsVr+B
         GyFqti7kcj0/5iIycdPX+2PExf9ZCnqnec6z2CXtev6RykdT/HNeLhYd8QsBKjBEJeuV
         mGt26CawvMXYgnHkk8Q6cyqU84RgIn5NfUbnCGIaqX4awlTqxQ/nj0m5M49jfgQ1eGe9
         3QCe7DjwcQJ3jYk8hGHPBV+hxW1H0CuuxgfEtATRiYk8jjpwNCVBJNG4nqOAcbjyH7AM
         W1/4ulBzR00UKeCvFUUFfD1fLQDKnXScBVzmRsTRKLEwRm0EoatsrgvqeKKxSRBZCnio
         Ee1A==
X-Gm-Message-State: AFqh2koqs4me6YTsdbIi4pa4uUFnN3lfd5scqmJT+J8gtq8TvO87myqa
        XmENFk/o/5xACsmX2C+0B8gWHqtD1XzGrdDBi/GGfg==
X-Google-Smtp-Source: AMrXdXu+usIT51QrhN3XgtNGs2meY4k3VapR89YptIDkG9ps8gK7cX5MIHSnrazqyTfkC8I4ixxIhSkCKFinuEbLcyo=
X-Received: by 2002:a05:6870:4b4c:b0:15f:17fd:1531 with SMTP id
 ls12-20020a0568704b4c00b0015f17fd1531mr325174oab.115.1673978557152; Tue, 17
 Jan 2023 10:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20230116173420.1278704-1-mw@semihalf.com> <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk> <CAPv3WKcbuY0kmM0trfS++at=r4KhCsp2bZ1kBL2r+-YJe=kE3w@mail.gmail.com>
 <Y8bhzex/k05i9NCQ@shell.armlinux.org.uk>
In-Reply-To: <Y8bhzex/k05i9NCQ@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 17 Jan 2023 19:02:29 +0100
Message-ID: <CAPv3WKec6R_CVv8n5L-bGFg3QHpmUc+emeGV2Sm-DNM6SovGvQ@mail.gmail.com>
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Landen.Chao@mediatek.com, Samer.El-Haj-Mahmoud@arm.com,
        andrew@lunn.ch, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, jaz@semihalf.com, kuba@kernel.org,
        linus.walleij@linaro.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        olteanv@gmail.com, pabeni@redhat.com, rafael@kernel.org,
        sean.wang@mediatek.com, tn@semihalf.com, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 17 sty 2023 o 18:58 Russell King (Oracle) <linux@armlinux.org.uk>
napisa=C5=82(a):
>
> Hi Marcin,
>
> On Tue, Jan 17, 2023 at 05:20:01PM +0100, Marcin Wojtas wrote:
> > Hi Russell,
> >
> >
> > pon., 16 sty 2023 o 18:50 Russell King (Oracle) <linux@armlinux.org.uk>
> > napisa=C5=82(a):
> > >
> > > On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > > > fixed-link PHYs API is used by DSA and a number of drivers
> > > > and was depending on of_. Switch to fwnode_ so to make it
> > > > hardware description agnostic and allow to be used in ACPI
> > > > world as well.
> > >
> > > Would it be better to let the fixed-link PHY die, and have everyone u=
se
> > > the more flexible fixed link implementation in phylink?
> > >
> > ,
> > This patchset did not intend to introduce any functional change, simply
> > switch to a more generic HW description abstraction. Killing
> > of/fwnode_phy_(de)register_fixed_link entirely seems to be a challenge,=
 as
> > there are a lot of users beyond the DSA. Otoh I see a value in having
> > of_/fwnode_phy_is_fixed_link check, afaik there is no equivalent in
> > phylink...
>
> Phylink provides a much improved implementation of fixed-link that is
> way more flexible than the phylib approach - it can implement speeds
> in excess of 1G. DSA already supports phylink with modern updated
> drivers that do not use the "adjust_link" implementation.
>
> What I'm proposing is that we don't bring the baggage of the phylib
> based fixed link forwards into fwnode, and leave this to be DT-only.
> I think this is what Andrew and Vladimir have also said.
>

Ok, thanks for clarifying.

Best regards,
Marcin
