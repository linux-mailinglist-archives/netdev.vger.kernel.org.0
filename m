Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41968E063
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjBGSqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBGSqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:05 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD35233CC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so16010563pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1675795563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=of90sCCcXJinZdShprzTyoN8TRCgjq4A+a1iE8NihBA=;
        b=GxyIr2OYJNLKD1So3mpJT1ZyKBEVHypB34XNHO+xXgK4oMghTkEj8RIXfaNIyKXBgH
         E6JKtqUbRWV3p4QgL3AME7ffqKk9Yv3Pcii7/oKdoYd3Ehxjxt9JYOoB4AB4d9SiMc2D
         GI4iCf/RLQQ4ZB2cdv1S4lSptn5kx3JZViKcB66z3LYeIpmCOp7f+xJgaUoJZjxYXdPD
         Un0EKQW+q4u25SkN2tXvV1coo956TjiKhFoY4j/hA7BGDQF73osuYs0M/6OjVjETMMHf
         AH/7skY5MX8FBlILLseSP5C/fj0B1OeqHJUDEcYY7Riva2CFhkV8MV7nR7Zipr4+wyA2
         W5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675795563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=of90sCCcXJinZdShprzTyoN8TRCgjq4A+a1iE8NihBA=;
        b=sJRgxmTzgmZ9ducMlcug/PGrZnvVra5NSY8Zi6tb9JovLT0MC7q2fp3jTWhiFzuEMT
         dBJZ+Vyb2TPSBUhT6Wf+w299Wsrwx4Bm8mMQDTyxH/4k2FPp3lITC0Yji0hll7+UdyIg
         /88MLUHUH5Gvbtf5FqNVYsQpIbuK42Yi1JoT52sx4T49tDFJxdr7MSxwC4XFvKAUje+5
         AHqyOJYTabWu/Up1ZAzbx2Q/a9PQzI2+05ELxm2dB01P48UeTS2LhdUiGD3ddt46PsZK
         8cEW6glAzO4tPsWrFKFrrtAUIVQs/iIYEWiwLcQu6Stnq+glR+rlWZKmK4rvVXt2I7qU
         f1JQ==
X-Gm-Message-State: AO0yUKX+bVpdu3dfWnTerrpHOeyLpbC0sdGEn7twOXWg/SYcwvs39lsS
        MKihoA1cDwT2ndttQXRTg3QK527/AYEUjeRldaspmu4o
X-Google-Smtp-Source: AK7set8I5CKEUK9dtxtZ7mYcWs1SPmFDQ66nQYP1923ItVk5ghrrBMqasl14VL0GoJhCy0oHw5Nw+JQkrXulPaPN/9o=
X-Received: by 2002:a17:902:ee55:b0:196:1462:3279 with SMTP id
 21-20020a170902ee5500b0019614623279mr1072138plo.17.1675795563241; Tue, 07 Feb
 2023 10:46:03 -0800 (PST)
MIME-Version: 1.0
References: <20230206181628.73302-1-shannon.nelson@amd.com>
 <20230206181628.73302-4-shannon.nelson@amd.com> <0b5e7968ba5e18db29fea886c818782fc35f0556.camel@gmail.com>
 <7ef03ee8-5ba6-4231-6eaa-e4a46f9218fa@amd.com>
In-Reply-To: <7ef03ee8-5ba6-4231-6eaa-e4a46f9218fa@amd.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 7 Feb 2023 10:45:51 -0800
Message-ID: <CAKgT0UeC9zFfSM=pLa-a3h-_LgaCrgizq_xTUzf3sS8SaHaJEw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] ionic: add support for device Component
 Memory Buffers
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 7, 2023 at 10:24 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>
> On 2/6/23 1:36 PM, Alexander H Duyck wrote:
> > On Mon, 2023-02-06 at 10:16 -0800, Shannon Nelson wrote:
> >> The ionic device has on-board memory (CMB) that can be used
> >> for descriptors as a way to speed descriptor access for faster
> >> traffic processing.  It imposes a couple of restrictions so
> >> is not on by default, but can be enabled through the ethtool
> >> priv-flags.
> >
> > For the purposes of patch review it might be convinent to call out what
> > those restrictions are as you enable the code below. I'm assuming it is
> > mostly just the amount of space you can use, but if there is something
> > else it would be useful to have that noted.

