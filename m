Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0544356E6E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFZQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:12:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47057 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfFZQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:12:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so1418297pgr.13
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6OFM3ZfAg+G8WIrD9XzsdlV6sbyJrFX2TeViApwcwRU=;
        b=q6yaPJ168KFGL7DBURc+ogCgcCIo5BpRUiXDnV/wYUlQPeJt1RE88ob1VwR20fOeec
         NX0mGqQr+mwWOOzIaj68EGY+ff9jSBGhgZtJTd9Hw0nilGmfTOMhu+enuzh8A3QGWdo4
         QupvyeJcrKGzjyL9vkpD0zKok7zr/zddT7UcJJmtiKF+cn4pp96VhyzIzR0HReIwsD5m
         qNkpF7bcxj34ZWrh9nUHdeefN02zChlQBAN3bCVXlsPhjfU35WIKGeGhbbF8g+gzK6xf
         YvA+ljr7ZLsy3c7p7hiB19QryrON+Xx8QpJZHGKMU6HLInZccgeBc1yK90tDiAwZoPMY
         /VTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6OFM3ZfAg+G8WIrD9XzsdlV6sbyJrFX2TeViApwcwRU=;
        b=kMHzX48KkHIZ6EIv0ZsKlU9OLMIr/M8mZVL5R4QJ1Bw5d+Q+COrLzTAjDh3QGpWwRt
         BZZgtC+/fduS7vM1X6B5bHvCbd4Sm1gFBASGxYwpkT1ugoBnUjuYKv/wxrBamCEqsroS
         Om7lPmHDI035PWJN3uX2WQ5l86en3p/OlV8Kyl3Ksmpm2PYZGrc+fQx2LsZ7GhAFASVT
         dqU16Uysr1AmBIGAfAlg5f2DP5g1yfrXVZdCt5Y+OffQPLQgjnqHuJwaO5nVRUcod3sf
         6d//CcpxoLZcDyxuSzT17b630JYKKYapOTfThlNWdnX02R6dH/N3DPlEiWG3g05zDHii
         XpqQ==
X-Gm-Message-State: APjAAAUyRgk0K/Lp4dW5Y0u234JiKtcfljdWzqrKaZepxxjc9xr3y12X
        /1yg2F+XEdLTPnQqi0tKueo78A==
X-Google-Smtp-Source: APXvYqwk1c14hxti86e1csk6ag5eahu2o+cdbuXKKv7hpJSj7huNmfEkcQA49kQ5nDLAzSeTxq8whQ==
X-Received: by 2002:a17:90a:ad93:: with SMTP id s19mr5721600pjq.36.1561565553417;
        Wed, 26 Jun 2019 09:12:33 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f2sm15242028pgs.83.2019.06.26.09.12.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 09:12:32 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:12:31 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     netdev@vger.kernel.org, Alban Crequy <alban@kinvolk.io>,
        Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next v2 08/10] bpf: Implement bpf_prog_test_run for perf
 event programs
Message-ID: <20190626161231.GA4866@mini-arch>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
 <20190625194215.14927-9-krzesimir@kinvolk.io>
 <20190625201220.GC10487@mini-arch>
 <CAGGp+cE3m1+ZWFBmjTgKFEHYVJ-L1dE=+iVUXvXCxWAxRG9YTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGGp+cE3m1+ZWFBmjTgKFEHYVJ-L1dE=+iVUXvXCxWAxRG9YTA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26, Krzesimir Nowak wrote:
