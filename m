Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726DCE7AE9
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbfJ1VGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:06:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35615 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389756AbfJ1VGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:06:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10so11396183wrb.2
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kmLbG7xlFIRZD/3ijO96lnD7meByS4x923IZvFm+VaA=;
        b=VM9Fmn7ylvsracAY5d67AGb8xMK9Q7dfb07/Z1Dsv5UMk9FTP5XpwxJJqz7VdC9j78
         ldevEHz1yYwS2tNXj7wxKOhczCRP63xrVgyJcrfm5r61pDYme4Nf4Y2erQeiD3On5GnL
         xvN/oqQyMVxjnSpPo5uLMNOgAULI5Y7Gky6AF+eQJh2p7gmiZ6AkccxgFdMbcdV94iZm
         qDKORxrHoaoGFEzLHLJ4WqPDDqs6SEk8vr7v6oEneCPiTENkwmIDb6JaQVzCH6SLFFh0
         tJgXPsA+9D4gaydluWCSXph/1LFhh97v2HOQvZCfYXt2kVenQtfHIKNMnujPm6pP7uu2
         uWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kmLbG7xlFIRZD/3ijO96lnD7meByS4x923IZvFm+VaA=;
        b=WZD3lhhwMBZVocFVgtQZCw1ppQYLK7m71xFbeDLUwX0+fjh9pQu4sORYhkAv/QLQTq
         isOlxNwEBhohsxfGtKWw4IydOIA8wAJucgzZ+vjdW9/9AmNDlRigV8/nuhGB0VdSDTHP
         XYI2l0/rB4snY9TBUUwo68j/VN1ec+uLJwi+o5h9nmbpNHSLPLWcKBgGULvJSpSWsCsX
         Pe5htgzVVRTbOpxbFfFXGeEoGTWpoz3vitLZYa64+Ap/g5TJ6YYP07nAymqpiVlcv/Fc
         HYSEG9fi/tqgQHLnQhLBD7S0Rc6IO6mcDlcSSxiO4mdBcy9KvRgJ3m1Z0Ps024JPpOWc
         gbfQ==
X-Gm-Message-State: APjAAAVO2/sZeM2UGf6FMPAAMPw4+AbjHLQKtfQhmY0M0lrTKJ9k0KWO
        ZfPp3tkPshNj/3PWZPuOdoo1Otdhi1LeQVjLyzhoew==
X-Google-Smtp-Source: APXvYqwASj4zprMprFIDA63PNWyUrrAq3SNIE66VlztI0flnsZYjGBs3OYEuA8ZG2zn/WxQAvn9S5Z16l5g1NPAAeOY=
X-Received: by 2002:a5d:6785:: with SMTP id v5mr12529813wru.174.1572296796532;
 Mon, 28 Oct 2019 14:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com> <20191025075820.GE31679@krava>
 <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com> <20191028193224.GB28772@krava>
In-Reply-To: <20191028193224.GB28772@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 28 Oct 2019 14:06:24 -0700
Message-ID: <CAP-5=fWqzT24JwuYYdH=4auB0EB2P4MMw4bvqGd02fTShXnJfg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] perf tools: add parse events append error
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 12:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Oct 25, 2019 at 08:14:36AM -0700, Ian Rogers wrote:
> > On Fri, Oct 25, 2019 at 12:58 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> > > > Parse event error handling may overwrite one error string with anot=
her
> > > > creating memory leaks and masking errors. Introduce a helper routin=
e
> > > > that appends error messages and avoids the memory leak.
> > > >
> > > > A reproduction of this problem can be seen with:
> > > >   perf stat -e c/c/
> > > > After this change this produces:
> > > > event syntax error: 'c/c/'
> > > >                        \___ unknown term (previous error: unknown t=
erm (previous error: unknown term (previous error: unknown term (previous e=
rror: unknown term (previous error: unknown term (previous error: unknown t=
erm (previous error: unknown term (previous error: unknown term (previous e=
rror: unknown term (previous error: unknown term (previous error: unknown t=
erm (previous error: unknown term (previous error: unknown term (previous e=
rror: unknown term (previous error: unknown term (previous error: unknown t=
erm (previous error: unknown term (previous error: unknown term (previous e=
rror: unknown term (previous error: unknown term (previous error: Cannot fi=
nd PMU `c'. Missing kernel support?)(help: valid terms: event,filter_rem,fi=
lter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter=
_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,conf=
ig,config1,config2,name,period,percore))(help: valid terms: event,filter_re=
m,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,fi=
lter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,=
config,config1,config2,name,period,percore))(help: valid terms: event,filte=
r_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umas=
k,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter=
_nm,config,config1,config2,name,period,percore))(help: valid terms: event,f=
ilter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,=
umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fi=
lter_nm,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,=
inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_stat=
e,filter_nm,config,config1,config2,name,period,percore))(help: valid terms:=
 event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter=
_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_=
state,filter_nm,config,config1,config2,name,period,percore))(help: valid te=
rms: event,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,frontend,=
cmask,config,config1,config2,name,period,percore))(help: valid terms: event=
,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,in=
v,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,=
filter_nm,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_n=
c,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_st=
ate,filter_nm,config,config1,config2,name,period,percore))(help: valid term=
s: event,config,config1,config2,name,period,percore))(help: valid terms: ev=
ent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc=
,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_sta=
te,filter_nm,config,config1,config2,name,period,percore))(help: valid terms=
: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filte=
r_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter=
_state,filter_nm,config,config1,config2,name,period,percore))(help: valid t=
erms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,f=
ilter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fi=
lter_state,filter_nm,config,config1,config2,name,period,percore))(help: val=
id terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_l=
oc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_n=
m,filter_state,filter_nm,config,config1,config2,name,period,percore))(help:=
 valid terms: event,config,config1,config2,name,period,percore))(help: vali=
d terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_lo=
c,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm=
,filter_state,filter_nm,config,config1,config2,name,period,percore))(help: =
valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filte=
r_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_no=
t_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(he=
lp: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,f=
ilter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filte=
r_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore)=
)(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_t=
id,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,f=
ilter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,perc=
ore))(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filt=
er_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_=
op,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,=
percore))
> > >
> > >
> > > hum... I'd argue that the previous state was better:
> > >
> > > [jolsa@krava perf]$ ./perf stat -e c/c/
> > > event syntax error: 'c/c/'
> > >                        \___ unknown term
> > >
> > >
> > > jirka
> >
> > I am agnostic. We can either have the previous state or the new state,
> > I'm keen to resolve the memory leak. Another alternative is to warn
> > that multiple errors have occurred before dropping or printing the
> > previous error. As the code is shared in memory places the approach
> > taken here was to try to not conceal anything that could potentially
> > be useful. Given this, is the preference to keep the status quo
> > without any warning?
>
> if the other alternative is string above, yes.. but perhaps
> keeping just the first error would be the best way?
>
> here it seems to be the:
>    "Cannot find PMU `c'. Missing kernel support?)(help: valid..."

I think this is a reasonable idea. I'd propose doing it as an
additional patch, the purpose of this patch is to avoid a possible
memory leak. I can write the patch and base it on this series.
To resolve the issue, I'd add an extra first error to the struct
parse_events_error. All callers would need to be responsible for
cleaning this up when present, which is why I'd rather not make it
part of this patch.
Does this sound reasonable?

Thanks,
Ian

> jirka
>
