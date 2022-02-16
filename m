Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB5D4B8A26
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiBPNdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:33:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiBPNdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:33:10 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A817F139
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:32:57 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id n24so3306349ljj.10
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HJNUJzZ2w9KfbDjNaVqLNvvR+3gcB5EqVbNjWDB34dM=;
        b=k5qtB80PfvkpTvOjjPlDYkbks7d3GraoGroAvNeTe2wCI/h1xR9X/PM8do+SuHmsrV
         Ks5AvtjFoaCXBbvMIiV/j6zb0IJKGWgwVAJ3Ttziu7hyFN43/txrW3+0KSqulB2PsMK0
         tYkl8gMrArec04pOak6emYrh+vQdxQVCboEPU2gFFctz4DPcp4+OZuu2zwvBH+xFlQp9
         ZTLlS0da9Wsm92DINB14pXfZt65ufAWKyqIJHOYBx4OBOoEgTlqz5Bd1dfvxESaOLtr9
         Jrl6uM/fdxycegSKg81xYRMFkEBVNxil/tf2IBts69ojFq3vjAEWhtfdz3HfFgDsGxEs
         BsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HJNUJzZ2w9KfbDjNaVqLNvvR+3gcB5EqVbNjWDB34dM=;
        b=dLySUpG2EFNHOkVR3Y9U0Av34gllVgMdi1HC6/VxjueXgb2kHkeAGzRkzB2K/A4ELI
         tfYt7/lm4L3nQPke8YCVjGnjrRsvC0aMXrwOuP801BeTrnSXBDYeBD2bspBHxNbLAptK
         Na2aeT+i3Vb84Ee/OFf6tM6WhSAfGELeJFgRiHts7OEXddPHH2Edwl1I3N90T8Q8e/0v
         M/qqwz0gmA8VQAqYHzBZ/77fzE9o7iewHvd1ojP6dVXQAFVG9ss29mCXYfIzihmpLpby
         DEUOSiQCQasnOEy1+b6un9D5h0mQdevliCigFWuB+spxxHMJq3Ra8Xl6vB2OGHfRlH/q
         Z2aA==
X-Gm-Message-State: AOAM530Uz1ph7qqNyw/Mg0xWaPNYXjROc4vRqxeTQdvlGchtnletnQFi
        ISa2gk+mqB5yDYfOngpFXYs9mJbibI92j9FV5JqmZw==
X-Google-Smtp-Source: ABdhPJziHXZzuJSN2Tfee/cC90OKw5xKamOwSF8X0Ohd9o5miqpmK9v5f1T42OU0pkaVUG2oYKvcBGP15cm60H+Y/eU=
X-Received: by 2002:a05:651c:178c:b0:245:fd2c:2d2b with SMTP id
 bn12-20020a05651c178c00b00245fd2c2d2bmr2101671ljb.486.1645018375924; Wed, 16
 Feb 2022 05:32:55 -0800 (PST)
MIME-Version: 1.0
References: <20220216090845.1278114-1-maz@kernel.org> <CAPv3WKf4RFeTDCsW+cY-Rp=2rZt1HuZSVQcmcB3oKQKNbvBtDA@mail.gmail.com>
 <877d9v3po0.wl-maz@kernel.org>
In-Reply-To: <877d9v3po0.wl-maz@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 16 Feb 2022 14:32:42 +0100
Message-ID: <CAPv3WKewWHd=23MKar8_-B4YpYQbnX9fqqPH=Ti7aGe2rV6FuQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: mvpp2: Survive CPU hotplug events
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 16 lut 2022 o 14:29 Marc Zyngier <maz@kernel.org> napisa=C5=82(a)=
:
>
> On Wed, 16 Feb 2022 13:19:30 +0000,
> Marcin Wojtas <mw@semihalf.com> wrote:
> >
> > Hi Marc,
> >
> > =C5=9Br., 16 lut 2022 o 10:08 Marc Zyngier <maz@kernel.org> napisa=C5=
=82(a):
> > >
> > > I recently realised that playing with CPU hotplug on a system equiped
> > > with a set of MVPP2 devices (Marvell 8040) was fraught with danger an=
d
> > > would result in a rapid lockup or panic.
> > >
> > > As it turns out, the per-CPU nature of the MVPP2 interrupts are
> > > getting in the way. A good solution for this seems to rely on the
> > > kernel's managed interrupt approach, where the core kernel will not
> > > move interrupts around as the CPUs for down, but will simply disable
> > > the corresponding interrupt.
> > >
> > > Converting the driver to this requires a bit of refactoring in the IR=
Q
> > > subsystem to expose the required primitive, as well as a bit of
> > > surgery in the driver itself.
> > >
> > > Note that although the system now survives such event, the driver
> > > seems to assume that all queues are always active and doesn't inform
> > > the device that a CPU has gone away. Someout who actually understand
> > > this driver should have a look at it.
> > >
> > > Patches on top of 5.17-rc3, lightly tested on a McBin.
> > >
> >
> > Thank you for the patches. Can you, please, share the commands you
> > used? I'd like to test it more.
>
> Offline CPU3:
> # echo 0 > /sys/devices/system/cpu/cpu3/online
>
> Online CPU3:
> # echo 1 > /sys/devices/system/cpu/cpu3/online
>
> Put that in a loop, using different CPUs.
>
> On my HW, turning off CPU0 leads to odd behaviours (I wouldn't be
> surprised if the firmware was broken in that respect, and also the
> fact that the device keeps trying to send stuff to that CPU...).
>

Thanks, I think stressing DUT with traffic during CPU hotplug will be
a good scenario - I'll try that.

Marcin
