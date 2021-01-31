Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB4309D40
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhAaOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhAaOyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:54:09 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00347C061573;
        Sun, 31 Jan 2021 06:53:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n6so15912752edt.10;
        Sun, 31 Jan 2021 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ekq97JXpRKbr0pVUPDyspe2YXKZSN9e/mAHMgPJ6BB0=;
        b=FsMRkzZdH34OGlktVz9087fjiE9bZIe2ftpd0ikg7t046Y54KoaziWCPMwY7uW7t73
         zhBwWweWxzc26pDIzwCDh0ELJQEz5GmZkBSuepajCxCIFfpntxsEtif585lMYvuSiXl7
         yJKqQuGPhtt/q0cfX/LfvCx+YboMA7C5XeZqtziP+jvJ9PpWIMVB1dYBfAQewf4Hp2X0
         OtCluIFhyVSgQ1j5FHo6yoqa50MmJShEEMNpK97UFTvtEBqQf3WrdnU1D5R8SnD92ULg
         AmNtIoJVeAvMOD+7LpwlofMl284vSKZ/fmYMOXIrw936uD70SfYHrv9jVAdr4kooNPlF
         sqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ekq97JXpRKbr0pVUPDyspe2YXKZSN9e/mAHMgPJ6BB0=;
        b=q7m3cc7SG7cExllGp9THPFK/Lh3WS8DEGInJKMPtzJXagsKmwKafHiLsatLTPd3/r6
         9nzXCbvVCvfalJ17IDu+D2ADzIHPoHzxe6kaOUmtOwEfchxNpku8IWM+s+Vr8XWMlZKq
         7glzRqNdXYkBMxqkSFkGH7KX5xZFPOPK1Rh3Vg9+px2OWXBpQyK0KxVqIn5pCKaNsti6
         N8QtsKDEm9E6B6FF3i2DACEoNa5h0fP+aj2wJwiOwaPVhmGCYIjYoSUfNdMZ1AtujgzG
         eHuUXelV+Iq6Tq1KJ3/CoRQwytbQ5oxxelLY1gGNxNbNCJJwfoIwPygBQa3iEHyaSIzx
         9c8g==
X-Gm-Message-State: AOAM532czB62czim2dlyhAhCkkwSohJXWql7Bd8QSccm7R/Gc37uSTrL
        RucDUPGgchJFelPNhQOSHZgM+/gm/mezz+6FB4Q=
X-Google-Smtp-Source: ABdhPJwB7ztY25PMjU8kbFdQRjjRfBmZBF2KakgFpS9JAEtwC2zRy5S1/dzmFZ8Q5t1LbAyTl1mNi0Imnf/D+J/gv6k=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr14981855edv.254.1612104798686;
 Sun, 31 Jan 2021 06:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20210129202019.2099259-1-elder@linaro.org> <20210129202019.2099259-10-elder@linaro.org>
 <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com> <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
In-Reply-To: <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Jan 2021 09:52:41 -0500
Message-ID: <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
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

