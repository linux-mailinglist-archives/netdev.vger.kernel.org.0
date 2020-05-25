Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF801E07A7
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgEYHS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388944AbgEYHSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 03:18:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A449DC061A0E;
        Mon, 25 May 2020 00:18:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e1so16109302wrt.5;
        Mon, 25 May 2020 00:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JtH+z7APn0Fnoh3UAtKkBHqcxT9UaYRNXhJ22yGFre0=;
        b=WGhe/+UODI8/TwXArBXWq/IZ+dmJfrLVLhCukywsZXbTFk35eArC0HqfMJYfXTF2w2
         WUQB9RZXkzBuKMCpC9Kt6RGmoAWbNdJIQS/3jU2soPmEPT1rqXSQADzg+ZzAOkKbsK6n
         Qq01Cb1oJETfkyRKfx8nNSNCqIjz75s+Z2iUfDMPj4HlqCxN6/r/Vuowp+pwNvxn0ux9
         goccz/YRyTKCQwvk3y/0omPIRryahtharUeWbUWlc3I0LGzTxirPFkP+PchyLhLn3RoY
         lpQ+aJvx5bgT6qR+zgOxV62aXBNsAkpJfz00fSpLHeD/wlz0vRVSDoojsXufmhaVNs9g
         YPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JtH+z7APn0Fnoh3UAtKkBHqcxT9UaYRNXhJ22yGFre0=;
        b=WSO09Wtpr/ujSpoFuUXuJgREVAk6866jt/Ol9PQhbuX6KQRMW0qiL/fOuJc8c22IsR
         pVZjyZZMb5Ruw5wQYloIlN1/gtlWXCn/t7ppSFcR7DFp4THdB5LG9BA7B1P7APxbHYU6
         pxKsxlsVmG/sYYfy+2sRh8+rV0+xnPZfxuxiZzaDL5Ru5Lah8LjTwtPn1DWB/XNiMF7z
         wabNZyhN4vIPrZJIDe+TtOyumewmzU4Tj64GlmgjEX3q2TphU+gtw7WRgO0jsKtrJWGx
         0co9RLyGGqzJRvd7kjBt41CDcM0seWSvn3Y6ckdh+XKU6EZ5Cp5DYoxOx4STrUQb2P1t
         N8EA==
X-Gm-Message-State: AOAM533d5xna6NOKXMi6JENuyUmwR4t8T4sYjdJbujiMCJf88f9ny9ZR
        pzqVizaFiA52ofHivwiqNx4=
X-Google-Smtp-Source: ABdhPJzYT3KdXsIrKYqjw2iMpUAJITBSxyKRiejdMaqQsxzgj2EeIConCw8CQNUuuDceFY3e8ihSkg==
X-Received: by 2002:a5d:4312:: with SMTP id h18mr13841074wrq.393.1590391102403;
        Mon, 25 May 2020 00:18:22 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id d6sm18638056wrj.90.2020.05.25.00.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 00:18:21 -0700 (PDT)
Date:   Mon, 25 May 2020 09:18:19 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/7] connector/cn_proc: Protect send_msg() with a
 local lock
Message-ID: <20200525071819.GD329373@gmail.com>
References: <20200524215739.551568-1-bigeasy@linutronix.de>
 <20200524215739.551568-6-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524215739.551568-6-bigeasy@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> From: Mike Galbraith <umgwanakikbuti@gmail.com>
> 
> send_msg() disables preemption to avoid out-of-order messages. As the
> code inside the preempt disabled section acquires regular spinlocks,
> which are converted to 'sleeping' spinlocks on a PREEMPT_RT kernel and
> eventually calls into a memory allocator, this conflicts with the RT
> semantics.
> 
> Convert it to a local_lock which allows RT kernels to substitute them with
> a real per CPU lock. On non RT kernels this maps to preempt_disable() as
> before. No functional change.
> 
> [bigeasy: Patch description]
> 
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/connector/cn_proc.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index d58ce664da843..d424d1f469136 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -18,6 +18,7 @@
>  #include <linux/pid_namespace.h>
>  
>  #include <linux/cn_proc.h>
> +#include <linux/locallock.h>
>  
>  /*
>   * Size of a cn_msg followed by a proc_event structure.  Since the
> @@ -38,25 +39,32 @@ static inline struct cn_msg *buffer_to_cn_msg(__u8 *buffer)
>  static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
>  static struct cb_id cn_proc_event_id = { CN_IDX_PROC, CN_VAL_PROC };
>  
> -/* proc_event_counts is used as the sequence number of the netlink message */
> -static DEFINE_PER_CPU(__u32, proc_event_counts) = { 0 };
> +/* local_evt.counts is used as the sequence number of the netlink message */
> +struct local_evt {
> +	__u32 counts;
> +	struct local_lock lock;
> +};
> +static DEFINE_PER_CPU(struct local_evt, local_evt) = {
> +	.counts = 0,

I don't think zero initializations need to be written out explicitly.

> +	.lock = INIT_LOCAL_LOCK(lock),
> +};
>  
>  static inline void send_msg(struct cn_msg *msg)
>  {
> -	preempt_disable();
> +	local_lock(&local_evt.lock);
>  
> -	msg->seq = __this_cpu_inc_return(proc_event_counts) - 1;
> +	msg->seq = __this_cpu_inc_return(local_evt.counts) - 1;

Naming nit: renaming this from 'proc_event_counts' to 
'local_evt.counts' is a step back IMO - what's an 'evt',
did we run out of e's? ;-)

Should be something like local_event.count? (Singular.)

Thanks,

	Ingo
