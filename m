Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17812AC999
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgKJAJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729847AbgKJAJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 19:09:50 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BB3C0613CF;
        Mon,  9 Nov 2020 16:09:50 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id i186so9922752ybc.11;
        Mon, 09 Nov 2020 16:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MrlUCPjB8KSnvLKxOJBPycaLoKpp69iwiSDtd8vsAs=;
        b=ojQXFWTYUtZot+KOstD0tQDSrrD83hmODcAa2toFUDVZerOksO6WLdcPT1N21KH/Mq
         Tpn1kNm1a/XUfur/RjQvtmzhBh0Sf4kZmM5/rm7AtkZ6GUKzBfeXw7v8481XXRVw5HWT
         hZVnv5022X5zvv1pKzm5FIRCYFHpDtMPA8jKIFyGPSnm0qZNJqpiM4alzdf4dZuReB0W
         zWMSLg6KA+FIYLpYfFB9yMAhbawbjtVyQsT8CxBw7szK5/hTyjyGbhpug20QAQnJwDx3
         fWBpLXg4zvcgQ1YPFR1ma83EgOq36XOC8PN+/UtmvAhNqA+kjg0xg1WwSfghRvSreY88
         Xj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MrlUCPjB8KSnvLKxOJBPycaLoKpp69iwiSDtd8vsAs=;
        b=Ef0wQ1M/JwmTyFRqi+uy2B/zUxnkBX6j4E5ZLeWq+0RtIi32BOp5YIG0PGJZzOJIr3
         NxkHC8RW7Zqv3Sc5JLen3QLdhZcRELRp0qLnPsS+9My+HS+1zVFX96xPv7pWuh9U1xzJ
         1x4+nrvadXJIYMnO7wjOiG9wqSITss3b/qlnt4noOF/709P0ftr6lfv4ZPDUC9NViBeQ
         2DS0TBUKr0TG56HBS6HxfAsyL/r45tDakdJcVVzLKAvgvJJObHNUlSDcAILsZwJM/mq1
         /GKQwYosIq63IIGUgqOwwzkaGVUueD6Mn/WXLZa/2YW6vr/u/uIa8scr0vdyPjUbK9Ib
         mvUg==
X-Gm-Message-State: AOAM5330LZIFt+M7YWJRoz+V7vKw8KB243wtxhDMEXtHFbnxkrLUC694
        qNBTe/7Jf8vnNIAjr6ZCqzuAiNmNBEo3XKVss1dXIW3538s=
X-Google-Smtp-Source: ABdhPJz8qtFeLMG3tZPgDwxvTK8M8a7V1f/6D0NHRXUpoE7XfxiO6iDVetGe9E2+t3IX2tEzCOf9YxuPp5Vp890NA1Y=
X-Received: by 2002:a25:585:: with SMTP id 127mr11582225ybf.425.1604966989511;
 Mon, 09 Nov 2020 16:09:49 -0800 (PST)
MIME-Version: 1.0
References: <20201109210024.2024572-1-andrii@kernel.org> <20201109210024.2024572-3-andrii@kernel.org>
 <20201109215518.jcqtsq7h7kni6w2w@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201109215518.jcqtsq7h7kni6w2w@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 Nov 2020 16:09:38 -0800
