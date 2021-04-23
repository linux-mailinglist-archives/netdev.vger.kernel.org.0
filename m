Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5142A3696C8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhDWQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhDWQT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:19:28 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A269C061574;
        Fri, 23 Apr 2021 09:18:52 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r128so51336110lff.4;
        Fri, 23 Apr 2021 09:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfGb5ogijPuDmXHwl7Pp4S+pfB7oeOGlVBJbleVgWig=;
        b=k26jh6sJdWKIhUIfW+ZWjFKWD5WIcJJXyoi4EDs/YlZRtblNGNdsZZMuNe3lKzoqmq
         DGMzzC3v+09cnKgMvFzRYGFTyTJ6wHbqeSi4QBiXo3lTqd+7yusq3P3elSLghZ8Lsd1v
         SN///YDz3G5hkl9dyIQC7direx/ItDMN2pOexKf6RfNxWwfDgMYfWbRSs1wCmeQwLeFy
         dA30VbM+N39JQdgvYZhfAcBwna7mpSfslPGVxZPDk2ezGjVc1yxQRgDli5IFp6KFaVpW
         kJhuv/P5arpPad0UrBmZ+4MusAfHo01xMOC9bU6zWhmT/tKowv/D2IK9+qgkFGhPSZMn
         mmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfGb5ogijPuDmXHwl7Pp4S+pfB7oeOGlVBJbleVgWig=;
        b=B0EaChIf/b3K6UzAB8DWd4tqUsJJ8Pg7mQ0hquosP8He5r3v8WAtVBB0Yi2q50FyVK
         zj2AZsEp+oNWHm4urbdezIHwrsA0qcBk6rGToG+IFXr0RUyl/3zuxPRy3JXxZZKgEhFV
         5XhIzSkuvDeyTxGdjG1FjZ/MVMP2D7lW4p05x0bZ2/zODO1dQZ5sITwhWXIWKMFeIg2m
         XJKmqtge2hWOR29aFmfs8Y1Ap3iTX1n/FyWGtzbUk4YRW77ocueDNpGxb2OBU6tgo1TD
         0PgT9ZGrR7Ox9/IEai1DoCREJtcHabYuyjWIeanBmredhh3jhB50XLC3JlLjrvRdQ40p
         InDQ==
X-Gm-Message-State: AOAM530d9oSQs/smhsl0mwDH+OmfzEzlVXlP5WmWB1UX7PiEnp4bfYZh
        hwU2lKHDwUCJdiWFPWmH+E7/i1dp/VN2oB7QZvI=
X-Google-Smtp-Source: ABdhPJwOEyiRALe1ACS/53iWPwPZsA+xQW1OjN6+bpp359brRJa+Wb4/rksowVu5nwEf7C6H0oGhoYH66Itfl023NOo=
X-Received: by 2002:ac2:491a:: with SMTP id n26mr3512100lfi.539.1619194730603;
 Fri, 23 Apr 2021 09:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
 <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
 <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com> <CAEf4BzY8VZyXGUYdtOCvyLjRGGcuOF07rA1OJPTLpRmEat+jbg@mail.gmail.com>
In-Reply-To: <CAEf4BzY8VZyXGUYdtOCvyLjRGGcuOF07rA1OJPTLpRmEat+jbg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 09:18:39 -0700
Message-ID: <CAADnVQJe-5sPyRxWnOwSyVyudkFo-WC2TgxXaibiMRM=54XhgA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 9:09 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 10:11 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 9:25 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Apr 22, 2021 at 7:54 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Thu, Apr 22, 2021 at 11:24 AM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > >
> > > > > >
> > > > > >
> > > > > > On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > > > > > > It should never fail, but if it does, it's better to know about this rather
> > > > > > > than end up with nonsensical type IDs.
> > > > > >
> > > > > > So this is defensive programming. Maybe do another round of
> > > > > > audit of the callers and if you didn't find any issue, you
> > > > > > do not need to check not-happening condition here?
> > > > >
> > > > > It's far from obvious that this will never happen, because we do a
> > > > > decently complicated BTF processing (we skip some types altogether
> > > > > believing that they are not used, for example) and it will only get
> > > > > more complicated with time. Just as there are "verifier bug" checks in
> > > > > kernel, this prevents things from going wild if non-trivial bugs will
> > > > > inevitably happen.
> > > >
> > > > I agree with Yonghong. This doesn't look right.
> > >
> > > I read it as Yonghong was asking about the entire patch. You seem to
> > > be concerned with one particular check, right?
> > >
> > > > The callback will be called for all non-void types, right?
> > > > so *type_id == 0 shouldn't never happen.
> > > > If it does there is a bug somewhere that should be investigated
> > > > instead of ignored.
> > >
> > > See btf_type_visit_type_ids() and btf_ext_visit_type_ids(), they call
> > > callback for every field that contains type ID, even if it points to
> > > VOID. So this can happen and is expected.
> >
> > I see. So something like 'extern cosnt void foo __ksym' would
> > point to void type?
> > But then why is it not a part of the id_map[] and has
> > to be handled explicitly?
>
> const void foo will be VAR -> CONST -> VOID. But any `void *` anywhere
> will be PTR -> VOID. Any void bla(int x) would have return type VOID
> (0), and so on. There are a lot of cases when we use VOID as type_id.
> VOID always is handled specially, because it stays zero despite any
> transformation: during BTF concatenation, BTF dedup, BTF generation,
> etc.
>
> >
> > > > The
> > > > if (new_id == 0) pr_warn
> > > > bit makes sense.
> > >
> > > Right, and this is the point of this patch. id_map[] will have zeroes
> > > for any unmapped type, so I just need to make sure I'm not false
> > > erroring on id_map[0] (== 0, which is valid, but never used).
> >
> > Right, id_map[0] should be 0.
> > I'm still missing something in this combination of 'if's.
> > May be do it as:
> > if (new_id == 0 && *type_id != 0) { pr_warn
> > ?
> > That was the idea?
>
> That's the idea, there is just no need to do VOID -> VOID
> transformation, but I'll rewrite it to a combined if if it makes it
> easier to follow. Here's full source of remap_type_id with few
> comments to added:
>
> static int remap_type_id(__u32 *type_id, void *ctx)
> {
>         int *id_map = ctx;
>         int new_id = id_map[*type_id];
>
>
> /* Here VOID stays VOID, that's all */
>
>         if (*type_id == 0)
>                 return 0;

Does it mean that id_map[0] is a garbage value?
and all other code that might be doing id_map[idx] might be reading
garbage if it doesn't have a check for idx == 0 ?

> /* This means whatever type we are trying to remap didn't get a new ID
> assigned in linker->btf and that's an error */
>         if (new_id == 0) {
>                 pr_warn("failed to find new ID mapping for original
> BTF type ID %u\n", *type_id);
>                 return -EINVAL;
>         }
>
>         *type_id = id_map[*type_id];
>
>         return 0;
> }
