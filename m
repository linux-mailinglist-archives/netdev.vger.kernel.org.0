Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839025F5F84
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiJFDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJFDUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1AA1FCF4;
        Wed,  5 Oct 2022 20:19:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id 13so1737332ejn.3;
        Wed, 05 Oct 2022 20:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VmNVAada1Zq8HNTCy4z/9PlG8SO/4rla6NMn8F5NE+g=;
        b=o56ekJYEn62hBFnztt0zNtWmCZ0te1Zm8/zaqYxecb7V2C6YMv8OTeTrf6trhwKiBy
         oC+3XsdJwQk4BdvUlXFfLRhNSXzafu6HSo4jkzIDsdpxX/CSMkd9Tu3PrupjUddfbBVv
         U+ILvbR/JTyBJ1/tkjkRdt39V5lWOdgItL92UfReWl4DJKYsSsDrbWwwF+3jQgkzJ9Kk
         f+S/HBrDeLSTpihnUWfaEjOPuceTa5xFOmrs02jg2jRk4ZLDV/WvjUTx+foNs+IM2ajC
         S2zIlJ4bg71h7Ekjhzki7EzDfmYO/BxqNnoOv8sNN9r9tiidV5W7m+lOIELgIF8R30QL
         30nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmNVAada1Zq8HNTCy4z/9PlG8SO/4rla6NMn8F5NE+g=;
        b=f1UxkurpdYyIddh4OIe+0H263U/2TWwPPiGl+xT1z9dv39Yg1qvSfqZ/wALMBr9ihi
         4UnEoK6csDn32vPxHcVvEgky4HI8kZaZFIevFC3Q3mwBP6Ua1V4EJaknqCTlei/5MZoE
         Pwfww3LuH5EOaHymvmkyL+T+PE0+1rbgMpbAV5ySdpkyhhUx/2/sgK1rKdBjtflu6OeI
         6G94hChh3lKSB0qimaPnsprtb7ue3fnd0sJXEv+sjHslCIQDl/IigK4R9O+EMn8+Trys
         LGlvFVFJ+1a0cjM5gAOleRzJ3ckHmKG89628DYkmmGaY8AQM3vb8cRn7ZeTVGrAjyvPL
         cpTw==
X-Gm-Message-State: ACrzQf2gXH2FX6IM70va1Vu3gP1rcgWNGVoi0A/cjlS8l6QlneGEOF9+
        U0owBjDNpt9cGxmwIjCMwQb2DfoLY5zauO7qI6M=
X-Google-Smtp-Source: AMsMyM644jT/L1Vf0M6Hf5hVc2rbEQobD4fFaRo6MnDIV7ka6HWQ2Q1pvWWvmnUGyEHZtTmLE7sxJgve/oQ6JSAMygA=
X-Received: by 2002:a17:907:3fa9:b0:782:ed33:df8d with SMTP id
 hr41-20020a1709073fa900b00782ed33df8dmr2182156ejc.745.1665026398368; Wed, 05
 Oct 2022 20:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-9-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-9-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:43 -0700
Message-ID: <CAEf4BzbRKMJRZvF2L+jfMPHo1WFmGFcQ-GPWAD9s=v+r+V3o=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/10] libbpf: Add support for BPF tc link
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Implement tc BPF link support for libbpf. The bpf_program__attach_fd()
> API has been refactored slightly in order to pass bpf_link_create_opts.
> A new bpf_program__attach_tc() has been added on top of this which allows
> for passing ifindex and prio parameters.
>
> New sections are tc/ingress and tc/egress which map to BPF_NET_INGRESS
> and BPF_NET_EGRESS, respectively.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf.c      |  4 ++++
>  tools/lib/bpf/bpf.h      |  3 +++
>  tools/lib/bpf/libbpf.c   | 31 ++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  5 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index d1e338ac9a62..f73fdecbb5f8 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -752,6 +752,10 @@ int bpf_link_create(int prog_fd, int target_fd,

should we rename target_fd into more generic "target" maybe?

>                 if (!OPTS_ZEROED(opts, tracing))
>                         return libbpf_err(-EINVAL);
>                 break;
> +       case BPF_NET_INGRESS:
> +       case BPF_NET_EGRESS:
> +               attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
> +               break;
>         default:
>                 if (!OPTS_ZEROED(opts, flags))
>                         return libbpf_err(-EINVAL);
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 96de58fecdbc..937583421327 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -334,6 +334,9 @@ struct bpf_link_create_opts {
>                 struct {
>                         __u64 cookie;
>                 } tracing;
> +               struct {
> +                       __u32 priority;
> +               } tc;
>         };
>         size_t :0;
>  };
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 184ce1684dcd..6eb33e4324ad 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8474,6 +8474,8 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("kretsyscall+",         KPROBE, 0, SEC_NONE, attach_ksyscall),
>         SEC_DEF("usdt+",                KPROBE, 0, SEC_NONE, attach_usdt),
>         SEC_DEF("tc",                   SCHED_CLS, 0, SEC_NONE),
> +       SEC_DEF("tc/ingress",           SCHED_CLS, BPF_NET_INGRESS, SEC_ATTACHABLE_OPT),
> +       SEC_DEF("tc/egress",            SCHED_CLS, BPF_NET_EGRESS, SEC_ATTACHABLE_OPT),

