Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AF2473B7A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhLNDYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhLNDYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:24:48 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F97C061748
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:24:48 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g18so16700951pfk.5
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/FP25EAS0jWe9Bmq1xKTTtZhdfUiLLbdKe0jZzbjmTg=;
        b=JjM/bjXFKsWhsVueD0GfNyJfbJKjzqPTfF/ptMJ3m+MFnQ/dlMCZMjSYyiCOXk1TiN
         lyRxMDBc/hbhJAiB46dd/DM51W1AbpXTs4xyIcHCA4EdxN+JXwjqw80o8PMsotzboZ1L
         9K9LuPB+DRXC22uUFXl5LGSuqRW/4vnNBdrxTAKHvsZvU5NZUAHfExbKC8arFiMcnyF9
         8lbssUZJqfACm7bn8Q3t2x1k+a0Cwkrl5LmaMrIpqPO1l6R1lWM9fycG1NoDKOZzST5N
         X6XlFpsGntjn5l9wJxVNLgR2JChtqOgsdDBS+407YEuufF0Ct1eTNNdydjD5EgKwKMS1
         CBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FP25EAS0jWe9Bmq1xKTTtZhdfUiLLbdKe0jZzbjmTg=;
        b=yF06IKNmZKRtr38WqYpsObZzcroKnW9sORB0W+LZUa8ETfwEskozyTL+Pgj/wEOu8B
         uS1uNPX6iR0egnJWi0Tx2QbT4CaWdlGfFv69agOoQuohYfDLdZW3DLSF6+6WZS5Bdrvl
         0T6HvajGjeOUh3W/TCcxoTA1+8F2rBkOnU37WaJWHWvvnV9PhI2BZmADiVy8eHfLWmbS
         9XCwADbCM3ZQcwBAaCmWzFVwXfQ8T4Pp9Ocj+n+OxQAO2gK/QbICSipo18KtZSiGcaZu
         aEvZjfIM1ZayPFZ6FbMjvm3sWZUMiZvzr9tlgFuT7On5Z/1QiyYalRNDmZKZLe9DHCF5
         QkZA==
X-Gm-Message-State: AOAM533H3+CJAyiUDHAWPjA9yVyUEMIvGBoKFYeLXyKBIeIY/qm4jOuz
        eBWtF1xnKSP3liokhVUPhbY8bg==
X-Google-Smtp-Source: ABdhPJzGkMINKutzwLWAkv9ZT/ZuLyFvXUivYQOMJM0rW7WzL+i0zVRuVrlUPS+0PfxiYFMwS/SHVQ==
X-Received: by 2002:a63:db17:: with SMTP id e23mr1940721pgg.420.1639452287590;
        Mon, 13 Dec 2021 19:24:47 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id k15sm12876168pff.215.2021.12.13.19.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 19:24:47 -0800 (PST)
Date:   Tue, 14 Dec 2021 11:24:36 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     James Clark <james.clark@arm.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v1 2/2] perf evlist: Don't run perf in non-root PID
 namespace when launch workload
Message-ID: <20211214032436.GA1884193@leoy-ThinkPad-X240s>
References: <20211212134721.1721245-1-leo.yan@linaro.org>
 <20211212134721.1721245-3-leo.yan@linaro.org>
 <6cad0a2e-c4b8-9788-fa0d-05405453a0dd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cad0a2e-c4b8-9788-fa0d-05405453a0dd@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

On Mon, Dec 13, 2021 at 01:54:33PM +0000, James Clark wrote:
> 
> 
> On 12/12/2021 13:47, Leo Yan wrote:
> > In function evlist__prepare_workload(), after perf forks a child process
> > and launches a workload in the created process, it needs to retrieve
> > process and namespace related info via '/proc/$PID/' node.
> > 
> > The process folders under 'proc' file system use the PID number from the
> > root PID namespace, when perf tool runs in non-root PID namespace and
> > creates new process for profiled program, this leads to the perf tool
> > wrongly gather process info since it uses PID from non-root namespace to
> > access nodes under '/proc'.
> > 
> > Let's see an example:
> > 
> >   unshare --fork --pid perf record -e cs_etm//u -a -- test_program
> > 
> > This command runs perf tool and the profiled program 'test_program' in
> > the non-root PID namespace.  When perf tool launches 'test_program',
> > e.g. the forked PID number is 2, perf tool retrieves process info for
> > 'test_program' from the folder '/proc/2'.  But '/proc/2' is actually for
> > a kernel thread so perf tool wrongly gather info for 'test_program'.
> 
> Hi Leo,
> 
> Which features aren't working exactly when you run in a non root namespace?

