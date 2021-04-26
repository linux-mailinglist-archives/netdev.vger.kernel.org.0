Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8362736BAB1
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbhDZU2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbhDZU2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 16:28:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7648EC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 13:28:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id zg3so4739336ejb.8
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 13:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6HryAfYx3/zRXSaYfBE41paZ2g8+TvoZJzNvgMqI3p0=;
        b=samMgfVtK07V7kktgrg6kYx5HKlNUtfR+kqEs4e832tnWwHxUpdT1WUviBRKrk5Sc0
         P5VCd4DirH9sZlY49wNWi2YmzfYatnXc4deNz92XfvhebmAMxv/JUhgNmTPewmDwDr+P
         7bIOudiJqvMV5aYSi0wET0rr4d7OfFBG0bDVkyR4lfItpXXJMkdEE1kAwYorh/gNPlGz
         G3qS1JHwbJEMTySYXm+LFmDxgY9ZUs/N9bDg0JoaGmGKIt5Ta4Jx9nRUngo2u++hap9i
         y9vuN6P/S0guspjhiUuNZBuvUt5+PpTwrTYd0WSxcmX4zQ0CuckqlBHLWmP4SHZRI1+p
         iLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6HryAfYx3/zRXSaYfBE41paZ2g8+TvoZJzNvgMqI3p0=;
        b=tfkxeZm+F0KZSCOt/EmMb3mQ1t14FlbvnsyzFyYJo0eede6RxFDgPTgLPzQJjPmKRA
         HnIdyaAt/5Y8gYQb1cfxbR2CtLdT4m1CBfFBYobV59/ug8YxkRZ5tFaM2jNca6HZq0jK
         yBlodLILLJYhRa+rEuFMPM5ikbGfBNoC2VL+Jfcx+ZhqJesvTyVmHhVteIbPQHqX5eFe
         S911SrNY8PSqnpi1B0JRULDzj+elPXGOazC2M5Us2vz4qwIjZzVWiYsrD16qFbH1GgLU
         uT/EQcP1hqHqJC4T91cLRtXJq2/Iua6ZnO9IPN2yarnEpSQuafIEL61JXmEzaLmQESkG
         COQw==
X-Gm-Message-State: AOAM532gEcohx69FjVgyQyAdzfPO0fedRuG2sGexRT2dXWhgbGOkpZXP
        5EGGNXAWZv2DPaet18GDVFE=
X-Google-Smtp-Source: ABdhPJyeS7rNhoTFa/fi5p9g96F4gPzwWBW7CdQ3LMslRcWEXcNK01xSuYKsEO4yJzDu+jVo2o6q8A==
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr20451737ejc.90.1619468882188;
        Mon, 26 Apr 2021 13:28:02 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n12sm640642edw.95.2021.04.26.13.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:28:01 -0700 (PDT)
Date:   Mon, 26 Apr 2021 23:28:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 5/9] net: dsa: Track port PVIDs
Message-ID: <20210426202800.y4hfurf5k3hrbvqf@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-6-tobias@waldekranz.com>
 <20210426194026.3sr22rqyf2srrwtq@skbuf>
 <877dkoq09r.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dkoq09r.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:05:52PM +0200, Tobias Waldekranz wrote:
> On Mon, Apr 26, 2021 at 22:40, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Hi Tobias,
> >
> > On Mon, Apr 26, 2021 at 07:04:07PM +0200, Tobias Waldekranz wrote:
> >> In some scenarios a tagger must know which VLAN to assign to a packet,
> >> even if the packet is set to egress untagged. Since the VLAN
> >> information in the skb will be removed by the bridge in this case,
> >> track each port's PVID such that the VID of an outgoing frame can
> >> always be determined.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >
> > Let me give you this real-life example:
> >
> > #!/bin/bash
> >
> > ip link add br0 type bridge vlan_filtering 1
> > for eth in eth0 eth1 swp2 swp3 swp4 swp5; do
> > 	ip link set $eth up
> > 	ip link set $eth master br0
> > done
> > ip link set br0 up
> >
> > bridge vlan add dev eth0 vid 100 pvid untagged
> > bridge vlan del dev swp2 vid 1
> > bridge vlan del dev swp3 vid 1
> > bridge vlan add dev swp2 vid 100
> > bridge vlan add dev swp3 vid 100 untagged
> >
> > reproducible on the NXP LS1021A-TSN board.
> > The bridge receives an untagged packet on eth0 and floods it.
> > It should reach swp2 and swp3, and be tagged on swp2, and untagged on
> > swp3 respectively.
> >
> > With your idea of sending untagged frames towards the port's pvid,
> > wouldn't we be leaking this packet to VLAN 1, therefore towards ports
> > swp4 and swp5, and the real destination ports would not get this packet?
> 
> I am not sure I follow. The bridge would never send the packet to
> swp{4,5} because should_deliver() rejects them (as usual). So it could
> only be sent either to swp2 or swp3. In the case that swp3 is first in
> the bridge's port list, it would be sent untagged, but the PVID would be
> 100 and the flooding would thus be limited to swp{2,3}.

Sorry, _I_ don't understand.

When you say that the PVID is 100, whose PVID is it, exactly? Is it the
pvid of the source port (aka eth0 in this example)? That's not what I
see, I see the pvid of the egress port (the Marvell device)...

So to reiterate: when you transmit a packet towards your hardware switch
which has br0 inside the sb_dev, how does the switch know in which VLAN
to forward that packet? As far as I am aware, when the bridge had
received the packet as untagged on eth0, it did not insert VLAN 100 into
the skb itself, so the bridge VLAN information is lost when delivering
the frame to the egress net device. Am I wrong?
