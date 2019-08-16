Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB0901AC
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfHPMfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:35:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36426 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPMfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:35:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so1409227wrt.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 05:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wj+6uD246uLca+al9PqwXZP6vODcCv2s/NvBilb6zGg=;
        b=uQ3Q0PeaS6Zco5pUEM7+xKv6jS2sj6IrulqPZ5EwTpizNcoQfvfXgBFirOQ5/duaJZ
         tcbLfz88HpuZWeRK51Q83HgZwrOGGOYt/XCopNrxNvoM1PkudnUH7QRYQEnVFjbD+Bd8
         ygR6jDlTM3RS1B4awC5b4Mbj1AchsJTNDqccq1D3DBBQD9P+yz1I3p4GsSfLmFkKRwqT
         PqaSqa4v5kPyfl0iAd/rVnJe+f2mijjPn8FeNfwhftSxqjxoP6iPOnQcMG6M0B6+dZkO
         O5MpSWfqzA4tvDe1NAhBDot5crv332f0kyBHdVrt3Bh36btMl6Fnb6vwlVQ3xBYhmLus
         KiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wj+6uD246uLca+al9PqwXZP6vODcCv2s/NvBilb6zGg=;
        b=aRtr8RBBzR3dxqFWyKfIjPdn3OHo8LUCI9OYDi+FjqXPMliCuQsv/wmOLHsP35fW1L
         wyN6PSIbn8XRQoierFkvaRlpSE7SvR0jcw9Sdx4MhLe2nUD3xVqJ3P4lm8Z3IfehCslB
         nMQ8fd91Oa+hcyPG2leGujCQsmsyX6cyDiY5RP8s8YKAYI5oiaCf54Xy3aUtIK3R3Dhe
         6T4bokwU2RSE4lCm+aPan0phuJZJn03tjlQsbgd71zGPquzUwo93XZk5JtWYC9J6wyFH
         JRbJUqdFwgc0pvOqqR9EaLHWi5mPB/E5qI440BipBAx3yvHhbM285nFe69oHFqAQ1fmv
         b9pQ==
X-Gm-Message-State: APjAAAX43LuCQmdMTOD9ezHYDPhA8Iez9BVDTrERxV6IMtAIDTod8wWY
        wIoBORJEYSc9bTikDTK+z6U=
X-Google-Smtp-Source: APXvYqznicCaQj40s361o3s7XAW5CazsgWDpXW3ZFwA23JfDT+Y5UgLD0s0ska6OsvoZPBlM9kxsqQ==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr10860637wru.69.1565958908897;
        Fri, 16 Aug 2019 05:35:08 -0700 (PDT)
Received: from [192.168.8.147] (83.168.185.81.rev.sfr.net. [81.185.168.83])
        by smtp.gmail.com with ESMTPSA id a17sm5072333wmm.47.2019.08.16.05.35.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 05:35:07 -0700 (PDT)
Subject: Re: r8169: Performance regression and latency instability
To:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        netdev@vger.kernel.org
Cc:     edumazet@google.com, hkallweit1@gmail.com
References: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
Date:   Fri, 16 Aug 2019 14:35:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/19 2:09 PM, Juliana Rodrigueiro wrote:
> Greetings!
> 
> During migration from kernel 3.14 to 4.19, we noticed a regression on the network performance. Under the exact same circumstances, the standard deviation of the latency is more than double than before on the Realtek RTL8111/8168B (10ec:8168) using the r8169 driver.
> 
> Kernel 3.14:
>     # netperf -v 2 -P 0 -H <netserver-IP>,4 -I 99,5 -t omni -l 1 -- -O STDDEV_LATENCY -m 64K -d Send
>     313.37
> 
> Kernel 4.19:
>     # netperf -v 2 -P 0 -H <netserver-IP>,4 -I 99,5 -t omni -l 1 -- -O STDDEV_LATENCY -m 64K -d Send
>     632.96
> 
> In contrast, we noticed small improvements in performance with other non-Realtek network cards (igb, tg3). Which suggested a possible driver related bug.
> 
> However after bisecting the code, I ended up with the following patch, which was introduced in kernel 4.17 and modifies net/ipv4:
> 
>     commit 0a6b2a1dc2a2105f178255fe495eb914b09cb37a
>     Author: Eric Dumazet <edumazet@google.com>
>     Date:   Mon Feb 19 11:56:47 2018 -0800
> 
>         tcp: switch to GSO being always on
> 
> Could you please help me to clarify, should GSO be always on on my device? Or does it just affect TCP? According to ethtool it is always off, "ethtool -K eth0 gso on" has no effect, unless I switch SG on.
> 
>     # ethtool -k eth0
>     Offload parameters for eth0:
>     Cannot get device udp large send offload settings: Operation not supported
>     rx-checksumming: on
>     tx-checksumming: off
>     scatter-gather: off
>     tcp-segmentation-offload: off
>     udp-fragmentation-offload: off
>     generic-segmentation-offload: off
>     generic-receive-offload: on
>     large-receive-offload: off
> 
> I validated that reverting "tcp: switch to GSO being always on" successfully brings back the better performance for the r8169 driver.
> 
> I'm sure that reverting that commit is not the optimal solution, so I would like to kindly ask for help to shed some light in this issue.

Hi Juliana

I am sure that all commits done in TCP stack can show a regression on a particular
combination of packet sizes, MTU size, NIC, and measured metric.

Basically if your NIC does not support SG and TSO, there is a possibility
that the changes we did to enter the era of 100Gbit and 200Gbit NIC might
hurt a bit.

Lack of SG means that the lower stack might have to perform memory  allocations
to perform the segmentation and this might be slow (or even fail) under memory pressure.

I have no idea why you can even turn on SG, if it is turned off by default.

Please give us more information on the NIC

ethtool -i eth0 ; ifconfig eth0

Possibly try to use a recent ethtool, it seems yours is pretty old.

I also see this relevant commit : I have no idea why SG would have any relation with TSO.

commit a7eb6a4f2560d5ae64bfac98d79d11378ca2de6c
Author: Holger Hoffstätte <holger@applied-asynchrony.com>
Date:   Fri Aug 9 00:02:40 2019 +0200

    r8169: fix performance issue on RTL8168evl
    
    Disabling TSO but leaving SG active results is a significant
    performance drop. Therefore disable also SG on RTL8168evl.
    This restores the original performance.
    
    Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
    Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
    Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b2a275d8504c..912bd41eaa1b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6898,9 +6898,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
        /* RTL8168e-vl has a HW issue with TSO */
        if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
-               dev->vlan_features &= ~NETIF_F_ALL_TSO;
-               dev->hw_features &= ~NETIF_F_ALL_TSO;
-               dev->features &= ~NETIF_F_ALL_TSO;
+               dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
+               dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
+               dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
        }
 
        dev->hw_features |= NETIF_F_RXALL;

