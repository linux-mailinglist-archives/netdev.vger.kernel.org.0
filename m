Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08F98F4D2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbfHOTjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:39:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44148 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731211AbfHOTjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:39:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so3547879qtg.11;
        Thu, 15 Aug 2019 12:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1uPy8KdAoiEgff6O2fYBXQ3Fn6UlM0L6zfIpxvfPBI=;
        b=WxI5DxIJVTUdx4BwaWNEVdTI3ReLWi0O3QnQ/xWqnWlLB/yW8fPQmxO+IL7K2gqgNU
         UsTKIKzDby0KalTlUJfv60UTvLgScfIYGeroKTEmxNG9dmhuvqmftOMAsUoDhMyu4atk
         g8pS44ImAJNN1WyNJHdq9D2BbSZg0yoNiUD6UWtzHN0+G7G5ML2JJwIs/4Xz7EmfU9ru
         35uprNN/J1Om8fdV+ooe1b4BGyFYAEDyXjfm0hq6zSfTTw4Csl29aGfnJir2Xn+s1CXx
         98aKJ2Dqmi/zYcXE1EcsT9G++Zp+lVrjmIc5UNrglrfkk2qXreQBPZF6jlfXMuVcOnLe
         +VBQ==
X-Gm-Message-State: APjAAAUQY62CuNCwFdZbK8/mQzJxFI8NY2DsjxpgUylCloqHZdU4xsNf
        d0h1L7L57XEphjGsDIMA80mDdRhkgnM527DYA+A=
X-Google-Smtp-Source: APXvYqxqTY8ftYo1EUWFqO+wE8ZQTXXaXX7aeplKk/nDWAyNr8WQSB0twRkA82A5Gyv2tMBQ6tV5GMhK78egWxkdSCU=
X-Received: by 2002:ac8:f99:: with SMTP id b25mr5374344qtk.142.1565897942632;
 Thu, 15 Aug 2019 12:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731225303.GC1330@shell.armlinux.org.uk>
 <CAK8P3a1Lgbz9RwVaOgNq=--gwvEG70tUi67XwsswjgnXAX6EhA@mail.gmail.com>
 <CAK8P3a0=GrjM_HOBgqy5V3pOsA6w1EDOtEQO9dZG2Cw+-2niaw@mail.gmail.com> <b43c3d60-b675-442c-c549-25530cfbffe3@gmail.com>
In-Reply-To: <b43c3d60-b675-442c-c549-25530cfbffe3@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 15 Aug 2019 21:38:46 +0200
Message-ID: <CAK8P3a3ry0S-yhE75hZx1SawYuVzY=NgnNBei101F6+HxBfE3g@mail.gmail.com>
Subject: Re: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
To:     Sylvain Lemieux <slemieux.tyco@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        SoC Team <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
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

On Thu, Aug 15, 2019 at 8:32 PM Sylvain Lemieux <slemieux.tyco@gmail.com> wrote:
> On 8/15/19 9:11 AM, Arnd Bergmann wrote:
> > On Thu, Aug 1, 2019 at 9:33 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > I applied patches 12 and 13 into the soc tree now. There are some
> > other pending multiplatform conversions (iop32x, ep93xx, lpc32xx,
> > omap1), but it looks like none of those will be complete for 5.4.
>
> I think the patchset (v2) for the LPC32xx is ready for 5.4
> ([PATCH v2 00/13] v2: ARM: move lpc32xx to multiplatform)

Good point. I've merged these into the arm/soc branch now.

     Arnd
