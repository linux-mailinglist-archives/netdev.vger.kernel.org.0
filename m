Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE81D5A3D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgEOTmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726188AbgEOTmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:42:01 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AB8C061A0C;
        Fri, 15 May 2020 12:42:01 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f83so3803811qke.13;
        Fri, 15 May 2020 12:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4VLOaxbVjaBb7rcCBZ6LrCtmkCPRdVq27mw9nxBaj4=;
        b=X1D0v8CHkxZGBLI08rsxQ5szdvBF1c7L0WvMpT+c8aV+etCL4JfGVda3XuY4vfqAFb
         tkuob9MO7KJK7tksUHzE8eV6BDbjUxc4GE6s1RmQj5/fD1VVQt0aphJLesWrdegQ9Hqg
         JVdM3aafixEsmfEoo4YzxtcvLwSboqmLEGK2GJBBw6Q9nHUu/MYd2r+6rtdjmhpT0hRg
         hTU8eiQGAv44YITo8dK4F0P8mJBsNFp/c4JOtEXHaN1p0yLJ0zLZsxNiRmUElZIDaoza
         +EL6cPi5ogGF028e9vXfLDAHxK6UwwLXEkzaUJZZILy1WR/ggeJp0peRgxzioGaRCiRh
         0RoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4VLOaxbVjaBb7rcCBZ6LrCtmkCPRdVq27mw9nxBaj4=;
        b=QnVGkQWhmLCEmixhRR7LkUnw2ApIMRPxXXeeLfZzvT/3tebYhZeQdbRJbFCHv3CKwY
         hBhXR+VjAbMMzIH0zqH7+Q9v8JSWlB5UkQsZQ0e8IWmlkn1E4HFPV9fVtwbzGqD4jWW0
         PiVfHgDjSWSP3Wk62pu+BZBP/lYh5VgvoagbhOaTrD9+IzyZhf+VkDjaHrtH+ubNo3jN
         je0P7CBeMarF3EMQ1sRE0FOduOj9y0KQW8A6jReha+UXdyU0HAYdPxaj8tU1zHpI44Sb
         SguZWsu+4PomHkn/NsBUCq5C2d1uEX3cTyqBjeehKnJxjTkN0Hd0HKADvPqUP5yWzBZ1
         bOCg==
X-Gm-Message-State: AOAM531d8AhkoVcZm3EhwE+aZELg5uESKAR0qxvMo3ubVl7AbGpo3pp1
        iwkRQSMTlBPwuwdAx9Qkb7iii3sB87nA2H/LBNY=
X-Google-Smtp-Source: ABdhPJwJfc9T+wPnVFBd8XbU/1XIFlRTqkMR+w2UsuzOY8PX48sfJ/ggkX6FLRlHsveICoRtlmxcj7edKdzXJuGSeu8=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr5166675qka.39.1589571720452;
 Fri, 15 May 2020 12:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-5-irogers@google.com>
In-Reply-To: <20200515165007.217120-5-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:41:49 -0700
Message-ID: <CAEf4BzZn4DTYFipFb60BMMURKjTddi9VR+5WKW7ussQhWp6kXQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] tools lib/api: Copy libbpf hashmap to tools/perf/util
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
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 9:50 AM Ian Rogers <irogers@google.com> wrote:
>
> Allow use of hashmap in perf. Modify perf's check-headers.sh script to
> check that the files are kept in sync, in the same way kernel headers are
> checked. This will warn if they are out of sync at the start of a perf
> build.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Given you want to make sure they stay 1 to 1, would just creating a
symlink work instead of copying the code?

Either way, I think hashmap is stable and not going to change
frequently, so whichever way is fine with me.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/perf/check-headers.sh |   4 +
>  tools/perf/util/Build       |   4 +
>  tools/perf/util/hashmap.c   | 238 ++++++++++++++++++++++++++++++++++++
>  tools/perf/util/hashmap.h   | 177 +++++++++++++++++++++++++++
>  4 files changed, 423 insertions(+)
>  create mode 100644 tools/perf/util/hashmap.c
>  create mode 100644 tools/perf/util/hashmap.h
>

[...]
