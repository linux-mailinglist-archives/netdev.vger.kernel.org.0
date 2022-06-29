Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3671556028B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiF2OZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiF2OZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:25:32 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F21321267;
        Wed, 29 Jun 2022 07:25:31 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id j1so15298263vsj.12;
        Wed, 29 Jun 2022 07:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jX3p6DenZNBEgcU3ch3YYakHc1wbWrFS7SkPyG+QQus=;
        b=k7LriSy86O02qAchUK8qdaNiKkHBVFPD7dkBTLu+m+rmlgeudmRB7LhcpAQlG04V66
         iLPvYDr379BVi88pgdODBp/FNhhmsntrQt7wj+/zDPrRQ5HV2DU84Az3jNtbTabDfg24
         YblDTpdZ83deSpZX5+iA6i79wP+UHtUcpb3hPZNQxiqJ1TtywryMXfTqKFcBFFAOUnxY
         E/X2V5d05Htta97aQXInk1QKmibSXk5My0q/v88jYE+w4G4EKQvEL86lJ2QsZPh/rttZ
         woqfOnWqrPudGmVHugbAEzbsWj0ggPFeZAm1ps4wG1+IKegrNtYfHVKK+TAkqwqo9aRN
         dX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jX3p6DenZNBEgcU3ch3YYakHc1wbWrFS7SkPyG+QQus=;
        b=LfUg5KBAA84sFNfFqSTQ2ThbDSx6tYoGuqwcKzHvIrRu3x3T4UJmTIwQe6rmqZIm4n
         /16Q4iIYG7fiQi+EvvIY1+F0AkkiVdT20zhjs5ttJWbamIGfRUtIQqJPqFUFU/wSFaG8
         chVecSrohThpq4PwEFhtuOGyfACfiN1rchkpUpk9nPxabvreGHiqBOyf9awn6d/n8+iq
         1dx8+XdvE38F1pVNd7vDr61ljzYi01XPYfB84xp9KmKo77Ks4NHYlQdrI6uoUdF4kQeX
         YE1tcqfmc95s1FW0r9fj1OBZYZTDKdIda3pmLPury24dy7WEoV1MmZYnQjfiYQk7DQ/n
         EF1g==
X-Gm-Message-State: AJIora8iQfczkGIsqCy1ciAZpA9g61vN4Rxvs1eHby8coe0olqnCj2RY
        ObleKY/OhiWz5Fc43sZ2xyUJsmMvJuIVkAzUMqI=
X-Google-Smtp-Source: AGRyM1uaoy8u7JL6ehg3hLz7HK18wCIoU1NSgsTiYQCJZG36LKjl0XBJme7WTvHQ9/6MlEbs82o2oZxAASeabK7GmnI=
X-Received: by 2002:a05:6102:3d28:b0:354:5e75:7031 with SMTP id
 i40-20020a0561023d2800b003545e757031mr4955069vsv.35.1656512730318; Wed, 29
 Jun 2022 07:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220629111351.47699-1-quentin@isovalent.com>
In-Reply-To: <20220629111351.47699-1-quentin@isovalent.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 29 Jun 2022 22:24:53 +0800
Message-ID: <CALOAHbCFsqy1DXk5c_NLyi2TPnJd_tP5CtU==thESmTbF6oQDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: Probe for memcg-based accounting
 before bumping rlimit
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 7:13 PM Quentin Monnet <quentin@isovalent.com> wrote:
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
> v2:
> - Simply use sizeof(attr) instead of hardcoding a size via
>   offsetofend().
> - Set r0 = 0 before returning in sample program.
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

LGTM

Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  tools/bpf/bpftool/common.c | 71 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 68 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index a0d4acd7c54a..fc8172a4969a 100644
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
> +       struct rlimit rlim_init, rlim_cur_zero = {};
> +       struct bpf_insn insns[] = {
> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +       size_t insn_cnt = ARRAY_SIZE(insns);
> +       union bpf_attr attr;
> +       int prog_fd, err;
> +
> +       memset(&attr, 0, sizeof(attr));
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
> +       prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
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
> --
> 2.34.1
>


-- 
Regards
Yafang
