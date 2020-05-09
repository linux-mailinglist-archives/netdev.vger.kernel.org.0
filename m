Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E391CBBA0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgEIAMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:12:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:58674 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgEIAMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:12:39 -0400
IronPort-SDR: L0wzQSIcx/nEb+cg0h87kx+WcFYi8tv1CSX9TP5/xKXN3D8WmO4WzQ8RQP+1cIzGTEu6y7kqoU
 1uoOlx6TJ2Ew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:12:39 -0700
IronPort-SDR: EsUwmc+TGJxa1Uzunjzr5CH78OgWwX+YLUO62mVT5Ha2qaJaWEUvFeJjWl3RtOtpobAuwv3Mvu
 ypOKMXHLF9dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="408277513"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 17:12:39 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 08629301C4C; Fri,  8 May 2020 17:12:39 -0700 (PDT)
Date:   Fri, 8 May 2020 17:12:38 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH v3 00/14] Share events between metrics
Message-ID: <20200509001238.GD3538@tassilo.jf.intel.com>
References: <20200508053629.210324-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 10:36:15PM -0700, Ian Rogers wrote:
> Metric groups contain metrics. Metrics create groups of events to
> ideally be scheduled together. Often metrics refer to the same events,
> for example, a cache hit and cache miss rate. Using separate event
> groups means these metrics are multiplexed at different times and the
> counts don't sum to 100%. More multiplexing also decreases the
> accuracy of the measurement.
> 
> This change orders metrics from groups or the command line, so that
> the ones with the most events are set up first. Later metrics see if
> groups already provide their events, and reuse them if
> possible. Unnecessary events and groups are eliminated.

Yes some improvements here are great.

> 
> The option --metric-no-group is added so that metrics aren't placed in
> groups. This affects multiplexing and may increase sharing.
> 
> The option --metric-mo-merge is added and with this option the
> existing grouping behavior is preserved.

Could we also make this a per metric option, like

-M foo:nomerge,... 

or somesuch? Okay i suppose this could be a followon.

Ultimatively like you said we probably want to configure
defaults in the event file.

-Andi
