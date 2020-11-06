Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67812AA008
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgKFWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbgKFWTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:19:14 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601CC0613CF;
        Fri,  6 Nov 2020 14:19:14 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id n142so2465530ybf.7;
        Fri, 06 Nov 2020 14:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WanxnqkYhRjw460Id+Jeks/pBXcSZo2qqD1EwrNVLLw=;
        b=Xi3XWP6mkcgYPweCl1fPdL5vQLXUv/3Vb9Eef0Midt/4JJTgQ6eOoQvwzGLwhNb9Of
         xdNvokvqbbCL/74//x8FgUy4iMJ4vqXVqGQe2Rdr7kad5cVsjEGXZcOHUz37z+PFkfNo
         DQzMHRnQM7t20mawQA4g3FGfpAIDG7addkWwzuI2NU0bhuW2KfXpTgoIBWTCH/FnvvX+
         sBpWKiRhzBOi47WTiiyg+jxVga8eh/33kldBt24jHTE0XMG65NZoW5Z2m6nmiR3rtwID
         7GEFdtrG+2grZlCz+GLfRrF2ghMwKfG4Vh9NLEJ9QO2iznXg3tq0CdVSY1CRXRMDKkn9
         rWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WanxnqkYhRjw460Id+Jeks/pBXcSZo2qqD1EwrNVLLw=;
        b=rarAIsAhXC4wJJ8+97G54b5CwHGut+KSeHGdWw/g18L/Ildecivue1XFTdfpLDFnQK
         DZ8aclP7etAKcqtcAGiV/BREIwO5p9JBCNzMcbzRFpuHS0gp/7VuTar9xH2yv5q6eRTm
         sFhQha+MAQ2mdec/WqxVKgvC+38ZDNQiLXR9mgBpN/oQAeQITmjKTv7l2dqmhkYxTsVX
         9IYcCnl/15guF1n4QvAZcTUwb2JZ059w+hfuq29WvBk5tG8tIfDKhpt165tafrF3jCyF
         gDXwU06AvdyNa392DB2GGO+96Nm26U+cRpSA753xcUBu+PYdluYo4R1d3etwCthHik4U
         N7QA==
X-Gm-Message-State: AOAM533/QsVop0LyLc3+a+HNLyl8LmDq6VTeAl47jTJBzg5pmEyBTFmT
        ZH+FsxCKwoGLhSgt/kZyt/r1EPjyeion+VxOeWk=
X-Google-Smtp-Source: ABdhPJwGdjfCrkbfgaEa32pQikhk/isfpKRxe8UdBpNUWOh1+6OkXAPjTV32wN0Cl+LFBakQ+D9SgnPv+KO0+IRec8o=
X-Received: by 2002:a25:afc1:: with SMTP id d1mr5534392ybj.27.1604701153997;
 Fri, 06 Nov 2020 14:19:13 -0800 (PST)
MIME-Version: 1.0
References: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
 <CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com> <d1cefb17a0a915fdabe7a80d14895ff3d85970c1.camel@perches.com>
In-Reply-To: <d1cefb17a0a915fdabe7a80d14895ff3d85970c1.camel@perches.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 14:19:03 -0800
Message-ID: <CAEf4BzYLRAZrCTDpECUDBN-JeAfHnPWBOHgpk5xSu9OpDd1q7A@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove unnecessary conversion to bool
To:     Joe Perches <joe@perches.com>
Cc:     xiakaixu1987@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 1:50 PM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2020-11-06 at 13:32 -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 5, 2020 at 11:12 PM <xiakaixu1987@gmail.com> wrote:
> > > Fix following warning from coccinelle:
> > > ./tools/lib/bpf/libbpf.c:1478:43-48: WARNING: conversion to bool not needed here
> []
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> []
> > > @@ -1475,7 +1475,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> > >                                 ext->name, value);
> > >                         return -EINVAL;
> > >                 }
> > > -               *(bool *)ext_val = value == 'y' ? true : false;
> > > +               *(bool *)ext_val = value == 'y';
> >
> > I actually did this intentionally. x = y == z; pattern looked too
> > obscure to my taste, tbh.
>
> It's certainly a question of taste and obviously there is nothing
> wrong with yours.
>
> Maybe adding parentheses makes the below look less obscure to you?
>
>         x = (y == z);

Yeah, I think this would be explicit enough. But let's keep the *(bool
*) cast and keep switch code shorter and without extra {} block.

>
> My taste would run to something like:
> ---
>  tools/lib/bpf/libbpf.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>

[...]
