Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A02F7674
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKKOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:34:00 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32790 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKOd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:33:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so8083588wrr.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 06:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p9u79VHTlYSKhEFnHPPYXgTl1Zaq4iJbA3N1mKwH9gg=;
        b=AwBZauiynQQt5N5WZYdidFu3WzRrnHXaJciCeFQULHHiTRBJSKK6PdTSBHuSjp6j8H
         w9+GN7f2/4w3zhLJM+5JiO61OwGoU3DLrkgb3KHx9NgejVVS/PdHQaFNZ4apq6EjMerG
         OCjzVNvc8HAOhisxtxXnvAvFsBJwpMfQPu+dm/A5C67gEKTZDI66HPs4Xt+Dn/f2u/TC
         b/vzzn+EN9p4DhESBBErsBNVLHtwABKdYqafqX1vmOLd8hDNi52JEv3vFbdSsNXlZDR0
         7g1eodfxYpxX3PRsj8kzchjG6dJFKHld6nHQYfMkyIMTDCbol0hCHEtu6UC0ztYK7kGb
         gETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p9u79VHTlYSKhEFnHPPYXgTl1Zaq4iJbA3N1mKwH9gg=;
        b=acau3o3cZJ9nVIuJf9JMvqAFToyIiZEUVKqZJkVd/Zt9RL4QKXl2md5htOQAeoLcW8
         kLHZl+acq6QkILJe65Pn2/BPZfjWhHBby/P5E7FGXKoAEiYuk1d+iVHyEfTaFGqJNi+W
         8PX/Q+/CXxI+GaROlWVAlk8n8MgwvcBZB3+RfdD3lgWQ97JFOgOEcw2rb4Y3V9lgMD1t
         5mP8DiHlLvTREiCNhODDQwffd341Bp7hAduuoJ4oUBzx09w9rlHh/FE28CKoot09LR87
         Ud4nbjhrDc0lPCw8d3aSrgLc/PNniD6sWO4+MJ3w7t8AhXF+9V6nj9Oa6wrxBqwl3tMP
         uekQ==
X-Gm-Message-State: APjAAAVWmqsDAFAQOgDAXNo0vNsf0BnJ3nqP8CfwQcRDau7Vf60+IMLA
        xxWgyrK3vKLjvtz/QJuFOVt6KrGAFWs=
X-Google-Smtp-Source: APXvYqyNKU4INgk8UnPBE1JU2U75VMB5PZyjZ15mhQc6WvCfmM/D2ZiVL6LrWFGf2PS0/RSif87YWw==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr20150850wrb.283.1573482835392;
        Mon, 11 Nov 2019 06:33:55 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id h124sm21691330wmf.30.2019.11.11.06.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 06:33:54 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:33:52 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     brouer@redhat.com, lorenzo@kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111143352.GA2698@apalos.home>
References: <20191111134615.GA8153@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111134615.GA8153@lunn.ch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Nov 11, 2019 at 02:46:15PM +0100, Andrew Lunn wrote:
> Hi Lorenzo, Jesper, Ilias
> 
> I just found that the XDP patches to mvneta have caused a regression.
> 
> This one breaks networking:

Thaks for the report.
Looking at the DTS i can see 'buffer-manager' in it. The changes we made were
for the driver path software buffer manager. 
Can you confirm which one your hardware uses?

I tested the patches on an espressobin, but the DTS i was using back then did
not register the dsa infrastructure and i only had an 'eth0'.

> 
> commit 8dc9a0888f4c8e27b25e48ff1b4bc2b3a845cc2d (HEAD)
> Author: Lorenzo Bianconi <lorenzo@kernel.org>
> Date:   Sat Oct 19 10:13:23 2019 +0200
> 
>     net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
>     
>     Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
>     mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
>     allocate skb since the previous patch introduced buffer recycling using
>     the page_pool API.
>     This patch fixes even an issue in the original driver where dma buffers
>     are accessed before dma sync.
>     mvneta driver can run on not cache coherent devices so it is
>     necessary to sync DMA buffers before sending them to the device
>     in order to avoid memory corruptions. Running perf analysis we can
>     see a performance cost associated with this DMA-sync (anyway it is
>     already there in the original driver code). In follow up patches we
>     will add more logic to reduce DMA-sync as much as possible.
> 
> I'm using an Linksys WRT1900ac, which has an Armada XP SoC. Device
> tree is arch/arm/boot/dts/armada-xp-linksys-mamba.dts.
> 
> With this patch applied, transmit appears to work O.K. My dhcp server
> is seeing good looking BOOTP requests and replying. However what is
> being received by the WRT1900ac is bad.

What if you assign a static ip address? Same effect?

> 
> 11:36:20.038558 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui Ethernet) Null Informati4
>         0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0030:  0000 0000 0000                           ......
> 11:36:26.924914 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui Ethernet) Null Informati4
>         0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0030:  0000 0000 0000                           ......
> 11:36:27.636597 4c:69:6e:75:78:20 (oui Unknown) > 6e:20:47:4e:55:2f (oui Unknown), ethertype Unkn 
>         0x0000:  2873 7472 6574 6368 2920 4c69 6e75 7820  (stretch).Linux.
>         0x0010:  352e 342e 302d 7263 362d 3031 3438 312d  5.4.0-rc6-01481-
>         0x0020:  6739 3264 3965 3038 3439 3662 382d 6469  g92d9e08496b8-di
>         0x0030:  7274 7920 2333 2053 756e 204e 6f76 2031  rty.#3.Sun.Nov.1
>         0x0040:  3020 3136 3a31 373a 3531 2043 5354 2032  0.16:17:51.CST.2
>         0x0050:  3031 3920 6172 6d76 376c 0e04 009c 0080  019.armv7l......
>         0x0060:  100c 0501 0a00 000e 0200 0000 0200 1018  ................
>         0x0070:  1102 fe80 0000 0000 0000 eefa aaff fe01  ................
>         0x0080:  12fe 0200 0000 0200 0804 6574 6830 fe09  ..........eth0..
>         0x0090:  0012 0f03 0100 0000 00fe 0900 120f 0103  ................
>         0x00a0:  ec00 0010 0000 e3ed 5509 0000 0000 0000  ........U.......
>         0x00b0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00c0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00d0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00e0:  0000 0000 0000
> 
> This actually looks like random kernel memory.
> 
>      Andrew

Thanks
/Ilias
