Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B258C21946F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgGHXkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgGHXkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:40:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB1AC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:40:04 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b185so167074qkg.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4PTp29U09bBo7Lu4mXNnRRUq7S8vPBuFkBdJI6sHus=;
        b=OF77syHXcChzkEUs9+BXgXSMwR+t9jCMThFrfbzfZ8mPDG8ZkTNSRve3ok6gtHomro
         es/mzdU4UysFHM2uMMrlumrIe1BwnlfTylxQuLiPUgxYNS4EtuzocS02fWNwaDF2pJrR
         N0GaAZ11AdR/x8QVwjRq62IkDCPufE+hNzo7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4PTp29U09bBo7Lu4mXNnRRUq7S8vPBuFkBdJI6sHus=;
        b=IKqWgPgzcLQ30qwGC+sADQgDWTnr8eiNlaUd2+lX9JU49V7ig6hAxGG5FTiZtZisQg
         4Jn3MKcjlEat+yf0VLMZCH2a+zSnFjcGK2bdtlvnCLIuoDPwlvIbCf2R6BanbGUWNcCk
         1ayysD7PwZYcpfbhw4h1v9I1oTwKvtAiau+v0LuLm5HiX6CqRkWVMacr3nG3Htbjkgde
         g4gdcQ3PQ2D2rEylykZ4PlkQeGQLM/fas7l6qo2+UPoNEI19860qsOaW5C0QwtQLipIx
         x0UFq6O21FzwQ/gP+0Ds6I40BQJh4iAKSmpABwUM6EmUwFGfRJmRpwGZLkO9VaYHAYd2
         twIQ==
X-Gm-Message-State: AOAM533iFCLWfOZT1n049dZb5IJX/vbFtfhkb9g+4Z0Iz7q5VP0tnzzu
        gH6T0g9WHUS8lIcEb2gnivtjP8qqmPg=
X-Google-Smtp-Source: ABdhPJww4Aln0RIrmJ1uUnIe8xj7Fl6L1yNLRV/7hej1PF/GkbV7S2aSN2HgfodbhjfxsvIox6dL3w==
X-Received: by 2002:a37:a347:: with SMTP id m68mr42338282qke.244.1594251602667;
        Wed, 08 Jul 2020 16:40:02 -0700 (PDT)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com. [209.85.222.179])
        by smtp.gmail.com with ESMTPSA id j45sm1301179qtk.31.2020.07.08.16.39.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 16:40:00 -0700 (PDT)
Received: by mail-qk1-f179.google.com with SMTP id b185so166927qkg.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:39:59 -0700 (PDT)
X-Received: by 2002:a37:9384:: with SMTP id v126mr58569207qkd.279.1594251599031;
 Wed, 08 Jul 2020 16:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
 <CA+ASDXMXtwdV4BNL1GSj8DY-3z8-dZ=1hP8Xv_R-AjKvJs0NMw@mail.gmail.com> <CAD=FV=WU2dUFtG4W6o574DRN9VV+u_B5-ThqV3BogjztBibyLQ@mail.gmail.com>
In-Reply-To: <CAD=FV=WU2dUFtG4W6o574DRN9VV+u_B5-ThqV3BogjztBibyLQ@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 8 Jul 2020 16:39:47 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOwFnCcMC9g11FSVLvj2nepArJyihGvx3SU-XqySoJruw@mail.gmail.com>
Message-ID: <CA+ASDXOwFnCcMC9g11FSVLvj2nepArJyihGvx3SU-XqySoJruw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Keep track of which interrupts fired, don't poll them
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Abhishek Kumar <kuabhs@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 4:14 PM Doug Anderson <dianders@chromium.org> wrote:
> On Wed, Jul 8, 2020 at 4:03 PM Brian Norris <briannorris@chromium.org> wrote:
> > If I'm reading correctly, you're removing the only remaining use of
> > 'per_ce_irq'. Should we kill the field entirely?
>
> Ah, you are indeed correct!  I hadn't noticed that.  Unless I hear
> otherwise, I'll send a v2 tomorrow that removes the field entirely.

A healthy middle ground might put that in a patch 2, so it's easily
dropped if desired. *shrug*

> > Or perhaps we should
> > leave some kind of WARN_ON() (BUG_ON()?) if this function is called
> > erroneously with per_ce_irq==true? But I suppose this driver is full
> > of landmines if the CE API is used incorrectly.
>
> Yeah, I originally had a WARN_ON() here and then took it out because
> it seemed like extra overhead and, as you said, someone writing the
> code has to know how the API works already I think.  ...but I'll add
> it back in if people want.

I believe WARN_ON() and friends have a built-in unlikely(), so it
shouldn't have much overhead. But I don't really mind either way.

> > Do you need to clear this map if the interface goes down or if there's
> > a firmware crash? Right now, I don't think there's a guarantee that
> > we'll run through a NAPI poll in those cases, which is the only place
> > you clear the map, and if the hardware/firmware has been reset, the
> > state map is probably not valid.
>
> Seems like a good idea.  Is the right place at the start of
> ath10k_snoc_hif_start()?

Either there or in .power_down()/.power_up(). I think either would be
equally correct, but I'm not entirely sure if the semantic difference
is meaningful for this.

Brian
