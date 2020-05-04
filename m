Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71D21C431C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgEDRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:42:39 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ADEC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:42:38 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m18so9617931otq.9
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/l5qrxE7+cTNEDOZX9ZdLxdBX4Uk+keHT60XXHnljnU=;
        b=FbRoOJOISSJRfdYsbqL66Ok+Q0nbcKW+Jz80I+hC4k/opskpddS15rfgZJvKnz2YcR
         MSJTEGpbsz4Q8AhpXzXFoo74LdgQNDjtF59m7DyJ5JbiKGBiucEdeWVDijzxOjB+OOXI
         LTyLrLMotJjz+ormqjFk4eLm1Zq0lwI2xuiRlfgV2Gkgb+zZSUFD6ODGe8dn2NkH30AI
         nbqR0m5SoY64tVfGTiR7rIB8K6B6TG9tsPGhh213x/kzBbU7ry8piPPKXuMxXmYG0n8z
         QviFMJaE6eLiqyfLnJLX3x277cSKy0You5VB/9rBnFR6bfnUZdzixhHJLsrs3o/AhZxM
         EZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/l5qrxE7+cTNEDOZX9ZdLxdBX4Uk+keHT60XXHnljnU=;
        b=Noj+bPCAJJGlJSl8961XeYbkEig5dP30NcpHU7553Radfbv4EemsIQpjn4FJPe/jlk
         aCMes6OfBSzz6kX/1fkD2gFYgC4MjHhhGWUYNQ81oaiU3MWD/moLOjrHN1PcTP0zZv9N
         qXFPAaiu4JWNG1nOwk1vOiZM+FYCyM5q9BuEp8KTk0vn/bIjr5ffppHl9G+K4Y27urWZ
         e2K75pFRoU/SYFv2rSLla4Ay15A4Upi7xTSTRCj3kRXzCYT9eWSguFSgDfhlce3nZR+r
         kS512Be3M7C3tgY1pxaqcs8hLNNeShdPGoqYnxdlE3NMgcDLE7v7Lculg6nhMTBnJQYO
         3TWQ==
X-Gm-Message-State: AGi0PuZCcTy1w0jgKuhKW5KOj9AzPdnztrWZUFG8PvKN7+nGAHbOTnXZ
        qDTduGXbhArMqsm6V7PvsjlI+AFevgijavlfKXKWuBev
X-Google-Smtp-Source: APiQypIz3aZxaaO+WTdIbePhlhX3RqyLaIQ+kx9fUagVIHBWZMCzTLojz8GgDUqG0mxG3RGu6GGsgYvlB7KTqv7hmCE=
X-Received: by 2002:a05:6830:1409:: with SMTP id v9mr743921otp.189.1588614158268;
 Mon, 04 May 2020 10:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
 <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com> <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
 <CAM_iQpWi9MA5DEk7933aah3yeOQ+=bHO8H2-xpqTtcXn0k=+0Q@mail.gmail.com>
 <66d03368-9b8e-b953-a3a5-1f61b71e6307@mojatatu.com> <08e34ca6-3a9d-4245-317f-ae17b60e3666@mojatatu.com>
In-Reply-To: <08e34ca6-3a9d-4245-317f-ae17b60e3666@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 4 May 2020 10:42:26 -0700
Message-ID: <CAM_iQpW4QTo9goSh4GCzH4SAWCGc_nkY0u_+iCO-bzw5AVPg3g@mail.gmail.com>
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 5:48 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-05-03 8:02 a.m., Jamal Hadi Salim wrote:
> > On 2020-05-02 10:28 p.m., Cong Wang wrote:
> >> On Sat, May 2, 2020 at 2:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >>>
> >>> On 2020-05-02 4:48 a.m., Jamal Hadi Salim wrote:
> >
> > [..]
> >>>> Note:
> >>>> tc filter show dev dummy0 root
> >>>> should not show that filter. OTOH,
> >>>> tc filter show dev dummy0 parent ffff:
> >>>> should.
> >>
> >> Hmm, but we use TC_H_MAJ(tcm->tcm_parent) to do the
> >> lookup, 'root' (ffff:ffff) has the same MAJ with ingress
> >> (ffff:0000).
> >>
> >
> > I have some long analysis and theory below.
> >
> >> And qdisc_lookup() started to search for ingress since 2008,
> >> commit 8123b421e8ed944671d7241323ed3198cccb4041.
> >>
> >> So it is likely too late to change this behavior even if it is not
> >> what we prefer.
> >>
> >
> > My gut feeling is that whatever broke (likely during block addition
> > maybe even earlier during clsact addition) is in the code
> > path for adding filter. Dumping may have bugs but i would
> > point a finger to filter addition first.
> > More below.... (sorry long email).
> >
> >
> > Here's what i tried after applying your patch:
> >
> > ----
> > # $TC qd add dev $DEV ingress
> > # $TC qd add dev $DEV root prio
> > # $TC qd ls dev $DEV
> > qdisc noqueue 0: dev lo root refcnt 2
> > qdisc prio 8008: dev enp0s1 root refcnt 2 bands 3 priomap 1 2 2 2 1 2 0
> > 0 1 1 1 1 1 1 1 1
> > qdisc ingress ffff: dev enp0s1 parent ffff:fff1 ----------------
> > -----
> >
> > egress i.e root is at 8008:
> > ingress is at ffff:fff1
> >
> > If say:
> > ---
> > # $TC filter add dev $DEV root protocol arp prio 10 basic action pass
> > ----
> >
> > i am instructing the kernel to "go and find root (which is 8008:)
> > and install the filter there".
>
> Ok, I went backwards and looked at many kernel sources.
> It is true we install the filters in two different locations
> i.e just specifying TC_H_ROOT does not equate to picking
> the egress qdisc with that flag.
> And has been broken for way too long - so we have to live
> with it.
> I wish we had more tdc tests and earlier.
>
> Advise to users is not to use semantics like "root" or ingress
> but rather explicitly specify the parent.

Yeah, I was confused too when my colleagues reported this
to me.

>
> So ignore what i said above. I will ACK your patch.

Thanks for review!
