Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441F888914
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 09:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfHJHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 03:22:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41474 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfHJHWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 03:22:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so37984pfz.8
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 00:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Kqvj5qJEEnuY9tHLIsHKAJCMxbCgSGhB0GQjUNBVzjU=;
        b=pN/qlGpA8abF6Y2VoHoy92OQQq3CMSqbXoIdJstu1huvjtuHlzemsHlD29Ba4F4utO
         +UeK5KoVrRu0etzH0vcO+0ApJqNcZj9rXGCkyt8spxUyMFRjwPpnBazmuhaFXTLalP6S
         Lp3HrbOgwuVvifao/yYUZzeuG8ssfQguwrqXmPbyF6y2xGEq0hnw//LC8p68WagfSLKH
         rsdDWlhVsgB+I7499JpZZuII9CApUi7KTaRS9kXf7Bz8QZGRH4mKTTx/dZ3qKUZRgIpX
         as4l8zy4iN8rP05Li25xLA1FIzCeDmSr2Tads+zy6ie5E7UV6uHqoqqdm8w9xwu1etk3
         he6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Kqvj5qJEEnuY9tHLIsHKAJCMxbCgSGhB0GQjUNBVzjU=;
        b=g6onOdoS8xUQeD3drnSAFsgjimfNQfchgzMDQUyVCvRdyuJSjzGl7VW9Sozj3EHT4q
         9vQFuxQLgyo9MxGqWGV3v71O7zbfnQ3KmWEz0YIKP8ASYzyH0pz56ameEVnXiKzt+wqC
         JKwGlrvkhI8yvnDGVr5JAe+oqy2/cHVeycDXAKXHYTFD4F+UL+IJGW45xHPsbnejRumg
         uocf2aEdGoc9/d+iHThhYlvO4CvkgzLTcXt6G2GfbKhI6aK6TQabAspHUJqWKlk6bfd7
         kHjiVdEegb39jHgpC18/KiZ8QsT4R4f5IFafz2qoonZ+qRebXjYgP/bIv4ib7nlL8rgB
         6PcQ==
X-Gm-Message-State: APjAAAUrM7mmrLvc7sRUwvVcsDv/AZDfAB89PINtAdagKqiIwJ+4LgoP
        5vcBThONw8Ikt73xeWmsx09fHw==
X-Google-Smtp-Source: APXvYqzWPFRraQJfw6z1Xg9lRpRTmgazGG+rZnbJsTWe4VcHA2vmbrAsasej8XE1f+jTi5V6mYDpug==
X-Received: by 2002:a17:90a:9f0b:: with SMTP id n11mr12981206pjp.98.1565421726801;
        Sat, 10 Aug 2019 00:22:06 -0700 (PDT)
Received: from localhost.localdomain (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id l17sm24872660pgj.44.2019.08.10.00.22.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 00:22:05 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Milian Wolff <milian.wolff@kdab.com>,
        Donald Yandt <donald.yandt@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Wei Li <liwei391@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mark Drayton <mbd@fb.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v4 0/2] perf: arm/arm64: Improve completeness for kernel address space
Date:   Sat, 10 Aug 2019 15:21:33 +0800
Message-Id: <20190810072135.27072-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is to improve completeness for kernel address space for
arm/arm64; it adds architecture specific tweaking for the kernel start
address, thus can include the memory regions which are prior to '_stext'
symbol.  With this change, we can see the eBPF program can be parsed
properly on arm64.

This patch set is a following up version for the old patch "perf cs-etm:
Improve completeness for kernel address space" [1]; the old patch was
only to fix the issue for CoreSight ETM event; but the kernel address space
issue is not only limited to CoreSight event, it should be a common issue
for other events (e.g. PMU events), clock events for profiling eBPF
program.  So this patch set tries to resolve it as a common issue for
arm/arm64 archs.

When implemented related code, I tried to use the API
machine__create_extra_kernel_maps(); but I found the 'perf script' tool
directly calls machine__get_kernel_start() instead of running into
the flow for machine__create_extra_kernel_maps(); this is the reason I
don't use machine__create_extra_kernel_maps() for tweaking kernel start
address and refactor machine__get_kernel_start() alternatively.

If there have better method to resolve this issue, any suggestions and
comments are very welcome!

[1] https://lkml.org/lkml/2019/6/19/1057


Leo Yan (2):
  perf machine: Support arch's specific kernel start address
  perf machine: arm/arm64: Improve completeness for kernel address space

 tools/perf/Makefile.config           | 22 ++++++++++++++++++++++
 tools/perf/arch/arm/util/Build       |  2 ++
 tools/perf/arch/arm/util/machine.c   | 17 +++++++++++++++++
 tools/perf/arch/arm64/util/Build     |  1 +
 tools/perf/arch/arm64/util/machine.c | 17 +++++++++++++++++
 tools/perf/arch/x86/util/machine.c   | 10 ++++++++++
 tools/perf/util/machine.c            | 13 +++++++------
 tools/perf/util/machine.h            |  2 ++
 8 files changed, 78 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/arch/arm/util/machine.c
 create mode 100644 tools/perf/arch/arm64/util/machine.c

-- 
2.17.1

