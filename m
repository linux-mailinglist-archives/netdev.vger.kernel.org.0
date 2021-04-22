Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939AB367BC4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhDVILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:11:11 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:55106 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhDVILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:11:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWNfQIX_1619079031;
Received: from 30.13.165.105(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWNfQIX_1619079031)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Apr 2021 16:10:32 +0800
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1616032552-39866-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <4983305a-3119-bb4b-bb51-520ed5bd28ac@iogearbox.net>
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Message-ID: <745a3bff-6b0e-f707-ffb5-d9f24063b57d@linux.alibaba.com>
Date:   Thu, 22 Apr 2021 16:09:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <4983305a-3119-bb4b-bb51-520ed5bd28ac@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/19 0:23, Daniel Borkmann wrote:
> On 3/18/21 2:55 AM, Jiapeng Chong wrote:
>> Fix the following coccicheck warning:
>>
>> ./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
>> comparing pointer to 0.
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>> ---
>>   tools/testing/selftests/bpf/progs/fentry_test.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c 
>> b/tools/testing/selftests/bpf/progs/fentry_test.c
>> index 5f645fd..d4247d6 100644
>> --- a/tools/testing/selftests/bpf/progs/fentry_test.c
>> +++ b/tools/testing/selftests/bpf/progs/fentry_test.c
>> @@ -64,7 +64,7 @@ struct bpf_fentry_test_t {
>>   SEC("fentry/bpf_fentry_test7")
>>   int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>>   {
>> -    if (arg == 0)
>> +    if (!arg)
>>           test7_result = 1;
>>       return 0;
>>   }
>> @@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>>   SEC("fentry/bpf_fentry_test8")
>>   int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
>>   {
>> -    if (arg->a == 0)
>> +    if (!arg->a)
>>           test8_result = 1;
>>       return 0;
>>   }
>>
> 
> This doesn't apply. Please rebase against bpf-next tree, and also make 
> sure to
> squash any other such patches into a single one.

OK, I'll submit it to the latest branch bpf-next tree later.
