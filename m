Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4796D556E78
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358641AbiFVWbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiFVWbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:31:03 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9CF3DA6B
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:31:00 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3178acf2a92so143211407b3.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9SfIkHxS+Q1Jb8k0oSMqRlf7MlpWHzDTC+soyTtijyM=;
        b=NebdBOf6fdS4nX2gfyfe8m1T6/C9zAE+3VIuCNVBM6MPWjXuoJzdqqPsTsUAR6pfvG
         xA4MVTApPXt06pwHKnuxwV1EYeC4UcXbEXYkkIdwQyxlj/bO1PmEbgnS2x2hgpF3lHP4
         h4UqwgdlMJTc14qMEg5zU9/3ErEGdK4mjOqA8Eftkugl+g7j+weQvtGSUWigyARlr1O/
         Bs+mhgd3gJiFyzFiiuJ+PVCKt6Z+Vtj9jRHkqKHTlRfColtigSBwNJxsrLimrFlpRpDJ
         QixEZsgjs01NM5W7QvGFsEB3Zd0eeS22AhTr5GnnlvMKF4SYTr1gGHBVfrUyl3Ptpb/A
         t32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SfIkHxS+Q1Jb8k0oSMqRlf7MlpWHzDTC+soyTtijyM=;
        b=rvVt9ZuN+zDB8uxEJCpojjVrREUElxlz5IcmdK44VvcaNkaieRuraEJrD0yrlmzCKk
         CXVAhFTGmhK0lFk8hAIulIjgyFQjXYymEI8y4VBPHNi/A+zdjaoPmVKFUwXDzMdrcokz
         zU89Xi5MZ4a9lWFVCv5Tpz1dpq3agB0tAVCMAgQr0qjiGCSnUv6PlQs84KfG7ZozmEw3
         i73Xbeq8M2MiSuBrqxOboxvuO8AIQiOlHcEuOtlRlMI1Re6N25Oj/er8TXnZKBsBZiuR
         m0Xu/m6SHjRaHJPt+76UU9ME4xHOhCJld/y0uAtSDEYKvvwT7ZSnt0DHLqph7uy3YUdL
         xiYw==
X-Gm-Message-State: AJIora8feQkroQKfisyFEo3mjiBEqv+lDExXCVL9nKVLqxh89sHgP4HZ
        NcTQxIZA8XoTmJQrv/FZn3WdX5EH4AWdafXyf2cALg==
X-Google-Smtp-Source: AGRyM1uYQIJJIqU5tgV6IO3uAtRp3fBa6488p3xRR/8VoSm4ObswB9eZF/y0HTd/1fbTAGXMYHZo8GPW9b+ZXRnH0VI=
X-Received: by 2002:a81:8486:0:b0:317:a4af:4e0a with SMTP id
 u128-20020a818486000000b00317a4af4e0amr6985709ywf.455.1655937059385; Wed, 22
 Jun 2022 15:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-8-saravanak@google.com> <20220622074756.GA1647@pengutronix.de>
 <CACRpkdYe=u9Ozj_dtLVr6GSau8yS5H7LnBNNrQHki1CJ1zST0A@mail.gmail.com>
 <CAGETcx_qm7DWbNVTLfF9jTgGA8uH8oAQzbPcMDh4L6+5mdRFog@mail.gmail.com> <CAGETcx8i9R51T-mGuV9_LUz-GXDCncpRWQ1Rj_7i2JrvCttq3w@mail.gmail.com>
In-Reply-To: <CAGETcx8i9R51T-mGuV9_LUz-GXDCncpRWQ1Rj_7i2JrvCttq3w@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 22 Jun 2022 15:30:23 -0700
Message-ID: <CAGETcx9XnyceCRBhgQc_YAYyJRca_Q-GPD8sh0cgCCuohzG16A@mail.gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 1:35 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Wed, Jun 22, 2022 at 12:40 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 1:44 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> > >
> > > On Wed, Jun 22, 2022 at 9:48 AM Sascha Hauer <sha@pengutronix.de> wrote:
> > >
> > > > This patch has the effect that console UART devices which have "dmas"
> > > > properties specified in the device tree get deferred for 10 to 20
> > > > seconds. This happens on i.MX and likely on other SoCs as well. On i.MX
> > > > the dma channel is only requested at UART startup time and not at probe
> > > > time. dma is not used for the console. Nevertheless with this driver probe
> > > > defers until the dma engine driver is available.
> >
> > FYI, if most of the drivers are built in, you could set
> > deferred_probe_timeout=1 to reduce the impact of this (should drop
> > down to 1 to 2 seconds). Is that an option until we figure out
> > something better?
> >
> > Actually, why isn't earlyconsole being used? That doesn't get blocked
> > on anything and the main point of that is to have console working from
> > really early on.
> >
> > > >
> > > > It shouldn't go in as-is.
> > >
> > > This affects all machines with the PL011 UART and DMAs specified as
> > > well.
> > >
> > > It would be best if the console subsystem could be treated special and
> > > not require DMA devlink to be satisfied before probing.
> >
> > If we can mark the console devices somehow before their drivers probe
> > them, I can make fw_devlink give them special treatment. Is there any
> > way I could identify them before their drivers probe?
> >
> > > It seems devlink is not quite aware of the concept of resources that are
> > > necessary to probe vs resources that are nice to have and might be
> > > added after probe.
> >
> > Correct, it can't tell them apart. Which is why it tries its best to
> > enforce them, get most of them ordered properly and then gives up
> > enforcing the rest after deferred_probe_timeout= expires. There's a
> > bit more nuance than what I explained here (explained in earlier
> > commit texts, LPC talks), but that's the gist of it. That's what's
> > going on in this case Sascha is pointing out.z
> >
> > > We need a strong devlink for the first category
> > > and maybe a weak devlink for the latter category.
> > >
> > > I don't know if this is a generic hardware property for all operating
> > > systems so it could be a DT property such as dma-weak-dependency?
> > >
> > > Or maybe compromize and add a linux,dma-weak-dependency;
> > > property?
> >
> > The linux,dma-weak-dependency might be an option, but then if the
> > kernel version changes and we want to enforce it because we now have a
> > dma driver (not related to Shasha's example) support, then the
> > fw_devlink still can't enforce it because of that property. But maybe
> > that's okay? The consumer can try to use dma and defer probe if it
> > fails?
> >
> > Another option is to mark console devices in DT with some property and
> > we can give special treatment for those without waiting for
> > deferred_probe_timeout= to expire.
>
> Heh, looks like there's already a property for that: stdout-path.
>
> Let me send a series that'll use that to give special treatment to
> console devices.

Here's the fix.
https://lore.kernel.org/lkml/20220622215912.550419-1-saravanak@google.com/

Sascha, can you give it a shot?

-Saravana
