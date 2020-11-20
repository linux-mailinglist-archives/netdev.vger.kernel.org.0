Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776942BB9C1
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgKTXMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgKTXMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:12:53 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C37C0613CF;
        Fri, 20 Nov 2020 15:12:52 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s8so10032677yba.13;
        Fri, 20 Nov 2020 15:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XwhX7mqdBZb79BJALMUFBwrzROJPtHHkHdKkiNfguEk=;
        b=KeDt4hdfc+q/0oF73O4HS7X9TSOYKZZYWGByDrzcIRKJ3NECZTKm7ROxjqcNjnCXp3
         rPJIy0mLxuiQ9phxJGbWPjhHJzy4nXJZ5ASlaeKJiGH1LujzZBMjWWC94qSFPKtXXLdI
         hhevbmkhojIMEyNZNinaOI3c93nPTUxbyFGLnSp984PPMVCbPVhiUGmwo8tq5eUsHXB2
         dQePymuawBEjAa1Fs4xxcu/eRwLS4kg+IzWTPbUpZr9vwtk+2/IbBI0enLZZjfYiRQ2z
         Bg7sTUNx9Eas3dq9B+QGLdLtW4GG3gRTRsaF9EJSDM4KiXgMSRMYEe0LkM4a+KzYUBfU
         Yckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XwhX7mqdBZb79BJALMUFBwrzROJPtHHkHdKkiNfguEk=;
        b=IgNnnzf5J7lymzhqMywWtvIOzDNgJwA0LUu7hsONAeiQPN6KGDNhmpaR42kgOr8sK5
         Q6JPoUc4qOMiH0lFmdT6TEWAcE2tfOJn/UkHVdmxHC+LLkUB/aSRufKkpwZjJ+lEZfm1
         CzzSMbP3hn2caDdOyU0kqzqI5FOjuD/UsjqXr8Rr9vmS+2Hxqk9NNycvJvpvRZ2pHQAF
         XYDcQBb1oyNhrOmwfsVoYxoNHWaVLBh6z4Le/0mUv5JqLBSb+W1SrDWbkE8cgifKA/9t
         n3HGBgV3yhLYRBkn1V8/m8Wt4klCPOuvsUU/zVQALYM2HwM0Sw1HlYGSdNJmgwMdzVq4
         WXFw==
X-Gm-Message-State: AOAM530+RfknFhQx5ZktNe7NOervuHmNIYb6mImJEQ+8l7hsD3cBNU51
        8LA4S+PQmUOgSBRDfQvcJtuiAhPdV43KknNt/FM=
X-Google-Smtp-Source: ABdhPJxGZAcp/N28eGNsF140NVGcycVpm0Pu+ec2TbPCFIweRgBoPqjugdoxcpeLth8SEHIfhsSU2e6WulLvvP2Mjy0=
X-Received: by 2002:a25:585:: with SMTP id 127mr22124564ybf.425.1605913972228;
 Fri, 20 Nov 2020 15:12:52 -0800 (PST)
MIME-Version: 1.0
References: <20201119232244.2776720-1-andrii@kernel.org> <20201119232244.2776720-5-andrii@kernel.org>
 <20201120230549.37k4zsjsrxbyjin3@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201120230549.37k4zsjsrxbyjin3@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Nov 2020 15:12:41 -0800
Message-ID: <CAEf4BzYU8h6CaruMasZW8C2CF27GVhV-2mnM5wz4rpLzyNSYtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 3:06 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
> [ ... ]
>
> > +static int load_module_btfs(struct bpf_object *obj)
> > +{
> > +     struct bpf_btf_info info;
> > +     struct module_btf *mod_btf;
> > +     struct btf *btf;
> > +     char name[64];
> > +     __u32 id, len;
> > +     int err, fd;
> > +
> > +     if (obj->btf_modules_loaded)
> > +             return 0;
> > +
> > +     /* don't do this again, even if we find no module BTFs */
> > +     obj->btf_modules_loaded = true;
> > +
> > +     /* kernel too old to support module BTFs */
> > +     if (!kernel_supports(FEAT_MODULE_BTF))
> > +             return 0;
> > +
> > +     while (true) {
> > +             err = bpf_btf_get_next_id(id, &id);
> > +             if (err && errno == ENOENT)
> > +                     return 0;
> > +             if (err) {
> > +                     err = -errno;
> > +                     pr_warn("failed to iterate BTF objects: %d\n", err);
> > +                     return err;
> > +             }
> > +
> > +             fd = bpf_btf_get_fd_by_id(id);
> > +             if (fd < 0) {
> > +                     if (errno == ENOENT)
> > +                             continue; /* expected race: BTF was unloaded */
> > +                     err = -errno;
> > +                     pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> > +                     return err;
> > +             }
> > +
> > +             len = sizeof(info);
> > +             memset(&info, 0, sizeof(info));
> > +             info.name = ptr_to_u64(name);
> > +             info.name_len = sizeof(name);
> > +
> > +             err = bpf_obj_get_info_by_fd(fd, &info, &len);
> > +             if (err) {
> > +                     err = -errno;
> > +                     pr_warn("failed to get BTF object #%d info: %d\n", id, err);
>
>                         close(fd);
>
> > +                     return err;
> > +             }
> > +
> > +             /* ignore non-module BTFs */
> > +             if (!info.kernel_btf || strcmp(name, "vmlinux") == 0) {
> > +                     close(fd);
> > +                     continue;
> > +             }
> > +
>
> [ ... ]
>
> > @@ -8656,9 +8815,6 @@ static inline int __find_vmlinux_btf_id(struct btf *btf, const char *name,
> >       else
> >               err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
> >
> > -     if (err <= 0)
> > -             pr_warn("%s is not found in vmlinux BTF\n", name);
> > -
> >       return err;
> >  }
> >
> > @@ -8675,6 +8831,9 @@ int libbpf_find_vmlinux_btf_id(const char *name,
> >       }
> >
> >       err = __find_vmlinux_btf_id(btf, name, attach_type);
> > +     if (err <= 0)
> > +             pr_warn("%s is not found in vmlinux BTF\n", name);
> > +
> Please explain this move in the commit message.

ok, I'll add something about that. The short answer is that
__find_vmlinux_btf_id() is now expected to not find a type in vmlinux
BTF, so emitting error would be wrong. So I moved it up a level where
it's not expected.

>
> >       btf__free(btf);
> >       return err;
> >  }
> > --
> > 2.24.1
> >
