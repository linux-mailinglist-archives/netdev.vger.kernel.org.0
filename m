Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5024314033
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhBHURi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbhBHURS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:17:18 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE31C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 12:16:38 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id a25so18974629ljn.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 12:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WO+CLkgUDraUDmu9kpnuQkPMhU0TkpGfM35HK61/4xE=;
        b=m/b6C+BuqvFyncXyL7YuoxIbHHYK6uameuvqmNFWImDF0wN2jvOKmat+XMd0CDRqR8
         234nOcw1FLtuqTdGgK3MY8uljK6ldye2YHxzD0z09B5RmrQEcYaq1OIKV2qwqpjh4M69
         +DZUgNqPrFmEkpxGQ+PHRcp4rIDv+3LyHQXIg7i70M/mlWnwlHULSbpfhf+ftWEbrqji
         QxU5G0eQg9kMS9u1GtUvhOcKp0l5Rx0o9ILDb7jzPF8qtJVRX522r+LLQqlxVj2acnWM
         AJuOKLW5uA0tEzTboLsPeIyBW/uew/VA25I05XCY8kLUtJ+aLKe3gaqZrwcbyWV3Dslf
         fBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WO+CLkgUDraUDmu9kpnuQkPMhU0TkpGfM35HK61/4xE=;
        b=CbRvfQvwjeXbtoSbLVomRgow0PwmShzUXCMbPzCPkcf+E5/Orwq1Eo2Ko4xxmtkEGf
         fBsjBqxlvcwLfYQlPnvoILEzE2jdUGem54ACE7Edevzr+zweUALy0ZZMhS4qBIf7GTWN
         4IoUNqn/nCr1WF+NADKQ/fc4YfQOTw3OmYnXP75H4YYJQyhGUOCzw16AKa3YcYnHvUV+
         qqDNvhnCEVyTLWvrjNTFmQIO6TQa4Age5m3qfViTJWaxF7OLAEFWpacvf9qwUYTUOur5
         gkkclql0YJSFvHpMS1SMMQiaCWbHT3pPgdWvs0WQMdDc4lhwjBv4nWAUrVHkQsr4ku71
         mb3w==
X-Gm-Message-State: AOAM532H1adgU8nl4/p6kxdCbDjaYGf8XtjB78yyTcFydZfCaYxPaH7W
        lcG1Wgvm/Ol83o35N3NTxS22HQ==
X-Google-Smtp-Source: ABdhPJzg8AKsCdItuF9YFHZHEz3nFyZkhdN2CshJBlPJro5tNk+736FVTrXoOsK+LEMalDbRK36UCA==
X-Received: by 2002:a2e:87c6:: with SMTP id v6mr12623185ljj.153.1612815396596;
        Mon, 08 Feb 2021 12:16:36 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p16sm2205831lfc.97.2021.02.08.12.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 12:16:36 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
In-Reply-To: <20210204215926.64377-1-george.mccollister@gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
Date:   Mon, 08 Feb 2021 21:16:35 +0100
Message-ID: <87sg6648nw.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 15:59, George McCollister <george.mccollister@gmail.com> wrote:
> Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
> removal, forwarding and duplication on DSA switches.
> This series adds offloading to the xrs700x DSA driver.
>
> Changes since RFC:
>  * Split hsr and dsa patches. (Florian Fainelli)
>
> Changes since v1:
>  * Fixed some typos/wording. (Vladimir Oltean)
>  * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
>  * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
>  * Don't add hsr tag for HSR v0 supervisory frames.
>  * Fixed tag insertion offloading for PRP.
>
> George McCollister (4):
>   net: hsr: generate supervision frame without HSR/PRP tag
>   net: hsr: add offloading support
>   net: dsa: add support for offloading HSR
>   net: dsa: xrs700x: add HSR offloading support
>
>  Documentation/networking/netdev-features.rst |  21 ++++++
>  drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
>  drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
>  include/linux/if_hsr.h                       |  27 +++++++
>  include/linux/netdev_features.h              |   9 +++
>  include/net/dsa.h                            |  13 ++++
>  net/dsa/dsa_priv.h                           |  11 +++
>  net/dsa/port.c                               |  34 +++++++++
>  net/dsa/slave.c                              |  14 ++++
>  net/dsa/switch.c                             |  24 ++++++
>  net/dsa/tag_xrs700x.c                        |   7 +-
>  net/ethtool/common.c                         |   4 +
>  net/hsr/hsr_device.c                         |  46 ++----------
>  net/hsr/hsr_device.h                         |   1 -
>  net/hsr/hsr_forward.c                        |  33 ++++++++-
>  net/hsr/hsr_forward.h                        |   1 +
>  net/hsr/hsr_framereg.c                       |   2 +
>  net/hsr/hsr_main.c                           |  11 +++
>  net/hsr/hsr_main.h                           |   8 +-
>  net/hsr/hsr_slave.c                          |  10 ++-
>  20 files changed, 331 insertions(+), 56 deletions(-)
>  create mode 100644 include/linux/if_hsr.h
>
> -- 
> 2.11.0

Hi George,

I will hopefully have some more time to look into this during the coming
weeks. What follows are some random thoughts so far, I hope you can
accept the windy road :)

Broadly speaking, I gather there are two common topologies that will be
used with the XRS chip: "End-device" and "RedBox".

End-device:    RedBox:
 .-----.       .-----.
 | CPU |       | CPU |
 '--+--'       '--+--'
    |             |
.---0---.     .---0---.
|  XRS  |     |  XRS  3--- Non-redundant network
'-1---2-'     '-1---2-'
  |   |         |   |
 HSR Ring      HSR Ring

From the looks of it, this series only deals with the end-device
use-case. Is that right?

I will be targeting a RedBox setup, and I believe that means that the
remaining port has to be configured as an "interlink". (HSR/PRP is still
pretty new to me). Is that equivalent to a Linux config like this:

      br0
     /   \
   hsr0   \
   /  \    \
swp1 swp2 swp3

Or are there some additional semantics involved in forwarding between
the redundant ports and the interlink?

The chip is very rigid in the sense that most roles are statically
allocated to specific ports. I think we need to add checks for this.

Looking at the packets being generated on the redundant ports, both
regular traffic and supervision frames seem to be HSR-tagged. Are
supervision frames not supposed to be sent with an outer ethertype of
0x88fb? The manual talks about the possibility of setting up a policy
entry to bypass HSR-tagging (section 6.1.5), is this what that is for?

In the DSA layer (dsa_slave_changeupper), could we merge the two HSR
join/leave calls somehow? My guess is all drivers are going to end up
having to do the same dance of deferring configuration until both ports
are known.

Thanks for working on this!
