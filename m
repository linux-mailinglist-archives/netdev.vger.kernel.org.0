Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F9A2177AC
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGGTOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgGGTOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:14:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34798C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:14:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k23so44321829iom.10
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 12:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWTFkU+asopeVMil6XRFdv9T205H+J4pMM3XkOPrkZ0=;
        b=ixvBTl2Ehpjo7+xG/8IVyw2nYmcrU3SL2zeK261Sc7n9bPhC2MeA1Srcyy61Haznze
         o1PivixfAK89i3VdtZmwjyURBL73yjkVBdp/BGAZs4DdWAwcKa8LduYGSADiptH4LzwP
         vYjKrHVbXi1fgoUjuvSw7a4rgza9l+l05meO2DttkVJa+DspJ6A/QgKUqGMNiSZlL8g3
         Y0c9qyY7wvsODrYBjimkkUr0fVVhVl43xgwvSzanrHdk2yMt+0H61031CF/jrYLdjx+Y
         KXHadyysXP4D8Dn3YoCio7kdKh4nX9b7rbJADbNCSYHvXUA70KUHtPnli7iPwgjgCrhe
         NwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWTFkU+asopeVMil6XRFdv9T205H+J4pMM3XkOPrkZ0=;
        b=XA+qU15ojfPoEDtEDc4lAFpunaqS+J8dC1aYL6J7VH3tl4qNIMK5RApKkeMIr/4NDe
         BUtX84Tv6KpU9ktxYGMQeJ/I9tY2QW8590c2SooBhq048BZdZUIybQjuTm/VEr7jiPhS
         gupj4VBW27gJpEDpDd33OXu8wVpADWpfis5hD4DG3Ppv2VZBFiZIVfuMp6TZEnyI3hf+
         QZGPLUAVn8U8qt3HCBnJ123pyyoIeBc7RrCbfq6YAwvt2dh6MQKyWRacXiCnpMwQSR+H
         NCbWnsNiaV0KZui29Fbt+Bgv0r9B+9A+uCCv4rzpFnPXTeenfD1BAz1FSrUUVGVlyRHa
         NgUQ==
X-Gm-Message-State: AOAM533PCWaGNmH3DEkePDDY77sx4uFnZJD1plWEMk1pxMqRs2++K44+
        +l2IlKKqmwH/YlU8AllAo3BINJ/jnbx6j3rSHrg=
X-Google-Smtp-Source: ABdhPJzlnSRsPhUj1HhAeasuebwpLalHH04G5MUHPmiua/309L5Uwx/Gn7BOIEjBE/FNvvJH9sdgLUeHxuknndvFI44=
X-Received: by 2002:a05:6602:2f0a:: with SMTP id q10mr31824817iow.134.1594149245125;
 Tue, 07 Jul 2020 12:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
 <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com>
In-Reply-To: <87a70bic3n.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jul 2020 12:13:54 -0700
Message-ID: <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 8:22 AM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> > On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
> >> The function tcf_qevent_handle() should be invoked when qdisc hits the
> >> "interesting event" corresponding to a block. This function releases root
> >> lock for the duration of executing the attached filters, to allow packets
> >> generated through user actions (notably mirred) to be reinserted to the
> >> same qdisc tree.
> >
> > Are you sure releasing the root lock in the middle of an enqueue operation
> > is a good idea? I mean, it seems racy with qdisc change or reset path,
> > for example, __red_change() could update some RED parameters
> > immediately after you release the root lock.
>
> So I had mulled over this for a while. If packets are enqueued or
> dequeued while the lock is released, maybe the packet under
> consideration should have been hard_marked instead of prob_marked, or
> vice versa. (I can't really go to not marked at all, because the fact
> that we ran the qevent is a very observable commitment to put the packet
> in the queue with marking.) I figured that is not such a big deal.
>
> Regarding a configuration change, for a brief period after the change, a
> few not-yet-pushed packets could have been enqueued with ECN marking
> even as I e.g. disabled ECN. This does not seem like a big deal either,
> these are transient effects.

Hmm, let's see:

1. red_enqueue() caches a pointer to child qdisc, child = q->qdisc
2. root lock is released by tcf_qevent_handle().
3. __red_change() acquires the root lock and then changes child
qdisc with a new one
4. The old child qdisc is put by qdisc_put()
5. tcf_qevent_handle() acquires the root lock again, and still uses
the cached but now freed old child qdisc.

Isn't this a problem?

Even if it really is not, why do we make tcf_qevent_handle() callers'
life so hard? They have to be very careful with race conditions like this.

Thanks.
