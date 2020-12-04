Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864682CEB40
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgLDJoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDJoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:44:16 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4E6C061A4F;
        Fri,  4 Dec 2020 01:43:35 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r3so4669595wrt.2;
        Fri, 04 Dec 2020 01:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=MjqjECPeOH2m0iAxDctLXcUNw5RcIYEsTXl8EIb+gZY=;
        b=qOS3L9ocGEhG1+ifZHBITCgl+Qej21GCcB+JCclNZbP7GUM5r13hGAWwtnBn7z2QsW
         4Tmb7wKn4x3RySFfbFZrVAt5n43BFN7gM3w5tB/R0xsKzcr4hiJ9MFmJPg9gHck7Csu2
         hNl9iocszISKLY5jADOfBOIsylWfdj0fH6veEqqyrlXoJEPoqVKegwO+4uVS0lk4BlJs
         I8XAtAUWlqSy8jOIJ9WUnmYEwN3WtJPuASGaj42zxGVspGJKYjSVbG+/EQmGPKVZi7j3
         Zh+txVDyoTCt74IMigr9fmAFxVxrtC85qElAotn54kxD1fueH6h6N0X8L4EfSbzxZ382
         34bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MjqjECPeOH2m0iAxDctLXcUNw5RcIYEsTXl8EIb+gZY=;
        b=smCyJAvcZRyppDasyiAsTRRQ2Tv3ugQohxISh1Voucrvw03/un5l+CFxBmp60XwWKa
         GlZ819l8BLWdichP7pJ80UxxC4kiOx/9S3E8y4WZv6mmRqKMVr8L6GbrbZbByBCXjhIw
         qPfqtVMx3DVHS3n39WLLK40UkuatarsMe2mnwRq27l9YEiXwufzZi/FQdq/C6MTrMiCT
         Lgo8VK2IqVu1xgu4Azxq0SZPb9XbkR6eRU2rwCfVXvvvRMbwChsDVckVQbgO0lZ+GNNI
         zRahxcNj1ehJRjYRVRGVwWLMeCzjO1/G2U17iDlFVq9e5Mz+EIPmub7whAidv6IQJZE2
         YS+Q==
X-Gm-Message-State: AOAM532+x82H5A+t6VobQ+zQWNrwSvPYeRkKu6F8z+5hiJsuJi2EcplL
        Kj4nh7zXuVszoi8Ttn+2fgE=
X-Google-Smtp-Source: ABdhPJzncTngv/sB2oooIknou+Rx9IueAWksmTMW8Mo7ghBaoUBuv89giU0hchvNMea0VZ8pSVEaNw==
X-Received: by 2002:adf:e6cf:: with SMTP id y15mr3873613wrm.403.1607075014510;
        Fri, 04 Dec 2020 01:43:34 -0800 (PST)
Received: from einonmac.psycm.cf.ac.uk (81.91.2.81.in-addr.arpa. [81.2.91.81])
        by smtp.googlemail.com with ESMTPSA id z140sm2565028wmc.30.2020.12.04.01.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:43:33 -0800 (PST)
Message-ID: <0ad0411ff960078e599bd2da9a1a0309d55e31b4.camel@gmail.com>
Subject: Re: [PATCH] ethernet: select CONFIG_CRC32 as needed
From:   Mark Einon <mark.einon@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com
Date:   Fri, 04 Dec 2020 09:43:32 +0000
In-Reply-To: <20201203232114.1485603-1-arnd@kernel.org>
References: <20201203232114.1485603-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 00:20 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of ethernet drivers require crc32 functionality to be
> avaialable in the kernel, causing a link error otherwise:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/agere/et131x.o: in function
> `et1310_setup_device_for_multicast':
> et131x.c:(.text+0x5918): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/cadence/macb_main.o: in
> function `macb_start_xmit':
> macb_main.c:(.text+0x4b88): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/faraday/ftgmac100.o: in
> function `ftgmac100_set_rx_mode':
> ftgmac100.c:(.text+0x2b38): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fec_main.o: in
> function `set_multicast_list':
> fec_main.c:(.text+0x6120): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/freescale/fman/fman_dtsec.o: in function
> `dtsec_add_hash_mac_address':
> fman_dtsec.c:(.text+0x830): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/freescale/fman/fman_dtsec.o:fman_dtsec.c:(.text+0
> xb68): more undefined references to `crc32_le' follow
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_hwinfo.o: in function
> `nfp_hwinfo_read':
> nfp_hwinfo.c:(.text+0x250): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_hwinfo.c:(.text+0x288): undefined reference
> to `crc32_be'
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.o: in function
> `nfp_resource_acquire':
> nfp_resource.c:(.text+0x144): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_resource.c:(.text+0x158): undefined
> reference to `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/nxp/lpc_eth.o: in function
> `lpc_eth_set_multicast_list':
> lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_flow_tbl_do':
> rocker_ofdpa.c:(.text+0x2e08): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_flow_tbl_del':
> rocker_ofdpa.c:(.text+0x3074): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_port_fdb':
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.o: in function
> `mlx5dr_ste_calc_hash_index':
> dr_ste.c:(.text+0x354): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/microchip/lan743x_main.o:
> in function `lan743x_netdev_set_multicast':
> lan743x_main.c:(.text+0x5dc4): undefined reference to `crc32_le'
> 
> Add the missing 'select CRC32' entries in Kconfig for each of them.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/agere/Kconfig              | 1 +
>  drivers/net/ethernet/cadence/Kconfig            | 1 +
>  drivers/net/ethernet/faraday/Kconfig            | 1 +
>  drivers/net/ethernet/freescale/Kconfig          | 1 +
>  drivers/net/ethernet/freescale/fman/Kconfig     | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  drivers/net/ethernet/microchip/Kconfig          | 1 +
>  drivers/net/ethernet/netronome/Kconfig          | 1 +
>  drivers/net/ethernet/nxp/Kconfig                | 1 +
>  drivers/net/ethernet/rocker/Kconfig             | 1 +
>  10 files changed, 10 insertions(+)

For the Agere et131x driver:

Acked-by: Mark Einon <mark.einon@gmail.com>

