Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4113B992E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfITVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 17:51:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43182 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfITVv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 17:51:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id c3so10357475qtv.10;
        Fri, 20 Sep 2019 14:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JyV3eQ6Txws71HKCK24SrBhT6PsVZFz2DYxOGXDUyAU=;
        b=ZqCT0beTqmAjmXhDyXh28o7FSbUyirsuCTK6mfjtWlHrDSPUB6Wrl/3k94MT2YFwup
         EbbiOW1eTm7wyq0p+MKUcDg/kBZXhsVbHhTHpHx1aqTtG6jOPqPXm//y1H/FHLQrjn04
         9sWGA2Pgoqih53m1DHJjZeHGUDb3zTLl7GR7swZZkcReY1jSq0MrDns6SHahQKeKqpl7
         GZzM//3p082FukWjfvxb1snV2hdsPPV47n30lniGj5kj7rn/hd20551dhsO4DyPNCIp1
         SUDGe50CDrhXsVwkX7MbeNwi2SUH8mmXaXKCJwFL4pD8qexXtosWChP/MXPecMo1f6sB
         YCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JyV3eQ6Txws71HKCK24SrBhT6PsVZFz2DYxOGXDUyAU=;
        b=G2BIWc58ztSw05UKS2IkZu6E50PaQXmu3DnGgmhbmjYb80BYfHH3NANX1gpFV7L8sq
         nVWLJgghvl+8Ocfw/mJykFqynZGvTatkdGGMepkAQ08yIMpKTThH1kyzqyjJdhs2rCWs
         vAl82Ya0E+GTjU5AO9mczLR7dqjFNjiw7WKe2ao85RIXqtZz7QZtsPJp/48MNOB0O/8x
         Jsh/hSHLjQ01tadRh32XK0W47tyRyG3tkpVcvx2BwwutQMjk1zBl+vGv6NTzYBV0wdRW
         AuiTtn9bZdkIbWGTwE4OtioCX6Uvu3KW4NgvLi0iPqO38V5YqRHwFYWAOVpiv9pe0w+Y
         LsIQ==
X-Gm-Message-State: APjAAAVLTot1zxQXHpPBy6XGizLSBInfzrwFuL3iorrldL2AG85Myoji
        ScQ8pNAs2CPuVC3rDpINRhHzdtPR3pWGWa43jA+myQ==
X-Google-Smtp-Source: APXvYqxfY8raxBEebjXOuo+E4xqbSqW+LOmgA/YRHzphdGNLvbHWp48LTp6h50xBP99SDiX0r2hsxmbCKWQCeE81ug4=
X-Received: by 2002:ac8:1417:: with SMTP id k23mr5352617qtj.93.1569016284859;
 Fri, 20 Sep 2019 14:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
 <CAEf4BzbCjCYr5NMPctDkUggwpehnqZPVBSqZOsd9MvSq6WmnZQ@mail.gmail.com>
 <20190920082204.GC8870@khorivan> <CAEf4BzaVuaN3HhMu8W_i9z4n-2zfjqxBXyOEOaQHexxZq7b3qg@mail.gmail.com>
 <20190920183449.GA2760@khorivan> <20190920191941.GB2760@khorivan>
