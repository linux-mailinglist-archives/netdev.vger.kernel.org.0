Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B3730A00E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhBABhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhBABhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 20:37:19 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D5C061573;
        Sun, 31 Jan 2021 17:36:39 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id hs11so21798899ejc.1;
        Sun, 31 Jan 2021 17:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZLQhvQu3Vrgzif0cDFF6QzD5gziJnoMo6564Rccbcw=;
        b=Vh0/8tpaAEBtV3/9Fww8Swkfa3nIX9i5EMzizlsah3XG81u/Tgd7k2E52yy71n6ZVy
         7U4sZmzqgaiiCasMi09Mr9XdVBGcnjolTOSvuKxc0ySx+yuuni4MqnJhUSWsUWe0GCIw
         9TaCs1Xs6Lcr8Wp5fAvg2zKDe6rp8JVUR4r+5STNF5xIHGqBzSaI3j6M8fyniGe9y2xW
         TAfGkK+rhcpIa38O5+LYFYseHEnCfZ9iVUPXq43fIwnUYXHndieGJsRG6qYS2CmFpRjP
         E2yPH+2+9d/I+a0+e7Zs1IWTZRfJZpm86mXEUM41oShkYax8NQ7uB3xSsXtDf+7JGy9T
         niKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZLQhvQu3Vrgzif0cDFF6QzD5gziJnoMo6564Rccbcw=;
        b=nquTzZKqrOLk+v9Wxu7SeZEqDU6uAyxbcTeZshARZu86Qt4lninwlQwuTbRkYWNSLy
         zmc2qepnBi4/pyeGhOKvylDcbtwZYdXfmEHaMbUcARcdehqVG0rSXjhJ4koFoKHW4ycR
         C7M+e63asVUESehiFBpxE/5BEOUpFb5HNlcGjbphKCKrKBhBzPIyp8FZ3a7DhbdFT4nu
         /+Wvz7DA/pxl+J5LRYc1/EdqvbapKRQwrTH8xLzqf2XTyrfjt1lcFGgnM2jGMQZGwhma
         wj1hI5pCZ8lw1NFiTyBJ844MLfmI1YSDEEg8PoKleAQna1E3ViZlfCYFWCuAQKBLEFR/
         kvpQ==
X-Gm-Message-State: AOAM533VVsKhHEBNGsa6BwZafFyWudliSWE64UzOyK0iaCOeEroTNpz/
        0HWCcboz7a7pF9XtVKnNfvD4jtxYSTOiI4y+tc0=
X-Google-Smtp-Source: ABdhPJyWvXYNkM0oM2cAKfCvj5cau94BVNTLa1zvb4sVHfUE0c13tuGHkdLUZUDGrHLQsGRK2dyMs2CdWN+qMnL8UI8=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr3579665ejw.11.1612143397878;
 Sun, 31 Jan 2021 17:36:37 -0800 (PST)
MIME-Version: 1.0
References: <20210129202019.2099259-1-elder@linaro.org> <20210129202019.2099259-10-elder@linaro.org>
 <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
 <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org> <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
 <67f4aa5a-4a60-41e6-a049-0ff93fb87b66@linaro.org>
In-Reply-To: <67f4aa5a-4a60-41e6-a049-0ff93fb87b66@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Jan 2021 20:36:01 -0500
Message-ID: <CAF=yD-+ABnhRmcHq=1T7PVz8VUVjqC073bjTa89GUt1rA3KVUw@mail.gmail.com>
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

