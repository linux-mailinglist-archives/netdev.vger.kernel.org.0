Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4E1851B2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCMWg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:36:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:42768 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCMWg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:36:26 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCsul-0002kq-R8; Fri, 13 Mar 2020 23:36:23 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCsul-000VYB-HZ; Fri, 13 Mar 2020 23:36:23 +0100
Subject: Re: [PATCH bpf-next 0/4] CO-RE candidate matching fix and tracing
 test
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200313172336.1879637-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <412ada94-03ff-4d52-2dbb-32259ca4a653@iogearbox.net>
Date:   Fri, 13 Mar 2020 23:36:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200313172336.1879637-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25750/Fri Mar 13 14:03:09 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/20 6:23 PM, Andrii Nakryiko wrote:
> This patch set fixes bug in CO-RE relocation candidate finding logic, which
> currently allows matching against forward declarations, functions, and other
> named types, even though it makes no sense to even attempt. As part of
> verifying the fix, add test using vmlinux.h with preserve_access_index
> attribute and utilizing struct pt_regs heavily to trace nanosleep syscall
> using 5 different types of tracing BPF programs.
> 
> This test also demonstrated problems using struct pt_regs in syscall
> tracepoints and required a new set of macro, which were added in patch #3 into
> bpf_tracing.h.
> 
> Patch #1 fixes annoying issue with selftest failure messages being out of
> sync.
> 
> v1->v2:
> - drop unused handle__probed() function (Martin).
> 
> Andrii Nakryiko (4):
>    selftests/bpf: ensure consistent test failure output
>    libbpf: ignore incompatible types with matching name during CO-RE
>      relocation
>    libbpf: provide CO-RE variants of PT_REGS macros
>    selftests/bpf: add vmlinux.h selftest exercising tracing of syscalls
> 
>   tools/lib/bpf/bpf_tracing.h                   | 103 ++++++++++++++++++
>   tools/lib/bpf/libbpf.c                        |   4 +
>   tools/testing/selftests/bpf/Makefile          |   7 +-
>   .../selftests/bpf/prog_tests/vmlinux.c        |  43 ++++++++
>   .../selftests/bpf/progs/test_vmlinux.c        |  84 ++++++++++++++
>   tools/testing/selftests/bpf/test_progs.c      |  10 +-
>   tools/testing/selftests/bpf/test_progs.h      |   8 +-
>   7 files changed, 249 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/vmlinux.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_vmlinux.c

Applied, thanks!