> On Tue, Jun 25, 2019 at 10:12 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/25, Krzesimir Nowak wrote:
> > > As an input, test run for perf event program takes struct
> > > bpf_perf_event_data as ctx_in and struct bpf_perf_event_value as
> > > data_in. For an output, it basically ignores ctx_out and data_out.
> > >
> > > The implementation sets an instance of struct bpf_perf_event_data_kern
> > > in such a way that the BPF program reading data from context will
> > > receive what we passed to the bpf prog test run in ctx_in. Also BPF
> > > program can call bpf_perf_prog_read_value to receive what was passed
> > > in data_in.
> > >
> > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > ---
> > >  kernel/trace/bpf_trace.c                      | 107 ++++++++++++++++++
> > >  .../bpf/verifier/perf_event_sample_period.c   |   8 ++
> > >  2 files changed, 115 insertions(+)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index c102c240bb0b..2fa49ea8a475 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -16,6 +16,8 @@
> > >
> > >  #include <asm/tlb.h>
> > >
> > > +#include <trace/events/bpf_test_run.h>
> > > +
> > >  #include "trace_probe.h"
> > >  #include "trace.h"
> > >
> > > @@ -1160,7 +1162,112 @@ const struct bpf_verifier_ops perf_event_verifier_ops = {
> > >       .convert_ctx_access     = pe_prog_convert_ctx_access,
> > >  };
> > >
> > > +static int pe_prog_test_run(struct bpf_prog *prog,
> > > +                         const union bpf_attr *kattr,
> > > +                         union bpf_attr __user *uattr)
> > > +{
> > > +     void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> > > +     void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> > > +     u32 data_size_in = kattr->test.data_size_in;
> > > +     u32 ctx_size_in = kattr->test.ctx_size_in;
> > > +     u32 repeat = kattr->test.repeat;
> > > +     u32 retval = 0, duration = 0;
> > > +     int err = -EINVAL;
> > > +     u64 time_start, time_spent = 0;
> > > +     int i;
> > > +     struct perf_sample_data sample_data = {0, };
> > > +     struct perf_event event = {0, };
> > > +     struct bpf_perf_event_data_kern real_ctx = {0, };
> > > +     struct bpf_perf_event_data fake_ctx = {0, };
> > > +     struct bpf_perf_event_value value = {0, };
> > > +
> > > +     if (ctx_size_in != sizeof(fake_ctx))
> > > +             goto out;
> > > +     if (data_size_in != sizeof(value))
> > > +             goto out;
> > > +
> > > +     if (copy_from_user(&fake_ctx, ctx_in, ctx_size_in)) {
> > > +             err = -EFAULT;
> > > +             goto out;
> > > +     }
> > Move this to net/bpf/test_run.c? I have a bpf_ctx_init helper to deal
> > with ctx input, might save you some code above wrt ctx size/etc.
> 
> My impression about net/bpf/test_run.c was that it was a collection of
> helpers for test runs of the network-related BPF programs, because
> they are so similar to each other. So kernel/trace/bpf_trace.c looked
> like an obvious place for the test_run implementation since other perf
> trace BPF stuff was already there.
Maybe net/bpf/test_run.c should be renamed to kernel/bpf/test_run.c?

> And about bpf_ctx_init - looks useful as it seems to me that it
> handles the scenario where the size of the ctx struct grows, but still
> allows passing older version of the struct (thus smaller) from
> userspace for compatibility. Maybe that checking and copying part of
> the function could be moved into some non-static helper function, so I
> could use it and still skip the need for allocating memory for the
> context?
You can always make bpf_ctx_init non-static and export it.
But, again, consider adding your stuff to the net/bpf/test_run.c
and exporting only pe_prog_test_run. That way you can reuse
bpf_ctx_init and bpf_test_run.

Why do you care about memory allocation though? It's a one time
operation and doesn't affect the performance measurements.

> > > +     if (copy_from_user(&value, data_in, data_size_in)) {
> > > +             err = -EFAULT;
> > > +             goto out;
> > > +     }
> > > +
> > > +     real_ctx.regs = &fake_ctx.regs;
> > > +     real_ctx.data = &sample_data;
> > > +     real_ctx.event = &event;
> > > +     perf_sample_data_init(&sample_data, fake_ctx.addr,
> > > +                           fake_ctx.sample_period);
> > > +     event.cpu = smp_processor_id();
> > > +     event.oncpu = -1;
> > > +     event.state = PERF_EVENT_STATE_OFF;
> > > +     local64_set(&event.count, value.counter);
> > > +     event.total_time_enabled = value.enabled;
> > > +     event.total_time_running = value.running;
> > > +     /* make self as a leader - it is used only for checking the
> > > +      * state field
> > > +      */
> > > +     event.group_leader = &event;
> > > +
> > > +     /* slightly changed copy pasta from bpf_test_run() in
> > > +      * net/bpf/test_run.c
> > > +      */
> > > +     if (!repeat)
> > > +             repeat = 1;
> > > +
> > > +     rcu_read_lock();
> > > +     preempt_disable();
> > > +     time_start = ktime_get_ns();
> > > +     for (i = 0; i < repeat; i++) {
> > Any reason for not using bpf_test_run?
> 
> Two, mostly. One was that it is a static function and my code was
> elsewhere. Second was that it does some cgroup storage setup and I'm
> not sure if the perf event BPF program needs that.
You can always make it non-static.

Regarding cgroup storage: do we care? If you can see it affecting
your performance numbers, then yes, but you can try to measure to see
if it gives you any noticeable overhead. Maybe add an argument to
bpf_test_run to skip cgroup storage stuff?

> > > +             retval = BPF_PROG_RUN(prog, &real_ctx);
> > > +
> > > +             if (signal_pending(current)) {
> > > +                     err = -EINTR;
> > > +                     preempt_enable();
> > > +                     rcu_read_unlock();
> > > +                     goto out;
> > > +             }
> > > +
> > > +             if (need_resched()) {
> > > +                     time_spent += ktime_get_ns() - time_start;
> > > +                     preempt_enable();
> > > +                     rcu_read_unlock();
> > > +
> > > +                     cond_resched();
> > > +
> > > +                     rcu_read_lock();
> > > +                     preempt_disable();
> > > +                     time_start = ktime_get_ns();
> > > +             }
> > > +     }
> > > +     time_spent += ktime_get_ns() - time_start;
> > > +     preempt_enable();
> > > +     rcu_read_unlock();
> > > +
> > > +     do_div(time_spent, repeat);
> > > +     duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> > > +     /* end of slightly changed copy pasta from bpf_test_run() in
> > > +      * net/bpf/test_run.c
> > > +      */
> > > +
> > > +     if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval))) {
> > > +             err = -EFAULT;
> > > +             goto out;
> > > +     }
> > > +     if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration))) {
> > > +             err = -EFAULT;
> > > +             goto out;
> > > +     }
> > Can BPF program modify fake_ctx? Do we need/want to copy it back?
> 
> Reading the pe_prog_is_valid_access function tells me that it's not
> possible - the only type of valid access is read. So maybe I should be
> stricter about the requirements for the data_out and ctx_out sizes
> (should be zero or return -EINVAL).
Yes, better to explicitly prohibit anything that we don't support.

