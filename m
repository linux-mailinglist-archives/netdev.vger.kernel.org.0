Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EC4BF490
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiBVJV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiBVJVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:21:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EBF149B9F;
        Tue, 22 Feb 2022 01:21:00 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c6so32480106edk.12;
        Tue, 22 Feb 2022 01:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W+fmOCb56NZVpaqqf1Z42IP4bJHPnZUVGUrK3OMEjMM=;
        b=BQtwwIozKsncjtjtlGVgl9d3JmfLYqaJDPzIBLZ/vVdf9W5lHFcfnaA7VsfNDBMdUV
         8UbiaD6LmVR7S5ZmGb71oUZ6+7fRCDfxxntR31v5njPoYkmt2mRf5mL99ZGC/0fx40l9
         4kroNisVs8iJWFKcmieBTejfgsSvhhCiPXVTaR5NqQ6Ov2ZrrzFmOdAtcAHQuRIdUI2H
         fu61aYcfzPTSoycavPl6HMAWN0pxZMeIpIXjGZIucJJaYkMiRl9ukexON9aEBBQFcFTJ
         gNyrSJS/b/J4wRBvDaPGcDGbW9PmLTEZyVqEHR+v43546oV1yksOqiVcsuxwzPXo0SPw
         Wbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+fmOCb56NZVpaqqf1Z42IP4bJHPnZUVGUrK3OMEjMM=;
        b=XmQHWCg5O9rqlzaFah1rwVYQ7JKSVA6la52edY7lxbVrX0clefSzRWMqDDEwFpy0xt
         bdPLK6WrjLk8L+4sqOtoT+VzT1zcAdPmNPxzEYidAxJrhA2X4fG21cACIa1xX0EY5ok/
         6Z28j9wjfGMMLTFZSwpFeKnSfYMu2gAGKuNBX0v0SyfY2IMY+bWPt4iB2anXW/kPIS/u
         cA6I9vobnX+KTR3/8IfvjK4Gu1dzdYHak0gI9VdnWl7CzOEr7G6e3riRJEKZB+8Ek2qX
         nniA6XV1uzzTyaIv7HZByP7bMJ5eWXt3D6/+cVwGXYYiS3E/aQUpte4S2p9u+CeoX2eZ
         Ki4Q==
X-Gm-Message-State: AOAM533PWeiSAs72soQ3riOs5/bDX70MKK6/0Q6GClTSWSaIS83gaEld
        MvqVgHZ0W+F+m4p/tuhK7Bslu4l3iPyj3G9Tj4M=
X-Google-Smtp-Source: ABdhPJyamj2rmrvB6dWO2xp1g6uOPNu7oLOSu/axqdeMZ9rMcD47b0cq8Gp1VukbGGbjBdgtjX84TjFgCAqCJX4AQsw=
X-Received: by 2002:a05:6402:5107:b0:412:8530:3ba9 with SMTP id
 m7-20020a056402510700b0041285303ba9mr25450809edd.264.1645521659276; Tue, 22
 Feb 2022 01:20:59 -0800 (PST)
MIME-Version: 1.0
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhQHqDJvahgriDZK@lunn.ch> <CAHp75VeHiTo6B=Ppz9Yc6OiC7nb5DViDt_bGifj6Jr=g89zf8Q@mail.gmail.com>
 <YhSlX01mEpFiRZQR@lunn.ch>
In-Reply-To: <YhSlX01mEpFiRZQR@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 22 Feb 2022 10:20:23 +0100
Message-ID: <CAHp75VcrhRaCMq8fwFtf9NPGQTedszwDHmqsibfB-uBxkaBb2A@mail.gmail.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:57 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > In the DT world, we avoid snow flakes. Once you define a binding, it
> > > is expected every following board will use it. So what i believe you
> > > are doing here is defining how i2c muxes are described in APCI.
> >
> > Linux kernel has already established description of I2C muxes in ACPI:
> > https://www.kernel.org/doc/html/latest/firmware-guide/acpi/i2c-muxes.html
> >
> > I'm not sure we want another one.
>
> Agreed. This implementation needs to make use of that. Thanks for
> pointing it out. I don't know the ACPI world, are there any other
> overlaps with existing ACPI bindings?

Besides ACPI specification, which defines _CRS resources, such as I2C,
SPI, GPIO, and other peripheral connections, in the Linux kernel we
have already established these [1]. I hope it's all here, since in the
past not everything got documented and there were some documentation
patches in time.

On top of that there are some Microsoft documents on enumeration that
Linux follows, such as USB embedded devices [2]. There is also a PCI
FW specification that defines how PCI bus devices, bridges, etc have
to be represented in ACPI, including additional tables, such as MCFG.

[1]: https://www.kernel.org/doc/html/latest/firmware-guide/acpi/enumeration.html
[2]: https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/other-acpi-namespace-objects#acpi-namespace-hierarchy-and-_adr-for-embedded-usb-devices

-- 
With Best Regards,
Andy Shevchenko
