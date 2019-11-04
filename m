Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59871EE9C0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfKDUhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:37:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35051 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKDUhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:37:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id l10so18686752wrb.2
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 12:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GpUcO+HZZVMYH5LohMRACc2HKfc/rPPQs8QWFr3WsFY=;
        b=I0S/Z4qeXLlzlpInn0r6wrn4yYGFnBbAUHJuvtz9P7UnQGXWztk7GfcomiToo+tkQP
         /INoCTtr4Jp+spQGlHTAwVpbQcxFAAl/xqCrNXOfTwxCZkSWSuez5yboYvN8ISr/fbP/
         PMTaqPvZAVF1vbvA0+ScQGTsxFVE7lvW6fxV3OgykduNbr7akvtEzUMjo/Sw6ZDj9lEY
         8boJG6GSfiv2PTHk+4d9iN6WX4uSvKqNMYTT9Gk+8rsWR6rOuZvuYDGiLvOe7NWZmhgb
         QM4OvMCUDClvBAzSbn75f59Vue/piRxqKcClSWNKbESUz1Tn0K/o3N+HsKuxTZknLnXs
         7iXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GpUcO+HZZVMYH5LohMRACc2HKfc/rPPQs8QWFr3WsFY=;
        b=pAkY8qoSqPL886ZpYF0lGTpaDI8qPMZ4L3vPXT5BTNRNY5++zegvSiqj0eIztNKw/0
         oQvFEm4+MzZU+jGF9wyMSASukwWY6cBYpfUbfuKeT5BvxhOu3NWcVPwcTEs5aoC4kw7w
         94An3EwTEar3/mGc8ilwUVOYJVBFY6rXz22j9+pXOQRZ+P7OE10bqTKd5xnHgodLxkHq
         nJWkmEng6rEanOSGGIIkUgD1Qy7D8U3vkLaqat0aYgfqIuCr3HHRd/CihHaqaDxTOQQe
         p5uUASkOePa89v/aKMqSRYS1nB1TUZR1aF+79BachQfGpvRCx/WLmVPT1oHhG7O5le9t
         YNGA==
X-Gm-Message-State: APjAAAWAajx/Tji2C/hImAxBJaDb6qPfhae4B0yKJ5licbCJK3GTMbVK
        OqJLi5gItjM4CG/zqvjXWMnf12jDv8/Lk+KPbVqlCQ==
X-Google-Smtp-Source: APXvYqx4QaDjbk9TE4AXn4sz9diPVtFGTVnImVqyUCHrXqlcLDEk5DVsC8uoUQmrOr6lXPukZxr+bKG1AUi6guLN6+Q=
X-Received: by 2002:adf:fd4b:: with SMTP id h11mr6821093wrs.191.1572899862821;
 Mon, 04 Nov 2019 12:37:42 -0800 (PST)
MIME-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com> <20191025075820.GE31679@krava>
 <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com>
 <20191028193224.GB28772@krava> <CAP-5=fWqzT24JwuYYdH=4auB0EB2P4MMw4bvqGd02fTShXnJfg@mail.gmail.com>
 <20191028213630.GE28772@krava>
In-Reply-To: <20191028213630.GE28772@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 4 Nov 2019 12:37:31 -0800
Message-ID: <CAP-5=fVmw1xT+PuuV+C4Ma_PYPt_jWKB6DyCscd7FWui39L_Rg@mail.gmail.com>
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

Thanks! This is part of the v5 patch set, specifically:
https://lkml.org/lkml/2019/10/30/1001

Let me know if there's anything else blocking this. Thanks,
Ian

On Mon, Oct 28, 2019 at 2:36 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Oct 28, 2019 at 02:06:24PM -0700, Ian Rogers wrote:
> > On Mon, Oct 28, 2019 at 12:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Fri, Oct 25, 2019 at 08:14:36AM -0700, Ian Rogers wrote:
> > > > On Fri, Oct 25, 2019 at 12:58 AM Jiri Olsa <jolsa@redhat.com> wrote=
:
> > > > >
> > > > > On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> > > > > > Parse event error handling may overwrite one error string with =
another
> > > > > > creating memory leaks and masking errors. Introduce a helper ro=
utine
> > > > > > that appends error messages and avoids the memory leak.
> > > > > >
> > > > > > A reproduction of this problem can be seen with:
> > > > > >   perf stat -e c/c/
> > > > > > After this change this produces:
> > > > > > event syntax error: 'c/c/'
> > > > > >                        \___ unknown term (previous error: unkno=
wn term (previous error: unknown term (previous error: unknown term (previo=
us error: unknown term (previous error: unknown term (previous error: unkno=
wn term (previous error: unknown term (previous error: unknown term (previo=
us error: unknown term (previous error: unknown term (previous error: unkno=
wn term (previous error: unknown term (previous error: unknown term (previo=
us error: unknown term (previous error: unknown term (previous error: unkno=
wn term (previous error: unknown term (previous error: unknown term (previo=
us error: unknown term (previous error: unknown term (previous error: Canno=
t find PMU `c'. Missing kernel support?)(help: valid terms: event,filter_re=
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
rms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fi=
lter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fil=
ter_state,filter_nm,config,config1,config2,name,period,percore))(help: vali=
d terms: event,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,front=
end,cmask,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_n=
c,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_st=
ate,filter_nm,config,config1,config2,name,period,percore))(help: valid term=
s: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filt=
er_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filte=
r_state,filter_nm,config,config1,config2,name,period,percore))(help: valid =
terms: event,config,config1,config2,name,period,percore))(help: valid terms=
: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filte=
r_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter=
_state,filter_nm,config,config1,config2,name,period,percore))(help: valid t=
erms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,f=
ilter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fi=
lter_state,filter_nm,config,config1,config2,name,period,percore))(help: val=
id terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_l=
oc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_n=
m,filter_state,filter_nm,config,config1,config2,name,period,percore))(help:=
 valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filt=
er_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_n=
ot_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(h=
elp: valid terms: event,config,config1,config2,name,period,percore))(help: =
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
percore))(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,=
filter_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_=
all_op,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,per=
iod,percore))
> > > > >
> > > > >
> > > > > hum... I'd argue that the previous state was better:
> > > > >
> > > > > [jolsa@krava perf]$ ./perf stat -e c/c/
> > > > > event syntax error: 'c/c/'
> > > > >                        \___ unknown term
> > > > >
> > > > >
> > > > > jirka
> > > >
> > > > I am agnostic. We can either have the previous state or the new sta=
te,
> > > > I'm keen to resolve the memory leak. Another alternative is to warn
> > > > that multiple errors have occurred before dropping or printing the
> > > > previous error. As the code is shared in memory places the approach
> > > > taken here was to try to not conceal anything that could potentiall=
y
> > > > be useful. Given this, is the preference to keep the status quo
> > > > without any warning?
> > >
> > > if the other alternative is string above, yes.. but perhaps
> > > keeping just the first error would be the best way?
> > >
> > > here it seems to be the:
> > >    "Cannot find PMU `c'. Missing kernel support?)(help: valid..."
> >
> > I think this is a reasonable idea. I'd propose doing it as an
> > additional patch, the purpose of this patch is to avoid a possible
> > memory leak. I can write the patch and base it on this series.
> > To resolve the issue, I'd add an extra first error to the struct
> > parse_events_error. All callers would need to be responsible for
> > cleaning this up when present, which is why I'd rather not make it
> > part of this patch.
> > Does this sound reasonable?
>
> yep, sounds good
>
> jirka
>
