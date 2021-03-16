Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30DC33E0A6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCPVfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhCPVfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:35:01 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6921C06174A;
        Tue, 16 Mar 2021 14:34:51 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 133so38390702ybd.5;
        Tue, 16 Mar 2021 14:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJLtePqUNhM4zQSXLUYUwpOWeYPKdhMjC6eTeYNKtlA=;
        b=OmDzd/AOwGZf8jOOAfzfCn+9DBEoeSzJEJeBbb6K3joUj7n8F3/FRIFXVJ1FTSeWm7
         HIKAuSswnLeghQwvVsfg76z1DLA11TOKWIPcJ92mG1iMhT5WlV4fEJC0iNQljR4n+3t9
         Hhpztbpx73ZUcnTqVDE7TMeR1VjYTd8aYSpyE4MGPpSDiQ9z1eX9SuQZqb3EULhzpQ2B
         9qktLZUeKwMlpotHSWrEqxicOqZLxPGvLFd8RarmrWrjdre44FtVgy1xilNpSNLMI0uJ
         q8ubRX9enYaYegaop/0OuqR+QLnLrk126J/UCtkp4VnuvO4MD7BFo4gqhJQYs169/WU1
         D7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HJLtePqUNhM4zQSXLUYUwpOWeYPKdhMjC6eTeYNKtlA=;
        b=hlwNjAZn1W/OS1g183YvBApbSDgPAcUrXBEyYiadqA6P6GNAHPEcplgTSk3635gMO8
         uSDLmy3DJfgBa6jpuDvtjTF99CCo2SgcOElUQ1tFCz8m9Vv7yPDQcGTkbZX+PERRXo5S
         aaDm5zLH0dzD5Er9OsWuN3wQ4UH+EJh45DjEYgv84kcceCmBpF+3tGHsZNDUZkY224g5
         qpmTnP7KSrkBkxoEcbi0wY2HzhN9jZ1TFwxOJ9aE52xPZADt34/v3uiMYuO6oLQ5zDwE
         Qlb8A8MVBJqsRbm56wRKjAW7inpjfXrM+hDx9xjV+2pMh++cZpUdtmWRtbZEffRJkZYJ
         FAxQ==
X-Gm-Message-State: AOAM530l1mQLGRYl8F3Eh/JZN+uHKxKbp2cFRzavc1VmCgS68nA7DpiB
        o4wCB91egtLPztZYQuav8AKBjKFIZ/ofOCO6pF0=
X-Google-Smtp-Source: ABdhPJxGRpWX00ea6r/doF82KubQtZX/E2gar0oiaIiQNiHZezUy8vI1/rP/G9lUMPVo75pARDYXgqUmUCDrIM64PmE=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr1237486yba.510.1615930490897;
 Tue, 16 Mar 2021 14:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210314173839.457768-1-pctammela@gmail.com> <5083f82b-39fc-9d46-bcd0-3a6be2fc7f98@iogearbox.net>
In-Reply-To: <5083f82b-39fc-9d46-bcd0-3a6be2fc7f98@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Mar 2021 14:34:40 -0700
Message-ID: <CAEf4Bza3vs3P0+zua5j8kJwCDXeiA3Up+t8f58AqswceHca7cA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: avoid inline hint definition from 'linux/stddef.h'
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 2:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/14/21 6:38 PM, Pedro Tammela wrote:
> > Linux headers might pull 'linux/stddef.h' which defines
> > '__always_inline' as the following:
> >
> >     #ifndef __always_inline
> >     #define __always_inline __inline__
> >     #endif
> >
> > This becomes an issue if the program picks up the 'linux/stddef.h'
> > definition as the macro now just hints inline to clang.
>
> How did the program end up including linux/stddef.h ? Would be good to
> also have some more details on how we got here for the commit desc.

It's an UAPI header, so why not? Is there anything special about
stddef.h that makes it unsuitable to be included?

>
> > This change now enforces the proper definition for BPF programs
> > regardless of the include order.
> >
> > Signed-off-by: Pedro Tammela <pctammela@gmail.com>
> > ---
> >   tools/lib/bpf/bpf_helpers.h | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index ae6c975e0b87..5fa483c0b508 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -29,9 +29,12 @@
> >    */
> >   #define SEC(NAME) __attribute__((section(NAME), used))
> >
> > -#ifndef __always_inline
> > +/*
> > + * Avoid 'linux/stddef.h' definition of '__always_inline'.
> > + */
>
> I think the comment should have more details on 'why' we undef it as in
> few months looking at it again, the next question to dig into would be
> what was wrong with linux/stddef.h. Providing a better rationale would
> be nice for readers here.

So for whatever reason commit bot didn't send notification, but I've
already landed this yesterday. To me, with #undef + #define it's
pretty clear that we "force-define" __always_inline exactly how we
want it, but we can certainly add clarifying comment in the follow up,
if you think it's needed.

>
> > +#undef __always_inline
> >   #define __always_inline inline __attribute__((always_inline))
> > -#endif
> > +
> >   #ifndef __noinline
> >   #define __noinline __attribute__((noinline))
> >   #endif
> >
>
