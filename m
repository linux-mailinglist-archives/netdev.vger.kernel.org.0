Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD594CA0E9
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiCBJfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiCBJfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:35:16 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE33B54E6
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:34:33 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id b64so555820vkf.7
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y5dvzKBcTK1wVXbtOVwjDKhdZhZeWw3dMTvyt0eh9R8=;
        b=IzloBRy9JrGzQcAa0tHrHDnGvAazFMm/e03qT/UDg7Lzru9ozBnKKUxy0uNIQxhBlK
         DIFHsRc8D2rU5B43BWG9Rhvo3r6nJEiQmcNqmZGwkmsPpwmNIPiU2PY6fqWMesm3CzBJ
         dP4Yh3ot8LwHtUA7LaOw2eoPV8SF79hbY5lMK25kPlyZp8fNVd1QkotFyS0uXKYxC8z7
         pwaO89vCs09HrqXvmS2JeVb1yfleN1m2tqFW6Eg4C5tdOYS0vLYDjVAAp3vQbrw+2EQT
         rmlo/N0BUCrlV33+Ym8d+WmXPXzOPt1m+xjqA0ihewBloCXP+bKh4k1j80pmGbT9bt+v
         uteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y5dvzKBcTK1wVXbtOVwjDKhdZhZeWw3dMTvyt0eh9R8=;
        b=67WBu4RFMrHnQgULX18lt1XCD3TVpDfWtVli9eeYOXVqY/0azYaeSqULOD9WHo4qzO
         bYLJaoDqWvob+u2ZrBFDKZoL2CFfX20PepS0HXGWk2hfT9X2VuNWKiZ0+Fp+2hokG+gV
         7/Z/w1qHjnkf0mK9SklfpAKdgu91Q68IdKUxqicUlB41Vq33E54Ctu8UiJYKpzAYHZO2
         zMWBay6rOpp9UatnAz5hfLQAasg4h2TiI3hjH7p0lPOKKZm6erGdhqIkj2pSRe9DC1G1
         BVPhC6q752SkQfijD/QNCGT7xE65jQcaN6hbCpMaQb3QeMPU5vUNKBa4IfU6hnKn9bxh
         ri+A==
X-Gm-Message-State: AOAM533LB2KlegpBc4WR4KGPB/7Tuf/3MtXzVgvmfpujnLSLmHkgBtUF
        3d7K0PNum8QIpPKQpsvtX3JtroUVIzfeOfEFgFA=
X-Google-Smtp-Source: ABdhPJwAlHc/W0BQlaeOYRAiiSx98BJlc6j+En/NH9Kr/TBXGr48NTR9j869R7oYhP6GHfqvlpl7ImVXpvAB+ZoenGI=
X-Received: by 2002:a05:6122:a1f:b0:32d:a4a4:6c27 with SMTP id
 31-20020a0561220a1f00b0032da4a46c27mr11255555vkn.14.1646213672375; Wed, 02
 Mar 2022 01:34:32 -0800 (PST)
MIME-Version: 1.0
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com> <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com> <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com> <aab96097-e461-7f8b-dbde-10819d711c25@arm.com>
In-Reply-To: <aab96097-e461-7f8b-dbde-10819d711c25@arm.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Wed, 2 Mar 2022 09:34:21 +0000
Message-ID: <CALeDE9PT+B3chOPzwABaDsriFToYvCTrHMngLSX0ioeLe4nd-w@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
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

