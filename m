Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986363966A6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhEaRPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbhEaRNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:13:54 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5094C0431DC;
        Mon, 31 May 2021 08:22:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so1488407pjs.2;
        Mon, 31 May 2021 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/nsoegynA0NxQg1GYgvxu0633H8HmQGqO4a4h40Vrs=;
        b=io7rMBM/BpXIrLooSN5ZmWTDIy8m4xnHFuzzSYxQc5JYEE4I8f0DKG79Vyj9CC74nq
         1CZs6Ie+s3Pr4WVULFjr2S0GHvnAztxCX9TRrurmhhwkHMubsj8ZVpn4foE/3GmSla8Q
         BpAuAYKBm8XJHQ8smIybRfC+TH161xzYLi+mCuTr3FqC9n36T2U/Oq3KrN1pMnsj8MlU
         0XPK0Wn1+mThvjwPlqMg0jDYdpP9Rlo+a0q87UkJTAviFjMkhGsNizQOETq9vRUsuPC2
         9Tp1kJZnEyCtMScONCFbsYO/mARS8AIxYYIK0Tn+DFrsO0XIy5ADyy2Yads+vm3lOl5M
         Av5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/nsoegynA0NxQg1GYgvxu0633H8HmQGqO4a4h40Vrs=;
        b=eimkLXtidNWLlbCThHGk+x2IvJHskH9aOezAe4RfmCDZjwZVOpYvY2jqYPFKGWIcaE
         Gt+hbYGnkWIX+/mpwbeEHUl0y9+369WRt0T1Itts1BfCl3csMAHw/PleYa2q0O7zLS+7
         L0g4TeysxG7ABvjW7m1icVN6pTt8SdurfjPN7bsywLldF6TOjNJ0cXQQ5zybtKgr4X6J
         HJRyd2H70pJAonUrOeUo0rkUC5MTrwEZU26h8wQnugffi/utqAdYTXtM1hd4rgrrQwt6
         nAngI2Hhvl3xYxKDgREHOVAXrUzIRC48K/XovhO50lrQPaRintfeX7D9TQhqgZ0C0cP/
         EXPg==
X-Gm-Message-State: AOAM533Z8uE56eGbxfawU7jYkDGMKFFklkR2YbfRA6BCgTInRXZJeU1C
        q/p2ioBM71t427JR8Fbcmss=
X-Google-Smtp-Source: ABdhPJyNi4I3yqF6G0P2FwAnt5dHjxqfjdJxnyvT4DlnNqIlwQHOyrX2w4rRtSRr4PQKzE3141t0nA==
X-Received: by 2002:a17:902:dac3:b029:105:66fc:8ed7 with SMTP id q3-20020a170902dac3b029010566fc8ed7mr4138063plx.6.1622474526131;
        Mon, 31 May 2021 08:22:06 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id np1sm10880007pjb.13.2021.05.31.08.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:22:05 -0700 (PDT)
Subject: Re: Ethernet padding - ti_cpsw vs DSA tail tag
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ben Hutchings <ben.hutchings@essensium.com>
Cc:     netdev@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-omap@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210531124051.GA15218@cephalopod>
 <20210531142914.bfvcbhglqz55us6s@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cfa6494d-0d7c-a260-6f9f-d7b8d74b287e@gmail.com>
