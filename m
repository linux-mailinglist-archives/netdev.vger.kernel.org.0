Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA6C3AFE4A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFVHts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhFVHtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:49:47 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6354C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:47:30 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 14so188407oir.11
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VaQ20TFZH3Wpx05mjimGofvLlawbzFxo/HI3pT0DBSM=;
        b=stOnU5ESo8AfKF5TGdPoo5mQpU/OEUtHZJi+cgfw3SkWbZTjkKB4n8VIQ3wjsgSfG4
         wq2f7J1sFtZyKpe0V6UPNzTamFzPmAbQp2re6TJmMrBeQBee5tpoCMzUMxAK2oen9o8d
         okJ7Zvysg+EVj1bU/a1udfv3pyvJirA3aM37Sbf1CMezYjTw4no00K/Qqcd/Xy/A7BMX
         4OeJpQIYvmakXZ3btaEXytqOvGwkXWTmlVJKSFFsGPFNuGCdK+MQKbiGVLlHzh17yzIX
         oOp21HgaI7zk8nPWIgvUAbbcNMRFJkYuHcw3F1aYMHIlct7urxJxZse63Jh2ROC/vApg
         lqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VaQ20TFZH3Wpx05mjimGofvLlawbzFxo/HI3pT0DBSM=;
        b=q1edWzL6PIhaA+O7h+JpHMD0uciQHtflqBy7yhsXDxd8+yrksx69ZTGFaH2WxhJnfP
         X6Iq+qTBdBhpZGwHRoZKB9vtCPt+LsznzNw2iTCUUQAJJ8MYzkTaDqySI0bfZZmB8bUz
         52hmHBFphU4sQz4tM6OXKj7ar4QzUBA8nIFWC8XgAEmV4UGUMbE6ZbooQJuk022QAX3E
         oVGJx9efCAp2JoQhMS+fJRwJ9QGcP7vNia2vjwUG0PFCAJFpajpVchVjOb+LvZB/xVxY
         P8g1kU6pc3cHKVA0XsvQ6KiHtlluXcJOIrMU+IQcNDjgTTZFmaTGd1sjD4ttSBEvdnSO
         gxNA==
X-Gm-Message-State: AOAM531gZEMVpxhYW8UE9rR0Ohnt9IQ5lZ4Qa3vabhu4OTk8F/YjdFby
        kZQlBbhLLY2szjwDxuHc32aMfQ/6KeiKjg/pUY2+oQ==
X-Google-Smtp-Source: ABdhPJy3wfN6gAjCeKm+EXQCm6TtUA82qTAhSnd3L3mQF/l4VzU0juu1Fb09QgF2leFBZra3rzpq7SZg/3FDYDj2zmw=
X-Received: by 2002:aca:3d03:: with SMTP id k3mr2173169oia.161.1624348050277;
 Tue, 22 Jun 2021 00:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210621103310.186334-1-jhp@endlessos.org> <YNCPcmEPuwdwoLto@lunn.ch>
 <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com> <CALeDE9MjRLjTQ1R2nw_rnXsCXKHLMx8XqvG881xgqKz2aJRGfA@mail.gmail.com>
 <9c0ae9ad-0162-42d9-c4f8-f98f6333b45a@i2se.com> <745e7a21-d189-39d7-504a-bdae58cfb8ad@gmail.com>
 <CAPpJ_ed+8fP8y_t983pb0LMHK9pfVtGdh7fQopedqGZJCrRxvQ@mail.gmail.com> <9a1e425b-af8c-9385-a226-35f2092554ae@gmail.com>
In-Reply-To: <9a1e425b-af8c-9385-a226-35f2092554ae@gmail.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Tue, 22 Jun 2021 15:46:46 +0800
Message-ID: <CAPpJ_ecJxUjvxEb+3GLmtQyxhAZ3Tqk+hoUbSowG1bi+739u-g@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Doug Berger <opendmb@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessos.org, bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=8822=
=E6=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=882:50=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 22.06.2021 08:29, Jian-Hong Pan wrote:
> > Florian Fainelli <f.fainelli@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=
=8822=E6=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8A=E5=8D=885:47=E5=AF=AB=E9=81=93=
=EF=BC=9A
> >>
> >> On 6/21/21 1:15 PM, Stefan Wahren wrote:
> >>> Am 21.06.21 um 18:56 schrieb Peter Robinson:
> >>>> On Mon, Jun 21, 2021 at 5:39 PM Florian Fainelli <f.fainelli@gmail.c=
om> wrote:
> >>>>> On 6/21/21 6:09 AM, Andrew Lunn wrote:
> >>>>>> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
> >>>>>>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot fin=
d the
> >>>>>>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach =
the
> >>>>>>> PHY.
> >>>>>>>
> >>>>>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> >>>>>>> ...
> >>>>>>> could not attach to PHY
> >>>>>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >>>>>>> uart-pl011 fe201000.serial: no DMA platform data
> >>>>>>> libphy: bcmgenet MII bus: probed
> >>>>>>> ...
> >>>>>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >>>>>>>
> >>>>>>> This patch makes GENET try to connect the PHY up to 3 times. Also=
, waits
> >>>>>>> a while between each time for mdio-bcm-unimac module's loading an=
d
> >>>>>>> probing.
> >>>>>> Don't loop. Return -EPROBE_DEFER. The driver core will then probed=
 the
