Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FEE18225A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgCKTcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:32:39 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44317 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731085AbgCKTcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:32:39 -0400
Received: by mail-yw1-f65.google.com with SMTP id t141so3146059ywc.11
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 12:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKraGJ30l6Da9gHXvZPSp4wo2q6s17TXGOTZwSnizRM=;
        b=ZRa0WWvzWQ7vbhoCUSCiE+Xpnyn0r9X4j+VOZY5z0moAgoqNi7XrIrbvdOGZLoPStZ
         t73/+8vK2zz/7Sh+YYuj8fHZZ3FvfEkXr6S9rYt7Ocx5uwZ/jttu0ZmY6lDF4hBC0sXu
         RTFy9i9geyhj4B0j0J1TMco4guXl0g6ScFtbUdddNz65nOwp+Tj4KuGah5rZn7yD5Rip
         nEJhat4np3znLve8DajoGUAaFw8E/zVSfQ8ONil21IEam4PVvzEjr7iYRP+6KxiOUnLs
         Khqge9cA25XyxZdxn421HLHv3XL3BJR/eI7EJ1GdIvQIWL5pL6/nNTdMvucoFOejfkzH
         yvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKraGJ30l6Da9gHXvZPSp4wo2q6s17TXGOTZwSnizRM=;
        b=pIbacyCcky0DZYGGAVv1tA97ufpoqhX+ZXZ/Z8y/gH9j72w0byW8XMxsJxM7MQios7
         RVRjijIaNA2XPlRJ0Oc8U3Tsnf5k5dj2tjMpO9hh1ulJ6ESAv3rHSY3qRNdhfozgqWDo
         0Bx1E/w3edwPyOFy7uuZaiuHaQ4GPSNt2sVJHOu4EMWLVjpnzqyRIgbEE609MA6X2CLD
         I7RlhEmgx7pm2DJn6tf848YtKqjr1cukcKgPZr3JN2DnPWQrJ0l1IeCsYPGe8W/iEdG5
         yDpSwAihfoip/mbQlzZU5pFxmwn+DWfWwpwKxIFXbK6udzAwb3PL+BR5Xj9fYHrE1Aty
         rBaw==
X-Gm-Message-State: ANhLgQ1iEprlMq0i0o/cUn59WXXOhadr0ZSKEZH8w2/KxB0KWZXhRAUV
        ujCf7wlzDFMY7OZ1my1An+pMxvLghpWcvBV+y5+mkg==
X-Google-Smtp-Source: ADFU+vuV0D3QIjqPpw7rA21p5bLAVNUkr3pTXiahSyMXLJ3IuwPm7ousgUlGjlBoJJ8eQPNDhN9e5l4QTnhzSuuZwbw=
X-Received: by 2002:a25:c482:: with SMTP id u124mr4859412ybf.286.1583955157918;
 Wed, 11 Mar 2020 12:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200310185003.57344-1-irogers@google.com> <20200310195915.GA1676879@tassilo.jf.intel.com>
 <CABPqkBRQo=bEOiCFGFjwcM8TZaXMFyaL7o1hcFd6Bc3w+LhJQA@mail.gmail.com> <20200311161320.GA254105@krava>
In-Reply-To: <20200311161320.GA254105@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 11 Mar 2020 12:32:26 -0700
Message-ID: <CAP-5=fXYMTT7-iiaacO1VF0rRSO6t9W0a5edkiEwdZMYBcrtpQ@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add support for lipfm4
To:     Jiri Olsa <jolsa@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 9:13 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 02:39:23PM -0700, Stephane Eranian wrote:
> > On Tue, Mar 10, 2020 at 12:59 PM Andi Kleen <ak@linux.intel.com> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 11:50:03AM -0700, Ian Rogers wrote:
> > > > This patch links perf with the libpfm4 library.
> > > > This library contains all the hardware event tables for all
> > > > processors supported by perf_events. This is a helper library
> > > > that help convert from a symbolic event name to the event
> > > > encoding required by the underlying kernel interface. This
> > > > library is open-source and available from: http://perfmon2.sf.net.
> > >
> > > For most CPUs the builtin perf JSON event support should make
> > > this redundant.
> > >
> > We decided to post this patch to propose an alternative to the JSON
> > file approach. It could be an option during the build.
> > The libpfm4 library has been around for 15 years now. Therefore, it
> > supports a lot of processors core and uncore and it  is very portable.
> > The key value add I see is that this is a library that can be, and has
> > been, used by tool developers directly in their apps. It can
> > work with more than Linux perf_events interface. It is not tied to the
> > interface. It has well defined and documented entry points.
> > We do use libpfm4 extensively at Google in both the perf tool and
> > applications. The PAPI toolkit also relies on this library.
> >
> > I don't see this as competing with the JSON approach. It is just an
> > option I'd like to offer to users especially those familiar
> > with it in their apps.
>
> I dont mind having it, in fact I found really old email where I'm
> asking Peter about that ;-) and he wasn't very keen about that:
>   https://lore.kernel.org/lkml/1312806326.10488.30.camel@twins/
>
> not sure what was the actual reason at that time and if anything
> changed since.. Peter?
>
> btw I can't apply even that v2 on latest Arnaldo's branch
>
> jirka

Thanks Jiri,

the patches were done on tip.git/master, perhaps there is a conflict
with the Documents Makefile due to adding better man page dates? I'll
try to repro building on
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/ on the
perf/core branch unless you  have a different suggestion? I also
noticed a warning crept into the Makefile.config in the v2 patch set
that should be removed.

Ian
