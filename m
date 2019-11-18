Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA922FFD8D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 05:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfKREac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 23:30:32 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:41298 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfKREab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 23:30:31 -0500
Received: by mail-pj1-f67.google.com with SMTP id gc1so1096479pjb.8
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 20:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6MG8bpSCu0G8hfgPAwJAnh+Mjlf/APFRCSXVe7Ww7Ms=;
        b=RC+EsnUomeZ5cWAY+HhIagUJ937x2VCRSrQsbGllNjRWIETFI4YV9u5r7kfqkkAByu
         dy7md15gSafZRs2nYmhW308IlcVeF0hgpBc6EAhE0a658xK6e8HoBaCWNo0gU2lpF7tD
         RUZx+AK/d0Gemhp9V3CC+CRmM2pfdRv8fD5qgWLJbrewHhAj/Za56BCB3yHEcY17N0m0
         cncvjhg/p0AvSkt8fa7N4VhC6GQJapmWXDXNf81/KzLhPsAFmE9TQsLIp/k+9VFpMOut
         +1mVKPoe2enUYiLn7Cj04dp768Zi+E7227PyWZUX1i/47VhIF4L405cr5ia9YSu9SLiz
         MDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6MG8bpSCu0G8hfgPAwJAnh+Mjlf/APFRCSXVe7Ww7Ms=;
        b=h2jsrX/ap9O2ldrkzUTg9T8KFjvy7Miy5tXCHIr2FLhSgHZ+gzxH31xGrMn7oC0Ds5
         i/3hPiWB7TYzeTej76bmy0pfO3Ukh+IIipph3gVnAwoM4czAdPmPJbBL0xvqJnaCJ1aR
         6wLx0/xAE7VSXX5qCrc8onrlHrM5UIwuEPrbIosXh5/NrSCCEzD+47HWMKKIHFAt71k4
         r0Hr0Gm+8vSU9ZqHrDDbbt3BxV+eEwtCu0Y/Ox3naKzfpPIK6g7A1btADUKFTX37ILZy
         kQ8/dGo+q8nKG6IQcb3ctsuWEcoZhlLJ0TR+5X4s1CRniarGMTqfnjVFbojhBtsWGHw8
         FqGw==
X-Gm-Message-State: APjAAAU+evwF2DLfMJAAp1FB23WrxfLrMYbL3r0CZ476pTAlL/lVIn0a
        BlEvCk4YZ+AwtttUJFZI4bn3DBNz
X-Google-Smtp-Source: APXvYqy/Bc5+3vmK+YGag/yw8Nevdih5szbtG5pEqZmryV0T6vqCExDsEDsH7DIiWrDmFIEa84z2EA==
X-Received: by 2002:a17:902:102:: with SMTP id 2mr27854010plb.156.1574051430221;
        Sun, 17 Nov 2019 20:30:30 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b17sm19101072pfr.17.2019.11.17.20.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 20:30:29 -0800 (PST)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_8021q: Allow DSA tags and VLAN
 filtering simultaneously
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20191117211407.9473-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
Date:   Sun, 17 Nov 2019 20:30:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191117211407.9473-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2019 1:14 PM, Vladimir Oltean wrote:
> There are very good reasons to want this (see documentation reference to
> br_if.c), and there are also very good reasons for not enabling it by
> default. So a devlink param named best_effort_vlan_filtering, currently
> driver-specific and exported only by sja1105, is used to configure this.
> 
> In practice, this is perhaps the way that most users are going to use
> the switch in. Best-effort untagged traffic can be bridged with any net
> device in the system or terminated locally, and VLAN-tagged streams are
> forwarded autonomously in a time-sensitive manner according to their
> PCP (they need not transit the CPU). For those cases where the CPU needs
> to terminate some VLAN-tagged traffic, using the DSA master is still an
> option.
> 
> A complication while implementing this was the fact that
> __netif_receive_skb_core calls __vlan_hwaccel_clear_tag right before
> passing the skb to the DSA packet_type handler. This means that the
> tagger does not see the VLAN tag in the skb, nor in the skb meta data.
> The patch that starting zeroing the skb VLAN tag is:
> 
>   commit d4b812dea4a236f729526facf97df1a9d18e191c
>   Author: Eric Dumazet <edumazet@google.com>
>   Date:   Thu Jul 18 07:19:26 2013 -0700
> 
>       vlan: mask vlan prio bits
> 
>       In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
>       ("vlan: don't deliver frames for unknown vlans to protocols")
>       Florian made sure we set pkt_type to PACKET_OTHERHOST
>       if the vlan id is set and we could find a vlan device for this
>       particular id.
> 
>       But we also have a problem if prio bits are set.
> 
>       Steinar reported an issue on a router receiving IPv6 frames with a
>       vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
>       because skb->vlan_tci is set.
> 
>       Forwarded frame is completely corrupted : We can see (8100:4000)
>       being inserted in the middle of IPv6 source address :
> 
>       16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
>       9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
>              0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
>              0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
>              0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
>              0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
> 
>       It seems we are not really ready to properly cope with this right now.
> 
>       We can probably do better in future kernels :
>       vlan_get_ingress_priority() should be a netdev property instead of
>       a per vlan_dev one.
> 
>       For stable kernels, lets clear vlan_tci to fix the bugs.
> 
>       Reported-by: Steinar H. Gunderson <sesse@google.com>
>       Signed-off-by: Eric Dumazet <edumazet@google.com>
>       Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> The patch doesn't say why "we are not really ready to properly cope with
> this right now", and hence why the best solution is to remove the VLAN
> tag from skb's that don't have a local VLAN sub-interface interested in
> them. And I have no idea either.
> 
> But the above patch has a loophole: if the VLAN tag is not
> hw-accelerated, it isn't removed from the skb if there is no VLAN
> sub-interface interested in it (our case). So we are hooking into the
> .ndo_fix_features callback of the DSA master and clearing the rxvlan
> offload feature, so the DSA tagger will always see the VLAN as part of
> the skb data. This is symmetrical with the ETH_P_DSA_8021Q case and does
> not need special treatment in the tagger. But perhaps the workaround is
> brittle and might break if not understood well enough.
> 
> The disabling of the rxvlan feature of the DSA master is unconditional.
> The reasoning is that at first sight, no DSA master with regular frame
> parsing abilities could be able to locate the VLAN tag with any of the
> existing taggers anyway, and therefore, adding a property in dsa_switch
> to control the rxvlan feature of the master would seem like useless
> boilerplate.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]

> +best_effort_vlan_filtering
> +			[DEVICE, DRIVER-SPECIFIC]
> +			Allow plain ETH_P_8021Q headers to be used as DSA tags.
> +			Benefits:
> +			- Can terminate untagged traffic over switch net
> +			  devices even when enslaved to a bridge with
> +			  vlan_filtering=1.
> +			- Can do QoS based on VLAN PCP for autonomously
> +			  forwarded frames.
> +			Drawbacks:
> +			- User cannot change pvid via 'bridge' commands. This
> +			  would break source port identification on RX for
> +			  untagged traffic.
> +			- User cannot use VLANs in range 1024-3071. If the
> +			  switch receives frames with such VIDs, it will
> +			  misinterpret them as DSA tags.
> +			- Cannot terminate VLAN-tagged traffic on local device.
> +			  There is no way to deduce the source port from these.
> +			  One could still use the DSA master though.

Could we use QinQ to possibly solve these problems and would that work
for your switch? I do not really mind being restricted to not being able
to change the default_pvid or have a reduced VLAN range, but being able
to test VLAN tags terminated on DSA slave network devices is a valuable
thing to do.
-- 
Florian