On Sun, Jan 31, 2021 at 10:32 AM Alex Elder <elder@linaro.org> wrote:
>
> On 1/31/21 8:52 AM, Willem de Bruijn wrote:
> > On Sat, Jan 30, 2021 at 11:29 PM Alex Elder <elder@linaro.org> wrote:
> >>
> >> On 1/30/21 9:25 AM, Willem de Bruijn wrote:
> >>> On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
> >>>>
> >>>> The channel stop and suspend paths both call __gsi_channel_stop(),
> >>>> which quiesces channel activity, disables NAPI, and (on other than
> >>>> SDM845) stops the channel.  Similarly, the start and resume paths
> >>>> share __gsi_channel_start(), which starts the channel and re-enables
> >>>> NAPI again.
> >>>>
> >>>> Disabling NAPI should be done when stopping a channel, but this
> >>>> should *not* be done when suspending.  It's not necessary in the
> >>>> suspend path anyway, because the stopped channel (or suspended
> >>>> endpoint on SDM845) will not cause interrupts to schedule NAPI,
> >>>> and gsi_channel_trans_quiesce() won't return until there are no
> >>>> more transactions to process in the NAPI polling loop.
> >>>
> >>> But why is it incorrect to do so?
> >>
> >> Maybe it's not; I also thought it was fine before, but...
> >>
> >> Someone at Qualcomm asked me why I thought NAPI needed
> >> to be disabled on suspend.  My response was basically
> >> that it was a lightweight operation, and it shouldn't
> >> really be a problem to do so.
> >>
> >> Then, when I posted two patches last month, Jakub's
> >> response told me he didn't understand why I was doing
> >> what I was doing, and I stepped back to reconsider
> >> the details of what was happening at suspend time.
> >>
> >> https://lore.kernel.org/netdev/20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> >>
> >> Four things were happening to suspend a channel:
> >> quiesce activity; disable interrupt; disable NAPI;
> >> and stop the channel.  It occurred to me that a
> >> stopped channel would not generate interrupts, so if
> >> the channel was stopped earlier there would be no need
> >> to disable the interrupt.  Similarly there would be
> >> (essentially) no need to disable NAPI once a channel
> >> was stopped.
> >>
> >> Underlying all of this is that I started chasing a
> >> hang that was occurring on suspend over a month ago.
> >> It was hard to reproduce (hundreds or thousands of
> >> suspend/resume cycles without hitting it), and one
> >> of the few times I actually hit the problem it was
> >> stuck in napi_disable(), apparently waiting for
> >> NAPI_STATE_SCHED to get cleared by napi_complete().
> >
> > This is important information.
> >
> > What exactly do you mean by hang?
>
> Yes it's important!  Unfortunately I was not able to
> gather details about the problem in all the cases where
> it occurred.  But in at least one case I *did* confirm
> it was in the situation described above.
>
> What I mean by "hang" is that the system simply stopped
> on its way down, and the IPA ->suspend callback never
> completed (stuck in napi_disable).  So I expect that
> the SCHED flag was never going to get cleared (because
> of a race, presumably).
>
> >> My best guess about how this could occur was if there
> >> were a race of some kind between the interrupt handler
> >> (scheduling NAPI) and the poll function (completing
> >> it).  I found a number of problems while looking
> >> at this, and in the past few weeks I've posted some
> >> fixes to improve things.  Still, even with some of
> >> these fixes in place we have seen a hang (but now
> >> even more rarely).
> >>
> >> So this grand rework of suspending/stopping channels
> >> is an attempt to resolve this hang on suspend.
> >
> > Do you have any data that this patchset resolves the issue, or is it
> > too hard to reproduce to say anything?
>
> The data I have is that I have been running for weeks
> with tens of thousands of iterations with this patch
> (and the rest of them) without any hang.  Unfortunately
> that doesn't guarantee anything.  I contemplated trying
> to "catch" the problem and report that it *would have*
> occurred had the fix not been in place, but I haven't
> tried that (in part because it might not be easy).
>
> So...  Too hard to reproduce, but I have evidence that
> my testing so far has never reproduced the hang.
>
> >> The channel is now stopped early, and once stopped,
> >> everything that completed prior to the channel being
> >> stopped is polled before considering the suspend
> >> function done.
> >
> > Does the call to gsi_channel_trans_quiesce before
> > gsi_channel_stop_retry leave a race where new transactions may occur
> > until state GSI_CHANNEL_STATE_STOPPED is reached? Asking without truly
> > knowing the details of this device.
>
> It should not.  For TX endpoints that have a net device, new
> requests will have been stopped earlier by netif_stop_queue()
> (in ipa_modem_suspend()).  For RX endpoints, receive buffers
> are replenished to the hardware, but we stop that earlier
> as well, in ipa_endpoint_suspend_one().  So the quiesce call
> is meant to figure out what the last submitted request was
> for an endpoint (channel), and then wait for that to complete.
>
> The "hang" occurs on an RX endpoint, and in particular it
> occurs on an endpoint that we *know* will be receiving a
> packet as part of the suspend process (when clearing the
> hardware pipeline).  I can go into that further but won't'
> unless asked.
>
> >> A stopped channel won't interrupt,
> >> so we don't bother disabling the completion interrupt,
> >> with no interrupts, NAPI won't be scheduled, so there's
> >> no need to disable NAPI either.
> >
> > That sounds plausible. But it doesn't explain why napi_disable "should
> > *not* be done when suspending" as the commit states.
> >
> > Arguably, leaving that won't have much effect either way, and is in
> > line with other drivers.
>
> Understood and agreed.  In fact, if the hang occurrs in
> napi_disable() when waiting for NAPI_STATE_SCHED to clear,
> it would occur in napi_synchronize() as well.