When perf tool lanches workload, it needs to synthesize samples for
PERF_RECORD_COMM and PERF_RECORD_NAMESPACES, this can make sure the
thread info has been prepared ahead before we decode hardware trace
data (e.g. using Arm CoreSight, SPE, or Intel PT, etc).

Also please see the comment in perf record tool [1]:

"Some H/W events are generated before COMM event
* which is emitted during exec(), so perf script
* cannot see a correct process name for those events.
* Synthesize COMM event to prevent it."

Unfortunately, when using the command "unshare --fork --pid perf
record -e cs_etm//u --namespaces -a -- test_program", it uses
the PID from non-root namespace to synthesize RECORD_COMM and
RECORD_NAMESPACES events, but the PID number doesn't match with the
process folders under /proc folder (which uses the root namespace's PID
to create file node).  As result, perf tool uses pid 2 (from non-root
namespace to capture a kernel thread info rather than the info for
created workload:

0x1ea90 [0x40]: event: 3
.
. ... raw event: size 64 bytes
.  0000:  03 00 00 00 00 00 40 00 02 00 00 00 02 00 00 00  ......@.........
.  0010:  6b 74 68 72 65 61 64 64 00 00 00 00 00 00 00 00  kthreadd........
.  0020:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.  0030:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

0 0 0x1ea90 [0x40]: PERF_RECORD_COMM: kthreadd:2/2

0x1ead0 [0xa8]: event: 16
.
. ... raw event: size 168 bytes
.  0000:  10 00 00 00 00 00 a8 00 02 00 00 00 02 00 00 00  ......?.........
.  0010:  07 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00  ................
.  0020:  91 00 00 f0 00 00 00 00 04 00 00 00 00 00 00 00  ...?............
.  0030:  fe ff ff ef 00 00 00 00 04 00 00 00 00 00 00 00  ????............
.  0040:  ff ff ff ef 00 00 00 00 04 00 00 00 00 00 00 00  ????............
.  0050:  fc ff ff ef 00 00 00 00 04 00 00 00 00 00 00 00  ????............
.  0060:  fd ff ff ef 00 00 00 00 04 00 00 00 00 00 00 00  ????............
.  0070:  00 00 00 f0 00 00 00 00 04 00 00 00 00 00 00 00  ...?............
.  0080:  fb ff ff ef 00 00 00 00 00 00 00 00 00 00 00 00  ????............
.  0090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.  00a0:  00 00 00 00 00 00 00 00                          ........        

0 0 0x1ead0 [0xa8]: PERF_RECORD_NAMESPACES 2/2 - nr_namespaces: 7
                [0/net: 4/0xf0000091, 1/uts: 4/0xeffffffe, 2/ipc: 4/0xefffffff, 3/pid: 4/0xeffffffc, 
                 4/user: 4/0xeffffffd, 5/mnt: 4/0xf0000000, 6/cgroup: 4/0xeffffffb]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/perf/builtin-record.c#n1823

> I did "perf record -- ls" and it seemed to be working for me. At least kernel
> sampling would be working in a namespace, even if there was something wrong
> with userspace.

The issue is relevant with the hardware trace events.

> I think causing a failure might be too restrictive and would prevent people
> from using perf in a container. Maybe we could show a warning instead, but
> I'm not sure exactly what's not working because I thought perf looked up stuff
> based on the path of the process not the pid.

Good point.  I am also worry that it is arbitrary to prevent perf to be
used in the namespace, so this patch it doesn't forbid all cases for
perf tool.  It only returns failure when perf tool tries to fork a
new program.

When perf tool runs in non-root PID namespace, since it still can access
the process info from root file system's /proc node, this causes mess that
the perf tool gathers process info from the root PID namespace.

One thing I think I should dig deeper: can we dynamically update (or mount)
/proc node when perf tool runs in non-root PID namespace so can ensure
perf tool to only see the process nodes in the same non-root namespace?
This can be a solution to avoid the perf tool gathers mess process info.
If anyone know for this, also welcome suggestion, thanks a lot!

Otherwise if we cannot find method to update '/proc' nodes, I think we
still need this patch to return failure when detects perf running in
non-root PID namespace.

Thanks,
Leo
