Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50B72B4277
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgKPLTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgKPLTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:19:13 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A0CC0613CF;
        Mon, 16 Nov 2020 03:19:11 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id y4so12481076edy.5;
        Mon, 16 Nov 2020 03:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6CPIyvD8XjBNQP4xPof1wHbO1v9fKQ05YkxbhaYKQM=;
        b=HG2Xe47Wf2k2l8Y2s2S+VlU1d1DXdhNNUDrhnPRNTfBuQ6AkpKw1F3dsff/B6gdhWi
         6MxYjlTFC1Vqsk35ff40GqJpiEYunxwy2B5v85swi/zNag0kkh1eZZ+tcK9P6uWwAT14
         LsHxCQREPm/t9ShRub/DH25BV0/YlkoaQJ8Pe8VchklX5eN86FlgjTMICHVeWgfLo8/B
         Ym0GCrjXJhvRCqFiJ+NvM+VExx8LqVG20sscfXoLomlE2U2vvjnBXS4PPDCeMYgVMBDa
         UmVxpdwepwnuGTBdjyd/7/69zItZQJ84QVXOg2Uzzke63GX4fUTtAoYm7zSjPSd6i6R9
         q8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6CPIyvD8XjBNQP4xPof1wHbO1v9fKQ05YkxbhaYKQM=;
        b=SfoZ48bpW6rcAJFYR7j0lZrfSabBQzm3WYh9eVAWyGR4o346vYAOLxT/MbUDLodcIw
         PZCFF61/2eEUkMkENrTc+66jktS92Mke1yaiIgsZjgg0YMgCKhwGRHxaW/EvJ1Tei+p7
         Qhq8P0zYDiAS6dz7hXhqya/gdh31ANPSmXBMu8oNYGfBKbS8S0zngcbNLNwWlRqfVWCg
         Hi10s+wu/eLav+R4xBQiGzfUC03hIDihoe8piNhNrpGSmsTL7VyolKeRh0INwpxLsyxC
         Xk40FX6lY0mcxgOYomyDvo7BnH2cQu/sthsDPb47Uj/GrEF67eL8SUq1bmLhMkUD0U1f
         4vgA==
X-Gm-Message-State: AOAM5322XZmj+g//Bnd4+cFIXvPe3kSXMuJtjtyeGwTkBA6UoxDHGmvX
        F5ap7fUwBheGQqZWG5XsYok=
X-Google-Smtp-Source: ABdhPJyq2UQEpY6TJGlJuUZLSFk8enZDbR8NPimsRQcmy2QVwGtO/svDuf9KZEHeN2hYDyMms/WLGg==
X-Received: by 2002:aa7:d14a:: with SMTP id r10mr14869673edo.225.1605525550227;
        Mon, 16 Nov 2020 03:19:10 -0800 (PST)
Received: from [192.168.1.110] ([77.126.113.122])
        by smtp.gmail.com with ESMTPSA id c4sm10375927ejx.9.2020.11.16.03.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:19:09 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 06/10] xsk: propagate napi_id to XDP socket Rx
 path
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        intel-wired-lan@lists.osuosl.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        sgoutham@marvell.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, thomas.petazzoni@bootlin.com,
        mcroce@microsoft.com, saeedm@nvidia.com, tariqt@nvidia.com,
        aelior@marvell.com, ecree@solarflare.com,
        ilias.apalodimas@linaro.org, grygorii.strashko@ti.com,
        sthemmin@microsoft.com, mst@redhat.com, kda@linux-powerpc.org
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
 <20201116110416.10719-7-bjorn.topel@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <b3354ce9-264c-a55b-88c9-95ee93dc959a@gmail.com>
Date:   Mon, 16 Nov 2020 13:19:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116110416.10719-7-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/2020 1:04 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Add napi_id to the xdp_rxq_info structure, and make sure the XDP
> socket pick up the napi_id in the Rx path. The napi_id is used to find
> the corresponding NAPI structure for socket busy polling.
> 
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>   drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
>   .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
>   .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
>   drivers/net/ethernet/intel/ice/ice_base.c     |  4 ++--
>   drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
>   drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
>   .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
>   drivers/net/ethernet/marvell/mvneta.c         |  2 +-
>   .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 ++--
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
>   .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
>   drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
>   drivers/net/ethernet/sfc/rx_common.c          |  2 +-
>   drivers/net/ethernet/socionext/netsec.c       |  2 +-
>   drivers/net/ethernet/ti/cpsw_priv.c           |  2 +-
>   drivers/net/hyperv/netvsc.c                   |  2 +-
>   drivers/net/tun.c                             |  2 +-
>   drivers/net/veth.c                            |  2 +-
>   drivers/net/virtio_net.c                      |  2 +-
>   drivers/net/xen-netfront.c                    |  2 +-
>   include/net/busy_poll.h                       | 19 +++++++++++++++----
>   include/net/xdp.h                             |  3 ++-
>   net/core/dev.c                                |  2 +-
>   net/core/xdp.c                                |  3 ++-
>   net/xdp/xsk.c                                 |  1 +
>   29 files changed, 47 insertions(+), 33 deletions(-)
> 

Acked-by: Tariq Toukan <tariqt@nvidia.com>
For the mlx4/5 parts.

Thanks,
Tariq