> >>>>>> driver again later, by which time, the MDIO bus driver should of
> >>>>>> probed.
> >>>>> This is unlikely to work because GENET register the mdio-bcm-unimac
> >>>>> platform device so we will likely run into a chicken and egg proble=
m,
> >>>>> though surprisingly I have not seen this on STB platforms where GEN=
ET is
> >>>>> used, I will try building everything as a module like you do. Can y=
ou
> >>>>> see if the following helps:
> >>>> For reference we have mdio_bcm_unimac/genet both built as modules in
> >>>> Fedora and I've not seen this issue reported using vanilla upstream
> >>>> kernels if that's a useful reference point.
> >>>
> >>> I was also unable to reproduce this issue, but it seems to be a known
> >>> issue [1], [2].
> >>>
> >>> Jian-Hong opened an issue in my Github repo [3], but before the issue
> >>> was narrowed down, he decided to send this workaround.
> >>
> >> The comment about changing the phy-mode property is not quite making
> >> sense to me, except if that means that in one case the Broadcom PHY
> >> driver is used and in the other case the Generic PHY driver is used.
> >>
> >> What is not clear to me from the debugging that has been done so far i=
s
> >> whether the mdio-bcm-unimac MDIO controller was not loaded at the time
> >> of_phy_connect() was trying to identify the PHY device.
> >
> > MODULE_SOFTDEP("pre: mdio-bcm-unimac")  mentioned in the comment [1]
> > solves this issue.
> >
> > Tracing the code by following the debug message in comment #2 [2], I
> > learned the path bcmgenet_mii_probe()'s of_phy_connect() ->
> > of_phy_find_device() -> of_mdio_find_device() ->
> > bus_find_device_by_of_node().  And, bus_find_device_by_of_node()
> > cannot find the device on the mdio bus.
> >
> > So, I traced bcm2711-rpi-4-b's device tree to find out which one is
> > the mdio device and why it has not been prepared ready on the mdio bus
> > for genet.
> > Then, I found out it is mdio-bcm-unimac module as mentioned in comment
> > #4 [3].  Also, noticed "unimac-mdio unimac-mdio.-19: Broadcom UniMAC
> > MDIO bus" comes after "bcmgenet fd580000.ethernet eth0: failed to
> > connect to PHY" in the log.
> >
> > With these findings, I try to re-modprobe genet module again.  The
> > ethernet on RPi 4B works correctly!  Also, noticed mdio-bcm-unimac
> > module is loaded before I re-modprobe genet module.
> > Therefore, I try to make mdio-bcm-unimac built in kernel image,
> > instead of a module.  Then, genet always can find the mdio device on
> > the bus and the ethernet works as well.
> >
> > Consequently, the idea, loading mdio-bcm-unimac module earlier than
> > genet module comes in my head!  However, I don't know the key word
> > "MODULE_SOFTDEP" until Florian's guide.  That is why I have a loop to
> > connect the PHY in the original patch.  But, I understand
> > MODULE_SOFTDEP is a better solution now!

Forgot to place some reference as note:

* MODULE_SOFTDEP is defined in include/linux/module.h [1]

* modprobe.d has an example: [2]
  Assume "softdep c pre: a b post: d e" is provided in
  the configuration. Running "modprobe c" is now equivalent to
  "modprobe a b c d e" without the softdep.

[1] https://elixir.bootlin.com/linux/v5.13-rc7/source/include/linux/module.=
h#L170
[2] https://man7.org/linux/man-pages/man5/modprobe.d.5.html

> > I think this is like the module loading order situation mentioned in
> > commit 11287b693d03 ("r8169: load Realtek PHY driver module before
> > r8169") [4].
> >
> The reason in r8169 is different. When people add r8169 module to
> initramfs but not the Realtek PHY driver module then loading
> r8169 will fail. The MODULE_SOFTDEP is a hint to tools building
> initramfs.

Thanks for Heiner's quick clarification.
Maybe I missed some background of the commit ("r8169: load Realtek PHY
driver module before r8169").

Jian-Hong Pan

> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c6
> > [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c2
> > [3] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c4
> > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D11287b693d03830010356339e4ceddf47dee34fa
> >
> > Jian-Hong Pan
> >
>
