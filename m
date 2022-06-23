Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EAC558770
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbiFWS0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbiFWS0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:26:08 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FEC6F7BF
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:27:23 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31772f8495fso1258087b3.4
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EL/06AiO/r0aaZHGPm8olM4Z1g8u3q+FzLtpTcwW9+E=;
        b=JnCT42yA4RwkalddkzPrJcFW4xS8/AuSbzy9tJ3tePu5bM24Ibqr3x++pzaPDrLfSq
         kaGJTArX9fUCrT0wKKOCtTLYJfjz7rj9imdcL7Pqfb4slmHg8IMENvZlqFm4OXbLEZny
         J9YpduFdJ0C9SGIfK3lAhmOLKKSD54emhGXwyTKd4zLc6mUsVCr0UEcbk+IU96MD0I9r
         JA/jzjJFQ+fQd7mJ8EkAmfjizWANCRRDX1m02PA1R+yQuTc3BWGj/hPC7P5U7eOqhdOe
         TNE+ns8QKBZrDwGhF91i4cSeiE94OXjudpzhMpSeD6m7B9EcjFqLK1KazAZTYMoHsxV2
         /pXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EL/06AiO/r0aaZHGPm8olM4Z1g8u3q+FzLtpTcwW9+E=;
        b=vOdJiXDVRf//s3B41Q1dF+bkABOcx2OfzUJ88IZs7lauZSYd6AV7P+FwdQ2Kax3JKG
         QL1Fr2KItXKuDQA0RlTBjod/NQdxIGwqy+dK0RS5HoZ1ObHVi+md/1B2VJ98NbK439gd
         jxpAeDXZ6tDGESOIij8aB+c/aCuq7WwTQcqLpkqu6sH5mAs1UxKfudrYJ+ufGNaR5REc
         URmHpbuv6qf8yVSdd2qXr72uUpzYgkO45EaybaC6yNIL4DcoDEo2JqWJJA6FMRmosJEA
         5sux5diMFPfx5M/W5R4YnPysstqGznqw7IPmePkXQ23rpOHe18A5WJjCNNEqC0uHQ++b
         BRZQ==
X-Gm-Message-State: AJIora9eybnWokS3yNUm8NgrSSPqonG5N62fmRAkpaT4q4rQwrxTeWjH
        Gh4zmKb3P1PZ7GciB7mOI9Ubu7ioW3gbYBvu9a1sHw==
X-Google-Smtp-Source: AGRyM1th3RmV9czY2nAQEMvAwHPPL7mFnNzI7DxsJuq4R6Wbusl3da+wwbtdHDw4EMO4U/ky+UtTRttD4UQUKoucelI=
X-Received: by 2002:a81:a095:0:b0:317:d4ce:38b6 with SMTP id
 x143-20020a81a095000000b00317d4ce38b6mr11755149ywg.83.1656005242403; Thu, 23
 Jun 2022 10:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de>
In-Reply-To: <20220623100421.GY1615@pengutronix.de>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 23 Jun 2022 10:26:46 -0700
Message-ID: <CAGETcx_eVkYtVX9=TOKnhpP2_ZpJwRDoBye3i7ND2u5Q-eQfPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     sascha hauer <sha@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
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

On Thu, Jun 23, 2022 at 3:05 AM sascha hauer <sha@pengutronix.de> wrote:
>
> On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> > Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > enabled iommus and dmas dependency enforcement by default. On some
> > systems, this caused the console device's probe to get delayed until the
> > deferred_probe_timeout expires.
> >
> > We need consoles to work as soon as possible, so mark the console device
> > node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> > the probe of the console device for suppliers without drivers. The
> > driver can then make the decision on where it can probe without those
> > suppliers or defer its probe.
> >
> > Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > Reported-by: Sascha Hauer <sha@pengutronix.de>
> > Reported-by: Peng Fan <peng.fan@nxp.com>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Tested-by: Peng Fan <peng.fan@nxp.com>
> > ---
> >  drivers/of/base.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index d4f98c8469ed..a19cd0c73644 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> >                       of_property_read_string(of_aliases, "stdout", &name);
> >               if (name)
> >                       of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> > +             if (of_stdout)
> > +                     of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
>
> The device given in the stdout-path property doesn't necessarily have to
> be consistent with the console= parameter. The former is usually
> statically set in the device trees contained in the kernel while the
> latter is dynamically set by the bootloader. So if you change the
> console uart in the bootloader then you'll still run into this trap.
>
> It's problematic to consult only the device tree for dependencies. I
> found several examples of drivers in the tree for which dma support
> is optional. They use it if they can, but continue without it when
> not available. "hwlock" is another property which consider several
> drivers as optional. Also consider SoCs in early upstreaming phases
> when the device tree is merged with "dmas" or "hwlock" properties,
> but the corresponding drivers are not yet upstreamed. It's not nice
> to defer probing of all these devices for a long time.
>
> I wonder if it wouldn't be a better approach to just probe all devices
> and record the device(node) they are waiting on. Then you know that you
> don't need to probe them again until the device they are waiting for
> is available.

That actually breaks things in a worse sense. There are cases where
the consumer driver is built in and the optional supplier driver is
loaded at boot. Without fw_devlink and the deferred probe timeout, we
end up probing the consumer with limited functionality. With the
current setup, sure we delay some probes a bit but at least everything
works with the right functionality. And you can reduce or remove the
delay if you want to optimize it.

-Saravana
