Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8572A2D0656
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 18:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgLFRdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgLFRdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 12:33:15 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2724BC0613D1;
        Sun,  6 Dec 2020 09:32:35 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i9so11117502ioo.2;
        Sun, 06 Dec 2020 09:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7N3sBfPKm9s8YI9bZ1YGc7d1O3+NqdQ1UI3/+WPcotk=;
        b=M45rI/m9DMfZmnJXHL7tTN30niu12r/EOAWc38VandwIYSnfEVUM1g2s2xYck7pARH
         wZD40X4jBe/KnNOo7q99jsZPfDyPyERcf/qwdmfPPxcEvC6QWQuKRb5mts4VYAlwHM+J
         CKtoU6Gyj7ZUqawPn6PTniKEGMhXGCp3JK6isjiY62Hk27nQT+2Zt9oe5S2E/TgWczJ7
         /zR6bHCHfRRjDxS2JiO4EROOwDW0x2uqZ1LF4OlUTO/0E2YsLnVvEzlRXl/I1pgjyOE4
         FWVXUDY0G6EzP9mJ2M06s6TEISJPNDdN6huCiSC02KrDYjY1bxOQXPht9J2QQ5p+PN9u
         CWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7N3sBfPKm9s8YI9bZ1YGc7d1O3+NqdQ1UI3/+WPcotk=;
        b=aAkIFtZYZSLRgUqMAIwXUM7QOml8M2IlMBGgekg3eIKLqzC7i88cLaRCLuP61Fn6Ml
         puNF9KDYBFg83nus9tnviPupp5YTRDeOUOq7pBHOBrwCOczG1YzGacsFN0ITTS6Lsc0M
         pVWAO5Wg3lAVKwv4Q0RTc6h18q5PeTHe/qruxDJ11Lz0fUQDfdQTZNGOWYwAa0yp5xp9
         S2taH6lWT4BiqliNdOXNCafMAmwq5TNErF8SdmulSX9Xtgn5SCfVVQ8cEtwGc71X320F
         AVeTdKJJRJB54QF0WY4Z+fF9Y6LTJxEVFf5kpkY70zEdsgi5A11qbpR6tiwMhLnvvGDG
         GKlA==
X-Gm-Message-State: AOAM530GwA6yNWM3k3Mh7t8CAOXp/gDcsO4WSk+eZTlevtchk/XERCML
        qqTOe/cbxmJZ8/x2BbuDENnRwoIF6JtqkSRvTeE=
X-Google-Smtp-Source: ABdhPJzqZCFiKiB5XjLUJArT/oiyNwwhPMWwOHxTLuiIuMINM7YzyWjxQfucl4doqDFbDLYVdSs/NdFIuXNI+AklWTs=
X-Received: by 2002:a02:5d85:: with SMTP id w127mr16403664jaa.83.1607275954356;
 Sun, 06 Dec 2020 09:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com>
 <DM6PR19MB2636B200D618A5546E7BBB57FAF10@DM6PR19MB2636.namprd19.prod.outlook.com>
 <CAKgT0UfuyrbzpDNySMmnAkqKnw9cYuEM1LhgG0QvmrY=smR-uw@mail.gmail.com> <20201205154951.4dd92194@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205154951.4dd92194@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 6 Dec 2020 09:32:23 -0800
Message-ID: <CAKgT0UcJh219bAXJtJFu7BZsh2+UVGqpLmTiX9V1utsQpPSjvA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        David Arcari <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 3:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Dec 2020 14:38:03 -0800 Alexander Duyck wrote:
> > > > The patches look good to me. Just need to address the minor issue that
> > > > seems to have been present prior to the introduction of this patch
> > > > set.
> > > >
> > > > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > Thanks for your review.  Just some operational questions - since this previously
> > > existed do you want me to re-spin the series to a v4 for this, or should it be
> > > a follow up after the series?
> > >
> > > If I respin it, would you prefer that change to occur at the start or end
> > > of the series?
> >
> > I don't need a respin, but if you are going to fix it you should
> > probably put out the patch as something like a 8/7. If you respin it
> > should happen near the start of the series as it is a bug you are
> > addressing.
>
> Don't we need that patch to be before this series so it can be
> back ported easily? Or is it not really a bug?

You're right. For backports it would make it easier to have the patch
be before the changes. As far as being a bug, it is one, but it isn't
an urgent bug as it is basically some bad exception handling so the
likelihood of seeing it should be quite low.
