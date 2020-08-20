Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7464324C336
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgHTQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbgHTQQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:16:03 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27440C061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:16:03 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id k63so542046oob.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UpPzndwiSYhaVueh4zOqhGfv4Oo3BxfBjljCA4pNUIM=;
        b=aS8KE4iTIRs5uiKqL5IP+COnR+Ldcy7QhNI0Fs+SpBbNkrd+GF28NFlOZwVXfU00zl
         j9xlxMBX1SaNs94apFw+bOvHsfgwzhfHg1mPOjpSs/xwohYSdnaeU8+R/NArdJ7qfbDH
         VS5lDOzW9PQPL6PgxyyMlRs2hVSikCAJXxPls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UpPzndwiSYhaVueh4zOqhGfv4Oo3BxfBjljCA4pNUIM=;
        b=Ahw7j0h+SAJ+/qciuiY89oaK0m6c425F9AA8QCtY5QFqB8dRf41GikoIyLYfsld1b9
         NQCR7v0WwRtLmP3h+pYENgcQaYdsXlS7BHETtaHsIO6YFGiUnM9xFToYPun0PM+m8IC+
         p1xCLeWV4JgKE6lfQh4578BbqXtDHXe4wFEZzyCUyFg6NbRSaoDDkj1v/UExdG6mdU8O
         3sniXNlhiECX69AB0qU5+QHbcOCbiqlV9upmadwRPOPo7Ja3/UME3zbTZbaxUKptt90v
         9TjDZ96s7OT88anq7ycSy6VGyhz452YGL0/rE1OlKYAbU16G9Rlq6zl+xdl1v7u/BHXq
         K9Ow==
X-Gm-Message-State: AOAM532namSwtFtEhvvz8FUE+R3m4X12KDKDYsWJpppAh+uJvD11vqCW
        ok0S3wQO8+5wd+st7kAcWN3h52/K2scUYooh3c6Zhw==
X-Google-Smtp-Source: ABdhPJxhIFwfgHxw3SxwdM5trgHfAXmTzg6cKfXYVIO/ijSC/WKBlr9CdxjuEg4Cgs9XTqRC/fGONcWAjPxBeg7NZYw=
X-Received: by 2002:a4a:de49:: with SMTP id z9mr3004747oot.6.1597940160388;
 Thu, 20 Aug 2020 09:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200820135729.135783-1-lmb@cloudflare.com> <20200820135729.135783-5-lmb@cloudflare.com>
 <34027dbc-d5c6-e886-21f8-f3e73e2fde4a@fb.com>
In-Reply-To: <34027dbc-d5c6-e886-21f8-f3e73e2fde4a@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 20 Aug 2020 17:15:48 +0100
Message-ID: <CACAyw98gaWmpJT-LPhqKbKgaPG9s=aNU=K2Db1144dihFHzXJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 at 17:10, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/20/20 6:57 AM, Lorenz Bauer wrote:
> > The verifier assumes that map values are simple blobs of memory, and
> > therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
> > map types where this isn't true. For example, sockmap and sockhash store
> > sockets. In general this isn't a big problem: we can just
> > write helpers that explicitly requests PTR_TO_SOCKET instead of
> > ARG_PTR_TO_MAP_VALUE.
> >
> > The one exception are the standard map helpers like map_update_elem,
> > map_lookup_elem, etc. Here it would be nice we could overload the
> > function prototype for different kinds of maps. Unfortunately, this
> > isn't entirely straight forward:
> > We only know the type of the map once we have resolved meta->map_ptr
> > in check_func_arg. This means we can't swap out the prototype
> > in check_helper_call until we're half way through the function.
> >
> > Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE* to
> > mean "the native type for the map" instead of "pointer to memory"
> > for sockmap and sockhash. This means we don't have to modify the
> > function prototype at all
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >   kernel/bpf/verifier.c | 37 +++++++++++++++++++++++++++++++++++++
> >   1 file changed, 37 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index b6ccfce3bf4c..24feec515d3e 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3872,6 +3872,35 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
> >       return -EINVAL;
> >   }
> >
> > +static int resolve_map_arg_type(struct bpf_verifier_env *env,
> > +                              const struct bpf_call_arg_meta *meta,
> > +                              enum bpf_arg_type *arg_type)
> > +{
> > +     if (!meta->map_ptr) {
> > +             /* kernel subsystem misconfigured verifier */
> > +             verbose(env, "invalid map_ptr to access map->type\n");
> > +             return -EACCES;
> > +     }
> > +
> > +     switch (meta->map_ptr->map_type) {
> > +     case BPF_MAP_TYPE_SOCKMAP:
> > +     case BPF_MAP_TYPE_SOCKHASH:
> > +             if (*arg_type == ARG_PTR_TO_MAP_VALUE) {
> > +                     *arg_type = ARG_PTR_TO_SOCKET;
> > +             } else if (*arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
> > +                     *arg_type = ARG_PTR_TO_SOCKET_OR_NULL;
>
> Is this *arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL possible with
> current implementation?

No, the only user is bpf_sk_storage_get and friends which requires
BPF_MAP_TYPE_SK_STORAGE.
I seemed to make sense to map ARG_PTR_TO_MAP_VALUE_OR_NULL, but I can
remove it as
well if you prefer. Do you think this is dangerous?

>
> If not, we can remove this "else if" and return -EINVAL, right?
>
> > +             } else {
> > +                     verbose(env, "invalid arg_type for sockmap/sockhash\n");
> > +                     return -EINVAL;
> > +             }
> > +             break;
> > +
> > +     default:
> > +             break;
> > +     }
> > +     return 0;
> > +}
> > +
> >   static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                         struct bpf_call_arg_meta *meta,
> >                         const struct bpf_func_proto *fn)
> > @@ -3904,6 +3933,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >               return -EACCES;
> >       }
> >
> > +     if (arg_type == ARG_PTR_TO_MAP_VALUE ||
> > +         arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> > +         arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
> > +             err = resolve_map_arg_type(env, meta, &arg_type);
>
> I am okay with this to cover all MAP_VALUE types with func
> name resolve_map_arg_type as a generic helper.
>
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> >       if (arg_type == ARG_PTR_TO_MAP_KEY ||
> >           arg_type == ARG_PTR_TO_MAP_VALUE ||
> >           arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> >



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
