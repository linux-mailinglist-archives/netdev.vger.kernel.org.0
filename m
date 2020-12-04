Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A1F2CF6F7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgLDWi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgLDWiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 17:38:55 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FEAC061A51;
        Fri,  4 Dec 2020 14:38:15 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id g1so6648071ilk.7;
        Fri, 04 Dec 2020 14:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zfSI0BVuut11EY/18dl98BRShWbYjMNy9Mytisqq938=;
        b=HzF35Jud24in6HdLiieS6+ZLB//zqFBLW5Cc8v5F2Ey9a+SzEU/CTBgns9+j6FdTbj
         BigmhJ+S6UJLEoAv9VbPYcd0vol5XRk8fPTTw9Bbc+V3SM3aLScBymmSQP/IHOqDzPaN
         bpKmTsQsSjiWY92uCSdXOoqNZMyLIrADEcP6ltW/r7480TknbM90F3bzAGNn51cuEi9M
         /e65BCwqh1S1YezAOunYu9136HxPrm4iHYP3Z1bLifpJxGjAntC2FE2411z57A6rgncl
         cVpy5r5orvw4+/X72ViHG4JpiFEA5SwUxJ7vaX44GelzjXthZ2gAPz8Z2GRLPMGGex1N
         M0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zfSI0BVuut11EY/18dl98BRShWbYjMNy9Mytisqq938=;
        b=iELrtAkDabOOGp4yBxt4Qfy5GhkAxlF3a9q4yc/lib8qs6qOrC0SaCoQm2l6XGw+U9
         l7FVTAPJXcrIcana+W+QoanEgWPvlaYRZVHHNc9Ef58s9JKSzMM/7b2AYo2+VaRXpPjV
         aJK2QXEwAhxXTDAdkXqPr3mFYfKgXmif0ttF5K7x0/pw1eXS0btFbE5wLh+Vnl01F8pK
         /N3nsIguCfL9L2t7EVvLRtrW4rclSAcURGc0avUURnnVjeSk+Jg47tJ4kSNEgACYIQdP
         V8IJjiVcANxmq23T6/81Qczl07JpnXmwkzcPECABmacX9LLQi9TGB5UpRrfQ3+wM4GTl
         3RqA==
X-Gm-Message-State: AOAM5323N8Zl/nwZTV5Wl09Xi8ZSsLB0aWmCKvJxiStIGvaKUBU2rioO
        aAGcxikmBjmeA3EByYXUib61NXHIAm+7LX91T/k=
X-Google-Smtp-Source: ABdhPJwq6XTGDVI27yEFKGhO8FLGO5z8uzKtXlTVxip2PtUxYmvG1QV2rHjit/27EVWnmcU+/bTgLUQ2mR3AuU7Tm9c=
X-Received: by 2002:a92:730d:: with SMTP id o13mr8965445ilc.95.1607121494715;
 Fri, 04 Dec 2020 14:38:14 -0800 (PST)
MIME-Version: 1.0
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com> <DM6PR19MB2636B200D618A5546E7BBB57FAF10@DM6PR19MB2636.namprd19.prod.outlook.com>
In-Reply-To: <DM6PR19MB2636B200D618A5546E7BBB57FAF10@DM6PR19MB2636.namprd19.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 4 Dec 2020 14:38:03 -0800
Message-ID: <CAKgT0UfuyrbzpDNySMmnAkqKnw9cYuEM1LhgG0QvmrY=smR-uw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Fri, Dec 4, 2020 at 2:28 PM Limonciello, Mario
<Mario.Limonciello@dell.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Friday, December 4, 2020 15:27
> > To: Limonciello, Mario
> > Cc: Jeff Kirsher; Tony Nguyen; intel-wired-lan; LKML; Linux PM; Netdev; Jakub
> > Kicinski; Sasha Netfin; Aaron Brown; Stefan Assmann; David Miller; David
> > Arcari; Shen, Yijun; Yuan, Perry; anthony.wong@canonical.com
> > Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
> >
> >
> > [EXTERNAL EMAIL]
> >
> > On Fri, Dec 4, 2020 at 12:09 PM Mario Limonciello
> > <mario.limonciello@dell.com> wrote:
> > >
> > > commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
> > systems")
> > > disabled s0ix flows for systems that have various incarnations of the
> > > i219-LM ethernet controller.  This was done because of some regressions
> > > caused by an earlier
> > > commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> > > with i219-LM controller.
> > >
> > > Performing suspend to idle with these ethernet controllers requires a
> > properly
> > > configured system.  To make enabling such systems easier, this patch
> > > series allows determining if enabled and turning on using ethtool.
> > >
> > > The flows have also been confirmed to be configured correctly on Dell's
> > Latitude
> > > and Precision CML systems containing the i219-LM controller, when the kernel
> > also
> > > contains the fix for s0i3.2 entry previously submitted here and now part of
> > this
> > > series.
> > > https://marc.info/?l=linux-netdev&m=160677194809564&w=2
> > >
> > > Patches 4 through 7 will turn the behavior on by default for some of Dell's
> > > CML and TGL systems.
> >
> > The patches look good to me. Just need to address the minor issue that
> > seems to have been present prior to the introduction of this patch
> > set.
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>
> Thanks for your review.  Just some operational questions - since this previously
> existed do you want me to re-spin the series to a v4 for this, or should it be
> a follow up after the series?
>
> If I respin it, would you prefer that change to occur at the start or end
> of the series?

I don't need a respin, but if you are going to fix it you should
probably put out the patch as something like a 8/7. If you respin it
should happen near the start of the series as it is a bug you are
addressing.
