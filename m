Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B084B1CCC23
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgEJQLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728762AbgEJQLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:11:35 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3E3C061A0C;
        Sun, 10 May 2020 09:11:34 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b26so5382587lfa.5;
        Sun, 10 May 2020 09:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmfY3qFSf1+6Ag0paDgCisPxcIAT37R1HkP3Hpu+pJk=;
        b=pS4JGb+K8jzCEeWFUbdoOXo2EjFeoyNDbNXtoyf4E3QZ2R3LyfqFDEUQ3hVzbg/tho
         gv/KGGLv+nI7LdjKQTM7oycIL3rARHmjvQire7RVnsQqpRqYKh6fggWAjhDLP61wUdKD
         ROJ5DA4eSg6XBYJAYhK77jErpvjaX6BLhYazLIG4BEuKULL9NbvYuJgud8uwc0idffIR
         mAk1si5lMBUlzIagMyXC1E/AhPQaFY+H+Rz7Y3LPTfayW3M3QhP6/1IoW7S5ARBHRBCB
         03s4fG/TKrG/xz5x85cfwzNN07uENHA1tcFyPw4B9CKylGypQqmPGxsfmQaR+TBEF/2K
         9JmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmfY3qFSf1+6Ag0paDgCisPxcIAT37R1HkP3Hpu+pJk=;
        b=VcV6oWAwX02WSe3nNI+OiVuX0a1ls7Q/pawWYS4scd0I6wMNi7rPnqBYxGVBGlUf5g
         zuu+pAga1t8jm447ahYninYHS68g2K5VvED9nt4Y+k7+2mKVHpon87P9tympRq1vHt/2
         SMOvYh+mEr2XNd9t2hsqo4yBwo+HrOIo5K9CTTJOtNEZZiAo6r5H6sEIDGeaS7do00Nc
         CLfBMzU5H+SgQODf4wxIMqMDSS8iCyfDxKRD7lzM/xGimCGz0ilFY9DjxxUZFcj6XQuX
         ec0hoBXiIHDo0loBmSm0m+HcSHXpnepWmwJRRF3dd526V/J3qDV0InWKjbLVA4Sr0zKJ
         sVFw==
X-Gm-Message-State: AOAM530iU1RowKtsL9Vit1jUW0Dz6EXCWJrwDyAXxAogJXeeU4YpdHpx
        d6G/7EW1ImKYfiAmuQq36+3Z1KKTg6q441AqBIE=
X-Google-Smtp-Source: ABdhPJyVhR2zIkBz32aTQ714YPn+LMFxysWNQaP9FIT4wB1ZYCbUEj5KGMS9Vophnh5M5rgvaol5gss7BNZ4AiToNg0=
X-Received: by 2002:ac2:5999:: with SMTP id w25mr7952640lfn.196.1589127092995;
 Sun, 10 May 2020 09:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200509175859.2474608-1-yhs@fb.com> <20200509175912.2476576-1-yhs@fb.com>
 <20200510005059.d3zocagerrnsspez@ast-mbp> <d5b04ac9-3e3c-3e32-4058-afc29e3d34ce@fb.com>
In-Reply-To: <d5b04ac9-3e3c-3e32-4058-afc29e3d34ce@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 May 2020 09:11:21 -0700
Message-ID: <CAADnVQKzhbFe4MQ0G4ZuPnjXbbzEfQMjvTwba4MkhyXQAuNP+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 12/21] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 10:19 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/9/20 5:50 PM, Alexei Starovoitov wrote:
> > On Sat, May 09, 2020 at 10:59:12AM -0700, Yonghong Song wrote:
> >> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >> index a2cfba89a8e1..c490fbde22d4 100644
> >> --- a/kernel/bpf/btf.c
> >> +++ b/kernel/bpf/btf.c
> >> @@ -3790,7 +3790,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >>              return true;
> >>
> >>      /* this is a pointer to another type */
> >> -    info->reg_type = PTR_TO_BTF_ID;
> >> +    if (off != 0 && prog->aux->btf_id_or_null_non0_off)
> >> +            info->reg_type = PTR_TO_BTF_ID_OR_NULL;
> >> +    else
> >> +            info->reg_type = PTR_TO_BTF_ID;
> >
> > I think the verifier should be smarter than this.
> > It's too specific and inflexible. All ctx fields of bpf_iter execpt first
> > will be such ? let's figure out a different way to tell verifier about this.
> > How about using typedef with specific suffix? Like:
> > typedef struct bpf_map *bpf_map_or_null;
> >   struct bpf_iter__bpf_map {
> >     struct bpf_iter_meta *meta;
> >     bpf_map_or_null map;
> >   };
> > or use a union with specific second member? Like:
> >   struct bpf_iter__bpf_map {
> >     struct bpf_iter_meta *meta;
> >     union {
> >       struct bpf_map *map;
> >       long null;
> >     };
> >   };
>
> I have an alternative approach to refactor this for future
> support for map elements as well.
>
> For example, for bpf_map_elements iterator the prog context type
> can be
>      struct bpf_iter_bpf_map_elem {
>         struct bpf_iter_meta *meta;
>         strruct bpf_map *map;
>         <key type>  *key;
>         <value type> *val;
>     };
>
> target will pass the following information to bpf_iter registration:
>     arg 1: PTR_TO_BTF_ID
>     arg 2: PTR_TO_BTF_ID_OR_NULL
>     arg 3: PTR_TO_BUFFER
>     arg 4: PTR_TO_BUFFER
>
> verifier will retrieve the reg_type from target.

you mean to introduce something like 'struct bpf_func_proto'
that describes types of helpers, but instead something similar
to clarify the types in ctx ? That should work. Thanks
