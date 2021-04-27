Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B83436BDCA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhD0Dhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhD0Dhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:37:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949BC061574;
        Mon, 26 Apr 2021 20:37:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6483415pjv.1;
        Mon, 26 Apr 2021 20:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1C9CVPJr3BySELErdByj88ox5WCaDH+ROiGvIWTc27Q=;
        b=X1bxRQr92MujTxcXWxK6ARS9RokTQ9kEjBttRd8OBiEJV+EEDjf3jOdq1HUAh9BXrc
         qn2jDca9by0UVF17jj9d86GrfqnyI2VgrmZbmX5d9XYMLtEp9gtgh/8v+24fpPKn9bcN
         f+xmW3vYAuckDxFRfpEmdIstsvr/CcSTmiLlbnN+QQdxrJdiwRbICnxgO+kEM9smz5Ch
         wRqchw3S7Zs5beuwzuBZYoHcGiuN5O83yCvU0FXYc/MdOPQssUtECj7JtMW+m7ksi3H8
         FhwfFiMi2tfuIgdu84j17fVpbZUfjb5bp53Ig29l8JSUzUz0sAPm586CRCotvWuhbP9K
         X/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1C9CVPJr3BySELErdByj88ox5WCaDH+ROiGvIWTc27Q=;
        b=J7LVmMxKdzyQ/X7EuormpT52sX2Ry6m9r6FGYANoSv2lNd2hE2n2io6PM8Hch1DiXb
         N/E3EiFkSkd578i/YhoMTR6wfoR/w/6AtadPSb0qxZfIWapoh0kA9N8eQoQXIiOXgXoB
         nNj7oUpE+cFOC81pvYxtKgrFshdUsZG5Wn9YAoQ+c8Fnqz81CmJcdtc1oys0VPCxajGS
         W0sfPN7xy5kCWn596jhj/Tfv5/4RnwJsm1EiaBHiZZ/IwJmKEPADohw9lSenHT/hvQqz
         gAnP9omPLXeABN7kj7GWqKPu3Fvss9SK59nugb7ASCvpgUYObOvKxPZVoKSIPZkiI6eu
         XBeg==
X-Gm-Message-State: AOAM533HJCptEZ5iDqDk0+alRFNhBj1VYGB09VV//OKToFwY7vbZabdZ
        QeIItBkn4YKG3GsIvWivJocviuALhfo=
X-Google-Smtp-Source: ABdhPJxJ300vI7i9A7zptPhLn24TUYRntVEoo0cEeDSnT8lAIjvcpK4vBggEilQFSgWwt/T631MVtA==
X-Received: by 2002:a17:90a:6282:: with SMTP id d2mr2519701pjj.168.1619494630141;
        Mon, 26 Apr 2021 20:37:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id q26sm970476pfg.146.2021.04.26.20.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 20:37:09 -0700 (PDT)
Date:   Mon, 26 Apr 2021 20:37:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind()
 helper.
Message-ID: <20210427033707.fu7hsm6xi5ayx6he@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com>
 <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 03:46:29PM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add new helper:
> >
> > long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> >         Description
> >                 Find given name with given type in BTF pointed to by btf_fd.
> >                 If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> >         Return
> >                 Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/bpf.h            |  1 +
> >  include/uapi/linux/bpf.h       |  8 ++++
> >  kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
> >  kernel/bpf/syscall.c           |  2 +
> >  tools/include/uapi/linux/bpf.h |  8 ++++
> >  5 files changed, 87 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 0f841bd0cb85..4cf361eb6a80 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1972,6 +1972,7 @@ extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
> >  extern const struct bpf_func_proto bpf_task_storage_get_proto;
> >  extern const struct bpf_func_proto bpf_task_storage_delete_proto;
> >  extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
> > +extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
> >
> >  const struct bpf_func_proto *bpf_tracing_func_proto(
> >         enum bpf_func_id func_id, const struct bpf_prog *prog);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index de58a714ed36..253f5f031f08 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4748,6 +4748,13 @@ union bpf_attr {
> >   *             Execute bpf syscall with given arguments.
> >   *     Return
> >   *             A syscall result.
> > + *
> > + * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> > + *     Description
> > + *             Find given name with given type in BTF pointed to by btf_fd.
> 
> "Find BTF type with given name"? Should the limits on name length be

+1

> specified? KSYM_NAME_LEN is a pretty arbitrary restriction.

that's implementation detail that shouldn't leak into uapi.

> Also,
> would it still work fine if the caller provides a pointer to a much
> shorter piece of memory?
> 
> Why not add name_sz right after name, as we do with a lot of other
> arguments like this?

That's an option too, but then the helper will have 5 args and 'flags'
would be likely useless. I mean unlikely it will help extending it.
I was thinking about ARG_PTR_TO_CONST_STR, but it doesn't work,
since blob is writeable by the prog. It's read only from user space.
I'm fine with name, name_sz though.

> 
> > + *             If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > + *     Return
> > + *             Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> 
> Mention that for vmlinux BTF btf_obj_fd will be zero? Also who "owns"
> the FD? If the BPF program doesn't close it, when are they going to be
> cleaned up?

just like bpf_sys_bpf. Who owns returned FD? The program that called
the helper, of course.
In the current shape of loader prog these btf fds are cleaned up correctly
in success and in error case.
Not all FDs though. map fds will stay around if bpf_sys_bpf(prog_load) fails to load.
Tweaking loader prog to close all FDs in error case is on todo list.