> >>>>> On 2/22/2022 1:53 AM, Peter Robinson wrote:
> >>>>>> The ethtool WoL enable function wasn't checking if the device
> >>>>>> has the optional WoL IRQ and hence on platforms such as the
> >>>>>> Raspberry Pi 4 which had working ethernet prior to the last
> >>>>>> fix regressed with the last fix, so also check if we have a
> >>>>>> WoL IRQ there and return ENOTSUPP if not.
> >>>>>>
> >>>>>> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> >>>>>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> >>>>>> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> >>>>>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
> >>>>>> ---
> >>>>>>     drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
> >>>>>>     1 file changed, 4 insertions(+)
> >>>>>>
> >>>>>> We're seeing this crash on the Raspberry Pi 4 series of devices on
> >>>>>> Fedora on 5.17-rc with the top Fixes patch and wired ethernet
> >>>>>> doesn't work.
> >>>>>
> >>>>> Are you positive these two things are related to one another? The
> >>>>> transmit queue timeout means that the TX DMA interrupt is not
> >>>>> firing up
> >>>>> what is the relationship with the absence/presence of the Wake-on-LAN
> >>>>> interrupt line?
> >>>>
> >>>> The first test I did was revert 9deb48b53e7f and the problem went
> >>>> away, then poked at a few bits and the patch also fixes it without
> >>>> having to revert the other fix. I don't know the HW well enough to
> >>>> know more.
> >>>>
> >>>> It seems there's other fixes/improvements that could be done around
> >>>> WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
> >>>> support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.
> >>>
> >>> There is no question we can report information more accurately and your
> >>> patch fixes that.
> >>>
> >>>>
> >>>> This fix at least makes it work again in 5.17, I think improvements
> >>>> can be looked at later by something that actually knows their way
> >>>> around the driver and IP.
> >>>
> >>> I happen to be that something, or rather consider myself a someone. But
> >>> the DTS is perfectly well written and the Wake-on-LAN interrupt is
> >>> optional, the driver assumes as per the binding documents that the
> >>> Wake-on-LAN is the 3rd interrupt, when available.
> >>>
> >>> What I was hoping to get at is the output of /proc/interrupts for the
> >>> good and the bad case so we can find out if by accident we end-up not
> >>> using the appropriate interrupt number for the TX path. Not that I can
> >>> see how that would happen, but since we have had some interesting issues
> >>> being reported before when mixing upstream and downstream DTBs, I just
> >>> don't fancy debugging that again:
> >>
> >> The top two are pre/post plugging an ethernet cable with the patched
> >> kernel, the last two are the broken kernel. There doesn't seem to be a
> >> massive difference in interrupts but you likely know more of what
> >> you're looking for.
> >
> > There is not a difference in the hardware interrupt numbers being
> > claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and
> > 158 + 32). In the broken case we can see that the second interrupt line
> > (interrupt 190), which is the one that services the non-default TX
> > queues does not fire up at all whereas it does in the patched case.
> >
> > The transmit queue timeout makes sense given that transmit queue 2
> > (which is not the default one, default is 0) has its interrupt serviced
> > by the second interrupt line (190). We can see it not firing up, hence
> > the timeout.
> >
> > What I *think* might be happening here is the following:
> >
> > - priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative
> > error code we do not install the interrupt handler for the WoL interrupt
> > since it is not valid
> >
> > - bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we
> > call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is
> > able to resolve that irq number to a valid interrupt descriptor
>
> That should not be possible, see below.
>
> >
> > - eventually we just mess up the interrupt descriptor for interrupt 49
> > and it stops working
> >
> > Now since this appears to be an ACPI-enabled system, we may be hitting
> > this part of the code in platform_get_irq_optional():
> >
> >            r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> >            if (has_acpi_companion(&dev->dev)) {
> >                    if (r && r->flags & IORESOURCE_DISABLED) {
> >                            ret = acpi_irq_get(ACPI_HANDLE(&dev->dev),
> > num, r);
> >                            if (ret)
> >                                    goto out;
> >                    }
> >            }
>
> As Peter points out, he is using uboot/DT. I on the other hand am not
> having any issues with fedora on the edk2/ACPI rpi4 with 5.17rc's.
>
> Although, I found this series interesting because I didn't (still don't,
> although I have a couple theories) see why the same bug shouldn't be
> affecting ACPI.
>
> Also, I don't actually understand how Peter's patch fixes the problem.
> That is because, device_set_wakeup_capable() isn't setting can_wakeup,
> thus the machine should immediately be returning from
> bcmgetnet_set_wol() when it checks device_can_wakeup(). Meaning it
> shouldn't ever execute the wol_irq <= 0 check being added by this patch.
>
> On the working/ACPI machine that is true, and it actually results in an
> unusual ethtool error. So, understanding how that gets set (and maybe
> adding an wakeup_capable(,false), like a couple other drivers) is the
> right path here? It should be 0, but I can't prove that to myself right now.
>
> Which brings me to my second point about ethtool. The return from
> bcmgenet_get_wol() is incorrect on these platforms, and that is why
> bcmgetnet_set_wol() is even being called. I have a patch I will post, to
> fix it, but its basically adding a device_can_wakeup() check to
> _get_wol() and returning wol->supported = 0; wol->wolopts=0;
>
> Finally, more on the thinking out loud theory, it came to my attention
> that some of the fedora kernels were being built with gcc11 (my rpi test
> kernels for sure) and some with gcc12? Is the failing kernel built with
> gcc12?

Yes, all the 5.17-rcX kernels in Fedora are currently built with gcc12.