The big thing for me is to make sure you call out your limitations. I
just want to make sure as the reviewer we know what to watch out for.
My main concern is wanting to see it documented somewhere as I am
assuming that it is mostly related to your MMIO size limitations.
However I have concerns that there may be other items such as the use
of write combining that would be nice to see called out somewhere as I
assume that is only needed for performance and not some writeback
limitation of the hardware.

> >
> >> @@ -390,6 +392,7 @@ static void ionic_remove(struct pci_dev *pdev)
> >>
> >>        ionic_port_reset(ionic);
> >>        ionic_reset(ionic);
> >> +     ionic_dev_teardown(ionic);
> >>        pci_clear_master(pdev);
> >>        ionic_unmap_bars(ionic);
> >>        pci_release_regions(pdev);
> >> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> >> index 626b9113e7c4..9b4bba2279ab 100644
> >> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> >> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> >> @@ -92,6 +92,7 @@ int ionic_dev_setup(struct ionic *ionic)
> >>        unsigned int num_bars = ionic->num_bars;
> >>        struct ionic_dev *idev = &ionic->idev;
> >>        struct device *dev = ionic->dev;
> >> +     int size;
> >>        u32 sig;
> >>
> >>        /* BAR0: dev_cmd and interrupts */
> >> @@ -133,9 +134,40 @@ int ionic_dev_setup(struct ionic *ionic)
> >>        idev->db_pages = bar->vaddr;
> >>        idev->phy_db_pages = bar->bus_addr;
> >>
> >> +     /* BAR2: optional controller memory mapping */
> >> +     bar++;
> >> +     mutex_init(&idev->cmb_inuse_lock);
> >> +     if (num_bars < 3 || !ionic->bars[IONIC_PCI_BAR_CMB].len) {
> >> +             idev->cmb_inuse = NULL;
> >> +             idev->phy_cmb_pages = 0;
> >> +             idev->cmb_npages = 0;
> >> +             return 0;
> >> +     }
> >> +
> >> +     idev->phy_cmb_pages = bar->bus_addr;
> >> +     idev->cmb_npages = bar->len / PAGE_SIZE;
> >> +     size = BITS_TO_LONGS(idev->cmb_npages) * sizeof(long);
> >> +     idev->cmb_inuse = kzalloc(size, GFP_KERNEL);
> >> +     if (!idev->cmb_inuse) {
> >> +             idev->phy_cmb_pages = 0;
> >> +             idev->cmb_npages = 0;
> >> +     }
> >> +
> >
> > Why not hold of on setting phy_cmb_pages and cmb_npages until after you
> > have allocated the pages rather then resetting them in the event of
> > failure?
>
> I need the values anyway to determine size, and the fail is unlikely, so
> why bother with tmp variables in the middle?  Also, this clearly sets
> idev->cmb_npages to 0 which is used as an indicator in the ethtool
> handler that thm CMB pages feature is not available.

Everything seems to be based on cmb_inuse being set anyway. You could
probably just leave the values set and not bother with zeroing them
since cmb_inuse would be NULL in case of the failure.

> >
> > Also is it really acceptable for this to fail silently?
>
> The fail would be from the memory allocation, which usually will already
> have printed some message, and we are usually discouraged from adding
> more "alloc failed" type messages.  Also, this is an optional feature,
> not needed for normal driver operations, so we don't need to kill the
> probe with an error code.  If the user tries to enable CMB, they will
> get a message that it is not available.

The error I would be looking for would be specific to the feature
failing to be enabled. The memory allocation would be harder to track
down since you would have to pick it out of a backtrace. If we had a
one line message about it failing to initialize that might be useful
in debugging should an attempt to enable it fail.
