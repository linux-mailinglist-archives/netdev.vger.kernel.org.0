Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA83A36B78E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhDZRIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:08:14 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F10C061574;
        Mon, 26 Apr 2021 10:07:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h15so4408466wre.11;
        Mon, 26 Apr 2021 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ku3U10kiltn1K2vROLxeP5RSrHLwSeZvLFMasSuc1lk=;
        b=ZHyAKjoi9LR5MwK2uMssgkgFmrmH3nMFKExiV+LUX8BhYDAlH2b99R8j57xguV7lf6
         hZSfSLweJ49CphUO3ORB+hzjMHw9JWnLGH4yFlX0AqE2e2TT3BXpHh8RGOfppCH1guS2
         xWeRDLThkmWe/twGdADksl6CHO1lM8lfnk1NYHONHjhfxqlKpoO8XB76nfrNPENaVzZg
         LovaFlkquaNP0V6/SwDytjiNAIn6i7eQW4UTCv77L8/vcKuYWyxJeeitDQiTuBvE1cUf
         dCfAkGiDSKFNaxhR0r+Ofb8rrpq2iX4lyiU9IwMRChQqaG3E1VQWQj3wEjZB0jKvhL9H
         QjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ku3U10kiltn1K2vROLxeP5RSrHLwSeZvLFMasSuc1lk=;
        b=JfcZd0umJ67DHV0q6+RZ5c5QbdT5cXyi3OKFVIvKQlfS0/Q/gaUvr4YNDn1wTXmVH2
         yXxq5a/9toJxClZDPjCYLj1W+tt1b3Rl3+ADDmqvXMqko+nw+EBV/3KIBAMu3ygYAfKj
         ITSaRwI8w08MahOmoj965A5sKCqIEVdHEwU4C+FUddEo1ukIcr3i1kY87fqBovpseWRC
         8kNrLRm5EX+gVq6/oKbPyYtTzYZ9yNRtFTTkC86HIGMH2gr4NTUN+Xg5UpK1wfJsXl8a
         TewuJpfGMlIWr6vRox9dg6/uBVHbpNqrZn6BUY9Se0UG0IDN9Yjnsp9i1mhWUNxildPw
         G/xw==
X-Gm-Message-State: AOAM5316Iwt/ABlsq/IkO8CDvTpfpAJIbt7TjX8wgWLLhevJL4u1Qmov
        Nid7EeCREfthRekjZYAufoiWD3ZCoic=
X-Google-Smtp-Source: ABdhPJwHiCmX3XwPxI7ffHPG3SsqUex4Mr8aNJFrFWHYSqAXNw0mYdetblS5Un4Ro8dU4xtEFdIimQ==
X-Received: by 2002:adf:e5c1:: with SMTP id a1mr13245096wrn.59.1619456849245;
        Mon, 26 Apr 2021 10:07:29 -0700 (PDT)
Received: from [192.168.1.102] ([37.167.106.225])
        by smtp.gmail.com with ESMTPSA id b12sm724914wmj.1.2021.04.26.10.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 10:07:28 -0700 (PDT)
Subject: Re: Unexpected timestamps in tcpdump with veth + tc qdisc netem delay
To:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <d3a4afd7-a448-4310-930d-063b39bde86e@www.fastmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8e0aa5a6-0457-ccd0-8984-9c9aaeab2228@gmail.com>
Date:   Mon, 26 Apr 2021 19:07:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <d3a4afd7-a448-4310-930d-063b39bde86e@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/21 4:35 PM, Henrique de Moraes Holschuh wrote:
> (please CC me in any replies, thank you!)
> 
> Hello,
> 
> While trying to simulate large delay links using veth and netns, I came across what looks like unexpected / incorrect behavior.
> 
> I have reproduced it in Debian 4.19 and 5.10 kernels, and a quick look at mainline doesn't show any relevant deviation from Debian kernels to mainline in my limited understanding of this area of the kernel.
> 
> I have attached a simple script to reproduce the scenario.  If my explanation below is not clear, please just look at the script to see what it does: it should be trivial to understand.  It needs tcpdump, and CAP_NET_ADMIN (or root, etc).
> 
> Topology
> 
> root netns:
>    veth vec0 (192.168.233.1)   paired to ves0 (192.168.233.2)
>    tc qdisc dev vec0 root netem delay 250ms
> 
> lab500ms netns:
>    veth ves0 (192.168.233.2), paired to vec0 (192.168.233.1)
>    tc qdisc dev ves0 root netem delay 250ms
> 
> So:
> [root netns  -- veth (tc qdisc netem delay 250ms) ] <> [ veth (tc qdisc netem delay 250ms) -- lab500ms netns ]
> 
> Expected RTT from a packet roundtrip (root nets -> lab500ms netns -> root netns) is 500ms.
> 
> 
> The problem:
> 
> [root netns]:  ping 192.168.233.2
> PING 192.168.233.2 (192.168.233.2) 56(84) bytes of data.
> 64 bytes from 192.168.233.2: icmp_seq=1 ttl=64 time=500 ms
> 64 bytes from 192.168.233.2: icmp_seq=2 ttl=64 time=500 ms
> 
> (the RTT reported by ping is 500ms as expected: there is a 250ms transmit delay attached to each member of the veth pair)
> 
> However:
> 
> [root netns]: tcpdump -i vec0 -s0 -n -p net 192.168.233.0/30
> listening on vec0, link-type EN10MB (Ethernet), capture size 262144 bytes
> 17:09:09.740681 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 1, length 64

Here you see the packet _after_ the 250ms delay

> 17:09:09.990891 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 1, length 64
Same here.

I do not see any problem.

> 17:09:10.741903 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 2, length 64
> 17:09:10.992031 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 2, length 64
> 17:09:11.742813 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 3, length 64
> 17:09:11.993009 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 3, length 64
> 
> [lab500ms netns]: ip netns exec lab500ms tcpdump -i ves0 -s0 -n -p net 192.168.233.0/30
> listening on ves0, link-type EN10MB (Ethernet), capture size 262144 bytes
> 17:09:09.740724 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 1, length 64
> 17:09:09.990867 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 1, length 64
> 17:09:10.741942 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 2, length 64
> 17:09:10.992012 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 2, length 64
> 17:09:11.742851 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 3, length 64
> 17:09:11.992985 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 3, length 64
> 
> One can see that the timestamps shown by tcpdump (also reproduced using wireshark) are *not* what one would expect: the 250ms delays are missing in incoming packets (i.e. there's 250ms missing from timestamps in packets "echo reply" in vec0, and "echo request" in ves0).
> 
> The 250ms vec0->ves0 delay AND 250ms ves0 -> vec0 delay *are* there, as shown by "ping", but you'd not know it if you look at the tcpdump.  The timing shown in tcpdump looks more like packet injection time at the first interface, than the time the packet was "seen" at the other end (capture interface).
> 
> Adding more namespaces and VETH pairs + routing "in a row" so that the packet "exits" one veth tunnel and enters another one (after trivial routing) doesn't fix the tcpdump timestamps in the capture at the other end of the veth-veth->routing->veth-veth->routing->... chain.
> 
> It looks like some sort of bug to me, but maybe I am missing something, in which case I would greatly appreciate an explanation of where I went wrong... 
> 

That is only because you expect to see something, but you forgot that tcpdump captures
TX packet _after_ netem.