Message-ID: <CAEf4BzbtWbcLvJaS51YzvzgL3dNJFUQ2AD+Y1YuyZ3rBL-yc2w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: assign ID to vmlinux BTF and return
 extra info for BTF in GET_OBJ_INFO
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 1:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Nov 09, 2020 at 01:00:21PM -0800, Andrii Nakryiko wrote:
> > Allocate ID for vmlinux BTF. This makes it visible when iterating over all BTF
> > objects in the system. To allow distinguishing vmlinux BTF (and later kernel
> > module BTF) from user-provided BTFs, expose extra kernel_btf flag, as well as
> > BTF name ("vmlinux" for vmlinux BTF, will equal to module's name for module
> > BTF).  We might want to later allow specifying BTF name for user-provided BTFs
> > as well, if that makes sense. But currently this is reserved only for
> > in-kernel BTFs.
> >
> > Having in-kernel BTFs exposed IDs will allow to extend BPF APIs that require
> > in-kernel BTF type with ability to specify BTF types from kernel modules, not
> > just vmlinux BTF. This will be implemented in a follow up patch set for
> > fentry/fexit/fmod_ret/lsm/etc.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       |  3 +++
> >  kernel/bpf/btf.c               | 39 ++++++++++++++++++++++++++++++++--
> >  tools/include/uapi/linux/bpf.h |  3 +++
> >  3 files changed, 43 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 9879d6793e90..162999b12790 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4466,6 +4466,9 @@ struct bpf_btf_info {
> >       __aligned_u64 btf;
> >       __u32 btf_size;
> >       __u32 id;
> > +     __aligned_u64 name;
> > +     __u32 name_len;
> > +     __u32 kernel_btf;
> >  } __attribute__((aligned(8)));
> >
> >  struct bpf_link_info {
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 894ee33f4c84..663c3fb4e614 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -215,6 +215,8 @@ struct btf {
> >       struct btf *base_btf;
> >       u32 start_id; /* first type ID in this BTF (0 for base BTF) */
> >       u32 start_str_off; /* first string offset (0 for base BTF) */
> > +     char name[MODULE_NAME_LEN];
> > +     bool kernel_btf;
> >  };
> >
> >  enum verifier_phase {
> > @@ -4430,6 +4432,8 @@ struct btf *btf_parse_vmlinux(void)
> >
> >       btf->data = __start_BTF;
> >       btf->data_size = __stop_BTF - __start_BTF;
> > +     btf->kernel_btf = true;
> > +     snprintf(btf->name, sizeof(btf->name), "vmlinux");
> >
> >       err = btf_parse_hdr(env);
> >       if (err)
> > @@ -4455,8 +4459,13 @@ struct btf *btf_parse_vmlinux(void)
> >
> >       bpf_struct_ops_init(btf, log);
> >
> > -     btf_verifier_env_free(env);
> >       refcount_set(&btf->refcnt, 1);
> > +
> > +     err = btf_alloc_id(btf);
> > +     if (err)
> > +             goto errout;
> > +
> > +     btf_verifier_env_free(env);
> >       return btf;
> >
> >  errout:
> > @@ -5554,7 +5563,8 @@ int btf_get_info_by_fd(const struct btf *btf,
> >       struct bpf_btf_info info;
> >       u32 info_copy, btf_copy;
> >       void __user *ubtf;
> > -     u32 uinfo_len;
> > +     char __user *uname;
> > +     u32 uinfo_len, uname_len, name_len;
> >
> >       uinfo = u64_to_user_ptr(attr->info.info);
> >       uinfo_len = attr->info.info_len;
> > @@ -5571,6 +5581,31 @@ int btf_get_info_by_fd(const struct btf *btf,
> >               return -EFAULT;
> >       info.btf_size = btf->data_size;
> >
> > +     info.kernel_btf = btf->kernel_btf;
> > +
> > +     uname = u64_to_user_ptr(info.name);
> > +     uname_len = info.name_len;
> > +     if (!uname ^ !uname_len)
> > +             return -EINVAL;
> > +
> > +     name_len = strlen(btf->name);
> > +     info.name_len = name_len;
> > +
> > +     if (uname) {
> > +             if (uname_len >= name_len + 1) {
> > +                     if (copy_to_user(uname, btf->name, name_len + 1))
> > +                             return -EFAULT;
> > +             } else {
> > +                     char zero = '\0';
> > +
> > +                     if (copy_to_user(uname, btf->name, uname_len - 1))
> > +                             return -EFAULT;
> > +                     if (put_user(zero, uname + uname_len - 1))
> > +                             return -EFAULT;
> > +                     return -ENOSPC;
> It should still do copy_to_user() even it will return -ENOSPC.
>

Good catch! I'll use "ret" variable, will set it to -ENOSPC here and
will let the code fall through.


> > +             }
> > +     }
> > +
> >       if (copy_to_user(uinfo, &info, info_copy) ||
> >           put_user(info_copy, &uattr->info.info_len))
> >               return -EFAULT;
