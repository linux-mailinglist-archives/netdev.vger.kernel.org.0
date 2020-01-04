Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16CA130025
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgADCea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:34:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46430 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgADCe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 21:34:29 -0500
Received: by mail-lj1-f193.google.com with SMTP id m26so43105545ljc.13
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 18:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQvpmc6bTYtIoGI7mIebVuPQLrewKdFxgpvNfh1jXk8=;
        b=tAZK3OEKd7k1M9evv8ECR6IT4KuCG9ELRfiOy7DNKz4dsEPusPe/W4hprN3ZoOOUz3
         +ODcHgUFQ4f7YwPVWXfHrzvzWU3ldmbVznRqqa1zjiUkPu4LpoCrsAknU2pSs7MXrXIu
         Y/xlv7+HrXX2kZSD/sFcN30bWts4SGSC4NXHj1vHv5ddjdk8O2FOHd/Rolgxf2cns+sm
         JXsm1ZhUMMiY+ixrFoIcOP0aW8DHcgEfeK6MQn7dP0f2AzG/APBX9Bucp+PPpWqmxSQz
         DHL2CocOXAEQcVBUweSFLywO+ba7qejLqqpJTYRMTjsrVcuRnFB62Lll2tPT7II4iznT
         iGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQvpmc6bTYtIoGI7mIebVuPQLrewKdFxgpvNfh1jXk8=;
        b=U5VLQF6o+YU1dhiDylzbbFG+kOFdg5LGvZSSlw2T0NaCdGxjm2k2vukothHOf3cXW8
         ZHbFvw/6foLENOodx0DdTwBsT6y7YC0gIFgBBth0qFrvsFSTRXgshUAlQvWHEj0sUXmI
         VBUJGysd1WmMLs/DlOmperQPvUOhMImbmnYDNbVxzoCLheOr8/RRMoCR58LmBlGzP6sw
         AhzxOovhjEu3amcJiK5L3brcCocojdkEVEgCG2EzDhhni0IG7LTo0gSg/3D5VNU05U22
         j7nD11372Qly7PJYtOFI5XkyL7dVJRLQ6LEmW88efP7xjZx8L1nuwbH2kf3706KfYlq3
         yp3A==
X-Gm-Message-State: APjAAAVT9RQnsfh85l/xd/jEjw1r8S9aDq5/FdqFSHbwNsWWexCcyqft
        jA0TAiic/40Rdcy7hX+XQk5SjAx+X7v/BDhQtt+tJg==
X-Google-Smtp-Source: APXvYqyD9oMygC2d1JGl/rCxn+X/nhk+8OE08L9az0yTsFlrgLIFWrcAV9zmwbipEHAuXtJG1WtnbPXhiUtiQEvCzyo=
X-Received: by 2002:a2e:9804:: with SMTP id a4mr27224065ljj.10.1578105265406;
 Fri, 03 Jan 2020 18:34:25 -0800 (PST)
MIME-Version: 1.0
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
 <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net>
 <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com> <CAMrEMU-QF8HCTMFhzHd0w2f132iA4GLUXHmBPGnuetPqkz=U7A@mail.gmail.com>
In-Reply-To: <CAMrEMU-QF8HCTMFhzHd0w2f132iA4GLUXHmBPGnuetPqkz=U7A@mail.gmail.com>
From:   Kan Yan <kyan@google.com>
Date:   Fri, 3 Jan 2020 18:34:14 -0800
Message-ID: <CA+iem5uPaYmZr=+kdHopm1Yo9dgyL98k7KfV6uYx_yH22FSGag@mail.gmail.com>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook (bisected)
To:     Justin Capella <justincapella@gmail.com>
Cc:     Stephen Oberholtzer <stevie@qrpff.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This AQL stuff sounds pretty nifty, and I'd love to try my hand at
> making it work for ath9k (also, since I put so much effort into an
> automated build-and-test framework, it'd be a shame to just abandon
> it.)  However, the ath9k code is rather lacking for comments, so I
> don't even know where I should start, except for (I suspect) a call to
> `wiphy_ext_feature_set(whatever, NL80211_EXT_FEATURE_AQL);` from
> inside ath9k_set_hw_capab()?
> In the meantime, I went back to e548f749b096 -- the commit prior to
> the one making AQL support opt-in -- and cranked up the debugging.

AQL is designed for wireless chipset that uses firmware/hardware
offloading, to manage the firmware/hardware queue size. For ath9k, the
TX queues are controlled by the host driver and chipsets that use
ath9k have a much smaller hardware queue compared to ath10k, so AQL is
probably not needed for ath9k. The airtime based TX scheduler alone
should be sufficient.

> > /sys/kernel/debug/ieee80211/phy0
> >
> > airtime_flags = 7
> >
> > stations/<my AP's MAC>/airtime =
> >
> > RX: 6583578 us
> > TX: 32719 us
> > Weight: 256
> > Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> > Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> > Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/12000
> >
> > (I have no idea how to interpret this, but that '32719 us' seems odd,
> > I thought the airtime usage was in 4us units?)
> Me neither, off the top of my head, let's wait for Toke.

"TX: 32719 us" is the airtime reported by firmware, which is not in 4us units.
There are two airtime: the "consumed" airtime reported by firmware,
which is used by the airtimed based TX scheduler to enforce fairness,
and the "estimated" airtime used by AQL to control the queue length
for frames pending in the firmware/hardware queue, which in 4us unit.

