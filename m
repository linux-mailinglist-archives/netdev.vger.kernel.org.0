Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA703E0A8F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 00:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhHDWuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 18:50:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:46792 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhHDWuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 18:50:54 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mBPia-000Gcu-Dn; Thu, 05 Aug 2021 00:50:32 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mBPia-0004r6-3I; Thu, 05 Aug 2021 00:50:32 +0200
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: Add mprog-disable
 to optstring.
To:     Matt Cover <werekraken@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210731005632.13228-1-matthew.cover@stackpath.com>
 <20210731152523.22syukzew6c7njjh@apollo.localdomain>
 <CAGyo_hp2Uunp0_McN3J8MjSeF593thwiODfUaiE-u_NXArEDPg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4922e491-46c2-fa85-e10c-79b0ffe476c7@iogearbox.net>
Date:   Thu, 5 Aug 2021 00:50:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAGyo_hp2Uunp0_McN3J8MjSeF593thwiODfUaiE-u_NXArEDPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26253/Wed Aug  4 10:20:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 7:57 PM, Matt Cover wrote:
> On Sat, Jul 31, 2021 at 8:25 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>>
>> On Sat, Jul 31, 2021 at 06:26:32AM IST, Matthew Cover wrote:
>>> Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
>>> on cpumap") added the following option, but missed adding it to optstring:
>>> - mprog-disable: disable loading XDP program on cpumap entries
>>>
>>> Add the missing option character.
>>
>> I made some changes in this area in [0], since the support was primarily to do
>> redirection from the cpumap prog, so by default we don't install anything now
>> and only do so if a redirection interface is specified (and use devmap instead).
>> So this option won't be used anyway going forward (since we don't install a
>> dummy XDP_PASS program anymore) if it gets accepted.
>>
>> [0]: https://lore.kernel.org/bpf/20210728165552.435050-1-memxor@gmail.com
>>
>> PS: I can restore it again if this is something really used beyond redirecting
>> to another device (i.e. with custom BPF programs). Any feedback would be helpful.
> 
> Hey Kartikeya. I happened to be looking through this code to get a
> feel for using CPUMAP for custom steering (e.g. RSS on encapsulated
> packets) in XDP and noticed the missing option character. Figured it
> was worth doing a quick patch and test.
> 
> Unfortunately, I'm not able to say much on your changes as I'm still
> getting familiarized with this code. It looks like your submission is
> in need of a rebase; v3 has been marked "Changes Requested" in
> patchwork [0]. As I see things, It'd be good to get this fix in there
> for now, whether or not the code is removed later.

Yeap, given this fix in here is tiny & valid either way, I took it in for now, and
when Kartikeya's rework eventually drops the whole option, so be it. ;)

Applied, thanks!
