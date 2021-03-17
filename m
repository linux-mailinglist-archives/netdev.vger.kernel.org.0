Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74433F42B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 16:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhCQOuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhCQOuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:50:24 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AF8C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:50:24 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id u75so40744220ybi.10
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1xLRRGeuVbUwEJTO18nt3rhlBDcVceINxnZrIEXeRs=;
        b=iv8skcCUUbUmsCUJ+spY4UDhJp3CJqKCnyhgD19TMlLTLUSuxe2ps25NyBqEude3TZ
         BeLmT6GGBmt5FjIVn4B+5+G5oyU8i6o9CSLxfb5SPFYd7h5F5m6PawdeHlz938pfH7ev
         qt5p6+vfjsoMkEaVjEBWf7p8Zqga1vxPg8FMkgWxHhwwB2y3wVhqCfJdxhZukpsJv7gV
         AVnPTP5IK943fZGLrDnTJWehzXKpSi7HUyiMLTrVU8eC4uO0hB2FuTaAVol2yezd7A0Y
         UHw+DATPMGWPSB2hwybIQvgtfd0Abaw9zKToaPk5M+n/66JOVbiYSBfZxovseYkwLWr9
         FAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1xLRRGeuVbUwEJTO18nt3rhlBDcVceINxnZrIEXeRs=;
        b=i5W7p0sq0tHhi8j1St/I+HlfWFNQqdttbWtTE2XnMB/cOmDRNyhunWcRd9t/a5KEZf
         8Om+R6k5gRmENmYeusmWJSgHgJdxrP6WTiigoc+w18uPPgTmtsT1nySVsS4PE0jidyY5
         0MoHQ0Eu1SOHwaJNyP/+uQDHnkfLoL7QwP+d8c3zE2BycBK08TMfZszjz8RIkdpgwZws
         7LS5EnI8sw+1f97/qfSQYaLYSne03a7g98pMBGvW49QfrahDlWJaBkV0oLKJD71AOo7K
         kfT6iE3WXNnQVksMeU9962dLufWJFG/fMR3H56cvGyQJ7Y58acaE6Yzh2FlBUXlwRODY
         iAEg==
X-Gm-Message-State: AOAM5317Z1nJZ43YW3tDxb0Ijaz1BX0y9VSSLrrU35f0v5s8/gQNeP7F
        U7CFRpsMuPB7ErfLLv153ZfD48Yy3d/ZRfB+1nF8kqtBphrJdg==
X-Google-Smtp-Source: ABdhPJyzaN4GhmMr6Q/ty6K2vMtU4Sg45xYptaOkB/aujpohyla7oR3icCuw/ODgxgIqTKY+0fhdwhnhePojNgnzn+k=
X-Received: by 2002:a25:850b:: with SMTP id w11mr3601934ybk.518.1615992623275;
 Wed, 17 Mar 2021 07:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-3-bigeasy@linutronix.de> <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
 <20191127093521.6achiubslhv7u46c@linutronix.de> <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
 <CANn89i+Aje5j2iJDoq9FCU966kxC-gaD=ObxwVL49VC9L85_vA@mail.gmail.com>
 <20191127173719.q3hrdthuvkt2h2ul@linutronix.de> <20200416135938.jiglv4ctjayg5qmg@linutronix.de>
 <871rcdzx8w.fsf@nanos.tec.linutronix.de>
In-Reply-To: <871rcdzx8w.fsf@nanos.tec.linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Mar 2021 15:50:11 +0100
Message-ID: <CANn89iKg5E1EDwHs1d1ppBbAxix+C8bbti4W-avuG1Yqe26aBQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in softirq
 context with `threadirqs'
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 3:10 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Thu, Apr 16 2020 at 15:59, Sebastian Andrzej Siewior wrote:
> > any comments from the timer department?
>
> Yes.
>
> > On 2019-11-27 18:37:19 [+0100], To Eric Dumazet wrote:
> >> On 2019-11-27 09:11:40 [-0800], Eric Dumazet wrote:
> >> > Resent in non HTML mode :/
> >> don't worry, mutt handles both :)
> >>
> >> > Long story short, why hrtimer are not by default using threaded mode
> >> > in threadirqs mode ?
> >>
> >> Because it is only documented to thread only interrupts. Not sure if we
> >> want change this.
> >> In RT we expire most of the hrtimers in softirq context for other
> >> reasons. A subset of them still expire in hardirq context.
> >>
> >> > Idea of having some (but not all of them) hard irq handlers' now being
> >> > run from BH mode,
> >> > is rather scary.
> >>
> >> As I explained in my previous email: All IRQ-handlers fire in
> >> threaded-mode if enabled. Only the hrtimer is not affected by this
> >> change.
> >>
> >> > Also, hrtimers got the SOFT thing only in 4.16, while the GRO patch
> >> > went in linux-3.19
> >> >
> >> > What would be the plan for stable trees ?
> >> No idea yet. We could let __napi_schedule_irqoff() behave like
> >> __napi_schedule().
>
> It's not really a timer departement problem. It's an interrupt problem.
>
> With force threaded interrupts we don't call the handler with interrupts
> disabled. What sounded a good idea long ago, is actually bad.
>
> See https://lore.kernel.org/r/87eegdzzez.fsf@nanos.tec.linutronix.de
>
> Any leftover issues on a RT kernel are a different story, but for !RT
> this is the proper fix.
>
> I'll spin up a proper patch and tag it for stable...

Your patch looks much better indeed, thanks !
