Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D394231861A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBKIHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:07:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:42236 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBKIHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 03:07:25 -0500
IronPort-SDR: DjWMi0qGqFslIgOQu9RNNrYRco1DQztYKs773kDXeajkZm0NQthylqaHd/FP2UKCpZbA3UGyBa
 tGHUxyQ2tYXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="169880841"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="169880841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 00:06:42 -0800
IronPort-SDR: H9JnFVZltIDY3Jaoq5DrnRpGycf+hNdoB00afjVpwGCDVADxDVwtggGN+bvcY7RJ/shIzDM19m
 pmRXg5jyQ8wg==
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="397160818"
Received: from akhalikx-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.35.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 00:06:39 -0800
Subject: Re: [PATCH bpf v3] selftests/bpf: convert test_xdp_redirect.sh to
 bash
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        u9012063@gmail.com, Randy Dunlap <rdunlap@infradead.org>
References: <20210209074518.849999-1-bjorn.topel@gmail.com>
 <CAEf4Bza7aJTnquXhJXiQR=rtNGVug-Sc_bsiBm9Op9QUOszkdw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <6fc15e5c-efce-d709-7f54-91ea81f7b9cc@intel.com>
Date:   Thu, 11 Feb 2021 09:06:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza7aJTnquXhJXiQR=rtNGVug-Sc_bsiBm9Op9QUOszkdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-10 21:13, Andrii Nakryiko wrote:
> On Mon, Feb 8, 2021 at 11:45 PM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The test_xdp_redirect.sh script uses a bash feature, '&>'. On systems,
>> e.g. Debian, where '/bin/sh' is dash, this will not work as
>> expected. Use bash in the shebang to get the expected behavior.
>>
>> Further, using 'set -e' means that the error of a command cannot be
>> captured without the command being executed with '&&' or '||'. Let us
>> use '||' to capture the return value of a failed command.
>>
>> v3: Reintroduced /bin/bash, and kept 'set -e'. (Andrii)
>> v2: Kept /bin/sh and removed bashisms. (Randy)
>>
>> Acked-by: William Tu <u9012063@gmail.com>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
> 
> Not exactly what I had in mind (see below), but it's ok like this as well, so:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> Does it have to go through the bpf tree or bpf-next is fine? And what
> about Fixes: tag?
> 
> 
>>   tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
>> index dd80f0c84afb..3f85a82f1c89 100755
>> --- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
>> +++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
>> @@ -1,4 +1,4 @@
>> -#!/bin/sh
>> +#!/bin/bash
>>   # Create 2 namespaces with two veth peers, and
>>   # forward packets in-between using generic XDP
>>   #
>> @@ -43,6 +43,8 @@ cleanup()
>>   test_xdp_redirect()
>>   {
>>          local xdpmode=$1
>> +       local ret1=0
>> +       local ret2=0
>>
>>          setup
>>
>> @@ -57,10 +59,8 @@ test_xdp_redirect()
>>          ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
>>          ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
>>
>> -       ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
>> -       local ret1=$?
>> -       ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
>> -       local ret2=$?
>> +       ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null || ret1=$?
>> +       ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null || ret2=$?
> 
> You didn't like
> 
> if ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null &&
>     ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null; then
>          echo "selftests: test_xdp_redirect $xdpmode [PASS]"
> ...
> 
> ?

Ah, yeah that's better. I'll spin a v4 with this and proper fixes-tag. 
Thanks, Andrii!

Björn
