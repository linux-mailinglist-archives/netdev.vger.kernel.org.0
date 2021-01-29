Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6E3090B8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhA2XoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhA2XoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:44:01 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C43C061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:43:07 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id kg20so15366458ejc.4
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1tGj3YNlrXPV9OlmjpByDCk3te/LnkW8VJOuhKBAGKY=;
        b=l5qAmLVFkSkjrYRgihgytQm+vTclJS2TaHYoTaIuc8dnyOKupB5xuXV9p76wJOm9A6
         KdX9GahjmS76KXsBHRGQIk8wGDiGTZldt1ULONPtdnbQP54u2DTRjRJSS8VAz5TmIjQ0
         JPWkY/aN6vAURVxvzlgcmAmTfhN+juYpaqgcy6QR6WLvJZxjqFoMuPofA6UYbC7UKfAU
         bfJPdWjQesFaPMFfecEiwst2JN8gcz4ZmC75+0BHvST+os0g6RyzzY9sj95Ztzqg/bZ1
         WooSZqi3+n9SQ3TStDgi9Quvj2A5RZvz9y9J+lmHemsTJYeZtXX+ASq1wFWjJp/l3vPr
         odlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tGj3YNlrXPV9OlmjpByDCk3te/LnkW8VJOuhKBAGKY=;
        b=AVTS8RtINJD46WDKu3hoZAGWdCSK8OdLusXnOmRdNXu34LArSoFdD6tRby41E0cOHu
         OJ53z+tidJgRNcdhiUDALy9HXl1jfJ/+Q3saaE0KhZog/ejmdhXykR+aoKsFPvVxiivV
         KuL/tPuitn9v8GRnj11hvGsinQqlO6+raQiAJ/EbScNkbdT27Qbh+Qft/luwg+w6cSS/
         +bsOoHKRDZVh+Cv13eLeQQMO/6P6wAJC4KelVcEeQb9JfP5gnK1ooVvRoxqPYVrx2T6+
         4OFCynR4qgSbs7xotOm9LXDo6/4p0CmsJ27kzrDPjJyDNbzedwyhIQudUy/o/xdpziu7
         BR+A==
X-Gm-Message-State: AOAM5324UWZlD+LMQTF6v0SKqUkPZEL7s1ehzFd6vLkj/PnEryvLRS8C
        D0F1QiNZMJhpritrpP0CUss=
X-Google-Smtp-Source: ABdhPJyXca5Kb5Lw5iFU0WMbK7E2W2K7GF79+ZfvYuOyqw+sg33T1tSq7wg2i9WwUrVnxb5XKPzwCg==
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr6939927ejr.39.1611963786425;
        Fri, 29 Jan 2021 15:43:06 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i22sm4374890ejx.77.2021.01.29.15.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 15:43:05 -0800 (PST)
