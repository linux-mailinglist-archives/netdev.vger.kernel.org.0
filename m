Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E33697E4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243264AbhDWRDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWRDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:03:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E738C061574;
        Fri, 23 Apr 2021 10:02:31 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id g38so56376379ybi.12;
        Fri, 23 Apr 2021 10:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owg94yUIU0a2eRqMOnoPDCKjXrACNS+uhbxAnQkFBqI=;
        b=XYOe2NjaeNttbS+/bzmBLPVv0G2fUZl87TWVzFDiKWN06wUJRdqxX00IX2tU9llt62
         E+xGTjKxtRS/SS81dKCvHXEaOXMXhybPvuK+c5z6X1tLzd/0ZxNEu/ohIy+az/PkFWy8
         EJ4K9FNF8fX5xwSasLWvJs6kqTOMXf5Aoailojd8dAMpKJ/ISFHIpS0qtpCCQ2j1DaUt
         PZE6/TcSeJpVF3zyXxxi5RZCRjt2VTBK/jN8kPaUDS/jQi8xmQEg0D4qWQJDuWwFLNum
         kust6JhcnqluB9LXmkTvsmsTULs+IMNzJBUkkhH/YZzwu62u1o59QNDlEGxPdu+/YSnt
         VKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owg94yUIU0a2eRqMOnoPDCKjXrACNS+uhbxAnQkFBqI=;
        b=I+vYgmij1D9Gtuh8Bd1x37DRg2yK6Q9uoN1iDUS1HZiKJ79xDRnUKeKA5hGg6Qx5YZ
         JgyJQSrEImd6CJY9sM+yoSzhLrhCNm6win1vgOB6JX6qXcGV3l//8LuqvJy+TeoF715V
         D9YSclzo+RCImbzYrgmBUe6/2KjSKuCwJg7ZG5+h27UED0Hs2ARSePkSuYurSCvR7FOy
         snnN+IFRN9OzvfVT1rE3H19FcigNPttVOTY7++o53+qg/I3MwryE5i0Gpa0FJad8DwQA
         XexiDXm7xKb3UEZG/ZLxHx9bjcOgyt9XAFJd4RahjNCWZxwCVSeADClkh+Rp3+V26rlE
         5MMw==
X-Gm-Message-State: AOAM532yMKEgmRqjjOcu5tLPdlZxhRL0RBYLWIRexAZRzR38gk626Oyc
        9G6Q2M1/uedRgQWBqADsEH3EAXlk0xjcnk71QLo=
X-Google-Smtp-Source: ABdhPJxLx0Is4f0m7YmQiEx8RXvbldyfM84RdoX1zH4Ix89f7jtKtSPjrciCTLjym1xZKKm06KPJ0leaEeycKApOon0=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr6268185ybg.459.1619197350640;
 Fri, 23 Apr 2021 10:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
 <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
 <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com>
 <CAEf4BzY8VZyXGUYdtOCvyLjRGGcuOF07rA1OJPTLpRmEat+jbg@mail.gmail.com>
 <CAADnVQJe-5sPyRxWnOwSyVyudkFo-WC2TgxXaibiMRM=54XhgA@mail.gmail.com>
 <CAEf4BzZbaOv0UoGF3Vwim94EgLtkTWtVYnDeuhfEbWkK9B1orw@mail.gmail.com> <CAADnVQLkXhui3K2O4v4u1gfMVXzBdEtfuUixPhnb=n-BdUbH9Q@mail.gmail.com>
In-Reply-To: <CAADnVQLkXhui3K2O4v4u1gfMVXzBdEtfuUixPhnb=n-BdUbH9Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 10:02:19 -0700
Message-ID: <CAEf4Bzaw0Je1zQvbKQh9VP3f1UuWTbsLZjJpyvSCHOr_JZGjsA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 9:34 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 9:31 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > static int remap_type_id(__u32 *type_id, void *ctx)
> > > > {
> > > >         int *id_map = ctx;
> > > >         int new_id = id_map[*type_id];
> > > >
> > > >
> > > > /* Here VOID stays VOID, that's all */
> > > >
> > > >         if (*type_id == 0)
> > > >                 return 0;
> > >
> > > Does it mean that id_map[0] is a garbage value?
> > > and all other code that might be doing id_map[idx] might be reading
> > > garbage if it doesn't have a check for idx == 0 ?
> >
> > No, id_map[0] == 0 by construction (id_map is obj->btf_type_map and is
> > calloc()'ed) and can be used as id_map[idx].
>
> Ok. Then why are you insisting on this micro optimization to return 0
> directly?
> That's the confusing part for me.

I'm not insisting:

  > but I'll rewrite it to a combined if if it makes it easier to follow

So I'm confused why you are confused.

>
> If it was:
> "if (new_id == 0 && *type_id != 0) { pr_warn"
> Then it would be clear what error condition is about.
> But 'return 0' messing things up in my mind,
> because it's far from obvious that first check is really a combination
> with the 2nd check and by itself it's a micro optimization to avoid
> reading id_map[0].

I didn't try to micro optimize, that's how I naturally think about the
problem. I'll rewrite the if, don't know why we are spending emails on
this still.