Date:   Mon, 31 May 2021 08:22:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531142914.bfvcbhglqz55us6s@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/2021 7:29 AM, Vladimir Oltean wrote:
> Hi Ben,
> 
> On Mon, May 31, 2021 at 02:40:52PM +0200, Ben Hutchings wrote:
>> I'm working on a system that uses a TI Sitara SoC with one of its
>> Ethernet ports connected to the host port of a Microchip KSZ8795
>> switch.  I'm updating the kernel from 4.14.y to 5.10.y.  Currently I
>> am using the ti_cpsw driver, but it looks like the ti_cpsw_new driver
>> has the same issue.
>>
>> The Microchip switch expects a tail tag on ingress from the host port
>> to control which external port(s) to forward to.  This must appear
>> immediately before the frame checksum.  The DSA core correctly pads
>> outgoing skbs to at least 60 bytes before tag_ksz appends the tag.
>>
>> However, since commit 9421c9015047 ("net: ethernet: ti: cpsw: fix min
>> eth packet size"), the cpsw driver pads outgoing skbs to at least 64
>> bytes.  This means that in smaller packets the tag byte is no longer
>> at the tail.
>>
>> It's not obvious to me where this should be fixed.  Should drivers
>> that pad in ndo_start_xmit be aware of any tail tag that needs to be
>> moved?  Should DSA be aware that a lower driver has a minimum size >
>> 60 bytes?
> 
> These are good questions.
> 
> In principle, DSA needs a hint from the master driver for tail taggers
> to work properly. We should pad to ETH_ZLEN + <the hint value> before
> inserting the tail tag. This is for correctness, to ensure we do not
> operate in marginal conditions which are not guaranteed to work.
> 
> A naive approach would be to take the hint from master->min_mtu.
> However, the first issue that appears is that the dev->min_mtu value is
> not always set quite correctly.
> 
> The MTU in general measures the number of bytes in the L2 payload (i.e.
> not counting the Ethernet + VLAN header, nor FCS). The DSA tag is
> considered to be a part of the L2 payload from the perspective of a
> DSA-unaware master.
> 
> But ether_setup() sets up dev->min_mtu by default to ETH_MIN_MTU (68),
> which cites RFC791. This says:
> 
>     Every internet module must be able to forward a datagram of 68
>     octets without further fragmentation.  This is because an internet
>     header may be up to 60 octets, and the minimum fragment is 8 octets.
> 
> But many drivers simply don't set dev->min_mtu = 0, even if they support
> sending minimum-sized Ethernet frames. Many set dev->min_mtu to ETH_ZLEN,
> proving nothing except the fact that they don't understand that the
> Ethernet header should not be counted by the MTU anyway.
> 
> So to work with these drivers which leave dev->min_mtu = ETH_MIN_MTU, we
> would have to pad the packets in DSA to ETH_ZLEN + ETH_MIN_MTU. This is
> not quite ideal, so even if it would be the correct approach, a large
> amount of drivers would have to be converted to set dev->min_mtu = 0
> before we could consider switching to that and not have too many
> regressions.
> 
> Also, dev->min_mtu does not appear to have a very strict definition
> anywhere other than "Interface Minimum MTU value". My hopes were some
> guarantees along the lines of "if you try to send a packet with a
> smaller L2 payload than dev->mtu, the controller might pad the packet".
> But no luck with that, it seems.
> 
> Going to commit 9421c9015047, it looks like that took a shortcut for
> performance reasons, and omitted to check whether the skb is actually
> VLAN-tagged or not, and if egress untagging was requested or not.
> My understanding is that packets smaller than CPSW_MIN_PACKET_SIZE _can_
> be sent, it's only that the value was chosen (too) conservatively as
> VLAN_ETH_ZLEN. The cpsw driver might be able to check whether the packet
> is a VLAN tagged one by looking at skb->protocol, and choose the pad
> size dynamically. Although I can understand why Grygorii might not want
> to do that.

Agree, that specific commit seems to be possibly by off by 4 in most cases.

> 
> The pitfall is that even if we declare the proper min_mtu value for
> every master driver, it would still not avoid padding in the cpsw case.
> This is because the reason cpsw pads is due to VLAN, but VLAN is not
> part of the L2 payload, so cpsw would still declare dev->min_mtu = 0 in
> spite of needing to pad.
> 
> The only honest solution might be to extend struct net_device and add a
> pad_size value somewhere in there. You might be able to find a hole with
> pahole or something, and it doesn't need to be larger than an u8 (for up
> to 255 bytes of padding). Then cpsw can set master->pad_size, and DSA
> can look at it for tail taggers.

Do we need another way for drivers to be left a chance to be wrong? Even
if we document the semantics of net_device::pad_size correctly this
probably won't cut it.

TBH, I don't fully understand why the network stack has left so much
leeway for Ethernet drivers to do their own padding as opposed to making
sure that non-tagged (VLAN, DSA, whatever) frames are guaranteed to be
at least 60 bytes when they reach ndo_start_xmit() and then just leave
the stacking of devices to add their bytes where they need them, with
the special trailer case that is a tiny bit harder to figure out. Maybe
back in the days most Ethernet NICs would hardware pad and this only
became a concern with newer/cheaper/embedded SoCs NICs that can no
longer hardware pad by default? I can understand the argument about raw
sockets which should permit an application to have full control over the
minimum packet length, but again, in general we have a real link partner
on the other side that is not going to be very tolerant.
-- 
Florian
