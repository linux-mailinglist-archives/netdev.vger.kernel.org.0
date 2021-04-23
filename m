Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F946368C24
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhDWE0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWE0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:26:20 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D028DC061574;
        Thu, 22 Apr 2021 21:25:44 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id z1so54128370ybf.6;
        Thu, 22 Apr 2021 21:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXAkZ+YAfZxx+0potAZ3BS9XSrbIjZz3+t1gWmWYx8E=;
        b=ROY51KI4bd0cl+G7KqbfkP0iEZvpAPke82VK5GEY3SolBNThtD52USP8a8Lwh/kqfA
         CGPXTPQG+X1msmuf4iZgQt5Kkotm2MZ2wuiZA1dYEy+f5lxP8gI2OobnaHURBX8llHXm
         VdTfl9LWpqkiOzvURI7hYgZu/gnSfyGdb1dvHDSs+DnqVcCMHqUrzhpRsMh2zbHXc/aC
         1Kq/CvxqduN2UA57XaUZ4w4R4S+P0xBGnthtRCc874/lSJyD6Ku57KGqWsraM1GRFIoa
         B6O+UR6Kc4qBmiUpm1l2E35cJIX3wUV9+dk7UqxlLyhs3aNgrGkNuRuA9dpIGAuL+bQI
         Dd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXAkZ+YAfZxx+0potAZ3BS9XSrbIjZz3+t1gWmWYx8E=;
        b=AgCL7ks6tO2+w+Z72R0XRdcbMbSc+8FLGz4pFd1Km3EqbrWVSXmmtBzjVYRfUrb9Xz
         qffZFGwBVSfTdVGiu6cmWe7aUzUxq6EaoKoYtTo0StaHiAx3BYYTZIBUxvfiHUbnSxXT
         qwozbAnWSIgASLebVkRlFDzo8eB9/cqXw73tTEdPHkiD9W6gF5Zyho9X6DcUnkHKl8do
         u9OLls8I58MRA6IdTmmdsK6RLLFMaGwxfVt380s6r/Th4xJax8cqDxPt1/exi9cn4xcj
         a4cb7mTJ/QFtwLFY7Zt2HtOu2ugtxRlQ4S2ceNKJfmw/GYonltSvsb9KlWUAJ4olEl9e
         SjaA==
X-Gm-Message-State: AOAM531/mu8X95KEoihrz7KhRxIK9fDz7EEwbq+Fmgr/7C8R93MhkvAu
        f2PRklXbxeFxtNkFTChSzIHx1pJ+FRPSvg2zz48=
X-Google-Smtp-Source: ABdhPJwzmYEOdTE5Nbpxjxl6GfbRVsn2LVnXoVrZeoFIRLKY09JqugoYkk6hCG17XUmVklbzCKs0tDxcw7vBrVQOqlc=
X-Received: by 2002:a25:2a0a:: with SMTP id q10mr1767484ybq.403.1619151944053;
 Thu, 22 Apr 2021 21:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
In-Reply-To: <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 21:25:33 -0700
Message-ID: <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
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

On Thu, Apr 22, 2021 at 7:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 11:24 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > > > It should never fail, but if it does, it's better to know about this rather
> > > > than end up with nonsensical type IDs.
> > >
> > > So this is defensive programming. Maybe do another round of
> > > audit of the callers and if you didn't find any issue, you
> > > do not need to check not-happening condition here?
> >
> > It's far from obvious that this will never happen, because we do a
> > decently complicated BTF processing (we skip some types altogether
> > believing that they are not used, for example) and it will only get
> > more complicated with time. Just as there are "verifier bug" checks in
> > kernel, this prevents things from going wild if non-trivial bugs will
> > inevitably happen.
>
> I agree with Yonghong. This doesn't look right.

I read it as Yonghong was asking about the entire patch. You seem to
be concerned with one particular check, right?

> The callback will be called for all non-void types, right?
> so *type_id == 0 shouldn't never happen.
> If it does there is a bug somewhere that should be investigated
> instead of ignored.

See btf_type_visit_type_ids() and btf_ext_visit_type_ids(), they call
callback for every field that contains type ID, even if it points to
VOID. So this can happen and is expected.

> The
> if (new_id == 0) pr_warn
> bit makes sense.

Right, and this is the point of this patch. id_map[] will have zeroes
for any unmapped type, so I just need to make sure I'm not false
erroring on id_map[0] (== 0, which is valid, but never used).

> My reading that it will abort the whole linking process and
> this linker bug will be reported back to us.
> So it's good.

Right, it will be propagated all the way up.
