Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC841DFB52
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 00:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgEWWTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 18:19:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728414AbgEWWTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 18:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590272389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+pt5OdV916/YUwvPCITecq1PtzZYEa/3tc5nSV/fP4o=;
        b=asuOPiBWtrFe1AaxYZ8JC1ccH52OH60bwdGkvh7XqzomJLNA5/x3Fd7Tsv9s1OjiKhfKY/
        kSNg26md6c3BLBnYLGq3DsPNYbevnLqdpWPoyhOZHXEeJq5SONIMiJMvdzaSOhwuHzmudk
        QXl6Zup9sykz+J/9ntJX+KV0y7e6IxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-GLPbmnFKM-aKHl18yEjEMg-1; Sat, 23 May 2020 18:19:45 -0400
X-MC-Unique: GLPbmnFKM-aKHl18yEjEMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63A1460;
        Sat, 23 May 2020 22:19:42 +0000 (UTC)
Received: from krava (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4B73C5C1D3;
        Sat, 23 May 2020 22:19:37 +0000 (UTC)
Date:   Sun, 24 May 2020 00:19:36 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
Message-ID: <20200523221936.GA123450@krava>
References: <20200520182011.32236-1-irogers@google.com>
 <20200521114325.GT157452@krava>
 <20200521172235.GD14034@kernel.org>
 <20200522101311.GA404187@krava>
 <20200522144908.GI14034@kernel.org>
 <CAP-5=fUaaNpi3RZd9-Q-uCaudop0tU5NN8HFek5e2XLoBZqt6w@mail.gmail.com>
 <CAP-5=fWZYJ2RXeXGGmFXAW9CNnb2S6cGYKc_M=hUQyCng7KJBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWZYJ2RXeXGGmFXAW9CNnb2S6cGYKc_M=hUQyCng7KJBQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 10:56:59AM -0700, Ian Rogers wrote:

SNIP

> >> >       #11 0x00000000004b6911 in cmd_test (argc=1, argv=0x7fffffffd7f0) at tests/builtin-test.c:772
> >> >       #12 0x00000000004e977b in run_builtin (p=0xa7eee8 <commands+552>, argc=3, argv=0x7fffffffd7f0) at perf.c:312
> >> >       #13 0x00000000004e99e8 in handle_internal_command (argc=3, argv=0x7fffffffd7f0) at perf.c:364
> >> >       #14 0x00000000004e9b2f in run_argv (argcp=0x7fffffffd64c, argv=0x7fffffffd640) at perf.c:408
> >> >       #15 0x00000000004e9efb in main (argc=3, argv=0x7fffffffd7f0) at perf.c:538
> >> >
> >> > attached patch fixes it for me, but I'm not sure this
> >> > should be necessary
> >>
> >> ... applying the patch below makes the segfault go away. Ian, Ack? I can
> >> fold it into the patch introducing the problem.
> >
> >
> > I suspect this patch is a memory leak. The underlying issue is likely the outstanding hashmap_clear fix in libbpf. Let me check.
> >
> > Thanks,
> > Ian
> 
> Tested:
> $ git checkout -b testing acme/tmp.perf/core
> $ make ...
> $ perf test 7
> 7: Simple expression parser                              : FAILED!
> $ git cherry-pick 6bca339175bf
> [acme-perf-expr-testing 4614bd252003] libbpf: Fix memory leak and
> possible double-free in hashmap__c

yep, it fixes the issue for me, but I see that under different commit number:

  229bf8bf4d91 libbpf: Fix memory leak and possible double-free in hashmap__clear

jirka

> lear
> Author: Andrii Nakryiko <andriin@fb.com>
> Date: Tue Apr 28 18:21:04 2020 -0700
> 1 file changed, 7 insertions(+)
> $ make ...
> $ perf test 7
> 7: Simple expression parser                              : Ok
> 
> I'd prefer we took the libbpf fix as initializing over the top of the
> hashmap will leak. This fix is in the tools/perf/util/hashmap.c.
> 
> Thanks,
> Ian
> 
> >> - Arnaldo
> >>
> >> > jirka
> >> >
> >> >
> >> > ---

SNIP

