Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1E6466053
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 10:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356420AbhLBJaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 04:30:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:47796 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356377AbhLBJaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 04:30:06 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1msiML-0003Cu-Rx; Thu, 02 Dec 2021 10:26:33 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1msiML-0007XR-FE; Thu, 02 Dec 2021 10:26:33 +0100
Subject: Re: kernel-selftests: make run_tests -C bpf cost 5 hours
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>, lkp <lkp@intel.com>,
        "Li, Philip" <philip.li@intel.com>,
        johan.almbladh@anyfinetworks.com
References: <PH0PR11MB479271060FA116D87B95E12DC5669@PH0PR11MB4792.namprd11.prod.outlook.com>
 <PH0PR11MB4792C2AC6C5185FBC95B9C21C5689@PH0PR11MB4792.namprd11.prod.outlook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <48bd2b51-485b-6b7a-3374-7239447f1efd@iogearbox.net>
Date:   Thu, 2 Dec 2021 10:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB4792C2AC6C5185FBC95B9C21C5689@PH0PR11MB4792.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26370/Wed Dec  1 10:29:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 7:54 AM, Zhou, Jie2X wrote:
> ping
> 
> ________________________________________
> From: Zhou, Jie2X
> Sent: Monday, November 29, 2021 3:36 PM
> To: ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org; kafai@fb.com; songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com; kpsingh@kernel.org
> Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kernel@vger.kernel.org; Li, ZhijianX; Ma, XinjianX
> Subject: kernel-selftests: make run_tests -C bpf cost 5 hours
> 
> hi,
> 
>     I have tested v5.16-rc1 kernel bpf function by make run_tests -C tools/testing/selftests/bpf.
>     And found it cost above 5 hours.
> 
>     Check dmesg and found that lib/test_bpf.ko cost so much time.
>     In tools/testing/selftests/bpf/test_kmod.sh insmod test_bpf.ko four times.
>     It took 40 seconds for the first three times.
> 
>     When do 4th test among 1009 test cases from #812 ALU64_AND_K to  #936 JMP_JSET_K every test case cost above 1 min.
>     Is it currently to cost so much time?
> 
> kern :info : [ 1127.985791] test_bpf: #811 ALU64_MOV_K: all immediate value magnitudes
> kern :info : [ 1237.158485] test_bpf: #812 ALU64_AND_K: all immediate value magnitudes jited:1 127955 PASS
> kern :info : [ 1341.638557] test_bpf: #813 ALU64_OR_K: all immediate value magnitudes jited:1 155039 PASS
> kern :info : [ 1447.725483] test_bpf: #814 ALU64_XOR_K: all immediate value magnitudes jited:1 129621 PASS
> kern :info : [ 1551.808683] test_bpf: #815 ALU64_ADD_K: all immediate value magnitudes jited:1 120428 PASS
> kern :info : [ 1655.550594] test_bpf: #816 ALU64_SUB_K: all immediate value magnitudes jited:1 175712 PASS
> ......
> kern :info : [16725.824950] test_bpf: #931 JMP32_JLE_X: all register value magnitudes jited:1 216508 PASS
> kern :info : [16911.555675] test_bpf: #932 JMP32_JSGT_X: all register value magnitudes jited:1 178367 PASS
> kern :info : [17101.466163] test_bpf: #933 JMP32_JSGE_X: all register value magnitudes jited:1 191436 PASS
> kern :info : [17288.359154] test_bpf: #934 JMP32_JSLT_X: all register value magnitudes jited:1 165714 PASS
> kern :info : [17480.615048] test_bpf: #935 JMP32_JSLE_X: all register value magnitudes jited:1 172846 PASS
> kern :info : [17667.472140] test_bpf: #936 JMP_JSET_K: imm = 0 -> never taken jited:1 14 PASS
> 
>     test_bpf.ko dmesg output is attached.

On my side, I'm seeing:

# time ./test_kmod.sh
[ JIT enabled:0 hardened:0 ]
[  107.182567] test_bpf: Summary: 1009 PASSED, 0 FAILED, [0/997 JIT'ed]
[  107.200319] test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [0/8 JIT'ed]
[  107.200379] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
[ JIT enabled:1 hardened:0 ]
[  108.130568] test_bpf: Summary: 1009 PASSED, 0 FAILED, [997/997 JIT'ed]
[  108.143447] test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
[  108.143510] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
[ JIT enabled:1 hardened:1 ]
[  109.116727] test_bpf: Summary: 1009 PASSED, 0 FAILED, [997/997 JIT'ed]
[  109.129915] test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
[  109.129979] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
[ JIT enabled:1 hardened:2 ]
[ 6617.952848] test_bpf: Summary: 1009 PASSED, 0 FAILED, [948/997 JIT'ed]
[ 6617.965936] test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
[ 6617.966004] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

real	108m32.833s
user	0m0.031s
sys	108m17.939s

The hardened:2 run takes significantly longer due to excessive patching for the
jit constant blinding code. Maybe the test cases can be reduced for the latter,
otoh, it's good to know that they all pass as well.

Thanks,
Daniel
