Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2854A36BA2D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhDZTlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhDZTlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 15:41:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98848C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:40:29 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cq11so23522183edb.0
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Is2SDw8WeN8XVXoywR6GIkJzDlR3VcflqryG4qw9d8I=;
        b=ueRq8J2oOg2cDQawuLIidmcLpsWVOn320XQbHevQDQFX1pqUMprNUFGbR23FVS3nTE
         Uc4qQs2befSyroRSuplHhB0omOiXVJCP1fvYP3UaoyaijKoG7KYyLRyaGdvzALeELsZK
         GfTbZnHlX8cgz3L9NpiaFj0cJmzb7zeWSfA331y50C6TPL401IUVkivlNKAloSjkAvxd
         zhU1D6vM9q5MQ/1JzQ0+2HVlenqXYpZCflgkCeda7NOqkyaprjlQJL/O/YrYeUteHMKr
         0jI6+q1Uq+ZQAQgeDj+ER/xsnHtcnTEAiddGXRpldDhA27/dOoQ6eKh2Wu/xE7Uh/WhR
         L+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Is2SDw8WeN8XVXoywR6GIkJzDlR3VcflqryG4qw9d8I=;
        b=NXWis9aJTEInKmvi5AModc1HJu2/X84q6xAmPDr3st8wJq8ILTeu1LC8QRaF4AVjbs
         sXJNEG+/jqEPXK1VamJYq3Ga82vs1TpiT3A9u+m6dCgVx32sqhCrWCL9o3Q/4czeguJ3
         M4xLqlqDmjFQ4+f5xYA1JiinLQHiGSBFqKl4750zHKb6smPcHRbzAwkj9L+sPAXsm3Ba
         rlDSelQYY3QD7uNVDaarCVkIBxGu1JRMlCa8BLJK5ciogxemU+9gomLIk8mOm6B58AOl
         oDdhAkePSrAwVlA1lokLOngSGCPUeceC5Wy3J87rP4wJ7QRh0D3VV9zWA7HxTQeHE8T/
         09uA==
X-Gm-Message-State: AOAM532YhESwgJKjnyuFwrHlcEmzhPFiOTU+y1kyknHaoBuFq/EF9uHI
        kmu783drc8kTcDqyDUrscus=
X-Google-Smtp-Source: ABdhPJwSjXK9iN2Jta354iUSV1YcFrkLwVahg3PrhUegd2cne5RyDoBF4cNv+LUk6pzLI0abflOj0Q==
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr310923eda.149.1619466028283;
        Mon, 26 Apr 2021 12:40:28 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id br14sm12139667ejb.61.2021.04.26.12.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 12:40:27 -0700 (PDT)
Date:   Mon, 26 Apr 2021 22:40:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 5/9] net: dsa: Track port PVIDs
Message-ID: <20210426194026.3sr22rqyf2srrwtq@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426170411.1789186-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Mon, Apr 26, 2021 at 07:04:07PM +0200, Tobias Waldekranz wrote:
> In some scenarios a tagger must know which VLAN to assign to a packet,
> even if the packet is set to egress untagged. Since the VLAN
> information in the skb will be removed by the bridge in this case,
> track each port's PVID such that the VID of an outgoing frame can
> always be determined.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Let me give you this real-life example:

#!/bin/bash

ip link add br0 type bridge vlan_filtering 1
for eth in eth0 eth1 swp2 swp3 swp4 swp5; do
	ip link set $eth up
	ip link set $eth master br0
done
ip link set br0 up

bridge vlan add dev eth0 vid 100 pvid untagged
bridge vlan del dev swp2 vid 1
bridge vlan del dev swp3 vid 1
bridge vlan add dev swp2 vid 100
bridge vlan add dev swp3 vid 100 untagged

reproducible on the NXP LS1021A-TSN board.
The bridge receives an untagged packet on eth0 and floods it.
It should reach swp2 and swp3, and be tagged on swp2, and untagged on
swp3 respectively.

With your idea of sending untagged frames towards the port's pvid,
wouldn't we be leaking this packet to VLAN 1, therefore towards ports
swp4 and swp5, and the real destination ports would not get this packet?
