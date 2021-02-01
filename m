Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C430AA35
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhBAOsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhBAOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:48:21 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B4EC061573;
        Mon,  1 Feb 2021 06:47:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id l9so24799139ejx.3;
        Mon, 01 Feb 2021 06:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWJ27oH+ywvoDHwR7zZy8Kz0h+8K+IT2Z5aTmsXDaM4=;
        b=N904BHLYYBJmo6z2B0YLjG+azfIZrlXuEpAz6sv3VBStKD3MXwHuuj7DxnFJMYgfHV
         o9RCX7AbrbXhoRfEx9Jz/Nui5u2qWr6LdO8HxU/j0hTMluFYDVxaZD0qJwwnIkSIgEkW
         kio6M2WR0BykTsR+epi4g2pURFie5bAB6sRWLWDTFT85cwIO/Egy+8/KGw6FPRjrcL8D
         WyU0dDSPBf3jhsG+j7lks4uEzZPVjCkk1l7uP9L/bCSbKDll6wL0lkG/OAnkdsnttq4J
         n58/COVWIy+2d0/x1jlQORQZ0twqxUi5uLqMwq8as0Rg9U6BvK5OXnpJ4hsJIsB5Bkak
         fa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWJ27oH+ywvoDHwR7zZy8Kz0h+8K+IT2Z5aTmsXDaM4=;
        b=CfTHFG0E5pVwV1oNuTRXP5PktKNYic2M2unPiu5sdSdQyovrAXVCoXvEgRAD1rEy5m
         9bEgyRZIO8Wln7f/nQowp/62E3tMUBElEaYjtydBIn+j3xHJSn46kqzLjxdRRFD+ItuT
         qhnB7yYTuahizTe8va4W4fd38pv6kI9dTOeHZiqpEXlbVngwLraygcSAMgo0kzczyMEs
         8+OdjC/h1ApcS/xmR0NcttBpKbDA+9OY2k7E70ebAGJ/m36vUCdoBixFsDDUkUO3Za3T
         9xDoaRhAjrAMu/ZmM5CryiBOYYZQ1sCvtFg+FJ66Mz3xtHhfFmOHPLmwfpFZ5YEWYJZS
         GBkQ==
X-Gm-Message-State: AOAM532AKrEjD4Vwctt8a+WYFzLpHIXIsI5JyhY5D3XzOCnHp6iLgvqF
        bN5NAWqrbHQBIsB9z/6tccwifBVsMW4NMGgMsSrnVuBO+wQ=
X-Google-Smtp-Source: ABdhPJzCpt8R76QmbBOR+RJdI8d9qEneCEJ7n2M7uKg7B4J9KhGoGp3p5sP6SwhPn/qAJrbgU6XGHaHceSlVZb3FXUk=
X-Received: by 2002:a17:907:35d1:: with SMTP id ap17mr10233931ejc.79.1612190859979;
 Mon, 01 Feb 2021 06:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20210129202019.2099259-1-elder@linaro.org> <20210129202019.2099259-10-elder@linaro.org>
 <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
 <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org> <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
 <67f4aa5a-4a60-41e6-a049-0ff93fb87b66@linaro.org> <CAF=yD-+ABnhRmcHq=1T7PVz8VUVjqC073bjTa89GUt1rA3KVUw@mail.gmail.com>
 <a1b12c17-5d65-ce29-3d4f-e09de4fdcf3f@linaro.org>
