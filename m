Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F6DF71C2
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 11:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfKKKWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 05:22:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:58814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKKWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 05:22:01 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU6pS-00069U-UP; Mon, 11 Nov 2019 11:21:51 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU6pS-000BbE-Bq; Mon, 11 Nov 2019 11:21:50 +0100
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
To:     Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Cc:     alexei.starovoitov@gmail.com, ast@kernel.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, Kernel-team@fb.com
References: <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
 <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
 <20191108213624.GM3079@worktop.programming.kicks-ass.net>
 <20191108.133924.1397692397131607421.davem@davemloft.net>
 <20191111081403.GM4131@hirez.programming.kicks-ass.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79170599-e29d-7d65-d7f5-0f22bcd15873@iogearbox.net>
Date:   Mon, 11 Nov 2019 11:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191111081403.GM4131@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25629/Sun Nov 10 11:19:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/19 9:14 AM, Peter Zijlstra wrote:
> On Fri, Nov 08, 2019 at 01:39:24PM -0800, David Miller wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Fri, 8 Nov 2019 22:36:24 +0100
>>
>>> The cover leter is not preserved and should therefore
>>   ...
>>
>> The cover letter is +ALWAYS+ preserved, we put them in the merge
>> commit.
> 
> Good to know; is this a netdev special? I've not seen this before.

I think it might be netdev special, and given developers are often used to
this practice on netdev, we've adopted the same for both bpf trees as well
if the cover letter contains a useful high level summary of the whole set.

We've recently changed our workflow a bit after last maintainers summit and
reuse Thomas' mb2q [0] in our small collection of scripts [1], so aside from
other useful features, for every commit under bpf/bpf-next there is now also
a 'Link:' tag pointing to https://lore.kernel.org/bpf/ archive, thus cover
letter or discussions could alternatively be found this way.

One downside of merge commit as cover letter is that they are usually lost (*)
once commits get cherry-picked into stable trees or other downstream, backport
heavy kernels, so with a 'Link:' tag it's a convenient way to quickly get more
context or discussions for those cases.

> Is there a convenient git command to find the merge commit for a given
> regular commit? Say I've used git-blame to find a troublesome commit,
> then how do I find the merge commit for it?

Once you have the sha, you could for example retrieve the corresponding
merge commit from the upstream tree (as top commit) via:

   $ git log <sha>..master --ancestry-path --merges --reverse

> Also, I still think this does not excuse weak individual Changelogs.

Ideally commit messages should be as self-contained as possible to have all
the necessary context w/o having to look up other resources also given issue
(*) above.

Thanks,
Daniel

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/quilttools.git/
   [1] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/
