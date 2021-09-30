Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558A041D42A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbhI3HMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:12:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:50252 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348676AbhI3HMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:12:07 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVqD0-00028c-N7; Thu, 30 Sep 2021 09:10:22 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVqD0-000V9g-By; Thu, 30 Sep 2021 09:10:22 +0200
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <20210930065238.GA28709@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4646b14-5ee9-e18e-8bb0-5087cd4f6cae@iogearbox.net>
Date:   Thu, 30 Sep 2021 09:10:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210930065238.GA28709@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26307/Wed Sep 29 11:09:54 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 8:52 AM, Lukas Wunner wrote:
> On Thu, Sep 30, 2021 at 08:08:53AM +0200, Daniel Borkmann wrote:
>> Hm, so in the case of SRv6 users were running into a similar issue
>> and commit 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6
>> data plane") [0] added a new hook along with a sysctl which defaults
>> the new hook to off.
>>
>> The rationale for it was given as "the hooks are enabled via
>> nf_hooks_lwtunnel sysctl to make sure existing netfilter rulesets
>>   do not break." [0,1]
>>
>> If the suggestion to flag the skb [2] one way or another from the
>> tc forwarding path (e.g. skb bit or per-cpu marker) is not
>> technically feasible, then why not do a sysctl toggle like in the
>> SRv6 case?
> 
> The skb flag *is* technically feasible.  I amended the patches with
> the flag and was going to post them this week, but Pablo beat me to
> the punch and posted his alternative version, which lacks the flag
> but modularizes netfilter ingress/egress processing instead.
> 
> Honestly I think a hodge-podge of config options and sysctl toggles
> is awful and I would prefer the skb flag you suggested.  I kind of
> like your idea of considering tc and netfilter as layers.
> 
> FWIW the finished patches *with* the flag are on this branch:
> https://github.com/l1k/linux/commits/nft_egress_v5
> 
> Below is the "git range-diff" between Pablo's patches and mine
> (just the hunks which pertain to the skb flag, plus excerpts
> from the commit message).
> 
> Would you find the patch set acceptable with this skb flag?

Yes, that looks good to me, thanks Lukas!
