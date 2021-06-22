Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3903AFD11
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFVGcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVGcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:32:03 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76277C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 23:29:48 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id q10so22618280oij.5
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 23:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DdJQdJIkwKIMOS7tXTygX0MjjffX2z749Iv2g2FNLaM=;
        b=UrVEk0jf/IzOFwQMXPDO127VY5YwqNQ4swugWt7AJ+KpEOfNz4B6QPPfkcjSoNVeDE
         zCGMwhZyrXPkG/9WobFGEdxOr8Nwm2NfNU4eKFjr1NhPQf3FvJJMzjqP2h6DLot4Jcgt
         QO6lvFzJQd/l0gx1RDBP3wHVlwcyEyykgc1N5lb4FgbfZKYcJexX+4iekbJYnfijwXjG
         h0sIUlQAzlq0L+r2D7c48wlQiZcawlI+AZGY26ZAlQ9TtFD8MQED04LKA6esv1kJ5Cq0
         tOif9qkjCNgu/Di3aIg9uukSqFdbZ85eJ41N7PuFGCDxb8yioHqE65kgTsILJcXCP1Zq
         gG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DdJQdJIkwKIMOS7tXTygX0MjjffX2z749Iv2g2FNLaM=;
        b=LKVOtcHN4GpzcZQdotEcDRdD6amiHTQir17JZH+2xGttek0fZVCl+BFb4RVBTL8wXt
         x348ulBMtRl4+00LkOef1IrssRyhlGRESO7wQ461DOH1ZmdD5Z7o4GVs6B36Ot+QaXi1
         0wPXKUotcFm2LRIAC8+abAUAh2zVmk403g1ozLsNZ5ye+Dn3GbmBya+G4wwbuAG0tCe4
         xL3p7+C5SKfK+hodpf4Gt+hsI+WIF4toZ0gz8QadtRtgbwzprfgic/z0N+NlkeYL/xeI
         25EGofZbNUlBeCDSagVX1yRvGUC6d9IwxKJXrRUzwJ1AH67gXAyhumbu+8Ryl7xKbWvW
         oo8g==
X-Gm-Message-State: AOAM532xXV0v1pzc3XzNrfbke+af1Qi01H4pmwNKOnwr4prHjJ+IWYlG
        2XuExJ6XeOJwpnAnxKft50OfrOKmSf0kTOIl82Fo8Q==
X-Google-Smtp-Source: ABdhPJwvZRvadrsFUY7LeFwYdZ4g/xPYH8e9+Y+K5nCU3Vxl1hLCW2UyZ2WXNbrpkPpqZ7rPkFVy16Ii+hWRGhDX7QI=
X-Received: by 2002:a05:6808:251:: with SMTP id m17mr1218383oie.77.1624343387678;
 Mon, 21 Jun 2021 23:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210621103310.186334-1-jhp@endlessos.org> <YNCPcmEPuwdwoLto@lunn.ch>
 <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com> <CALeDE9MjRLjTQ1R2nw_rnXsCXKHLMx8XqvG881xgqKz2aJRGfA@mail.gmail.com>
 <9c0ae9ad-0162-42d9-c4f8-f98f6333b45a@i2se.com> <745e7a21-d189-39d7-504a-bdae58cfb8ad@gmail.com>
In-Reply-To: <745e7a21-d189-39d7-504a-bdae58cfb8ad@gmail.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Tue, 22 Jun 2021 14:29:04 +0800
Message-ID: <CAPpJ_ed+8fP8y_t983pb0LMHK9pfVtGdh7fQopedqGZJCrRxvQ@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
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

