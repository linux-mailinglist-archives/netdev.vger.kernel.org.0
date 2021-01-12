Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D422F346C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404886AbhALPoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:44:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:56640 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404536AbhALPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:44:03 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzLpI-000Dp0-KM; Tue, 12 Jan 2021 16:43:20 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzLpI-000KzU-Bo; Tue, 12 Jan 2021 16:43:20 +0100
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     Gilad Reti <gilad.reti@gmail.com>, KP Singh <kpsingh@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210112091545.10535-1-gilad.reti@gmail.com>
 <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
 <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net>
Date:   Tue, 12 Jan 2021 16:43:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26047/Tue Jan 12 13:33:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 4:35 PM, Gilad Reti wrote:
> On Tue, Jan 12, 2021 at 4:56 PM KP Singh <kpsingh@kernel.org> wrote:
>> On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>>>
>>> Add test to check that the verifier is able to recognize spilling of
>>> PTR_TO_MEM registers.
>>
>> It would be nice to have some explanation of what the test does to
>> recognize the spilling of the PTR_TO_MEM registers in the commit
>> log as well.
>>
>> Would it be possible to augment an existing test_progs
>> program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
>> this functionality?

How would you guarantee that LLVM generates the spill/fill, via inline asm?

> It may be possible, but from what I understood from Daniel's comment here
> 
> https://lore.kernel.org/bpf/17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net/
> 
> the test should be a part of the verifier tests (which is reasonable
> to me since it is
> a verifier bugfix)

Yeah, the test_verifier case as you have is definitely the most straight
forward way to add coverage in this case.
