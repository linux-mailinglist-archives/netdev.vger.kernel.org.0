Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9F6E9B88
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjDTSW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDTSW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:22:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9206B40FE;
        Thu, 20 Apr 2023 11:22:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so8283153ejj.12;
        Thu, 20 Apr 2023 11:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682014974; x=1684606974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CZVwM4RlbVKeoWvXJRK2+ZkqTGEdyW7G1e+Ai+Xkhg=;
        b=XOHFvAO5MBVfkTn4XBqOSdVvEIXnsbypbQMtBcR6/41FtApQW4fxFvuKbC56vKg/fq
         9TBsjgdojXX6EZFZcyzfZoG6W2JZhOnyrH61Y10i0FAwson3VyTnTVUFa9Wch+bMsvqE
         NDN62y0S1/sAYDk5RR5pThFSF2W3R8QoNu51DzKgqVw9R1OVNusAS9OaPS4K3rVnLIzW
         y6JFIHJNnPv/vmHpNhz5gvLHCz31RynuK684XBIQdjvCRP5GmnS3iboA2gVO+fpSAU0w
         9vdoYWXat/ofs3vm4uy0i776EODY9qIZJ5yAgxYB2y32QhwIfv/Gx1vVwUGJ3qWSt5yh
         JKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682014974; x=1684606974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CZVwM4RlbVKeoWvXJRK2+ZkqTGEdyW7G1e+Ai+Xkhg=;
        b=Ky88AssaFEcYdBDp0K+OSi9bjSzuqEl7vdaA8Jcv3rjt6+Idjt61ICg0IuHB66DJBw
         LyVrSUknFFkOEG/B949rSQ+hHRLbpe97AJdocAvAnNzTgAla3B+ay6uwy/kNBmXalPpD
         IddhT1Spb0dcF9X7+Gq9zOlewHub2gBnKUlBUePtmJLIjttzX39dOIu7i/NFH5Of1lsO
         EoMklekt4NuBNmrmdMj6nHn7HWSHVpKCRYkgLJ6BcHMeDvmbgrjjmRjiBiWxmjG2gLbJ
         MM+z/vueGs6pPPtEGrmG+HOb4URcbOc6qq5e4LTrQBr7h2LqWB1o9Q9sOLolK8mQQj1n
         KhIw==
X-Gm-Message-State: AAQBX9dRuVlJaIHVK4WyY0KMxbs+l1v7griPhnb0hBAE07TMbtucy8jT
        6MgBZTjtxeegcV7kpFzs4YuwH7HcVEnLmjaXiN3IIvX2G50=
X-Google-Smtp-Source: AKy350ayaAnMLUIS7RQGLIM768z8dPY/V6mF3C0n4BNfAf7yOlzroMZz6sbJeazJvG1yJPtPyN6lglvR3UOY3cAnSqA=
X-Received: by 2002:a17:906:4fc5:b0:93e:739f:b0b8 with SMTP id
 i5-20020a1709064fc500b0093e739fb0b8mr1023652ejw.3.1682014973801; Thu, 20 Apr
 2023 11:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230420072657.80324-1-zhoufeng.zf@bytedance.com> <20230420072657.80324-2-zhoufeng.zf@bytedance.com>
In-Reply-To: <20230420072657.80324-2-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Apr 2023 11:22:42 -0700
Message-ID: <CAADnVQ+ffmrJCMa2R48AtJL3nT93jtKEdRv3RFeJ3Vo2L6ukQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add bpf_task_under_cgroup helper
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, yangzhenze@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:27=E2=80=AFAM Feng zhou <zhoufeng.zf@bytedance.c=
om> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> This adds a bpf helper that's similar to the
> bpf_current_task_under_cgroup. The difference is that it is a
> designated task.
>
> When hook sched related functions, sometimes it is necessary to
> specify a task instead of the current task.
>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  include/uapi/linux/bpf.h       | 13 +++++++++++++
>  kernel/bpf/verifier.c          |  4 +++-
>  kernel/trace/bpf_trace.c       | 31 +++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 13 +++++++++++++
>  4 files changed, 60 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4b20a7269bee..3d31ddb39e10 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5550,6 +5550,18 @@ union bpf_attr {
>   *             0 on success.
>   *
>   *             **-ENOENT** if the bpf_local_storage cannot be found.
> + *
> + * long bpf_task_under_cgroup(struct bpf_map *map, struct task_struct *t=
ask, u32 index)
> + *     Description
> + *             Check whether the probe is being run is the context of a =
given
> + *             subset of the cgroup2 hierarchy. The cgroup2 to test is h=
eld by
> + *             *map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
> + *     Return
> + *             The return value depends on the result of the test, and c=
an be:
> + *
> + *             * 1, if assigned task belongs to the cgroup2.
> + *             * 0, if assigned task does not belong to the cgroup2.
> + *             * A negative error code, if an error occurred.
>   */
>  #define ___BPF_FUNC_MAPPER(FN, ctx...)                 \
>         FN(unspec, 0, ##ctx)                            \
> @@ -5764,6 +5776,7 @@ union bpf_attr {
>         FN(user_ringbuf_drain, 209, ##ctx)              \
>         FN(cgrp_storage_get, 210, ##ctx)                \
>         FN(cgrp_storage_delete, 211, ##ctx)             \
> +       FN(task_under_cgroup, 212, ##ctx)               \
>         /* */
>
>  /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that do=
n't
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1e05355facdc..1e2c3c3e8d5f 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7771,7 +7771,8 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
>                 break;
>         case BPF_MAP_TYPE_CGROUP_ARRAY:
>                 if (func_id !=3D BPF_FUNC_skb_under_cgroup &&
> -                   func_id !=3D BPF_FUNC_current_task_under_cgroup)
> +                   func_id !=3D BPF_FUNC_current_task_under_cgroup &&
> +                   func_id !=3D BPF_FUNC_task_under_cgroup)
>                         goto error;
>                 break;
>         case BPF_MAP_TYPE_CGROUP_STORAGE:
> @@ -7902,6 +7903,7 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
>                         goto error;
>                 break;
>         case BPF_FUNC_current_task_under_cgroup:
> +       case BPF_FUNC_task_under_cgroup:
>         case BPF_FUNC_skb_under_cgroup:
>                 if (map->map_type !=3D BPF_MAP_TYPE_CGROUP_ARRAY)
>                         goto error;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index bcf91bc7bf71..b02a04768824 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -814,6 +814,35 @@ static const struct bpf_func_proto bpf_current_task_=
under_cgroup_proto =3D {
>         .arg2_type      =3D ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_task_under_cgroup, struct bpf_map *, map, struct task_str=
uct *,
> +          task, u32, idx)
> +{
> +       struct bpf_array *array =3D container_of(map, struct bpf_array, m=
ap);
> +       struct cgroup *cgrp;
> +
> +       if (unlikely(!task))
> +               return -ENOENT;
> +
> +       if (unlikely(idx >=3D array->map.max_entries))
> +               return -E2BIG;
> +
> +       cgrp =3D READ_ONCE(array->ptrs[idx]);
> +       if (unlikely(!cgrp))
> +               return -EAGAIN;
> +
> +       return task_under_cgroup_hierarchy(task, cgrp);

We don't add helpers anymore.
Please wrap task_under_cgroup_hierarchy() as a kfunc
that takes two TRUSTED pointers task and cgroup.
