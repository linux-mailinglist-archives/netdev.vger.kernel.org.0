Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2AEC66F64
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfGLM74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:59:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:49224 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfGLM74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:59:56 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlv9W-00058W-7D; Fri, 12 Jul 2019 14:59:54 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlv9V-000STs-V7; Fri, 12 Jul 2019 14:59:53 +0200
Subject: Re: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>
Cc:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
 <0143c2e9-ac0d-33de-3019-85016d771c76@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bf74b176-9321-c175-359d-4c5cf58a72b4@iogearbox.net>
Date:   Fri, 12 Jul 2019 14:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <0143c2e9-ac0d-33de-3019-85016d771c76@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 08:03 AM, Yonghong Song wrote:
> On 7/10/19 11:53 PM, Andrii Nakryiko wrote:
>> BTF size resolution logic isn't always resolving type size correctly, leading
>> to erroneous map creation failures due to value size mismatch.
>>
>> This patch set:
>> 1. fixes the issue (patch #1);
>> 2. adds tests for trickier cases (patch #2);
>> 3. and converts few test cases utilizing BTF-defined maps, that previously
>>     couldn't use typedef'ed arrays due to kernel bug (patch #3).
>>
>> Patch #1 can be applied against bpf tree, but selftest ones (#2 and #3) have
>> to go against bpf-next for now.
> 
> Why #2 and #3 have to go to bpf-next? bpf tree also accepts tests, 
> AFAIK. Maybe leave for Daniel and Alexei to decide in this particular case.

Yes, corresponding test cases for fixes are also accepted for bpf tree, thanks.

>> Andrii Nakryiko (3):
>>    bpf: fix BTF verifier size resolution logic
>>    selftests/bpf: add trickier size resolution tests
>>    selftests/bpf: use typedef'ed arrays as map values
> 
> Looks good to me. Except minor comments in patch 1/3, Ack the series.
> Acked-by: Yonghong Song <yhs@fb.com>
> 
>>
>>   kernel/bpf/btf.c                              | 14 ++-
>>   .../bpf/progs/test_get_stack_rawtp.c          |  3 +-
>>   .../bpf/progs/test_stacktrace_build_id.c      |  3 +-
>>   .../selftests/bpf/progs/test_stacktrace_map.c |  2 +-
>>   tools/testing/selftests/bpf/test_btf.c        | 88 +++++++++++++++++++
>>   5 files changed, 102 insertions(+), 8 deletions(-)
>>

