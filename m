Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C60E85451
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389137AbfHGUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:10:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43564 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbfHGUKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:10:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so9088128qto.10;
        Wed, 07 Aug 2019 13:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SErlbb0y5L/aKARO6Vw0SsAtfcwIDkq0Ah1o9nG9mJM=;
        b=o1nRzyfd/FmlHR+0yCUVKXC4PPtdvjajP6nKsm4GxDUoMFpAaRCk0boZzHdzPWCss5
         PkFDjRLEeHlA1ZJxmx/YNPTKDfibt6hC0qAmJzyIPAPiatrLpLpgiCoj3pzpQ1epOE8R
         DvWPkXowkAKSImzdUTo/Fe23ESTa6sP1c5j1QEwq05JXWIHd0z9kVaOXZu8+ED6IYzR/
         9a4HCPR8vwHQFc7wdSrFnRmj7uDnHfAOGyqiCpxVXZRNRw23jYbE/e9FVw6FeVC60DLI
         mleusLA1OyZX5fVkDGNouMF13mbNxzJoYOismtBLP3ONPm9WVrY5M2SzdqrIpjEQSNwz
         tqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SErlbb0y5L/aKARO6Vw0SsAtfcwIDkq0Ah1o9nG9mJM=;
        b=Q4tSgyEA+c+SXu37csRo/THjGX2U6oGoAQqPi6skfuuhLTAJRjjWCv4RID+dXjGt2f
         6xY8e5ah0CMzCCYQYH76oZd1pzlH1oVvGyZCZRtJp+eIVZx1FzJUpgMFS+Eyj4vvn0X4
         1hfpxnyz1tjZJXbJrcHABdHYfPHg+LUYJZk7cIgmDxXixcDT6fq08Q1nGm5yu9k6gjj8
         wnWNdat9OdGk1WPzUqInEHDywhP7Na002ldgt8cIokgeDAWlRvKeBQXfTrQ02XiF3DL+
         1pq1t2Tx5cToESXESJtLYgzkew9YXfglYo+LG4/MVUi/uiIgVpZV1NY8X6gbA6eWSHaa
         tQVA==
X-Gm-Message-State: APjAAAVtW+9f9rGLQ9/Uczd9UflDlpJMHAAtRjQm4M3EGfdc/Gl1KzFd
        euUeonBKO8PvY4KziBP+iFNrMJKBRBxFDt75fIA=
X-Google-Smtp-Source: APXvYqy5ThF1LnCDxBXUh7Bgr5iBPjgFpVX9g5synIgUmVsWEvRI2A5fTsZcXlAk0w1TzG6/xeFbPDSveYBzVMQqgis=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr7891989qvv.38.1565208646174;
 Wed, 07 Aug 2019 13:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190807053806.1534571-1-andriin@fb.com> <20190807053806.1534571-3-andriin@fb.com>
 <20190807193011.g2zuaapc2uvvr4h6@ast-mbp> <CAEf4BzahxLWRVNcNWpba7_7CbbQgN8k0RU8Ya1XCK8j4rPQ0NQ@mail.gmail.com>
 <151d13d1-e894-56cc-4690-4661c8afc65e@fb.com>
In-Reply-To: <151d13d1-e894-56cc-4690-4661c8afc65e@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Aug 2019 13:10:34 -0700
Message-ID: <CAEf4BzYPfMvNt57oP7YH1Subi6vE7ptcjkdBkdRCVcs=hw5LSQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 02/14] libbpf: convert libbpf code to use new
 btf helpers
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 1:01 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 8/7/19 12:59 PM, Andrii Nakryiko wrote:
> > On Wed, Aug 7, 2019 at 12:30 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Tue, Aug 06, 2019 at 10:37:54PM -0700, Andrii Nakryiko wrote:
> >>> Simplify code by relying on newly added BTF helper functions.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >> ..
> >>>
> >>> -     for (i = 0, vsi = (struct btf_var_secinfo *)(t + 1);
> >>> -          i < vars; i++, vsi++) {
> >>> +     for (i = 0, vsi = (void *)btf_var_secinfos(t); i < vars; i++, vsi++) {
> >>
> >>> +                     struct btf_member *m = (void *)btf_members(t);
> >> ...
> >>>                case BTF_KIND_ENUM: {
> >>> -                     struct btf_enum *m = (struct btf_enum *)(t + 1);
> >>> -                     __u16 vlen = BTF_INFO_VLEN(t->info);
> >>> +                     struct btf_enum *m = (void *)btf_enum(t);
> >>> +                     __u16 vlen = btf_vlen(t);
> >> ...
> >>>                case BTF_KIND_FUNC_PROTO: {
> >>> -                     struct btf_param *m = (struct btf_param *)(t + 1);
> >>> -                     __u16 vlen = BTF_INFO_VLEN(t->info);
> >>> +                     struct btf_param *m = (void *)btf_params(t);
> >>> +                     __u16 vlen = btf_vlen(t);
> >>
> >> So all of these 'void *' type hacks are only to drop const-ness ?
> >
> > Yes.
> >
> >> May be the helpers shouldn't be taking const then?
> >>
> >
> > Probably not, because then we'll have much wider-spread problem of
> > casting const pointers into non-const when passing btf_type into
> > helpers.
> > I think const as a default is the right choice, because normally BTF
> > is immutable and btf__type_by_id is returning const pointer, etc.
> > That's typical and expected use-case. btf_dedup and BTF sanitization +
> > datasec size setting pieces are an exception that have to modify BTF
> > types in place before passing it to user.
> >
> > So realistically I think we can just leave it as (void *), or I can do
> > explicit non-const type casts, or we can just not use helpers for
> > mutable cases. Do you have a preference?
>
> Hmm. Take a const into the helper and drop it there?
> I'd like to avoid all these 'void *'.

Well, I guess it's a way to do this as well. Given it's C, I guess
it's acceptable to be so free about constness. I'll update patches.
