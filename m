Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1911413E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfEERCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:02:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35791 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbfEERCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:02:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id t87so4873392pfa.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6DxJFJU5bqEmTNi14UgfbWjzH1HvNqtEsIeP9lQUKPQ=;
        b=VCXWwU/RrgZV1JBnfWK4pisu7ONZO7Q5j+CP1BydYj94wINKl0ZKMPFQ/gygf1vV6L
         BRH46WVS1D+MbLZAH0BpHudlNAub/+vt47WWr9NKa5Y8ka4VPEbDW+6Qt10t1s+48Uy3
         E0IqvJPCrINJQDvZqcidJ1+Bui/au86CkLGX7goH5cIETKwohJOG63qWgpD1c2lY7SGk
         q5UMsm6dc2kM8cg1u9N8s7Qog1V8EXd5f0GZjWeqAcJ02km6OzP+0L4NR2v0eL7LRERw
         LbEMoW1ToGaL1BtL3fH/VH/u5ELuxN76MbY30n/1YDWihbB2vhckIjpRwLrrXI94HBeC
         azmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DxJFJU5bqEmTNi14UgfbWjzH1HvNqtEsIeP9lQUKPQ=;
        b=VuPu+Wi1txmMKITLHZGvOW8nr9WWUhl+qbxsaeJ9naiX4oYRQXLH9TLCRZo99kVOYe
         6mRgtAE8MeDLUkuPizhz+Jzjv7o1vfuzPLWWeEYFkw1D3LGVMefcLtgL27Z5mHHlcJXc
         N1JB9e9T1rXaW5MDoVegHhICi1sqzpbXDRua4dU9AV583BelqWD8J4DykMQqamjJPgX8
         l6ddU4AtZ0w6JCXz27eORQOYH7p4XgSFvisudxfdQIBaFeoLDIfKK9mRVJrctQruLk1Y
         YCP7zqPxZFLLp4Cqf1ZnfADjlNt2PU5Msf6X3Wuo2PZw/CL+yKvOUlKpiy9JKuA9FRIQ
         UgOQ==
X-Gm-Message-State: APjAAAUbzORq3QdzEWyL3SeOEZRe4fHrQGFni+VmDvEwKqzZ3i2StMTH
        dV9DGWBmw+x7ikBwi3zmCf/H9PTT
X-Google-Smtp-Source: APXvYqwucOu21W7HeC/B5XQUB4mVxPTMlDBzPaRDynppU5XMzvkKfvtx5F2zWU2gzBY17TSaztaB6w==
X-Received: by 2002:a62:4690:: with SMTP id o16mr27093405pfi.166.1557075769452;
        Sun, 05 May 2019 10:02:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id j6sm10430988pfe.107.2019.05.05.10.02.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:02:48 -0700 (PDT)
Subject: Re: [PATCH net-next v3 04/10] net: dsa: Allow drivers to filter
 packets they can decode source port from
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190505101929.17056-1-olteanv@gmail.com>
 <20190505101929.17056-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <0c7debc2-7ba4-3fef-031f-b70a2c3c219f@gmail.com>
Date:   Sun, 5 May 2019 10:02:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505101929.17056-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> Frames get processed by DSA and redirected to switch port net devices
> based on the ETH_P_XDSA multiplexed packet_type handler found by the
> network stack when calling eth_type_trans().
> 
> The running assumption is that once the DSA .rcv function is called, DSA
> is always able to decode the switch tag in order to change the skb->dev
> from its master.
> 
> However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
> user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
> true, since switch tagging piggybacks on the absence of a vlan_filtering
> bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
> rely on switch tagging, but on a different mechanism. So it would make
> sense to at least be able to terminate that.
> 
> Having DSA receive traffic it can't decode would put it in an impossible
> situation: the eth_type_trans() function would invoke the DSA .rcv(),
> which could not change skb->dev, then eth_type_trans() would be invoked
> again, which again would call the DSA .rcv, and the packet would never
> be able to exit the DSA filter and would spiral in a loop until the
> whole system dies.
> 
> This happens because eth_type_trans() doesn't actually look at the skb
> (so as to identify a potential tag) when it deems it as being
> ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
> installed (therefore it's a DSA master) and that there exists a .rcv
> callback (everybody except DSA_TAG_PROTO_NONE has that). This is
> understandable as there are many switch tags out there, and exhaustively
> checking for all of them is far from ideal.
> 
> The solution lies in introducing a filtering function for each tagging
> protocol. In the absence of a filtering function, all traffic is passed
> to the .rcv DSA callback. The tagging protocol should see the filtering
> function as a pre-validation that it can decode the incoming skb. The
> traffic that doesn't match the filter will bypass the DSA .rcv callback
> and be left on the master netdevice, which wasn't previously possible.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> --
just one nit below:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

[snip]

> -	if (unlikely(netdev_uses_dsa(dev)))
> +	if (unlikely(netdev_uses_dsa(dev)) && dsa_can_decode(skb, dev))
>  		return htons(ETH_P_XDSA);

Just in case you need to resubmit, should not the dsa_can_decode() also
be part of the unlikely() statement here?

-- 
Florian
