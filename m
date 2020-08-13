Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DA0243B27
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHMOA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHMOAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:00:54 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E153FC061386
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 07:00:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z17so5599708ill.6
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 07:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PtGgLWDRWGx50RdkDqyUn+OE7RzPlwh+dkXE2Y3x1AE=;
        b=oNzeSBEUqD21BcUdio0euZ7kKnm3HeCKKvHH//qIOPDPpc6+1zjyIfzj4TWCdiqUdt
         b1B/dy3nw32XQrZio79LnayYzYpvBC6aWeSoFArul4s/2tpnlWuQftkaZKFKkVxfImrv
         OMkVtobHB6Yol37pWxp0/R1v9f7o1X7sl53gZwTRIPqBwjnfWpPEJ/XHKz+kHWqQFsB2
         5JhCFeh6FriDFZPVqq6uCBy8K/jBER9vqyhY3lANlUfa6sFmWCygp7q1SihcSuO5V1ar
         5ZtqPzdYH5h1f7kG1fgR9EAbNZ/C/9710NlvC8aLeJWSIuXQVTVlEBQnUGkWQ/BtlD+O
         31FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PtGgLWDRWGx50RdkDqyUn+OE7RzPlwh+dkXE2Y3x1AE=;
        b=WAzUo9dro2tgs1AhBXSvkIewnfezLs8Y7kGkcJrUom22q7v5oysd6SoSS6uklgiCLK
         dmps+nq0+ghaJhVD/j4TP3Ndy4CcoIpzBqn4BCseruYDPLJ2G1PClztLc59yNOkYTOEt
         7IbjlEJRETspGWH0jskXg9hhEgPt7fB1lX3JQ4a/DQcZXom3/x209O2Gx0jGOQHhf+bA
         uv64/yCojp1JOItrkZmuID6fox/2lo/kDc3gIYeNGjmv4fQJS4g+OmpfVRpBue/tq+Pg
         nZ+NQy7RTyfDLMunMKDD5ML1IFi2LOiuUtvDaMeuElJ/M+Pbu7KKLt99e6kIP322xQZ9
         S3zg==
X-Gm-Message-State: AOAM533c0GE9LvjAuhRlfh9FQlUeQH4r53EzKBTHVQXz/QKq5yMk61fi
        qmFBFnHX16HW4RXXRnRf8nOXelqAL31FjWD7/+3I0w==
X-Google-Smtp-Source: ABdhPJyIReqaT2A3Fla/oeGttyZvchNIXydn2XR5ObkIgfF5oK0DolFRwpaWjU7akUP6lqjR8QzIge7PZOMdXkaIiaU=
X-Received: by 2002:a92:c52e:: with SMTP id m14mr4810697ili.205.1597327253121;
 Thu, 13 Aug 2020 07:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUWiXyP-s+=V9xy00ZwjaSQKZ9GOG_cvkCetNTVYHNipGg@mail.gmail.com>
 <CA+icZUUdtRm7uHPT=TtT1BEE0dQU3pFP-nvqwBE7ES1F_kvXSA@mail.gmail.com>
In-Reply-To: <CA+icZUUdtRm7uHPT=TtT1BEE0dQU3pFP-nvqwBE7ES1F_kvXSA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Aug 2020 07:00:41 -0700
Message-ID: <CANn89i+Yp7duamws_yH6KdFJjiUrH_aGxVf7ANPo8DEmib8Cbw@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     sedat.dilek@gmail.com
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 1:27 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> I run a perf session looks like this in my KDE/Plasma desktop-environment:
>
> [ PERF SESSION ]
>
>  1016  2020-08-13 09:57:24 echo 1 > /proc/sys/kernel/sched_schedstats
>  1017  2020-08-13 09:57:24 echo prandom_u32 >>
> /sys/kernel/debug/tracing/set_event
>  1018  2020-08-13 09:57:24 echo traceon >
> /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
>  1019  2020-08-13 09:57:25 echo 1 > /sys/kernel/debug/tracing/events/enable
>
>  1020  2020-08-13 09:57:32 sysctl -n kernel.sched_schedstats
>  1021  2020-08-13 09:57:32 cat /sys/kernel/debug/tracing/events/enable
>  1022  2020-08-13 09:57:32 grep prandom_u32 /sys/kernel/debug/tracing/set_event
>  1023  2020-08-13 09:57:33 cat
> /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
>
> root# /home/dileks/bin/perf record -a -g -e random:prandom_u32 sleep 5
>

To be clear : This "perf record -a -g -e random:prandom_u32 sleep 5"
is self sufficient.

You have nothing to do before (as reported in your email), this is
simply not needed.

I am not sure why you added all this irrelevant stuff, this is distracting.