Florian Fainelli <f.fainelli@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=8822=
=E6=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8A=E5=8D=885:47=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 6/21/21 1:15 PM, Stefan Wahren wrote:
> > Am 21.06.21 um 18:56 schrieb Peter Robinson:
> >> On Mon, Jun 21, 2021 at 5:39 PM Florian Fainelli <f.fainelli@gmail.com=
> wrote:
> >>> On 6/21/21 6:09 AM, Andrew Lunn wrote:
> >>>> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
> >>>>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find =
the
> >>>>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach th=
e
> >>>>> PHY.
> >>>>>
> >>>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> >>>>> ...
> >>>>> could not attach to PHY
> >>>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >>>>> uart-pl011 fe201000.serial: no DMA platform data
> >>>>> libphy: bcmgenet MII bus: probed
> >>>>> ...
> >>>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >>>>>
> >>>>> This patch makes GENET try to connect the PHY up to 3 times. Also, =
waits
> >>>>> a while between each time for mdio-bcm-unimac module's loading and
> >>>>> probing.
> >>>> Don't loop. Return -EPROBE_DEFER. The driver core will then probed t=
he
> >>>> driver again later, by which time, the MDIO bus driver should of
> >>>> probed.
> >>> This is unlikely to work because GENET register the mdio-bcm-unimac
> >>> platform device so we will likely run into a chicken and egg problem,
> >>> though surprisingly I have not seen this on STB platforms where GENET=
 is
> >>> used, I will try building everything as a module like you do. Can you
> >>> see if the following helps:
> >> For reference we have mdio_bcm_unimac/genet both built as modules in
> >> Fedora and I've not seen this issue reported using vanilla upstream
> >> kernels if that's a useful reference point.
> >
> > I was also unable to reproduce this issue, but it seems to be a known
> > issue [1], [2].
> >
> > Jian-Hong opened an issue in my Github repo [3], but before the issue
> > was narrowed down, he decided to send this workaround.
>
> The comment about changing the phy-mode property is not quite making
> sense to me, except if that means that in one case the Broadcom PHY
> driver is used and in the other case the Generic PHY driver is used.
>
> What is not clear to me from the debugging that has been done so far is
> whether the mdio-bcm-unimac MDIO controller was not loaded at the time
> of_phy_connect() was trying to identify the PHY device.

MODULE_SOFTDEP("pre: mdio-bcm-unimac")  mentioned in the comment [1]
solves this issue.

Tracing the code by following the debug message in comment #2 [2], I
learned the path bcmgenet_mii_probe()'s of_phy_connect() ->
of_phy_find_device() -> of_mdio_find_device() ->
bus_find_device_by_of_node().  And, bus_find_device_by_of_node()
cannot find the device on the mdio bus.

So, I traced bcm2711-rpi-4-b's device tree to find out which one is
the mdio device and why it has not been prepared ready on the mdio bus
for genet.
Then, I found out it is mdio-bcm-unimac module as mentioned in comment
#4 [3].  Also, noticed "unimac-mdio unimac-mdio.-19: Broadcom UniMAC
MDIO bus" comes after "bcmgenet fd580000.ethernet eth0: failed to
connect to PHY" in the log.

With these findings, I try to re-modprobe genet module again.  The
ethernet on RPi 4B works correctly!  Also, noticed mdio-bcm-unimac
module is loaded before I re-modprobe genet module.
Therefore, I try to make mdio-bcm-unimac built in kernel image,
instead of a module.  Then, genet always can find the mdio device on
the bus and the ethernet works as well.

Consequently, the idea, loading mdio-bcm-unimac module earlier than
genet module comes in my head!  However, I don't know the key word
"MODULE_SOFTDEP" until Florian's guide.  That is why I have a loop to
connect the PHY in the original patch.  But, I understand
MODULE_SOFTDEP is a better solution now!

I think this is like the module loading order situation mentioned in
commit 11287b693d03 ("r8169: load Realtek PHY driver module before
r8169") [4].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c6
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c2
[3] https://bugzilla.kernel.org/show_bug.cgi?id=3D213485#c4
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D11287b693d03830010356339e4ceddf47dee34fa

Jian-Hong Pan
