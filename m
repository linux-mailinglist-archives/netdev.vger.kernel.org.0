Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8D42CECB2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbgLDLEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgLDLEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:04:23 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87DFC061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 03:03:42 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id 81so5300210ioc.13
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Jv+nYTl5ucMhc3yA6kiS/0QAXOSLESFYDG8UMjys/k=;
        b=sLB3YmNMRt3awTg7ukKbVbdpZyMROx24h6agCLHNLgCMHx1z9CV5+1j1ie4wdKy4Dm
         nUQrqdxR+Ui9ecQ8J6mG7Eh1gPak5lyFkk/CprpTqaM0OGphhY+3C7sD6ak1633s0+LF
         2W2/yWRTGNWJ9reYjAfwEDhl+BofuW8P4fDpKfOtC2jDW0saZWfxuHK7F9EEwiH9esq2
         JzIHIU93bKHRIIDw2bILPfLKrf8Ca3Nx2f7AEGN+2Nk89+bs4W/ZZy1peBALpO0OIHWk
         0CFtu6IRMIBq8thyIhC+JDWibZLlRPi1g0Q3z3Y3zGHPEeEr+t4D06WPFSqiZ281PUM0
         76CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Jv+nYTl5ucMhc3yA6kiS/0QAXOSLESFYDG8UMjys/k=;
        b=j/9TYoyoNnd6M7X4EJfXBumd1QAoc4G87W7C7d82cp+M4kRNEHR4nBcNSNq/GllAWd
         mt6HN/GdfId3156nxlBcuxetfZKSt9AmONCO4S7yvl74E/X9dzkGxfPc4wgvcRYUNRGo
         8JEsi6bSPGYwJBwnpCDa64FaAbK81v1Byz5sReZADOSqGOSngLdCNahO+Wji/cj/22HJ
         PBbCTwzh6pPETqMJZhh1VxQu4VO6tc/wPH8+Kk335xoOLcBzA9EZ7YVENaE6wWIUlzgp
         8WgnwU1qzqoR36stdT8tdn+F6B9rZYbFb9UwR+QgwWoifv9qPnrojICjE85NyZCONprA
         XBZA==
X-Gm-Message-State: AOAM5317z05ikUSObqUwRRQDc/05IDzIrmdKkfM8lKTbZYuaIlj4bw4c
        MSTWqcliU9S3VwjkrDO2qP6W7Q==
X-Google-Smtp-Source: ABdhPJxFzHB0Xqk/E6O4AEodvWZzmDBjxeT4tcuhxMAMKl9TKWt2uyxgf2393QWwOJ3cZv7SLvfmVA==
X-Received: by 2002:a02:7650:: with SMTP id z77mr5628861jab.134.1607079822008;
        Fri, 04 Dec 2020 03:03:42 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id x5sm1447299ilm.22.2020.12.04.03.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:03:41 -0800 (PST)
Date:   Fri, 4 Dec 2020 12:03:32 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH] ethernet: select CONFIG_CRC32 as needed
Message-ID: <20201204110331.GA21587@netronome.com>
References: <20201203232114.1485603-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203232114.1485603-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:20:37AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of ethernet drivers require crc32 functionality to be
> avaialable in the kernel, causing a link error otherwise:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/agere/et131x.o: in function `et1310_setup_device_for_multicast':
> et131x.c:(.text+0x5918): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/cadence/macb_main.o: in function `macb_start_xmit':
> macb_main.c:(.text+0x4b88): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/faraday/ftgmac100.o: in function `ftgmac100_set_rx_mode':
> ftgmac100.c:(.text+0x2b38): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fec_main.o: in function `set_multicast_list':
> fec_main.c:(.text+0x6120): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fman/fman_dtsec.o: in function `dtsec_add_hash_mac_address':
> fman_dtsec.c:(.text+0x830): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fman/fman_dtsec.o:fman_dtsec.c:(.text+0xb68): more undefined references to `crc32_le' follow
> arm-linux-gnueabi-ld: drivers/net/ethernet/netronome/nfp/nfpcore/nfp_hwinfo.o: in function `nfp_hwinfo_read':
> nfp_hwinfo.c:(.text+0x250): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_hwinfo.c:(.text+0x288): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.o: in function `nfp_resource_acquire':
> nfp_resource.c:(.text+0x144): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_resource.c:(.text+0x158): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/nxp/lpc_eth.o: in function `lpc_eth_set_multicast_list':
> lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_flow_tbl_do':
> rocker_ofdpa.c:(.text+0x2e08): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_flow_tbl_del':
> rocker_ofdpa.c:(.text+0x3074): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_port_fdb':
> arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.o: in function `mlx5dr_ste_calc_hash_index':
> dr_ste.c:(.text+0x354): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/microchip/lan743x_main.o: in function `lan743x_netdev_set_multicast':
> lan743x_main.c:(.text+0x5dc4): undefined reference to `crc32_le'
> 
> Add the missing 'select CRC32' entries in Kconfig for each of them.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/agere/Kconfig              | 1 +
>  drivers/net/ethernet/cadence/Kconfig            | 1 +
>  drivers/net/ethernet/faraday/Kconfig            | 1 +
>  drivers/net/ethernet/freescale/Kconfig          | 1 +
>  drivers/net/ethernet/freescale/fman/Kconfig     | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  drivers/net/ethernet/microchip/Kconfig          | 1 +
>  drivers/net/ethernet/netronome/Kconfig          | 1 +
>  drivers/net/ethernet/nxp/Kconfig                | 1 +
>  drivers/net/ethernet/rocker/Kconfig             | 1 +
>  10 files changed, 10 insertions(+)

Hi Arnd,

I'm slightly curious to know how you configured the kernel to build
the Netronome NFP driver but not CRC32 but nonetheless I have no
objection to this change.

For the Netronome portion:

Acked-by: Simon Horman <simon.horman@netronome.com>