In-Reply-To: <a1b12c17-5d65-ce29-3d4f-e09de4fdcf3f@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 09:47:03 -0500
Message-ID: <CAF=yD-JSpz5OAp3DtW+1K_w1NZsLLxbrviZRQ5j7=qyJFpZAQg@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 9:35 AM Alex Elder <elder@linaro.org> wrote:
>
> On 1/31/21 7:36 PM, Willem de Bruijn wrote:
> > On Sun, Jan 31, 2021 at 10:32 AM Alex Elder <elder@linaro.org> wrote:
> >>
> >> On 1/31/21 8:52 AM, Willem de Bruijn wrote:
> >>> On Sat, Jan 30, 2021 at 11:29 PM Alex Elder <elder@linaro.org> wrote:
> >>>>
> >>>> On 1/30/21 9:25 AM, Willem de Bruijn wrote:
> >>>>> On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
> >>>>>>
> >>>>>> The channel stop and suspend paths both call __gsi_channel_stop(),
> >>>>>> which quiesces channel activity, disables NAPI, and (on other than
> >>>>>> SDM845) stops the channel.  Similarly, the start and resume paths
> >>>>>> share __gsi_channel_start(), which starts the channel and re-enables
> >>>>>> NAPI again.
> >>>>>>
> >>>>>> Disabling NAPI should be done when stopping a channel, but this
> >>>>>> should *not* be done when suspending.  It's not necessary in the
> >>>>>> suspend path anyway, because the stopped channel (or suspended
> >>>>>> endpoint on SDM845) will not cause interrupts to schedule NAPI,
> >>>>>> and gsi_channel_trans_quiesce() won't return until there are no
> >>>>>> more transactions to process in the NAPI polling loop.
> >>>>>
> >>>>> But why is it incorrect to do so?
> >>>>
> >>>> Maybe it's not; I also thought it was fine before, but...
>
> . . .
>
> >> The "hang" occurs on an RX endpoint, and in particular it
> >> occurs on an endpoint that we *know* will be receiving a
> >> packet as part of the suspend process (when clearing the
> >> hardware pipeline).  I can go into that further but won't'
> >> unless asked.
> >>
> >>>> A stopped channel won't interrupt,
> >>>> so we don't bother disabling the completion interrupt,
> >>>> with no interrupts, NAPI won't be scheduled, so there's
> >>>> no need to disable NAPI either.
> >>>
> >>> That sounds plausible. But it doesn't explain why napi_disable "should
> >>> *not* be done when suspending" as the commit states.
> >>>
> >>> Arguably, leaving that won't have much effect either way, and is in
> >>> line with other drivers.
> >>
> >> Understood and agreed.  In fact, if the hang occurrs in
> >> napi_disable() when waiting for NAPI_STATE_SCHED to clear,
> >> it would occur in napi_synchronize() as well.
> >
> > Agreed.
> >
> > So you have an environment to test a patch in, it might be worthwhile
> > to test essentially the same logic reordering as in this patch set,
> > but while still disabling napi.
>
> What is the purpose of this test?  Just to guarantee
> that the NAPI hang goes away?  Because you agree that
> the napi_schedule() call would *also* hang if that
> problem exists, right?
>
> Anyway, what you're suggesting is to simply test with
> this last patch removed.  I can do that but I really
> don't expect it to change anything.  I will start that
> test later today when I'm turning my attention to
> something else for a while.
>
> > The disappearing race may be due to another change rather than
> > napi_disable vs napi_synchronize. A smaller, more targeted patch could
> > also be a net (instead of net-next) candidate.
>
> I am certain it is.
>
> I can tell you that we have seen a hang (after I think 2500+
> suspend/resume cycles) with the IPA code that is currently
> upstream.
>
> But with this latest series of 9, there is no hang after
> 10,000+ cycles.  That gives me a bisect window, but I really
> don't want to go through a full bisect of even those 9,
> because it's 4 tests, each of which takes days to complete.
>
> Looking at the 9 patches, I think this one is the most
> likely culprit:
>    net: ipa: disable IEOB interrupt after channel stop
>
> I think the race involves the I/O completion handler
> interacting with NAPI in an unwanted way, but I have
> not come up with the exact sequence that would lead
> to getting stuck in napi_disable().
>
> Here are some possible events that could occur on an
> RX channel in *some* order, prior to that patch.  And
> in the order I show there's at least a problem of a
> receive not being processed immediately.
>
>                 . . . (suspend initiated)
>
>         replenish_stop()
>         quiesce()
>                         IRQ fires (receive ready)
>         napi_disable()
>                         napi_schedule() (ignored)
>         irq_disable()
>                         IRQ condition; pending
>         channel_stop()
>
>                 . . . (resume triggered)
>
>         channel_start()
>         irq_enable()
>                         pending IRQ fires
>                         napi_schedule() (ignored)
>         napi_enable()
>
>                 . . . (suspend initiated)
>
> >> At this point
> >> it's more about the whole set of rework here, and keeping
> >> NAPI enabled during suspend seems a little cleaner.
> >
> > I'm not sure. I haven't looked if there is a common behavior across
> > devices. That might be informative. igb, for one, releases all
> > resources.
>
> I tried to do a survey of that too and did not see a
> consistent pattern.  I didn't look *that* hard because
> doing so would be more involved than I wanted to get.

Okay. If there is no consistent pattern, either approach works.

I'm fine with this patchset as is.

> So in summary:
> - I'm putting together version 2 of this series now
> - Testing this past week seems to show that this series
>    makes the hang in napi_disable() (or synchronize)
>    go away.
> - I think the most likely patch in this series that
>    fixes the problem is the IRQ ordering one I mention
>    above, but right now I can't cite a specific sequence
>    of events that would prove it.
> - I will begin some long testing later today without
>    this last patch applied
>      --> But I think testing without the IRQ ordering
>         patch would be more promising, and I'd like
>         to hear your opinion on that

Either test depends on whether you find it worthwhile to more
specifically identify the root cause. If not, no need to run the tests
on my behalf. I understand that these are time consuming.

>
> Thanks again for your input and help on this.
>
>                                         -Alex
>
> . . .
