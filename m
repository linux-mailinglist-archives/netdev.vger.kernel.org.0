Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97248CAEE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356201AbiALS0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356214AbiALSZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:25:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C476C061751
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:25:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so13855412pja.1
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t7riP9B4hsvG3qfLdbEnZvp9wjNoyW2lbflNMHW39W8=;
        b=LBtirDp/PTk9KEi34QLQbuOhPPu+AMulIJ/xPckEDw1TwMcMQY/5ywr4YRWMpfwodt
         96mes91QC04PFSDdvQIAixfp4kHrYOL9KeZTb5elcOoapSEEVPn2X2lAcPSWKaNdeXIk
         13e0ypnAqoody2uFNiBD0nZcgdOsqjQXGqvHowltFdOoh8qSRYFQ5t30eWuh32YL2YP5
         HK5bqWHxOKRK6pElqxm41spg+55WYbHRd92ySsZhcbuQXQ6XDONC6DRsTX/xknVZz+FN
         0jTleVMUynsW1r5aJBVggbKoaSbbKOWJtIweBxCJ1GuiI89jGdPXhnU3ZEYk3YONh9BB
         2qAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7riP9B4hsvG3qfLdbEnZvp9wjNoyW2lbflNMHW39W8=;
        b=39YAJVhkOxWWDRCy+9QiNVXio7EoNJkOwbjXMIF/COSR+6S+CX/OrLbYtEixVStn6z
         c6o3d1loshfRHLGHNSQYdmG8zq2XXttllWMMlltzoae5MgX6DYOhgeAS2/UJjDWVswlX
         z/1hYG3y60ITrthNNMA4PfilsZ2Msa9BoTmKYoAWEh7pvYagSd6VcPz2TcZRWTM8S1m1
         Gqb5GLPo/SxxUq0TKQLN+AMOMMvA2ItkuP2siAY6tr8bHDwIrkoLyE20WcXf7uXmn4lc
         THHQozNVsOsltPvXz74lbqGbmUniHkp0QZbrQqHop4SwFb8neMRmrnn4Ah0lOIltsDgc
         gq/A==
X-Gm-Message-State: AOAM5334EsxJEpE0GYm0cC2RnZm6zvlM7qlGDLyek9+RNrfQhisanF73
        4C1TYyZOwhu7svbgE13Q6NjTft4Ofrg3U4cI9fxcX6t/38U=
X-Google-Smtp-Source: ABdhPJyjyv7NrFCdZ4Lz45io4ag12WYI5HWn85TJF1pRqOoZZe8eIxQkcTz2QYyELGuhHu4dMOoYI+pjQ95pIIpL+CU=
X-Received: by 2002:a17:90b:e89:: with SMTP id fv9mr876098pjb.155.1642011957942;
 Wed, 12 Jan 2022 10:25:57 -0800 (PST)
MIME-Version: 1.0
References: <20210719082756.15733-1-ms@dev.tdt.de> <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de> <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk>
In-Reply-To: <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 12 Jan 2022 10:25:45 -0800
Message-ID: <CAJ+vNU1R8fGssHjfoz-jN1zjBLPz4Kg8XEUsy4z4bByKS1PqQA@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 5:46 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jan 11, 2022 at 11:12:33AM -0800, Tim Harvey wrote:
> > I added a debug statement in xway_gphy_rgmii_init and here you can see
> > it gets called 'before' the link comes up from the NIC on a board that
> > has a cable plugged in at power-on. I can tell from testing that the
> > rx_delay/tx_delay set in xway_gphy_rgmii_init does not actually take
> > effect unless I then bring the link down and up again manually as you
> > indicate.
> >
> > # dmesg | egrep "xway|nicvf"
> > [    6.855971] xway_gphy_rgmii_init mdio_thunder MDI_MIICTRL:0xb100
> > rx_delay=1500 tx_delay=500
> > [    6.999651] nicvf, ver 1.0
> > [    7.002478] nicvf 0000:05:00.1: Adding to iommu group 7
> > [    7.007785] nicvf 0000:05:00.1: enabling device (0004 -> 0006)
> > [    7.053189] nicvf 0000:05:00.2: Adding to iommu group 8
> > [    7.058511] nicvf 0000:05:00.2: enabling device (0004 -> 0006)
> > [   11.044616] nicvf 0000:05:00.2 eth1: Link is Up 1000 Mbps Full duplex
>
> Does the kernel message about the link coming up reflect what is going
> on physically with the link though?
>
> If a network interface is down, it's entirely possible that the link is
> already established at the hardware level, buit the "Link is Up" message
> gets reported when the network interface is later brought up. So,
> debugging this by looking at the kernel messages is unreliable.
>

Russell,

You are correct... the link doesn't come up at that point its already
linked. So we need to force a reset or an auto negotiation reset after
modifying the delays.

Tim
