Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ADE5721FC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiGLRxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiGLRxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06B38BB;
        Tue, 12 Jul 2022 10:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ADC1B81B88;
        Tue, 12 Jul 2022 17:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB44C341C8;
        Tue, 12 Jul 2022 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657648417;
        bh=81DQ6XwV6QSGRv/Y8PZB4OF0sSCD+qz4XroqcCziNmg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nd3/SesHarbZ9Ec5IuCJ/CxludbfYk4IrYVLcvv/AT257kIyLgURuvBaEV3Vum0hc
         t3ME+q+Z0hh6HnQnNpocVI39x0VHdAbXJZ9V/86jTEztZOkmehbiQehlIAwcFCgI83
         U9BpOsR0ZKhWAKjdSGzlT6DrYaE7pmgFoGif9cvR8zGasRtD6ltfQQMAbVSB6f9saU
         3TLmtZYnugNpToW+BFontk/DHQezBdPbTbk6fQbCwesvUAnyDr0/RKq2k7vAFZWBBb
         WdP/lyKt5KjUuMxHHamf5Ky4lpRkemMIeZe9E2UqJYhbV7ZG8pefk1JATo+e9o16pN
         WjGLF0NGXvoRw==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31bf3656517so88792797b3.12;
        Tue, 12 Jul 2022 10:53:36 -0700 (PDT)
X-Gm-Message-State: AJIora8iYPmbbE0eOG+TMTTXaAi6QRKV6dinXcwIxlPaGP61ajpcAQyK
        jaS92gMx+lClXV/mcB0SAYZHmayetwpqEeY8UfA=
X-Google-Smtp-Source: AGRyM1uZFjBEihbK2YQQp/NBSOZ9Xn1WI5+IJIQYfmNEdqci5UczaZ7c5pkl25sDzH1+9TZ7vqGVhxQpLxRNKtYZXl4=
X-Received: by 2002:a0d:f445:0:b0:31d:4f2c:a0b0 with SMTP id
 d66-20020a0df445000000b0031d4f2ca0b0mr19507196ywf.73.1657648415966; Tue, 12
 Jul 2022 10:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220711083220.2175036-1-asavkov@redhat.com> <20220711083220.2175036-4-asavkov@redhat.com>
In-Reply-To: <20220711083220.2175036-4-asavkov@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Jul 2022 10:53:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
Message-ID: <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 1:32 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> Add a helper that will make the kernel panic immediately with specified
> message. Using this helper requires kernel.destructive_bpf_enabled sysctl
> to be enabled, BPF_F_DESTRUCTIVE flag to be supplied on program load as
> well as CAP_SYS_BOOT capabilities.
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  7 +++++++
>  kernel/bpf/core.c              |  1 +
>  kernel/bpf/helpers.c           | 13 +++++++++++++
>  kernel/bpf/verifier.c          |  7 +++++++
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h |  7 +++++++
>  7 files changed, 38 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 43c008e3587a..77c20ba9ca8e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2339,6 +2339,7 @@ extern const struct bpf_func_proto bpf_strtol_proto;
>  extern const struct bpf_func_proto bpf_strtoul_proto;
>  extern const struct bpf_func_proto bpf_tcp_sock_proto;
>  extern const struct bpf_func_proto bpf_jiffies64_proto;
> +extern const struct bpf_func_proto bpf_panic_proto;
>  extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
>  extern const struct bpf_func_proto bpf_event_output_data_proto;
>  extern const struct bpf_func_proto bpf_ringbuf_output_proto;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4423874b5da4..e2e2c4de44ee 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3927,6 +3927,12 @@ union bpf_attr {
>   *     Return
>   *             The 64 bit jiffies
>   *
> + * void bpf_panic(const char *msg)
> + *     Description
> + *             Make the kernel panic immediately
> + *     Return
> + *             void
> + *
>   * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
>   *     Description
>   *             For an eBPF program attached to a perf event, retrieve the
> @@ -5452,6 +5458,7 @@ union bpf_attr {
>         FN(tcp_send_ack),               \
>         FN(send_signal_thread),         \
>         FN(jiffies64),                  \
> +       FN(panic),                      \
>         FN(read_branch_records),        \
>         FN(get_ns_current_pid_tgid),    \
>         FN(xdp_output),                 \
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index b5ffebcce6cc..0f333a0e85a5 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2649,6 +2649,7 @@ const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto __weak;
>  const struct bpf_func_proto bpf_spin_lock_proto __weak;
>  const struct bpf_func_proto bpf_spin_unlock_proto __weak;
>  const struct bpf_func_proto bpf_jiffies64_proto __weak;
> +const struct bpf_func_proto bpf_panic_proto __weak;
>
>  const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
>  const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index a1c84d256f83..5cb90208a264 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -374,6 +374,19 @@ const struct bpf_func_proto bpf_jiffies64_proto = {
>         .ret_type       = RET_INTEGER,
>  };
>
> +BPF_CALL_1(bpf_panic, const char *, msg)
> +{
> +       panic(msg);

I think we should also check

   capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()

here. Or at least, destructive_ebpf_enabled(). Otherwise, we
may trigger panic after the sysctl is disabled.

In general, I don't think sysctl is a good API, as it is global, and
the user can easily forget to turn it back off. If possible, I would
rather avoid adding new BPF related sysctls.

Thanks,
Song


> +       return 0;
> +}
> +
> +const struct bpf_func_proto bpf_panic_proto = {
> +       .func           = bpf_panic,
> +       .gpl_only       = false,
> +       .ret_type       = RET_VOID,
> +       .arg1_type      = ARG_PTR_TO_CONST_STR,
> +};
> +
>  #ifdef CONFIG_CGROUPS
>  BPF_CALL_0(bpf_get_current_cgroup_id)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2859901ffbe3..f49c026917c5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7285,6 +7285,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>                                 reg_type_str(env, regs[BPF_REG_1].type));
>                         return -EACCES;
>                 }
> +               break;
> +       case BPF_FUNC_panic:
> +               struct bpf_prog_aux *aux = env->prog->aux;
> +               if (!aux->destructive) {
> +                       verbose(env, "bpf_panic() calls require BPF_F_DESTRUCTIVE flag\n");
> +                       return -EACCES;
> +               }
>         }
>
>         if (err)
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4be976cf7d63..3ee888507795 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1304,6 +1304,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_find_vma_proto;
>         case BPF_FUNC_trace_vprintk:
>                 return bpf_get_trace_vprintk_proto();
> +       case BPF_FUNC_panic:
> +               return capable(CAP_SYS_BOOT) && destructive_ebpf_enabled() ? &bpf_panic_proto : NULL;
>         default:
>                 return bpf_base_func_proto(func_id);
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4423874b5da4..e2e2c4de44ee 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3927,6 +3927,12 @@ union bpf_attr {
>   *     Return
>   *             The 64 bit jiffies
>   *
> + * void bpf_panic(const char *msg)
> + *     Description
> + *             Make the kernel panic immediately
> + *     Return
> + *             void
> + *
>   * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
>   *     Description
>   *             For an eBPF program attached to a perf event, retrieve the
> @@ -5452,6 +5458,7 @@ union bpf_attr {
>         FN(tcp_send_ack),               \
>         FN(send_signal_thread),         \
>         FN(jiffies64),                  \
> +       FN(panic),                      \
>         FN(read_branch_records),        \
>         FN(get_ns_current_pid_tgid),    \
>         FN(xdp_output),                 \
> --
> 2.35.3
>
