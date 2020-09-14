Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7190D269862
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINVx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgINVxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:53:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F65C06178B
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:53:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so1414755wmh.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d6R//vqMN6BffGOrWatWjWsmRIOB1pIO7I9oLqMWNw0=;
        b=SI0yvrVcSl0TT8KkITBTYo9ix5y+//IhJ97vmN+e6qPoyMhGlpE0n6hrqvoq9VB519
         d9S2CbSTBPueFmj6QkI+fGGTgHG6CBejqmKUFK+e0R8w9H6R69Fi9ZuUM1jq7uYKTj7k
         QHWIHdH+fNMVE+p4+fhNqOnJl7dN+sOiZSY0MlR5QYYq6SXX6zexWxkpwj7YXhU7GcwP
         GiBzHsXGtqIq/KE5BsFRYUpu8fem5uOgtdsjge9au4rovoTwTHfmotXRDy+rbrJcssVm
         //LsJ5gC+eW5lenSVwjPEs+DlWq1OIVfEimSstQtMbpv4hRz/ovxOeb9vKGGvdyYTz6J
         XGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d6R//vqMN6BffGOrWatWjWsmRIOB1pIO7I9oLqMWNw0=;
        b=cCG8xTwl9HGwFHV/9cdGqal0qa0KKTXEGxpcDZCNHxLq1iDJjAUI+mpQKza/Xym/lE
         p3GiwHh7SBftznUbmwPk46QQHvzLnWFHdHS98D5KdyGSQKtIMqBSrBLoEQCeHRaWfk/9
         Iwrl/BDuoD5QcMMRQvUgDxhIkfieXr8GTsxZjJD1kDcEXZn5CBCAyicLq+by3OqIZlE9
         FOHOzDWaN4uzn4oMcxR3UwO4YkD2Wgagrl22DyV0EtmDIYG9dLFO9mpudO+IWWonfY29
         3V4ogN/XpP74Rb3f5LWc3/zuFLobglVQwqcTgTY9qekHfivXrBH5JCB8Hd/7K0mtgWsh
         IzCw==
X-Gm-Message-State: AOAM531mcmY1c/f8guA2Dpx6+LRj1mOlvCFX6DTHZx9kpcR1zUYhQ9H3
        /LPBULBg3GqHDbujm8ZxhAopqIF82dxOtoJlEDGy7g==
X-Google-Smtp-Source: ABdhPJwmw2QvynGaxOjZ5iu4c71i7/aOOzaly5AbCXm0aW1KbcG1yQbmPSTCcVsNVTl5BNQc7viCFFZlMJpOCYDbdZU=
X-Received: by 2002:a1c:2cc2:: with SMTP id s185mr1357304wms.77.1600120393828;
 Mon, 14 Sep 2020 14:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200912025655.1337192-1-irogers@google.com> <20200912025655.1337192-4-irogers@google.com>
 <20200914214655.GE166601@kernel.org> <20200914215106.GF166601@kernel.org>
In-Reply-To: <20200914215106.GF166601@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 14 Sep 2020 14:52:57 -0700
Message-ID: <CAP-5=fUO_HFd2-z53u6GdRV=o7HsB4ThzWYJDGQG8OwGDeV+VA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] perf record: Don't clear event's period if set by
 a term
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 2:51 PM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Mon, Sep 14, 2020 at 06:46:55PM -0300, Arnaldo Carvalho de Melo escrev=
eu:
> > Em Fri, Sep 11, 2020 at 07:56:54PM -0700, Ian Rogers escreveu:
> > > If events in a group explicitly set a frequency or period with leader
> > > sampling, don't disable the samples on those events.
> > >
> > > Prior to 5.8:
> > > perf record -e '{cycles/period=3D12345000/,instructions/period=3D6789=
000/}:S'
> > > would clear the attributes then apply the config terms. In commit
> > > 5f34278867b7 leader sampling configuration was moved to after applyin=
g the
> > > config terms, in the example, making the instructions' event have its=
 period
> > > cleared.
> > > This change makes it so that sampling is only disabled if configurati=
on
> > > terms aren't present.
> >
> > Adrian, Jiri, can you please take a look a this and provide Reviewed-by
> > or Acked-by tags?
>
> Without this patch we have:
>
> # perf record -e '{cycles/period=3D1/,instructions/period=3D2/}:S' sleep =
1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.051 MB perf.data (6 samples) ]
> #
> # perf evlist -v
> cycles/period=3D1/: size: 120, { sample_period, sample_freq }: 1, sample_=
type: IP|TID|TIME|READ|ID, read_format: ID|GROUP, disabled: 1, mmap: 1, com=
m: 1, enable_on_exec: 1, task: 1, sample_id_all: 1, exclude_guest: 1, mmap2=
: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
> instructions/period=3D2/: size: 120, config: 0x1, sample_type: IP|TID|TIM=
E|READ|ID, read_format: ID|GROUP, sample_id_all: 1, exclude_guest: 1
> #
>
> So indeed the period=3D2 is being cleared for the second event in that
> group.
>
> - Arnaldo

Thanks Arnaldo and Adrian! Adrian's acked-by is here:
https://lore.kernel.org/lkml/77df85d3-a50c-d6aa-1d60-4fc9ea90dc44@intel.com=
/
Let me know if anything is missing.

Ian
