Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8A555570
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 22:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiFVUgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 16:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVUgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 16:36:08 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BFB38BC1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 13:36:03 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3176b6ed923so174555607b3.11
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 13:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0Q20J3OyFK4BXoHp26oZBRHT0NT/TPRkGHoG9EjHBM=;
        b=AIh/u0M6R759JTz79TyCN93gK6bgpHDzPVQZ1c1GJ5mwFOuIeCYHJ4edi50jml847F
         YlyEIG6KHqq8aPkZTHE9o8riSh+o+aPdQkAJtuBIbSQJ1Qvz8SxbjAaqCBGJVWgX2P/S
         /lWL8gVqkrxuDaPOll9RogYmQJePhkDfIDDmdpqwgFqUaxnpkJlZlOJqH2LK8OYh0EHS
         NkvT2u3I65Z8qEvtK4yyQHIJoLFYRlLWUJzUrck6e096qTWwpgSy4j4OJNJBxKuqt4cm
         +0dfDWU9Ra9WoP4nC6yrNay035tCUQh6UFCC2SBvyjlcMQdeY4uW7Ka6L/TCcUlvjRXY
         RbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0Q20J3OyFK4BXoHp26oZBRHT0NT/TPRkGHoG9EjHBM=;
        b=rTi/mWk8o84NzNpG58CLrIwAPQuzz46neMRMJFiqiWavMfFUVHYn6+LOUaNyA8IQ7D
         rgAs9GeNCCa5Wf2UVXSbVRv/1tXUdrdR/fOCBFMn3kKuXZW17Z5vI2FMkjVJC+HMcHfe
         zprtZA0p0fhSZ6vZnUGwqApXC5liH1/2qAESVRK0LSSkazKbzIjprlfoTo+ANNuzTgVB
         Xx/88ugO7ARC0IvTPbehuk+LcCgL1A2pBSa5dTO/08dM0ooif+L0BlEmegp+mk6W40L3
         KHBHCzg1zZDtNRwAtkTGgGsFPont/qIG2BcsfAIByXl20Nvu/7kxeOlNns1WCdkWlXt1
         Hz+w==
X-Gm-Message-State: AJIora8e7yxpdZF2NUG+CNNt6RtJprXBdKRxUYkrMAYA24shsx/Yfa9o
        aP78vvxsgUPBYwgOfhlOD06ISlnJHbHX/S3FKSlLLQ==
X-Google-Smtp-Source: AGRyM1tZz2wdFHKMCQcrlrsexZuCcN2icaf5UPnPLdD9I4E6Eu6Q2ruY0h+nLZ4RTx4/aeKVzxa/AbO9gvemQvBe43c=
X-Received: by 2002:a81:a095:0:b0:317:d4ce:38b6 with SMTP id
 x143-20020a81a095000000b00317d4ce38b6mr6426893ywg.83.1655930162762; Wed, 22
 Jun 2022 13:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-8-saravanak@google.com> <20220622074756.GA1647@pengutronix.de>
 <CACRpkdYe=u9Ozj_dtLVr6GSau8yS5H7LnBNNrQHki1CJ1zST0A@mail.gmail.com> <CAGETcx_qm7DWbNVTLfF9jTgGA8uH8oAQzbPcMDh4L6+5mdRFog@mail.gmail.com>
In-Reply-To: <CAGETcx_qm7DWbNVTLfF9jTgGA8uH8oAQzbPcMDh4L6+5mdRFog@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 22 Jun 2022 13:35:26 -0700
Message-ID: <CAGETcx8i9R51T-mGuV9_LUz-GXDCncpRWQ1Rj_7i2JrvCttq3w@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] driver core: Set fw_devlink.strict=1 by default
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Sascha Hauer <sha@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:40 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Wed, Jun 22, 2022 at 1:44 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > On Wed, Jun 22, 2022 at 9:48 AM Sascha Hauer <sha@pengutronix.de> wrote:
> >
> > > This patch has the effect that console UART devices which have "dmas"
> > > properties specified in the device tree get deferred for 10 to 20
> > > seconds. This happens on i.MX and likely on other SoCs as well. On i.MX
> > > the dma channel is only requested at UART startup time and not at probe
> > > time. dma is not used for the console. Nevertheless with this driver probe
> > > defers until the dma engine driver is available.
>
> FYI, if most of the drivers are built in, you could set
> deferred_probe_timeout=1 to reduce the impact of this (should drop
> down to 1 to 2 seconds). Is that an option until we figure out
> something better?
>
> Actually, why isn't earlyconsole being used? That doesn't get blocked
> on anything and the main point of that is to have console working from
> really early on.
>
> > >
> > > It shouldn't go in as-is.
> >
> > This affects all machines with the PL011 UART and DMAs specified as
> > well.
> >
> > It would be best if the console subsystem could be treated special and
> > not require DMA devlink to be satisfied before probing.
>
> If we can mark the console devices somehow before their drivers probe
> them, I can make fw_devlink give them special treatment. Is there any
> way I could identify them before their drivers probe?
>
> > It seems devlink is not quite aware of the concept of resources that are
> > necessary to probe vs resources that are nice to have and might be
> > added after probe.
>
> Correct, it can't tell them apart. Which is why it tries its best to
> enforce them, get most of them ordered properly and then gives up
> enforcing the rest after deferred_probe_timeout= expires. There's a
> bit more nuance than what I explained here (explained in earlier
> commit texts, LPC talks), but that's the gist of it. That's what's
> going on in this case Sascha is pointing out.z
>
> > We need a strong devlink for the first category
> > and maybe a weak devlink for the latter category.
> >
> > I don't know if this is a generic hardware property for all operating
> > systems so it could be a DT property such as dma-weak-dependency?
> >
> > Or maybe compromize and add a linux,dma-weak-dependency;
> > property?
>
> The linux,dma-weak-dependency might be an option, but then if the
> kernel version changes and we want to enforce it because we now have a
> dma driver (not related to Shasha's example) support, then the
> fw_devlink still can't enforce it because of that property. But maybe
> that's okay? The consumer can try to use dma and defer probe if it
> fails?
>
> Another option is to mark console devices in DT with some property and
> we can give special treatment for those without waiting for
> deferred_probe_timeout= to expire.

Heh, looks like there's already a property for that: stdout-path.

Let me send a series that'll use that to give special treatment to
console devices.

-Saravana
