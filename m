Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308833C6B2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404770AbfFKIyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:54:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:41950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404119AbfFKIyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:54:45 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hacYF-00011F-7y; Tue, 11 Jun 2019 10:54:43 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hacYE-000UlR-WC; Tue, 11 Jun 2019 10:54:43 +0200
Subject: Re: [PATCH v6 bpf-next 0/3] Add a new API libbpf_num_possible_cpus()
To:     Hechao Li <hechaol@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, kernel-team@fb.com
References: <20190611005652.3827331-1-hechaol@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1359a225-7f7b-96e6-25f5-8d6c1da5677b@iogearbox.net>
Date:   Tue, 11 Jun 2019 10:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190611005652.3827331-1-hechaol@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25477/Tue Jun 11 10:08:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11/2019 02:56 AM, Hechao Li wrote:
> Getting number of possible CPUs is commonly used for per-CPU BPF maps
> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
> helps user with per-CPU related operations and remove duplicate
> implementations in bpftool and selftests.
> 
> v2: Save errno before calling pr_warning in case it is changed.
> v3: Make sure libbpf_num_possible_cpus never returns 0 so that user only
>     has to check if ret value < 0.
> v4: Fix error code when reading 0 bytes from possible CPU file.
> v5: Fix selftests compliation issue.
> v6: Split commit to reuse libbpf_num_possible_cpus() into two commits:
>     One commit to remove bpf_util.h from test BPF C programs.
>     One commit to reuse libbpf_num_possible_cpus() in bpftools 
>     and bpf_util.h.
> 
> 
> Hechao Li (3):
>   bpf: add a new API libbpf_num_possible_cpus()
>   selftests/bpf: remove bpf_util.h from BPF C progs
>   bpf: use libbpf_num_possible_cpus internally
> 
>  tools/bpf/bpftool/common.c                    | 53 ++---------------
>  tools/lib/bpf/libbpf.c                        | 57 +++++++++++++++++++
>  tools/lib/bpf/libbpf.h                        | 16 ++++++
>  tools/lib/bpf/libbpf.map                      |  1 +
>  tools/testing/selftests/bpf/bpf_endian.h      |  1 +
>  tools/testing/selftests/bpf/bpf_util.h        | 37 ++----------
>  .../selftests/bpf/progs/sockmap_parse_prog.c  |  1 -
>  .../bpf/progs/sockmap_tcp_msg_prog.c          |  2 +-
>  .../bpf/progs/sockmap_verdict_prog.c          |  1 -
>  .../selftests/bpf/progs/test_sysctl_prog.c    |  5 +-
>  10 files changed, 90 insertions(+), 84 deletions(-)
> 

Applied, thanks!
