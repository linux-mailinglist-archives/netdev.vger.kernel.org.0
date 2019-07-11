Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139166088
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 22:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfGKUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 16:25:50 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41318 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbfGKUZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 16:25:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so3588339pls.8
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 13:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xHxfY+WF+f29ODCxsuN6WurKEvtCVRVsIcJu6ZKOQjc=;
        b=VN8+pPFlmbpD4l3hB+BNBlmkUMHgcJFUqfrILzVT94NShGYc7PT6DEn/3KSCLS7WOU
         iG0BPRB6VP6clMjRMrHu4ACtoYOJ1BO9Tzf2skFGzKwo9skhJN07zLe8zdC3ci59a3RE
         4Dsw0TpCZXwcjCCyFiY+WAYZ66xu69YqonendBD1gdFdbaSGO+AwZQCPzPXgKJHoHGFd
         owksRFQflazJnvvQJfgRQ5RWJ+KaCvQrqYdxXmBWhLwO7/QGWNIZBE2BsIsqsoRsEIDA
         t/3vJp3qY8G/+wo4oCMIRkkF0kohvDi8OIKXHOcrPr078V7X8oOEmxWFT2nWwc8LnW2W
         EFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xHxfY+WF+f29ODCxsuN6WurKEvtCVRVsIcJu6ZKOQjc=;
        b=R2H7pzMjIHkG4TpZPvWfF5L7dnnSBnYkhxOlws/rx7EnoJS6NGzN6V8peAQyPPz0d4
         fpmZJ29lY6mb+10SYllKI4l8DfH9y9J2SWu+1MFbFQCIt0WUL9KRZN4ZgT931vlpVCit
         JDb8+8E90KfKZoVWv7dP3XeqrSOl+gWN3VmtXpSGHVqB1VawqsE2hECJ6YtYoxGRyGWA
         QaulPIHztWJoaECyTqYlT8BYyaJ1CkMy7jRh9cAAeUt1e+n9eHV4Gkn5GhhQOx6gJV+J
         XgSXrk2sTdbBL04z9xmd6QG9teXGwK4bey+qeiJ0WkQiESPwlf4Hd9sVMFdPooKKHG2n
         jXLg==
X-Gm-Message-State: APjAAAWWwc6rK1rhqKvmg0zQO1xvnVEUsH2wHgOTu0Vv6b4iLsXWyv1G
        NnXOzSyUHF9S3Vhxkaa8T+c=
X-Google-Smtp-Source: APXvYqzDphHKDSvXKt0LP6Rvm+rOyir65TpJqMxDi129ctwni7rUQe+ck6dnMPUY9EjJ6yycPX4bnQ==
X-Received: by 2002:a17:902:403:: with SMTP id 3mr6645054ple.66.1562876748050;
        Thu, 11 Jul 2019 13:25:48 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g18sm9641429pgm.9.2019.07.11.13.25.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 13:25:45 -0700 (PDT)
Date:   Thu, 11 Jul 2019 13:25:44 -0700
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
Subject: Re: [bpf-next v3 09/12] bpf: Split out some helper functions
Message-ID: <20190711202544.GA16709@mini-arch>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
 <20190708163121.18477-10-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708163121.18477-10-krzesimir@kinvolk.io>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08, Krzesimir Nowak wrote:
> The moved functions are generally useful for implementing
> bpf_prog_test_run for other types of BPF programs - they don't have
> any network-specific stuff in them, so I can use them in a test run
> implementation for perf event BPF program too.
It's a bit hard to follow. Maybe split into multiple patches?
First one moves the relevant parts as is.
Second one renames (though, I'm not sure we need to rename, but up to
you/maintainers).
Third one removes duplication from bpf_prog_test_run_flow_dissector.

Also see possible suggestion on BPF_TEST_RUN_SETUP_CGROUP_STORAGE below.

> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  include/linux/bpf.h   |  28 +++++
>  kernel/bpf/Makefile   |   1 +
>  kernel/bpf/test_run.c | 212 ++++++++++++++++++++++++++++++++++
>  net/bpf/test_run.c    | 263 +++++++++++-------------------------------
>  4 files changed, 308 insertions(+), 196 deletions(-)
>  create mode 100644 kernel/bpf/test_run.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 18f4cc2c6acd..28db8ba57bc3 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1143,4 +1143,32 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
>  }
>  #endif /* CONFIG_INET */
>  
> +/* Helper functions for bpf_prog_test_run implementations */
> +typedef u32 bpf_prog_run_helper_t(struct bpf_prog *prog, void *ctx,
> +				   void *private_data);
> +
> +enum bpf_test_run_flags {
> +	BPF_TEST_RUN_PLAIN = 0,
> +	BPF_TEST_RUN_SETUP_CGROUP_STORAGE = 1 << 0,
> +};
> +
> +int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags,
> +		 u32 *retval, u32 *duration);
> +
> +int bpf_test_run_cb(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags,
> +		    bpf_prog_run_helper_t run_prog, void *private_data,
> +		    u32 *retval, u32 *duration);
> +
> +int bpf_test_finish(union bpf_attr __user *uattr, u32 retval, u32 duration);
> +
> +void *bpf_receive_ctx(const union bpf_attr *kattr, u32 max_size);
> +
> +int bpf_send_ctx(const union bpf_attr *kattr, union bpf_attr __user *uattr,
> +		 const void *data, u32 size);
> +
> +void *bpf_receive_data(const union bpf_attr *kattr, u32 max_size);
> +
> +int bpf_send_data(const union bpf_attr *kattr, union bpf_attr __user *uattr,
> +		  const void *data, u32 size);
> +
>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 29d781061cd5..570fd40288f4 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>  ifeq ($(CONFIG_INET),y)
>  obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
>  endif
> +obj-$(CONFIG_BPF_SYSCALL) += test_run.o
> diff --git a/kernel/bpf/test_run.c b/kernel/bpf/test_run.c
> new file mode 100644
> index 000000000000..0481373da8be
> --- /dev/null
> +++ b/kernel/bpf/test_run.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2017 Facebook
> + * Copyright (c) 2019 Tigera, Inc
> + */
> +
> +#include <asm/div64.h>
> +
> +#include <linux/bpf-cgroup.h>
> +#include <linux/bpf.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/filter.h>
> +#include <linux/gfp.h>
> +#include <linux/kernel.h>
> +#include <linux/limits.h>
> +#include <linux/preempt.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +#include <linux/timekeeping.h>
> +#include <linux/uaccess.h>
> +
> +static void teardown_cgroup_storage(struct bpf_cgroup_storage **storage)
> +{
> +	enum bpf_cgroup_storage_type stype;
> +
> +	if (!storage)
> +		return;
> +	for_each_cgroup_storage_type(stype)
> +		bpf_cgroup_storage_free(storage[stype]);
> +	kfree(storage);
> +}
> +
> +static struct bpf_cgroup_storage **setup_cgroup_storage(struct bpf_prog *prog)
> +{
> +	enum bpf_cgroup_storage_type stype;
> +	struct bpf_cgroup_storage **storage;
> +	size_t size = MAX_BPF_CGROUP_STORAGE_TYPE;
> +
> +	size *= sizeof(struct bpf_cgroup_storage *);
> +	storage = kzalloc(size, GFP_KERNEL);
> +	for_each_cgroup_storage_type(stype) {
> +		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
> +		if (IS_ERR(storage[stype])) {
> +			storage[stype] = NULL;
> +			teardown_cgroup_storage(storage);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}
> +	return storage;
> +}
> +
> +static u32 run_bpf_prog(struct bpf_prog *prog, void *ctx, void *private_data)
> +{
> +	return BPF_PROG_RUN(prog, ctx);
> +}
> +
> +int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags,
> +		 u32 *retval, u32 *duration)
> +{
> +	return bpf_test_run_cb(prog, ctx, repeat, flags, run_bpf_prog, NULL,
> +			       retval, duration);
> +}
> +
> +int bpf_test_run_cb(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags,
> +		    bpf_prog_run_helper_t run_prog, void *private_data,
> +		    u32 *retval, u32 *duration)
> +{
> +	struct bpf_cgroup_storage **storage = NULL;
> +	u64 time_start, time_spent = 0;
> +	int ret = 0;
> +	u32 i;
> +
> +	if (flags & BPF_TEST_RUN_SETUP_CGROUP_STORAGE) {
You can maybe get away without a flag. prog->aux->cgroup_storage[x] has
a non-zero pointer if verifier found out that the prog is using cgroup
storage. bpf_cgroup_storage_alloc returns NULL is the program doesn't
use cgroup storage. So you should be able to dynamically figure out
whether you need to call bpf_cgroup_storage_set or not.

> +		storage = setup_cgroup_storage(prog);
> +		if (IS_ERR(storage))
> +			return PTR_ERR(storage);
> +	}
> +
> +	if (!repeat)
> +		repeat = 1;
> +
> +	rcu_read_lock();
> +	preempt_disable();
> +	time_start = ktime_get_ns();
> +	for (i = 0; i < repeat; i++) {
> +		if (storage)
> +			bpf_cgroup_storage_set(storage);
> +		*retval = run_prog(prog, ctx, private_data);
> +
> +		if (signal_pending(current)) {
> +			preempt_enable();
> +			rcu_read_unlock();
> +			teardown_cgroup_storage(storage);
> +			return -EINTR;
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
> +	*duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> +
> +	teardown_cgroup_storage(storage);
> +
> +	return ret;
> +}
> +
> +int bpf_test_finish(union bpf_attr __user *uattr, u32 retval, u32 duration)
> +{
> +	if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)))
> +		return -EFAULT;
> +	if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static void *bpf_receive_mem(u64 in, u32 in_size, u32 max_size)
> +{
> +	void __user *data_in = u64_to_user_ptr(in);
> +	void *data;
> +	int err;
> +
> +	if (!data_in && in_size)
> +		return ERR_PTR(-EINVAL);
> +	data = kzalloc(max_size, GFP_USER);
> +	if (!data)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (data_in) {
> +		err = bpf_check_uarg_tail_zero(data_in, max_size, in_size);
> +		if (err) {
> +			kfree(data);
> +			return ERR_PTR(err);
> +		}
> +
> +		in_size = min_t(u32, max_size, in_size);
> +		if (copy_from_user(data, data_in, in_size)) {
> +			kfree(data);
> +			return ERR_PTR(-EFAULT);
> +		}
> +	}
> +	return data;
> +}
> +
> +static int bpf_send_mem(u64 out, u32 out_size, u32 *out_size_write,
> +                        const void *data, u32 data_size)
> +{
> +	void __user *data_out = u64_to_user_ptr(out);
> +	int err = -EFAULT;
> +	u32 copy_size = data_size;
> +
> +	if (!data_out && out_size)
> +		return -EINVAL;
> +
> +	if (!data || !data_out)
> +		return 0;
> +
> +	if (copy_size > out_size) {
> +		copy_size = out_size;
> +		err = -ENOSPC;
> +	}
> +
> +	if (copy_to_user(data_out, data, copy_size))
> +		goto out;
> +	if (copy_to_user(out_size_write, &data_size, sizeof(data_size)))
> +		goto out;
> +	if (err != -ENOSPC)
> +		err = 0;
> +out:
> +	return err;
> +}
> +
> +void *bpf_receive_data(const union bpf_attr *kattr, u32 max_size)
> +{
> +	return bpf_receive_mem(kattr->test.data_in, kattr->test.data_size_in,
> +                               max_size);
> +}
> +
> +int bpf_send_data(const union bpf_attr *kattr, union bpf_attr __user *uattr,
> +                  const void *data, u32 size)
> +{
> +	return bpf_send_mem(kattr->test.data_out, kattr->test.data_size_out,
> +			    &uattr->test.data_size_out, data, size);
> +}
> +
> +void *bpf_receive_ctx(const union bpf_attr *kattr, u32 max_size)
> +{
> +	return bpf_receive_mem(kattr->test.ctx_in, kattr->test.ctx_size_in,
> +                               max_size);
> +}
> +
> +int bpf_send_ctx(const union bpf_attr *kattr, union bpf_attr __user *uattr,
> +                 const void *data, u32 size)
> +{
> +        return bpf_send_mem(kattr->test.ctx_out, kattr->test.ctx_size_out,
> +                            &uattr->test.ctx_size_out, data, size);
> +}
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 80e6f3a6864d..fe6b7b1af0cc 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -14,97 +14,6 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/bpf_test_run.h>
>  
> -static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
> -			u32 *retval, u32 *time)
> -{
> -	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
> -	enum bpf_cgroup_storage_type stype;
> -	u64 time_start, time_spent = 0;
> -	int ret = 0;
> -	u32 i;
> -
> -	for_each_cgroup_storage_type(stype) {
> -		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
> -		if (IS_ERR(storage[stype])) {
> -			storage[stype] = NULL;
> -			for_each_cgroup_storage_type(stype)
> -				bpf_cgroup_storage_free(storage[stype]);
> -			return -ENOMEM;
> -		}
> -	}
> -
> -	if (!repeat)
> -		repeat = 1;
> -
> -	rcu_read_lock();
> -	preempt_disable();
> -	time_start = ktime_get_ns();
> -	for (i = 0; i < repeat; i++) {
> -		bpf_cgroup_storage_set(storage);
> -		*retval = BPF_PROG_RUN(prog, ctx);
> -
> -		if (signal_pending(current)) {
> -			ret = -EINTR;
> -			break;
> -		}
> -
> -		if (need_resched()) {
> -			time_spent += ktime_get_ns() - time_start;
> -			preempt_enable();
> -			rcu_read_unlock();
> -
> -			cond_resched();
> -
> -			rcu_read_lock();
> -			preempt_disable();
> -			time_start = ktime_get_ns();
> -		}
> -	}
> -	time_spent += ktime_get_ns() - time_start;
> -	preempt_enable();
> -	rcu_read_unlock();
> -
> -	do_div(time_spent, repeat);
> -	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> -
> -	for_each_cgroup_storage_type(stype)
> -		bpf_cgroup_storage_free(storage[stype]);
> -
> -	return ret;
> -}
> -
> -static int bpf_test_finish(const union bpf_attr *kattr,
> -			   union bpf_attr __user *uattr, const void *data,
> -			   u32 size, u32 retval, u32 duration)
> -{
> -	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
> -	int err = -EFAULT;
> -	u32 copy_size = size;
> -
> -	/* Clamp copy if the user has provided a size hint, but copy the full
> -	 * buffer if not to retain old behaviour.
> -	 */
> -	if (kattr->test.data_size_out &&
> -	    copy_size > kattr->test.data_size_out) {
> -		copy_size = kattr->test.data_size_out;
> -		err = -ENOSPC;
> -	}
> -
> -	if (data_out && copy_to_user(data_out, data, copy_size))
> -		goto out;
> -	if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size)))
> -		goto out;
> -	if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)))
> -		goto out;
> -	if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration)))
> -		goto out;
> -	if (err != -ENOSPC)
> -		err = 0;
> -out:
> -	trace_bpf_test_finish(&err);
> -	return err;
> -}
> -
>  static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
>  			   u32 headroom, u32 tailroom)
>  {
> @@ -125,63 +34,6 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
>  	return data;
>  }
>  
> -static void *bpf_ctx_init(const union bpf_attr *kattr, u32 max_size)
> -{
> -	void __user *data_in = u64_to_user_ptr(kattr->test.ctx_in);
> -	void __user *data_out = u64_to_user_ptr(kattr->test.ctx_out);
> -	u32 size = kattr->test.ctx_size_in;
> -	void *data;
> -	int err;
> -
> -	if (!data_in && !data_out)
> -		return NULL;
> -
> -	data = kzalloc(max_size, GFP_USER);
> -	if (!data)
> -		return ERR_PTR(-ENOMEM);
> -
> -	if (data_in) {
> -		err = bpf_check_uarg_tail_zero(data_in, max_size, size);
> -		if (err) {
> -			kfree(data);
> -			return ERR_PTR(err);
> -		}
> -
> -		size = min_t(u32, max_size, size);
> -		if (copy_from_user(data, data_in, size)) {
> -			kfree(data);
> -			return ERR_PTR(-EFAULT);
> -		}
> -	}
> -	return data;
> -}
> -
> -static int bpf_ctx_finish(const union bpf_attr *kattr,
> -			  union bpf_attr __user *uattr, const void *data,
> -			  u32 size)
> -{
> -	void __user *data_out = u64_to_user_ptr(kattr->test.ctx_out);
> -	int err = -EFAULT;
> -	u32 copy_size = size;
> -
> -	if (!data || !data_out)
> -		return 0;
> -
> -	if (copy_size > kattr->test.ctx_size_out) {
> -		copy_size = kattr->test.ctx_size_out;
> -		err = -ENOSPC;
> -	}
> -
> -	if (copy_to_user(data_out, data, copy_size))
> -		goto out;
> -	if (copy_to_user(&uattr->test.ctx_size_out, &size, sizeof(size)))
> -		goto out;
> -	if (err != -ENOSPC)
> -		err = 0;
> -out:
> -	return err;
> -}
> -
>  /**
>   * range_is_zero - test whether buffer is initialized
>   * @buf: buffer to check
> @@ -238,6 +90,36 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
>  	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
>  }
>  
> +static int bpf_net_prog_test_run_finish(const union bpf_attr *kattr,
> +                                        union bpf_attr __user *uattr,
> +                                        const void *data, u32 data_size,
> +                                        const void *ctx, u32 ctx_size,
> +                                        u32 retval, u32 duration)
> +{
> +	int ret;
> +	union bpf_attr fixed_kattr;
> +	const union bpf_attr *kattr_ptr = kattr;
> +
> +	/* Clamp copy (in bpf_send_mem) if the user has provided a
> +	 * size hint, but copy the full buffer if not to retain old
> +	 * behaviour.
> +	 */
> +	if (!kattr->test.data_size_out && kattr->test.data_out) {
> +		fixed_kattr = *kattr;
> +		fixed_kattr.test.data_size_out = U32_MAX;
> +		kattr_ptr = &fixed_kattr;
> +	}
> +
> +	ret = bpf_send_data(kattr_ptr, uattr, data, data_size);
> +	if (!ret) {
> +		ret = bpf_test_finish(uattr, retval, duration);
> +		if (!ret && ctx)
> +			ret = bpf_send_ctx(kattr_ptr, uattr, ctx, ctx_size);
> +	}
> +	trace_bpf_test_finish(&ret);
> +	return ret;
> +}
> +
>  int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  			  union bpf_attr __user *uattr)
>  {
> @@ -257,7 +139,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	if (IS_ERR(data))
>  		return PTR_ERR(data);
>  
> -	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
> +	ctx = bpf_receive_ctx(kattr, sizeof(struct __sk_buff));
>  	if (IS_ERR(ctx)) {
>  		kfree(data);
>  		return PTR_ERR(ctx);
> @@ -307,7 +189,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	ret = convert___skb_to_skb(skb, ctx);
>  	if (ret)
>  		goto out;
> -	ret = bpf_test_run(prog, skb, repeat, &retval, &duration);
> +	ret = bpf_test_run(prog, skb, repeat, BPF_TEST_RUN_SETUP_CGROUP_STORAGE,
> +			   &retval, &duration);
>  	if (ret)
>  		goto out;
>  	if (!is_l2) {
> @@ -327,10 +210,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	/* bpf program can never convert linear skb to non-linear */
>  	if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
>  		size = skb_headlen(skb);
> -	ret = bpf_test_finish(kattr, uattr, skb->data, size, retval, duration);
> -	if (!ret)
> -		ret = bpf_ctx_finish(kattr, uattr, ctx,
> -				     sizeof(struct __sk_buff));
> +	ret = bpf_net_prog_test_run_finish(kattr, uattr, skb->data, size,
> +					   ctx, sizeof(struct __sk_buff),
> +					   retval, duration);
>  out:
>  	kfree_skb(skb);
>  	bpf_sk_storage_free(sk);
> @@ -365,32 +247,48 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
>  	xdp.rxq = &rxqueue->xdp_rxq;
>  
> -	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration);
> +	ret = bpf_test_run(prog, &xdp, repeat,
> +			   BPF_TEST_RUN_SETUP_CGROUP_STORAGE,
> +			   &retval, &duration);
>  	if (ret)
>  		goto out;
>  	if (xdp.data != data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
>  	    xdp.data_end != xdp.data + size)
>  		size = xdp.data_end - xdp.data;
> -	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
> +	ret = bpf_net_prog_test_run_finish(kattr, uattr, xdp.data, size,
> +					   NULL, 0, retval, duration);
>  out:
>  	kfree(data);
>  	return ret;
>  }
>  
> +struct bpf_flow_dissect_run_data {
> +	__be16 proto;
> +	int nhoff;
> +	int hlen;
> +};
> +
> +static u32 bpf_flow_dissect_run(struct bpf_prog *prog, void *ctx,
> +				void *private_data)
> +{
> +	struct bpf_flow_dissect_run_data *data = private_data;
> +
> +	return bpf_flow_dissect(prog, ctx, data->proto, data->nhoff, data->hlen);
> +}
> +
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>  				     const union bpf_attr *kattr,
>  				     union bpf_attr __user *uattr)
>  {
> +	struct bpf_flow_dissect_run_data run_data = {};
>  	u32 size = kattr->test.data_size_in;
>  	struct bpf_flow_dissector ctx = {};
>  	u32 repeat = kattr->test.repeat;
>  	struct bpf_flow_keys flow_keys;
> -	u64 time_start, time_spent = 0;
>  	const struct ethhdr *eth;
>  	u32 retval, duration;
>  	void *data;
>  	int ret;
> -	u32 i;
>  
>  	if (prog->type != BPF_PROG_TYPE_FLOW_DISSECTOR)
>  		return -EINVAL;
> @@ -407,49 +305,22 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>  
>  	eth = (struct ethhdr *)data;
>  
> -	if (!repeat)
> -		repeat = 1;
> -
>  	ctx.flow_keys = &flow_keys;
>  	ctx.data = data;
>  	ctx.data_end = (__u8 *)data + size;
>  
> -	rcu_read_lock();
> -	preempt_disable();
> -	time_start = ktime_get_ns();
> -	for (i = 0; i < repeat; i++) {
> -		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
> -					  size);
> -
> -		if (signal_pending(current)) {
> -			preempt_enable();
> -			rcu_read_unlock();
> -
> -			ret = -EINTR;
> -			goto out;
> -		}
> -
> -		if (need_resched()) {
> -			time_spent += ktime_get_ns() - time_start;
> -			preempt_enable();
> -			rcu_read_unlock();
> -
> -			cond_resched();
> -
> -			rcu_read_lock();
> -			preempt_disable();
> -			time_start = ktime_get_ns();
> -		}
> -	}
> -	time_spent += ktime_get_ns() - time_start;
> -	preempt_enable();
> -	rcu_read_unlock();
> -
> -	do_div(time_spent, repeat);
> -	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> +	run_data.proto = eth->h_proto;
> +	run_data.nhoff = ETH_HLEN;
> +	run_data.hlen = size;
> +	ret = bpf_test_run_cb(prog, &ctx, repeat, BPF_TEST_RUN_PLAIN,
> +			      bpf_flow_dissect_run, &run_data,
> +			      &retval, &duration);
> +	if (!ret)
> +		goto out;
>  
> -	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
> -			      retval, duration);
> +	ret = bpf_net_prog_test_run_finish(kattr, uattr, &flow_keys,
> +					   sizeof(flow_keys), NULL, 0,
> +					   retval, duration);
>  
>  out:
>  	kfree(data);
> -- 
> 2.20.1
> 
