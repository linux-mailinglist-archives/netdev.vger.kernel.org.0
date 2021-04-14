Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301135F9F1
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350677AbhDNRcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350666AbhDNRcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 13:32:07 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8BCC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:31:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id p6so13939609wrn.9
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZrbNx718XhCTSNtLacg/vXHJaXZNWB2VB5fv4au4PI=;
        b=TLZyayIadq0js6ks0XxC6Cq/VDWN7iM93MZH9xlasSifPA8MJY64JQd6JpcoYzzITC
         G+43/+Rp+Ylm2ferbIXr/1vftILWYH0bh1MEfShUqA/0dhiOeEHAqHvo/6H4ZZMv30AG
         qMPA8VTtU7K6GFXXmYtaTVJEmcoS3M5f7NmB5Jr80ym7NcxqbWbFWl0CN/QFSpDuoPI2
         TSgNioCZOLH1/KwrRKvFgqGb9+WtNjx1qTdzORjdR/aQnhsIkEOP8GhW3k4eXKmURDpk
         5sDFWCoMGz9rUuWWtcuzwsE3XrzmBrMlTR/0kZay4vXrI7PHLQK+J8lQsBL6Z2I1cReP
         3+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZrbNx718XhCTSNtLacg/vXHJaXZNWB2VB5fv4au4PI=;
        b=HJJsv0lZjDX589hTJVfPmaj+zOm1LJdeHFQ01Ol9goIC6GTcuJX4phM/Cnf+5Mfu3A
         5V5vOfEHIBqdMDGKQvjZQrboBky4uXhB6B8Z/iJwttMlSKqyb+sRjxgy+TkcuSXcZyrd
         fdPdyq+B/A8EK/FmtF/irYNeoub0IAQcoW58lez95f4yJ3xrKx57Z+xOS/h015XFYjaZ
         OjfnhtK5KnypNyZmziTXR0MsDrM81Fu1Lh8Lxi6XRN3CQQLvsrIpYQqCD7dHsmy+QjO8
         ZNmCOc9ARlWqZmwAYCHH/6xQ/FWM/lW/HWTRK+Nt1pZsXbtbCTPy+4/FH9pc3Aox2iP6
         6lJg==
X-Gm-Message-State: AOAM533WaRFuO7e8HCz5Mjd84KaTgUmkusZF3jZcUd/QLzO/33Cz7Lyp
        m+kDXthSIsDjHTOixKfHMbUuM30vByYf8wUS5eo=
X-Google-Smtp-Source: ABdhPJyuVPZdsb4HRCEakKXM7hdofnwLs5ZZzWw6HUEK8zhOJ7dZxoo0mgzp95GQ++Db8uJCbNPmq3YaXkkdIJHNyEo=
X-Received: by 2002:adf:cf09:: with SMTP id o9mr14737894wrj.366.1618421504111;
 Wed, 14 Apr 2021 10:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210414080845.11426-1-lijunp213@gmail.com> <c72fd322-5181-16d6-5992-0fd71a083c31@huawei.com>
In-Reply-To: <c72fd322-5181-16d6-5992-0fd71a083c31@huawei.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 14 Apr 2021 12:31:32 -0500
Message-ID: <CAOhMmr7-GOQuF7TRQ28c9QC=ccLSCRk-TztxJTGYe-ZE_Afdpg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: core: make napi_disable more robust
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:45 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/4/14 16:08, Lijun Pan wrote:
> > There are chances that napi_disable can be called twice by NIC driver.
> > This could generate deadlock. For example,
> > the first napi_disable will spin until NAPI_STATE_SCHED is cleared
> > by napi_complete_done, then set it again.
> > When napi_disable is called the second time, it will loop infinitely
> > because no dev->poll will be running to clear NAPI_STATE_SCHED.
> >
> > Though it is driver writer's responsibility to make sure it being
> > called only once, making napi_disable more robust does not hurt, not
> > to say it can prevent a buggy driver from crashing a system.
> > So, we check the napi state bit to make sure that if napi is already
> > disabled, we exit the call early enough to avoid spinning infinitely.
> >
> > Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
> > Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> > ---
> > v2: justify that this patch makes napi_disable more robust.
> >
> >  net/core/dev.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1f79b9aa9a3f..fa0aa212b7bb 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6830,6 +6830,24 @@ EXPORT_SYMBOL(netif_napi_add);
> >  void napi_disable(struct napi_struct *n)
> >  {
> >       might_sleep();
> > +
> > +     /* make sure napi_disable() runs only once,
> > +      * When napi is disabled, the state bits are like:
> > +      * NAPI_STATE_SCHED (set by previous napi_disable)
> > +      * NAPI_STATE_NPSVC (set by previous napi_disable)
> > +      * NAPI_STATE_DISABLE (cleared by previous napi_disable)
> > +      * NAPI_STATE_PREFER_BUSY_POLL (cleared by previous napi_complete_done)
> > +      * NAPI_STATE_MISSED (cleared by previous napi_complete_done)
> > +      */
> > +
> > +     if (napi_disable_pending(n))
> > +             return;
> > +     if (test_bit(NAPI_STATE_SCHED, &n->state) &&
> > +         test_bit(NAPI_STATE_NPSVC, &n->state) &&
> > +         !test_bit(NAPI_STATE_MISSED, &n->state) &&
> > +         !test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state))
> > +             return;
>
> The NAPI_STATE_DISABLE is cleared at the end of napi_disable(),
> and if a buggy driver/hw triggers a interrupt and driver calls
> napi_schedule_irqoff(), which may set NAPI_STATE_MISSED
> if NAPI_STATE_SCHED is set(in napi_schedule_prep()), the above
> checking does not seem to handle it?

What I described in the commit message is the napi_disable() being
called from the same instance, same cpu. e.g.,
funcA {
    napi_disable();
    ...
    funcB{
        if (blah)
            napi_disable();
            ...
    }
    funcC;
}

The scenario you mentioned above seems to have napi already enabled
and scheduled, such that napi_schedule_prep() would set NAPI_STATE_MISSED.
The two scenarios are different per my understanding. Is there a way
that your scenario will finally call into my scenario?
Let me know if I understand you correctly.

Maybe testing NAPI_STATE_MISSED bit is not needed
because this bit is not that reliable.

Lijun
