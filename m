Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C438E57A36C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiGSPq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238470AbiGSPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:46:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9BA54670
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:46:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b10so4217978pjq.5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLGineCxzdUhqZ0totHv9/HyxhWkFQEif+a4cEJSDL8=;
        b=DW0EnfRwpOw1uNv4VAVwjEIGLJYOoNSuCcD40y6h3lKcLGS+MBuBuVX/UegUgNbGel
         +ty0PUe3Zb5MGym/CRL0C7cxczOoUDRB2VP8Z7dfuTUi4o4EzqlWCDqwMCwNw0ZqySm8
         dGT45EkwtMUdEu1hOA4Fq6e2jBTS1CT/czPuB5AIWXV/0cy0/bwFrjwF74jEBzBgiLhA
         zFXzOZPXeQbAVHysr3nHY0jIK04lSl1vTt7r6/RsCR+Sq7IF/S/yNCcDX1b/aF1DMQfz
         SBLxG1AP0/K0cftPJ8Yez80ecG/GS7X5fD7ZYwk/Nzq9o9RNTDtp/ZjTBQQnUpbL3rxI
         Ndtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLGineCxzdUhqZ0totHv9/HyxhWkFQEif+a4cEJSDL8=;
        b=Hh3+ktlPGBnYsC3EuMAMMQ6OdloDY6br59CCEzVwaNp2JOab2NOV1JdtDVZboLV/tg
         FTfxqC2RYorsZEAsZBkkwYo3To7JmtRtDcZtBbniog0H98DOd+6yvhzcGb1IIj/5GlKb
         OVFvvVSBiJTR2p/aNVUg2TIBHqWAB6qyukAUMgLeq2ObW1v6i3RyOzzKKMXKP5PgKaQI
         Sevr+X//X/qa3mKU+PbTmOjvykJ2hr5JQKhxHLEfd47zxAOwSuYUJVSnHjba/p+tja65
         mBeFR4ivvjpdg04ocHwoX2ckTFqA9XnoE0lkA1OLLELOAqpa8AxoOXi06gLEq7PmsXJM
         u/kw==
X-Gm-Message-State: AJIora81lzuBThs/TJ2PB2Y7croQKWHiBIYqX/hHAlPH9QDi6hiHI62Y
        EMabR+1tUMoUNP7adDgDOPS40cCT2b8WvyoSBrAAng==
X-Google-Smtp-Source: AGRyM1vtvaCffnh2l4f56YAsiMoaolRPJSDOCqynhJ372P0N1qzCRKtatEZUvXr8ozYvnmieW+RNiA+CsPVXAjtJMZE=
X-Received: by 2002:a17:902:db11:b0:16c:3e90:12e5 with SMTP id
 m17-20020a170902db1100b0016c3e9012e5mr33546576plx.73.1658245583818; Tue, 19
 Jul 2022 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <1658221305-35718-1-git-send-email-xujia39@huawei.com>
In-Reply-To: <1658221305-35718-1-git-send-email-xujia39@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 19 Jul 2022 08:46:12 -0700
Message-ID: <CAKH8qBuwm75KirLSrTh1jeYqDAn78Ki5sgiAY8y2G2OCsDJP5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf compile error caused by CONFIG_CGROUP_BPF
To:     Xu Jia <xujia39@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 1:49 AM Xu Jia <xujia39@huawei.com> wrote:
>
> We failed to compile when CONFIG_BPF_LSM is enabled but CONFIG_CGROUP_BPF
> is not set. The failings are shown as below:
>
> kernel/bpf/trampoline.o: in function `bpf_trampoline_link_cgroup_shim'
> trampoline.c: undefined reference to `bpf_cgroup_atype_get'
> kernel/bpf/bpf_lsm.o: In function `bpf_lsm_find_cgroup_shim':
> bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_current'
> bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_sock'
> bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_socket'
>
> Fix them by protecting these functions with CONFIG_CGROUP_BPF.

Should be fixed by the following?

https://lore.kernel.org/bpf/20220714185404.3647772-1-sdf@google.com/

> Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
> Signed-off-by: Xu Jia <xujia39@huawei.com>
> ---
>  include/linux/bpf.h     | 12 +++++++++---
>  include/linux/bpf_lsm.h | 10 ++++++----
>  kernel/bpf/bpf_lsm.c    |  2 ++
>  kernel/bpf/trampoline.c |  2 ++
>  4 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2b21f2a3452f..add8895c02cc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1255,9 +1255,7 @@ struct bpf_dummy_ops {
>  int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
>                             union bpf_attr __user *uattr);
>  #endif
> -int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> -                                   int cgroup_atype);
> -void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
> +
>  #else
>  static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
>  {
> @@ -1281,6 +1279,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
>  {
>         return -EINVAL;
>  }
> +#endif
> +
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL) && \
> +    defined(CONFIG_CGROUP_BPF)
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +                                   int cgroup_atype);
> +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
> +#else
>  static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
>                                                   int cgroup_atype)
>  {
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 4bcf76a9bb06..bed45a0c8a9c 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -42,8 +42,6 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
>  extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
>  void bpf_inode_storage_free(struct inode *inode);
>
> -void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> -
>  #else /* !CONFIG_BPF_LSM */
>
>  static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
> @@ -67,11 +65,15 @@ static inline void bpf_inode_storage_free(struct inode *inode)
>  {
>  }
>
> +#endif /* CONFIG_BPF_LSM */
> +
> +#if defined(CONFIG_BPF_LSM) && defined(CONFIG_BPF_CGROUP)
> +void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> +#else
>  static inline void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>                                            bpf_func_t *bpf_func)
>  {
>  }
> -
> -#endif /* CONFIG_BPF_LSM */
> +#endif
>
>  #endif /* _LINUX_BPF_LSM_H */
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index d469b7f3deef..29527828b38b 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -63,6 +63,7 @@ BTF_ID(func, bpf_lsm_socket_post_create)
>  BTF_ID(func, bpf_lsm_socket_socketpair)
>  BTF_SET_END(bpf_lsm_unlocked_sockopt_hooks)
>
> +#ifdef CONFIG_BPF_CGROUP
>  void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>                              bpf_func_t *bpf_func)
>  {
> @@ -86,6 +87,7 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  #endif
>                 *bpf_func = __cgroup_bpf_run_lsm_current;
>  }
> +#endif /* CONFIG_BPF_CGROUP */
>
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>                         const struct bpf_prog *prog)
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 6cd226584c33..127924711935 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -525,6 +525,7 @@ static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
>         .dealloc = bpf_shim_tramp_link_dealloc,
>  };
>
> +#ifdef CONFIG_CGROUP_BPF
>  static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
>                                                      bpf_func_t bpf_func,
>                                                      int cgroup_atype)
> @@ -668,6 +669,7 @@ void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
>
>         bpf_trampoline_put(tr); /* bpf_trampoline_lookup above */
>  }
> +#endif /* CONFIG_CGROUP_BPF */
>  #endif
>
>  struct bpf_trampoline *bpf_trampoline_get(u64 key,
> --
> 2.25.1
>
