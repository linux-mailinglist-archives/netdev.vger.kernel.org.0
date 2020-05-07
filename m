Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7453B1C8008
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEGCdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727072AbgEGCdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 22:33:12 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1594FC061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 19:33:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so2174964ioh.12
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 19:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FNrrgpXLdDHrj1thWxoSeNd2fD9oKYEd+ucgYMP04/Y=;
        b=tBBfEf8PZmPOqtdlPjQNKfDCZFyH+h04nuYmOixmtTqLQJJaR5oopZgER17zKRsVsj
         NKmidG8aVOEOikMKilqribSFyxkQ22sEoigLiluoMc1qrRRd6LQcL5owRm5NxaK83PGv
         jMQYNUcjmhOqoN3M5Eadan/FjxiMulxeQtdI/oyaIHkbVowb9gm8WGV1Iu6Q7goLFbI2
         cEemYEjXPktlWAC8x5HX2bcDgwDyvLQamhbqPh8KZ3SVnx6bX6Q93o5gILG2fjVLSpsh
         0CRIway791gc4GPOtEYvXAevHY8x/jKUt21nv24qUCB7oa7y87q0fmcRpjG8VLBOmNop
         /l7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FNrrgpXLdDHrj1thWxoSeNd2fD9oKYEd+ucgYMP04/Y=;
        b=tOMSAZp1/VSAN7CTIyTEwu4z6z+r5gXkUkOmUAtCQb1yWvj9Cj1FuCnxLmNnRyB0XE
         6xNIyQCitlku0f5xjOFAlrdyfFuQ9qDWpifksdM4BNoAW6Q+xXMI2wmFRHKZ7ztF8bxK
         MRzoLVF4soecMx9Cq8nN/xYX5ieAP2L22uoXNodHYAJ6WlNdKw6qcpqA/UcsZ1mHOhxo
         A6zECswhEFI4URkNFd44xcWnbO3mukXBt2040TZ6ALlphoeH6I8OUCIbhwwoLCZb4FYk
         11ry1X0FEPyk+DPZ+KHheKXeNIHfCDzO2EZOUeH+nYGKoLgFxznsj32aSN0mvmSNEpon
         b5bA==
X-Gm-Message-State: AGi0PuYvTqxZJOIBCsETuck5wfZTgVyBy0F8S5GjXhKJn2A7uPvJf7tP
        H7hvc5ugrJtCdyUa4F6zHbwwVkAgncE9eKnGpa4l1u72
X-Google-Smtp-Source: APiQypJ0sGPIIUWleDPp1ifoTHv5TF9fOlnyUk8tWISK9IUp5zU1hID9PxPz1cIe6gN1YWLGhYgQ8KbSFXTOSoEnZIs=
X-Received: by 2002:a6b:bc85:: with SMTP id m127mr11321556iof.89.1588818790998;
 Wed, 06 May 2020 19:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200420231427.63894-1-zenczykowski@gmail.com>
 <20200506233259.112545-1-zenczykowski@gmail.com> <20200506165517.140d39ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANP3RGc4aWPM09SoD3gk1R9f1UL4Ef57LHGiTKMBvYBLotwPGQ@mail.gmail.com>
In-Reply-To: <CANP3RGc4aWPM09SoD3gk1R9f1UL4Ef57LHGiTKMBvYBLotwPGQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 6 May 2020 19:32:59 -0700
Message-ID: <CANP3RGduts2FJ2M5MLcf23GaRa=-fwUC7oPf-S4zp39f63jHMg@mail.gmail.com>
Subject: Re: [PATCH v2] net: bpf: permit redirect from L3 to L2 devices at
 near max mtu
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I thought we have established that checking device MTU (m*T*u)
> > at ingress makes a very limited amount of sense, no?
> >
> > Shooting from the hip here, but won't something like:
> >
> >     if (!skb->dev || skb->tc_at_ingress)
> >         return SKB_MAX_ALLOC;
> >     return skb->dev->mtu + skb->dev->hard_header_len;
> >
> > Solve your problem?
>
> I believe that probably does indeed solve the ingress case of tc
> ingress hook on cellular redirecting to wifi.
>
> However, there's 2 possible uplinks - cellular (rawip, L3), and wifi
> (ethernet, L2).
> Thus, there's actually 4 things I'm trying to support:
>
> - ipv6 ingress on cellular uplink (L3/rawip), translate to ipv4,
> forward to wifi/ethernet <- need to add ethernet header
>
> - ipv6 ingress on wifi uplink (L2/ether), translate to ipv4, forward
> to wifi/ethernet <- trivial, no packet size change
>
> - ipv4 egressing through tun (L3), translate to ipv6, forward to
> cellular uplink <- trivial, no packet size change
>
> - ipv4 egressing through tun (L3), translate to ipv6, forward to wifi
> uplink <- need to add ethernet header [*]
>
> I think your approach doesn't solve the reverse path (* up above):
>
> ie. ipv4 packets hitting a tun device (owned by a clat daemon doing
> ipv4<->ipv6 translation in userspace), being stolen by a tc egress
> ebpf hook, mutated to ipv6 by ebpf and bpf_redirect'ed to egress
> through a wifi ipv6-only uplink.
>
> Though arguably in this case I could probably simply increase the tun
> device mtu by another 14, while keeping ipv4 route mtus low...
> (tun mtu already has to be 28 bytes lower then wifi mtu to allow
> replacement of ipv4 with ipv6 header (20 bytes extra), with possibly
> an ipv6 frag header (8 more bytes))
>
> Any further thoughts?

Thinking about this some more, that seems to solve the immediate need
(case 1 above),
and I can work around case 4 with tun mtu bumps.

And maybe the real correct fix would be to simply pass in the desired path mtu
to these 3 functions via 16-bits of the flags argument.
