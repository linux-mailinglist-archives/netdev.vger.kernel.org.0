Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F629683509
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjAaST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjAaSTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:19:25 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4932BF08;
        Tue, 31 Jan 2023 10:18:53 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q5so15115534wrv.0;
        Tue, 31 Jan 2023 10:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KQtWetJKNRW19yzIJi5PZLD2MSbSr+5EToDGZLhUjpw=;
        b=Z+EeN7H40zW94smvkENuVCMV77J0I8/1yBNNx9J5dUkiO6JRLg0vPLpVs/gJEkJsVJ
         PZdL/BI6jgGqdNUpXQ5e6VLIABsCVMSYGgyFX++Jow220b7/sTZIJZCcu76MA72KNBdp
         oq6gTacNM217YLZNpONoagLU0CIYXgzjgHgSMxJOJDbFCosKKRPB+KdjxBND5kfhPt4A
         RkgIaUVZhT+yrLCW00R3jk0I9aX4RKi6isQshWaeZxLpMj/lh2cNGzckQQMeSuL2nn+u
         c2O6tOO/buO2U9vEQsF3JCHUh3ETYCQGv3gxXXwQa/Dt3zjxCPRIqYd8Ll8g434FywwR
         72fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQtWetJKNRW19yzIJi5PZLD2MSbSr+5EToDGZLhUjpw=;
        b=UPi7KB88beT9YCJupoTvbfyTF9x4xaNg9JTXFNOcq6qQb+/ltfcC/f7M5ipyvymXgc
         1C/6lI6ft9bdbGItepdXYTsURRbVvIFmMczktY9uqihjShJo5Za50fV2VAki3xkgetUY
         rwIihzBoCF0j1jW6p7c1dUrvhEse0cMgxgcJOohi+rRtB2/rDCAQ+9N+PCywxqm0/U27
         /EFYRmfpSpxjmvksi4cdmJFeKMncsTdbbNX/TcYpDzcE5B1ipUhRWHCYY7CSxgVnJlPw
         l3Py2636/SUG9YsYICUAV4ru99g9pkH0pnC5q+U824JY3hESabQJNR5PR9+HRewqodJu
         EuRQ==
X-Gm-Message-State: AO0yUKWmG/6hxVge96dmDp9ah1FZukfhbtrpo529dmio8WpNhYnKWv31
        AGF3VW6Rls3jxOqcy3SgVKtXCfuCCrkwF5QhVpQ=
X-Google-Smtp-Source: AK7set9pgNaftSKgqyqDJswcDbD1ZIPXBBAMCbUQgKoXZNNoI+ZJAm8texPrpIeaf2lu43EzhM7egd427gVu9oiOK88=
X-Received: by 2002:a05:6000:1847:b0:2bf:d1a1:c120 with SMTP id
 c7-20020a056000184700b002bfd1a1c120mr455065wri.422.1675189132121; Tue, 31 Jan
 2023 10:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
In-Reply-To: <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 10:18:39 -0800
Message-ID: <CAJnrk1Yc2zyHb+WRtZrtLMnj6kKAQTg0oBmMq5E4P9Byxamf1g@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf@vger.kernel.org
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

