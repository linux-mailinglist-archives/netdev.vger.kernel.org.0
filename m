Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB8230CAB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgG1OtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 10:49:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730335AbgG1OtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 10:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595947748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G61YfqunjV0jTuV2DAMclXYHXLXrDV49YMkHRTR6IRU=;
        b=EkLD785hob6XeMl4zawSPGroG5ncFpOvWMsVRWGWdUGHZHsJouJnLcUhHmT6FVXFebe7vt
        6XsCkLc0XWNtI0FoPg8SCOYCBjPLTpqNKR0+FiB/z02ET1wvdwyb5OTX9dHxkwfykCi1xg
        YbkFp/AnUF+cIQ95nmu+tT0zEwgqp20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-CFcs_dBQM-Wtwa4WkzLriA-1; Tue, 28 Jul 2020 10:49:04 -0400
X-MC-Unique: CFcs_dBQM-Wtwa4WkzLriA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAF1758;
        Tue, 28 Jul 2020 14:49:02 +0000 (UTC)
Received: from carbon (unknown [10.40.208.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF48712E8;
        Tue, 28 Jul 2020 14:48:53 +0000 (UTC)
Date:   Tue, 28 Jul 2020 16:48:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [RFC net-next 00/22] Introduce mb bit in xdp_buff/xdp_frame
Message-ID: <20200728164852.76305a12@carbon>
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 13:42:12 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
> if shared_info area has been properly initialized for non-linear
> xdp buffers.
> Initialize mb to 0 for all xdp drivers

It is nice to see that we have some many XDP drivers, but 20 separate
patches for drivers is a bit much.  Perhaps we can do all the drivers
in one patch? What do others think?

> Lorenzo Bianconi (22):
>   xdp: introduce mb in xdp_buff/xdp_frame
>   xdp: initialize xdp_buff mb bit to 0 in netif_receive_generic_xdp
>   net: virtio_net: initialize mb bit of xdp_buff to 0
>   net: xen-netfront: initialize mb bit of xdp_buff to 0
>   net: veth: initialize mb bit of xdp_buff to 0
>   net: hv_netvsc: initialize mb bit of xdp_buff to 0
>   net: bnxt: initialize mb bit in xdp_buff to 0
>   net: dpaa2: initialize mb bit in xdp_buff to 0
>   net: ti: initialize mb bit in xdp_buff to 0
>   net: nfp: initialize mb bit in xdp_buff to 0
>   net: mvpp2: initialize mb bit in xdp_buff to 0
>   net: sfc: initialize mb bit in xdp_buff to 0
>   net: qede: initialize mb bit in xdp_buff to 0
>   net: amazon: ena: initialize mb bit in xdp_buff to 0
>   net: cavium: thunder: initialize mb bit in xdp_buff to 0
>   net: socionext: initialize mb bit in xdp_buff to 0
>   net: tun: initialize mb bit in xdp_buff to 0
>   net: ixgbe: initialize mb bit in xdp_buff to 0
>   net: ice: initialize mb bit in xdp_buff to 0
>   net: i40e: initialize mb bit in xdp_buff to 0
>   net: mlx5: initialize mb bit in xdp_buff to 0
>   net: mlx4: initialize mb bit in xdp_buff to 0
>
>  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 1 +
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 1 +
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c           | 1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 1 +
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 1 +

I see that mvneta is missing, but maybe it is doing another kind of
init of struct xdp_buff?

>  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 1 +
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
>  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 1 +
>  drivers/net/ethernet/sfc/rx.c                       | 1 +
>  drivers/net/ethernet/socionext/netsec.c             | 1 +
>  drivers/net/ethernet/ti/cpsw.c                      | 1 +
>  drivers/net/ethernet/ti/cpsw_new.c                  | 1 +
>  drivers/net/hyperv/netvsc_bpf.c                     | 1 +
>  drivers/net/tun.c                                   | 2 ++
>  drivers/net/veth.c                                  | 1 +
>  drivers/net/virtio_net.c                            | 2 ++
>  drivers/net/xen-netfront.c                          | 1 +
>  include/net/xdp.h                                   | 8 ++++++--
>  net/core/dev.c                                      | 1 +
>  24 files changed, 31 insertions(+), 2 deletions(-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

