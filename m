Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2053F38F2
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 08:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhHUGWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 02:22:13 -0400
Received: from relay.sw.ru ([185.231.240.75]:36490 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhHUGWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 02:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=jXG48tWESZb6lwsKKk8bGd3ORv54iPGDzLfPPpbyMwQ=; b=ce5qLSZ39acEgFHia
        sCBTLAUyFg5/haCLEqrBK5wvpip5qttB/4JT94NcAn4OFVJNuoAlOCQfzFzI3m9YdNTamP6Z8t7R6
        XHJjTkb/kQXk3hwY8yd8B2PfEicTf2RmPgRjMym/dRAelr2H1ePuJQBmCxFzgk1JVeslPw9Bp0ups
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mHKNi-008OhM-9T; Sat, 21 Aug 2021 09:21:26 +0300
Subject: Re: [PATCH NET v4 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com>
 <77f3e358-c75e-b0bf-ca87-6f8297f5593c@virtuozzo.com>
 <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
 <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <ff75b068-8165-a45c-0026-8b8f1c745213@virtuozzo.com>
Date:   Sat, 21 Aug 2021 09:21:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/21 1:44 AM, Christoph Paasch wrote:
> (resend without html - thanks gmail web-interface...)
> On Fri, Aug 20, 2021 at 3:41 PM Christoph Paasch
>> AFAICS, this is because pskb_expand_head (called from
>> skb_expand_head) is not adjusting skb->truesize when skb->sk is set
>> (which I guess is the case in this particular scenario). I'm not
>> sure what the proper fix would be though...

Could you please elaborate?
it seems to me skb_realloc_headroom used before my patch called pskb_expand_head() too
and did not adjusted skb->truesize too. Am I missed something perhaps?

The only difference in my patch is that skb_clone can be not called, 
though I do not understand how this can affect skb->truesize.

Thank you,
	Vasily Averin
