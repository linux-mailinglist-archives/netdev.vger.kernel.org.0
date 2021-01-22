Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A84300ADF
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbhAVSLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbhAVR5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:57:32 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C0C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:56:52 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q131so4276471pfq.10
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4dBT1BSXVpYqqKfkRYpWS031Wd+xHAUxb9YF4TVzkYM=;
        b=ma+opaRHNWy/feJErokIV9r5/SxYdEQO/XgqNXPwz9zmC7gz56qnA0g85w7Dx1PPeK
         x9ImdwxMYFVD7ZO/i916Zf8KfmrZZG6mGESU8MDlUJeryxgcRjtPkfQO7ANppLl+Esn5
         +pf9yhI4n47kOLWWoBAUFdzwyoc1NOp8MsI/d8Ul3MUHSS9fBNAVSlWgYCe6/s79bo54
         Ix5cQcQRRK1tYe11wtlnqBORCFJTqcodpPFwP3l55ER2COkXMts21pmkkOKQ/Ao4oVrH
         xKwCq8XvG7GhXYtG02RODnSLEGmpevQUKeRUJ8/LGRO2xtyliHYjZoC/RsnvLXYSvz+g
         4aWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4dBT1BSXVpYqqKfkRYpWS031Wd+xHAUxb9YF4TVzkYM=;
        b=FmBxurObJAWPYCf5huWeaox06qFNbfZTKIRvdSwEq9YNo3uw5A/qZ/ab2RJcfW7L1s
         YCQ1VyBmaVNcWnXfGwRwPRG2/ITuJBTQeAPskSAClG3oLqdHZnGZXd8UhONIC3zEA9cZ
         L4tvNISzszcmK72peLPfibCoXak6A+2yV0bVCi5X93U6GFWETcJTWkuIv/unsnx/SBQ/
         r7r4fR4rLGVBgDQXPoK4p6vtLsbA/qiS6h2u/QgjmPTR4oH5ITm/1ysJED2i5P6F395X
         2JR2bz1FvLpMYNEtOjX5SONT5pxQSFzP1orT+7BWR5oU/er30bLM92kLFsWIifYmJ0xM
         hgzg==
X-Gm-Message-State: AOAM533xDi8lau2p6dHb7LL6ooO7BDpfylth8K/Adm/hlnBeOg55a2YV
        SLOTMCIm/eC+Zt5/fEnvarFFvVQmDug=
X-Google-Smtp-Source: ABdhPJy+mrqHvsL75d1IsQXIKZiyPd/IsJGScY+FordmCE9ZmaCPbOeqgwtzZzvGXu2bH6Ws1lD9cg==
X-Received: by 2002:a63:7748:: with SMTP id s69mr5688723pgc.81.1611338211403;
        Fri, 22 Jan 2021 09:56:51 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm10495449pju.36.2021.01.22.09.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 09:56:50 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
To:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
Date:   Fri, 22 Jan 2021 09:56:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122155948.5573-3-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 7:59 AM, George McCollister wrote:
> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> tag removal, duplicate generation and forwarding on DSA switches.
> 
> Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
> device so DSA can tell them apart from other devices in
> dsa_slave_changeupper.
> 
> Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
> to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.
> 
> The DSA switch driver should then set netdev feature flags for the
> HSR/PRP operation that it offloads.
>     NETIF_F_HW_HSR_TAG_INS
>     NETIF_F_HW_HSR_TAG_RM
>     NETIF_F_HW_HSR_FWD
>     NETIF_F_HW_HSR_DUP
> 
> For HSR, insertion involves the switch adding a 6 byte HSR header after
> the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.
> 
> Tag removal involves automatically stripping the HSR/PRP header/trailer
> in the switch. This is possible when the switch also preforms auto
> deduplication using the HSR/PRP header/trailer (making it no longer
> required).
> 
> Forwarding involves automatically forwarding between redundant ports in
> an HSR. This is crucial because delay is accumulated as a frame passes
> through each node in the ring.
> 
> Duplication involves the switch automatically sending a single frame
> from the CPU port to both redundant ports. This is required because the
> inserted HSR/PRP header/trailer must contain the same sequence number
> on the frames sent out both redundant ports.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

This is just a high level overview for now, but I would split this into two:

- a patch that adds HSR offload to the existing HSR stack and introduces
the new netdev_features_t bits to support HSR offload, more on that below

- a patch that does the plumbing between HSR and within the DSA framework

> ---
>  Documentation/networking/netdev-features.rst | 20 ++++++++++++++++
>  include/linux/if_hsr.h                       | 22 ++++++++++++++++++
>  include/linux/netdev_features.h              |  9 ++++++++
>  include/linux/netdevice.h                    | 13 +++++++++++
>  include/net/dsa.h                            | 13 +++++++++++
>  net/dsa/dsa_priv.h                           | 11 +++++++++
>  net/dsa/port.c                               | 34 ++++++++++++++++++++++++++++
>  net/dsa/slave.c                              | 13 +++++++++++
>  net/dsa/switch.c                             | 24 ++++++++++++++++++++
>  net/ethtool/common.c                         |  4 ++++
>  net/hsr/hsr_device.c                         | 12 +++-------
>  net/hsr/hsr_forward.c                        | 27 +++++++++++++++++++---
>  net/hsr/hsr_forward.h                        |  1 +
>  net/hsr/hsr_main.c                           | 14 ++++++++++++
>  net/hsr/hsr_main.h                           |  8 +------
>  net/hsr/hsr_slave.c                          | 13 +++++++----
>  16 files changed, 215 insertions(+), 23 deletions(-)
>  create mode 100644 include/linux/if_hsr.h
> 
> diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
> index a2d7d7160e39..4eab45405031 100644
> --- a/Documentation/networking/netdev-features.rst
> +++ b/Documentation/networking/netdev-features.rst
> @@ -182,3 +182,23 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
>  be re-segmentable by GSO or TSO back to the exact original packet stream.
>  Hardware GRO is dependent on RXCSUM since every packet successfully merged
>  by hardware must also have the checksum verified by hardware.
> +
> +* hsr-tag-ins-offload
> +
> +This should be set for devices which insert an HSR (highspeed ring) tag
> +automatically when in HSR mode.
> +
> +* hsr-tag-rm-offload
> +
> +This should be set for devices which remove HSR (highspeed ring) tags
> +automatically when in HSR mode.
> +
> +* hsr-fwd-offload
> +
> +This should be set for devices which forward HSR (highspeed ring) frames from
> +one port to another in hardware.
> +
> +* hsr-dup-offload
> +
> +This should be set for devices which duplicate outgoing HSR (highspeed ring)
> +frames in hardware.

Do you think we can start with a hsr-hw-offload feature and create new
bits to described how challenged a device may be with HSR offload? Is it
 reasonable assumption that functional hardware should be able to
offload all of these functions or none of them?

It may be a good idea to know what the platform that Murali is working
on or has worked on is capable of doing, too.

[snip]

>  
> +static inline bool netif_is_hsr_master(const struct net_device *dev)
> +{
> +	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_HSR;
> +}
> +
> +static inline bool netif_is_hsr_slave(const struct net_device *dev)
> +{
> +	return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_HSR;
> +}

I believe the kernel community is now trying to eliminate the use of the
terms master and slave, can you replace these with some HSR specific
naming maybe?
-- 
Florian
