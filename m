Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA742B1EDF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgKMPdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgKMPds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 10:33:48 -0500
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762B422284
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605281627;
        bh=jnKiuE0yheBhn9aDbbSQIceQgn/pMLEOy1vwrBJ6M1c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qYEaqcrABf6OAJgpl41fCFz3OV5RgJhdbxANwsBKWheLr0pM1iybBgDlPGI2wh7MX
         doTwzGU3JtWbcDOaMVZQlc+h8ORpRQCja3GlUJdLZUz4kunz/PxSKGQaVuuP289fuK
         DyL/WtUUu6XA6g6OKhUr5WUX/+WhEHXNS0H2196Q=
Received: by mail-oi1-f174.google.com with SMTP id k26so10834022oiw.0
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:33:47 -0800 (PST)
X-Gm-Message-State: AOAM530UA9lSrgvIP/bXE3r3BT+m3+7SDQC31HaBGibzr5UUOsgOG+T1
        tdiA4C94SVe1mOeGGb9yHI+0XH3TYevBpMHt0M4=
X-Google-Smtp-Source: ABdhPJw/u3H0Y3ADB7u18hEOS+JUGsjwWWXciDzCTaUsWw1o7X53Ys+/tzJap7vF2kdHVknWBPhbEOD+W6tnyzqkTDk=
X-Received: by 2002:aca:e0d7:: with SMTP id x206mr1856468oig.67.1605281621864;
 Fri, 13 Nov 2020 07:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20201017230226.GV456889@lunn.ch> <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home> <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com> <20201113144401.GM1456319@lunn.ch>
In-Reply-To: <20201113144401.GM1456319@lunn.ch>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 13 Nov 2020 16:33:25 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
Message-ID: <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 3:45 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Sadly, there is one board - Pine64 Plus - where HW settings are wrong and it
> > > actually needs SW override. Until this Realtek PHY driver fix was merged, it
> > > was unclear what magic value provided by Realtek to board manufacturer does.
> > >
> > > Reference:
> > > https://lore.kernel.org/netdev/20191001082912.12905-3-icenowy@aosc.io/
> >
> > I have merged the fixes from the allwinner tree now, but I still think we
> > need something better than this, as the current state breaks any existing
> > dtb file that has the incorrect values, and this really should not have been
> > considered for backporting to stable kernels.
>
> Hi Arnd
>
> This PHY driver bug hiding DT bug is always hard to handle. We have
> been though it once before with the Atheros PHY. All the buggy DT
> files were fixed in about one cycle.

Do you have a link to the problem for the Atheros PHY?

I'm generally skeptical about the idea of being able to fix all DTBs,
some of the problems with that being:

- There is no way to identify which of of the 2019 dts files in the
  kernel actually have this particular phy, because it does not
  have a device node in the dt. Looking only at files that set
  phy-mode="rgmii" limits it to 235 files, but that is still more than
  anyone can test.

- if there was a way to automate identifying the dts files that
  need to be modified, we should also be able to do it at runtime

- I really want to encourage stable dtb files that users can ship
  with their boards in the same way that we treat firmware
  on PCs and classic Open Firmware machines as stable.
  Updating a kernel should never require updating the firmware
  first.

- The model advocated by EBBR [1] actually requires this in
  order to deal with distros updating kernels. When you use a
  distro with grub (or similar) as the bootloader, you can choose
  between multiple kernels through a boot menu, but a single
  DTB is provided by the firmware to the bootloader.
  There is an ongoing discussion on how to deal with picking
  the right DTB for a kernel being picked by the boot loader, while
  also having the firmware modify an arbitrary set of properties
  (memory size, boot arguments, mac address, random seed,
  ...) in there, but it would be best to just not have to rely on that
  kind of mechanism.

- Not every custom board should need to have its dts file
  in the kernel. I'm less concerned about incorrect properties
  in out-of-tree dts files, but would strongly discourage
  other incompatible binding changes.

> Now that we know there is a board which really does want rgmii when it
> says rgmii, we cannot simply ignore it in the PHY driver.
>
> But the whole story is muddy because of the backport to stable.  It
> might make sense to revert the stable change, and just leave HEAD
> broken. That then gives people more time to fix DT blobs. But we have
> to consider Pine64 Plus, are we happy breaking that for a while, when
> it is actually doing everything correct, and is bug free?

I agree this makes the problem harder, but I have still hope that
we can come up with a code solution that can deal with this
one board that needs to have the correct settings applied as well
as the others on which we have traditionally ignored them.

As I understand it so far, the reason this board needs a different
setting is that the strapping pins are wired incorrectly, while all
other boards set them right and work correctly by default. I would
much prefer a way to identify this behavior in dts and have the phy
driver just warn when it finds a mismatch between the internal
delay setting in DT and the strapping pins but keep using the
setting from the strapping pins when there is a conflict.

There are surely other ways to achieve the same state of having
it all working without requiring the fixed dts.

     Arnd

[1] https://arm-software.github.io/ebbr/
