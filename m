Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5585587C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfFYUMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:12:22 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38792 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfFYUMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:12:22 -0400
Received: by mail-pl1-f193.google.com with SMTP id g4so46072plb.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=frdlJFxp0g7/JgxVC9Knu0EZuFk8912u7Wo1FVzUmns=;
        b=Nyb+zlMnDiYMzmLqnBAwdmngB+mYJdvquxfMDwCy5zvB7uhuZYJ965t0yuyadQ5fC5
         WAwMBqEhRzvXZJlWTFHp1eGTYXntKDuyWJIXRygR4w4aLx90JBuzG1YT5TqDklyjyWDe
         YbTaC2rHWCEpTr7osJsgtI2DVbvgnyErrAnRKB5vxim3CQ8qV6vzbBI0GRTZeExvFESj
         D7UvI9PzC50CDNlYR5vwX+gjDokE4WkOCypTdCQ0xFT4R+EYDTLtEFhmQ12/3aRbVPiL
         q55toOzREutJvOUWTydV4sxijBek67/XvKyV7usdzK/go45JI2h3Ted+6+e+4vyurgnt
         a5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=frdlJFxp0g7/JgxVC9Knu0EZuFk8912u7Wo1FVzUmns=;
        b=HPARuEuBek4o4ybf+c/lmT4w8obsBCC+1mjFCHoQj2IcJTqiZBi0VqgF+mtqqGWR3m
         wAFaXf4BHwZJhIhCyDdOD680NV2nHeZztuyAlwyS+zBfnBcrUKFYzUOZNJQ0WZ0uYFAC
         mb/4cUV+NZfXy8LaSj3Bov8tzu36gcsi9SJjD1p0PdcSO4YcwD2sMryJ4sudTunGOS2f
         7p8z+GwthaYPw9eSVaAptlqDJD39mNpkjAQ/nKDDnIMIFIwPxXDJU7tAPcmL0VZdddYY
         fFxkZDT/bZAeMPd1IRb2elinaZCZNyyDEgygf2Cx304Lxvv9S4+ZZOFQrXTEM505ZrFJ
         +6HA==
X-Gm-Message-State: APjAAAUney3s54RR5X1T7aHRJLHrewKhzk2u1KACgqV3V+i2U3TTjJOj
        NGJppYVmI1+H0VwkTQm+TRO8Sg==
X-Google-Smtp-Source: APXvYqz5A8wkwC4bDX9Grozu3DdnvL4TZkl+WU84TSLtrBEe3ie0duREqD7ndDM6yIZbjMI4EQ0Hpw==
X-Received: by 2002:a17:902:8207:: with SMTP id x7mr544236pln.63.1561493541558;
        Tue, 25 Jun 2019 13:12:21 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j21sm16301529pfh.86.2019.06.25.13.12.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:12:21 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:12:20 -0700
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
Message-ID: <20190625201220.GC10487@mini-arch>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
 <20190625194215.14927-9-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625194215.14927-9-krzesimir@kinvolk.io>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25, Krzesimir Nowak wrote:
