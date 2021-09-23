Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF9416601
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbhIWTkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbhIWTkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:40:13 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA1FC061574;
        Thu, 23 Sep 2021 12:38:41 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eg28so27208597edb.1;
        Thu, 23 Sep 2021 12:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Crfq7oYAoG8JFMvE676pL0/iUOz+9stc+tHZex6JUT8=;
        b=cTwmisMFk6jl3/R1y3X+8Z5iyEHo2ZdRB1yMYKKM+o2149w/B1kEX5riLeICq7Cfm7
         6WlRbCQ8r8P+BkEODJukPxf71p8KudEYRpOWie6unCSIRQeqyPtYsjY7t4beiIx+7KW+
         jD5CBYiJd/2380IvVnPLFudYD/JTWSsD736bTkmZcrttSPstI8dos/fKhMd0CIPOUi3t
         gVQX5V3NLCXpvbRlrRIxsr8kQJ+QePWN5LRwY4XR1ruYGmFexwWpGK5QMvdZRRUUgeK7
         /Z3TxXh38C1rMh9gMsHMavaqQG2pMpo60YaIk5KzkYqARy81mjTgUBtFqNuRoJNEH9kS
         uRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Crfq7oYAoG8JFMvE676pL0/iUOz+9stc+tHZex6JUT8=;
        b=P1RYhtVPzkcgrdkmStDfoxPq/Vlh/VD8h3IT+X7KFSwSRRz7/lIGiIAt2iVbYOCxEH
         7jTrRGExzvGgwrMNXvgeOr9VuioaOuBx//f+LxDIEqNIGhfwbZBNrQ2B0p64btmghlfK
         lS4KUf2iNtLgPqR0ektD2ljVppMoQ4uBnBg8e/hkSq2+JHtY9Dx4WjgS4iBz+F6Fcv2g
         VtUgo+av3Fxvg7Ply3yDe0lpP5e43MIRl8WUxLskIGcaclY4jG00f+8MCyPDGM5GAYbu
         OKhbscbI6fUnYWd68lkUOTksYcQKFMPIkfmUL2k1f30qp5ae5bTuKIaHYMKbXolAZOqd
         PvkQ==
X-Gm-Message-State: AOAM531M6o5d0hrjouMEDkmrMsE9jmMNpeNzCb92kPoBXrNc2em1XMuS
        A/tZIUUYEXFliPm1E0r2u6BXoazfGVAEaJ7YMhg=
X-Google-Smtp-Source: ABdhPJwyduLxYBBHBlpBM0b3Dvma9HOOm0+aDOcKahAlaet7awvdEC8JhTHGJRUUIw/qqtvgoDJUZw+wkVxNjdjdLuM=
X-Received: by 2002:a17:906:2887:: with SMTP id o7mr7053776ejd.425.1632425920308;
 Thu, 23 Sep 2021 12:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com> <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
 <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl> <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
