Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCD55EB5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiF1Rx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiF1Rx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:53:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9E71BA
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:53:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 9so12891613pgd.7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BawOF30jreBw6h+htpf+3bv16wUJ+LKNYVml1Jeqpw0=;
        b=teopuH3YajUvyRSjpzuJ0w6HC+e25mYt3gIiW4Oz6o7f9migqOsNznrGpM3E/faGW9
         hA954PfTeCDeExUSQWdZbedOjy/LkDa6k48rXl/Z88jdBJnhzfj68ZK6ICc7PS/Y87jz
         kmdCF/NlivvaIpNsM4sDUX33e1eXEvwbceF7/mzweKS/8MGvEKysJnhG/GpjJmdOPEEv
         cy9pKwYKYORdfxehAboJ82yTbcP+6SehWlX+yUD9IesX+mn06mLAv52SqmpK9oitYaCM
         F1awtQ3XNVOH0dugB3T6vC/QZT/Sg3rvLljQsQQFuaZg5ElBpdV9jGfzHu9XDgMXp8mP
         XEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BawOF30jreBw6h+htpf+3bv16wUJ+LKNYVml1Jeqpw0=;
        b=YDHVZWK7NDHbe+rLKNFJF3/Q463jBcnp/m4S3VDYr4KAL+XPGzXUxkjtwYtZIp4MU1
         X9Vqwmhr/8SAHOanNQPMuRXFSw2thCnt+hJkQgG8Ka7AA0RbkSohaCbL9olesVzs6cQK
         F/yp2JiX5t3KN1lTrgQap7OBzf1O7LgdaPMkTlAI2wadss59hL5Hny3LHm78fm1+20iI
         aDQGpMnYUVwJyB8Q+bIDO0I8WYD1vEMCixKWuMMgCZcXn/QoRjKhBz+9Dng3lKKrrU3+
         X4LPLMXCxh6w7nWGDEmV0hFQf1v6IYHH9WI9on+GzFlIOKPzCiksCiPSbQp7+yB5n3b+
         zhEw==
X-Gm-Message-State: AJIora9UUxpJV+nFY6phgRW6m4lpkxIdIFlNX3iI93Rd3bAp1wJPI4/q
        BhJJ//fj8N4c1vTVlVyRf6B5KRZw8d2chjw8IAoN7w==
X-Google-Smtp-Source: AGRyM1sC3ogLLDXNLb1gHLxxs5KL+4rKb/G8HX+uluA6x+uMkIcdcbQdiPIqw344QtLriRX9dDPn+fUdexdtPtQfjLA=
X-Received: by 2002:a62:1582:0:b0:525:6361:85cd with SMTP id
 124-20020a621582000000b00525636185cdmr4665342pfv.72.1656438836687; Tue, 28
 Jun 2022 10:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220628164529.80050-1-quentin@isovalent.com>
