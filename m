Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76717400C42
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbhIDRY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 13:24:29 -0400
Received: from relay.sw.ru ([185.231.240.75]:40668 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237110AbhIDRY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 13:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=gUqgvy02f4+L2h01QsSAozR5KCMkELC05U5xEFTXuHo=; b=OX9CrPeb4WhBmn5kh
        mmHSI5lvzDx1eJA3simcLU0apsqIltVri7faJXA4Agb8xSAOAf05zd2zWFNvBEK6gxrw0Xh1YFLq4
        zqOcehzKduG13rX1n860gxYhJ12W9JnxXgMo+eftUWoyBF5oQiu17g/zsA9eL9U7IJBoJGFKrxUyo
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mMZNz-000nOH-QK; Sat, 04 Sep 2021 20:23:23 +0300
Subject: Re: WARNING in sk_stream_kill_queues
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsYG3O_irFOZqjq5dJVDwW8pSUR_p6oO4BUaabWcx-hQCQ@mail.gmail.com>
 <c84b07f8-ab0e-9e0c-c5d7-7d44e4d6f3e5@gmail.com>
 <9a35a6f2-9373-6561-341c-8933b537122e@virtuozzo.com>
 <71e8b315-3f3a-85ae-fede-914269a15272@virtuozzo.com>
 <606daddf-6ca5-6789-b571-6178100432be@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <c857c5c7-9d65-dda1-cfba-6f4f66251cd9@virtuozzo.com>
Date:   Sat, 4 Sep 2021 20:23:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <606daddf-6ca5-6789-b571-6178100432be@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/21 8:14 PM, Eric Dumazet wrote:
> 
> 
> On 9/4/21 7:48 AM, Vasily Averin wrote:
> 
>> Eric,
>> this problem is not related to my patches.
>> I've reproduced the problem locally on orignal kernel with original config,
>> then I've applied last version of my patch -- but it did not help, issue was reproduced again,
>> then I've reverted all my patches, see lest below -- and reproduced the problem once again
>>
>> Thank you,
>> 	Vasily Averin
>>
>> b8a0bb68ac30 (HEAD -> net-next-5.15) Revert "ipv6: allocate enough headroom in ip6_finish_output2()"
>> 1bc2de674a1b Revert "ipv6: ip6_finish_output2: set sk into newly allocated nskb"
>> 780e2f7d9b93 Revert "skbuff: introduce skb_expand_head()"
>> 782eaeed9de7 Revert "ipv6: use skb_expand_head in ip6_finish_output2"
>> 639e9842fc1f Revert "ipv6: use skb_expand_head in ip6_xmit"
>> 3b16ee164bcd Revert "ipv4: use skb_expand_head in ip_finish_output2"
>> ab48caf0e632 Revert "vrf: use skb_expand_head in vrf_finish_output"
>> 4da67a72ceef Revert "ax25: use skb_expand_head"
>> 9b113a8a62f0 Revert "bpf: use skb_expand_head in bpf_out_neigh_v4/6"
>> fc4ab503ce8f Revert "vrf: fix NULL dereference in vrf_finish_output()"
>>
> 
> OK, thanks for checking.
> 
> The repro on my host does not trigger the issue, I can not really investigate/bisect.

I"ve recompiled kernel with original config,
It was booted very slowly, ~10 minutes,
then reproducer worked a quite long time,
node was crashed in 3000-4000 seconds uptime.

Thank you,
	Vasily Averin
