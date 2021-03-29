Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3380D34D953
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhC2Uw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:52:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42015 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231158AbhC2UwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:52:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 463D85C00DE;
        Mon, 29 Mar 2021 16:52:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 16:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BXZ5ke
        /0VNYbAih92ufZTePIlDugQM4dNpIXwsRqSDA=; b=TbXOGsRDG+neqGGL1Eq6up
        2aruH5dQeMLvns4naqMrnpadJX2+Y5sBW9Qiv7orKGzZhIo42dOI7koA8e/If+By
        g4gJJPhKrWx07kvcXf5JXkeFCz+KO6BYWbPRIQCMAVqffGJfLHpRC3F2k6t/CFsN
        beoBQAYxsYSo//wzug1aIfCWkP/7rnOc0EYVSRlU3vit2jUlM7NCQUc7PdflMBCt
        BW0lEhamO/zzl8A/jqgRjwSkOzOIHytwnHgKSbXzIvpf1bbQPKwU5yDJm7qCMl9C
        XuRgM7IYP07/Y5Awj0dZoRporHxGesVnxHa9vqO6pgeYruqh1D7jaVCM7naGtkNA
        ==
X-ME-Sender: <xms:-T1iYINIl4Lqmiwr9qHhgeBYeyqf8pKEOyzfYOf_A5x3N8SeftZCdA>
    <xme:-T1iYO-tSUCvQdVkdeylyiTiINvstHW5ulW2ISGQbkT5M8d0WhjqXJn8z8wbm79UO
    pShBtSEX7F7lYk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgudehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-T1iYPQgWCNs_DRmZcZrIcr6eQaxvMnbfV5YYyJx79UGxWRG0pUPbA>
    <xmx:-T1iYAus9Hd7M0sA9VRzwtzPpsrq_tdktrfoi5xgbkOLtsFcg-fd9g>
    <xmx:-T1iYAfnJkZ_kojPx2Qb7Cv9qKd8IWJOEIyLyyzN3q4oWeoWa032KA>
    <xmx:-j1iYKoP1hBnDrPk1nORpjzZ4McmDuGyWe_SbTQ830PcH2hj6o1Bsw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 451A5240057;
        Mon, 29 Mar 2021 16:52:09 -0400 (EDT)
Date:   Mon, 29 Mar 2021 23:52:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Soltys <msoltyspl@yandex.pl>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [BUG / question] in routing rules, some options (e.g. ipproto,
 sport) cause rules to be ignored in presence of packet marks
Message-ID: <YGI99fyA6MYKixuB@shredder.lan>
References: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 04:05:29PM +0200, Michal Soltys wrote:
> Hi,
> 
> I'm not sure how it behaved in earlier kernels (can check later), but it is
> / looks bugged in at least recent 5.x+ ones (tests were done with 5.11.8 and
> 5.10.25).
> 
> Consider following setup:
> 
> # ip -o ad sh
> 1: lo    inet 127.0.0.1/8 scope host lo
> 2: right1    inet 10.0.10.2/24 scope global
> 3: right2    inet 10.0.20.2/24 scope global
> 
> # ip ro sh tab main
> default via 10.0.10.1 dev right1
> 10.0.10.0/24 dev right1 proto kernel scope link src 10.0.10.2
> 10.0.20.0/24 dev right2 proto kernel scope link src 10.0.20.2
> 
> # ip ro sh tab 123
> default via 10.0.20.1 dev right2 src 10.0.20.2
> 
> And routing rules:
> 
> 0:      from all lookup local
> 9:      from all fwmark 0x1 ipproto udp sport 1194 lookup 123
> 10:     from all ipproto udp sport 1194 lookup 123
> 32766:  from all lookup main
> 32767:  from all lookup default
> 
> This - without any mangling via ipt/nft or by other means - works correctly,
> for example:
> 
> nc -u -p 1194 1.2.3.4 12345
> 
> will be routed out correctly via 'right2' using 10.0.20.2
> 
> But if we add mark to locally outgoing packets:
> 
> iptables -t mangle -A OUTPUT -j MARK --set-mark 1
> 
> Then *both* rule 9 and rule 10 will be ignored during reroute check. tcpdump
> on interface 'right1' will show:
> 
> # tcpdump -nvi right1 udp
> tcpdump: listening on right1, link-type EN10MB (Ethernet), snapshot length
> 262144 bytes
> 13:21:59.684928 IP (tos 0x0, ttl 64, id 8801, offset 0, flags [DF], proto
> UDP (17), length 33)
>     10.0.20.2.1194 > 1.2.3.4.12345: UDP, length 5
> 
> Initial routing decision in rule 10 will set the address correctly, but the
> packet goes out via interface right1, ignoring both 9 and 10.
> 
> If I add another routing roule:
> 
> 8:      from all fwmark 0x1 lookup 123
> 
> Then the packects will flow correctly - but I *cannot* use (from the ones I
> tested): sport, dport, ipproto, uidrange - as they will cause the rule to be
> ignored. For example, this setup of routing rules will fail, if there is any
> mark set on a packet (nc had uid 1120):
> 
> # ip ru sh
> 0:      from all lookup local
> 10:     from all ipproto udp lookup 123
> 10:     from all sport 1194 lookup 123
> 10:     from all dport 12345 lookup 123
> 10:     from all uidrange 1120-1120 lookup 123
> 32766:  from all lookup main
> 32767:  from all lookup default
> 
> Adding correct fwmark to the above rules will have *no* effect either. Only
> fwmark *alone* will work (or in combination with: iif, from, to - from the
> ones I tested).
> 
> I peeked at fib_rule_match() in net/core/fib_rules.c - but it doesn't look
> like there is anything wrong there. I initially suspected lack of
> 'rule->mark &&' in mark related line - but considering that rules such as
> 'from all fwmark 1 sport 1194 lookup main' also fail, it doesn't look like
> it's the culprit (and mark_mask covers that test either way).
> 
> OTOH, perhaps nf_ip_reroute() / ip_route_me_harder() are somehow the culprit
> here - but I haven't analyzed them yet. Perhaps it's just an issue of
> changing output interface incorrectly after ip_route_me_harder() ?

ip_route_me_harder() does not set source / destination port in the
flow key, so it explains why fib rules that use them are not hit after
mangling the packet. These keys were added in 4.17, but I
don't think this use case every worked. You have a different experience?

> 
> Is this a bug ? Or am I misinterpreting how 'reroute check' works after
> initial routing decision ? One would expect routing rules during post-mangle
> check to not be ignored out of the blue, only because packet mark changed on
> the packet. Not mentioning both marks and routing rules can be used for
> separate purposes (e.g. marks for shaping).
> 
