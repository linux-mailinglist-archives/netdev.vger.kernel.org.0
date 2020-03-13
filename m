Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE12184E9C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCMSbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:31:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34568 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMSbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:31:11 -0400
Received: by mail-qk1-f193.google.com with SMTP id f3so14225799qkh.1;
        Fri, 13 Mar 2020 11:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7VWF42YYsHVvqKfOU1rBH3ohimrnDdc8FeNphBNmgI=;
        b=Dyyem0UTC6SMSM9r14h83UV6z2n+gZZnr9BvL0gcMtIHi81ej0Y7X4o1BkJg87atRv
         SvAj4M4DZG9OXpa8bDF6J7u90Fu1KM8i1x/D1A+2WTZNmDCXO2Tju1g01WXSZnwC1jD6
         /fv6gZTuEX0Mb/KPIM3X+FEQSCe5eEnnq1ygtNcOMgdaWfqpHMBMP2uK7luR3/IVuu1W
         wFRbxhFIuKZT0xzkRfdHUL1lcNop6CGO27VYlvVKmdGqh446ClcvlAr2MhL1RM5IfYLn
         5eREWR7yRljOPJvtFb5Ci7h/O/+zccKTwUL8QojvgioEWY/iUr3bXM9f1L1YhZRu1BUr
         4cGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7VWF42YYsHVvqKfOU1rBH3ohimrnDdc8FeNphBNmgI=;
        b=gvfxWBSBYWHDoKwIP4EqS/5IaD3FmkDMVeuAKN3M5a1HQL5U67rXEn8a4M5czmuS9T
         YjItIYlYxSCZ0eRHm73ch4QFSoWawaXM+hS0pV1k2OlEgCDLL9Q2shCGTSLE2xwFLz/J
         9Ly6Q7JjzkU+BKqcqSgwbYIM8SBUMjwwM5xxHZ0JbGFPRGNAhhIxYcX//kPs1L6f7Fsn
         oEUn21MW5jTcB7wRRAr9SWqP9/0P/Jx5BMev93UtKRfsx+cShxV0hPyahg/VdnD5/UeH
         uQGoiLvS/chRpQw1lpxFvdTEGzN9VGOt/cfmbJ2x6++QKLPtObjPr6+RxVGxYJ+RvT3Z
         0JKA==
X-Gm-Message-State: ANhLgQ2Jfo83Xa8PZtrjDZLy+DPt0VwhcLwIdo4p0LfFDEg3UBj9Yr/4
        jWPRSounwzARIq8Fhfmy339UVkV/XsbVZgJFIuw=
X-Google-Smtp-Source: ADFU+vsp90k5VaHLBeVJ49Sj9t/ytCKejZhJmL33Mj5xtkTiHq6ZopR6NN2IRwueenrZO13WRehUFLIkQfaK+LgG+kE=
X-Received: by 2002:a37:6411:: with SMTP id y17mr14841147qkb.437.1584124269698;
 Fri, 13 Mar 2020 11:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200312171105.533690-1-jakub@cloudflare.com> <CAEf4BzbsDMbmury9Z-+j=egsfJf4uKxsu0Fsdr4YpP1FgvBiiQ@mail.gmail.com>
 <87o8t0xl37.fsf@cloudflare.com>
In-Reply-To: <87o8t0xl37.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 11:30:58 -0700
Message-ID: <CAEf4BzbJENxR6nrL47tKa+mL8Cxf7JtTjkX7ysBSE0iYB0Ey5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix spurious failures in accept
 due to EAGAIN
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 9:42 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Mar 12, 2020 at 06:57 PM CET, Andrii Nakryiko wrote:
> > Thanks for looking into this. Can you please verify that test
> > successfully fails (not hangs) when, say, network is down (do `ip link
> > set lo down` before running test?). The reason I'm asking is that I
> > just fixed a problem in tcp_rtt selftest, in which accept() would
> > block forever, even if listening socket was closed.
>
> While on the topic writing network tests with test_progs.
>
> There are a couple pain points because all tests run as one process:
>
> 1) resource cleanup on failure
>
>    Tests can't simply exit(), abort(), or error() on failure. Instead
>    they need to clean up all resources, like opened file descriptors and
>    memory allocations, and propagate the error up to the main test
>    function so it can return to the test runner.
>
> 2) terminating in timely fashion
>
>    We don't have an option of simply setting alarm() to terminate after
>    a reasnable timeout without worrying about I/O syscalls in blocking
>    mode being stuck.

I agree, those APIs suck, unfortunately.

>
> Careful error and timeout handling makes test code more complicated that
> it really needs to be, IMHO. Making writing as well as maintaing them
> harder.

Well, I think it's actually a good thing. Tests are as important as
features, if not more, so it pays to invest in having reliable tests.

>
> What if we extended test_progs runner to support process-per-test
> execution model? Perhaps as an opt-in for selected tests.
>
> Is that in line with the plans/vision for BPF selftests?

It would be nice indeed, though I'd still maintain that tests
shouldn't be sloppy. But having that would allow parallelizing tests,
which would be awesome. So yeah, it would be good to have, IMO.