In-Reply-To: <20190920191941.GB2760@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Sep 2019 14:51:14 -0700
Message-ID: <CAEf4BzZGeY-WD17mq6FTd7Rae_f26j4kBAWCmuppeu4VjZxvUg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 12:19 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Fri, Sep 20, 2019 at 09:34:51PM +0300, Ivan Khoronzhuk wrote:
> >On Fri, Sep 20, 2019 at 09:41:54AM -0700, Andrii Nakryiko wrote:
> >>On Fri, Sep 20, 2019 at 1:22 AM Ivan Khoronzhuk
> >><ivan.khoronzhuk@linaro.org> wrote:
> >>>
> >>>On Thu, Sep 19, 2019 at 01:02:40PM -0700, Andrii Nakryiko wrote:
> >>>>On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
> >>>><ivan.khoronzhuk@linaro.org> wrote:
> >>>>>
> >>>>> It's very often for embedded to have stripped version of sort in
> >>>>> busybox, when no -V option present. It breaks build natively on target
> >>>>> board causing recursive loop.
> >>>>>
> >>>>> BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
> >>>>> Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
> >>>>> start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
> >>>>>
> >>>>> Lets modify command a little to avoid -V option.
> >>>>>
> >>>>> Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
> >>>>>
> >>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >>>>> ---
> >>>>>
> >>>>> Based on bpf/master
> >>>>>
> >>>>>  tools/lib/bpf/Makefile | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> >>>>> index c6f94cffe06e..a12490ad6215 100644
> >>>>> --- a/tools/lib/bpf/Makefile
> >>>>> +++ b/tools/lib/bpf/Makefile
> >>>>> @@ -3,7 +3,7 @@
> >>>>>
> >>>>>  LIBBPF_VERSION := $(shell \
> >>>>>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> >>>>> -       sort -rV | head -n1 | cut -d'_' -f2)
> >>>>> +       cut -d'_' -f2 | sort -r | head -n1)
> >>>>
> >>>>You can't just sort alphabetically, because:
> >>>>
> >>>>1.2
> >>>>1.11
> >>>>
> >>>>should be in that order. See discussion on mailing thread for original commit.
> >>>
> >>>if X1.X2.X3, where X = {0,1,....99999}
> >>>Then it can be:
> >>>
> >>>-LIBBPF_VERSION := $(shell \
> >>>-       grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> >>>-       sort -rV | head -n1 | cut -d'_' -f2)
> >>>+_LBPFLIST := $(patsubst %;,%,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
> >>>+           $(shell cat libbpf.map))))
> >>>+_LBPFLIST2 := $(foreach v,$(_LBPFLIST), \
> >>>+               $(subst $() $(),,$(foreach n,$(subst .,$() $(),$(v)), \
> >>>+                       $(shell printf "%05d" $(n)))))
> >>>+_LBPF_VER := $(word $(words $(sort $(_LBPFLIST2))), $(sort $(_LBPFLIST2)))
> >>>+LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
> >>>+        $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPFLIST2))))
> >>>
> >>>It's bigger but avoids invocations of grep/sort/cut/head, only cat/printf
> >>>, thus -V option also.
> >>>
> >>
> >>No way, this is way too ugly (and still unreliable, if we ever have
> >>X.Y.Z.W or something). I'd rather go with my original approach of
> >Yes, forgot to add
> >X1,X2,X3,...XN, where X = {0,1,....99999} and N = const for all versions.
> >But frankly, 1.0.0 looks too far.
>
> It actually works for any numbs of X1.X2...X100
> but not when you have couple kindof:
> X1.X2.X3
> and
> X1.X2.X3.X4
>
> But, no absolutely any problem to extend this solution to handle all cases,
> by just adding leading 0 to every "transformed version", say limit it to 10
> possible 'dots' (%5*10d) and it will work as clocks. Advantage - mostly make
> functions.
>
> Here can be couple more solutions with sed, not sure it can look less maniac.
>
> >
> >>fetching the last version in libbpf.map file. See
> >>https://www.spinics.net/lists/netdev/msg592703.html.
>
> Yes it's nice but, no sort, no X1.X2.X3....XN
>
> Main is to solve it for a long time.

Thinking a bit more about this, I'm even more convinced that we should
just go with my original approach: find last section in libbpf.map and
extract LIBBPF version from that. That will handle whatever crazy
version format we might decide to use (e.g., 1.2.3-experimental).
We'll just need to make sure that latest version is the last in
libbpf.map, which will just happen naturally. So instead of this
Makefile complexity, please can you port back my original approach?
Thanks!

>
> >>
> >>>>
> >>>>>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
> >>>>>
> >>>>>  MAKEFLAGS += --no-print-directory
> >>>>> --
> >>>>> 2.17.1
> >>>>>
> >>>
> >>>--
> >>>Regards,
> >>>Ivan Khoronzhuk
> >
> >--
> >Regards,
> >Ivan Khoronzhuk
>
> --
> Regards,
> Ivan Khoronzhuk
