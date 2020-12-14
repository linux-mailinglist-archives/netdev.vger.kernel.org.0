Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D62D9B1C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391302AbgLNPde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbgLNPdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:33:25 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC53C0613D3;
        Mon, 14 Dec 2020 07:32:44 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id q18so9327061wrn.1;
        Mon, 14 Dec 2020 07:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t9tfHZ7qzv0OG/aI1UXzHdYUmhcbXBLi/GRcSGPa9Wc=;
        b=iYOxyLJVyDzZX0c1YMNrCpBp30Iorl5Ol3ys7Ksn8B93k2VnoNOlWDOabq/KgVH+Gf
         Ao7qs3tuCMdgydjqrBsH7QKC5UCfzaP2Z6HSuz1YyiAosPXhU4MmlZK8mRUS68yUefPv
         k4mi4146FHAU1LHAbUW3rGleJOQg/enqCxLYVikgwhAeWcZr1//dyw9+Xj8o3783VBIC
         3viYxEFLMSfcgsWKWP3fvRYCELONM4RV/2VYKI7lBwXChAqNSDUIMeoqdKUz5gpQ3mpD
         Lopj/t2UaJZNgYnaiVO02WDLTzlF5O1BcRAXOkFIPv+VUXL09RY/bTb7IyQ8mnklUVfK
         qJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=t9tfHZ7qzv0OG/aI1UXzHdYUmhcbXBLi/GRcSGPa9Wc=;
        b=p1oXsBUwFidG3rKh93M3UELpSmT6yO3bR7AxIz4HQ1VBASb1arClN1SWrEz4ie9UhM
         klHTRRBtrayEdqyEg0VIu7os9Hp+dFdZvPvRXWx/kM6eIu6uBLKBACeEbYG1Ye1J1RIj
         CJY3h0FFg5oTD7tzJf1i4wM/cS+odFBjPesS3QBqeameI2411RAxYsqGd05Hi+3+4PEU
         3z/RFagFiqmaF3t2gNLjLBjELlsqPp+PwzkZuCQGI7bBoUw1oG5L0Z7hq1O31auRgcMH
         4w+NdF5+W9xAszuUEbp007naBuBPlx6jhxDC6XDM/iipXgRBKwOipe1hjqvKMz6ZKXnD
         RByw==
X-Gm-Message-State: AOAM531CEPyEpVbtVkpGsd0vxplgwyg6hJ4lnK3mOYE5dE5Aqlr/nqJe
        gc5jABnbhs+g+koKa58j1iw=
X-Google-Smtp-Source: ABdhPJxMPxWHSILIf1tihFx1amtA3y1le8Lipj7tRwaYG4UGBHtDYnlx6dlIbh9DpGEkgoLVcEUATQ==
X-Received: by 2002:a5d:4682:: with SMTP id u2mr29265881wrq.265.1607959963458;
        Mon, 14 Dec 2020 07:32:43 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id s13sm31789724wrt.80.2020.12.14.07.32.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 07:32:42 -0800 (PST)
Date:   Mon, 14 Dec 2020 15:32:35 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        alexander.duyck@gmail.com, maciej.fijalkowski@intel.com,
        saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Message-ID: <20201214153235.s3dpayxpo7xnfqdk@gmail.com>
Mail-Followup-To: Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        alexander.duyck@gmail.com, maciej.fijalkowski@intel.com,
        saeed@kernel.org
References: <cover.1607794551.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1607794551.git.lorenzo@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 06:41:47PM +0100, Lorenzo Bianconi wrote:
> Introduce xdp_init_buff and xdp_prepare_buff utility routines to initialize
> xdp_buff data structure and remove duplicated code in all XDP capable
> drivers.
> 
> Changes since v2:
> - precompute xdp->data as hard_start + headroom and save it in a local
>   variable to reuse it for xdp->data_end and xdp->data_meta in
>   xdp_prepare_buff()
> 
> Changes since v1:
> - introduce xdp_prepare_buff utility routine
> 
> Lorenzo Bianconi (2):
>   net: xdp: introduce xdp_init_buff utility routine
>   net: xdp: introduce xdp_prepare_buff utility routine

For changes in drivers/net/ethernet/sfc:

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  8 +++-----
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 ++-----
>  .../net/ethernet/cavium/thunder/nicvf_main.c  | 11 ++++++-----
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 13 +++++--------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 +++++++++---------
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 17 +++++++++--------
>  drivers/net/ethernet/intel/igb/igb_main.c     | 18 +++++++++---------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 +++++++++----------
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 +++++++++----------
>  drivers/net/ethernet/marvell/mvneta.c         |  9 +++------
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++++------
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +++-----
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 ++-----
>  .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    |  7 ++-----
>  drivers/net/ethernet/sfc/rx.c                 |  9 +++------
>  drivers/net/ethernet/socionext/netsec.c       |  8 +++-----
>  drivers/net/ethernet/ti/cpsw.c                | 17 ++++++-----------
>  drivers/net/ethernet/ti/cpsw_new.c            | 17 ++++++-----------
>  drivers/net/hyperv/netvsc_bpf.c               |  7 ++-----
>  drivers/net/tun.c                             | 11 ++++-------
>  drivers/net/veth.c                            | 14 +++++---------
>  drivers/net/virtio_net.c                      | 18 ++++++------------
>  drivers/net/xen-netfront.c                    |  8 +++-----
>  include/net/xdp.h                             | 19 +++++++++++++++++++
>  net/bpf/test_run.c                            |  9 +++------
>  net/core/dev.c                                | 18 ++++++++----------
>  28 files changed, 156 insertions(+), 195 deletions(-)
> 
> -- 
> 2.29.2

-- 
Martin Habets <habetsm.xilinx@gmail.com>
