Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF954647C5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbhLAHVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhLAHVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:21:16 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9104CC061574;
        Tue, 30 Nov 2021 23:17:55 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g17so60452812ybe.13;
        Tue, 30 Nov 2021 23:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgCf7H2QIscKYgcL7m10lgHqnVySdW0PeZbQQpk2RTU=;
        b=jwScB/ESINH9zhgU/5svpJusVqaNyAktCbTuSU8SmQolFcSz+AEvL9lRRvfZMSNPaJ
         XWTtVGFECWPLrOb/wAfFSDJwLePbYcSGednwBamx2rPxR0dPgA/8OaQKXXDFom4B6bP6
         PoURDZVNsKqIHlQqymAPKB8LbtfI7UkxdFpZ+y/xe2B7B0V7ZfWYPiWmhhVDEadwV982
         dHYKw9j9s/6aQDhfzv6XpDqROpeZDLhH/Jk8/0qQ9guCrvrQg+Vhgma/Qfa3H0UwGRMt
         0eQ+dJn4RAUHgM38XmHeJiBHI7RYdbNKB6pZ5aqkab+pZxTSSPOCIMv3KM3C/cmf3w4q
         BY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgCf7H2QIscKYgcL7m10lgHqnVySdW0PeZbQQpk2RTU=;
        b=GeY9exPqRdc3U99FjVnT0+WyNaU5rYs/uMy5bB0PRg4rV6qCoS5Z1NAERHVOjAMIlT
         yRcIZSEeGHnEvO14lqeaLOtxfiKu7AUzx8V9eZL/HEmXtFOzV+mM16pqrfqHhus/d/HB
         Ed1ACkYak2RaPILl8lgkWXpGJkNX/UZ0lW1lFLaNLI1+IGfBBuq9j6Wt64kBeSElDOa8
         lBcQqKLyFZ+x/bgsuy+//JbN6ZO9ydIU211MJmTU7XowlTtlrdv6keLbH8ryg6/ds9JC
         PdisIaeKfgyuL8e//LFOaAx0zqZQpTWRBR8Irvugtf8E92QSQJYg8MxoMnhCyQ7DayYu
         RGEg==
X-Gm-Message-State: AOAM5334bfPnmClFf2Oqm/wvj36tNv8C4MCtnqGCp0/wxLKP/b3kz8+P
        KfF9ZXdgJFL5rKA6szJvl8r7zwUmuQWXo03nkRs=
X-Google-Smtp-Source: ABdhPJxW8HmWp8w4Rr0S8vIW3BEtVBrW4VT3h/auWe3x3dmNxU53XM7cgmiyyu38XlNiLeaT3R191uUZ5vVCY4sbJBQ=
X-Received: by 2002:a25:e617:: with SMTP id d23mr5007065ybh.555.1638343074863;
 Tue, 30 Nov 2021 23:17:54 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-10-jolsa@kernel.org>
 <20211119041159.7rebb5lz2ybnygqr@ast-mbp.dhcp.thefacebook.com>
 <YZv6VLAuv+4gPy/4@krava> <CAEf4Bzad=O3PgZ9Z55HpuiobQTkhA57GHFEV2M6JveG_nzP40A@mail.gmail.com>
 <YaO/O4bNeg2JRrbU@krava>
In-Reply-To: <YaO/O4bNeg2JRrbU@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 23:17:44 -0800
Message-ID: <CAEf4Bza5ceiQS0jLAsoCvMSb4CbS7vJ-Qym=wn7CzOGsU2g_DQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/29] bpf: Add support to load multi func
 tracing program
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 9:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Nov 24, 2021 at 01:51:36PM -0800, Andrii Nakryiko wrote:
> > On Mon, Nov 22, 2021 at 12:15 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, Nov 18, 2021 at 08:11:59PM -0800, Alexei Starovoitov wrote:
> > > > On Thu, Nov 18, 2021 at 12:24:35PM +0100, Jiri Olsa wrote:
> > > > > +
> > > > > +DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
> > > > > +                 unsigned long a3, unsigned long a4,
> > > > > +                 unsigned long a5, unsigned long a6)
> > > >
> > > > This is probably a bit too x86 specific. May be make add all 12 args?
> > > > Or other places would need to be tweaked?
> > >
> > > I think si, I'll check
> > >
> > > >
> > > > > +BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
> > > > ...
> > > > > -   prog->aux->attach_btf_id = attr->attach_btf_id;
> > > > > +   prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;
> > > >
> > > > Just ignoring that was passed in uattr?
> > > > Maybe instead of ignoring dopr BPF_F_MULTI_FUNC and make libbpf
> > > > point to that btf_id instead?
> > > > Then multi or not can be checked with if (attr->attach_btf_id == bpf_multi_func_btf_id[0]).
> > > >
> > >
> > > nice idea, it might fit better than the flag
> >
> > Instead of a flag we can also use a different expected_attach_type
> > (FENTRY vs FENTRY_MULTI, etc).
>
> right, you already asked for that - https://lore.kernel.org/bpf/YS9k26rRcUJVS%2Fvx@krava/
>
> I still think it'd mean more code while this way we just use
> current fentry/fexit code paths with few special handling
> for multi programs
>

I don't see how it makes much difference for kernel implementation.
Checking expected_attach_type vs checking prog_flags is about the same
amount of code. The big advantage of new expected_attach_type (or
prog_type) is that it will be very obvious in all sorts of diagnostics
tooling (think bpftool prog show output, etc). prog_flags are almost
invisible and it will be the last thing that users will think about.
I'd try to minimize the usage of prog_flags overall.

> > As for attach_btf_id, why can't we just
> > enforce it as 0?
>
> there's prog->aux->attach_func_proto that needs to be set based
> on attach_btf_id, and is checked later in btf_ctx_access

right:

if (attach_btf_id == 0)
    prog->aux->attach_func_proto =
&special_func_model_or_proto_or_whatever_that_does_not_have_to_be_known_to_libbpf_and_outside_world_ever;

;) let's keep implementation details as internal implementation
details, instead of dumping all that to UAPI

>
> jirka
>
> >
> > >
> > > thanks,
> > > jirka
> > >
> >
>