On Mon, Jan 30, 2023 at 2:04 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/27/23 11:17 AM, Joanne Koong wrote:
> > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >               mark_reg_known_zero(env, regs, BPF_REG_0);
> >               regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> >               regs[BPF_REG_0].mem_size = meta.mem_size;
> > +             if (func_id == BPF_FUNC_dynptr_data &&
> > +                 dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > +                     bool seen_direct_write = env->seen_direct_write;
> > +
> > +                     regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > +                     if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > +                             regs[BPF_REG_0].type |= MEM_RDONLY;
> > +                     else
> > +                             /*
> > +                              * Calling may_access_direct_pkt_data() will set
> > +                              * env->seen_direct_write to true if the skb is
> > +                              * writable. As an optimization, we can ignore
> > +                              * setting env->seen_direct_write.
> > +                              *
> > +                              * env->seen_direct_write is used by skb
> > +                              * programs to determine whether the skb's page
> > +                              * buffers should be cloned. Since data slice
> > +                              * writes would only be to the head, we can skip
> > +                              * this.
> > +                              */
> > +                             env->seen_direct_write = seen_direct_write;
> > +             }
>
> [ ... ]
>
> > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> >                               return ret;
> >                       break;
> >               case KF_ARG_PTR_TO_DYNPTR:
> > +             {
> > +                     enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > +
> >                       if (reg->type != PTR_TO_STACK &&
> >                           reg->type != CONST_PTR_TO_DYNPTR) {
> >                               verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> >                               return -EINVAL;
> >                       }
> >
> > -                     ret = process_dynptr_func(env, regno, insn_idx,
> > -                                               ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > +                     if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > +                             dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > +                     else
> > +                             dynptr_arg_type |= MEM_RDONLY;
> > +
> > +                     ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > +                                               meta->func_id);
> >                       if (ret < 0)
> >                               return ret;
> >                       break;
> > +             }
> >               case KF_ARG_PTR_TO_LIST_HEAD:
> >                       if (reg->type != PTR_TO_MAP_VALUE &&
> >                           reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                  desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> >               insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> >               *cnt = 1;
> > +     } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > +             bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
>
> Does it need to restore the env->seen_direct_write here also?
>
> It seems this 'seen_direct_write' saving/restoring is needed now because
> 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is actually
> writing the packet. Some refactoring can help to avoid issue like this.

Yes! Great catch! I'll submit a patch that refactors this, so that
env->seen_direct_write isn't set implicitly within
may_access_direct_pkt_data()

>
> While at 'seen_direct_write', Alexei has also pointed out that the verifier
> needs to track whether the (packet) 'slice' returned by bpf_dynptr_data() has
> been written. It should be tracked in 'seen_direct_write'. Take a look at how
> reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere in
> v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> PTR_TO_MEM instead of PTR_TO_PACKET.
>

The verifier right now does track whether the dynptr skb 'slice' is
writable or not and sets seen_direct_write accordingly. However, it
currently does it in check_helper_call() where if the bpf program is
writable, then the env->seen_direct_write is set (regardless of
whether actual writes occur or not), so I like your idea of moving
this to check_mem_access(). The PTR_TO_MEM that gets returned for the
data slice will need to be tagged with DYNPTR_TYPE_SKB.

>
> [ ... ]
>
> > +int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
> > +                     struct bpf_dynptr_kern *ptr, int is_rdonly)
>
> hmm... this exposed kfunc takes "int is_rdonly".
>
> What if the bpf prog calls it like bpf_dynptr_from_skb(..., false) in some hook
> that is not writable to packet?

If the bpf prog tries to do this, their "false" value will be ignored,
because the "int is_rdonly" arg value gets set by the verifier (in
fixup_kfunc_call() in line 15969)

>
> > +{
> > +     if (flags) {
> > +             bpf_dynptr_set_null(ptr);
> > +             return -EINVAL;
> > +     }
> > +
> > +     bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
> > +
> > +     if (is_rdonly)
> > +             bpf_dynptr_set_rdonly(ptr);
> > +
> > +     return 0;
> > +}
> > +
> >   BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
> >   {
> >       return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
> > @@ -11607,3 +11634,28 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
> >
> >       return func;
> >   }
> > +
> > +BTF_SET8_START(bpf_kfunc_check_set_skb)
> > +BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
> > +BTF_SET8_END(bpf_kfunc_check_set_skb)
> > +
> > +static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
> > +     .owner = THIS_MODULE,
> > +     .set = &bpf_kfunc_check_set_skb,
> > +};
> > +
> > +static int __init bpf_kfunc_init(void)
> > +{
> > +     int ret;
> > +
> > +     ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SK_SKB, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCKET_FILTER, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
> > +     ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
> > +     return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
> > +}
> > +late_initcall(bpf_kfunc_init);
>
>
