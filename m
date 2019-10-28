Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A9DE7B6F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfJ1Vgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:36:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730454AbfJ1Vgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572298604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Brfy7mrD97bCpvfB3FBCa9L0t2S1CRB6c2tZSeFAi8A=;
        b=VRe/8OtZ+iXGIOgn2fVmg8jWxzuB6N4+wvQ3klO40xsegMCRHB1JCWoxEXjElV5whhVBPc
        PgcfJEvwNVr3MlicmGXc9hajGT2PUAbDuTCqzRxddBOVnYjjbWqh9KfCLzYQtBncZ8bRro
        GcyBqTE42twZs+Ke+qQNr8Mu7xPsu74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-ae2TBSuRM5GBbekG5sh_Wg-1; Mon, 28 Oct 2019 17:36:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C11DF801E5C;
        Mon, 28 Oct 2019 21:36:36 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id BB6515D9C8;
        Mon, 28 Oct 2019 21:36:31 +0000 (UTC)
Date:   Mon, 28 Oct 2019 22:36:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
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
Subject: Re: [PATCH v3 1/9] perf tools: add parse events append error
Message-ID: <20191028213630.GE28772@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com>
 <20191025075820.GE31679@krava>
 <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com>
 <20191028193224.GB28772@krava>
 <CAP-5=fWqzT24JwuYYdH=4auB0EB2P4MMw4bvqGd02fTShXnJfg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAP-5=fWqzT24JwuYYdH=4auB0EB2P4MMw4bvqGd02fTShXnJfg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: ae2TBSuRM5GBbekG5sh_Wg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 02:06:24PM -0700, Ian Rogers wrote:
> On Mon, Oct 28, 2019 at 12:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, Oct 25, 2019 at 08:14:36AM -0700, Ian Rogers wrote:
> > > On Fri, Oct 25, 2019 at 12:58 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> > > > > Parse event error handling may overwrite one error string with an=
other
> > > > > creating memory leaks and masking errors. Introduce a helper rout=
ine
> > > > > that appends error messages and avoids the memory leak.
> > > > >
> > > > > A reproduction of this problem can be seen with:
> > > > >   perf stat -e c/c/
> > > > > After this change this produces:
> > > > > event syntax error: 'c/c/'
> > > > >                        \___ unknown term (previous error: unknown=
 term (previous error: unknown term (previous error: unknown term (previous=
 error: unknown term (previous error: unknown term (previous error: unknown=
 term (previous error: unknown term (previous error: unknown term (previous=
 error: unknown term (previous error: unknown term (previous error: unknown=
 term (previous error: unknown term (previous error: unknown term (previous=
 error: unknown term (previous error: unknown term (previous error: unknown=
 term (previous error: unknown term (previous error: unknown term (previous=
 error: unknown term (previous error: unknown term (previous error: Cannot =
find PMU `c'. Missing kernel support?)(help: valid terms: event,filter_rem,=
filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filt=
er_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,co=
nfig,config1,config2,name,period,percore))(help: valid terms: event,filter_=
rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,=
filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_n=
m,config,config1,config2,name,period,percore))(help: valid terms: event,fil=
ter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,um=
ask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filt=
er_nm,config,config1,config2,name,period,percore))(help: valid terms: event=
,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,in=
v,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,=
filter_nm,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_n=
c,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_st=
ate,filter_nm,config,config1,config2,name,period,percore))(help: valid term=
s: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filt=
er_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filte=
r_state,filter_nm,config,config1,config2,name,period,percore))(help: valid =
terms: event,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,fronten=
d,cmask,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,=
inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_stat=
e,filter_nm,config,config1,config2,name,period,percore))(help: valid terms:=
 event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter=
_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_=
state,filter_nm,config,config1,config2,name,period,percore))(help: valid te=
rms: event,config,config1,config2,name,period,percore))(help: valid terms: =
event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_=
nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_s=
tate,filter_nm,config,config1,config2,name,period,percore))(help: valid ter=
ms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fil=
ter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filt=
er_state,filter_nm,config,config1,config2,name,period,percore))(help: valid=
 terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc=
,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,=
filter_state,filter_nm,config,config1,config2,name,period,percore))(help: v=
alid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter=
_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not=
_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(hel=
p: valid terms: event,config,config1,config2,name,period,percore))(help: va=
lid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_=
loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_=
nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(help=
: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,fil=
ter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_=
not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(=
help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid=
,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,fil=
ter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percor=
e))(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter=
_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op=
,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,pe=
rcore))(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,fi=
lter_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_al=
l_op,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,perio=
d,percore))
> > > >
> > > >
> > > > hum... I'd argue that the previous state was better:
> > > >
> > > > [jolsa@krava perf]$ ./perf stat -e c/c/
> > > > event syntax error: 'c/c/'
> > > >                        \___ unknown term
> > > >
> > > >
> > > > jirka
> > >
> > > I am agnostic. We can either have the previous state or the new state=
,
> > > I'm keen to resolve the memory leak. Another alternative is to warn
> > > that multiple errors have occurred before dropping or printing the
> > > previous error. As the code is shared in memory places the approach
> > > taken here was to try to not conceal anything that could potentially
> > > be useful. Given this, is the preference to keep the status quo
> > > without any warning?
> >
> > if the other alternative is string above, yes.. but perhaps
> > keeping just the first error would be the best way?
> >
> > here it seems to be the:
> >    "Cannot find PMU `c'. Missing kernel support?)(help: valid..."
>=20
> I think this is a reasonable idea. I'd propose doing it as an
> additional patch, the purpose of this patch is to avoid a possible
> memory leak. I can write the patch and base it on this series.
> To resolve the issue, I'd add an extra first error to the struct
> parse_events_error. All callers would need to be responsible for
> cleaning this up when present, which is why I'd rather not make it
> part of this patch.
> Does this sound reasonable?

yep, sounds good

jirka

