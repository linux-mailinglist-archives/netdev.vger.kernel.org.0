Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61517368C6D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbhDWFMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWFMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:12:10 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22635C061574;
        Thu, 22 Apr 2021 22:11:33 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d27so18779518lfv.9;
        Thu, 22 Apr 2021 22:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIRfzDU/CpJ2GwUwi5qaYyALcM0b/ZoofzJjBH1j+y0=;
        b=pofHhJn5Dbu9gmZ8D0IkPEuxaxfysZnusWgwpk5zuMzElVg5ywpEIYE0dcmAtSQJSB
         X4AxLNumat7hlUCquX+K+3KzFDUyveGLsH25BaXqPDk6aSl30k2A68QdCYayI3M7+pZR
         yyEEdWmRpN9F8x2EQhwuxix0JEkDsuD10hVbitcElO9PlpVJs8ohdxMtcZ+ZnV766wWs
         yEa62gxxAG9z+nPS/PLtBF9yWfWdPFvhK3JVCvCQjO+OPFAIAMgccsjSFmrUZpRMeIbQ
         zFN6bOVMkrFa85m/7S0MDDRCAXgOH/j26Wzs0czw8T11zev0yeOd76T7TsrrxJozv9EW
         SEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIRfzDU/CpJ2GwUwi5qaYyALcM0b/ZoofzJjBH1j+y0=;
        b=IZ31usEJdvDkvDxIwTHR4ckaeIzJnE2tB8d3ybWmFscQQajIlm0B9VMDcteN4L84A7
         9ZEgyN/UfdE9LnEpoc7OGadSkr9GzicAOwdVbYfyBr3B7aotCoD0V5h8VdRc6DEP/wMD
         a66Wn2vjHIQB8TrtBAmA9eWl1mQg04vRhFVdNJIBPRiCYW3YY4sxCpuBEo0syEYN9G8Y
         B1Iv00KNJKAitxxPdb+nlm6gpDvmhtL9L+aRcK1NgSie8ysbTi4Erod3BcAiSRO2+PBq
         CljxdRlqGuc/zS7er2xIFpZ1rwbkGhyVHTL2PkhrmaKDT8QVfQOyiDEu3UQ92pRacljX
         HuEA==
X-Gm-Message-State: AOAM533M9nhi/7kuxpzvKVHIBuEjt2OAxdGf8iTd52qaMRBlcn9gHhge
        3OlG3P3kuHrf65S5njcDyheamd8wgiUz2GoUJT4=
X-Google-Smtp-Source: ABdhPJw8mhdySLWueSTV2SK7AvfuBatrn3Uj6BnJfYkemulWBsXlXDZF+yVlzCCy8onhrwG5HodIQ8JjYtYp8zFgRF8=
X-Received: by 2002:ac2:510d:: with SMTP id q13mr1400930lfb.75.1619154691477;
 Thu, 22 Apr 2021 22:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com> <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
In-Reply-To: <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 22 Apr 2021 22:11:19 -0700
Message-ID: <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com>
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

On Thu, Apr 22, 2021 at 9:25 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 7:54 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 11:24 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > > > > It should never fail, but if it does, it's better to know about this rather
> > > > > than end up with nonsensical type IDs.
> > > >
> > > > So this is defensive programming. Maybe do another round of
> > > > audit of the callers and if you didn't find any issue, you
> > > > do not need to check not-happening condition here?
> > >
> > > It's far from obvious that this will never happen, because we do a
> > > decently complicated BTF processing (we skip some types altogether
> > > believing that they are not used, for example) and it will only get
> > > more complicated with time. Just as there are "verifier bug" checks in
> > > kernel, this prevents things from going wild if non-trivial bugs will
> > > inevitably happen.
> >
> > I agree with Yonghong. This doesn't look right.
>
> I read it as Yonghong was asking about the entire patch. You seem to
> be concerned with one particular check, right?
>
> > The callback will be called for all non-void types, right?
> > so *type_id == 0 shouldn't never happen.
> > If it does there is a bug somewhere that should be investigated
> > instead of ignored.
>
> See btf_type_visit_type_ids() and btf_ext_visit_type_ids(), they call
> callback for every field that contains type ID, even if it points to
> VOID. So this can happen and is expected.

I see. So something like 'extern cosnt void foo __ksym' would
point to void type?
But then why is it not a part of the id_map[] and has
to be handled explicitly?

> > The
> > if (new_id == 0) pr_warn
> > bit makes sense.
>
> Right, and this is the point of this patch. id_map[] will have zeroes
> for any unmapped type, so I just need to make sure I'm not false
> erroring on id_map[0] (== 0, which is valid, but never used).

Right, id_map[0] should be 0.
I'm still missing something in this combination of 'if's.
May be do it as:
if (new_id == 0 && *type_id != 0) { pr_warn
?
That was the idea?
