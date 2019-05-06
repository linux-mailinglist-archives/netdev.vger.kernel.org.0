Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119E814D68
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 16:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfEFOsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbfEFOr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 10:47:59 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09AF2087F;
        Mon,  6 May 2019 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154078;
        bh=I3RuPUnsau3/9T4URycFeXmxeH3JbPXrTjlfIFBbXOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DqUmgGisNw+/giG/ord66rkonSMoqSF91WC7wOTWyCgsJgOSov+m1vSLOqOSBKKCP
         vDLYkj9L48KHbOS3Qi8WGDP12vZ7j49e5S7Zb8SQ86NZgkUg24H2BMf285zL9TVBjo
         PXd56WG6upWC1grtw6tlaMl3VETTE9eTFQ7J7+NA=
Date:   Mon, 6 May 2019 23:47:51 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-Id: <20190506234751.65c92139dccbfa025bdfe300@kernel.org>
In-Reply-To: <20190502204958.7868-1-joel@joelfernandes.org>
References: <20190502204958.7868-1-joel@joelfernandes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

On Thu,  2 May 2019 16:49:58 -0400
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

> The eBPF based opensnoop tool fails to read the file path string passed
> to the do_sys_open function. This is because it is a pointer to
> userspace address and causes an -EFAULT when read with
> probe_kernel_read. This is not an issue when running the tool on x86 but
> is an issue on arm64. This patch adds a new bpf function call based
> which calls the recently proposed probe_user_read function [1].
> Using this function call from opensnoop fixes the issue on arm64.
> 
> [1] https://lore.kernel.org/patchwork/patch/1051588/

Anyway, this series is still out-of-tree. We have to push this or similar
update into kernel at first. I can resend v7 on the latest -tip tree including
this patch if you update the description.

Thank you,

> 
> Cc: Michal Gregorczyk <michalgr@live.com>
> Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
> Cc: Mohammad Husain <russoue@gmail.com>
> Cc: Qais Yousef <qais.yousef@arm.com>
> Cc: Srinivas Ramana <sramana@codeaurora.org>
> Cc: duyuchao <yuchao.du@unisoc.com>
> Cc: Manjo Raja Rao <linux@manojrajarao.com>
> Cc: Karim Yaghmour <karim.yaghmour@opersys.com>
> Cc: Tamir Carmeli <carmeli.tamir@gmail.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Peter Ziljstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: kernel-team@android.com
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  include/uapi/linux/bpf.h       |  7 ++++++-
>  kernel/trace/bpf_trace.c       | 22 ++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 ++++++-
>  3 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e99e3e6f8b37..6fec701eaa46 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -539,6 +539,10 @@ union bpf_attr {
>   *     @mode: operation mode (enum bpf_adj_room_mode)
>   *     @flags: reserved for future use
>   *     Return: 0 on success or negative error code
> + *
> + * int bpf_probe_read_user(void *dst, int size, void *src)
> + *     Read a userspace pointer safely.
> + *     Return: 0 on success or negative error
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -591,7 +595,8 @@ union bpf_attr {
>  	FN(get_socket_uid),		\
>  	FN(set_hash),			\
>  	FN(setsockopt),			\
> -	FN(skb_adjust_room),
> +	FN(skb_adjust_room),		\
> +	FN(probe_read_user),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index dc498b605d5d..1e1a11d9faa8 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -81,6 +81,26 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
>  	.arg3_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size, const void *, unsafe_ptr)
> +{
> +	int ret;
> +
> +	ret = probe_user_read(dst, unsafe_ptr, size);
> +	if (unlikely(ret < 0))
> +		memset(dst, 0, size);
> +
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_probe_read_user_proto = {
> +	.func		= bpf_probe_read_user,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
> +	.arg2_type	= ARG_CONST_SIZE,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
>  BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
>  	   u32, size)
>  {
> @@ -459,6 +479,8 @@ static const struct bpf_func_proto *tracing_func_proto(enum bpf_func_id func_id)
>  		return &bpf_map_delete_elem_proto;
>  	case BPF_FUNC_probe_read:
>  		return &bpf_probe_read_proto;
> +	case BPF_FUNC_probe_read_user:
> +		return &bpf_probe_read_user_proto;
>  	case BPF_FUNC_ktime_get_ns:
>  		return &bpf_ktime_get_ns_proto;
>  	case BPF_FUNC_tail_call:
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index e99e3e6f8b37..6fec701eaa46 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -539,6 +539,10 @@ union bpf_attr {
>   *     @mode: operation mode (enum bpf_adj_room_mode)
>   *     @flags: reserved for future use
>   *     Return: 0 on success or negative error code
> + *
> + * int bpf_probe_read_user(void *dst, int size, void *src)
> + *     Read a userspace pointer safely.
> + *     Return: 0 on success or negative error
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -591,7 +595,8 @@ union bpf_attr {
>  	FN(get_socket_uid),		\
>  	FN(set_hash),			\
>  	FN(setsockopt),			\
> -	FN(skb_adjust_room),
> +	FN(skb_adjust_room),		\
> +	FN(probe_read_user),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> -- 
> 2.21.0.593.g511ec345e18-goog
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
