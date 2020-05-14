Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C671D26E8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 07:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgENF7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 01:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725794AbgENF7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 01:59:17 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7ED4C061A0C;
        Wed, 13 May 2020 22:59:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 4so1957321qtb.4;
        Wed, 13 May 2020 22:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFyj8vcqUQLGEcrCrABRZUjZY1gWvxrlhLlZOI3F+YU=;
        b=BYiNEqUa6YhgHt7klRbt0dwWvan1w+wkV0A1EThuEQ/+WfS5zvqoPmya7sy5Xg0dbl
         BaAxojUsTDAXOPUa0guJmxnmzA4Eb8It8dkx0ENJOuckGkvP5TozPmxVHrE+/6qEOFpm
         4OZ8kCuphBdRd5rO4BLXBKInMt2IGomnXdbXZb+heYMZ75PuxEPs/Ull2KEMogvxhwvC
         pq4Ov00mmL3iC9y9JjaRSLNG+h8zAJRjoiPj8ONiQ/0J8DbttvUoFUabyxXznyKl31q9
         979HS3kuP5i/28aFmjbcyJQy8XG+bpncqb1MLbHQTS/6PmxhVz/sXPIAxkP6nU83NuC4
         4jzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFyj8vcqUQLGEcrCrABRZUjZY1gWvxrlhLlZOI3F+YU=;
        b=ia0qeAAhMS4JH/MDojYZoOA8GOEHp/SyglVzbguLLGIOMLqg2+Q66KcwrDdqDK2m4y
         pOvFtiyGy/iwf4pFNDlmopDQRCWQx0rjilp04p+TqXXJZieQ7GwOqOkn3jjjN8o6cNUz
         w8laJmDyuGMStllPIUvzaw/dhi566AZA5FbcZ6m4+jBfCAeWWbE0ZT0ugRutEr9IzGcp
         SbO3USUmt6Pj9j+YEhVP68P77qIRao7gOiWj8maGuvgwSMO+tuJWiuuZwpNlZ5r4dcec
         HLmLcxbSxvSiBwEqVj2eVz/YFYqpe7yPREd7WfZo7lK4e8R4bA9cOzvu9NOBvVBy0fYA
         nYEA==
X-Gm-Message-State: AOAM533rK+IaheSX64JTnvX/555RKyef/aQn9vKYolBl8dgNnJ0a2oSL
        UQxV9tjTxaGW3C0NDlZHV5K8vq3u0M9wb7vWSYQ=
X-Google-Smtp-Source: ABdhPJyULhu33afCvDkft733jdgYQh+MMEJTe/0mJc7QflOgq7ZE7z+128Qi1KBy9aX7/gZR0jefFEaULhmYHkUNCYU=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr2621262qtc.93.1589435955988;
 Wed, 13 May 2020 22:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <alpine.LRH.2.21.2005132231450.1535@localhost>
In-Reply-To: <alpine.LRH.2.21.2005132231450.1535@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 May 2020 22:59:05 -0700
Message-ID: <CAEf4BzZpa3Xjevy-tV2oD2Yoxhf=Sm1EPNZdWsv0CoUCSmuF9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 2:59 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Wed, 13 May 2020, Andrii Nakryiko wrote:
>
> > This commits adds a new MPSC ring buffer implementation into BPF ecosystem,
> > which allows multiple CPUs to submit data to a single shared ring buffer. On
> > the consumption side, only single consumer is assumed.
> >
> > Motivation
> > ----------
> > There are two distinctive motivators for this work, which are not satisfied by
> > existing perf buffer, which prompted creation of a new ring buffer
> > implementation.
> >   - more efficient memory utilization by sharing ring buffer across CPUs;
> >   - preserving ordering of events that happen sequentially in time, even
> >   across multiple CPUs (e.g., fork/exec/exit events for a task).
> >
> > These two problems are independent, but perf buffer fails to satisfy both.
> > Both are a result of a choice to have per-CPU perf ring buffer.  Both can be
> > also solved by having an MPSC implementation of ring buffer. The ordering
> > problem could technically be solved for perf buffer with some in-kernel
> > counting, but given the first one requires an MPSC buffer, the same solution
> > would solve the second problem automatically.
> >
>
> This looks great Andrii! One potentially interesting side-effect of
> the way this is implemented is that it could (I think) support speculative
> tracing.
>
> Say I want to record some tracing info when I enter function foo(), but
> I only care about cases where that function later returns an error value.
> I _think_ your implementation could support that via a scheme like
> this:
>
> - attach a kprobe program to record the data via bpf_ringbuf_reserve(),
>   and store the reserved pointer value in a per-task keyed hashmap.
>   Then record the values of interest in the reserved space. This is our
>   speculative data as we don't know whether we want to commit it yet.
>
> - attach a kretprobe program that picks up our reserved pointer and
>   commit()s or discard()s the associated data based on the return value.
>
> - the consumer should (I think) then only read the committed data, so in
>   this case just the data of interest associated with the failure case.
>
> I'm curious if that sort of ringbuf access pattern across multiple
> programs would work? Thanks!


Right now it's not allowed. Similar to spin lock and socket reference,
verifier will enforce that reserved record is committed or discarded
within the same BPF program invocation. Technically, nothing prevents
us from relaxing this and allowing to store this pointer in a map, but
that's probably way too dangerous and not necessary for most common
cases.

But all your troubles with this is due to using a pair of
kprobe+kretprobe. What I think should solve your problem is a single
fexit program. It can read input arguments *and* return value of
traced function. So there won't be any need for additional map and
storing speculative data (and no speculation as well, because you'll
just know beforehand if you even need to capture data). Does this work
for your case?

>
> Alan
>

[...]

no one seems to like trimming emails ;)