> I ran a ping, and saw this:
>
> - pings coming back in <5ms
> - re-enable AQL (echo 7 | tee airtime_flags)
> - pings stop coming back immediately
> - some seconds later, disable AQL again (echo 3 | tee airtime_flags)
> - immediate *flood* of ping replies registered, with times 16000ms,
> 15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
> - According to the icmp_seq values, all 28 requests were replied to,
> and their replies were delivered in-order
>
> This certainly looks like a missing TX queue restart to me?
I don't think TX queue restart is "missing", the TX queue should get
restarted when the pending frames is completed and returned to the
host driver. However, It looks like there is some issue with the
deficit refill logic in ath9k, and the TX queue got blocked due to the
negative deficit.


On Thu, Jan 2, 2020 at 11:22 PM Justin Capella <justincapella@gmail.com> wrote:
>
> The rather large negative deficit stands out to me. See this patch,
> https://patchwork.kernel.org/patch/11246363/ specifically the comments
> by Kan Yan
>
> On Thu, Jan 2, 2020, 3:14 PM Stephen Oberholtzer <stevie@qrpff.net> wrote:
> >
> >
> > /sys/kernel/debug/ieee80211/phy0
> >
> > airtime_flags = 7
> >
> > stations/<my AP's MAC>/airtime =
> >
> > RX: 6583578 us
> > TX: 32719 us
> > Weight: 256
> > Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> > Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> > Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/1200
>
> On Thu, Jan 2, 2020 at 3:14 PM Stephen Oberholtzer <stevie@qrpff.net> wrote:
> >
> > On Thu, Jan 2, 2020 at 8:28 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > On Tue, 2019-12-31 at 19:49 -0500, Stephen Oberholtzer wrote:
> > > > Wireless networking goes down on Acer C720P Chromebook (bisected)
> > > >
> > > > Culprit: 7a89233a ("mac80211: Use Airtime-based Queue Limits (AQL) on
> > > > packet dequeue")
> > > >
> >
> > <snip>
> >
> > > I think I found at least one hole in this, but IIRC (it was before my
> > > vacation, sorry) it was pretty unlikely to actually happen. Perhaps
> > > there are more though.
> > >
> > > https://lore.kernel.org/r/b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net
> >
> > <snippety-snip>
> >
> > > Do you get any output at all? Like a WARN_ON() for an underflow, or
> > > something?
> > >
> > > johannes
> > >
> >
> > Johannes,
> >
> > To answer your immediate question, no, I don't get any dmesg output at
> > all. Nothing about underruns.
> > However, while pursuing other avenues -- specifically, enabling
> > mac80211 debugfs and log messages -- I realized that my 'master' was
> > out-of-date from linux-stable and did a git pull.  Imagine my surprise
> > when the resulting kernel did not exhibit the problem!
> >
> > Apparently, I had been a bit too pessimistic; since the problem
> > existed in 5.5-rc1 release, I'd assumed that the problem wouldn't get
> > rectified before 5.5.
> >
> > However, I decided to bisect the fix, and ended up with: 911bde0f
> > ("mac80211: Turn AQL into an NL80211_EXT_FEATURE"), which appears to
> > have "solved" the problem by just disabling the feature (this is
> > ath9k, by the way.)
> >
> > This AQL stuff sounds pretty nifty, and I'd love to try my hand at
> > making it work for ath9k (also, since I put so much effort into an
> > automated build-and-test framework, it'd be a shame to just abandon
> > it.)  However, the ath9k code is rather lacking for comments, so I
> > don't even know where I should start, except for (I suspect) a call to
> > `wiphy_ext_feature_set(whatever, NL80211_EXT_FEATURE_AQL);` from
> > inside ath9k_set_hw_capab()?
> >
> > In the meantime, I went back to e548f749b096 -- the commit prior to
> > the one making AQL support opt-in -- and cranked up the debugging.
> >
> > I'm not sure how to interpret any of this, but  here's what I got:
> >
> > dmesg output:
> >
> > Last relevant mention is "moving STA <my AP's MAC> to state 4" which
> > happened during startup, before everything shut down.
> >
> > /sys/kernel/debug/ieee80211/phy0
> >
> > airtime_flags = 7
> >
> > stations/<my AP's MAC>/airtime =
> >
> > RX: 6583578 us
> > TX: 32719 us
> > Weight: 256
> > Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> > Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> > Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/12000
> >
> > (I have no idea how to interpret this, but that '32719 us' seems odd,
> > I thought the airtime usage was in 4us units?)
> >
> >
> > Doing an 'echo 3 | tee airtime_flags' to clear the (old) AQL-enabled
> > bit seemed to *immediately* restore network connectivity.
> >
> > I ran a ping, and saw this:
> >
> > - pings coming back in <5ms
> > - re-enable AQL (echo 7 | tee airtime_flags)
> > - pings stop coming back immediately
> > - some seconds later, disable AQL again (echo 3 | tee airtime_flags)
> > - immediate *flood* of ping replies registered, with times 16000ms,
> > 15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
> > - According to the icmp_seq values, all 28 requests were replied to,
> > and their replies were delivered in-order
> >
> > This certainly looks like a missing TX queue restart to me?
> >
> >
> > --
> > -- Stevie-O
> > Real programmers use COPY CON PROGRAM.EXE
