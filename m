Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3611A8EC76
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbfHONLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:11:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37150 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731282AbfHONLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:11:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id y26so2251139qto.4;
        Thu, 15 Aug 2019 06:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oj5UE2LGVcMS9SysCoBFopHSBvRpgrX1g7nT1W4Cv9s=;
        b=HmHrpfoylIv+xenX+ud7+vckyYDAz7lESPt20PyQy2YEInPQleZa1NVmH0x4CfYiBJ
         JXW7Hl0Ra0lW+jouPOonVpIg8RvjwGgENSVMn351rtO0nD5SsJqrsAcNSeWu/VqzrnXX
         ElBk6PwCa12NBNyZiaKQECiegQ1dDbulhdA4XZJd5ElX8WlaW43i0ZjbuGEgorzggdZx
         HVgsGhDqkmwVpcvSSntpkMagxMhhIhJoaq6e81Vz+jeRtwMYoJ4Fn2FVvVcNIZ03ySAT
         fwdWqTd3IjVxa/LeZgJVcrxfao45oXHsYq3Tv5zKnSQWED52q9jBCcbzyManuc5vU6tk
         2s/Q==
X-Gm-Message-State: APjAAAWHpTUJLk1TW3XlkPOlsBoewZwdFvYWLwRVRkD4eOrfOI8oLzgj
        vn+GtPPpgIXLfr246yq4GX/Sw/QE7ADJfz7Te4k=
X-Google-Smtp-Source: APXvYqxABsAyr+BlU4FYBzPP5E1lu5hNr5RQd0ASTCcdU5s/TSRX7ngTvmZ5zwiRax3ZP5e4wh7pQOi1eFXPhhKeyw0=
X-Received: by 2002:ad4:53cb:: with SMTP id k11mr3085440qvv.93.1565874701634;
 Thu, 15 Aug 2019 06:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731225303.GC1330@shell.armlinux.org.uk>
 <CAK8P3a1Lgbz9RwVaOgNq=--gwvEG70tUi67XwsswjgnXAX6EhA@mail.gmail.com>
In-Reply-To: <CAK8P3a1Lgbz9RwVaOgNq=--gwvEG70tUi67XwsswjgnXAX6EhA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 15 Aug 2019 15:11:25 +0200
Message-ID: <CAK8P3a0=GrjM_HOBgqy5V3pOsA6w1EDOtEQO9dZG2Cw+-2niaw@mail.gmail.com>
Subject: Re: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     SoC Team <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 9:33 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Aug 1, 2019 at 12:53 AM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Jul 31, 2019 at 09:56:42PM +0200, Arnd Bergmann wrote:
> > > For dove, the patches are basically what I had proposed back in
> > > 2015 when all other ARMv6/ARMv7 machines became part of a single
> > > kernel build. I don't know what the state is mach-dove support is,
> > > compared to the DT based support in mach-mvebu for the same
> > > hardware. If they are functionally the same, we could also just
> > > remove mach-dove rather than applying my patches.
> >
> > Well, the good news is that I'm down to a small board support file
> > for the Dove Cubox now - but the bad news is, that there's still a
> > board support file necessary to support everything the Dove SoC has
> > to offer.
> >
> > Even for a DT based Dove Cubox, I'm still using mach-dove, but it
> > may be possible to drop most of mach-dove now.  Without spending a
> > lot of time digging through it, it's impossible to really know.
>
> Ok, so we won't remove it then, but I'd like to merge my patches to
> at least get away from the special case of requiring a separate kernel
> image for it.
>
> Can you try if applying patches 12 and 14 from my series causes
> problems for you? (it may be easier to apply the entire set
> or pull from [1] to avoid rebase conflicts).

I applied patches 12 and 13 into the soc tree now. There are some
other pending multiplatform conversions (iop32x, ep93xx, lpc32xx,
omap1), but it looks like none of those will be complete for 5.4.

I now expect that we can get most of the preparation into 5.4,
and maybe move them all over together in 5.5 after some more
testing. If someone finds a problem with the one of the
preparation steps, that we can revert the individual patches
more easily.

      Arnd
