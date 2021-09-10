Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA20D40653B
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhIJBeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 21:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhIJBeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 21:34:03 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B6FC061574
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 18:32:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so163235otk.9
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 18:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRiYcvdIn/aIEmoI5IOHlPi9c0uTR/p2l9AM+C5qzoE=;
        b=Pk6JlJ5+3PF9YT39h3z/kI4BCr7l0eaEAVOdoIEmk/VaBHSUbuMfkdMkj0wyDeWD/S
         W8O7GHAmoMtdiYdFRczKtWogOmI22BKWnzfcMYlucsu3VSZOTV1H7k0ld2K34qN/ogQS
         +SH6DQSU5Zc2TUfRFMzQNJHbeH4L0EthiL2q/0MYs2q8jCGi1OBZ8KyXyqcAKoa88h2V
         NRIICbILy5Hw/ot7dFCRq/Q+1PMsv66ehj2KONrpX811JdFZ/45qImAQDBX0eIKNbW6l
         8DJdP/N7b2xEe6uu6kYksLVUjHHoH/E4J3Tx5DqEGCgXv/cxhAVBznfaRf79kLZnXhNI
         uZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRiYcvdIn/aIEmoI5IOHlPi9c0uTR/p2l9AM+C5qzoE=;
        b=7IJATlyKSnKS+0L9B8mf1QEKFHpZ3+oTPZgY8XUxe/czq1z4JfKEll2vF+phelKGjE
         TmFTSd67jdIRSjtS+tbXH6E02Fn4TnfeSJazARzzKlRrHfLu5SWoFP/8gsFkyLXmqnQB
         f4CEUh/Jpsc4Oax/d6n0iqdRTmExhyd908DlHUQslslhrPU5qamM9tpSatOIUL1GUz/P
         FTxV9i7LF+a9w7zWVVv95f6gPgixOKX5xziIgt8VkeX5rg5/j5jkj5aiZboCp7oTMJb/
         L9bnsotDesNSZW8w4rCzXVD74nBYMt9g24AwJL9Z3amNwyfu3zAhDf2GbbdA/CnUpWKz
         /PGQ==
X-Gm-Message-State: AOAM531tE2kdQoApwoIuftAXsVy7ElMxA964XQlxG50tR1BJ8+kowO2e
        GX1k9RfGGxtNnOnRPq0WZEti22x1xg1JDX6ysKX01PHu1nU=
X-Google-Smtp-Source: ABdhPJyy96OTE8WKils6yM2cKUTOISLgSatOYHdOyX7HiKP4NWC3PnrAMdTW/JXUMUwZI1tMmXodv2hgtUr0quHGWXU=
X-Received: by 2002:a25:e0d4:: with SMTP id x203mr7090909ybg.391.1631237560343;
 Thu, 09 Sep 2021 18:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de> <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de> <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf> <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf> <92ad3d7d-78db-289b-47d7-55b33b83c24e@gmail.com>
In-Reply-To: <92ad3d7d-78db-289b-47d7-55b33b83c24e@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 9 Sep 2021 18:32:04 -0700
Message-ID: <CAGETcx_Nq1dxAd84sHPtNjkeJNcA+u6xybCGg=QEoficmDT=+Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 9:00 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> +Saravana,
>
> On 9/9/2021 8:47 AM, Vladimir Oltean wrote:
> > On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
> >>> Do you see similar things on your 5.10 kernel?
> >>
> >> For the master device is see
> >>
> >> lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consumer:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:spi3.0
> >
> > So this is the worst of the worst, we have a device link but it doesn't help.
> >
> > Where the device link helps is here:
> >
> > __device_release_driver
> >       while (device_links_busy(dev))
> >               device_links_unbind_consumers(dev);
> >
> > but during dev_shutdown, device_links_unbind_consumers does not get called
> > (actually I am not even sure whether it should).
> >
> > I've reproduced your issue by making this very simple change:
> >
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > index 60d94e0a07d6..ec00f34cac47 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > @@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver = {
> >       .id_table = enetc_pf_id_table,
> >       .probe = enetc_pf_probe,
> >       .remove = enetc_pf_remove,
> > +     .shutdown = enetc_pf_remove,
> >   #ifdef CONFIG_PCI_IOV
> >       .sriov_configure = enetc_sriov_configure,
> >   #endif
> >
> > on my DSA master driver. This is what the genet driver has "special".
> >
> > I was led into grave error by Documentation/driver-api/device_link.rst,
> > which I've based my patch on, where it clearly says that device links
> > are supposed to help with shutdown ordering (how?!).
>
> I was also under the impression that device links were supposed to help
> with shutdown ordering, because it does matter a lot. One thing that I
> had to work before (and seems like it came back recently) is the
> shutdown ordering between gpio_keys.c and the GPIO controller. If you
> suspend the GPIO controller first, gpio_keys.c never gets a chance to
> keep the GPIO pin configured for a wake-up interrupt, therefore no
> wake-up event happens on key presses, whoops.

This is more of a Rafael question. Adding him. I haven't looked too
closely at device links and shutdown.

-Saravana

>
> >
> > So the question is, why did my DSA trees get torn down on shutdown?
> > Basically the short answer is that my SPI controller driver does
> > implement .shutdown, and calls the same code path as the .remove code,
> > which calls spi_unregister_controller which removes all SPI children..
> >
> > When I added this device link, one of the main objectives was to not
> > modify all DSA drivers. I was certain based on the documentation that
> > device links would help, now I'm not so sure anymore.
> >
> > So what happens is that the DSA master attempts to unregister its net
> > device on .shutdown, but DSA does not implement .shutdown, so it just
> > sits there holding a reference (supposedly via dev_hold, but where from?!)
> > to the master, which makes netdev_wait_allrefs to wait and wait.
>
> It's not coming from of_find_net_device_by_node() that's for sure and
> with OF we don't go through the code path calling
> dsa_dev_to_net_device() which does call dev_hold() and then shortly
> thereafter the caller calls dev_put() anyway.
>
> >
> > I need more time for the denial phase to pass, and to understand what
> > can actually be done. I will also be away from the keyboard for the next
> > few days, so it might take a while. Your patches obviously offer a
> > solution only for KSZ switches, we need something more general. If I
> > understand your solution, it works not by virtue of there being any
> > shutdown ordering guarantee at all, but simply due to the fact that
> > DSA's .shutdown hook gets called eventually, and the reference to the
> > master gets freed eventually, which unblocks the unregister_netdevice
> > call from the master. I don't yet understand why DSA holds a long-term
> > reference to the master, that's one thing I need to figure out.
> >
>
> Agreed.
> --
> Florian
