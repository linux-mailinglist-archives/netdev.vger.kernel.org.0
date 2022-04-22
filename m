Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0350B489
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356188AbiDVKDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDVKD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:03:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C8FBAA;
        Fri, 22 Apr 2022 03:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1208B82BB3;
        Fri, 22 Apr 2022 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976B4C385A0;
        Fri, 22 Apr 2022 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621631;
        bh=vmNcIN7ZM6D37SIWNSAEuPLtScbEabkD+cFkumM4MLI=;
        h=From:To:Cc:Subject:Date:From;
        b=RZu1N34z+KyqF0WYYZy3M/wNqFmSLNPiME86NwpBk6utFpbjRNsz1AGAXajFz+rfa
         mlScEVq48P48XxU4RWXBplQxXBiiZFM69I8qKZUlQKmskCAvU6IO2srrVCXnuTHOh5
         f/SupNLDk5qE3PZd2uKZbrbsm4/1F1WXTviEv3E7zFkISzUE0byzSPH7trsX3uOL4W
         n6ln5LQ2BwLqZ2TiYLN+XjeM9wXIv1DVfVHui6KYxIp6jCDZb+ggbDW9WfBjifndT7
         ab+lqV/OZv+51YgUMLRnO00B1R4wOSI4WhCyEDbc7IvNtSrNmMfjO33ZnxlSGnvmcU
         ULqDHQOIyc09Q==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: [PATCH perf/core 0/5] perf tools: Fix prologue generation
Date:   Fri, 22 Apr 2022 12:00:20 +0200
Message-Id: <20220422100025.1469207-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
sending change we discussed some time ago [1] to get rid of
some deprecated functions we use in perf prologue code.

Despite the gloomy discussion I think the final code does
not look that bad ;-)

This patchset removes following libbpf functions from perf:
  bpf_program__set_prep
  bpf_program__nth_fd
  struct bpf_prog_prep_result

Also available in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/depre

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
---
Jiri Olsa (5):
      libbpf: Add bpf_program__set_insns function
      libbpf: Load prog's instructions after prog_prepare_load_fn callback
      perf tools: Move libbpf init in libbpf_init function
      perf tools: Register perfkprobe libbpf section handler
      perf tools: Rework prologue generation code

 tools/lib/bpf/libbpf.c                      |  10 +++++
 tools/lib/bpf/libbpf.h                      |  12 ++++++
 tools/lib/bpf/libbpf.map                    |   3 +-
 tools/perf/include/bpf/bpf.h                |   2 +-
 tools/perf/tests/bpf-script-example.c       |   2 +-
 tools/perf/tests/bpf-script-test-prologue.c |   2 +-
 tools/perf/util/bpf-loader.c                | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 7 files changed, 212 insertions(+), 32 deletions(-)
