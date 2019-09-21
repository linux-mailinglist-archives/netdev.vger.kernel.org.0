Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44D4B9B00
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 02:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfIUAG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 20:06:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:33342 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfIUAG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 20:06:29 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iBSuv-0005FJ-D2; Sat, 21 Sep 2019 02:06:25 +0200
Received: from [178.197.248.15] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iBSuv-000Jrj-3k; Sat, 21 Sep 2019 02:06:25 +0200
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <20190919.132147.31804711876075453.davem@davemloft.net>
 <vbfk1a41fr1.fsf@mellanox.com> <20190920091647.0129e65f@cakuba.netronome.com>
 <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net>
 <20190920155605.7c81c2af@cakuba.netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f1983a74-d144-6d21-9b20-59cea9afc366@iogearbox.net>
Date:   Sat, 21 Sep 2019 02:06:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190920155605.7c81c2af@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25578/Fri Sep 20 10:21:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/19 12:56 AM, Jakub Kicinski wrote:
[...]
>> I thought idea of stuffing things into skb extensions are only justified if
>> it's not enabled by default for everyone. :(
>>
>>     [0] https://lore.kernel.org/netdev/CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com/T/#u
> 
> The skb ext allocation is only done with GOTO_CHAIN, which AFAIK only
> has practical use for offload.  We could perhaps add another static
> branch there or move the OvS static branch out of the OvS module so
> there are no linking issues?
> 
> I personally have little sympathy for this piece of code, it is perhaps
> the purest form of a wobbly narrow-use construct pushed into TC for HW
> offload.
> 
> Any suggestions on the way forward? :(

Presumably there are no clean solutions here, but on the top of my head for
this use case, you'd need to /own/ the underlying datapath anyway, so couldn't
you program the OVS key->recirc_id based on skb->mark (or alternatively via
skb->tc_index) which was previously set by tc ingress?

Thanks,
Daniel