On Sat, Jan 30, 2021 at 11:29 PM Alex Elder <elder@linaro.org> wrote:
>
> On 1/30/21 9:25 AM, Willem de Bruijn wrote:
> > On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
> >>
> >> The channel stop and suspend paths both call __gsi_channel_stop(),
> >> which quiesces channel activity, disables NAPI, and (on other than
> >> SDM845) stops the channel.  Similarly, the start and resume paths
> >> share __gsi_channel_start(), which starts the channel and re-enables
> >> NAPI again.
> >>
> >> Disabling NAPI should be done when stopping a channel, but this
> >> should *not* be done when suspending.  It's not necessary in the
> >> suspend path anyway, because the stopped channel (or suspended
> >> endpoint on SDM845) will not cause interrupts to schedule NAPI,
> >> and gsi_channel_trans_quiesce() won't return until there are no
> >> more transactions to process in the NAPI polling loop.
> >
> > But why is it incorrect to do so?
>
> Maybe it's not; I also thought it was fine before, but...
>
> Someone at Qualcomm asked me why I thought NAPI needed
> to be disabled on suspend.  My response was basically
> that it was a lightweight operation, and it shouldn't
> really be a problem to do so.
>
> Then, when I posted two patches last month, Jakub's
> response told me he didn't understand why I was doing
> what I was doing, and I stepped back to reconsider
> the details of what was happening at suspend time.
>
> https://lore.kernel.org/netdev/20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
>
> Four things were happening to suspend a channel:
> quiesce activity; disable interrupt; disable NAPI;
> and stop the channel.  It occurred to me that a
> stopped channel would not generate interrupts, so if
> the channel was stopped earlier there would be no need
> to disable the interrupt.  Similarly there would be
> (essentially) no need to disable NAPI once a channel
> was stopped.
>
> Underlying all of this is that I started chasing a
> hang that was occurring on suspend over a month ago.
> It was hard to reproduce (hundreds or thousands of
> suspend/resume cycles without hitting it), and one
> of the few times I actually hit the problem it was
> stuck in napi_disable(), apparently waiting for
> NAPI_STATE_SCHED to get cleared by napi_complete().

This is important information.

What exactly do you mean by hang?

>
> My best guess about how this could occur was if there
> were a race of some kind between the interrupt handler
> (scheduling NAPI) and the poll function (completing
> it).  I found a number of problems while looking
> at this, and in the past few weeks I've posted some
> fixes to improve things.  Still, even with some of
> these fixes in place we have seen a hang (but now
> even more rarely).
>
> So this grand rework of suspending/stopping channels
> is an attempt to resolve this hang on suspend.

Do you have any data that this patchset resolves the issue, or is it
too hard to reproduce to say anything?

> The channel is now stopped early, and once stopped,
> everything that completed prior to the channel being
> stopped is polled before considering the suspend
> function done.

Does the call to gsi_channel_trans_quiesce before
gsi_channel_stop_retry leave a race where new transactions may occur
until state GSI_CHANNEL_STATE_STOPPED is reached? Asking without truly
knowing the details of this device.

> A stopped channel won't interrupt,
> so we don't bother disabling the completion interrupt,
> with no interrupts, NAPI won't be scheduled, so there's
> no need to disable NAPI either.

That sounds plausible. But it doesn't explain why napi_disable "should
*not* be done when suspending" as the commit states.

Arguably, leaving that won't have much effect either way, and is in
line with other drivers.

Your previous patchset mentions "When stopping a channel, the IPA
driver currently disables NAPI before disabling the interrupt." That
would no longer be the case.

> The net result is simpler, and seems logical, and
> should preclude any possible race between the interrupt
> handler and poll function.  I'm trying to solve the
> hang problem analytically, because it takes *so* long
> to reproduce.
>
> I'm open to other suggestions.
>
>                                         -Alex
>
> >  From a quick look, virtio-net disables on both remove and freeze, for instance.
> >
> >> Instead, enable NAPI in gsi_channel_start(), when the completion
> >> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
> >> when finally disabling the interrupt.
> >>
> >> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
> >> NAPI polling is done before moving on.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> > =
> >> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
> >>          struct gsi_channel *channel = &gsi->channel[channel_id];
> >>          int ret;
> >>
> >> -       /* Enable the completion interrupt */
> >> +       /* Enable NAPI and the completion interrupt */
> >> +       napi_enable(&channel->napi);
> >>          gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
> >>
> >>          ret = __gsi_channel_start(channel, true);
> >> -       if (ret)
> >> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> >> +       if (!ret)
> >> +               return 0;
> >> +
> >> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> >> +       napi_disable(&channel->napi);
> >>
> >>          return ret;
> >>   }
> >
> > subjective, but easier to parse when the normal control flow is linear
> > and the error path takes a branch (or goto, if reused).
> >
>