Date:   Sat, 30 Jan 2021 01:43:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v8 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210129234304.heqjkkngqri5hjoc@skbuf>
References: <20210129010009.3959398-1-olteanv@gmail.com>
 <20210129010009.3959398-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129010009.3959398-9-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 03:00:06AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently DSA exposes the following sysfs:
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot
> 
> which is a read-only device attribute, introduced in the kernel as
> commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
> and used by libpcap since its commit 993db3800d7d ("Add support for DSA
> link-layer types").
> 
> It would be nice if we could extend this device attribute by making it
> writable:
> $ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> 
> This is useful with DSA switches that can make use of more than one
> tagging protocol. It may be useful in dsa_loop in the future too, to
> perform offline testing of various taggers, or for changing between dsa
> and edsa on Marvell switches, if that is desirable.
> 
> In terms of implementation, drivers can support this feature by
> implementing .change_tag_protocol, which should always leave the switch
> in a consistent state: either with the new protocol if things went well,
> or with the old one if something failed. Teardown of the old protocol,
> if necessary, must be handled by the driver.
> 
> Some things remain as before:
> - The .get_tag_protocol is currently only called at probe time, to load
>   the initial tagging protocol driver. Nonetheless, new drivers should
>   report the tagging protocol in current use now.
> - The driver should manage by itself the initial setup of tagging
>   protocol, no later than the .setup() method, as well as destroying
>   resources used by the last tagger in use, no earlier than the
>   .teardown() method.
> 
> For multi-switch DSA trees, error handling is a bit more complicated,
> since e.g. the 5th out of 7 switches may fail to change the tag
> protocol. When that happens, a revert to the original tag protocol is
> attempted, but that may fail too, leaving the tree in an inconsistent
> state despite each individual switch implementing .change_tag_protocol
> transactionally. Since the intersection between drivers that implement
> .change_tag_protocol and drivers that support D in DSA is currently the
> empty set, the possibility for this error to happen is ignored for now.
> 
> Testing:
> 
> $ insmod mscc_felix.ko
> [   79.549784] mscc_felix 0000:00:00.5: Adding to iommu group 14
> [   79.565712] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517
> $ insmod tag_ocelot.ko
> $ rmmod mscc_felix.ko
> $ insmod mscc_felix.ko
> [   97.261724] libphy: VSC9959 internal MDIO bus: probed
> [   97.267363] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 0
> [   97.274998] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 1
> [   97.282561] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 2
> [   97.289700] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 3
> [   97.599163] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [   97.862034] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [   97.950731] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
> [   97.964278] 8021q: adding VLAN 0 to HW filter on device swp0
> [   98.146161] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [   98.238649] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
> [   98.251845] 8021q: adding VLAN 0 to HW filter on device swp1
> [   98.433916] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [   98.485542] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
> [   98.503584] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow control rx/tx
> [   98.527948] device eno2 entered promiscuous mode
> [   98.544755] DSA: tree 0 setup
> 
> $ ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1): 56 data bytes
> 64 bytes from 10.0.0.1: seq=0 ttl=64 time=2.337 ms
> 64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.754 ms
> ^C
> --- 10.0.0.1 ping statistics ---

Jakub, I was stupid and I pasted the ping command output into the commit
message, so git will trim anything past the dotted line as not part of
the commit message, which makes your netdev/verify_signedoff test fail.
If by some sort of miracle I don't need to resend a v9, do you think you
could just delete this and the next 2 lines?

> 2 packets transmitted, 2 packets received, 0% packet loss
> round-trip min/avg/max = 0.754/1.545/2.337 ms
> 
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot
> $ cat ./test_ocelot_8021q.sh
>         #!/bin/bash
> 
>         ip link set swp0 down
>         ip link set swp1 down
>         ip link set swp2 down
>         ip link set swp3 down
>         ip link set swp5 down
>         ip link set eno2 down
>         echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
>         ip link set eno2 up
>         ip link set swp0 up
>         ip link set swp1 up
>         ip link set swp2 up
>         ip link set swp3 up
>         ip link set swp5 up
> $ ./test_ocelot_8021q.sh
> ./test_ocelot_8021q.sh: line 9: echo: write error: Protocol not available
> $ rmmod tag_ocelot.ko
> rmmod: can't unload module 'tag_ocelot': Resource temporarily unavailable
> $ insmod tag_ocelot_8021q.ko
> $ ./test_ocelot_8021q.sh
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot-8021q
> $ rmmod tag_ocelot.ko
> $ rmmod tag_ocelot_8021q.ko
> rmmod: can't unload module 'tag_ocelot_8021q': Resource temporarily unavailable
> $ ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1): 56 data bytes
> 64 bytes from 10.0.0.1: seq=0 ttl=64 time=0.953 ms
> 64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.787 ms
> 64 bytes from 10.0.0.1: seq=2 ttl=64 time=0.771 ms
> $ rmmod mscc_felix.ko
> [  645.544426] mscc_felix 0000:00:00.5: Link is Down
> [  645.838608] DSA: tree 0 torn down
> $ rmmod tag_ocelot_8021q.ko
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v8:
> - Take reference on tagging driver module in dsa_find_tagger_by_name.
> - Replaced DSA_NOTIFIER_TAG_PROTO_SET and DSA_NOTIFIER_TAG_PROTO_DEL
>   with a single DSA_NOTIFIER_TAG_PROTO.
> - Combined .set_tag_protocol and .del_tag_protocol into a single
>   .change_tag_protocol, and we're no longer calling those 2 functions at
>   probe and unbind time.
> - Dropped review tags due to amount of changes.
