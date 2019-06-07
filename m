Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C5A399C7
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfFGXrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:47:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:60550 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfFGXrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 19:47:31 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZOa0-00052O-Vv; Sat, 08 Jun 2019 01:47:29 +0200
Received: from [178.197.248.32] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZOa0-000QI0-QH; Sat, 08 Jun 2019 01:47:28 +0200
Subject: Re: [PATCH v4 bpf-next 0/2] bpf: Add a new API
To:     Roman Gushchin <guro@fb.com>, Hechao Li <hechaol@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>
References: <20190607232550.GA5472@tower.DHCP.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7b7c8e00-a0d5-7d45-017d-a8869cd8025c@iogearbox.net>
Date:   Sat, 8 Jun 2019 01:47:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190607232550.GA5472@tower.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25473/Fri Jun  7 10:00:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2019 01:25 AM, Roman Gushchin wrote:
> On 06/07/2019 06:37 PM, Hechao Li wrote:
>> Getting number of possible CPUs is commonly used for per-CPU BPF maps
>> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
>> helps user with per-CPU related operations and remove duplicate
>> implementations in bpftool and selftests.
>>
>> v4: Fixed error code when reading 0 bytes from possible CPU file
>>
>> Hechao Li (2):
>>   bpf: add a new API libbpf_num_possible_cpus()
>>   bpf: use libbpf_num_possible_cpus in bpftool and selftests
>>
>>  tools/bpf/bpftool/common.c             | 53 +++---------------------
>>  tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
>>  tools/lib/bpf/libbpf.h                 | 16 ++++++++
>>  tools/lib/bpf/libbpf.map               |  1 +
>>  tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
>>  5 files changed, 84 insertions(+), 80 deletions(-)
> 
>> Series applied, thanks!
> 
>> P.s.: Please retain full history (v1->v2->v3->v4) in cover letter next time as
>> that is typical convention and helps readers of git log to follow what has been
>> changed over time.
> 
> 
> Hello!
> 
> I'm getting the following errors on an attempt to build bpf tests.
> Reverting the last patch fixes it.
> 
[...]
> 
> clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/include -idirafter /opt/fb/devtoolset/bin/../lib/clang/4.0.0/include -idirafter /usr/include -Wno-compare-distinct-pointer-types \
> 	 -O2 -target bpf -emit-llvm -c progs/sockmap_parse_prog.c -o - |      \
> llc -march=bpf -mcpu=generic  -filetype=obj -o /data/users/guro/linux/tools/testing/selftests/bpf/sockmap_parse_prog.o
> In file included from progs/sockmap_parse_prog.c:3:
> ./bpf_util.h:9:10: fatal error: 'libbpf.h' file not found
> #include <libbpf.h>
>          ^~~~~~~~~~
> 1 error generated.

True, I've therefore tossed the series from bpf-next. Hechao, please fix and resubmit.
