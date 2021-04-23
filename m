Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E473696A8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhDWQKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWQKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:10:04 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7ECC061574;
        Fri, 23 Apr 2021 09:09:26 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p3so35555332ybk.0;
        Fri, 23 Apr 2021 09:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PppScy9yGIBUpbTFjzNiwr+1UDgZpQDsW+ECfiTrdQ=;
        b=isNXTbR9S4UhCRLC6U0V1rcnVdTOnyX/6FrcJmUlDrw0I24d3suVoNvO33jSLmMU0L
         lMWyw+WkSGag3wA2qNWguA2DhnIKGeuj0FzYvgwDOY8ydBUGePYo1HB9ykICu6Ff7o9a
         6C5fDNWqMwyXeikcZZohz0UlpkYW9GGUT0yxzTJTS5uJuPHJ3/w8prBtGocFHmbGh8BC
         GXlbCCJlckKkciCSPvjV08ywIg28k+FBY0D+NGaosobFGVQdtWxHvpDefWvG3qixKaJI
         DEFaeoK9uurIcaHooqqVyNUDczcHpyXObNPnUCtqRoLrsQubEGMiEwBL66FQujF8HtLn
         lrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PppScy9yGIBUpbTFjzNiwr+1UDgZpQDsW+ECfiTrdQ=;
        b=q79lusG5zeJztloayXosAUPWk9yginGmvag0wkQ968CB5X1vmHGnnKAZm9zoeTXPt9
         ZM9ErRMpB/9dOiiQ/TjK5+00CIMg/gd5UpI2pikZuuX/sngjqJcfxcLVkFOhuqamEpa/
         XMI8Ik2phdeD9ugHBqAJhiL8oxhAMTE/F0axAop0jWdf4HCeE4HPOEIUZjgFyYs8bUnn
         78va1/SBT3kSxAYGR+JE4/467EBCWUbfoHyFYHN4yOa5htRl1Ts/zNlaiP8tZxO0/TI/
         D2PAogORG/cWYq8R1PdZh2Lgb6CIyaNpCcjirtcXwUn05nPI795yIf2PuxFGQl1hvjdb
         4moQ==
X-Gm-Message-State: AOAM530E7hCsfzxNKDiAMq9ru/Gz+swe/FzEaFsxjo9+AjAYGzj+PPb2
        9USpz+ESmrmplksYweMfwVuiPd+JPpky1dAdyH8=
X-Google-Smtp-Source: ABdhPJwbKenXnBC9ZrA/Uaua4QnvMHKc4h+i3ByBpPOSV2758LXZbW59tCqPJEVD2vw/ymipBgbXIUbz922uGeCDato=
X-Received: by 2002:a25:9942:: with SMTP id n2mr6694168ybo.230.1619194160280;
 Fri, 23 Apr 2021 09:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
 <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com> <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com>
In-Reply-To: <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 09:09:09 -0700
Message-ID: <CAEf4BzY8VZyXGUYdtOCvyLjRGGcuOF07rA1OJPTLpRmEat+jbg@mail.gmail.com>
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

On Thu, Apr 22, 2021 at 10:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 9:25 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 7:54 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Apr 22, 2021 at 11:24 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > > > > > It should never fail, but if it does, it's better to know about this rather
> > > > > > than end up with nonsensical type IDs.
> > > > >
> > > > > So this is defensive programming. Maybe do another round of
> > > > > audit of the callers and if you didn't find any issue, you
> > > > > do not need to check not-happening condition here?
> > > >
> > > > It's far from obvious that this will never happen, because we do a
> > > > decently complicated BTF processing (we skip some types altogether
> > > > believing that they are not used, for example) and it will only get
> > > > more complicated with time. Just as there are "verifier bug" checks in
> > > > kernel, this prevents things from going wild if non-trivial bugs will
> > > > inevitably happen.
> > >
> > > I agree with Yonghong. This doesn't look right.
> >
> > I read it as Yonghong was asking about the entire patch. You seem to
> > be concerned with one particular check, right?
> >
> > > The callback will be called for all non-void types, right?
> > > so *type_id == 0 shouldn't never happen.
> > > If it does there is a bug somewhere that should be investigated
> > > instead of ignored.
> >
> > See btf_type_visit_type_ids() and btf_ext_visit_type_ids(), they call
> > callback for every field that contains type ID, even if it points to
> > VOID. So this can happen and is expected.
>
> I see. So something like 'extern cosnt void foo __ksym' would
> point to void type?
> But then why is it not a part of the id_map[] and has
> to be handled explicitly?

const void foo will be VAR -> CONST -> VOID. But any `void *` anywhere
will be PTR -> VOID. Any void bla(int x) would have return type VOID
(0), and so on. There are a lot of cases when we use VOID as type_id.
VOID always is handled specially, because it stays zero despite any
transformation: during BTF concatenation, BTF dedup, BTF generation,
etc.

>
> > > The
> > > if (new_id == 0) pr_warn
> > > bit makes sense.
> >
> > Right, and this is the point of this patch. id_map[] will have zeroes
> > for any unmapped type, so I just need to make sure I'm not false
> > erroring on id_map[0] (== 0, which is valid, but never used).
>
> Right, id_map[0] should be 0.
> I'm still missing something in this combination of 'if's.
> May be do it as:
> if (new_id == 0 && *type_id != 0) { pr_warn
> ?
> That was the idea?

That's the idea, there is just no need to do VOID -> VOID
transformation, but I'll rewrite it to a combined if if it makes it
easier to follow. Here's full source of remap_type_id with few
comments to added:

static int remap_type_id(__u32 *type_id, void *ctx)
{
        int *id_map = ctx;
        int new_id = id_map[*type_id];


/* Here VOID stays VOID, that's all */

        if (*type_id == 0)
                return 0;

/* This means whatever type we are trying to remap didn't get a new ID
assigned in linker->btf and that's an error */
        if (new_id == 0) {
                pr_warn("failed to find new ID mapping for original
BTF type ID %u\n", *type_id);
                return -EINVAL;
        }

        *type_id = id_map[*type_id];

        return 0;
}
