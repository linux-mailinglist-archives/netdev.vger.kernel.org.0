Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCA2DB3E6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgLOSlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:41:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:52574 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbgLOSlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 13:41:39 -0500
IronPort-SDR: eCf5TbFDh4pOE8ld4EVKW8hfWStMXbniN/noN/Qe8L/ACoxBEChmKicZf8kYDVI0vaMKNeITbn
 71bes5xRqNqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="154739041"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="154739041"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 10:39:52 -0800
IronPort-SDR: WZcHuhWOoUxXCDbN+e8Bj2ffHJhRAf1F6LGhGhN1dUdzaKFB0VpJ41e9Q2eiuyhO7mZoGQIXzi
 pevHk8hEmZOQ==
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="352032975"
Received: from tassilo.jf.intel.com ([10.54.74.11])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 10:39:52 -0800
Date:   Tue, 15 Dec 2020 10:39:51 -0800
From:   Andi Kleen <ak@linux.intel.com>
To:     "Paul A. Clarke" <pc@us.ibm.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
Message-ID: <20201215183951.GB1538637@tassilo.jf.intel.com>
References: <20200507081436.49071-1-irogers@google.com>
 <20200507174835.GB3538@tassilo.jf.intel.com>
 <CAP-5=fUdoGJs+yViq3BOcJa7YyF53AD9RGQm8aRW72nMH0sKDA@mail.gmail.com>
 <20200507214652.GC3538@tassilo.jf.intel.com>
 <CAP-5=fV2eNAt0LLHYXeLMR6GZi_oGZyzz8psErNkbahLQs-VLQ@mail.gmail.com>
 <20201215150812.GA38786@li-24c3614c-2adc-11b2-a85c-85f334518bdb.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215150812.GA38786@li-24c3614c-2adc-11b2-a85c-85f334518bdb.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Or, is the concern more about trying to time-slice the results in a 
> fairly granular way and expecting accurate results then?

Usually the later. It's especially important for divisions. You want
both divisor and dividend to be in the same time slice, otherwise
the result usually doesn't make a lot of sense.

-Andi
