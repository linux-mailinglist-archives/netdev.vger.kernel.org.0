Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C315432626
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhJRSQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:16:40 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6822EC06161C;
        Mon, 18 Oct 2021 11:14:29 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id w10-20020a4a274a000000b002b6e972caa1so220049oow.11;
        Mon, 18 Oct 2021 11:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6eZ6X/IT+0Zq6XvgT/8WinYBlxbuMSmvLxrHbIg4LRQ=;
        b=D+BID3BqunKpjisCMzpRwqDpMjDtnRaVskJMBbeHRYbGzxsqWMvQV6SKF7FA24h3MM
         2K1IK/4Y9FSvcV6VFBAuAF7bywcs+0L4U3bL5p6KYB+zmhkxpImGlGu2mvZkALWTCxWE
         iHFg/GvgfTxy5Y8tbSc4hL4M/dxJNAuXorKd8MZ+oi99o1DHdtNeE8iQbGrk/JUJwTD0
         uCThZX/KMH558UH3wkLB0r1eAMgOZ7QysZRYLqmqprqYS62TiPU5bT3vDlqVGHm1ethB
         r/9sY11g975lopRxgj41PilPsZ8pPYcpvowy+r6i/6yFTwR5hNvCmVQnJ+XEfyfOotR0
         eq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6eZ6X/IT+0Zq6XvgT/8WinYBlxbuMSmvLxrHbIg4LRQ=;
        b=6Ag8ZNGfz+lu0s7NhWlZEN1Ei/2IcMaoePzQAMT2QiY6+4f0/vy62dDc8nmUHowuX8
         bQarsm7depRyuO7OZuHSPVsDwxhwyomgi4QAbpwO8UcnyJLqi40Xm1VHfs162KP4RcQv
         zgnTmTNWaeDhac43Q8r3DmPAFpv0cNbuRwHV1Y8OSeBRCHw797vu8fp1ZmyG1gFoYfsR
         vVCo1KKU3AY+q85B45/gTgGfjbkTA7c1aF6Wj6vPA+be06BbuvVb6JXrm6VsYPmCOCiY
         wFuILtge/Pv0KN1ffkMYYZeTlE7vTND3xrFSLxHkXPIFxw0Lo3ksxrcaIYN2+MCoVf7E
         +i2Q==
X-Gm-Message-State: AOAM532f9wx3OydGd+SA81+R+IAbkyCUZ1YLK90EqXca5K4Fd1sX3jhq
        uYEmr35jjAro3xcb9D7/j1EFKaByqac=
X-Google-Smtp-Source: ABdhPJzsp3BB5typbHIfn8n1cIKNaWDPCXn0IWxVlv2uhNK9P9nhqValsRiH+EG8LMSR7ylS59KKvw==
X-Received: by 2002:a4a:dc82:: with SMTP id g2mr1033773oou.97.1634580868224;
        Mon, 18 Oct 2021 11:14:28 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id y123sm3091096oie.0.2021.10.18.11.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:14:27 -0700 (PDT)
Message-ID: <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
Date:   Mon, 18 Oct 2021 12:14:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc> <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
 <20211018143430.GB28644@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211018143430.GB28644@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 8:34 AM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
