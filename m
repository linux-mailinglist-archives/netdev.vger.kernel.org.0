Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A882C4AA330
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350448AbiBDWgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350310AbiBDWgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:36:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9CFD210536
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:36:07 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so7403059pjb.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atIvdbbgNJhEtgYsiRDaIlp5c71qNxWW6NldhDMZOaE=;
        b=Zxd2f/qJqimaQ8VLu698VAUrPThnH5QJb3TSwwtn61IdrO29Lv5bZt+kEUbwgiLm81
         x7jReEARezGvS7ZbELnZBenOyW9A+ncqPeq9zjVyTz30CIQXR3U00F3t6Whuh6ix+uOx
         I/sh4E78bc9CcFcP40/XlQZmHQcAq3PBt9Oo9IokC+qM9XWbcPth8V3KLPoWcKHqv8eY
         TwYdaRMyG/VmF2Bs+9aVpmKYBL9rcbd+NT2pyBMk9s8d4Zu5cDQWcqSgbp1opiZOiHtK
         IuXKbeO0cDm68UiRLry7yFNPLvhEzk1pmYsw1p2FKQ/Qd0/iYYNubefiOCv+0nowpkRJ
         vkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atIvdbbgNJhEtgYsiRDaIlp5c71qNxWW6NldhDMZOaE=;
        b=QCT7jdEPR30cf1yRid+5fE7pjt6DRIp2znO0J0a27jSd2ffngxBnC+jYDOszMxt51T
         IrO1ILrrzk/VV1fOnIAzf8SwdN8Ny1Rd676xryne7qZ78+CppEQuTrELch2QwwtZifXD
         MjcwjkwEdh3DNtZw9LZbspoXTQHFc0DpbRrdNnorG4lOfyY43R1wNaAPPe+dMH32qE6S
         1jsvZ7M9MwVuIsYl4d3W4ByPt2wHFJ8VVv8PvVXcUzWnnMhX/kNi8lrxQc2XZOct3ZIY
         nStNpRhf2Z92GPQRepHj247ewEMNi2m1fbifHCQYPj0EPdGy6q5fGKJVDR43UWQSZAw/
         9z0Q==
X-Gm-Message-State: AOAM532kfFevCPiMxZP4eTU4gGPT7DZF4MLm3+B3K7jtEWNic2S5cYV9
        RxeeYk0j9xjBSh1Sy23Habeow9b4mnzTPDcVNf8DPw==
X-Google-Smtp-Source: ABdhPJwMfI+Qw6bAEnBLEJINdajlVEEoCTLVMXg/kJFZMr8rNqAH47DsBB3k4BgJ/O2H1TTGAYH44z8Hs2klQFFaqVY=
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr1274458pjb.179.1644014166999;
 Fri, 04 Feb 2022 14:36:06 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de> <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch> <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch> <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
 <YfxtglvVDx2JJM9w@lunn.ch>
In-Reply-To: <YfxtglvVDx2JJM9w@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 4 Feb 2022 14:35:55 -0800
Message-ID: <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 4:04 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Andrew,
> >
> > The issue is that in an ideal world where all parts adhere to the
> > JEDEC standards 2ns would be correct but that is not reality. In my
> > experience with the small embedded boards I help design and support
> > not about trace lengths as it would take inches to skew 0.5ns but
> > instead differences in setup/hold values for various MAC/PHY parts
> > that are likely not adhering the standards.
> >
> > Some examples from current boards I support:
> > - CN8030 MAC rgmii-rxid with intel-xway GPY111 PHY: we need to
> > configure this for rx_delay=1.5ns and tx_delay=0.5ns
>
> So i assume this is what broke for you. Your bootloader sets these
> delays, phy-type is rgmii-id, and since you don't have the properties
> for what exact delays you want it default to what 802.3 specifies,
> 2ns.
>
> I actually think the current behaviour of the driver is correct.  By
> saying phy-type = rgmii-id you are telling the PHY driver to insert
> the delays and that is what it is doing.
>
> In retrospect, i would say you had two choices to cleanly solve this.
>
> 1) Do exactly what the patch does, add properties to define what
> actual delay you want, when you don't want 2ns.
>
> 2) Have the bootloader set the delay, but also tell Linux you have set
> the phy mode including the delays, and it should not touch them. There
> is a well defined way to do this:
>
> PHY_INTERFACE_MODE_NA
>
> It has two main use cases. The first is that the MAC and PHY are
> integrated, there is no MII between them, phy-mode is completely
> unnecessary. This is the primary meaning.
>
> The second meaning is, something else has setup the phy mode, e.g. the
> bootloader. Don't touch it.
>
> This second meaning does not always work, since the driver might reset
> the PHY, and depending on the PHY, that might clear whatever the
> bootloader set. So it is not reliable.

Andrew,

I appreciate your suggestions.

The PHY_INTERRFACE_MODE_NA is a neat trick that I will remember but it
would only help with the rgmii delay issue and not the LED issue (this
patch). The GPY111 has some really nasty errata that is going to cause
me to have a very hackish work-around anyway and I will be disabling
the PHY driver to stay out of the way of that workaround so in this
case here I'm not looking for a solution.

>
> > - CN8030 MAC rgmii-rxid with dp83867 GPY111 PHY: we need to configure
> > this for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)
> > - IMX8MM FEC MAC rgmii-id with intel-xway PHY: we need to configure
> > this for rx_delay=2ns and tx_delay=2.5ns
> > - IMX8MM FEC MAC rgmii-id with dp83867 PHY: we need to configure this
> > for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)
> >
> > The two boards above have identical well matched trace-lengths between
> > the two PHY variant designs so you can see here that the intel-xway
> > GPY111 PHY needs an extra 0.5ps delay to avoid RX errors on the
> > far-off board.
>
> So a couple of ideas.
>
> Since GPY111 and dp83867 use different properties for the delays, just
> put both in DT. The PHY driver will look for the property it
> understands and ignore the other. So you can have different delays for
> different PHYs.

Yes, this is what I am currently doing but I'm not sure that would
ever be accepted as a dt change upstream and at some point when the
common property for the delays is supported in both PHY drivers that
will not work (as you point out below). I do a lot of dt fixups in
boot firmware already to deal with board revision's so I'll probably
deal with it that way at some point.

I believe I have made a good case why defaulting to 2ns delays does
not work for all RGMII MAC/PHY scenarios. If 2ns was all you needed
then all these PHY's would not have adjustable delays (its not just
about trace-lengths as they have to be off more than an insh for 0.5ps
and there are a ton of tiny embedded boards out there with delays
between 0.5 and 2.5ns).

As far as changing a driver to force a LED configuration with no dt
binding input (like this patch does) it feels wrong for exactly the
same reason - LED configuration for this PHY can be done via
pin-strapping and this driver now undoes that with this patch. I still
feel very strongly that a PHY driver should not change configuration
which may be based on pin-strapping or boot firmware changes when no
dt properties exist telling it to make that specific change. However
if my opinion is not the popular one I will stop bringing it up.

Best regards,

Tim


>
> We have started to standardize on the delay property. And new driver
> should be using rx-internal-delay-ps and tx-internal-delay-ps. If you
> have two drivers using the same property name, what i just suggested
> will not work. Can you control the address the PHY uses? Put the
> GPY111 on a different address to the dp83867. List them both in DT. If
> you don't have a phy-handle in DT, the FEC will go hunting on its MDIO
> bus and use the first PHY it finds. You can put the needed delay
> properties in DT for the specific PHY.
>
>         Andrew
>
