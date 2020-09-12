Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABBB267C50
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgILUtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 16:49:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgILUtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 16:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599943752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4AxzX4krOcHBm8+hBaUbmqWLp68cQ/w1UdDPA60DZiY=;
        b=aSeQRstplr06VOCpELQ7mBI4h8eXy7oRpN9tVqWYl+AzBENxvOpUJtGPn6MopCWM+1iD8i
        Y49M1ZsCA5gnaoSVA2f4KLLjQPUmSmMXuRM90xH8DXkppfgc+AZb7KF2MHBd+1ncvLSVcj
        8XKAZ/KqbujU5ho70aYrS4TCZw7ihwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-BCe_ZU25N7ChGLLBGdRJxA-1; Sat, 12 Sep 2020 16:49:10 -0400
X-MC-Unique: BCe_ZU25N7ChGLLBGdRJxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CF081074657;
        Sat, 12 Sep 2020 20:49:07 +0000 (UTC)
Received: from krava (unknown [10.40.192.28])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0EC7A5D9D2;
        Sat, 12 Sep 2020 20:49:02 +0000 (UTC)
Date:   Sat, 12 Sep 2020 22:49:02 +0200
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
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 0/4] Fixes for setting event freq/periods
Message-ID: <20200912204902.GE1714160@krava>
References: <20200912025655.1337192-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912025655.1337192-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 07:56:51PM -0700, Ian Rogers wrote:
> Some fixes that address issues for regular and pfm4 events with 2
> additional perf_event_attr tests. Various authors, David Sharp isn't
> currently at Google.
> 
> v3. moved a loop into a helper following Adrian Hunter's suggestion. 
> v2. corrects the commit message following Athira Rajeev's suggestion.
> 
> David Sharp (1):
>   perf record: Set PERF_RECORD_PERIOD if attr->freq is set.
> 
> Ian Rogers (2):
>   perf record: Don't clear event's period if set by a term
>   perf test: Leader sampling shouldn't clear sample period
> 
> Stephane Eranian (1):
>   perf record: Prevent override of attr->sample_period for libpfm4
>     events

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> 
>  tools/perf/tests/attr/README             |  1 +
>  tools/perf/tests/attr/test-record-group2 | 29 ++++++++++++++++++++
>  tools/perf/util/evsel.c                  | 10 ++++---
>  tools/perf/util/record.c                 | 34 ++++++++++++++++++------
>  4 files changed, 63 insertions(+), 11 deletions(-)
>  create mode 100644 tools/perf/tests/attr/test-record-group2
> 
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 

