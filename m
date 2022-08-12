Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC515917AA
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiHLXxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 19:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLXxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 19:53:20 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F2866A58;
        Fri, 12 Aug 2022 16:53:19 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id l24so1994328ion.13;
        Fri, 12 Aug 2022 16:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Ir1lHoOfRpwW/dZe/4rIQyh4fxR9qGDtTo/VLvQWsdg=;
        b=TkV+WjHB7jbckRkmPi57Wv6XY5wKUy+uosW0dkgz+BO/XG/leYX2ZMg6F0a/lrwn0F
         zyXClEBKsG0rgp4pW2y9iL5RnXrZdwIe2h2Bm7YUUuHWop6dfIiEjrr3w3VY2UFtWN9Z
         Wgw8KOjPAVhIjvA94XANev8GlFSY35hKf8liNQiYZ0g02b6l86+0VZMSI7kV4AXcZ2Oq
         Dzsl1a+3woPBjHHYPhGaiN+J7Fo4rYi8IZG3VZ6DwXQsztLZSPBFVefFfqW/ZYHZWC0U
         SpkfUgvSKMTd9fVSrxwcgweuE5I/uDVn6P0fyuMYnf3rLSd6xOI0paurij3hmL3YMDXN
         Yzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Ir1lHoOfRpwW/dZe/4rIQyh4fxR9qGDtTo/VLvQWsdg=;
        b=vM+QwqTgDCXv9VxfMEvDIk8HUJPx44XvfqMdNYo+f2Tz0b+Ym91hzAc9k9fLrBrdQf
         j8m3grtwxi2wfVp19N6UIqqxcP3RRQaWAylAG+iWZnXZU0ENOZ0QvyQMGh5KodCfCFEj
         fA6sBvlNmRrB1DA3akZqMVy+b3G/pa+ODfW+3HJoKx3JB4Mmu8fSxaAiUV+jen5QqFYr
         UdjsIuloSN1/ENz9Gh+VNFAVC8RUQxl5N4tuFjRF9zzVbzVnFSSQsGKVDyJXGhk9HJeR
         FKRdaqz/wk9wQKcSu8L9MfOyPXbnW731mccrf4qhq8K2QRVIL24iYVJ6kOUxkr23viQH
         D+yA==
X-Gm-Message-State: ACgBeo3EVn4oSpReLlN2+Aw1sKijJRbc9NOXXvhc0fMiwJq8wwY3LPZp
        jXpwao4GDk7tYnjpY5NHGPl9FGO5s52aJKatbmY=
X-Google-Smtp-Source: AA6agR4kx34uWtcZCvtKDyFSdV0kB0PxAs9+1OC0HJOTa+OUIoUYHpefOR00g/75tknsBHvDVvsaHZScDnOiGoNIknw=
X-Received: by 2002:a05:6602:1346:b0:669:35d4:1a81 with SMTP id
 i6-20020a056602134600b0066935d41a81mr2605900iov.112.1660348398825; Fri, 12
 Aug 2022 16:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220812024038.7056-1-liuhangbin@gmail.com> <407e67b7-b4f2-40db-6e13-409784fe32aa@isovalent.com>
In-Reply-To: <407e67b7-b4f2-40db-6e13-409784fe32aa@isovalent.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Sat, 13 Aug 2022 07:53:07 +0800
Message-ID: <CAPwn2JSacQ6mOOKLL1Ju68BJf5PepnJnziM5k88Gx-7nxtmNmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: making bpf_prog_load() ignore name if
 kernel doesn't support
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     netdev@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 4:38 PM Quentin Monnet <quentin@isovalent.com> wrote:
> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > index 9c50beabdd14..125c580e45f8 100644
> > --- a/tools/lib/bpf/bpf.h
> > +++ b/tools/lib/bpf/bpf.h
> > @@ -35,6 +35,9 @@
> >  extern "C" {
> >  #endif
> >
> > +#define PROG_LOAD_ATTEMPTS 5
> > +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
> > +
>
> bpf.h is the user-facing header, should these go into libbpf_internal.h
> instead?

 libbpf_internal.h makes more sense, I wil move it.

> > +     union bpf_attr attr = {
> > +             .prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
> > +             .prog_name = "test",
> > +             .license = ptr_to_u64("GPL"),
> > +             .insns = ptr_to_u64(insns),
> > +             .insn_cnt = (__u32)ARRAY_SIZE(insns),
> > +     };
>
> I think you cannot initialise "attr" directly, you need a "memset(&attr,
> 0, sizeof(attr));" first, in case the struct contains padding between
> the fields.

Thanks for the reminder. I forgot the padding issue.

I will post version 2.

Thanks
Hangbin