> 
> Hi David
> 
> TL;DR:
> What is your take on the correct/expected behaviour with vrf+conntrack+nat?
> 
>> Thanks for jumping in, Florian.
> 
> NP.
> 
> Sorry for the wall of text below.
> 
> You can fast-forward to 'Possible solutions' if you want, but they key
> question for me at the moment is the one above.
> 
> I've just submitted a selftest patch to nf.git that adds test
> cases for the problem reported by Eugene + two masquerade/snat test
> cases.
> 
> With net/net-next, first test fails and the other two work, after
> revert its vice versa.
> 
> To get all three working there are a couple of possible solutions to
> this but so far I don't have anything that is void of side effects.
> 
> It assumes revert of the problematic commit, i.e. no nf_reset_ct in
> ingress path from VRF driver.
> 
> First, a summary of VRF+nf+conntrack interaction and where problems are.
> 
> The VRF driver invokes netfilter for output+postrouting hooks,
> with outdev set to the vrf device. Afterwards, ip stack calls those
> hooks again, with outdev set to lower device.
> 
> This is a problem when conntrack is used with IP masquerading.
> With all nf_reset_ct() in vrf driver removed following will happen:
> 
> 1. Conntrack only, no nat, locally generated traffic.
> 
> vrf driver calls output/postrouting hooks.
> output creates new conntrack object and attaches it to skb.
> postrouting confirms entry and places it into state table.
> 
> When hooks are called a second time by IP stack, no new conntrack lookup is
> done because skb already has one attached to it.
> 
> 2. When SNAT is used, this works as well, second iteration doesn't
>    do connection tracking and re-uses nat settings done in iteration 1.
> 
> However there are caveats:
> a) NAT rules that use something like '-o eth0' won't have any effect.
> b) IP address matching in round 2 is 'broken', as the second round deals
> with a rewritten skb (iph saddr already updated).
> 
> This is because when the hooks are invoked a second time, there already
> is a NAT binding attached to the entry. This happens regardless of a
> matching '-o vrfdevice' nat rule or not; when first round did not match
> a nat rule, nat engine attaches a 'nat null binding'.
> 
> 3) When Masquerade is used, things don't work at all.
> 
> This is because of nf_nat_oif_changed() triggering errnously in the nat
> engine.  When masquerade is hit, the output interface index gets stored
> in the conntrack entry.  When the interface index changes, its assumed
> that a routing change took place and the connection has been broken
> (masquerade picks saddr based on the output interface).
> 
> Therefore, NF_DROP gets returned.
> 
> In VRF case, this triggers because we see the skb twice, once with
> ifindex == vrf and once with lower/physdev.
> 
> I suspect that this is what lead eb63ecc1706b3e094d0f57438b6c2067cfc299f2
> (net: vrf: Drop conntrack data after pass through VRF device on Tx),
> this added nf_reset() calls to the tx path.
> 
> This changes things as follows:
> 
> 1. Conntrack only, no nat:
> same as before, expect that the second round does a new conntrack lookup.
> It will find the entry created by first iteration and use that.
> 
> 2. With nat:
> If first round has no matching nat rule, things work:
> Second round will find existing entry and use it.
> NAT rules on second iteration have no effect, just like before.
> 
> If first round had a matching nat rule, then the packet gets rewritten.
> This means that the second round will NOT find an existing entry, and
> conntrack tracks the flow a second time, this time with the post-nat
> source address.
> 
> Because of this, conntrack will also detect a tuple collision when it
> tries to insert the 'new flow incarnation', because the reply direction
> of the 'first round flow' collides with the original direction of the
> second iteration. This forces allocation of a new source port, so source
> port translation is done.
> 
> This in turn breaks in reverse direction, because incoming/reply packet
> only hits the connection tracking engine once, i.e. only the source
> port translation is reversed.
> 
> To fix this, Lahav also added nf_reset_ct() to ingress processing to
> undo the first round nat transformation as well.
> 
> ... and that in turn breaks 'notrack', 'mark' or 'ct zone' assignments
> done based on the incoming/lower device -- the nf_reset_ct zaps those
> settings before round 2 so they have no effect anymore.
> 
> Possible solutions
> ==================
> 
> Taking a few steps back and ignoring 'backwards compat' for now, I think
> that conntrack should process the flow only once.  VRF doesn't transform the
> packets in any way and the only reason for the extra NF_HOOK() calls appear to
> be so that users can match on the incoming/outgoing vrf interface.
> 
> a)
> For locally generated packets, the most simple fix would be to mark
> skb->nfct as 'untracked', and clear it again instead of nf_reset_ct().
> 
> This avoids the need to change anyting on conntrack/nat side.
> The downside is that it becomes impossible to add nat mappings based
> on '-o vrf', because conntrack gets bypassed in round 1.
> 
> For forwarding case (where OUTPUT hooks are not hit and
> ingress path has attached skb->nfct), we would need to find a different
> way to bypass conntrack.  One solution (least-LOC) is to nf_reset() and
> then mark skb as untracked.  IP(6)CB should have FORWARD flag set that
> can be used to detect this condition.
> 
> b)
> make the nf_ct_reset calls in vrf tx path conditional.
> Its possible to detect when a NAT rule was hit via ct->status bits.
> 
> When the NF_HOOK() calls invoked via VRF found a SNAT/MASQ rule,
> don't reset the conntrack entry.
> 
> Downside 1: the second invocation is done with 'incorrect' ip source
> address, OTOH that already happens at this time.
> 
> Downside 2: We need to alter conntrack/nat to avoid the 'oif has
> changed' logic from kicking in.
> 
> I don't see other solutions at the moment.
> 
> For INPUT, users can also match the lower device via inet_sdif()
> (original ifindex stored in IP(6)CB), but we don't have that
> for output, and its not easy to add something because IPCB isn't
> preserved between rounds 1 & 2.
> 

Thanks for the detailed summary and possible solutions.

NAT/MASQ rules with VRF were not really thought about during
development; it was not a use case (or use cases) Cumulus or other NOS
vendors cared about. Community users were popping up fairly early and
patches would get sent, but no real thought about how to handle both
sets of rules - VRF device and port devices.

What about adding an attribute on the VRF device to declare which side
to take -- rules against the port device or rules against the VRF device
and control the nf resets based on it?