> As an input, test run for perf event program takes struct
> bpf_perf_event_data as ctx_in and struct bpf_perf_event_value as
> data_in. For an output, it basically ignores ctx_out and data_out.
> 
> The implementation sets an instance of struct bpf_perf_event_data_kern
> in such a way that the BPF program reading data from context will
> receive what we passed to the bpf prog test run in ctx_in. Also BPF
> program can call bpf_perf_prog_read_value to receive what was passed
> in data_in.
> 
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  kernel/trace/bpf_trace.c                      | 107 ++++++++++++++++++
>  .../bpf/verifier/perf_event_sample_period.c   |   8 ++
>  2 files changed, 115 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index c102c240bb0b..2fa49ea8a475 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -16,6 +16,8 @@
>  
>  #include <asm/tlb.h>
>  
> +#include <trace/events/bpf_test_run.h>
> +
>  #include "trace_probe.h"
>  #include "trace.h"
>  
> @@ -1160,7 +1162,112 @@ const struct bpf_verifier_ops perf_event_verifier_ops = {
>  	.convert_ctx_access	= pe_prog_convert_ctx_access,
>  };
>  
> +static int pe_prog_test_run(struct bpf_prog *prog,
> +			    const union bpf_attr *kattr,
> +			    union bpf_attr __user *uattr)
> +{
> +	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> +	u32 data_size_in = kattr->test.data_size_in;
> +	u32 ctx_size_in = kattr->test.ctx_size_in;
> +	u32 repeat = kattr->test.repeat;
> +	u32 retval = 0, duration = 0;
> +	int err = -EINVAL;
> +	u64 time_start, time_spent = 0;
> +	int i;
> +	struct perf_sample_data sample_data = {0, };
> +	struct perf_event event = {0, };
> +	struct bpf_perf_event_data_kern real_ctx = {0, };
> +	struct bpf_perf_event_data fake_ctx = {0, };
> +	struct bpf_perf_event_value value = {0, };
> +
> +	if (ctx_size_in != sizeof(fake_ctx))
> +		goto out;
> +	if (data_size_in != sizeof(value))
> +		goto out;
> +
> +	if (copy_from_user(&fake_ctx, ctx_in, ctx_size_in)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
Move this to net/bpf/test_run.c? I have a bpf_ctx_init helper to deal
with ctx input, might save you some code above wrt ctx size/etc.

> +	if (copy_from_user(&value, data_in, data_size_in)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	real_ctx.regs = &fake_ctx.regs;
> +	real_ctx.data = &sample_data;
> +	real_ctx.event = &event;
> +	perf_sample_data_init(&sample_data, fake_ctx.addr,
> +			      fake_ctx.sample_period);
> +	event.cpu = smp_processor_id();
> +	event.oncpu = -1;
> +	event.state = PERF_EVENT_STATE_OFF;
> +	local64_set(&event.count, value.counter);
> +	event.total_time_enabled = value.enabled;
> +	event.total_time_running = value.running;
> +	/* make self as a leader - it is used only for checking the
> +	 * state field
> +	 */
> +	event.group_leader = &event;
> +
> +	/* slightly changed copy pasta from bpf_test_run() in
> +	 * net/bpf/test_run.c
> +	 */
> +	if (!repeat)
> +		repeat = 1;
> +
> +	rcu_read_lock();
> +	preempt_disable();
> +	time_start = ktime_get_ns();
> +	for (i = 0; i < repeat; i++) {
Any reason for not using bpf_test_run?

> +		retval = BPF_PROG_RUN(prog, &real_ctx);
> +
> +		if (signal_pending(current)) {
> +			err = -EINTR;
> +			preempt_enable();
> +			rcu_read_unlock();
> +			goto out;
> +		}
> +
> +		if (need_resched()) {
> +			time_spent += ktime_get_ns() - time_start;
> +			preempt_enable();
> +			rcu_read_unlock();
> +
> +			cond_resched();
> +
> +			rcu_read_lock();
> +			preempt_disable();
> +			time_start = ktime_get_ns();
> +		}
> +	}
> +	time_spent += ktime_get_ns() - time_start;
> +	preempt_enable();
> +	rcu_read_unlock();
> +
> +	do_div(time_spent, repeat);
> +	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> +	/* end of slightly changed copy pasta from bpf_test_run() in
> +	 * net/bpf/test_run.c
> +	 */
> +
> +	if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval))) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +	if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration))) {
> +		err = -EFAULT;
> +		goto out;
> +	}
Can BPF program modify fake_ctx? Do we need/want to copy it back?

> +	err = 0;
> +out:
> +	trace_bpf_test_finish(&err);
> +	return err;
> +}
> +
>  const struct bpf_prog_ops perf_event_prog_ops = {
> +	.test_run	= pe_prog_test_run,
>  };
>  
>  static DEFINE_MUTEX(bpf_event_mutex);
> diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> index 471c1a5950d8..16e9e5824d14 100644
> --- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> +++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
This should probably go in another patch.

> @@ -13,6 +13,8 @@
>  	},
>  	.result = ACCEPT,
>  	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +	.ctx_len = sizeof(struct bpf_perf_event_data),
> +	.data_len = sizeof(struct bpf_perf_event_value),
>  },
>  {
>  	"check bpf_perf_event_data->sample_period half load permitted",
> @@ -29,6 +31,8 @@
>  	},
>  	.result = ACCEPT,
>  	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +	.ctx_len = sizeof(struct bpf_perf_event_data),
> +	.data_len = sizeof(struct bpf_perf_event_value),
>  },
>  {
>  	"check bpf_perf_event_data->sample_period word load permitted",
> @@ -45,6 +49,8 @@
>  	},
>  	.result = ACCEPT,
>  	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +	.ctx_len = sizeof(struct bpf_perf_event_data),
> +	.data_len = sizeof(struct bpf_perf_event_value),
>  },
>  {
>  	"check bpf_perf_event_data->sample_period dword load permitted",
> @@ -56,4 +62,6 @@
>  	},
>  	.result = ACCEPT,
>  	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +	.ctx_len = sizeof(struct bpf_perf_event_data),
> +	.data_len = sizeof(struct bpf_perf_event_value),
>  },
> -- 
> 2.20.1
> 