Agreed.

So you have an environment to test a patch in, it might be worthwhile
to test essentially the same logic reordering as in this patch set,
but while still disabling napi.

The disappearing race may be due to another change rather than
napi_disable vs napi_synchronize. A smaller, more targeted patch could
also be a net (instead of net-next) candidate.

> At this point
> it's more about the whole set of rework here, and keeping
> NAPI enabled during suspend seems a little cleaner.

I'm not sure. I haven't looked if there is a common behavior across
devices. That might be informative. igb, for one, releases all
resources.

> See my followup message, about Jakub's assertion that NAPI
> assumes the device will be *reset* when NAPI is disabled.
> (I'm not convinced NAPI assumes that, but that doesn't matter.)
> In any case, the IPA hardware does *not* reset channels when
> suspended.
>
> > Your previous patchset mentions "When stopping a channel, the IPA
> > driver currently disables NAPI before disabling the interrupt." That
> > would no longer be the case.
>
> I'm not sure which patch you're referring to (and I'm in
> a hurry at the moment).  But yes, with this patch we would
> only disable NAPI when "really" stopping the channel, not
> when suspending it.  And we'd similarly be no longer
> disabling the completion interrupt on suspend either.
>
> Thanks a lot, I appreciate the help and input on this.
>
>                                         -Alex
>
> >> The net result is simpler, and seems logical, and
> >> should preclude any possible race between the interrupt
> >> handler and poll function.  I'm trying to solve the
> >> hang problem analytically, because it takes *so* long
> >> to reproduce.
> >>
> >> I'm open to other suggestions.
> >>
> >>                                         -Alex
> >>
> >>>  From a quick look, virtio-net disables on both remove and freeze, for instance.
> >>>
> >>>> Instead, enable NAPI in gsi_channel_start(), when the completion
> >>>> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
> >>>> when finally disabling the interrupt.
> >>>>
> >>>> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
> >>>> NAPI polling is done before moving on.
> >>>>
> >>>> Signed-off-by: Alex Elder <elder@linaro.org>
> >>>> ---
> >>> =
> >>>> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
> >>>>          struct gsi_channel *channel = &gsi->channel[channel_id];
> >>>>          int ret;
> >>>>
> >>>> -       /* Enable the completion interrupt */
> >>>> +       /* Enable NAPI and the completion interrupt */
> >>>> +       napi_enable(&channel->napi);
> >>>>          gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
> >>>>
> >>>>          ret = __gsi_channel_start(channel, true);
> >>>> -       if (ret)
> >>>> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> >>>> +       if (!ret)
> >>>> +               return 0;
> >>>> +
> >>>> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> >>>> +       napi_disable(&channel->napi);
> >>>>
> >>>>          return ret;
> >>>>   }
> >>>
> >>> subjective, but easier to parse when the normal control flow is linear
> >>> and the error path takes a branch (or goto, if reused).
> >>>
> >>
>
