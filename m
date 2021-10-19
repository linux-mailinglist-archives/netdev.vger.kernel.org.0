Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF51C433DD2
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhJSRxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhJSRxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:53:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6CC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:51:31 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r4so9228590edi.5
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+14G6bpeSZaGRLoDMaNEETFG1kZsEHc4TCuylqd1Jb8=;
        b=fraQguX0c5GX1wgVS/iXx8RXEhSLeSsTMCfuYA+sGp3xmZktza2ZLCYaQncbwgjUbz
         wTVOrMmo5Z9dwraXNmaNRMXK595FkQkBRMn1ImTf7gsy1TIP0LsPazL2kjCaZsNmOAdM
         4GJFY65++kiskyQhw0XE8TIQ9q1C4Yr15RKFaSySmBwiIDsDBCKQRcEg5gNTX27ActzQ
         UEFS9SoA8edvOA288Q0TvAf9M8W/2GY088b9hswxluelDAw/K995LM1WwSaravP5fOuG
         SdHoqGRVYI8MMX/7KqNhkILLmXhCjJU0MP5xvIsLfqz4A2u6hhbtFylkCZlmXwJF78wZ
         ikCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+14G6bpeSZaGRLoDMaNEETFG1kZsEHc4TCuylqd1Jb8=;
        b=7UcMWP+dbyUE8y2rghepmGPq9pA/fysIo1HOKWSYq7nNeEE13DlmxkAhWyH/UFf2fN
         QHA3I7c6EMH4whJlzd2gB9KONdbMc3cH2dqhtTSwKkKZkWtR59h7ZdxcAGD35eQpWCMX
         iY6HBCwFHrBZ5aeQZXFS/dubrSJ2DZlEb3baZY4CBQwLcUmZqohq5WTVlli9CnyZ23Xs
         Jr8d+NWsmjlEKnkPrB+679mrpDqGS37cSrAGgexImxaSgSXwsdz5jlUE1zbnsRbiRPqG
         +oSPloiVqozL/Jb2ifXfdxjrilQunMEhfMq4Pv2JV1qypNQh/td0e7/7hvTIZpbF92Jp
         vgAQ==
X-Gm-Message-State: AOAM530eJblnFgYCfdgDqa4ne4/txkoWkpunQ8Q0OGKjxYTYTfjwqHS0
        XBv2prZExpu6XS35trlghmnxWWg/zqkqdU3MZP89TA==
X-Google-Smtp-Source: ABdhPJyDkXIjnwuDyIaREOIpcV1r/d8FQTqZX6n/TOpCdGYo9cdftRcTYSMwD2UZIXoXRqkxisLubgtUkSr9wc5ZgMo=
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr39730514ejp.427.1634665887709;
 Tue, 19 Oct 2021 10:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211018183709.124744-1-erik@kryo.se> <YW7k6JVh5LxMNP98@lunn.ch>
 <20211019155306.ibxzmsixwb5rd6wx@gmail.com> <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
In-Reply-To: <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 19 Oct 2021 19:51:16 +0200
Message-ID: <CAGgu=sA1B5=HzMYBD0r6M0BD+8fWCTOwxfEE9gTAySHABoON2Q@mail.gmail.com>
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
To:     Andrew Lunn <andrew@lunn.ch>, Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 19:34, Erik Ekman <erik@kryo.se> wrote:
>
> On Tue, 19 Oct 2021 at 17:53, Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Tue, Oct 19, 2021 at 05:31:52PM +0200, Andrew Lunn wrote:
> > > On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > > > These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> > > > for 1000BaseX and missing 10G link modes") back in 2016.
> > > >
> > > > Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> > > >
> > > > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> > >
> > > Did you test with a Copper SFP modules?
> > >
>
> I have tested it with a copper SFP PHY at 1G and that works fine.
> I don't have the hardware to test copper 10G (RJ45).
>
> > > > +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> > > > @@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
> > > >     case MC_CMD_MEDIA_QSFP_PLUS:
> > > >             SET_BIT(FIBRE);
> > > >             if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> > > > -                   SET_BIT(1000baseT_Full);
> > > > +                   SET_BIT(1000baseX_Full);
> > >
> > > I'm wondering if you should have both? The MAC is doing 1000BaseX. But
> > > it could then be connected to a copper PHY which then does
> > > 1000baseT_Full? At 1G, it is however more likely to be using SGMII,
> > > not 1000BaseX.

If you mean that the card has only copper phys on the card, then a
different case in the switch statement is run
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/sfc/mcdi_port_common.c#n149).
Should we still return both if the only baseT support is via an SFP module?

>
> Yes, we can return both.
>
> Similarly, is there a reason only CR modes are set for fiber ports,
> when I expect LR/SR/etc to work as well?
> I can set the modes for 10G similar to the example in 5711a98221443
> ("net: ethtool: add support
> for 1000BaseX and missing 10G link modes"): CR/SR/LR/ER
> I inserted a LR SFP+ module and ethtool -m could list its settings at least.
>
> >
> > Yes, they should both be set. We actually did a 10Gbase-T version of Siena,
> > the SFN51x1T.
> >
>
> For the baseT-version of the cards the supported modes are set further
> down in the file
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/sfc/mcdi_port_common.c#n149),
> so they are not affected by this change.
>
> Thanks
> /Erik