btw, we could implement optionally the ability to declaratively
specify priority, so that you could do SEC("tc/ingress:10") or some
syntax like that, if that seems useful in practice. If you expect that
prio is going to be dynamic most of the time, then it might not make
sense to add unnecessary parsing code

>         SEC_DEF("classifier",           SCHED_CLS, 0, SEC_NONE),
>         SEC_DEF("action",               SCHED_ACT, 0, SEC_NONE),
>         SEC_DEF("tracepoint+",          TRACEPOINT, 0, SEC_NONE, attach_tp),
> @@ -11238,11 +11240,10 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
>  }
>
>  static struct bpf_link *
> -bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
> -                      const char *target_name)
> +bpf_program__attach_fd_opts(const struct bpf_program *prog,
> +                           const struct bpf_link_create_opts *opts,
> +                           int target_fd, const char *target_name)

let's move opts to be last argument or second to last before
"target_name", whichever makes more sense to you

also fd part is a lie, and whole double-underscore naming is also bad
here because this is internal helper. Let's rename this to something
like bpf_prog_create_link()?

>  {
> -       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> -                           .target_btf_id = btf_id);
>         enum bpf_attach_type attach_type;
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
> @@ -11260,7 +11261,7 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
>         link->detach = &bpf_link__detach_fd;
>
>         attach_type = bpf_program__expected_attach_type(prog);
> -       link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
> +       link_fd = bpf_link_create(prog_fd, target_fd, attach_type, opts);
>         if (link_fd < 0) {
>                 link_fd = -errno;
>                 free(link);
> @@ -11273,6 +11274,16 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
>         return link;
>  }
>
> +static struct bpf_link *
> +bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
> +                      const char *target_name)

there seems to be only one use case where we have btf_id != 0, so I
think we should just use LIBBPF_OPTS() explicitly in that one case and
for all other current uses of bpf_program__attach_fd() just use opts
variant and pass NULL

> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +                           .target_btf_id = btf_id);
> +
> +       return bpf_program__attach_fd_opts(prog, &opts, target_fd, target_name);
> +}
> +
>  struct bpf_link *
>  bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
>  {
> @@ -11291,6 +11302,16 @@ struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifi
>         return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
>  }
>
> +struct bpf_link *bpf_program__attach_tc(const struct bpf_program *prog,
> +                                       int ifindex, __u32 priority)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +                           .tc.priority = priority);
> +

nit: please just use shorter LIBBPF_OPTS in new code, nice and short

> +       /* target_fd/target_ifindex use the same field in LINK_CREATE */
> +       return bpf_program__attach_fd_opts(prog, &opts, ifindex, "tc");
> +}
> +
>  struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
>                                               int target_fd,
>                                               const char *attach_func_name)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index eee883f007f9..7e64cec9a1ba 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -645,6 +645,8 @@ bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd);
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex);
>  LIBBPF_API struct bpf_link *
> +bpf_program__attach_tc(const struct bpf_program *prog, int ifindex, __u32 priority);
> +LIBBPF_API struct bpf_link *
>  bpf_program__attach_freplace(const struct bpf_program *prog,
>                              int target_fd, const char *attach_func_name);
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 0c94b4862ebb..473ed71829c6 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -378,4 +378,5 @@ LIBBPF_1.1.0 {
>                 user_ring_buffer__reserve_blocking;
>                 user_ring_buffer__submit;
>                 bpf_prog_detach_opts;
> +               bpf_program__attach_tc;

same about alphabetical order

>  } LIBBPF_1.0.0;

> --
> 2.34.1
>