In-Reply-To: <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 23 Sep 2021 22:37:40 +0300
Message-ID: <CAHp75VdRWd9Oj_68BqewAdjtzhRz406eh=4M7FmjRvqhkaWaOw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 6:28 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
>
> On 9/22/21 2:50 PM, Jonas Dre=C3=9Fler wrote:
> > On 9/20/21 7:48 PM, Brian Norris wrote:
> >> On Sat, Sep 18, 2021 at 12:37 AM Jonas Dre=C3=9Fler <verdre@v0yd.nl> w=
rote:
> >>> Thanks for the pointer to that commit Brian, it turns out this is
> >>> actually the change that causes the "Firmware wakeup failed" issues t=
hat
> >>> I'm trying to fix with the second patch here.
> >>
> >> Huh. That's interesting, although I guess it makes some sense given
> >> your theory of "dropped writes". FWIW, this strategy (post a single
> >> write, then wait for wakeup) is the same used by some other
> >> chips/drivers too (e.g., ath10k/pci), although in those cases card
> >> wakeup is much much faster. But if the bus was dropping writes
> >> somehow, those strategies would fail too.
> >>
> >>> Also my approach is a lot messier than just reverting
> >>> 062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3 and also appears to be block=
ing
> >>> even longer...
> >>
> >> For the record, in case you're talking about my data ("blocking even
> >> longer"): I was only testing patch 1. Patch 2 isn't really relevant to
> >> my particular systems (Rockchip RK3399 + Marvell 8997/PCIe), because
> >> (a) I'm pretty sure my system isn't "dropping" any reads or writes
> >> (b) all my delay is in the read-back; the Rockchip PCIe bus is waiting
> >> indefinitely for the card to wake up, instead of timing out and
> >> reporting all-1's like many x86 systems appear to do (I've tested
> >> this).
> >>
> >> So, the 6ms delay is entirely sitting in the ioread32(), not a delay
> >> loop.
> >>
> >> I haven't yet tried your version 2 (which avoids the blocking read to
> >> wake up; good!), but it sounds like in theory it could solve your
> >> problem while avoiding 6ms delays for me. I intend to test your v2
> >> this week.
> >>
> >
> > With "blocking even longer" I meant that (on my system) the delay-loop
> > blocks even longer than waking up the card via mwifiex_read_reg() (both
> > are in the orders of milliseconds). And given that in certain cases the
> > card wakeup (or a write getting through to the card, I have no idea) ca=
n
> > take extremely long, I'd feel more confident going with the
> > mwifiex_read_reg() method to wake up the card.
> >
> > Anyway, you know what's even weirder with all this: I've been testing
> > the first commit of patch v2 (so just the single read-back instead of
> > the big hammer) together with 062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3
> > reverted for a good week now and haven't seen any wakeup failure yet.
> > Otoh I'm fairly sure the big hammer with reading back every write wasn'=
t
> > enough to fix the wakeup failures, otherwise I wouldn't even have
> > started working on the second commit.
> >
> > So that would mean there's a difference between writing and then readin=
g
> > back vs only reading to wake up the card: Only the latter fixes the
> > wakeup failures.
> >
> >>> Does anyone have an idea what could be the reason for the posted writ=
e
> >>> not going through, or could that also be a potential firmware bug in =
the
> >>> chip?
> >>
> >> I have no clue about that. That does sound downright horrible, but so
> >> are many things when dealing with this family of hardware/firmware.
> >> I'm not sure how to prove out whether this is a host bus problem, or
> >> an endpoint/firmware problem, other than perhaps trying the same
> >> module/firmware on another system, if that's possible.
> >>
> >> Anyway, to reiterate: I'm not fundamentally opposed to v2 (pending a
> >> test run here), even if it is a bit ugly and perhaps not 100%
> >> understood.
> >>
> >
> > I'm not 100% sure about all this yet, I think I'm gonna try to confirm
> > my older findings once again now and then we'll see. FTR, would you be
> > fine with using the mwifiex_read_reg() method to wake up the card and
> > somehow quirking your system to use write_reg()?
> >
> >> Brian
> >>
> >
>
> Okay, so I finally managed to find my exact reproducer for the bug again:
>
> 1) Make sure wifi powersaving is enabled (iw dev wlp1s0 set power_save on=
)
> 2) Connect to any wifi network (makes firmware go into wifi powersaving
> mode, not deep sleep)
> 3) Make sure bluetooth is turned off (to ensure the firmware actually
> enters powersave mode and doesn't keep the radio active doing bluetooth
> stuff)
> 4) To confirm that wifi powersaving is entered ping a device on the LAN,
> pings should be a few ms higher than without powersaving
> 5) Run "while true; do iwconfig; sleep 0.0001; done", this wakes and
> suspends the firmware extremely often
> 6) Wait until things explode, for me it consistently takes <5 minutes
>
> Using this reproducer I was able to clear things up a bit:
>
> - There still are wakeup failures when using (only) mwifiex_read_reg()
> to wake the card, so there's no weird difference between waking up using
> read vs write+read-back
>
> - Just calling mwifiex_write_reg() once and then blocking until the card
> wakes up using my delay-loop doesn't fix the issue, it's actually
> writing multiple times that fixes the issue
>
> These observations sound a lot like writes (and even reads) are actually
> being dropped, don't they?



--=20
With Best Regards,
Andy Shevchenko
