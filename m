Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3444862234
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388213AbfGHPXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:23:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:44470 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388200AbfGHPXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:23:30 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVUG-0000Vd-Hk; Mon, 08 Jul 2019 17:23:28 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVUG-000Eus-BH; Mon, 08 Jul 2019 17:23:28 +0200
Subject: Re: [PATCH v7 bpf-next 0/5] libbpf: add perf buffer abstraction and
 API
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        kernel-team@fb.com
References: <20190706180628.3919653-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <db6888a8-fcdd-a73e-4f83-d41c508ca703@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:23:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190706180628.3919653-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 08:06 PM, Andrii Nakryiko wrote:
> This patchset adds a high-level API for setting up and polling perf buffers
> associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
> described in corresponding commit.
> 
> Patch #1 adds a set of APIs to set up and work with perf buffer.
> Patch #2 enhances libbpf to support auto-setting PERF_EVENT_ARRAY map size.
> Patch #3 adds test.
> Patch #4 converts bpftool map event_pipe to new API.
> Patch #5 updates README to mention perf_buffer_ prefix.
> 
> v6->v7:
> - __x64_ syscall prefix (Yonghong);
> v5->v6:
> - fix C99 for loop variable initialization usage (Yonghong);
> v4->v5:
> - initialize perf_buffer_raw_opts in bpftool map event_pipe (Jakub);
> - add perf_buffer_ to README;
> v3->v4:
> - fixed bpftool event_pipe cmd error handling (Jakub);
> v2->v3:
> - added perf_buffer__new_raw for more low-level control;
> - converted bpftool map event_pipe to new API (Daniel);
> - fixed bug with error handling in create_maps (Song);
> v1->v2:
> - add auto-sizing of PERF_EVENT_ARRAY maps;
> 
> Andrii Nakryiko (5):
>   libbpf: add perf buffer API
>   libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
>   selftests/bpf: test perf buffer API
>   tools/bpftool: switch map event_pipe to libbpf's perf_buffer
>   libbpf: add perf_buffer_ prefix to README
> 
>  tools/bpf/bpftool/map_perf_ring.c             | 201 +++------
>  tools/lib/bpf/README.rst                      |   3 +-
>  tools/lib/bpf/libbpf.c                        | 397 +++++++++++++++++-
>  tools/lib/bpf/libbpf.h                        |  49 +++
>  tools/lib/bpf/libbpf.map                      |   4 +
>  .../selftests/bpf/prog_tests/perf_buffer.c    | 100 +++++
>  .../selftests/bpf/progs/test_perf_buffer.c    |  25 ++
>  7 files changed, 634 insertions(+), 145 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c
> 

Applied, thanks!
