Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076B35838FA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiG1GsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiG1GsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:48:11 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC10D5A2D9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:48:09 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id s204so1458881oif.5
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HgwlQG4Lhx8whx7o14FpfCX9iHMs/wtL+rv0oLousaM=;
        b=Lp+CwaWO4nw6MMzfwGVjyhC14OxkQxYBsfkzHny0qQnxwHloJEKmoVOZZGAnkpqHIo
         uPz7OhI2Ic2ymiyTnvboWdPU590QzG5fUzNr+WKNARr+TzbLjGgFWQ/p7hUrFF8nFmel
         lVePTIE766U+suinIq5Dr+2BJyEjSSWTtii+TZy7gpNA7A2yhvSCuVG68jZotyQuPM5N
         5wvHmRNNkYHFFUKJazcwGEdIiwB8YuXKJ4tqQl+mQwb83tv7ycMPIqg50Kqc75VENa0M
         /kinDCpvUbgdEsMvqGP72oKu3x5tXmULOSw37vS4i1lRdAYXdBZaVrY0dtx/bE8ljZ6s
         ts7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HgwlQG4Lhx8whx7o14FpfCX9iHMs/wtL+rv0oLousaM=;
        b=2+0I9987N4U6bECn6Ulsr/StblMTbMulKxREwJXloLPy9xfPWzgCq64ix4uvH8N5E/
         GwzfaJ+4xrJvkHKgWz++gcG7XJYfsoqndtwL/Hs3561d5nSU1Jounb4oIOT0AUyxqX8V
         lZUFJb266LbwURf5jubAvWcUB4zoBiohREpnRwFKn/MiLTKEnj5NtlwAJ1baIm1FdI8K
         ORQJT7ZFQSdsrYkyA4wEt9GLoVtG0ZW2AxxZRAqtiQP8iU2nVwXsoqUo6GMxIz1CCg/s
         h1ioIVXa6w/f7b8lti0BxO6TYeIqFJ1gCQMpM40oxYX0X6zyNpJTl/oWqm/qLLVS3H+d
         lgdg==
X-Gm-Message-State: AJIora8i2FTuJ/ih9pfSNoVms6lYu1J3DBG3v/S0ZpjgkUWIvCFpuVBV
        tT00Py/cgvVLDrpYcyidiO8fu5+Um34Q+aYU9d6KxQ==
X-Google-Smtp-Source: AGRyM1thjZdUodZ96oXemTgQ1CJj0swEyhRb1esz/G34MlrxNe5eFkNSWTLvfNptPZrVZ1gJ5qWeseaVefgcm/2KvEU=
X-Received: by 2002:aca:ba86:0:b0:33a:c6f7:3001 with SMTP id
 k128-20020acaba86000000b0033ac6f73001mr3375710oif.5.1658990889029; Wed, 27
 Jul 2022 23:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf> <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <20220727211112.kcpbxbql3tw5q5sx@skbuf>
In-Reply-To: <20220727211112.kcpbxbql3tw5q5sx@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Jul 2022 08:47:58 +0200
Message-ID: <CAPv3WKcc2i6HsraP3OSrFY0YiBOAHwBPxJUErg_0p7mpGjn3Ug@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
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

=C5=9Br., 27 lip 2022 o 23:11 Vladimir Oltean <olteanv@gmail.com> napisa=C5=
=82(a):
>
> On Wed, Jul 27, 2022 at 07:40:00PM +0200, Marcin Wojtas wrote:
> > SET_NETDEV_DEV() fills net_device->dev.parent with &pdev->dev
> > and in most cases it is sufficient apparently it is sufficient for
> > fwnode_find_parent_dev_match (at least tests with mvneta case proves
> > it's fine).
>
> Indeed, mvneta works, which is a plain old platform device that hasn't
> even been converted to fwnode, so why don't the others?
>
> Well, as it turns out, it's one of the cases where I spoke to soon,
> thinking I knew what was the problem why probing failed, before actually
> debugging.
>
> I thought there was no dmesg output from DSA at all, which would have
> indicated an eternal -EPROBE_DEFER situation. But there's one tiny line
> I had overlooked:
>
> [    5.094013] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register=
 DSA switch
>
> This comes from here:
>
> static int dsa_port_parse_fw(struct dsa_port *dp, struct fwnode_handle *f=
wnode)
> {
>         struct fwnode_handle *ethernet =3D fwnode_find_reference(fwnode, =
"ethernet", 0);
>         bool link =3D fwnode_property_present(fwnode, "link");
>         const char *name =3D NULL;
>         int ret;
>
>         ret =3D fwnode_property_read_string(fwnode, "label", &name);
> //      if (ret)
> //              return ret;
>
>         dp->fwnode =3D fwnode;
>
> The 'label' property of a port was optional, you've made it mandatory by =
accident.
> It is used only by DSA drivers that register using platform data.

Thanks for spotting that, I will make it optional again.

>
> (side note, I can't believe you actually have a 'label' property for the
> CPU port and how many people are in the same situation as you; you know
> it isn't used for anything, right? how do we stop the cargo cult?)
>

Well, given these results:
~/git/linux : git grep 'label =3D \"cpu\"' arch/arm/boot/dts/ | wc -l
79
~/git/linux : git grep 'label =3D \"cpu\"' arch/arm64/boot/dts/ | wc -l
14

It's not a surprise I also have it defined in the platforms I test. I
agree it doesn't serve any purpose in terms of creating the devices in
DSA with DT, but it IMO increases readability of the description at
least.

> > Can you please check applying following diff:
> >
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -695,20 +695,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
> >   * The routine can be used e.g. as a callback for class_find_device().
> >   *
> >   * Returns: %1 - match is found
> >   *          %0 - match not found
> >   */
> >  int fwnode_find_parent_dev_match(struct device *dev, const void *data)
> >  {
> >         for (; dev; dev =3D dev->parent) {
> >                 if (device_match_fwnode(dev, data))
> >                         return 1;
> > +               else if (device_match_of_node(dev, to_of_node(data))
> > +                       return 1;
> >         }
> >
> >         return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(fwnode_find_parent_dev_match);
>
> So, nothing to do with device_match_fwnode() failing, that would have
> been strange, come to think about it. Sorry for the noise here.
>

Great, thank you for confirmation.

> But looking at the deeper implementation of dev_fwnode() as:
>
> struct fwnode_handle *dev_fwnode(struct device *dev)
> {
>         return IS_ENABLED(CONFIG_OF) && dev->of_node ?
>                 of_fwnode_handle(dev->of_node) : dev->fwnode;
> }
>
> I wonder, why did you have to modify mvpp2? It looks at dev->of_node
> prior to returning dev->fwnode. It should work.

When I boot with ACPI, the dev->of_node becomes NULL. With DT it's fine as-=
is.

Best regards,
Marcin
