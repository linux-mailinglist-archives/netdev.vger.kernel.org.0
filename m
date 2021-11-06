Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8639744706E
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 21:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhKFUf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 16:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbhKFUf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 16:35:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6173C061570;
        Sat,  6 Nov 2021 13:32:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso5809939pjb.2;
        Sat, 06 Nov 2021 13:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X6lpn6AMoPP9TRTu8toAjATfa/UQsAtS13j2wxEqZDk=;
        b=FEpfve68/uifvN5DKaowbOH3aYzYGqzjkC/k25/xa/+QfG0zAfN7bVQXfEcjqLiQXn
         G4+RHwRBubW9SFRu/J7e9nntqztrAB16PkGDTLrfjYSQwLngV6Tv7JbaLD8CxTwoJCC+
         k/BF/mfYyfOBomX9WIG7TuShXTAyPkCVZTbCstXHR5eupmqu5uA4/ZF4i9V/amlV9ee9
         Ycg3PEux5JGm78/k0YkBAPtZCfcaTfuNHGFChLHhRiffhZmnhlxQIBySiqj54RXNMgML
         czIL/Vl8OQ/Eq8xfOWO4mvoRmKjEGDP4k4+IMTzOpcdR3r+lEbzye/xsH7NFPI+wdizh
         BM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X6lpn6AMoPP9TRTu8toAjATfa/UQsAtS13j2wxEqZDk=;
        b=rwgnHckQ1GTzSNq6rsDYd+cUeag+sCx3MKlW6zUu5IuYj38AzgZCYJ3M/JXDGflLWF
         OaRNZzzxorlrD9/y5gpXDqK/ebX3rHCvMdSUScm4+e5DYWC4hnhvitDRdnApTJUAku2r
         yKMfQ4cz+mtlzwRKiEceMnuFrhzU3GXUO8yiC4S8Us5y9w50spSWgdv6pE671KKOH5G2
         WvEvadV3ZxtmYhl4xpcyiMvpI8Nl15F1ZWgCWx728AU+XO42YnVyLQW/HVWrHfaQ6Kl3
         U8goOqgi+1pArWLRbMc5x8jGEoW/KxK90AMmE1lxnwppAC52Ib7NICHgJT0TtWiW1Usn
         NPqA==
X-Gm-Message-State: AOAM532umFgBmNiS6A8Im/VO32XMzkrV9hZdIWtDDmHxlo/sZvL0tGk4
        JysXAlaSnTwCGfkIYA2TYN4ndcfLlOAnrUg6cb8=
X-Google-Smtp-Source: ABdhPJyvLi90F5vkQdv/ztpYIFxnvIqhZnUpXOgUaIaotV5cD5aFG/Pvbox2cHdba/Dfh3AIDEQJZq7DAKsqef6ibEs=
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr17923802pjb.62.1636230766231;
 Sat, 06 Nov 2021 13:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211106132822.1396621-1-houtao1@huawei.com> <20211106132822.1396621-2-houtao1@huawei.com>
 <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com> <CAEf4BzZ-g2U-=kLihD3xNkWsZrkg+B29Es=WZqCH1+r5V95sVg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ-g2U-=kLihD3xNkWsZrkg+B29Es=WZqCH1+r5V95sVg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 6 Nov 2021 13:32:35 -0700
Message-ID: <CAADnVQJv1NXV2ZHRQZu8YqOdQzdtD+Ydezoh-usvYvVdqyc0Gw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 6, 2021 at 1:07 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Nov 6, 2021 at 12:26 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Nov 06, 2021 at 09:28:21PM +0800, Hou Tao wrote:
> > > The helper compares two strings: one string is a null-terminated
> > > read-only string, and another one has const max storage size. And
> > > it can be used to compare file name in tracing or LSM program.
> > >
> > > We don't check whether or not s2 in bpf_strncmp() is null-terminated,
> > > because its content may be changed by malicous program, and we only
> > > ensure the memory accessed is bounded by s2_sz.
> >
> > I think "malicous" adjective is unnecessary and misleading.
> > It's also misspelled.
> > Just mention that 2nd argument doesn't have to be null terminated.
> >
> > > + * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
> > ...
> > > +BPF_CALL_3(bpf_strncmp, const char *, s1, const char *, s2, size_t, s2_sz)
> >
> > probably should match u32 instead of size_t.
> >
> > > @@ -1210,6 +1210,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >               return &bpf_get_branch_snapshot_proto;
> > >       case BPF_FUNC_trace_vprintk:
> > >               return bpf_get_trace_vprintk_proto();
> > > +     case BPF_FUNC_strncmp:
> > > +             return &bpf_strncmp_proto;
> >
> > why tracing only?
> > Should probably be in bpf_base_func_proto.
> >
> > I was thinking whether the proto could be:
> > long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
> > but I think your version is better though having const string as 1st arg
> > is a bit odd in normal C.
>
> Why do you think it's better? This is equivalent to `123 == x` if it
> was integer comparison, so it feels like bpf_strncmp(s, sz, "blah") is
> indeed more natural. No big deal, just curious what's better about it.

Only that helper implementation has two less register moves.
which makes it 51%/49% win for me.
