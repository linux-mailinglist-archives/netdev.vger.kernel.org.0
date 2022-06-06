Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C878953F23B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiFFWqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiFFWqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:46:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78852C5E48
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:46:42 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e66so14122609pgc.8
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 15:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HLuyI2W62ZPcSsKQMknqN2Xs/HI65ZJVRyOjevQKz1w=;
        b=SMGdYhVLh++BJZJL2oQ6GOelpSYexPW7aaCMkUJaZaEmAt2TcPjzCeFg6UGYVeBMUX
         1ngs2kBy3mmQG4rTQV+4KQrAQfTtK6r5jAVpicJvWIpkfaReidmtqFMsx9I8MwblyPnM
         RMP+YuJygKrwGQJqM68e4yBT4PR/jajAcmvuiyncxZ0Hw/BUs62kMQ4BC/t2lXFJITAq
         /g7X/W3t55WRv9ZmDyRmqH7xXk9tR7FwRg4aM5m9NCt/6tK1PsM/Ai52UR3Ttn/0HRO7
         NkUG2SaiOBgaSChi9ZjPvmYKnP3DfGqgB7YK+TcYXxz0JGS91OtW5aI7+0ggcZKjaxPM
         pEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLuyI2W62ZPcSsKQMknqN2Xs/HI65ZJVRyOjevQKz1w=;
        b=H6MDAmwGlYnvm0ntWX1oft5bFDTkzaDaemXRhutLItDfZ5xAeZGcI1qMmJ5SG+lNWf
         DqctSSZopVnjBqK0Uttyl4LAIxjxNiBYucdiC8lh0NnydN+ucscC6dKJ2KKNyMbsDpby
         qdSWXdUXt/d5UVtB0IfGI9tMvhjbxgCWPLIzNhsjMLzIEheQPo7Z++PTAYvi+bEudqby
         MXB9kkju155SaUMZDYNsiXZZ2VVnMWo5sdEWeOXWBscuwk4Nc7BkjVJUo3hQqLKVCHHj
         EZX58HHpcDE1/ihHF3Xm+3UydsTUfTkPejlCgjRg5cbcAfwpdeOZA8qJHFwrU77uZ/QA
         rKBg==
X-Gm-Message-State: AOAM533ABPuiXw8hcezCy69OPZ4D1/SsUqoyjdcKj6f00sB2SYN0q3Pm
        s1d1WNsqQCz6JLfv9q/3Rl/jAPntVX5MLRDZIvzkAg==
X-Google-Smtp-Source: ABdhPJzGhwJNwldVtweTAgnJ9cJUdl6AJhb7fvxC1mDgHmN7cCRBadqy1ANJTX8aSJ8v/FomfJou9G8QNi3euCQPctw=
X-Received: by 2002:a63:f158:0:b0:3db:8563:e8f5 with SMTP id
 o24-20020a63f158000000b003db8563e8f5mr23516591pgk.191.1654555600833; Mon, 06
 Jun 2022 15:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-7-sdf@google.com>
 <20220604071808.rwzoktja73ijr3i7@kafai-mbp>
In-Reply-To: <20220604071808.rwzoktja73ijr3i7@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 6 Jun 2022 15:46:29 -0700
Message-ID: <CAKH8qBv-cKrqvYjPh3P1JaWGLCTpBq3JtOEg+Py=a7BN_dVrPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 06/11] bpf: allow writing to a subset of sock
 fields from lsm progtype
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 4, 2022 at 12:18 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 01, 2022 at 12:02:13PM -0700, Stanislav Fomichev wrote:
> > For now, allow only the obvious ones, like sk_priority and sk_mark.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/bpf_lsm.c  | 58 +++++++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/verifier.c |  3 ++-
> >  2 files changed, 60 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 83aa431dd52e..feba8e96f58d 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -303,7 +303,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
> >  const struct bpf_prog_ops lsm_prog_ops = {
> >  };
> >
> > +static int lsm_btf_struct_access(struct bpf_verifier_log *log,
> > +                                     const struct btf *btf,
> > +                                     const struct btf_type *t, int off,
> > +                                     int size, enum bpf_access_type atype,
> > +                                     u32 *next_btf_id,
> > +                                     enum bpf_type_flag *flag)
> > +{
> > +     const struct btf_type *sock_type;
> > +     struct btf *btf_vmlinux;
> > +     s32 type_id;
> > +     size_t end;
> > +
> > +     if (atype == BPF_READ)
> > +             return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> > +                                      flag);
> > +
> > +     btf_vmlinux = bpf_get_btf_vmlinux();
> > +     if (!btf_vmlinux) {
> > +             bpf_log(log, "no vmlinux btf\n");
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
> > +     if (type_id < 0) {
> > +             bpf_log(log, "'struct sock' not found in vmlinux btf\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     sock_type = btf_type_by_id(btf_vmlinux, type_id);
> > +
> > +     if (t != sock_type) {
> > +             bpf_log(log, "only 'struct sock' writes are supported\n");
> > +             return -EACCES;
> > +     }
> > +
> > +     switch (off) {
> > +     case bpf_ctx_range(struct sock, sk_priority):
> This looks wrong.  It should not allow to write at
> any bytes of the '__u32 sk_priority'.

SG, I'll change to offsetof() and will enfoce u32 size.

> > +             end = offsetofend(struct sock, sk_priority);
> > +             break;
> > +     case bpf_ctx_range(struct sock, sk_mark):
> Same here.
>
> Just came to my mind,
> if the current need is only sk_priority and sk_mark,
> do you think allowing bpf_setsockopt will be more useful instead ?

For my use-case I only need sk_priority, but I was thinking that we
can later extend that list as needed. But you suggestion to use
bpf_setsockopt sounds good, let me try to use that. That might be
better than poking directly into the fields.

> It currently has SO_MARK, SO_PRIORITY, and other options.
> Also, changing SO_MARK requires to clear the sk->sk_dst_cache.
> In general, is it safe to do bpf_setsockopt in all bpf_lsm hooks ?

It seems that we might need to more strictly control it (regardless of
helper or direct field access). Not all lsm hooks lock sk argument, so
we so maybe start with some allowlist of attach_btf_ids that can do
bpf_setsockopt? (I'll add existing hooks that work on new/unreferenced
or locked sockets to the list)


> > +             end = offsetofend(struct sock, sk_mark);
> > +             break;
> > +     default:
> > +             bpf_log(log, "no write support to 'struct sock' at off %d\n", off);
> > +             return -EACCES;
> > +     }
> > +
> > +     if (off + size > end) {
> > +             bpf_log(log,
> > +                     "write access at off %d with size %d beyond the member of 'struct sock' ended at %zu\n",
> > +                     off, size, end);
> > +             return -EACCES;
> > +     }
> > +
> > +     return NOT_INIT;
> > +}
> > +
> >  const struct bpf_verifier_ops lsm_verifier_ops = {
> >       .get_func_proto = bpf_lsm_func_proto,
> >       .is_valid_access = btf_ctx_access,
> > +     .btf_struct_access = lsm_btf_struct_access,
> >  };
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index caa5740b39b3..c54e171d9c23 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -13413,7 +13413,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
> >                               insn->code = BPF_LDX | BPF_PROBE_MEM |
> >                                       BPF_SIZE((insn)->code);
> >                               env->prog->aux->num_exentries++;
> > -                     } else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
> > +                     } else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS &&
> > +                                resolve_prog_type(env->prog) != BPF_PROG_TYPE_LSM) {
> >                               verbose(env, "Writes through BTF pointers are not allowed\n");
> >                               return -EINVAL;
> >                       }
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
