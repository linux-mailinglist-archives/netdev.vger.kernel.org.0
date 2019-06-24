Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8583050C5A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfFXNuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:50:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50329 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfFXNuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:50:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id c66so12902456wmf.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 06:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D4DjKhaJXWAcFaHULT8Zn9bt97FGVDTogkGCO3mVhww=;
        b=L3+4oA+lklMFId3a+K4s1lbQz8lfC1jKbU/8fqFCiBIs/PIwKb+e9ikmlolc9VPVIa
         FE59+E+se4ULjwA7pZMEWJRcWW266Y9/THR37nNy3C8Z9ShArChMLN6FJtGfUjXZYJUY
         cMOlzCLXEgA1QFRo9w+NvQS71+dn71fjAhvY6AkD+lFwy43PchpCfNocxDGInrBpS12y
         exPpeucAKilYlsBFaDjsQBBsCwJ6k8xHnh8J5Plp2LhASJ2K1AtKfuNZnutf9B+F4yof
         FR/Uc97Ph0wxyM6imYUSD28AnrDt58buFZpT3RuZIutFUN70+y73l5U9ZHpfrVB/Y9Pe
         8XFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D4DjKhaJXWAcFaHULT8Zn9bt97FGVDTogkGCO3mVhww=;
        b=jhX7KNis7RIkpbQv+3b6IGlC7XRUIj98ZKq46sWKVb/CMWpb+SkZJnGYBDfY9NbPF6
         ihmrNBOqFPzUM8wNR9ZlYWk39z/glN+yHc/OELWi34ozQ/tINmP8yRk9miEvN3d53ltN
         ANm8dIdWhYtKFnwkE3mK2JodPKk3ZMsVJ/LAXe5+0ndSsvsa1iJQjoUNh4tBMMxn77uX
         scbON6LIHFtFDCP9Ud49lXTz0TonDfHgQLfEjur22UA1p2pBCRZOq/Nst56pvGxVxEut
         cp7j1qwVLVG4YorYMAW3Ri24+Dbka2kmNZOOfESVNu/zzfRTq6EFSxoGyC4bTPR+RpZm
         33WQ==
X-Gm-Message-State: APjAAAWpa34DTFE2OMdqmzDiy6u8eonmqKfz4/lhwnyiG8Xhnlj0S1ZS
        5ePfkrkK1o/hxzFPGpOh9+fD5w==
X-Google-Smtp-Source: APXvYqyMEn90cp6R9MWMj/HJmzulUNmcokEq3zfm9OmaA0vTRaK1wb0kEC559DwYAMjQKSXHIW3mug==
X-Received: by 2002:a1c:5f09:: with SMTP id t9mr17082582wmb.112.1561384208642;
        Mon, 24 Jun 2019 06:50:08 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id v4sm9256542wmg.22.2019.06.24.06.50.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 06:50:08 -0700 (PDT)
Date:   Mon, 24 Jun 2019 15:50:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Yuehaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        sdf@google.com, jianbol@mellanox.com, jiri@mellanox.com,
        mirq-linux@rere.qmqm.pl, willemb@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] flow_dissector: Fix vlan header offset in
 __skb_flow_dissect
Message-ID: <20190624135007.GA17673@nanopsycho>
References: <20190619160132.38416-1-yuehaibing@huawei.com>
 <20190619183938.GA19111@mini-arch>
 <00a5d09f-a23e-661f-60c0-75fba6227451@huawei.com>
 <20190621003317.GE1383@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621003317.GE1383@mini-arch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 21, 2019 at 02:33:17AM CEST, sdf@fomichev.me wrote:
>On 06/20, Yuehaibing wrote:
>> On 2019/6/20 2:39, Stanislav Fomichev wrote:
>> > On 06/20, YueHaibing wrote:
>> >> We build vlan on top of bonding interface, which vlan offload
>> >> is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
>> >> BOND_XMIT_POLICY_ENCAP34.
>> >>
>> >> __skb_flow_dissect() fails to get information from protocol headers
>> >> encapsulated within vlan, because 'nhoff' is points to IP header,
>> >> so bond hashing is based on layer 2 info, which fails to distribute
>> >> packets across slaves.
>> >>
>> >> Fixes: d5709f7ab776 ("flow_dissector: For stripped vlan, get vlan info from skb->vlan_tci")
>> >> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> >> ---
>> >>  net/core/flow_dissector.c | 3 +++
>> >>  1 file changed, 3 insertions(+)
>> >>
>> >> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
>> >> index 415b95f..2a52abb 100644
>> >> --- a/net/core/flow_dissector.c
>> >> +++ b/net/core/flow_dissector.c
>> >> @@ -785,6 +785,9 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
>> >>  		    skb && skb_vlan_tag_present(skb)) {
>> >>  			proto = skb->protocol;
>> >>  		} else {
>> >> +			if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX)
>> >> +				nhoff -=  sizeof(*vlan);
>> >> +
>> > Should we instead fix the place where the skb is allocated to properly
>> > pull vlan (skb_vlan_untag)? I'm not sure this particular place is
>> > supposed to work with an skb. Having an skb with nhoff pointing to
>> > IP header but missing skb_vlan_tag_present() when with
>> > proto==ETH_P_8021xx seems weird.
>> 
>> The skb is a forwarded vxlan packet, it send through vlan interface like this:
>> 
>>    vlan_dev_hard_start_xmit
>>     --> __vlan_hwaccel_put_tag //vlan_tci and VLAN_TAG_PRESENT is set
>>     --> dev_queue_xmit
>>         --> validate_xmit_skb
>>           --> validate_xmit_vlan // vlan_hw_offload_capable is false
>>              --> __vlan_hwaccel_push_inside //here skb_push vlan_hlen, then clear skb->tci
>> 
>>     --> bond_start_xmit
>>        --> bond_xmit_hash
>>          --> __skb_flow_dissect // nhoff point to IP header
>>             -->  case htons(ETH_P_8021Q)
>>             // skb_vlan_tag_present is false, so
>>               vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan), //vlan point to ip header wrongly
>I see, so bonding device propagates hw VLAN support from the slaves.
>If one of the slaves doesn't have it, its disabled for the bond device.
>Any idea why we do that? Why not pass skbs to the slave devices
>instead and let them handle the hw/sw vlan implementation?

Probably due to historical reasons. It is indeed not needed to push the
vlan header. We should rather have the vlan_tci filled all the way down
to the transmitting netdevice. So the bonding/team should have the
NETIF_F_HW_VLAN_CTAG_TX and NETIF_F_HW_VLAN_STAG_TX flags always on.
That seems to be the correct fix to me.


>I see the propagation was added in 278339a42a1b 10 years ago and
>I don't see any rationale in the commit description.
>Somebody with more context should probably chime in :-)