In-Reply-To: <20220628164529.80050-1-quentin@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 28 Jun 2022 10:53:45 -0700
Message-ID: <CAKH8qBvzZvHoUpkVPXN-v=XrvdPQ-1tEJOcd=PrGosHbY7+KdA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Probe for memcg-based accounting before
 bumping rlimit
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 9:45 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool used to bump the memlock rlimit to make sure to be able to load
> BPF objects. After the kernel has switched to memcg-based memory
> accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
> for memcg-based accounting support and for raising the rlimit if
> necessary [1]. But this was later reverted, because the probe would
> sometimes fail, resulting in bpftool not being able to load all required
> objects [2].
>
> Here we add a more efficient probe, in bpftool itself. We first lower
> the rlimit to 0, then we attempt to load a BPF object (and finally reset
> the rlimit): if the load succeeds, then memcg-based memory accounting is
> supported.
>
> This approach was earlier proposed for the probe in libbpf itself [3],
> but given that the library may be used in multithreaded applications,
> the probe could have undesirable consequences if one thread attempts to
> lock kernel memory while memlock rlimit is at 0. Since bpftool is
> single-threaded and the rlimit is process-based, this is fine to do in
> bpftool itself.
>
> This probe was inspired by the similar one from the cilium/ebpf Go
> library [4].
>
> [0] commit 97306be45fbe ("Merge branch 'switch to memcg-based memory accounting'")
> [1] commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
> [2] commit 6b4384ff1088 ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"")
> [3] https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/t/#u
> [4] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/common.c   | 71 ++++++++++++++++++++++++++++++++++--
>  tools/include/linux/kernel.h |  5 +++
>  2 files changed, 73 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index a0d4acd7c54a..e07769802f76 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -13,14 +13,17 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> -#include <linux/limits.h>
> -#include <linux/magic.h>
>  #include <net/if.h>
>  #include <sys/mount.h>
>  #include <sys/resource.h>
>  #include <sys/stat.h>
>  #include <sys/vfs.h>
>
> +#include <linux/filter.h>
> +#include <linux/limits.h>
> +#include <linux/magic.h>
> +#include <linux/unistd.h>
> +
>  #include <bpf/bpf.h>
>  #include <bpf/hashmap.h>
>  #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
> @@ -73,11 +76,73 @@ static bool is_bpffs(char *path)
>         return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>  }
>
> +/* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
> + * memcg-based memory accounting for BPF maps and programs. This was done in
> + * commit 97306be45fbe ("Merge branch 'switch to memcg-based memory
> + * accounting'"), in Linux 5.11.
> + *
> + * Libbpf also offers to probe for memcg-based accounting vs rlimit, but does
> + * so by checking for the availability of a given BPF helper and this has
> + * failed on some kernels with backports in the past, see commit 6b4384ff1088
> + * ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"").
> + * Instead, we can probe by lowering the process-based rlimit to 0, trying to
> + * load a BPF object, and resetting the rlimit. If the load succeeds then
> + * memcg-based accounting is supported.
> + *
> + * This would be too dangerous to do in the library, because multithreaded
> + * applications might attempt to load items while the rlimit is at 0. Given
> + * that bpftool is single-threaded, this is fine to do here.
> + */
> +static bool known_to_need_rlimit(void)
> +{
> +       const size_t prog_load_attr_sz = offsetofend(union bpf_attr, attach_btf_obj_fd);

nit:
Any specific reason you're hard coding this sz via offseofend? Why not
use sizeof(bpf_attr) directly as a syscall/memset size?
The kernel should handle all these cases where bpftool has extra zero
padding, right?

> +       struct bpf_insn insns[] = {
> +               BPF_EXIT_INSN(),
> +       };
> +       struct rlimit rlim_init, rlim_cur_zero = {};
> +       size_t insn_cnt = ARRAY_SIZE(insns);
> +       union bpf_attr attr;
> +       int prog_fd, err;
> +
> +       memset(&attr, 0, prog_load_attr_sz);
> +       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> +       attr.insns = ptr_to_u64(insns);
> +       attr.insn_cnt = insn_cnt;
> +       attr.license = ptr_to_u64("GPL");
> +
> +       if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
> +               return false;
> +
> +       /* Drop the soft limit to zero. We maintain the hard limit to its
> +        * current value, because lowering it would be a permanent operation
> +        * for unprivileged users.
> +        */
> +       rlim_cur_zero.rlim_max = rlim_init.rlim_max;
> +       if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
> +               return false;
> +
> +       /* Do not use bpf_prog_load() from libbpf here, because it calls
> +        * bump_rlimit_memlock(), interfering with the current probe.
> +        */
> +       prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, prog_load_attr_sz);
> +       err = errno;
> +
> +       /* reset soft rlimit to its initial value */
> +       setrlimit(RLIMIT_MEMLOCK, &rlim_init);
> +
> +       if (prog_fd < 0)
> +               return err == EPERM;
> +
> +       close(prog_fd);
> +       return false;
> +}
> +
>  void set_max_rlimit(void)
>  {
>         struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
>
> -       setrlimit(RLIMIT_MEMLOCK, &rinf);
> +       if (known_to_need_rlimit())
> +               setrlimit(RLIMIT_MEMLOCK, &rinf);
>  }
>
>  static int
> diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
> index 4b0673bf52c2..5c90d65cc2d3 100644
> --- a/tools/include/linux/kernel.h
> +++ b/tools/include/linux/kernel.h
> @@ -24,6 +24,11 @@
>  #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
>  #endif
>
> +#ifndef offsetofend
> +# define offsetofend(TYPE, FIELD) \
> +       (offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
> +#endif
> +
>  #ifndef container_of
>  /**
>   * container_of - cast a member of a structure out to the containing structure
> --
> 2.34.1
>
