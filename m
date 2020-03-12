Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213CC182CF8
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCLKEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:04:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36058 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgCLKEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584007449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5YZ0uFjoLjHcSjDWFVHYTUoRRtODH2+w0PTu1PtGgGw=;
        b=CVGWaMY36MNFHQwJTf5nL83B4sshtN0SSq7+Si4jbd9Q1WTae9HQgs9Le1If45ABaPIG+G
        c38EdIQHrrowpcSUDFRE+3/CYvmzau4vJEx2YYLyhs0vWK+07TO3Ig5LUq/dhgpkX0xMp6
        5kusW3XP1g2+cej6WEm+XFfTImeAWxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-FAJ065r0Pm67so_kPxsVrw-1; Thu, 12 Mar 2020 06:04:03 -0400
X-MC-Unique: FAJ065r0Pm67so_kPxsVrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25AFE18AB2C2;
        Thu, 12 Mar 2020 10:04:00 +0000 (UTC)
Received: from krava (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E77D60BEC;
        Thu, 12 Mar 2020 10:03:52 +0000 (UTC)
Date:   Thu, 12 Mar 2020 11:03:49 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: add support for lipfm4
Message-ID: <20200312100349.GB254105@krava>
References: <20200310185003.57344-1-irogers@google.com>
 <20200310195915.GA1676879@tassilo.jf.intel.com>
 <CABPqkBRQo=bEOiCFGFjwcM8TZaXMFyaL7o1hcFd6Bc3w+LhJQA@mail.gmail.com>
 <20200311161320.GA254105@krava>
 <CAP-5=fXYMTT7-iiaacO1VF0rRSO6t9W0a5edkiEwdZMYBcrtpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXYMTT7-iiaacO1VF0rRSO6t9W0a5edkiEwdZMYBcrtpQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:32:26PM -0700, Ian Rogers wrote:
> On Wed, Mar 11, 2020 at 9:13 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 02:39:23PM -0700, Stephane Eranian wrote:
> > > On Tue, Mar 10, 2020 at 12:59 PM Andi Kleen <ak@linux.intel.com> wrote:
> > > >
> > > > On Tue, Mar 10, 2020 at 11:50:03AM -0700, Ian Rogers wrote:
> > > > > This patch links perf with the libpfm4 library.
> > > > > This library contains all the hardware event tables for all
> > > > > processors supported by perf_events. This is a helper library
> > > > > that help convert from a symbolic event name to the event
> > > > > encoding required by the underlying kernel interface. This
> > > > > library is open-source and available from: http://perfmon2.sf.net.
> > > >
> > > > For most CPUs the builtin perf JSON event support should make
> > > > this redundant.
> > > >
> > > We decided to post this patch to propose an alternative to the JSON
> > > file approach. It could be an option during the build.
> > > The libpfm4 library has been around for 15 years now. Therefore, it
> > > supports a lot of processors core and uncore and it  is very portable.
> > > The key value add I see is that this is a library that can be, and has
> > > been, used by tool developers directly in their apps. It can
> > > work with more than Linux perf_events interface. It is not tied to the
> > > interface. It has well defined and documented entry points.
> > > We do use libpfm4 extensively at Google in both the perf tool and
> > > applications. The PAPI toolkit also relies on this library.
> > >
> > > I don't see this as competing with the JSON approach. It is just an
> > > option I'd like to offer to users especially those familiar
> > > with it in their apps.
> >
> > I dont mind having it, in fact I found really old email where I'm
> > asking Peter about that ;-) and he wasn't very keen about that:
> >   https://lore.kernel.org/lkml/1312806326.10488.30.camel@twins/
> >
> > not sure what was the actual reason at that time and if anything
> > changed since.. Peter?
> >
> > btw I can't apply even that v2 on latest Arnaldo's branch
> >
> > jirka
> 
> Thanks Jiri,
> 
> the patches were done on tip.git/master, perhaps there is a conflict
> with the Documents Makefile due to adding better man page dates? I'll
> try to repro building on
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/ on the
> perf/core branch unless you  have a different suggestion? I also

yes, it's perf/core

jirka

