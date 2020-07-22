Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2312298B0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgGVMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732466AbgGVMx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:53:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CB2C0619DC;
        Wed, 22 Jul 2020 05:53:57 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id lx13so2090061ejb.4;
        Wed, 22 Jul 2020 05:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C2Q65rLgQCFAZPTaAiFAGL3WNsz9Y3J5CP3LiOy1w0o=;
        b=OJIJEUqBwTFeyRSqOZVb72Rna/IWZsW8TFLwQV3bmc82vaRGz46wl7RWCR6vIS2rZg
         l7wClxuAtFnJvW9mO2AEPkXMtsGr/GgVOmWQwhJjtuD0r7EC/S3440Wn7ghtjNL7/0ft
         6nw/4SMIycpzxFWMjEHKGo0D+Lk/C4sC4GF5PyfVx6Hbcd9nuDaJROtdtbYy51ml3Qn+
         12TNuZhuxVFTWBl1y9KVTQawSk3sW6HhvjcmDdD4HIgoR0vDAnmzeMl4cFdTwgd91NPQ
         b1UPs0De16EuTnmTlTprOswBL1r3NYuDRHWij7ufuYOXi4JTsOrirEI23oYhHw9QN10G
         BuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C2Q65rLgQCFAZPTaAiFAGL3WNsz9Y3J5CP3LiOy1w0o=;
        b=eUritCU4IIdB90+3RVYWM9cJnUuidpikaEiM5zDPzt2jz9dZE4DOVGjToA+ZTgVNG3
         M3oTuivJJREGHL0bzNjBT5fCNUqqtT2N7KqeawihLgCRB9O04u3vEMMn6sleLiaqP3mm
         tHnLFmhXTscAaxdlbVAptoaADW92DWxTD7dH56ipMI7s55g6DZJ0AwtZpmOHE0b1D/Q5
         XAHMWiKU6a6Ykgt/K8AkIJQfFrdaldreASh6yM3CmnN9JsGVO7HgA0pfGJdo6Li1bppb
         32uRiqCaPoSXmm1uyjoi5ygKdP8OpSkCNy2mC6V6mIJ1Wh+9DA1CLoE9ZNBGMiFa8waR
         XeSw==
X-Gm-Message-State: AOAM5325IQE5XY9VthvqqymO7tnh14TYVc2+xFXBqvDW/QtHLdRLXZKz
        /am3EV8q6ZnaJ73VsfYBtuw=
X-Google-Smtp-Source: ABdhPJwh9BONiVoCz78jT2F7EaVSzGpQkLcAmD/JVtYBBr3R+okVe7dY80RHaw6MmTnOQAbhRfuyFQ==
X-Received: by 2002:a17:906:86d4:: with SMTP id j20mr32083745ejy.68.1595422435644;
        Wed, 22 Jul 2020 05:53:55 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x10sm19088247ejc.46.2020.07.22.05.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 05:53:55 -0700 (PDT)
Date:   Wed, 22 Jul 2020 15:53:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Subject: Re: [PATCH v3 2/2] net: dsa: ocelot: Add support for QinQ Operation
Message-ID: <20200722125352.qbllow6pm6za5pq4@skbuf>
References: <20200722103200.15395-1-hongbo.wang@nxp.com>
 <20200722103200.15395-3-hongbo.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722103200.15395-3-hongbo.wang@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 06:32:00PM +0800, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> This featue can be test using network test tools
>     TX-tool -----> swp0  -----> swp1 -----> RX-tool
> 
> TX-tool simulates Customer that will send and receive packets with single
> VLAN tag(CTAG), RX-tool simulates Service-Provider that will send and
> receive packets with double VLAN tag(STAG and CTAG). This refers to
> "4.3.3 Provider Bridges and Q-in-Q Operation" in VSC99599_1_00_TS.pdf.
> 
> The related test commands:
> 1.
> ip link add dev br0 type bridge
> ip link set dev swp0 master br0
> ip link set dev swp1 master br0
> 2.
> ip link add link swp0 name swp0.111 type vlan id 111
> ip link add link swp1 name swp1.111 type vlan protocol 802.1ad id 111
> 3.
> bridge vlan add dev swp0 vid 100 pvid
> bridge vlan add dev swp1 vid 100
> bridge vlan del dev swp1 vid 1 pvid
> bridge vlan add dev swp1 vid 200 pvid untagged
> Result:
> Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> Service-Provider(STAG \
>                     tpid:88A8 vid:100, CTAG tpid:8100 vid:111)
> 
> Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
> ---

Instead of writing a long email, let me just say this.
I ran your commands on 2 random network cards (not ocelot/felix ports).
They don't produce the same results as you. In fact, no frame with VLAN
111 C-TAG is forwarded (or received) at all by the bridge, not to
mention that no VLAN 1000 S-TAG is pushed on egress.


Have you tried playing with these commands?

ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad
ip link set eth0 master br0
ip link set eth1 master br0
bridge vlan add dev eth0 vid 100 pvid
bridge vlan add dev eth1 vid 100

They produce the same output as yours, but have the benefit of using
the network stack's abstractions and not glue between the 802.1q and the
bridge module, hidden in the network driver.

I am sending the following packet towards eth0:

00:04:9f:05:f4:ad > 00:01:02:03:04:05, ethertype 802.1Q (0x8100), length 102: \
	vlan 111, p 0, ethertype IPv4, 10.0.111.1 > 10.0.111.3: \
	ICMP echo request, id 63493, seq 991, length 64

and collecting it on the partner of eth1 as follows:

00:04:9f:05:f4:ad > 00:01:02:03:04:05, ethertype 802.1Q-QinQ (0x88a8), length 106: \
	vlan 100, p 0, ethertype 802.1Q, vlan 111, p 0, ethertype IPv4, \
	10.0.111.1 > 10.0.111.3: ICMP echo request, id 63493, seq 991, length 64

Thanks,
-Vladimir
