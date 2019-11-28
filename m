Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4250C10C1F6
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 02:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfK1BxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 20:53:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40366 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfK1BxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 20:53:04 -0500
Received: by mail-lj1-f196.google.com with SMTP id s22so7602309ljs.7;
        Wed, 27 Nov 2019 17:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sjoIpFpRenJ43SEbjdtws32ttw6a5wLdlbCVT5pndaQ=;
        b=q61J3ZTEbhk/7GIlrL4eaVHPJE03jjQZK5TCfgcz/1DbBt7+9BDIGhNfCOBmpobbJk
         6FRxlnkcSmazOdKB4luTKr1i3esan4cF6c5U1fM4YHAtVils6SZuOdmt+ST5f1F2UcOj
         qtA2qp8e9JWNaLk3rYc1QxU7ijgVjswAo8lEXxVC5umtHjYTuF1/PGrCW5i56dZOp7du
         PX90rTPy2mFdcAU2W5cZ8nnxAzCz9P/PnpY2xsrcpRuVj+YwvxjVdm8ZvF3zIiNoiPsl
         E77OQECS0voPkg5X1Y1SScRUFNzWSgxVXH+8xT7Ab3T11c920kzZGfgNzacMfZL/9jIA
         CEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sjoIpFpRenJ43SEbjdtws32ttw6a5wLdlbCVT5pndaQ=;
        b=o/2db4zaaNtzW1cpmTXPk5aOoKckNDi8SS7IBaG5e6RKjMD5lUrn7g18YFgfBG0sxI
         Or/xrj2lv0ZBQhneKlb00pbzgnO7fQV+3Kgh4kpxkTP1OmxiZk1vLpreoiALNu+fdcK9
         g7EelekyvGV9wrbNexN6WhiPf1SBSUB2f8QBDuHEGk1mQTlfBo/Ob9U8ch4kzz+V3P2x
         yKP8YdbPAVI4+thX9Z7+uxLkfeP2Ili9PZ2Px3GRqQ+hxu9KOFBNG+zlDBjju94wlh2t
         EwX6PNo4iAzjnlQPoBBzlUc+mCyUGwxLCFDLK8GQaRUl44Hq2mW67hZBJHZRuXUTiitI
         CHRg==
X-Gm-Message-State: APjAAAXK28YHtJUtrUadRrSAdDIrOPlobGjQb1FOvy1LuzrnqkqChK4L
        ZnJLR9dXQAxhnqwfJhN6FOF2Pg1yhQVGU1qPeUMbfchX
X-Google-Smtp-Source: APXvYqxak1JG+XREoRk/MyoRGKdT9xeT7/OZtEGmbWsmKSDSZvhvs9D9Viubh5oOkbK+eLBNy7ZGgHxej6ZoszhbOLo=
X-Received: by 2002:a2e:9181:: with SMTP id f1mr2692282ljg.51.1574905982362;
 Wed, 27 Nov 2019 17:53:02 -0800 (PST)
MIME-Version: 1.0
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com>
 <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org> <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com>
 <58CA150B-D006-48DF-A279-077BA2FFD6EC@kernel.org> <CAADnVQLFVH000BJM4cN29kcC+KKDmVek3jaen3cZz2=12jP58g@mail.gmail.com>
 <D93F5A0F-7675-4A66-B90A-C6091F995BE5@kernel.org>
In-Reply-To: <D93F5A0F-7675-4A66-B90A-C6091F995BE5@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 17:52:51 -0800
Message-ID: <CAADnVQLRjzSFy+m=3q2-xqfDjeT1ChNda7f62MS+wtRvQ-616w@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 5:26 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> On November 27, 2019 10:20:17 PM GMT-03:00, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >On Wed, Nov 27, 2019 at 5:17 PM Arnaldo Carvalho de Melo
> ><arnaldo.melo@gmail.com> wrote:
> >>
> >> On November 27, 2019 9:59:15 PM GMT-03:00, Alexei Starovoitov
> ><alexei.starovoitov@gmail.com> wrote:
> >> >On Wed, Nov 27, 2019 at 4:50 PM Arnaldo Carvalho de Melo
> >> ><arnaldo.melo@gmail.com> wrote:
> >> >>
> >> >> Take it as one, I think it's what should have been in the cset it
> >is
> >> >fixing, that way no breakage would have happened.
> >> >
> >> >Ok. I trimmed commit log and applied here:
> >>
> >>https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=1fd450f99272791df8ea8e1b0f5657678e118e90
> >> >
> >> >What about your other fix and my suggestion there?
> >> >(__u64) cast instead of PRI ?
> >> >We do this already in two places:
> >> >libbpf.c:                shdr_idx, (__u64)sym->st_value);
> >> >libbpf.c:             (__u64)sym.st_value,
> >GELF_ST_TYPE(sym.st_info),
> >>
> >>
> >> I'm using the smartphone now, but I thought you first suggested using
> >a cast to long, if you mean using %llu + cast to __u64, then should be
> >was ugly as using PRI, IOW, should work on both 64 bit and 32 bit. :-)
> >
> >Yes. I suggested (long) first, but then found two cases in libbpf that
> >solve this with (__u64),
> >so better to stick to that for consistency.
>
> If it's already being used elsewhere in lubbpf, it was tested already with the build containers and since nobody complained, go with it :-)

Ok.
Pushed this fix:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=7c3977d1e80401b1a25efded698b05d60ee26e31
Likely will send PR for bpf tree to Dave tomorrow.