> > > +     err = 0;
> > > +out:
> > > +     trace_bpf_test_finish(&err);
> > > +     return err;
> > > +}
> > > +
> > >  const struct bpf_prog_ops perf_event_prog_ops = {
> > > +     .test_run       = pe_prog_test_run,
> > >  };
> > >
> > >  static DEFINE_MUTEX(bpf_event_mutex);
> > > diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > > index 471c1a5950d8..16e9e5824d14 100644
> > > --- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > > +++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > This should probably go in another patch.
> 
> Yeah, I was wondering about it. These changes are here to avoid
> breaking the tests, since perf event program can actually be run now
> and the test_run for perf event required certain sizes for ctx and
> data.
You need to make sure the context is optional, that way you don't break
any existing tests out in the wild and can move those changes to
another patch.

> So, I will either move them to a separate patch or rework the test_run
> for perf event to accept the size between 0 and sizeof(struct
> something), so the changes in tests maybe will not be necessary.
> 
> >
> > > @@ -13,6 +13,8 @@
> > >       },
> > >       .result = ACCEPT,
> > >       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +     .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +     .data_len = sizeof(struct bpf_perf_event_value),
> > >  },
> > >  {
> > >       "check bpf_perf_event_data->sample_period half load permitted",
> > > @@ -29,6 +31,8 @@
> > >       },
> > >       .result = ACCEPT,
> > >       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +     .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +     .data_len = sizeof(struct bpf_perf_event_value),
> > >  },
> > >  {
> > >       "check bpf_perf_event_data->sample_period word load permitted",
> > > @@ -45,6 +49,8 @@
> > >       },
> > >       .result = ACCEPT,
> > >       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +     .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +     .data_len = sizeof(struct bpf_perf_event_value),
> > >  },
> > >  {
> > >       "check bpf_perf_event_data->sample_period dword load permitted",
> > > @@ -56,4 +62,6 @@
> > >       },
> > >       .result = ACCEPT,
> > >       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +     .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +     .data_len = sizeof(struct bpf_perf_event_value),
> > >  },
> > > --
> > > 2.20.1
> > >
> 
> 
> 
> -- 
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Geschäftsführer/Directors: Alban Crequy, Chris Kühl, Iago López Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
