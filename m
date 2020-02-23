Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F7D169A80
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 23:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBWWkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 17:40:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41912 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWWkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 17:40:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id 70so4085572pgf.8;
        Sun, 23 Feb 2020 14:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j2mYDc1i3ua7STLlJCa6Hdc5WmjYOywz/EKCcFwocXo=;
        b=mFToI9xjI4QQ9dypWcrCsgTEWlSEJ6HCXy8z1JYt1MFng6K1F8VTZeGlZhW0+SLGA3
         4Ga5OgTGeaSZwIyGp87GNUhQ01M2Q3GXMhtRdvs1YmCiXaaVk/2GBwL8zWHwrka9Sa2i
         uP14yCI5z8L+/b1/JbAi6Vzpf8y+kCyitXPVleKmPNsEq3jrBkf2k9GJUKXBNIwbPr8N
         yXFQKfR0AVJ7lNqiw5XQs0yuRXpBUQGbppEwIDeLwf/y/8UZxhyMtrEDX46Cyxbp4v0o
         B4W+pB7ia/IFGgBnAK9/vQwqZw+HDTsIkKZxTd2BPaf1vKrs246j/FhiXU4GDz4NWUem
         IP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j2mYDc1i3ua7STLlJCa6Hdc5WmjYOywz/EKCcFwocXo=;
        b=ftgzxoVwi34IRoAVWjoN57om8UULRt9ncA2/HYgB90bm3jc3yBIElj5fGUS4CzNlZJ
         n8N2dY3KrCy0JWf74T6h6ANEvbH5edsf4xwzoyCjc5s2zVH9TP7JrDntsaJjMYf5cg6F
         SXqXVmoQxmRDJWg9HxZ0rduLxomAgwaO01I0DOOlBhNaR4y5V2btCDo1puok++4+0FCF
         Ine6xwriumVkmrjgMsJXhQ+eU3imISombplQH2C6XaRTfCL7b+v1r+hsajC+ZZMDN5Ma
         454FF6nTHhOWvFQAQEO2FeMmzuRYTLsJGV2OyOJoMAU16qS67z5F5Sk41vy0cRQ6uCnS
         PE5w==
X-Gm-Message-State: APjAAAU+viqLENDEwv6EXBWrvZZro6YjiTQjPBKD88RTGNA5yxq0JNQE
        21KYR8Kfk1QFqfV41je4jew=
X-Google-Smtp-Source: APXvYqxzYVkwsh8iybt5JEDibUnTgddsvfUWsaYYvbMj8IkRablUTnWOw5fdtlt39H18Ky0wJcLsDw==
X-Received: by 2002:a63:2cd6:: with SMTP id s205mr49190694pgs.258.1582497651814;
        Sun, 23 Feb 2020 14:40:51 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:7207])
        by smtp.gmail.com with ESMTPSA id t19sm9864351pgg.23.2020.02.23.14.40.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Feb 2020 14:40:51 -0800 (PST)
Date:   Sun, 23 Feb 2020 14:40:48 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V2 01/20] bpf: Enforce preallocation for all
 instrumentation programs
Message-ID: <20200223224046.o6ynykpvg6kl75ar@ast-mbp>
References: <20200222042916.k3r5dj5njoo2ywyj@ast-mbp>
 <87o8tr3thx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8tr3thx.fsf@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 22, 2020 at 09:40:10AM +0100, Thomas Gleixner wrote:
> Alexei,
> 
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > On Thu, Feb 20, 2020 at 09:45:18PM +0100, Thomas Gleixner wrote:
> >> The assumption that only programs attached to perf NMI events can deadlock
> >> on memory allocators is wrong. Assume the following simplified callchain:
> >>  	 */
> >> -	if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
> >> +	if ((is_tracing_prog_type(prog->type)) {
> >
> > This doesn't build.
> > I assumed the typo somehow sneaked in and proceeded, but it broke
> > a bunch of tests:
> > Summary: 1526 PASSED, 0 SKIPPED, 54 FAILED
> > One can argue that the test are unsafe and broken.
> > We used to test all those tests with and without prealloc:
> > map_flags = 0;
> > run_all_tests();
> > map_flags = BPF_F_NO_PREALLOC;
> > run_all_tests();
> > Then 4 years ago commit 5aa5bd14c5f866 switched hashmap to be no_prealloc
> > always and that how it stayed since then. We can adjust the tests to use
> > prealloc with tracing progs, but this breakage shows that there could be plenty
> > of bpf users that also use BPF_F_NO_PREALLOC with tracing. It could simply
> > be because they know that their kprobes are in a safe spot (and kmalloc is ok)
> > and they want to save memory. They could be using large max_entries parameter
> > for worst case hash map usage, but typical load is low. In general hashtables
> > don't perform well after 50%, so prealloc is wasting half of the memory. Since
> > we cannot control where kprobes are placed I'm not sure what is the right fix
> > here. It feels that if we proceed with this patch somebody will complain and we
> > would have to revert, but I'm willing to take this risk if we cannot come up
> > with an alternative fix.
> 
> Having something which is known to be broken exposed is not a good option
> either.
> 
> Just assume that someone is investigating a kernel issue. BOFH who is
> stuck in the 90's uses perf, kprobes and tracepoints. Now he goes on
> vacation and the new kid in the team decides to flip that over to BPF.
> So now instead of getting information he deadlocks or crashes the
> machine.
> 
> You can't just tell him, don't do that then. It's broken by design and
> you really can't tell which probes are safe and which are not because
> the allocator calls out into whatever functions which might look
> completely unrelated.
> 
> So one way to phase this out would be:
> 
> 	if (is_tracing()) {
>         	if (is_perf() || IS_ENABLED(RT))
>                 	return -EINVAL;
>                 WARN_ONCE(.....)
>         }
> 
> And clearly write in the warning that this is dangerous, broken and
> about to be forbidden. Hmm?

Yeah. Let's start with WARN_ONCE and verbose(env, "dangerous, broken")
so the users see it in the verifier log and people who maintain
servers (like kernel-team-s in fb, goog, etc) see it as well
in their dmesg logs. So the motivation will be on both sides.
Then in few kernel releases we can flip it to disable.
Or we'll find a way to make it work without pre-allocating.
