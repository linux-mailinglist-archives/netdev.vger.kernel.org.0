Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF7B363151
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhDQRKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbhDQRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:10:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56760C061574;
        Sat, 17 Apr 2021 10:09:35 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lt13so6790263pjb.1;
        Sat, 17 Apr 2021 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x7a2xqi/iFnK0eHNKezFE2yZURJDDLRgYL5anBL6QIo=;
        b=ksU6jZGHvtPyz9NcZUzfkbpgqw1ieXJvb+e/rFGwKblsqE2vHomN3yT+aVc4rsuTlZ
         CZKcevPy/7pHKtcnjL/x6lO8D6IcCG/Xh8WWi6xWLmMsXdP4K+1//1/0TMXOEhNCW3uE
         +4K5q856L9rTWqyJtWiBYixORwbnguLrzA8vpLNWwL1Ro9i3MpB3zXsUOwk1mAg1IQe6
         pQKUgsq7IKqxkn84+cvKM4EPU0P0ckvp+62kbZ6ETCUSLfvzBytFnVsbUqygUpjzgrZK
         Km5KyBhvWanU6Wr7dENvO5oXt0c7dzQOMh58vd8sBuD/1zMcz3FrvzQLWPGsoHXY8fTS
         Qd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x7a2xqi/iFnK0eHNKezFE2yZURJDDLRgYL5anBL6QIo=;
        b=jaybjOHk0c9M8x537ON3ZhEgmyQScLtdCLLDLhzawIBLLCI/vVlrVy6cV+L6qlz1xf
         xkCnCQvc3GKzBx+4HKwpLoTBmEiHM+z+5sfWP0x5Qo9To0VEIml8KveI62aQYrBD1+EL
         tS0cjez83DOuARvlSs9VBwolYLpbY3JOhN7rvKy5edJJXiQ5Wy5e9VD7sjrbXmLD7a+m
         6W9NDJPqLy4uWJ6LLWab6YlyWrs7mg07LSsJh0J9MdNUkZTxRi9ph3fakTw0DEc+MwJZ
         m5bLqdJeyVl6VnklLVOoOp1AVRIsC7JjlUKrGpX1wZOr3jfGmXMKl1cqnH1NVoR0uk9w
         ANHQ==
X-Gm-Message-State: AOAM531ZLuRWEyVeAibDkLpsZzdPFCRCXr4EjeoRiKLQFaN+TOQpVhRe
        B9fvyzruV0gYNblJZVYzz8I=
X-Google-Smtp-Source: ABdhPJwyMg/eGlknw6XyTMcxkhCp0BFWFfoAeobWrvIpW2wiVcFhrqhYvn8xxzyFY67Xol+C/QQT3w==
X-Received: by 2002:a17:90a:8410:: with SMTP id j16mr15553053pjn.120.1618679374717;
        Sat, 17 Apr 2021 10:09:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8587])
        by smtp.gmail.com with ESMTPSA id t19sm8461891pfg.38.2021.04.17.10.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 10:09:34 -0700 (PDT)
Date:   Sat, 17 Apr 2021 10:09:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
Message-ID: <20210417170931.hxo2vvt4532jrx7k@ast-mbp.dhcp.thefacebook.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com>
 <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
 <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
 <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
 <CAADnVQLOZ7QL61_XPCSmxDfZ0OHX_pBOmpEWLjSUwqhLm_10Jw@mail.gmail.com>
 <20210417143639.kq3nafzlsridtbb6@ast-mbp>
 <YHsRdTqgurSCykt7@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHsRdTqgurSCykt7@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 04:48:53PM +0000, Al Viro wrote:
> On Sat, Apr 17, 2021 at 07:36:39AM -0700, Alexei Starovoitov wrote:
> 
> > The kernel will perform the same work with FDs. The same locks are held
> > and the same execution conditions are in both cases. The LSM hooks,
> > fsnotify, etc will be called the same way.
> > It's no different if new syscall was introduced "sys_foo(int num)" that
> > would do { return close_fd(num); }.
> > It would opearate in the same user context.
> 
> Hmm...  unless I'm misreading the code, one of the call chains would seem to
> be sys_bpf() -> bpf_prog_test_run() -> ->test_run() -> ... -> bpf_sys_close().
> OK, as long as you make sure bpf_prog_get() does fdput() (i.e. that we
> don't have it restructured so that fdget()/fdput() pair would be lifted into
> bpf_prog_test_run(), with fdput() moved in place of bpf_prog_put()).

Got it. There is no fdget/put bracketing in the code.
On the way to test_run we do __bpf_prog_get() which does fdget and immediately
fdput after incrementing refcnt of the prog.
I believe this pattern is consistent everywhere in kernel/bpf/*

> Note that we *really* can not allow close_fd() on anything to be bracketed
> by fdget()/fdput() pair; we had bugs of that sort and, as the matter of fact,
> still have one in autofs_dev_ioctl().
> 
> The trouble happens if you have file F with 2 references, held by descriptor
> tables of different processes.  Say, process A has descriptor 6 refering to
> it, while B has descriptor 42 doing the same.  Descriptor tables of A and B
> are not shared with anyone.
> 
> A: fdget(6) 	-> returns a reference to F, refcount _not_ touched
> A: close_fd(6)	-> rips the reference to F from descriptor table, does fput(F)
> 		   refcount drops to 1.
> B: close(42)	-> rips the reference to F from B's descriptor table, does fput(F)
> 		   This time refcount does reach 0 and we use task_work_add() to
> 		   make sure the destructor (__fput()) runs before B returns to
> 		   userland.  sys_close() returns and B goes off to userland.
> 		   On the way out __fput() is run, and among other things,
> 		   ->release() of F is executed, doing whatever it wants to do.
> 		   F is freed.
> And at that point A, which presumably is using the guts of F, gets screwed.

Thanks for these details. That's really helpful.

> 	So please, mark all call sites with "make very sure you never get
> here with unpaired fdget()".

Good point. Will add this comment.

> 	BTW, if my reading (re ->test_run()) is correct, what limits the recursion
> via bpf_sys_bpf()?

Glad you asked! This kind of code review questions are much appreciated.

It's an allowlist of possible commands in bpf_sys_bpf().
'case BPF_PROG_TEST_RUN:' is not there for this exact reason.
I'll add a comment to make it more obvious.
