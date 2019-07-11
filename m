Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4814C660AF
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 22:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfGKUbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 16:31:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40422 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbfGKUbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 16:31:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so3612918pla.7
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 13:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TV2jSvn5SJbiANqesUZ+all03sCywDkc0brqJHcrz/s=;
        b=AQ3DbKxl1VudFwp2u0IRGvRKW0ik5qJpVbipJChEW6DyoxnPSNQmHAV/H5i6kL76WF
         ZTj5PmgZHQ+Us8ylLM97QgZFpqYL8ZlRtYjJjZrJPE83dV2zmTv7ldWIQRJfPx2cgdrJ
         91yMy5y+Fc5ZL2nQr7uABfRScoBToPqUQC+5zQJKQ5qzpUqV9gqWM9shlCUZca4vqGva
         CIa7yvmdP/CyV25Y1szokHevNdrtgRmsVXAvYxv32I/79hY2/Z0SfgOaO9CBUQyLTWn4
         NjQayNG+PwaHvmB7loPSmM7/mnn4YO5zAcV7znJTLoRU79XWs+p/0gZCIL9Dkd9IbTUB
         eXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TV2jSvn5SJbiANqesUZ+all03sCywDkc0brqJHcrz/s=;
        b=NDv5gpbxMqM5I0rpHh0Q0ik1lET7Wark+UblL4B7kGpY9YnZTNACx8sBmibbYD/q5C
         KGNBguDkcCJCLJYxIQLqOqpYlr69N1R5vA19voPwsskX3l6JAMDWqnxbfUKsS0Jpnmo8
         tzXa2fYbKqY3IC280bm+wU5YV0MRPtWaHKpxzuiK1X3661E5HIWWWO5Jz8bLRqlFRgZb
         8rc5/YnWN3lcfaILEpm2j8adcBAlmz9srXUXCM4ajC98e65wwdQIF66g7Ow/eEJds4sh
         OObkaK6yw1Q/0Y5x7vlQLrBmuS5ldearKcoMCmA6i/Izbpc8qTE/x62h7jbrq9lfrHDq
         jsLw==
X-Gm-Message-State: APjAAAWA1YR/FvKvYsuG9cW79rdRw+fvt/TeaADeplq0yT7HQW6fo3Xi
        swBCZ8ok0z8heLE620322RM=
X-Google-Smtp-Source: APXvYqz1HiiGkIF3jM4roVcn1A3U9HeG/I2Oi5xsnkmPIbL4o2zcAH8p7IgPBemIwtw1cVptETOBMg==
X-Received: by 2002:a17:902:3283:: with SMTP id z3mr6758105plb.176.1562877065317;
        Thu, 11 Jul 2019 13:31:05 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s66sm7073008pfs.8.2019.07.11.13.30.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 13:30:59 -0700 (PDT)
Date:   Thu, 11 Jul 2019 13:30:59 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     linux-kernel@vger.kernel.org, Alban Crequy <alban@kinvolk.io>,
        Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org
Subject: Re: [bpf-next v3 10/12] bpf: Implement bpf_prog_test_run for perf
 event programs
Message-ID: <20190711203059.GB16709@mini-arch>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
 <20190708163121.18477-11-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708163121.18477-11-krzesimir@kinvolk.io>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08, Krzesimir Nowak wrote:
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
> Changes since v2:
> - drop the changes in perf event verifier test - they are not needed
>   anymore after reworked ctx size handling
> 
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  kernel/trace/bpf_trace.c | 60 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ca1255d14576..b870fc2314d0 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -19,6 +19,8 @@
>  #include "trace_probe.h"
>  #include "trace.h"
>  
> +#include <trace/events/bpf_test_run.h>
> +
>  #define bpf_event_rcu_dereference(p)					\
>  	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
>  
> @@ -1160,7 +1162,65 @@ const struct bpf_verifier_ops perf_event_verifier_ops = {
>  	.convert_ctx_access	= pe_prog_convert_ctx_access,
>  };
>  
> +static int pe_prog_test_run(struct bpf_prog *prog,
> +			    const union bpf_attr *kattr,
> +			    union bpf_attr __user *uattr)
> +{
> +	struct bpf_perf_event_data_kern real_ctx = {0, };
> +	struct perf_sample_data sample_data = {0, };
> +	struct bpf_perf_event_data *fake_ctx;
> +	struct bpf_perf_event_value *value;
> +	struct perf_event event = {0, };
> +	u32 retval = 0, duration = 0;
> +	int err;
> +
> +	if (kattr->test.data_size_out || kattr->test.data_out)
> +		return -EINVAL;
> +	if (kattr->test.ctx_size_out || kattr->test.ctx_out)
> +		return -EINVAL;
> +
> +	fake_ctx = bpf_receive_ctx(kattr, sizeof(struct bpf_perf_event_data));
> +	if (IS_ERR(fake_ctx))
> +		return PTR_ERR(fake_ctx);
> +
> +	value = bpf_receive_data(kattr, sizeof(struct bpf_perf_event_value));
> +	if (IS_ERR(value)) {
> +		kfree(fake_ctx);
> +		return PTR_ERR(value);
> +	}
nit: maybe use bpf_test_ prefix for receive_ctx/data:
* bpf_test_receive_ctx
* bpf_test_receive_data

? To signify that they are used for tests only.

> +
> +	real_ctx.regs = &fake_ctx->regs;
> +	real_ctx.data = &sample_data;
> +	real_ctx.event = &event;
> +	perf_sample_data_init(&sample_data, fake_ctx->addr,
> +			      fake_ctx->sample_period);
> +	event.cpu = smp_processor_id();
> +	event.oncpu = -1;
> +	event.state = PERF_EVENT_STATE_OFF;
> +	local64_set(&event.count, value->counter);
> +	event.total_time_enabled = value->enabled;
> +	event.total_time_running = value->running;
> +	/* make self as a leader - it is used only for checking the
> +	 * state field
> +	 */
> +	event.group_leader = &event;
> +	err = bpf_test_run(prog, &real_ctx, kattr->test.repeat,
> +			   BPF_TEST_RUN_PLAIN, &retval, &duration);
> +	if (err) {
> +		kfree(value);
> +		kfree(fake_ctx);
> +		return err;
> +	}
> +
> +	err = bpf_test_finish(uattr, retval, duration);
> +	trace_bpf_test_finish(&err);
Can probably do:

	err = bpf_test_run(...)
	if (!err) {
		err = bpf_test_finish(uattr, retval, duration);
		trace_bpf_test_finish(&err);
	}
	kfree(..);
	kfree(..);
	return err;

So you don't have to copy-paste the error handling.

> +	kfree(value);
> +	kfree(fake_ctx);
> +	return err;
> +}
> +
>  const struct bpf_prog_ops perf_event_prog_ops = {
> +	.test_run	= pe_prog_test_run,
>  };
>  
>  static DEFINE_MUTEX(bpf_event_mutex);
> -- 
> 2.20.1
> 
