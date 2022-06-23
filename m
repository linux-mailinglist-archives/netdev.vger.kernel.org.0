Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B66A55886A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiFWTNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiFWTN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:13:26 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53D66362B
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:17:48 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef5380669cso2338337b3.9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5I7lwaxg3ERNdh1USCLL4gsDNHBsesSwjbd6s/cNSY=;
        b=HJ6V5dP4AOSSwMe7wcgfuDX/clqSs9gbT7weCDHIdQMoMq/tOG9jM9s9f0AVeRDeGC
         6i5p1kAgTQDU+NkxVXG7PAUzfambG55P1F4tcUrSXCH+tWquWb0GtqXEg+nA8Dchanzn
         HRW1WDYo5QE/5U8e3rDPy8HatPAjphhwWyXIsW7bt1MI5QLeN/88pxyeRjlGf5flDm1D
         YFJuq5/ejD0Xbcv02GN2um3+I2gA0lfF+XZedqX37LXzCxA7LGwtr/E9d95mnlTXfr5z
         bsQ/MyVF23+eCsn7mS+xZwrqAGSVGxeXvWRjd8N+eXvQsslukdaOR7K9u2E0eGYmGLYO
         oqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5I7lwaxg3ERNdh1USCLL4gsDNHBsesSwjbd6s/cNSY=;
        b=bct4CPjW1aOeL3kx1ukIn+MTJGMIe8VpF5flSYbWoOM57eiNqcjEotEjBdU4uhB2pz
         B7A7iFHEvnnWmPmQlIbbDSGJtGa1hKdvb6APjth2Gsq6LW4DOv/zih3JJbVyxipbWuQx
         k8CHAEJM/8vF/MFhAdWWZFOZxVB7AcU8q7x0yhiq2WBY1WWyEZ9PpX9ctWlyv0ozoTpC
         Aqtj4L6OIw4XGH4I5R84O2sJMpfDJP9paq/ec8WVYDxk7gmsSLHvfs/tVG3X0b081Zjm
         7Vk+vMOS3hOqaKEh/vDVgALehqCfkIriK5aIYK2lwmSnTWT0VpG4oBwuAFEUSePwVcQP
         i/Kg==
X-Gm-Message-State: AJIora/twcHH3uz0GEOkw/05L0hpzA5NOLssob9ppUlEIflR/Jpvfb0+
        slncZqvAlmYUEzXmxpaKqq/HIfWvt0wViUTW5gb4aQ==
X-Google-Smtp-Source: AGRyM1uilfZ0qukZAX74cZpSq2rgoRk3U9n8kYZfj2P22qz/S+S3tWRG5TkEZw7C9nYFw+KJ3ktelnjUqr/SV5UBD5M=
X-Received: by 2002:a81:4896:0:b0:317:f767:95f8 with SMTP id
 v144-20020a814896000000b00317f76795f8mr12660216ywa.218.1656008259994; Thu, 23
 Jun 2022 11:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de> <CAGETcx_eVkYtVX9=TOKnhpP2_ZpJwRDoBye3i7ND2u5Q-eQfPg@mail.gmail.com>
 <ec4168b6-36f1-0183-b1ed-6a33d9fa1bbc@pengutronix.de>
In-Reply-To: <ec4168b6-36f1-0183-b1ed-6a33d9fa1bbc@pengutronix.de>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 23 Jun 2022 11:17:03 -0700
Message-ID: <CAGETcx9ytCwrYUbS2PpuaCSyGq60HbWJexatv74Zz3qk973wmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     sascha hauer <sha@pengutronix.de>, andrew lunn <andrew@lunn.ch>,
        peng fan <peng.fan@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linus walleij <linus.walleij@linaro.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        eric dumazet <edumazet@google.com>,
        pavel machek <pavel@ucw.cz>, will deacon <will@kernel.org>,
        kevin hilman <khilman@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        joerg roedel <joro@8bytes.org>,
        russell king <linux@armlinux.org.uk>,
        linux-acpi@vger.kernel.org, jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>, kernel-team@android.com,
        Len Brown <lenb@kernel.org>, len brown <len.brown@intel.com>,
        kernel@pengutronix.de, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        david ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        Daniel Scally <djrscally@gmail.com>,
        iommu@lists.linux-foundation.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        netdev@vger.kernel.org, "david s. miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, heiner kallweit <hkallweit1@gmail.com>
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

On Thu, Jun 23, 2022 at 10:36 AM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
> Hello Saravana,
>
> On 23.06.22 19:26, Saravana Kannan wrote:
> > On Thu, Jun 23, 2022 at 3:05 AM sascha hauer <sha@pengutronix.de> wrote:
> >>
> >> On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> >>> Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> >>> enabled iommus and dmas dependency enforcement by default. On some
> >>> systems, this caused the console device's probe to get delayed until the
> >>> deferred_probe_timeout expires.
> >>>
> >>> We need consoles to work as soon as possible, so mark the console device
> >>> node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> >>> the probe of the console device for suppliers without drivers. The
> >>> driver can then make the decision on where it can probe without those
> >>> suppliers or defer its probe.
> >>>
> >>> Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> >>> Reported-by: Sascha Hauer <sha@pengutronix.de>
> >>> Reported-by: Peng Fan <peng.fan@nxp.com>
> >>> Signed-off-by: Saravana Kannan <saravanak@google.com>
> >>> Tested-by: Peng Fan <peng.fan@nxp.com>
> >>> ---
> >>>  drivers/of/base.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/drivers/of/base.c b/drivers/of/base.c
> >>> index d4f98c8469ed..a19cd0c73644 100644
> >>> --- a/drivers/of/base.c
> >>> +++ b/drivers/of/base.c
> >>> @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> >>>                       of_property_read_string(of_aliases, "stdout", &name);
> >>>               if (name)
> >>>                       of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> >>> +             if (of_stdout)
> >>> +                     of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
> >>
> >> The device given in the stdout-path property doesn't necessarily have to
> >> be consistent with the console= parameter. The former is usually
> >> statically set in the device trees contained in the kernel while the
> >> latter is dynamically set by the bootloader. So if you change the
> >> console uart in the bootloader then you'll still run into this trap.
> >>
> >> It's problematic to consult only the device tree for dependencies. I
> >> found several examples of drivers in the tree for which dma support
> >> is optional. They use it if they can, but continue without it when
> >> not available. "hwlock" is another property which consider several
> >> drivers as optional. Also consider SoCs in early upstreaming phases
> >> when the device tree is merged with "dmas" or "hwlock" properties,
> >> but the corresponding drivers are not yet upstreamed. It's not nice
> >> to defer probing of all these devices for a long time.
> >>
> >> I wonder if it wouldn't be a better approach to just probe all devices
> >> and record the device(node) they are waiting on. Then you know that you
> >> don't need to probe them again until the device they are waiting for
> >> is available.
> >
> > That actually breaks things in a worse sense. There are cases where
> > the consumer driver is built in and the optional supplier driver is
> > loaded at boot. Without fw_devlink and the deferred probe timeout, we
> > end up probing the consumer with limited functionality. With the
> > current setup, sure we delay some probes a bit but at least everything
> > works with the right functionality. And you can reduce or remove the
> > delay if you want to optimize it.
>
> I have a system that doesn't use stdout-path and has the bootloader
> set console= either to ttynull when secure booting or to an UART
> when booting normally. How would I optimize the kernel to avoid
> my UART being loaded after DMA controller probe without touching
> the bootloader?
>

Thanks for the report Ahmad. I think someone else reported a similar
thing in another thread. I plan to take a look at it. It should be
possible to find the device and set the flag for those devices too.

-Saravana
