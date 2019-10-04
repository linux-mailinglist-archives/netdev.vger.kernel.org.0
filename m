Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426FDCBF27
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbfJDP3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:29:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44095 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389086AbfJDP3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:29:24 -0400
Received: by mail-qk1-f194.google.com with SMTP id u22so6132548qkk.11;
        Fri, 04 Oct 2019 08:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UQe+bCmrBq86gqS+Z0mMlSvgU7YGuHf7sfKi5sOgcoU=;
        b=H8j4XNNxLZj8Be2UxD3j7Hf+9X+GmgTB+RPIcBpKGmADnO8BrOUlZEdHVuOptoT6No
         TPOI3UlTz4HBe+svQOEkv8KoTSv/PYV9o7WKWZFy0k+w7acWk+SP93CfpO6701PGQMX3
         dyJb/ClNI/wnM6HMDEQG8IbGY8I2nhJmg3puDe5siZnHSyEcHFsPVb9YU6KQ+S2D+K2f
         6pDcVg8LVJFRjD4km5NgC2XoOrn8EZOblj6750MF3tKXYenMyEIEa7yAw5mHXhj5SRYS
         FnTu8iP7VLP7R7ifRdc0HyWPLLt2o4mN3+R6sJChhg1sI4hTyPqWvr1t1Jsf/9CkxYnG
         BlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UQe+bCmrBq86gqS+Z0mMlSvgU7YGuHf7sfKi5sOgcoU=;
        b=Q6/UedVev1KMxq0wl4yM1BlAr9jVsZwqPNQVNF+0MBYs3PHtRcgB3zYhj2qPUNjZFe
         ETnS+Pq406sle5ToCNonOM7Ari6sLk8SZ7uv7bbFmanvEqPpR7LmmX2M9JPyW8gqUTnS
         KJ5S5YiECZQCBkfQsB/wUWeC6/v7+Sh10ibIusR57d1EgGOFtH+iUUG24q/edoW1vmWW
         zkscRX/pZDnKTySlUWTnC1TsVASbW/00SwcCE7ccR2Dp5Op9vM8fMSud0yuurz0ASXaH
         +cJ1e4wQVB6EuNGWmHmva+H9NR0N/XAIbRb0qkzlP6J2jH4fanqNlBpKkCEDxGqoFycH
         4ECA==
X-Gm-Message-State: APjAAAVVBfecHkkBqD3PoH058hNxVJ22CguQ76eE1VKuPKILEx2MGvSm
        BGiz7CKH6C62ey3iRcRUcrHLYztrg2iHHOFa/Cg=
X-Google-Smtp-Source: APXvYqwzCxR/XO4nDoNu85wVx0vsVk5Mj1uj5ZK1at+OZ9CBn8hdAiYx4+KnaHQd4kfrWYiRNLnI8I6Zgnq+5BzHTTo=
X-Received: by 2002:a37:98f:: with SMTP id 137mr10991751qkj.449.1570202963346;
 Fri, 04 Oct 2019 08:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191004053235.2710592-1-andriin@fb.com> <20191004053235.2710592-3-andriin@fb.com>
 <87bluxow1a.fsf@toke.dk>
In-Reply-To: <87bluxow1a.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 08:29:11 -0700
Message-ID: <CAEf4BzYvtZmi4p2xZUS0Obx-tcH2xV0=68EfeKLziAxsZW=XTQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: add bpf_object__open_{file,mem}
 w/ extensible opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 11:38 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add new set of bpf_object__open APIs using new approach to optional
> > parameters extensibility allowing simpler ABI compatibility approach.
> >
> > This patch demonstrates an approach to implementing libbpf APIs that
> > makes it easy to extend existing APIs with extra optional parameters in
> > such a way, that ABI compatibility is preserved without having to do
> > symbol versioning and generating lots of boilerplate code to handle it.
> > To facilitate succinct code for working with options, add OPTS_VALID,
> > OPTS_HAS, and OPTS_GET macros that hide all the NULL, size, and zero
> > checks.
> >
> > Additionally, newly added libbpf APIs are encouraged to follow similar
> > pattern of having all mandatory parameters as formal function parameter=
s
> > and always have optional (NULL-able) xxx_opts struct, which should
> > always have real struct size as a first field and the rest would be
> > optional parameters added over time, which tune the behavior of existin=
g
> > API, if specified by user.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c          | 51 ++++++++++++++++++++++++++++-----
> >  tools/lib/bpf/libbpf.h          | 36 +++++++++++++++++++++--
> >  tools/lib/bpf/libbpf.map        |  3 ++
> >  tools/lib/bpf/libbpf_internal.h | 32 +++++++++++++++++++++
> >  4 files changed, 112 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 056769ce4fd0..503fba903e99 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3620,16 +3620,33 @@ struct bpf_object *bpf_object__open(const char =
*path)
> >       return bpf_object__open_xattr(&attr);
> >  }
> >
> > -struct bpf_object *bpf_object__open_buffer(void *obj_buf,
> > -                                        size_t obj_buf_sz,
> > -                                        const char *name)
> > +struct bpf_object *
> > +bpf_object__open_file(const char *path, struct bpf_object_open_opts *o=
pts)
> > +{
> > +     if (!OPTS_VALID(opts, bpf_object_open_opts))
> > +             return ERR_PTR(-EINVAL);
> > +     if (!path)
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     pr_debug("loading %s\n", path);
> > +
> > +     return __bpf_object__open(path, NULL, 0, 0);
> > +}
>
> This is not doing anything with opts...

oh, my bad, was concentrating on bpf_object__open_mem too much. Good
thing v3 is necessary anyway..

>
> [...]
>
> > +struct bpf_object_open_opts {
> > +     /* size of this struct, for forward/backward compatiblity */
> > +     size_t sz;
> > +     /* object name override, if provided:
> > +      * - for object open from file, this will override setting object
> > +      *   name from file path's base name;
>
> ... but this says it should be, no?
>
> -Toke
>
