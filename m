Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C2141385C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhIURgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhIURdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 13:33:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6731C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 10:31:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r5so7334053edi.10
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 10:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=egCBE6Ndap/i6qoLfQddqiPMRtsk6XZbUrnUwtD9K90=;
        b=b8rgGDOlssfxwzIoeHREhUk4Qq1SQjz/cSgJealYXs7G7bMMRm2wmcCK12hfbaQLbi
         DvLNoMz9tBerBUq872rnm4NabJNTLfKGOEvHZfrUTIJsU/SZv10khczddK96DOYtqv21
         DP1VWGknpf4/f5DkxwC/ejeT3jsFfJg/c4OuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=egCBE6Ndap/i6qoLfQddqiPMRtsk6XZbUrnUwtD9K90=;
        b=g/NFocTKMP0jWRTbFZTQ2uk5gBN3nywaa5OPNQtzYnaWKxQS/tJipr06LhYeKcMnTP
         z/YVFSJK5RLWRuBznR42dHaKRUuTjhMiuBL1KtcsfRpgvqkh2eCVX+L1WAln2VplJcYE
         YPv5efpbBCaLvZPUWjsz6Ck3cqfGPsnIgux0HTg90yxQkdBzVLHfCDSJhZ65iIJBweDQ
         DuLTeBP+4cFRTFGWa4wXG9Y1A1uLRye8/y64Tli+CexeMBRYxikk1YZLNyoIswJUbl6K
         FUG/CWkKa/TJLM799Q+QZKvtR4ZW5s1UhbKXhgMrDQrQyBKLBweqJqJWB5eQKGnYJRFr
         4nzA==
X-Gm-Message-State: AOAM532GODWAC6e1a1Z2qzliY9T6bSv66l7J40rF+UnkXs5OvAAG+60M
        4YstQ+4ACm1QVNWw7dIcIt5TPKoNNUuqdqYpxSMBQDWEtksT0DmA
X-Google-Smtp-Source: ABdhPJzSNL5MT9GVv5s7RGXO5yBKLcNDppD1qUsjy9B3K77eX7CRVaMYFbt6yaEAhnqdBrgHko5oKGF+0XCKUHuvmT8=
X-Received: by 2002:a50:e145:: with SMTP id i5mr22438306edl.16.1632245496241;
 Tue, 21 Sep 2021 10:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk>
In-Reply-To: <87o88l3oc4.fsf@toke.dk>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Tue, 21 Sep 2021 10:31:24 -0700
Message-ID: <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Hi Lorenz (Cc. the other people who participated in today's discussion)
>
> Following our discussion at the LPC session today, I dug up my previous
> summary of the issue and some possible solutions[0]. Seems no on
> actually replied last time, which is why we went with the "do nothing"
> approach, I suppose. I'm including the full text of the original email
> below; please take a look, and let's see if we can converge on a
> consensus here.
>
> First off, a problem description: If an existing XDP program is exposed
> to an xdp_buff that is really a multi-buffer, while it will continue to
> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
> the packet it'll only see part of the payload and not be aware of that
> fact, and if it's calculating the packet length, that will also only be
> wrong (only counting the first fragment).
>
> So what to do about this? First of all, to do anything about it, XDP
> programs need to be able to declare themselves "multi-buffer aware" (but
> see point 1 below). We could try to auto-detect it in the verifier by
> which helpers the program is using, but since existing programs could be
> perfectly happy to just keep running, it probably needs to be something
> the program communicates explicitly. One option is to use the
> expected_attach_type to encode this; programs can then declare it in the
> source by section name, or the userspace loader can set the type for
> existing programs if needed.
>
> With this, the kernel will know if a given XDP program is multi-buff
> aware and can decide what to do with that information. For this we came
> up with basically three options:
>
> 1. Do nothing. This would make it up to users / sysadmins to avoid
>    anything breaking by manually making sure to not enable multi-buffer
>    support while loading any XDP programs that will malfunction if
>    presented with an mb frame. This will probably break in interesting
>    ways, but it's nice and simple from an implementation PoV. With this
>    we don't need the declaration discussed above either.
>
> 2. Add a check at runtime and drop the frames if they are mb-enabled and
>    the program doesn't understand it. This is relatively simple to
>    implement, but it also makes for difficult-to-understand issues (why
>    are my packets suddenly being dropped?), and it will incur runtime
>    overhead.
>
> 3. Reject loading of programs that are not MB-aware when running in an
>    MB-enabled mode. This would make things break in more obvious ways,
>    and still allow a userspace loader to declare a program "MB-aware" to
>    force it to run if necessary. The problem then becomes at what level
>    to block this?
>

I think there's another potential problem with this as well: what happens t=
o
already loaded programs that are not MB-aware? Are they forcibly unloaded?

>    Doing this at the driver level is not enough: while a particular
>    driver knows if it's running in multi-buff mode, we can't know for
>    sure if a particular XDP program is multi-buff aware at attach time:
>    it could be tail-calling other programs, or redirecting packets to
>    another interface where it will be processed by a non-MB aware
>    program.
>
>    So another option is to make it a global toggle: e.g., create a new
>    sysctl to enable multi-buffer. If this is set, reject loading any XDP
>    program that doesn't support multi-buffer mode, and if it's unset,
>    disable multi-buffer mode in all drivers. This will make it explicit
>    when the multi-buffer mode is used, and prevent any accidental subtle
>    malfunction of existing XDP programs. The drawback is that it's a
>    mode switch, so more configuration complexity.
>

Could we combine the last two bits here into a global toggle that doesn't
require a sysctl? If any driver is put into multi-buffer mode, then the sys=
tem
switches to requiring all programs be multi-buffer? When the last multi-buf=
fer
enabled driver switches out of multi-buffer, remove the system-wide
restriction?

Regarding my above question, if non-MB-aware XDP programs are not forcibly
unloaded, then a global toggle is also insufficient. An existing non-MB-awa=
re
XDP program would still beed to be rejected at attach time by the driver.

> None of these options are ideal, of course, but I hope the above
> explanation at least makes sense. If anyone has any better ideas (or can
> spot any flaws in the reasoning above) please don't hesitate to let us
> know!
>
> -Toke
>
> [0] https://lore.kernel.org/r/8735srxglb.fsf@toke.dk
>
