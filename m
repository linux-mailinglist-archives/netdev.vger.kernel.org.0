Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA631D83F8
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733256AbgERSHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733245AbgERSHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:07:05 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77217C061A0C;
        Mon, 18 May 2020 11:07:05 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ee19so5162244qvb.11;
        Mon, 18 May 2020 11:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FGe0cYU7QRQrBub6kPg7LS2mMokuizGPeM+/vsZpJ0c=;
        b=DDZsqjev9pPgykILD6UPID2QV3+WLOgbGPXNX7VGKiD5foIMBD6Ig3QA44tRzLmGib
         1mKKZilQ5ETaljO5EYgpRnJptRjnAUOLxPH4gdu5+sMzcEgSRjVuhvaeSTM9YoycCwCk
         2A+TY4cjxjhxNxZiLYT2ruZPcxJNu7umH6Vu9aSZIYrrv9XJn+MInwstXFCAlIHw1WUb
         sCqyfCtYVo5dQrNv3xg086881Zd5saQlxNJu53IiQDzlfrTSmR2Y3bav8kaCWopJzt5B
         qVeDKeGSnlwZcimXa9kVFJ6abIibigsiCpI3x/x/V3LmORYeovnqdMuYBqB3p76Djc/9
         VAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FGe0cYU7QRQrBub6kPg7LS2mMokuizGPeM+/vsZpJ0c=;
        b=N8n9cidacfPNCPKXAuQxcgxY9bNR2V9T+GfNzusWJseoq/sQSZxLxUBH7V86HL46uI
         SmxLrTQTeTQ8ZBAS3UeboP3um3h7wQBhfViNQISIS4MP/ZxAYDsDBSEGdPETyFYTe+jW
         g5Zzx/scUnjlb/cg6tn6gcCTYpD7RRMwFjFT2LWxzz731CgkOi6z07KMyrPLUNLjItYm
         M+//i5ijhClVuAVsOXVTAQUA2xczG6un++lNHpUYrpgA/BFSFCS5WMMrygqWxQpCORrI
         CfsgXhNHjdobSU1/D6e0zXM0+mLm4sxcBvaneSl8P/uqiOkoOTUeLhkykIDOJ670Ffl2
         CbJA==
X-Gm-Message-State: AOAM531q3REZQiPyl2pYxkGVno1EMfmkSh6baP/rN/Q7xMsu85LRoAsK
        J9IRKwC2q8NWD6LYqYbY1HiEkGoOjJUawOc2AAo=
X-Google-Smtp-Source: ABdhPJx7gFJZCHG8pAYfJs0PbDVHs9Ww5BXdE3nVr2Ovp/YWIgWIKSJgkqjadmT/fF2jdRU64gjBY21G4Xm8cOd52zo=
X-Received: by 2002:a0c:e48f:: with SMTP id n15mr15724904qvl.73.1589825224064;
 Mon, 18 May 2020 11:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com> <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com> <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
 <20200518171801.GL11244@42.do-not-panic.com>
In-Reply-To: <20200518171801.GL11244@42.do-not-panic.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 18 May 2020 11:06:27 -0700
Message-ID: <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 10:19 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Mon, May 18, 2020 at 10:15:45AM -0700, Ben Greear wrote:
> >
> >
> > On 05/18/2020 10:09 AM, Luis Chamberlain wrote:
> > > On Mon, May 18, 2020 at 09:58:53AM -0700, Ben Greear wrote:
> > > >
> > > >
> > > > On 05/18/2020 09:51 AM, Luis Chamberlain wrote:
> > > > > On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
> > > > > > On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
> > > > > >
> > > > > > You didn't CC me or the wireless list on the rest of the patches, so I'm
> > > > > > replying to a random one, but ...
> > > > > >
> > > > > > What is the point here?
> > > > > >
> > > > > > This should in no way affect the integrity of the system/kernel, for
> > > > > > most devices anyway.
> > > > >
> > > > > Keyword you used here is "most device". And in the worst case, *who*
> > > > > knows what other odd things may happen afterwards.
> > > > >
> > > > > > So what if ath10k's firmware crashes? If there's a driver bug it will
> > > > > > not handle it right (and probably crash, WARN_ON, or something else),
> > > > > > but if the driver is working right then that will not affect the kernel
> > > > > > at all.
> > > > >
> > > > > Sometimes the device can go into a state which requires driver removal
> > > > > and addition to get things back up.
> > > >
> > > > It would be lovely to be able to detect this case in the driver/system
> > > > somehow!  I haven't seen any such cases recently,
> > >
> > > I assure you that I have run into it. Once it does again I'll report
> > > the crash, but the problem with some of this is that unless you scrape
> > > the log you won't know. Eventually, a uevent would indeed tell inform
> > > me.
> > >
> > > > but in case there is
> > > > some common case you see, maybe we can think of a way to detect it?
> > >
> > > ath10k is just one case, this patch series addresses a simple way to
> > > annotate this tree-wide.
> > >
> > > > > > So maybe I can understand that maybe you want an easy way to discover -
> > > > > > per device - that the firmware crashed, but that still doesn't warrant a
> > > > > > complete kernel taint.
> > > > >
> > > > > That is one reason, another is that a taint helps support cases *fast*
> > > > > easily detect if the issue was a firmware crash, instead of scraping
> > > > > logs for driver specific ways to say the firmware has crashed.
> > > >
> > > > You can listen for udev events (I think that is the right term),
> > > > and find crashes that way.  You get the actual crash info as well.
> > >
> > > My follow up to this was to add uevent to add_taint() as well, this way
> > > these could generically be processed by userspace.
> >
> > I'm not opposed to the taint, though I have not thought much on it.
> >
> > But, if you can already get the crash info from uevent, and it automatically
> > comes without polling or scraping logs, then what benefit beyond that does
> > the taint give you?
>
> From a support perspective it is a *crystal* clear sign that the device
> and / or device driver may be in a very bad state, in a generic way.
>

Unfortunately a "taint" is interpreted by many users as: "your kernel
is really F#*D up, you better do something about it right now."
Assuming they're paying attention at all in the first place of course.

The fact is, WiFi chip firmware crashes, and in most cases the driver
is able to recover seamlessly. At least that is the case with most QCA
chipsets I work with. And the users or our ability to do anything
about it is minimal to none as we don't have access to firmware
source. It's too bad and I wish it weren't the case, but we have
embraced reality and most drivers have a recovery mechanism built in
for this case. In short, it's a non-event. I fear that elevating this
to a kernel taint will significantly increase "support" requests that
really are nothing but noise; similar to how the firmware load failure
messages (fail to load fw-2.bin, fail to load fw-1.bin, yay loaded
fw-0.bin) cause a lot of noise.

Not specifically opposed, but I wonder what it really accomplishes in
a world where the firmware crashing is pretty much a normal
occurrence.

If it goes in, I think that the drivers shouldn't trigger the taint if
they're able to recover normally. Only trigger on failure to come back
up.  In other words, the ideal place in the ath10k driver isn't where
you have proposed as at that point operation is normal and we're doing
a routine recovery.

- Steve





>   Luis
