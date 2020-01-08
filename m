Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C23134A89
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgAHShy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:37:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:32830 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgAHShy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:37:54 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipGDG-0001FX-7d; Wed, 08 Jan 2020 19:37:50 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipGDF-000UdI-OC; Wed, 08 Jan 2020 19:37:49 +0100
Subject: Re: [PATCH bpf-next v3 0/2] bpftool/libbpf: Add probe for large INSN
 limit
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Peter Wu <peter@lekensteyn.nl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200108162428.25014-1-mrostecki@opensuse.org>
 <01feb8cd-6e24-91d8-4c78-a489c1170965@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fffe7581-c2ef-ced0-7df6-3db895a0e3d2@iogearbox.net>
Date:   Wed, 8 Jan 2020 19:37:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <01feb8cd-6e24-91d8-4c78-a489c1170965@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25688/Wed Jan  8 10:56:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/20 6:48 PM, Quentin Monnet wrote:
> 2020-01-08 17:23 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
>> This series implements a new BPF feature probe which checks for the
>> commit c04c0d2b968a ("bpf: increase complexity limit and maximum program
>> size"), which increases the maximum program size to 1M. It's based on
>> the similar check in Cilium, although Cilium is already aiming to use
>> bpftool checks and eventually drop all its custom checks.
>>
>> Examples of outputs:
>>
>> # bpftool feature probe
>> [...]
>> Scanning miscellaneous eBPF features...
>> Large complexity limit and maximum program size (1M) is available
>>
>> # bpftool feature probe macros
>> [...]
>> /*** eBPF misc features ***/
>> #define HAVE_HAVE_LARGE_INSN_LIMIT
>>
>> # bpftool feature probe -j | jq '.["misc"]'
>> {
>>    "have_large_insn_limit": true
>> }
>>
>> v1 -> v2:
>> - Test for 'BPF_MAXINSNS + 1' number of total insns.
>> - Remove info about current 1M limit from probe's description.
>>
>> v2 -> v3:
>> - Remove the "complexity" word from probe's description.
> 
> Series looks good to me, thanks!
> 
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied, thanks!
