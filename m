Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495C24A4238
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359301AbiAaLLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377540AbiAaLKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:10:11 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E659C06174A
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:08:13 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id w11so24629356wra.4
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=KjCn1FEvG31U+vfeF3uDNukp4t4J8LVZbyDHizrTv/c=;
        b=Ep9cwU7Zo9QA5HaKlcupNyj/opmcWaUvXAl+JXm8ibzpBntvEsbXHh5UeEm66+AHid
         zZFXCK9PpNKb9yS62rcTgJOX1FfwSqCUlm30k0hj1sobvquuDd4FOqH+1Yl6K2IYSmIL
         en6vFZBDsMjUvVdKcxMEIJ7tOellMOHNODHo0SGLEqrueDnst0pr72R1mbjhC3WOHBOR
         1Kr6E8BRMYndRMlJfscqSXaD4EymcCEI82Y/ztBRckGM1BFmKWhozRjGCn7/7sVALBDR
         JeAK39F90G6S2PyFD0Y3wtZKI+PJAqXg4inUPxEkIqdXl8HGQYqRhHlQJgh+T18abDXQ
         nBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=KjCn1FEvG31U+vfeF3uDNukp4t4J8LVZbyDHizrTv/c=;
        b=EXS+VvUjz2WcjwqAGP46n3JVAmqe2njVUQrB1u2J5wYj4li3SvCgHMNtJHzcNE9DrQ
         +At8EtJ2TlXFJ9GxqglqX93g2F5h1grT2I/iquhD3mp4vUXhUvH+Fhiu8/M1H60YWUjt
         AQtSonupQg1TIvsfWP08vGdVwzg+UXVsiXdidZoq3XHfXlDTybxHP+VZI4lC7JoZhUi7
         9aZEOIdpo2oySiGjyBKiYHybps4Yr6KIzqY0ZDSVnrKiiSLLQ7vfOKIwwRwyuYFADvUJ
         wyUNqFEDWnrW1rdPnWRS6zFMHbbHxc0amt7ohaKE+lJmaLNHpGPkDGEvnbIDGtIshohg
         cOQQ==
X-Gm-Message-State: AOAM530iv5vqruDwX3+KYq/YNFVG32dkGXXgoUPbkc2d6z65flTMjEJ7
        vFycmmESv8nvmqEMixXgywA=
X-Google-Smtp-Source: ABdhPJzIr1gf2pQj1scNKZZEi51GEScVBTtWHAfhGm3Uu6zxMSGYZgGem60MWd3tu3KTISauBw2xMQ==
X-Received: by 2002:a05:6000:3c6:: with SMTP id b6mr16956638wrg.12.1643627291776;
        Mon, 31 Jan 2022 03:08:11 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id 44sm11588985wrm.103.2022.01.31.03.08.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 Jan 2022 03:08:10 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:08:05 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Subject: Re: [PATCH net-next] sfc: The size of the RX recycle ring should be
 more flexible
Message-ID: <20220131110805.a3p77a54yjku4r5s@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
 <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
 <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
 <20220102092207.rxz7kpjii4ermnfo@gmail.com>
 <20220110085820.zi73go4etyyrkixr@gmail.com>
 <CACT4ouf+zW_Ey=NvJJrNCQ2q7V4xYnxdH7cX1PQcF9-EE1PP9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6ymahzmprkdpv54f"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4ouf+zW_Ey=NvJJrNCQ2q7V4xYnxdH7cX1PQcF9-EE1PP9w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6ymahzmprkdpv54f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jan 10, 2022 at 10:31:57AM +0100, Íñigo Huguet wrote:
> Hi Martin, thanks for the quick fix.
> 
> On Mon, Jan 10, 2022 at 9:58 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > Ideally the size would depend on the link speed, but the recycle
> > ring is created when the interface is brought up before the driver
> > knows the link speed. So size it for the maximum speed of a given NIC.
> > PowerPC is only supported on SFN7xxx and SFN8xxx NICs.
> >
> > With this patch on a 40G NIC the number of calls to alloc_pages and
> > friends went down from about 18% to under 2%.
> > On a 10G NIC the number of calls to alloc_pages and friends went down
> > from about 15% to 0 (perf did not capture any calls during the 60
> > second test).
> > On a 100G NIC the number of calls to alloc_pages and friends went down
> > from about 23% to 4%.
> 
> Although the problem seemed to be mainly in the case of IOMMU not
> present, this patch also changes the ring size for the IOMMU present
> case, using the same size for both. Have you checked that performance
> is not reduced in the second case?

With the IOMMU enabled calls to __alloc_pages are at a whopping 0.01%.
No change in performance was measured.

Martin

> > Reported-by: Íñigo Huguet <ihuguet@redhat.com>
> > Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> > ---
> >  drivers/net/ethernet/sfc/ef10.c       |   31 +++++++++++++++++++++++++++++++
> >  drivers/net/ethernet/sfc/ef100_nic.c  |    9 +++++++++
> >  drivers/net/ethernet/sfc/net_driver.h |    2 ++
> >  drivers/net/ethernet/sfc/nic_common.h |    5 +++++
> >  drivers/net/ethernet/sfc/rx_common.c  |   18 +-----------------
> >  drivers/net/ethernet/sfc/rx_common.h  |    6 ++++++
> >  drivers/net/ethernet/sfc/siena.c      |    8 ++++++++
> >  7 files changed, 62 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> > index cf366ed2557c..dc3f95503d9c 100644
> > --- a/drivers/net/ethernet/sfc/ef10.c
> > +++ b/drivers/net/ethernet/sfc/ef10.c
> > @@ -3990,6 +3990,35 @@ static unsigned int ef10_check_caps(const struct efx_nic *efx,
> >         }
> >  }
> >
> > +static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
> > +{
> > +       unsigned int ret;
> > +
> > +       /* There is no difference between PFs and VFs. The side is based on
> > +        * the maximum link speed of a given NIC.
> > +        */
> > +       switch (efx->pci_dev->device & 0xfff) {
> > +       case 0x0903:    /* Farmingdale can do up to 10G */
> > +#ifdef CONFIG_PPC64
> > +               ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> > +#else
> > +               ret = EFX_RECYCLE_RING_SIZE_10G;
> > +#endif
> > +               break;
> > +       case 0x0923:    /* Greenport can do up to 40G */
> > +       case 0x0a03:    /* Medford can do up to 40G */
> > +#ifdef CONFIG_PPC64
> > +               ret = 16 * EFX_RECYCLE_RING_SIZE_10G;
> > +#else
> > +               ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> > +#endif
> > +               break;
> > +       default:        /* Medford2 can do up to 100G */
> > +               ret = 10 * EFX_RECYCLE_RING_SIZE_10G;
> > +       }
> > +       return ret;
> > +}
> > +
> >  #define EF10_OFFLOAD_FEATURES          \
> >         (NETIF_F_IP_CSUM |              \
> >          NETIF_F_HW_VLAN_CTAG_FILTER |  \
> > @@ -4106,6 +4135,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
> >         .check_caps = ef10_check_caps,
> >         .print_additional_fwver = efx_ef10_print_additional_fwver,
> >         .sensor_event = efx_mcdi_sensor_event,
> > +       .rx_recycle_ring_size = efx_ef10_recycle_ring_size,
> >  };
> >
> >  const struct efx_nic_type efx_hunt_a0_nic_type = {
> > @@ -4243,4 +4273,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
> >         .check_caps = ef10_check_caps,
> >         .print_additional_fwver = efx_ef10_print_additional_fwver,
> >         .sensor_event = efx_mcdi_sensor_event,
> > +       .rx_recycle_ring_size = efx_ef10_recycle_ring_size,
> >  };
> > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > index f79b14a119ae..a07cbf45a326 100644
> > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > @@ -23,6 +23,7 @@
> >  #include "ef100_rx.h"
> >  #include "ef100_tx.h"
> >  #include "ef100_netdev.h"
> > +#include "rx_common.h"
> >
> >  #define EF100_MAX_VIS 4096
> >  #define EF100_NUM_MCDI_BUFFERS 1
> > @@ -696,6 +697,12 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
> >         }
> >  }
> >
> > +static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
> > +{
> > +       /* Maximum link speed for Riverhead is 100G */
> > +       return 10 * EFX_RECYCLE_RING_SIZE_10G;
> > +}
> > +
> >  /*     NIC level access functions
> >   */
> >  #define EF100_OFFLOAD_FEATURES (NETIF_F_HW_CSUM | NETIF_F_RXCSUM |     \
> > @@ -770,6 +777,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
> >         .rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
> >         .rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
> >         .rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
> > +       .rx_recycle_ring_size = efx_ef100_recycle_ring_size,
> >
> >         .reconfigure_mac = ef100_reconfigure_mac,
> >         .reconfigure_port = efx_mcdi_port_reconfigure,
> > @@ -849,6 +857,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
> >         .rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
> >         .rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
> >         .rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
> > +       .rx_recycle_ring_size = efx_ef100_recycle_ring_size,
> >
> >         .reconfigure_mac = ef100_reconfigure_mac,
> >         .test_nvram = efx_new_mcdi_nvram_test_all,
> > diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> > index cc15ee8812d9..c75dc75e2857 100644
> > --- a/drivers/net/ethernet/sfc/net_driver.h
> > +++ b/drivers/net/ethernet/sfc/net_driver.h
> > @@ -1282,6 +1282,7 @@ struct efx_udp_tunnel {
> >   * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
> >   * @print_additional_fwver: Dump NIC-specific additional FW version info
> >   * @sensor_event: Handle a sensor event from MCDI
> > + * @rx_recycle_ring_size: Size of the RX recycle ring
> >   * @revision: Hardware architecture revision
> >   * @txd_ptr_tbl_base: TX descriptor ring base address
> >   * @rxd_ptr_tbl_base: RX descriptor ring base address
> > @@ -1460,6 +1461,7 @@ struct efx_nic_type {
> >         size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
> >                                          size_t len);
> >         void (*sensor_event)(struct efx_nic *efx, efx_qword_t *ev);
> > +       unsigned int (*rx_recycle_ring_size)(const struct efx_nic *efx);
> >
> >         int revision;
> >         unsigned int txd_ptr_tbl_base;
> > diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
> > index b9cafe9cd568..0cef35c0c559 100644
> > --- a/drivers/net/ethernet/sfc/nic_common.h
> > +++ b/drivers/net/ethernet/sfc/nic_common.h
> > @@ -195,6 +195,11 @@ static inline void efx_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
> >                 efx->type->sensor_event(efx, ev);
> >  }
> >
> > +static inline unsigned int efx_rx_recycle_ring_size(const struct efx_nic *efx)
> > +{
> > +       return efx->type->rx_recycle_ring_size(efx);
> > +}
> > +
> >  /* Some statistics are computed as A - B where A and B each increase
> >   * linearly with some hardware counter(s) and the counters are read
> >   * asynchronously.  If the counters contributing to B are always read
> > diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> > index 633ca77a26fd..1b22c7be0088 100644
> > --- a/drivers/net/ethernet/sfc/rx_common.c
> > +++ b/drivers/net/ethernet/sfc/rx_common.c
> > @@ -23,13 +23,6 @@ module_param(rx_refill_threshold, uint, 0444);
> >  MODULE_PARM_DESC(rx_refill_threshold,
> >                  "RX descriptor ring refill threshold (%)");
> >
> > -/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
> > - * ring, this number is divided by the number of buffers per page to calculate
> > - * the number of pages to store in the RX page recycle ring.
> > - */
> > -#define EFX_RECYCLE_RING_SIZE_IOMMU 4096
> > -#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
> > -
> >  /* RX maximum head room required.
> >   *
> >   * This must be at least 1 to prevent overflow, plus one packet-worth
> > @@ -141,16 +134,7 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
> >         unsigned int bufs_in_recycle_ring, page_ring_size;
> >         struct efx_nic *efx = rx_queue->efx;
> >
> > -       /* Set the RX recycle ring size */
> > -#ifdef CONFIG_PPC64
> > -       bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
> > -#else
> > -       if (iommu_present(&pci_bus_type))
> > -               bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
> > -       else
> > -               bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_NOIOMMU;
> > -#endif /* CONFIG_PPC64 */
> > -
> > +       bufs_in_recycle_ring = efx_rx_recycle_ring_size(efx);
> >         page_ring_size = roundup_pow_of_two(bufs_in_recycle_ring /
> >                                             efx->rx_bufs_per_page);
> >         rx_queue->page_ring = kcalloc(page_ring_size,
> > diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
> > index 207ccd8ba062..fbd2769307f9 100644
> > --- a/drivers/net/ethernet/sfc/rx_common.h
> > +++ b/drivers/net/ethernet/sfc/rx_common.h
> > @@ -18,6 +18,12 @@
> >  #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
> >                                       EFX_RX_USR_BUF_SIZE)
> >
> > +/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
> > + * ring, this number is divided by the number of buffers per page to calculate
> > + * the number of pages to store in the RX page recycle ring.
> > + */
> > +#define EFX_RECYCLE_RING_SIZE_10G      256
> > +
> >  static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
> >  {
> >         return page_address(buf->page) + buf->page_offset;
> > diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
> > index 16347a6d0c47..ce3060e15b54 100644
> > --- a/drivers/net/ethernet/sfc/siena.c
> > +++ b/drivers/net/ethernet/sfc/siena.c
> > @@ -25,6 +25,7 @@
> >  #include "mcdi_port_common.h"
> >  #include "selftest.h"
> >  #include "siena_sriov.h"
> > +#include "rx_common.h"
> >
> >  /* Hardware control for SFC9000 family including SFL9021 (aka Siena). */
> >
> > @@ -958,6 +959,12 @@ static unsigned int siena_check_caps(const struct efx_nic *efx,
> >         return 0;
> >  }
> >
> > +static unsigned int efx_siena_recycle_ring_size(const struct efx_nic *efx)
> > +{
> > +       /* Maximum link speed is 10G */
> > +       return EFX_RECYCLE_RING_SIZE_10G;
> > +}
> > +
> >  /**************************************************************************
> >   *
> >   * Revision-dependent attributes used by efx.c and nic.c
> > @@ -1098,4 +1105,5 @@ const struct efx_nic_type siena_a0_nic_type = {
> >         .rx_hash_key_size = 16,
> >         .check_caps = siena_check_caps,
> >         .sensor_event = efx_mcdi_sensor_event,
> > +       .rx_recycle_ring_size = efx_siena_recycle_ring_size,
> >  };
> >
> 
> 
> -- 
> Íñigo Huguet

--6ymahzmprkdpv54f
Content-Type: image/svg+xml
Content-Disposition: attachment; filename="receive-flamegraph.svg"
Content-Transfer-Encoding: quoted-printable

<?xml version=3D"1.0" standalone=3D"no"?>=0A<!DOCTYPE svg PUBLIC "-//W3C//D=
TD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">=0A<svg =
version=3D"1.1" width=3D"1200" height=3D"790" onload=3D"init(evt)" viewBox=
=3D"0 0 1200 790" xmlns=3D"http://www.w3.org/2000/svg" xmlns:xlink=3D"http:=
//www.w3.org/1999/xlink">=0A<!-- Flame graph stack visualization. See https=
://github.com/brendangregg/FlameGraph for latest version, and http://www.br=
endangregg.com/flamegraphs.html for examples. -->=0A<!-- NOTES:  -->=0A<def=
s>=0A	<linearGradient id=3D"background" y1=3D"0" y2=3D"1" x1=3D"0" x2=3D"0"=
 >=0A		<stop stop-color=3D"#eeeeee" offset=3D"5%" />=0A		<stop stop-color=
=3D"#eeeeb0" offset=3D"95%" />=0A	</linearGradient>=0A</defs>=0A<style type=
=3D"text/css">=0A	text { font-family:Verdana; font-size:12px; fill:rgb(0,0,=
0); }=0A	#search, #ignorecase { opacity:0.1; cursor:pointer; }=0A	#search:h=
over, #search.show, #ignorecase:hover, #ignorecase.show { opacity:1; }=0A	#=
subtitle { text-anchor:middle; font-color:rgb(160,160,160); }=0A	#title { t=
ext-anchor:middle; font-size:17px}=0A	#unzoom { cursor:pointer; }=0A	#frame=
s > *:hover { stroke:black; stroke-width:0.5; cursor:pointer; }=0A	.hide { =
display:none; }=0A	.parent { opacity:0.5; }=0A</style>=0A<script type=3D"te=
xt/ecmascript">=0A<![CDATA[=0A	"use strict";=0A	var details, searchbtn, unz=
oombtn, matchedtxt, svg, searching, currentSearchTerm, ignorecase, ignoreca=
seBtn;=0A	function init(evt) {=0A		details =3D document.getElementById("det=
ails").firstChild;=0A		searchbtn =3D document.getElementById("search");=0A	=
	ignorecaseBtn =3D document.getElementById("ignorecase");=0A		unzoombtn =3D=
 document.getElementById("unzoom");=0A		matchedtxt =3D document.getElementB=
yId("matched");=0A		svg =3D document.getElementsByTagName("svg")[0];=0A		se=
arching =3D 0;=0A		currentSearchTerm =3D null;=0A=0A		// use GET parameters=
 to restore a flamegraphs state.=0A		var params =3D get_params();=0A		if (p=
arams.x && params.y)=0A			zoom(find_group(document.querySelector('[x=3D"' +=
 params.x + '"][y=3D"' + params.y + '"]')));=0A                if (params.s=
) search(params.s);=0A	}=0A=0A	// event listeners=0A	window.addEventListene=
r("click", function(e) {=0A		var target =3D find_group(e.target);=0A		if (t=
arget) {=0A			if (target.nodeName =3D=3D "a") {=0A				if (e.ctrlKey =3D=3D=
=3D false) return;=0A				e.preventDefault();=0A			}=0A			if (target.classLi=
st.contains("parent")) unzoom();=0A			zoom(target);=0A			if (!document.quer=
ySelector('.parent')) {=0A				clearzoom();=0A				return;=0A			}=0A=0A			// =
set parameters for zoom state=0A			var el =3D target.querySelector("rect");=
=0A			if (el && el.attributes && el.attributes.y && el.attributes._orig_x) =
{=0A				var params =3D get_params()=0A				params.x =3D el.attributes._orig_=
x.value;=0A				params.y =3D el.attributes.y.value;=0A				history.replaceSta=
te(null, null, parse_params(params));=0A			}=0A		}=0A		else if (e.target.id=
 =3D=3D "unzoom") clearzoom();=0A		else if (e.target.id =3D=3D "search") se=
arch_prompt();=0A		else if (e.target.id =3D=3D "ignorecase") toggle_ignorec=
ase();=0A	}, false)=0A=0A	// mouse-over for info=0A	// show=0A	window.addEv=
entListener("mouseover", function(e) {=0A		var target =3D find_group(e.targ=
et);=0A		if (target) details.nodeValue =3D "Function: " + g_to_text(target)=
;=0A	}, false)=0A=0A	// clear=0A	window.addEventListener("mouseout", functi=
on(e) {=0A		var target =3D find_group(e.target);=0A		if (target) details.no=
deValue =3D ' ';=0A	}, false)=0A=0A	// ctrl-F for search=0A	// ctrl-I to to=
ggle case-sensitive search=0A	window.addEventListener("keydown",function (e=
) {=0A		if (e.keyCode =3D=3D=3D 114 || (e.ctrlKey && e.keyCode =3D=3D=3D 70=
)) {=0A			e.preventDefault();=0A			search_prompt();=0A		}=0A		else if (e.ct=
rlKey && e.keyCode =3D=3D=3D 73) {=0A			e.preventDefault();=0A			toggle_ign=
orecase();=0A		}=0A	}, false)=0A=0A	// functions=0A	function get_params() {=
=0A		var params =3D {};=0A		var paramsarr =3D window.location.search.substr=
(1).split('&');=0A		for (var i =3D 0; i < paramsarr.length; ++i) {=0A			var=
 tmp =3D paramsarr[i].split("=3D");=0A			if (!tmp[0] || !tmp[1]) continue;=
=0A			params[tmp[0]]  =3D decodeURIComponent(tmp[1]);=0A		}=0A		return para=
ms;=0A	}=0A	function parse_params(params) {=0A		var uri =3D "?";=0A		for (v=
ar key in params) {=0A			uri +=3D key + '=3D' + encodeURIComponent(params[k=
ey]) + '&';=0A		}=0A		if (uri.slice(-1) =3D=3D "&")=0A			uri =3D uri.substr=
ing(0, uri.length - 1);=0A		if (uri =3D=3D '?')=0A			uri =3D window.locatio=
n.href.split('?')[0];=0A		return uri;=0A	}=0A	function find_child(node, sel=
ector) {=0A		var children =3D node.querySelectorAll(selector);=0A		if (chil=
dren.length) return children[0];=0A	}=0A	function find_group(node) {=0A		va=
r parent =3D node.parentElement;=0A		if (!parent) return;=0A		if (parent.id=
 =3D=3D "frames") return node;=0A		return find_group(parent);=0A	}=0A	funct=
ion orig_save(e, attr, val) {=0A		if (e.attributes["_orig_" + attr] !=3D un=
defined) return;=0A		if (e.attributes[attr] =3D=3D undefined) return;=0A		i=
f (val =3D=3D undefined) val =3D e.attributes[attr].value;=0A		e.setAttribu=
te("_orig_" + attr, val);=0A	}=0A	function orig_load(e, attr) {=0A		if (e.a=
ttributes["_orig_"+attr] =3D=3D undefined) return;=0A		e.attributes[attr].v=
alue =3D e.attributes["_orig_" + attr].value;=0A		e.removeAttribute("_orig_=
"+attr);=0A	}=0A	function g_to_text(e) {=0A		var text =3D find_child(e, "ti=
tle").firstChild.nodeValue;=0A		return (text)=0A	}=0A	function g_to_func(e)=
 {=0A		var func =3D g_to_text(e);=0A		// if there's any manipulation we wan=
t to do to the function=0A		// name before it's searched, do it here before=
 returning.=0A		return (func);=0A	}=0A	function update_text(e) {=0A		var r =
=3D find_child(e, "rect");=0A		var t =3D find_child(e, "text");=0A		var w =
=3D parseFloat(r.attributes.width.value) -3;=0A		var txt =3D find_child(e, =
"title").textContent.replace(/\([^(]*\)$/,"");=0A		t.attributes.x.value =3D=
 parseFloat(r.attributes.x.value) + 3;=0A=0A		// Smaller than this size won=
't fit anything=0A		if (w < 2 * 12 * 0.59) {=0A			t.textContent =3D "";=0A	=
		return;=0A		}=0A=0A		t.textContent =3D txt;=0A		// Fit in full text width=
=0A		if (/^ *$/.test(txt) || t.getSubStringLength(0, txt.length) < w)=0A			=
return;=0A=0A		for (var x =3D txt.length - 2; x > 0; x--) {=0A			if (t.getS=
ubStringLength(0, x + 2) <=3D w) {=0A				t.textContent =3D txt.substring(0,=
 x) + "..";=0A				return;=0A			}=0A		}=0A		t.textContent =3D "";=0A	}=0A=0A=
	// zoom=0A	function zoom_reset(e) {=0A		if (e.attributes !=3D undefined) {=
=0A			orig_load(e, "x");=0A			orig_load(e, "width");=0A		}=0A		if (e.childN=
odes =3D=3D undefined) return;=0A		for (var i =3D 0, c =3D e.childNodes; i =
< c.length; i++) {=0A			zoom_reset(c[i]);=0A		}=0A	}=0A	function zoom_child=
(e, x, ratio) {=0A		if (e.attributes !=3D undefined) {=0A			if (e.attribute=
s.x !=3D undefined) {=0A				orig_save(e, "x");=0A				e.attributes.x.value =
=3D (parseFloat(e.attributes.x.value) - x - 10) * ratio + 10;=0A				if (e.t=
agName =3D=3D "text")=0A					e.attributes.x.value =3D find_child(e.parentNo=
de, "rect[x]").attributes.x.value + 3;=0A			}=0A			if (e.attributes.width !=
=3D undefined) {=0A				orig_save(e, "width");=0A				e.attributes.width.valu=
e =3D parseFloat(e.attributes.width.value) * ratio;=0A			}=0A		}=0A=0A		if =
(e.childNodes =3D=3D undefined) return;=0A		for (var i =3D 0, c =3D e.child=
Nodes; i < c.length; i++) {=0A			zoom_child(c[i], x - 10, ratio);=0A		}=0A	=
}=0A	function zoom_parent(e) {=0A		if (e.attributes) {=0A			if (e.attribute=
s.x !=3D undefined) {=0A				orig_save(e, "x");=0A				e.attributes.x.value =
=3D 10;=0A			}=0A			if (e.attributes.width !=3D undefined) {=0A				orig_sav=
e(e, "width");=0A				e.attributes.width.value =3D parseInt(svg.width.baseVa=
l.value) - (10 * 2);=0A			}=0A		}=0A		if (e.childNodes =3D=3D undefined) re=
turn;=0A		for (var i =3D 0, c =3D e.childNodes; i < c.length; i++) {=0A			z=
oom_parent(c[i]);=0A		}=0A	}=0A	function zoom(node) {=0A		var attr =3D find=
_child(node, "rect").attributes;=0A		var width =3D parseFloat(attr.width.va=
lue);=0A		var xmin =3D parseFloat(attr.x.value);=0A		var xmax =3D parseFloa=
t(xmin + width);=0A		var ymin =3D parseFloat(attr.y.value);=0A		var ratio =
=3D (svg.width.baseVal.value - 2 * 10) / width;=0A=0A		// XXX: Workaround f=
or JavaScript float issues (fix me)=0A		var fudge =3D 0.0001;=0A=0A		unzoom=
btn.classList.remove("hide");=0A=0A		var el =3D document.getElementById("fr=
ames").children;=0A		for (var i =3D 0; i < el.length; i++) {=0A			var e =3D=
 el[i];=0A			var a =3D find_child(e, "rect").attributes;=0A			var ex =3D pa=
rseFloat(a.x.value);=0A			var ew =3D parseFloat(a.width.value);=0A			var up=
stack;=0A			// Is it an ancestor=0A			if (0 =3D=3D 0) {=0A				upstack =3D p=
arseFloat(a.y.value) > ymin;=0A			} else {=0A				upstack =3D parseFloat(a.y=
=2Evalue) < ymin;=0A			}=0A			if (upstack) {=0A				// Direct ancestor=0A			=
	if (ex <=3D xmin && (ex+ew+fudge) >=3D xmax) {=0A					e.classList.add("par=
ent");=0A					zoom_parent(e);=0A					update_text(e);=0A				}=0A				// not i=
n current path=0A				else=0A					e.classList.add("hide");=0A			}=0A			// Ch=
ildren maybe=0A			else {=0A				// no common path=0A				if (ex < xmin || ex =
+ fudge >=3D xmax) {=0A					e.classList.add("hide");=0A				}=0A				else {=
=0A					zoom_child(e, xmin, ratio);=0A					update_text(e);=0A				}=0A			}=
=0A		}=0A		search();=0A	}=0A	function unzoom() {=0A		unzoombtn.classList.ad=
d("hide");=0A		var el =3D document.getElementById("frames").children;=0A		f=
or(var i =3D 0; i < el.length; i++) {=0A			el[i].classList.remove("parent")=
;=0A			el[i].classList.remove("hide");=0A			zoom_reset(el[i]);=0A			update_=
text(el[i]);=0A		}=0A		search();=0A	}=0A	function clearzoom() {=0A		unzoom(=
);=0A=0A		// remove zoom state=0A		var params =3D get_params();=0A		if (par=
ams.x) delete params.x;=0A		if (params.y) delete params.y;=0A		history.repl=
aceState(null, null, parse_params(params));=0A	}=0A=0A	// search=0A	functio=
n toggle_ignorecase() {=0A		ignorecase =3D !ignorecase;=0A		if (ignorecase)=
 {=0A			ignorecaseBtn.classList.add("show");=0A		} else {=0A			ignorecaseBt=
n.classList.remove("show");=0A		}=0A		reset_search();=0A		search();=0A	}=0A=
	function reset_search() {=0A		var el =3D document.querySelectorAll("#frame=
s rect");=0A		for (var i =3D 0; i < el.length; i++) {=0A			orig_load(el[i],=
 "fill")=0A		}=0A		var params =3D get_params();=0A		delete params.s;=0A		hi=
story.replaceState(null, null, parse_params(params));=0A	}=0A	function sear=
ch_prompt() {=0A		if (!searching) {=0A			var term =3D prompt("Enter a searc=
h term (regexp " +=0A			    "allowed, eg: ^ext4_)"=0A			    + (ignorecase ?=
 ", ignoring case" : "")=0A			    + "\nPress Ctrl-i to toggle case sensitiv=
ity", "");=0A			if (term !=3D null) search(term);=0A		} else {=0A			reset_s=
earch();=0A			searching =3D 0;=0A			currentSearchTerm =3D null;=0A			search=
btn.classList.remove("show");=0A			searchbtn.firstChild.nodeValue =3D "Sear=
ch"=0A			matchedtxt.classList.add("hide");=0A			matchedtxt.firstChild.nodeV=
alue =3D ""=0A		}=0A	}=0A	function search(term) {=0A		if (term) currentSear=
chTerm =3D term;=0A=0A		var re =3D new RegExp(currentSearchTerm, ignorecase=
 ? 'i' : '');=0A		var el =3D document.getElementById("frames").children;=0A=
		var matches =3D new Object();=0A		var maxwidth =3D 0;=0A		for (var i =3D =
0; i < el.length; i++) {=0A			var e =3D el[i];=0A			var func =3D g_to_func(=
e);=0A			var rect =3D find_child(e, "rect");=0A			if (func =3D=3D null || r=
ect =3D=3D null)=0A				continue;=0A=0A			// Save max width. Only works as w=
e have a root frame=0A			var w =3D parseFloat(rect.attributes.width.value);=
=0A			if (w > maxwidth)=0A				maxwidth =3D w;=0A=0A			if (func.match(re)) {=
=0A				// highlight=0A				var x =3D parseFloat(rect.attributes.x.value);=0A=
				orig_save(rect, "fill");=0A				rect.attributes.fill.value =3D "rgb(230,=
0,230)";=0A=0A				// remember matches=0A				if (matches[x] =3D=3D undefined=
) {=0A					matches[x] =3D w;=0A				} else {=0A					if (w > matches[x]) {=0A=
						// overwrite with parent=0A						matches[x] =3D w;=0A					}=0A				}=
=0A				searching =3D 1;=0A			}=0A		}=0A		if (!searching)=0A			return;=0A		v=
ar params =3D get_params();=0A		params.s =3D currentSearchTerm;=0A		history=
=2EreplaceState(null, null, parse_params(params));=0A=0A		searchbtn.classLi=
st.add("show");=0A		searchbtn.firstChild.nodeValue =3D "Reset Search";=0A=
=0A		// calculate percent matched, excluding vertical overlap=0A		var count=
 =3D 0;=0A		var lastx =3D -1;=0A		var lastw =3D 0;=0A		var keys =3D Array()=
;=0A		for (k in matches) {=0A			if (matches.hasOwnProperty(k))=0A				keys.p=
ush(k);=0A		}=0A		// sort the matched frames by their x location=0A		// asc=
ending, then width descending=0A		keys.sort(function(a, b){=0A			return a -=
 b;=0A		});=0A		// Step through frames saving only the biggest bottom-up fr=
ames=0A		// thanks to the sort order. This relies on the tree property=0A		=
// where children are always smaller than their parents.=0A		var fudge =3D =
0.0001;	// JavaScript floating point=0A		for (var k in keys) {=0A			var x =
=3D parseFloat(keys[k]);=0A			var w =3D matches[keys[k]];=0A			if (x >=3D l=
astx + lastw - fudge) {=0A				count +=3D w;=0A				lastx =3D x;=0A				lastw =
=3D w;=0A			}=0A		}=0A		// display matched percent=0A		matchedtxt.classList=
=2Eremove("hide");=0A		var pct =3D 100 * count / maxwidth;=0A		if (pct !=3D=
 100) pct =3D pct.toFixed(1)=0A		matchedtxt.firstChild.nodeValue =3D "Match=
ed: " + pct + "%";=0A	}=0A]]>=0A</script>=0A<rect x=3D"0.0" y=3D"0" width=
=3D"1200.0" height=3D"790.0" fill=3D"url(#background)"  />=0A<text id=3D"ti=
tle" x=3D"600.00" y=3D"24" >receive</text>=0A<text id=3D"details" x=3D"10.0=
0" y=3D"773" > </text>=0A<text id=3D"unzoom" x=3D"10.00" y=3D"24" class=3D"=
hide">Reset Zoom</text>=0A<text id=3D"search" x=3D"1090.00" y=3D"24" >Searc=
h</text>=0A<text id=3D"ignorecase" x=3D"1174.00" y=3D"24" >ic</text>=0A<tex=
t id=3D"matched" x=3D"1090.00" y=3D"773" > </text>=0A<g id=3D"frames">=0A<g=
 >=0A<title>check_preemption_disabled (40 samples, 0.01%)</title><rect x=3D=
"782.5" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(211,131,53)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"785.55" y=3D"351.5" ></text>=0A</g>=0A<g >=
=0A<title>__domain_mapping (110 samples, 0.04%)</title><rect x=3D"797.9" y=
=3D"53" width=3D"0.4" height=3D"15.0" fill=3D"rgb(232,178,22)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"800.87" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>=
netif_skb_features (25 samples, 0.01%)</title><rect x=3D"15.4" y=3D"341" wi=
dth=3D"0.1" height=3D"15.0" fill=3D"rgb(226,133,42)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"18.42" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>nft_cmp_e=
val (289 samples, 0.10%)</title><rect x=3D"822.6" y=3D"341" width=3D"1.2" h=
eight=3D"15.0" fill=3D"rgb(222,208,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
825.59" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>ip_list_rcv (28 samples=
, 0.01%)</title><rect x=3D"1189.8" y=3D"357" width=3D"0.1" height=3D"15.0" =
fill=3D"rgb(220,142,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.78" y=3D"3=
67.5" ></text>=0A</g>=0A<g >=0A<title>__nf_conntrack_eventmask_report.isra.=
7 (37 samples, 0.01%)</title><rect x=3D"809.2" y=3D"341" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(207,228,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"812.=
16" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>alloc_iova_fast (35 samples=
, 0.01%)</title><rect x=3D"1175.6" y=3D"197" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(251,138,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.61" y=3D"2=
07.5" ></text>=0A</g>=0A<g >=0A<title>irq_exit_rcu (134 samples, 0.05%)</ti=
tle><rect x=3D"1189.4" y=3D"565" width=3D"0.6" height=3D"15.0" fill=3D"rgb(=
225,105,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.44" y=3D"575.5" ></tex=
t>=0A</g>=0A<g >=0A<title>efx_tx_send_pending (1,405 samples, 0.48%)</title=
><rect x=3D"38.1" y=3D"389" width=3D"5.7" height=3D"15.0" fill=3D"rgb(232,1=
5,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.11" y=3D"399.5" ></text>=0A</g=
>=0A<g >=0A<title>_raw_spin_lock_irqsave (26 samples, 0.01%)</title><rect x=
=3D"13.2" y=3D"245" width=3D"0.1" height=3D"15.0" fill=3D"rgb(221,35,13)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"16.16" y=3D"255.5" ></text>=0A</g>=0A<g >=
=0A<title>asm_sysvec_apic_timer_interrupt (105 samples, 0.04%)</title><rect=
 x=3D"1092.9" y=3D"565" width=3D"0.4" height=3D"15.0" fill=3D"rgb(238,8,26)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.86" y=3D"575.5" ></text>=0A</g>=
=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (74 samples, 0.03%)</title=
><rect x=3D"1007.9" y=3D"501" width=3D"0.3" height=3D"15.0" fill=3D"rgb(231=
,142,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1010.94" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>ip_finish_output2 (1,360 samples, 0.47%)</title><re=
ct x=3D"10.0" y=3D"437" width=3D"5.5" height=3D"15.0" fill=3D"rgb(246,132,1=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"447.5" ></text>=0A</g>=0A=
<g >=0A<title>gro_pull_from_frag0 (371 samples, 0.13%)</title><rect x=3D"62=
=2E7" y=3D"549" width=3D"1.5" height=3D"15.0" fill=3D"rgb(210,154,33)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"65.67" y=3D"559.5" ></text>=0A</g>=0A<g >=
=0A<title>ip_output (29 samples, 0.01%)</title><rect x=3D"61.0" y=3D"309" w=
idth=3D"0.1" height=3D"15.0" fill=3D"rgb(224,157,42)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"63.96" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__cpu_map=
_flush (959 samples, 0.33%)</title><rect x=3D"1169.7" y=3D"565" width=3D"3.=
9" height=3D"15.0" fill=3D"rgb(233,195,10)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1172.73" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_=
interrupt (42 samples, 0.01%)</title><rect x=3D"755.3" y=3D"277" width=3D"0=
=2E1" height=3D"15.0" fill=3D"rgb(243,30,19)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"758.28" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (3=
2 samples, 0.01%)</title><rect x=3D"989.2" y=3D"373" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(207,115,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.2=
4" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef10_ev_process (116 sam=
ples, 0.04%)</title><rect x=3D"1189.5" y=3D"485" width=3D"0.5" height=3D"15=
=2E0" fill=3D"rgb(231,61,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.48" y=
=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>sk_reset_timer (25 samples, 0.01=
%)</title><rect x=3D"800.5" y=3D"309" width=3D"0.1" height=3D"15.0" fill=3D=
"rgb(218,227,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"803.48" y=3D"319.5" ></=
text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid (57 samples, 0.02%)</ti=
tle><rect x=3D"841.3" y=3D"405" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
43,20,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"844.27" y=3D"415.5" ></text>=
=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (64 samples, 0.02%)</titl=
e><rect x=3D"390.2" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(228=
,64,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.15" y=3D"431.5" ></text>=0A=
</g>=0A<g >=0A<title>hrtimer_interrupt (104 samples, 0.04%)</title><rect x=
=3D"390.0" y=3D"469" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,19,47)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.02" y=3D"479.5" ></text>=0A</g>=0A<g=
 >=0A<title>task_tick_fair (29 samples, 0.01%)</title><rect x=3D"988.7" y=
=3D"341" width=3D"0.1" height=3D"15.0" fill=3D"rgb(239,181,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"991.72" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title=
>__slab_alloc.isra.97 (178 samples, 0.06%)</title><rect x=3D"345.2" y=3D"43=
7" width=3D"0.7" height=3D"15.0" fill=3D"rgb(243,79,16)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"348.18" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>nf_nat=
_packet (41 samples, 0.01%)</title><rect x=3D"811.3" y=3D"357" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(208,196,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"814.35" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_bh=
 (91 samples, 0.03%)</title><rect x=3D"868.7" y=3D"357" width=3D"0.4" heigh=
t=3D"15.0" fill=3D"rgb(218,165,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"871.=
69" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>intel_iommu_unmap_pages (49=
 samples, 0.02%)</title><rect x=3D"1169.1" y=3D"517" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(210,96,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1172.1=
4" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__tcp_transmit_skb (50 sampl=
es, 0.02%)</title><rect x=3D"60.9" y=3D"341" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(226,78,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.88" y=3D"351.=
5" ></text>=0A</g>=0A<g >=0A<title>napi_skb_cache_get (34 samples, 0.01%)</=
title><rect x=3D"53.2" y=3D"501" width=3D"0.2" height=3D"15.0" fill=3D"rgb(=
213,57,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.22" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>netif_skb_features (25 samples, 0.01%)</title><rect=
 x=3D"799.3" y=3D"165" width=3D"0.1" height=3D"15.0" fill=3D"rgb(207,194,51=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.32" y=3D"175.5" ></text>=0A</g>=
=0A<g >=0A<title>scheduler_tick (32 samples, 0.01%)</title><rect x=3D"251.7=
" y=3D"405" width=3D"0.2" height=3D"15.0" fill=3D"rgb(231,183,34)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"254.75" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>asm_sysvec_apic_timer_interrupt (243 samples, 0.08%)</title><rect x=3D"=
1167.6" y=3D"565" width=3D"1.0" height=3D"15.0" fill=3D"rgb(223,156,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1170.62" y=3D"575.5" ></text>=0A</g>=0A<g =
>=0A<title>nft_do_chain (75 samples, 0.03%)</title><rect x=3D"800.0" y=3D"2=
29" width=3D"0.3" height=3D"15.0" fill=3D"rgb(211,218,25)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"802.98" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>__kf=
ree_skb (159 samples, 0.05%)</title><rect x=3D"60.0" y=3D"357" width=3D"0.6=
" height=3D"15.0" fill=3D"rgb(226,164,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"62.99" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (85 s=
amples, 0.03%)</title><rect x=3D"1008.6" y=3D"421" width=3D"0.3" height=3D"=
15.0" fill=3D"rgb(246,125,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.56" =
y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>new_sync_read (9,071 samples, 3=
=2E12%)</title><rect x=3D"10.0" y=3D"613" width=3D"36.8" height=3D"15.0" fi=
ll=3D"rgb(215,25,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"623.5"=
 >new..</text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (36 samples, 0.01%)=
</title><rect x=3D"856.1" y=3D"357" width=3D"0.1" height=3D"15.0" fill=3D"r=
gb(218,196,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"859.06" y=3D"367.5" ></t=
ext>=0A</g>=0A<g >=0A<title>efx_features_check (25 samples, 0.01%)</title><=
rect x=3D"15.4" y=3D"325" width=3D"0.1" height=3D"15.0" fill=3D"rgb(218,44,=
48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.42" y=3D"335.5" ></text>=0A</g>=
=0A<g >=0A<title>kthread (278,126 samples, 95.71%)</title><rect x=3D"46.8" =
y=3D"693" width=3D"1129.5" height=3D"15.0" fill=3D"rgb(228,166,6)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"49.84" y=3D"703.5" >kthread</text>=0A</g>=0A<g >=
=0A<title>tick_sched_handle.isra.23 (143 samples, 0.05%)</title><rect x=3D"=
1167.9" y=3D"469" width=3D"0.6" height=3D"15.0" fill=3D"rgb(236,75,48)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1170.92" y=3D"479.5" ></text>=0A</g>=0A<g =
>=0A<title>__domain_mapping (1,300 samples, 0.45%)</title><rect x=3D"25.9" =
y=3D"277" width=3D"5.3" height=3D"15.0" fill=3D"rgb(251,224,26)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"28.94" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title=
>asm_sysvec_apic_timer_interrupt (44 samples, 0.02%)</title><rect x=3D"755.=
3" y=3D"293" width=3D"0.1" height=3D"15.0" fill=3D"rgb(249,61,19)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"758.27" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>inet_gro_complete (192 samples, 0.07%)</title><rect x=3D"698.1" y=3D"48=
5" width=3D"0.8" height=3D"15.0" fill=3D"rgb(235,206,4)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"701.12" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>asm_co=
mmon_interrupt (3,089 samples, 1.06%)</title><rect x=3D"1176.3" y=3D"613" w=
idth=3D"12.5" height=3D"15.0" fill=3D"rgb(206,13,51)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1179.30" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>inet_gr=
o_receive (111 samples, 0.04%)</title><rect x=3D"1180.2" y=3D"421" width=3D=
"0.5" height=3D"15.0" fill=3D"rgb(248,114,10)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"1183.20" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef10_tx_wri=
te (197 samples, 0.07%)</title><rect x=3D"14.1" y=3D"325" width=3D"0.8" hei=
ght=3D"15.0" fill=3D"rgb(250,185,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"17=
=2E12" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (176 sa=
mples, 0.06%)</title><rect x=3D"318.7" y=3D"437" width=3D"0.7" height=3D"15=
=2E0" fill=3D"rgb(247,132,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.68" y=
=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_unmap (31 samples, 0.01%=
)</title><rect x=3D"1187.6" y=3D"421" width=3D"0.1" height=3D"15.0" fill=3D=
"rgb(239,219,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.57" y=3D"431.5" >=
</text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (34 samples, 0.01%)</title=
><rect x=3D"593.7" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(227,=
142,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"596.72" y=3D"431.5" ></text>=0A=
</g>=0A<g >=0A<title>efx_hard_start_xmit (578 samples, 0.20%)</title><rect =
x=3D"43.8" y=3D"405" width=3D"2.4" height=3D"15.0" fill=3D"rgb(209,79,10)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"46.81" y=3D"415.5" ></text>=0A</g>=0A<g =
>=0A<title>dma_map_page_attrs (274 samples, 0.09%)</title><rect x=3D"797.6"=
 y=3D"149" width=3D"1.1" height=3D"15.0" fill=3D"rgb(231,86,25)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"800.62" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<titl=
e>asm_sysvec_apic_timer_interrupt (38 samples, 0.01%)</title><rect x=3D"102=
7.3" y=3D"533" width=3D"0.2" height=3D"15.0" fill=3D"rgb(229,16,42)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1030.33" y=3D"543.5" ></text>=0A</g>=0A<g >=0A=
<title>finish_task_switch (135 samples, 0.05%)</title><rect x=3D"1189.4" y=
=3D"613" width=3D"0.6" height=3D"15.0" fill=3D"rgb(235,71,48)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1192.44" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<titl=
e>_iommu_map (101 samples, 0.03%)</title><rect x=3D"1168.7" y=3D"517" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(208,116,12)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1171.66" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__iowrite64_=
copy (198 samples, 0.07%)</title><rect x=3D"20.8" y=3D"389" width=3D"0.8" h=
eight=3D"15.0" fill=3D"rgb(249,228,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
23.81" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interr=
upt (35 samples, 0.01%)</title><rect x=3D"593.7" y=3D"453" width=3D"0.2" he=
ight=3D"15.0" fill=3D"rgb(227,3,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"596=
=2E72" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>strncpy (56 samples, 0.0=
2%)</title><rect x=3D"795.9" y=3D"197" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(234,24,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"798.93" y=3D"207.5" =
></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (52 samples, 0.02%)</title=
><rect x=3D"1008.0" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(229=
,198,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1010.99" y=3D"431.5" ></text>=
=0A</g>=0A<g >=0A<title>__qdisc_run (1,360 samples, 0.47%)</title><rect x=
=3D"10.0" y=3D"405" width=3D"5.5" height=3D"15.0" fill=3D"rgb(216,6,34)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"415.5" ></text>=0A</g>=0A<g >=
=0A<title>sysvec_apic_timer_interrupt (112 samples, 0.04%)</title><rect x=
=3D"390.0" y=3D"501" width=3D"0.5" height=3D"15.0" fill=3D"rgb(243,38,33)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.00" y=3D"511.5" ></text>=0A</g>=0A<g=
 >=0A<title>preempt_count_sub (48 samples, 0.02%)</title><rect x=3D"782.3" =
y=3D"325" width=3D"0.2" height=3D"15.0" fill=3D"rgb(228,168,43)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"785.31" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<titl=
e>scheduler_tick (41 samples, 0.01%)</title><rect x=3D"695.5" y=3D"325" wid=
th=3D"0.2" height=3D"15.0" fill=3D"rgb(235,228,10)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"698.54" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>ip_local_de=
liver (51 samples, 0.02%)</title><rect x=3D"1177.7" y=3D"357" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(216,65,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1180.71" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>tcp_v4_inbound_md5_ha=
sh (91 samples, 0.03%)</title><rect x=3D"804.9" y=3D"341" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(240,139,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"807=
=2E86" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>smpboot_thread_fn (278,1=
26 samples, 95.71%)</title><rect x=3D"46.8" y=3D"677" width=3D"1129.5" heig=
ht=3D"15.0" fill=3D"rgb(216,16,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"49.8=
4" y=3D"687.5" >smpboot_thread_fn</text>=0A</g>=0A<g >=0A<title>__memcpy (6=
92 samples, 0.24%)</title><rect x=3D"495.1" y=3D"485" width=3D"2.8" height=
=3D"15.0" fill=3D"rgb(216,11,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"498.10"=
 y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>nft_do_chain_ipv4 (130 samples=
, 0.04%)</title><rect x=3D"61.3" y=3D"405" width=3D"0.5" height=3D"15.0" fi=
ll=3D"rgb(236,166,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.32" y=3D"415.5=
" ></text>=0A</g>=0A<g >=0A<title>read_tsc (67 samples, 0.02%)</title><rect=
 x=3D"802.5" y=3D"277" width=3D"0.3" height=3D"15.0" fill=3D"rgb(252,209,42=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"805.53" y=3D"287.5" ></text>=0A</g>=
=0A<g >=0A<title>__list_add_valid (30 samples, 0.01%)</title><rect x=3D"700=
=2E5" y=3D"469" width=3D"0.2" height=3D"15.0" fill=3D"rgb(225,100,3)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"703.54" y=3D"479.5" ></text>=0A</g>=0A<g >=0A=
<title>validate_xmit_skb (166 samples, 0.06%)</title><rect x=3D"46.2" y=3D"=
405" width=3D"0.6" height=3D"15.0" fill=3D"rgb(253,85,42)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"49.16" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__lis=
t_add_valid (100 samples, 0.03%)</title><rect x=3D"482.0" y=3D"501" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(230,147,54)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"485.02" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>ip_finish_out=
put2 (865 samples, 0.30%)</title><rect x=3D"796.3" y=3D"261" width=3D"3.5" =
height=3D"15.0" fill=3D"rgb(245,57,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
799.33" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>validate_xmit_skb (25 s=
amples, 0.01%)</title><rect x=3D"15.4" y=3D"357" width=3D"0.1" height=3D"15=
=2E0" fill=3D"rgb(217,184,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.42" y=
=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (66 samples=
, 0.02%)</title><rect x=3D"1055.4" y=3D"469" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(211,136,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1058.37" y=3D"4=
79.5" ></text>=0A</g>=0A<g >=0A<title>__ip_queue_xmit (436 samples, 0.15%)<=
/title><rect x=3D"1174.5" y=3D"405" width=3D"1.8" height=3D"15.0" fill=3D"r=
gb(225,106,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"415.5" ></=
text>=0A</g>=0A<g >=0A<title>ip_output (7,711 samples, 2.65%)</title><rect =
x=3D"15.5" y=3D"501" width=3D"31.3" height=3D"15.0" fill=3D"rgb(214,23,24)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.52" y=3D"511.5" >ip..</text>=0A</g>=
=0A<g >=0A<title>__sysvec_apic_timer_interrupt (108 samples, 0.04%)</title>=
<rect x=3D"390.0" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"rgb(220,2=
16,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.00" y=3D"495.5" ></text>=0A</=
g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (240 samples, 0.08%)</titl=
e><rect x=3D"988.1" y=3D"453" width=3D"0.9" height=3D"15.0" fill=3D"rgb(246=
,7,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.07" y=3D"463.5" ></text>=0A<=
/g>=0A<g >=0A<title>__netif_receive_skb_list_core (436 samples, 0.15%)</tit=
le><rect x=3D"1174.5" y=3D"581" width=3D"1.8" height=3D"15.0" fill=3D"rgb(2=
52,160,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"591.5" ></text=
>=0A</g>=0A<g >=0A<title>ip_local_deliver_finish (36 samples, 0.01%)</title=
><rect x=3D"1177.7" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235=
,76,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.72" y=3D"351.5" ></text>=
=0A</g>=0A<g >=0A<title>nf_nat_inet_fn (361 samples, 0.12%)</title><rect x=
=3D"878.7" y=3D"373" width=3D"1.4" height=3D"15.0" fill=3D"rgb(238,155,31)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"881.68" y=3D"383.5" ></text>=0A</g>=0A<=
g >=0A<title>ip_local_deliver_finish (18,683 samples, 6.43%)</title><rect x=
=3D"729.4" y=3D"389" width=3D"75.8" height=3D"15.0" fill=3D"rgb(223,100,51)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"732.36" y=3D"399.5" >ip_local..</text>=
=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (66 samples, 0.02%)</titl=
e><rect x=3D"695.5" y=3D"357" width=3D"0.2" height=3D"15.0" fill=3D"rgb(232=
,178,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"698.48" y=3D"367.5" ></text>=0A=
</g>=0A<g >=0A<title>ksys_read (9,071 samples, 3.12%)</title><rect x=3D"10.=
0" y=3D"645" width=3D"36.8" height=3D"15.0" fill=3D"rgb(231,95,44)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"655.5" >ksy..</text>=0A</g>=0A<g >=
=0A<title>tcp_v4_rcv (18,069 samples, 6.22%)</title><rect x=3D"731.9" y=3D"=
357" width=3D"73.3" height=3D"15.0" fill=3D"rgb(223,35,20)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"734.86" y=3D"367.5" >tcp_v4_rcv</text>=0A</g>=0A<g >=0A=
<title>native_queued_spin_lock_slowpath (74 samples, 0.03%)</title><rect x=
=3D"781.4" y=3D"325" width=3D"0.3" height=3D"15.0" fill=3D"rgb(254,114,47)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.39" y=3D"335.5" ></text>=0A</g>=0A<=
g >=0A<title>__napi_poll (2,891 samples, 0.99%)</title><rect x=3D"1177.1" y=
=3D"533" width=3D"11.7" height=3D"15.0" fill=3D"rgb(221,228,30)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1180.11" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<tit=
le>iommu_dma_alloc_iova.isra.28 (39 samples, 0.01%)</title><rect x=3D"798.5=
" y=3D"101" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,93,27)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"801.53" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<tit=
le>hrtimer_interrupt (215 samples, 0.07%)</title><rect x=3D"655.3" y=3D"421=
" width=3D"0.9" height=3D"15.0" fill=3D"rgb(245,135,32)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"658.30" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>update=
_process_times (114 samples, 0.04%)</title><rect x=3D"1008.5" y=3D"437" wid=
th=3D"0.5" height=3D"15.0" fill=3D"rgb(234,174,31)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1011.50" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>slab_post_=
alloc_hook (340 samples, 0.12%)</title><rect x=3D"347.3" y=3D"437" width=3D=
"1.4" height=3D"15.0" fill=3D"rgb(224,111,34)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"350.34" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__alloc_skb (121=
 samples, 0.04%)</title><rect x=3D"52.9" y=3D"517" width=3D"0.5" height=3D"=
15.0" fill=3D"rgb(249,220,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"55.86" y=
=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>nf_hook_slow (110 samples, 0.04%=
)</title><rect x=3D"799.8" y=3D"261" width=3D"0.5" height=3D"15.0" fill=3D"=
rgb(220,64,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.84" y=3D"271.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__rcu_read_lock (36 samples, 0.01%)</title><rec=
t x=3D"729.8" y=3D"373" width=3D"0.2" height=3D"15.0" fill=3D"rgb(234,171,3=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"732.83" y=3D"383.5" ></text>=0A</g>=
=0A<g >=0A<title>tcp_rcv_established (71 samples, 0.02%)</title><rect x=3D"=
60.8" y=3D"357" width=3D"0.3" height=3D"15.0" fill=3D"rgb(216,50,10)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"63.85" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<=
title>slab_post_alloc_hook (76 samples, 0.03%)</title><rect x=3D"356.1" y=
=3D"437" width=3D"0.3" height=3D"15.0" fill=3D"rgb(244,19,46)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"359.09" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title=
>__qdisc_run (691 samples, 0.24%)</title><rect x=3D"796.7" y=3D"229" width=
=3D"2.8" height=3D"15.0" fill=3D"rgb(243,123,17)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"799.66" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>intel_iommu_i=
otlb_sync_map (42 samples, 0.01%)</title><rect x=3D"1175.4" y=3D"197" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(235,7,39)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"1178.43" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_he=
ad_state (84 samples, 0.03%)</title><rect x=3D"757.1" y=3D"261" width=3D"0.=
3" height=3D"15.0" fill=3D"rgb(223,129,39)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"760.10" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (2=
5 samples, 0.01%)</title><rect x=3D"593.7" y=3D"389" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(248,225,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"596.7=
4" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (56 sam=
ples, 0.02%)</title><rect x=3D"157.5" y=3D"421" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(241,118,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.49" y=3D=
"431.5" ></text>=0A</g>=0A<g >=0A<title>task_tick_fair (38 samples, 0.01%)<=
/title><rect x=3D"157.7" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rg=
b(217,70,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.73" y=3D"431.5" ></text=
>=0A</g>=0A<g >=0A<title>kmem_cache_alloc_bulk (1,220 samples, 0.42%)</titl=
e><rect x=3D"351.4" y=3D"453" width=3D"5.0" height=3D"15.0" fill=3D"rgb(217=
,31,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"354.44" y=3D"463.5" ></text>=0A=
</g>=0A<g >=0A<title>__dev_queue_xmit (1,360 samples, 0.47%)</title><rect x=
=3D"10.0" y=3D"421" width=3D"5.5" height=3D"15.0" fill=3D"rgb(251,86,37)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"431.5" ></text>=0A</g>=0A<g >=
=0A<title>nf_conntrack_tcp_packet (64 samples, 0.02%)</title><rect x=3D"795=
=2E0" y=3D"213" width=3D"0.3" height=3D"15.0" fill=3D"rgb(230,174,20)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"798.02" y=3D"223.5" ></text>=0A</g>=0A<g >=
=0A<title>__hrtimer_run_queues (31 samples, 0.01%)</title><rect x=3D"839.5"=
 y=3D"261" width=3D"0.2" height=3D"15.0" fill=3D"rgb(238,177,12)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"842.54" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__slab_free (268 samples, 0.09%)</title><rect x=3D"1185.6" y=3D"421" wid=
th=3D"1.1" height=3D"15.0" fill=3D"rgb(231,63,34)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1188.64" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>ip_rcv_fini=
sh_core.isra.22 (2,707 samples, 0.93%)</title><rect x=3D"716.4" y=3D"421" w=
idth=3D"11.0" height=3D"15.0" fill=3D"rgb(216,172,20)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"719.43" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>intel_io=
mmu_map_pages (59 samples, 0.02%)</title><rect x=3D"1168.7" y=3D"485" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(251,85,19)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1171.67" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__list_del_en=
try_valid (43 samples, 0.01%)</title><rect x=3D"727.8" y=3D"405" width=3D"0=
=2E2" height=3D"15.0" fill=3D"rgb(228,75,33)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"730.83" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_t=
imer_interrupt (199 samples, 0.07%)</title><rect x=3D"1008.3" y=3D"549" wid=
th=3D"0.8" height=3D"15.0" fill=3D"rgb(246,10,31)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1011.25" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>ip_finish_o=
utput2 (27 samples, 0.01%)</title><rect x=3D"61.0" y=3D"293" width=3D"0.1" =
height=3D"15.0" fill=3D"rgb(249,44,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
63.96" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_in=
terrupt (228 samples, 0.08%)</title><rect x=3D"655.3" y=3D"469" width=3D"0.=
9" height=3D"15.0" fill=3D"rgb(248,82,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"658.27" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>ip_protocol_deliver=
_rcu (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"485" width=3D"1.8"=
 height=3D"15.0" fill=3D"rgb(228,149,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1177.50" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__netif_receive_sk=
b_list_core (28 samples, 0.01%)</title><rect x=3D"1189.8" y=3D"373" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(222,9,0)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"1192.78" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>should_failslab=
 (61 samples, 0.02%)</title><rect x=3D"347.1" y=3D"437" width=3D"0.2" heigh=
t=3D"15.0" fill=3D"rgb(232,81,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"350.0=
9" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (82 samples,=
 0.03%)</title><rect x=3D"783.2" y=3D"325" width=3D"0.3" height=3D"15.0" fi=
ll=3D"rgb(216,167,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.16" y=3D"335.=
5" ></text>=0A</g>=0A<g >=0A<title>inet_gro_receive (822 samples, 0.28%)</t=
itle><rect x=3D"55.7" y=3D"533" width=3D"3.3" height=3D"15.0" fill=3D"rgb(2=
19,158,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"58.66" y=3D"543.5" ></text>=
=0A</g>=0A<g >=0A<title>__sk_defer_free_flush (182 samples, 0.06%)</title><=
rect x=3D"59.9" y=3D"373" width=3D"0.8" height=3D"15.0" fill=3D"rgb(243,102=
,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.92" y=3D"383.5" ></text>=0A</g>=
=0A<g >=0A<title>efx_rx_packet_gro (60 samples, 0.02%)</title><rect x=3D"11=
79.7" y=3D"453" width=3D"0.2" height=3D"15.0" fill=3D"rgb(236,63,52)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"1182.66" y=3D"463.5" ></text>=0A</g>=0A<g >=
=0A<title>gro_pull_from_frag0 (898 samples, 0.31%)</title><rect x=3D"494.3"=
 y=3D"501" width=3D"3.6" height=3D"15.0" fill=3D"rgb(213,176,42)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"497.27" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__memcpy (46 samples, 0.02%)</title><rect x=3D"1181.3" y=3D"421" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(218,139,3)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1184.29" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__slab_free (=
54 samples, 0.02%)</title><rect x=3D"778.9" y=3D"325" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(236,94,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"781.92=
" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_data (73 samples,=
 0.03%)</title><rect x=3D"60.3" y=3D"309" width=3D"0.3" height=3D"15.0" fil=
l=3D"rgb(215,71,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.29" y=3D"319.5" =
></text>=0A</g>=0A<g >=0A<title>nft_do_chain_ipv4 (170 samples, 0.06%)</tit=
le><rect x=3D"795.5" y=3D"229" width=3D"0.7" height=3D"15.0" fill=3D"rgb(24=
4,55,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"798.47" y=3D"239.5" ></text>=
=0A</g>=0A<g >=0A<title>fib_validate_source (27 samples, 0.01%)</title><rec=
t x=3D"59.4" y=3D"421" width=3D"0.1" height=3D"15.0" fill=3D"rgb(239,189,23=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.42" y=3D"431.5" ></text>=0A</g>=0A=
<g >=0A<title>hrtimer_interrupt (85 samples, 0.03%)</title><rect x=3D"1055.=
3" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"rgb(205,43,3)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1058.34" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__iommu_dma_map (238 samples, 0.08%)</title><rect x=3D"1174.8" y=3D"229=
" width=3D"1.0" height=3D"15.0" fill=3D"rgb(235,59,11)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1177.79" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>sock_d=
ef_readable (168 samples, 0.06%)</title><rect x=3D"800.6" y=3D"309" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(216,33,26)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"803.58" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__netif_receiv=
e_skb_list_core (82 samples, 0.03%)</title><rect x=3D"1177.7" y=3D"421" wid=
th=3D"0.3" height=3D"15.0" fill=3D"rgb(242,87,42)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1180.66" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__tcp_selec=
t_window (53 samples, 0.02%)</title><rect x=3D"793.4" y=3D"293" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(244,144,4)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"796.42" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queue=
s (54 samples, 0.02%)</title><rect x=3D"1008.0" y=3D"437" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(238,19,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1010=
=2E98" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>efx_tx_map_data (3,776 s=
amples, 1.30%)</title><rect x=3D"21.8" y=3D"389" width=3D"15.3" height=3D"1=
5.0" fill=3D"rgb(225,26,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"24.78" y=3D"=
399.5" ></text>=0A</g>=0A<g >=0A<title>ip_sublist_rcv (78 samples, 0.03%)</=
title><rect x=3D"1177.7" y=3D"389" width=3D"0.3" height=3D"15.0" fill=3D"rg=
b(226,201,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.68" y=3D"399.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (25 samples, 0.01=
%)</title><rect x=3D"493.0" y=3D"453" width=3D"0.1" height=3D"15.0" fill=3D=
"rgb(247,183,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"495.99" y=3D"463.5" ><=
/text>=0A</g>=0A<g >=0A<title>__list_add_valid (56 samples, 0.02%)</title><=
rect x=3D"841.0" y=3D"405" width=3D"0.3" height=3D"15.0" fill=3D"rgb(238,74=
,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"844.05" y=3D"415.5" ></text>=0A</g=
>=0A<g >=0A<title>__rcu_read_unlock (1,858 samples, 0.64%)</title><rect x=
=3D"485.6" y=3D"501" width=3D"7.5" height=3D"15.0" fill=3D"rgb(230,80,9)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"488.55" y=3D"511.5" ></text>=0A</g>=0A<g =
>=0A<title>efx_tx_map_data (627 samples, 0.22%)</title><rect x=3D"11.1" y=
=3D"341" width=3D"2.5" height=3D"15.0" fill=3D"rgb(254,181,47)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"14.06" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>=
sch_direct_xmit (623 samples, 0.21%)</title><rect x=3D"796.9" y=3D"213" wid=
th=3D"2.6" height=3D"15.0" fill=3D"rgb(238,215,45)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"799.93" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>__alloc_skb=
 (69 samples, 0.02%)</title><rect x=3D"793.7" y=3D"293" width=3D"0.3" heigh=
t=3D"15.0" fill=3D"rgb(248,61,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"796.6=
7" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>efx_tx_map_chunk (210 sample=
s, 0.07%)</title><rect x=3D"36.1" y=3D"373" width=3D"0.9" height=3D"15.0" f=
ill=3D"rgb(242,35,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.11" y=3D"383.5=
" ></text>=0A</g>=0A<g >=0A<title>skb_try_coalesce (84 samples, 0.03%)</tit=
le><rect x=3D"791.3" y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"rgb(22=
5,89,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"794.35" y=3D"335.5" ></text>=
=0A</g>=0A<g >=0A<title>ip_list_rcv (840 samples, 0.29%)</title><rect x=3D"=
59.2" y=3D"485" width=3D"3.4" height=3D"15.0" fill=3D"rgb(225,27,48)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"62.22" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<=
title>efx_xmit_done (1,584 samples, 0.55%)</title><rect x=3D"1181.6" y=3D"4=
85" width=3D"6.5" height=3D"15.0" fill=3D"rgb(205,0,10)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"1184.62" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__rcu=
_read_unlock (108 samples, 0.04%)</title><rect x=3D"783.5" y=3D"325" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(239,25,17)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"786.49" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>__this_cpu_pre=
empt_check (27 samples, 0.01%)</title><rect x=3D"712.8" y=3D"421" width=3D"=
0.1" height=3D"15.0" fill=3D"rgb(217,217,25)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"715.83" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (9=
6 samples, 0.03%)</title><rect x=3D"318.9" y=3D"389" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(211,93,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.89=
" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>net_rx_action (2,891 samples,=
 0.99%)</title><rect x=3D"1177.1" y=3D"549" width=3D"11.7" height=3D"15.0" =
fill=3D"rgb(244,152,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.11" y=3D"5=
59.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (252 samples, 0.09%=
)</title><rect x=3D"582.7" y=3D"437" width=3D"1.1" height=3D"15.0" fill=3D"=
rgb(220,87,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"585.74" y=3D"447.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__rcu_read_lock (29 samples, 0.01%)</title><rect=
 x=3D"697.7" y=3D"485" width=3D"0.1" height=3D"15.0" fill=3D"rgb(240,102,9)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"700.67" y=3D"495.5" ></text>=0A</g>=0A=
<g >=0A<title>__tcp_transmit_skb (1,598 samples, 0.55%)</title><rect x=3D"7=
94.0" y=3D"309" width=3D"6.4" height=3D"15.0" fill=3D"rgb(206,91,38)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"796.95" y=3D"319.5" ></text>=0A</g>=0A<g >=0A=
<title>update_wall_time (32 samples, 0.01%)</title><rect x=3D"493.3" y=3D"3=
89" width=3D"0.2" height=3D"15.0" fill=3D"rgb(241,176,13)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"496.34" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>upda=
te_wall_time (25 samples, 0.01%)</title><rect x=3D"988.3" y=3D"373" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(237,175,44)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"991.27" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>__kmalloc_nod=
e_track_caller (28 samples, 0.01%)</title><rect x=3D"53.1" y=3D"485" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(231,70,5)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"56.10" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>dma_pte_clear_le=
vel (40 samples, 0.01%)</title><rect x=3D"1169.2" y=3D"485" width=3D"0.1" h=
eight=3D"15.0" fill=3D"rgb(245,109,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1172.16" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__netif_receive_skb_li=
st_core (870 samples, 0.30%)</title><rect x=3D"59.1" y=3D"501" width=3D"3.5=
" height=3D"15.0" fill=3D"rgb(207,165,2)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"62.10" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>handle_irq_event (19=
8 samples, 0.07%)</title><rect x=3D"1176.3" y=3D"549" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(215,161,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.=
30" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (=
30 samples, 0.01%)</title><rect x=3D"731.0" y=3D"357" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(229,206,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"734.0=
3" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>debug_smp_processor_id (25 s=
amples, 0.01%)</title><rect x=3D"351.3" y=3D"453" width=3D"0.1" height=3D"1=
5.0" fill=3D"rgb(238,26,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"354.34" y=
=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__domain_mapping (208 samples, 0=
=2E07%)</title><rect x=3D"11.7" y=3D"229" width=3D"0.9" height=3D"15.0" fil=
l=3D"rgb(221,124,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.73" y=3D"239.5"=
 ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (65 samples, 0.02%)</title=
><rect x=3D"715.7" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(241,=
21,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"718.67" y=3D"431.5" ></text>=0A<=
/g>=0A<g >=0A<title>efx_poll (277,630 samples, 95.54%)</title><rect x=3D"47=
=2E1" y=3D"597" width=3D"1127.4" height=3D"15.0" fill=3D"rgb(210,76,34)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"50.07" y=3D"607.5" >efx_poll</text>=0A</g>=
=0A<g >=0A<title>ip_finish_output2 (7,711 samples, 2.65%)</title><rect x=3D=
"15.5" y=3D"485" width=3D"31.3" height=3D"15.0" fill=3D"rgb(246,189,38)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"18.52" y=3D"495.5" >ip..</text>=0A</g>=0A<=
g >=0A<title>__tcp_ack_snd_check (226 samples, 0.08%)</title><rect x=3D"792=
=2E7" y=3D"309" width=3D"1.0" height=3D"15.0" fill=3D"rgb(222,154,30)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"795.73" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>__sysvec_apic_timer_interrupt (34 samples, 0.01%)</title><rect x=
=3D"593.7" y=3D"437" width=3D"0.2" height=3D"15.0" fill=3D"rgb(226,160,2)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"596.72" y=3D"447.5" ></text>=0A</g>=0A<g=
 >=0A<title>__efx_enqueue_skb (6,967 samples, 2.40%)</title><rect x=3D"15.5=
" y=3D"405" width=3D"28.3" height=3D"15.0" fill=3D"rgb(251,181,24)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"18.52" y=3D"415.5" >_..</text>=0A</g>=0A<g >=0A=
<title>skb_release_all (306 samples, 0.11%)</title><rect x=3D"1184.2" y=3D"=
437" width=3D"1.3" height=3D"15.0" fill=3D"rgb(218,117,21)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"1187.24" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>de=
v_hard_start_xmit (470 samples, 0.16%)</title><rect x=3D"797.3" y=3D"197" w=
idth=3D"1.9" height=3D"15.0" fill=3D"rgb(242,211,45)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"800.29" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>nf_connt=
rack_tcp_packet (3,341 samples, 1.15%)</title><rect x=3D"862.4" y=3D"373" w=
idth=3D"13.6" height=3D"15.0" fill=3D"rgb(237,149,21)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"865.39" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>alloc_io=
va_fast (36 samples, 0.01%)</title><rect x=3D"798.5" y=3D"85" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(213,15,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"801.54" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>do_idle (3,379 samples,=
 1.16%)</title><rect x=3D"1176.3" y=3D"661" width=3D"13.7" height=3D"15.0" =
fill=3D"rgb(230,34,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.28" y=3D"67=
1.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (80 samples, 0.03%)</=
title><rect x=3D"390.1" y=3D"437" width=3D"0.3" height=3D"15.0" fill=3D"rgb=
(228,92,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.09" y=3D"447.5" ></text>=
=0A</g>=0A<g >=0A<title>clflush_cache_range (25 samples, 0.01%)</title><rec=
t x=3D"1168.8" y=3D"453" width=3D"0.1" height=3D"15.0" fill=3D"rgb(243,192,=
50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.79" y=3D"463.5" ></text>=0A</g=
>=0A<g >=0A<title>dma_map_page_attrs (125 samples, 0.04%)</title><rect x=3D=
"1168.6" y=3D"565" width=3D"0.5" height=3D"15.0" fill=3D"rgb(244,201,36)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"1171.60" y=3D"575.5" ></text>=0A</g>=0A<g=
 >=0A<title>__iommu_dma_map (3,004 samples, 1.03%)</title><rect x=3D"23.4" =
y=3D"341" width=3D"12.2" height=3D"15.0" fill=3D"rgb(243,158,15)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"26.39" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<titl=
e>dev_gro_receive (2,167 samples, 0.75%)</title><rect x=3D"53.9" y=3D"549" =
width=3D"8.8" height=3D"15.0" fill=3D"rgb(230,163,3)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"56.87" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>iperf3 (9=
,071 samples, 3.12%)</title><rect x=3D"10.0" y=3D"725" width=3D"36.8" heigh=
t=3D"15.0" fill=3D"rgb(253,90,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"735.5" >ipe..</text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (72=
 samples, 0.02%)</title><rect x=3D"989.1" y=3D"437" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(234,227,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.12" =
y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__local_bh_enable_ip (242 sampl=
es, 0.08%)</title><rect x=3D"865.7" y=3D"357" width=3D"0.9" height=3D"15.0"=
 fill=3D"rgb(220,139,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"868.66" y=3D"36=
7.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_data (4,765 samples, 1.64%=
)</title><rect x=3D"757.4" y=3D"277" width=3D"19.4" height=3D"15.0" fill=3D=
"rgb(228,70,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"760.45" y=3D"287.5" ></=
text>=0A</g>=0A<g >=0A<title>dma_map_page_attrs (275 samples, 0.09%)</title=
><rect x=3D"1174.7" y=3D"261" width=3D"1.1" height=3D"15.0" fill=3D"rgb(222=
,95,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.70" y=3D"271.5" ></text>=
=0A</g>=0A<g >=0A<title>skb_condense (47 samples, 0.02%)</title><rect x=3D"=
791.2" y=3D"325" width=3D"0.1" height=3D"15.0" fill=3D"rgb(229,119,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"794.16" y=3D"335.5" ></text>=0A</g>=0A<g >=
=0A<title>__hrtimer_run_queues (228 samples, 0.08%)</title><rect x=3D"493.2=
" y=3D"437" width=3D"0.9" height=3D"15.0" fill=3D"rgb(214,102,49)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"496.21" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>perf_event_task_tick (46 samples, 0.02%)</title><rect x=3D"1168.1" y=3D=
"421" width=3D"0.1" height=3D"15.0" fill=3D"rgb(214,123,9)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"1171.05" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>ip=
_list_rcv (43,178 samples, 14.86%)</title><rect x=3D"708.5" y=3D"453" width=
=3D"175.3" height=3D"15.0" fill=3D"rgb(227,117,33)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"711.50" y=3D"463.5" >ip_list_rcv</text>=0A</g>=0A<g >=0A<title>=
sysvec_apic_timer_interrupt (25 samples, 0.01%)</title><rect x=3D"493.0" y=
=3D"469" width=3D"0.1" height=3D"15.0" fill=3D"rgb(219,154,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"495.99" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title=
>__list_del_entry_valid (100 samples, 0.03%)</title><rect x=3D"700.7" y=3D"=
469" width=3D"0.4" height=3D"15.0" fill=3D"rgb(254,72,8)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"703.67" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>get_l=
4proto (284 samples, 0.10%)</title><rect x=3D"856.3" y=3D"373" width=3D"1.2=
" height=3D"15.0" fill=3D"rgb(215,134,11)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"859.31" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (41 =
samples, 0.01%)</title><rect x=3D"390.2" y=3D"389" width=3D"0.2" height=3D"=
15.0" fill=3D"rgb(248,171,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.20" y=
=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>iommu_pgsize.isra.21 (119 sample=
s, 0.04%)</title><rect x=3D"31.2" y=3D"293" width=3D"0.5" height=3D"15.0" f=
ill=3D"rgb(239,197,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.24" y=3D"303.=
5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (27 samples, 0=
=2E01%)</title><rect x=3D"755.3" y=3D"197" width=3D"0.1" height=3D"15.0" fi=
ll=3D"rgb(231,137,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.31" y=3D"207.=
5" ></text>=0A</g>=0A<g >=0A<title>strncpy (2,694 samples, 0.93%)</title><r=
ect x=3D"828.7" y=3D"341" width=3D"11.0" height=3D"15.0" fill=3D"rgb(213,10=
4,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"831.74" y=3D"351.5" ></text>=0A</=
g>=0A<g >=0A<title>ip_list_rcv (135 samples, 0.05%)</title><rect x=3D"1180.=
7" y=3D"373" width=3D"0.5" height=3D"15.0" fill=3D"rgb(234,199,8)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1183.70" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<t=
itle>sysvec_apic_timer_interrupt (279 samples, 0.10%)</title><rect x=3D"493=
=2E1" y=3D"485" width=3D"1.2" height=3D"15.0" fill=3D"rgb(205,225,36)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"496.14" y=3D"495.5" ></text>=0A</g>=0A<g >=
=0A<title>skb_gro_receive (9,752 samples, 3.36%)</title><rect x=3D"656.2" y=
=3D"469" width=3D"39.6" height=3D"15.0" fill=3D"rgb(213,31,41)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"659.20" y=3D"479.5" >skb..</text>=0A</g>=0A<g >=0A<=
title>__qdisc_run (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"341" =
width=3D"1.8" height=3D"15.0" fill=3D"rgb(244,40,29)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1177.50" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>intel_i=
ommu_iotlb_sync_map (94 samples, 0.03%)</title><rect x=3D"12.6" y=3D"261" w=
idth=3D"0.4" height=3D"15.0" fill=3D"rgb(218,96,51)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"15.64" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>ip_sublis=
t_rcv_finish (51 samples, 0.02%)</title><rect x=3D"1177.7" y=3D"373" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(233,148,3)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1180.71" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>__fib_validat=
e_source (522 samples, 0.18%)</title><rect x=3D"719.1" y=3D"373" width=3D"2=
=2E2" height=3D"15.0" fill=3D"rgb(236,131,32)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"722.13" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_time=
r_interrupt (71 samples, 0.02%)</title><rect x=3D"1008.0" y=3D"485" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(209,48,21)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1010.95" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>netif_receive=
_skb_list_internal (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"597"=
 width=3D"1.8" height=3D"15.0" fill=3D"rgb(245,179,42)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1177.50" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>irq_ex=
it_rcu (124 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"565" width=3D"0.=
5" height=3D"15.0" fill=3D"rgb(234,144,4)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1191.88" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>inet_ehashfn (216 =
samples, 0.07%)</title><rect x=3D"725.4" y=3D"373" width=3D"0.9" height=3D"=
15.0" fill=3D"rgb(244,93,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"728.44" y=
=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt =
(116 samples, 0.04%)</title><rect x=3D"695.3" y=3D"453" width=3D"0.5" heigh=
t=3D"15.0" fill=3D"rgb(223,222,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"698.3=
3" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>nft_do_chain (6,508 samples,=
 2.24%)</title><rect x=3D"813.2" y=3D"357" width=3D"26.5" height=3D"15.0" f=
ill=3D"rgb(235,182,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"816.25" y=3D"367=
=2E5" >n..</text>=0A</g>=0A<g >=0A<title>kfree (299 samples, 0.10%)</title>=
<rect x=3D"775.5" y=3D"261" width=3D"1.2" height=3D"15.0" fill=3D"rgb(222,1=
34,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.52" y=3D"271.5" ></text>=0A<=
/g>=0A<g >=0A<title>__hrtimer_run_queues (31 samples, 0.01%)</title><rect x=
=3D"1027.3" y=3D"469" width=3D"0.2" height=3D"15.0" fill=3D"rgb(236,71,1)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.34" y=3D"479.5" ></text>=0A</g>=0A<=
g >=0A<title>__sysvec_apic_timer_interrupt (279 samples, 0.10%)</title><rec=
t x=3D"157.0" y=3D"533" width=3D"1.1" height=3D"15.0" fill=3D"rgb(228,84,52=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.01" y=3D"543.5" ></text>=0A</g>=
=0A<g >=0A<title>intel_iommu_unmap_pages (30 samples, 0.01%)</title><rect x=
=3D"1187.6" y=3D"405" width=3D"0.1" height=3D"15.0" fill=3D"rgb(223,134,31)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.57" y=3D"415.5" ></text>=0A</g>=
=0A<g >=0A<title>__hrtimer_run_queues (63 samples, 0.02%)</title><rect x=3D=
"251.6" y=3D"469" width=3D"0.3" height=3D"15.0" fill=3D"rgb(253,199,9)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"254.63" y=3D"479.5" ></text>=0A</g>=0A<g >=
=0A<title>asm_sysvec_apic_timer_interrupt (235 samples, 0.08%)</title><rect=
 x=3D"318.5" y=3D"517" width=3D"1.0" height=3D"15.0" fill=3D"rgb(229,143,39=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.52" y=3D"527.5" ></text>=0A</g>=
=0A<g >=0A<title>check_preemption_disabled (116 samples, 0.04%)</title><rec=
t x=3D"350.9" y=3D"453" width=3D"0.4" height=3D"15.0" fill=3D"rgb(229,56,21=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"353.87" y=3D"463.5" ></text>=0A</g>=
=0A<g >=0A<title>kmalloc_reserve (30 samples, 0.01%)</title><rect x=3D"53.1=
" y=3D"501" width=3D"0.1" height=3D"15.0" fill=3D"rgb(231,105,52)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"56.09" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<tit=
le>update_process_times (63 samples, 0.02%)</title><rect x=3D"390.2" y=3D"4=
05" width=3D"0.2" height=3D"15.0" fill=3D"rgb(227,107,21)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"393.16" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__ef=
x_enqueue_skb (401 samples, 0.14%)</title><rect x=3D"1174.5" y=3D"293" widt=
h=3D"1.6" height=3D"15.0" fill=3D"rgb(238,54,7)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1177.50" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>tcp_grow_wind=
ow (42 samples, 0.01%)</title><rect x=3D"801.9" y=3D"309" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(247,113,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"804=
=2E89" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>dql_completed (45 sample=
s, 0.02%)</title><rect x=3D"1178.1" y=3D"501" width=3D"0.2" height=3D"15.0"=
 fill=3D"rgb(211,210,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.07" y=3D"=
511.5" ></text>=0A</g>=0A<g >=0A<title>__efx_rx_packet (91 samples, 0.03%)<=
/title><rect x=3D"1177.6" y=3D"501" width=3D"0.4" height=3D"15.0" fill=3D"r=
gb(220,88,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.63" y=3D"511.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (86 samples, 0.03%)</title=
><rect x=3D"390.1" y=3D"453" width=3D"0.3" height=3D"15.0" fill=3D"rgb(240,=
83,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.06" y=3D"463.5" ></text>=0A<=
/g>=0A<g >=0A<title>handle_edge_irq (198 samples, 0.07%)</title><rect x=3D"=
1176.3" y=3D"565" width=3D"0.8" height=3D"15.0" fill=3D"rgb(206,55,30)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1179.30" y=3D"575.5" ></text>=0A</g>=0A<g =
>=0A<title>__domain_mapping (55 samples, 0.02%)</title><rect x=3D"1168.7" y=
=3D"469" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,195,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1171.68" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__hrtimer_run_queues (26 samples, 0.01%)</title><rect x=3D"593.7" y=3D"40=
5" width=3D"0.1" height=3D"15.0" fill=3D"rgb(253,167,6)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"596.74" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>_raw_s=
pin_lock (58 samples, 0.02%)</title><rect x=3D"797.0" y=3D"197" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(207,222,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"799.98" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>ip_local_deliver (4=
36 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"517" width=3D"1.8" height=
=3D"15.0" fill=3D"rgb(222,213,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.5=
0" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>inet_gro_receive (48,729 sam=
ples, 16.77%)</title><rect x=3D"497.9" y=3D"501" width=3D"197.9" height=3D"=
15.0" fill=3D"rgb(227,118,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"500.92" y=
=3D"511.5" >inet_gro_receive</text>=0A</g>=0A<g >=0A<title>tick_sched_handl=
e.isra.23 (29 samples, 0.01%)</title><rect x=3D"775.4" y=3D"165" width=3D"0=
=2E1" height=3D"15.0" fill=3D"rgb(211,51,17)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"778.37" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>efx_rx_packet (10=
0 samples, 0.03%)</title><rect x=3D"1189.5" y=3D"469" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(249,165,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.=
55" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>net_rx_action (124 samples,=
 0.04%)</title><rect x=3D"1188.9" y=3D"533" width=3D"0.5" height=3D"15.0" f=
ill=3D"rgb(241,54,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.88" y=3D"543=
=2E5" ></text>=0A</g>=0A<g >=0A<title>ip_sublist_rcv_finish (27,644 samples=
, 9.51%)</title><rect x=3D"727.4" y=3D"421" width=3D"112.3" height=3D"15.0"=
 fill=3D"rgb(253,219,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"730.42" y=3D"43=
1.5" >ip_sublist_rc..</text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_i=
nterrupt (54 samples, 0.02%)</title><rect x=3D"775.3" y=3D"261" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(216,130,52)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"778.30" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>ip_rcv_core.isra.23=
 (770 samples, 0.26%)</title><rect x=3D"710.3" y=3D"437" width=3D"3.1" heig=
ht=3D"15.0" fill=3D"rgb(228,201,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"713=
=2E28" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>ip_list_rcv (436 samples=
, 0.15%)</title><rect x=3D"1174.5" y=3D"565" width=3D"1.8" height=3D"15.0" =
fill=3D"rgb(247,191,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"5=
75.5" ></text>=0A</g>=0A<g >=0A<title>fq_dequeue (43 samples, 0.01%)</title=
><rect x=3D"796.8" y=3D"213" width=3D"0.1" height=3D"15.0" fill=3D"rgb(211,=
27,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"799.76" y=3D"223.5" ></text>=0A</=
g>=0A<g >=0A<title>alloc_iova_fast (319 samples, 0.11%)</title><rect x=3D"3=
4.1" y=3D"309" width=3D"1.3" height=3D"15.0" fill=3D"rgb(248,158,36)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"37.14" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<=
title>tcp_v4_rcv (45 samples, 0.02%)</title><rect x=3D"1180.8" y=3D"277" wi=
dth=3D"0.2" height=3D"15.0" fill=3D"rgb(227,93,18)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1183.80" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>task_tick_=
fair (35 samples, 0.01%)</title><rect x=3D"1008.7" y=3D"405" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(222,48,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1011.73" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (67 =
samples, 0.02%)</title><rect x=3D"729.1" y=3D"389" width=3D"0.3" height=3D"=
15.0" fill=3D"rgb(205,181,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"732.08" y=
=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (29 samples, 0.=
01%)</title><rect x=3D"1027.4" y=3D"453" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(254,223,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.35" y=3D"463.5"=
 ></text>=0A</g>=0A<g >=0A<title>tcp_v4_rcv (34 samples, 0.01%)</title><rec=
t x=3D"1177.7" y=3D"309" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,51,1=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.73" y=3D"319.5" ></text>=0A</g>=
=0A<g >=0A<title>kmem_cache_free (40 samples, 0.01%)</title><rect x=3D"1187=
=2E9" y=3D"453" width=3D"0.2" height=3D"15.0" fill=3D"rgb(248,1,26)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1190.89" y=3D"463.5" ></text>=0A</g>=0A<g >=0A=
<title>secondary_startup_64_no_verify (3,380 samples, 1.16%)</title><rect x=
=3D"1176.3" y=3D"709" width=3D"13.7" height=3D"15.0" fill=3D"rgb(231,223,10=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.27" y=3D"719.5" ></text>=0A</g>=
=0A<g >=0A<title>check_preemption_disabled (75 samples, 0.03%)</title><rect=
 x=3D"825.7" y=3D"325" width=3D"0.3" height=3D"15.0" fill=3D"rgb(206,21,0)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"828.69" y=3D"335.5" ></text>=0A</g>=0A<=
g >=0A<title>tick_sched_do_timer (26 samples, 0.01%)</title><rect x=3D"582.=
9" y=3D"389" width=3D"0.1" height=3D"15.0" fill=3D"rgb(232,111,32)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"585.93" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<t=
itle>netif_receive_skb_list_internal (45,815 samples, 15.77%)</title><rect =
x=3D"698.9" y=3D"485" width=3D"186.0" height=3D"15.0" fill=3D"rgb(221,221,7=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"701.90" y=3D"495.5" >netif_receive_sk=
b_list_i..</text>=0A</g>=0A<g >=0A<title>intel_iommu_map_pages (117 samples=
, 0.04%)</title><rect x=3D"1174.9" y=3D"181" width=3D"0.5" height=3D"15.0" =
fill=3D"rgb(222,27,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.93" y=3D"19=
1.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (37 sample=
s, 0.01%)</title><rect x=3D"1027.3" y=3D"517" width=3D"0.2" height=3D"15.0"=
 fill=3D"rgb(216,77,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.34" y=3D"5=
27.5" ></text>=0A</g>=0A<g >=0A<title>cpuidle_enter_state (3,226 samples, 1=
=2E11%)</title><rect x=3D"1176.3" y=3D"629" width=3D"13.1" height=3D"15.0" =
fill=3D"rgb(245,158,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.30" y=3D"63=
9.5" ></text>=0A</g>=0A<g >=0A<title>consume_skb (822 samples, 0.28%)</titl=
e><rect x=3D"1184.2" y=3D"453" width=3D"3.3" height=3D"15.0" fill=3D"rgb(22=
0,156,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1187.20" y=3D"463.5" ></text>=
=0A</g>=0A<g >=0A<title>hrtimer_interrupt (36 samples, 0.01%)</title><rect =
x=3D"1027.3" y=3D"485" width=3D"0.2" height=3D"15.0" fill=3D"rgb(239,112,9)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.34" y=3D"495.5" ></text>=0A</g>=
=0A<g >=0A<title>__list_add_valid (48 samples, 0.02%)</title><rect x=3D"697=
=2E5" y=3D"485" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,39,19)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"700.47" y=3D"495.5" ></text>=0A</g>=0A<g >=0A=
<title>tcp_in_window (1,453 samples, 0.50%)</title><rect x=3D"870.1" y=3D"3=
57" width=3D"5.9" height=3D"15.0" fill=3D"rgb(213,46,8)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"873.06" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>efx_fa=
st_push_rx_descriptors (51 samples, 0.02%)</title><rect x=3D"1188.4" y=3D"5=
01" width=3D"0.2" height=3D"15.0" fill=3D"rgb(209,123,13)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1191.38" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>val=
idate_xmit_skb_list (25 samples, 0.01%)</title><rect x=3D"15.4" y=3D"373" w=
idth=3D"0.1" height=3D"15.0" fill=3D"rgb(229,225,36)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"18.42" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>sch_direc=
t_xmit (7,711 samples, 2.65%)</title><rect x=3D"15.5" y=3D"437" width=3D"31=
=2E3" height=3D"15.0" fill=3D"rgb(208,161,31)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"18.52" y=3D"447.5" >sc..</text>=0A</g>=0A<g >=0A<title>__rcu_read_un=
lock (110 samples, 0.04%)</title><rect x=3D"715.9" y=3D"421" width=3D"0.5" =
height=3D"15.0" fill=3D"rgb(238,102,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"718.94" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__inet_lookup_establis=
hed (72 samples, 0.02%)</title><rect x=3D"738.5" y=3D"341" width=3D"0.3" he=
ight=3D"15.0" fill=3D"rgb(246,147,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"74=
1.52" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>gro_pull_from_frag0 (53 s=
amples, 0.02%)</title><rect x=3D"1181.3" y=3D"437" width=3D"0.2" height=3D"=
15.0" fill=3D"rgb(245,178,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1184.26" =
y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>nf_ip_checksum (95 samples, 0.0=
3%)</title><rect x=3D"869.7" y=3D"357" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(248,169,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"872.67" y=3D"367.5" =
></text>=0A</g>=0A<g >=0A<title>ret_from_fork (278,126 samples, 95.71%)</ti=
tle><rect x=3D"46.8" y=3D"709" width=3D"1129.5" height=3D"15.0" fill=3D"rgb=
(225,187,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"49.84" y=3D"719.5" >ret_fr=
om_fork</text>=0A</g>=0A<g >=0A<title>scheduler_tick (118 samples, 0.04%)</=
title><rect x=3D"157.5" y=3D"437" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(217,79,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.45" y=3D"447.5" ></text=
>=0A</g>=0A<g >=0A<title>common_interrupt (134 samples, 0.05%)</title><rect=
 x=3D"1189.4" y=3D"581" width=3D"0.6" height=3D"15.0" fill=3D"rgb(227,90,37=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.44" y=3D"591.5" ></text>=0A</g>=
=0A<g >=0A<title>__efx_enqueue_skb (424 samples, 0.15%)</title><rect x=3D"7=
97.4" y=3D"181" width=3D"1.7" height=3D"15.0" fill=3D"rgb(237,194,1)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"800.38" y=3D"191.5" ></text>=0A</g>=0A<g >=0A=
<title>__list_del_entry_valid (61 samples, 0.02%)</title><rect x=3D"703.6" =
y=3D"453" width=3D"0.3" height=3D"15.0" fill=3D"rgb(252,142,9)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"706.62" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title=
>__qdisc_run (7,711 samples, 2.65%)</title><rect x=3D"15.5" y=3D"453" width=
=3D"31.3" height=3D"15.0" fill=3D"rgb(211,53,22)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"18.52" y=3D"463.5" >__..</text>=0A</g>=0A<g >=0A<title>hrtimer_in=
terrupt (221 samples, 0.08%)</title><rect x=3D"318.6" y=3D"469" width=3D"0.=
9" height=3D"15.0" fill=3D"rgb(237,179,4)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"321.56" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>gro_pull_from_frag0=
 (25,287 samples, 8.70%)</title><rect x=3D"886.8" y=3D"517" width=3D"102.6"=
 height=3D"15.0" fill=3D"rgb(211,57,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"889.76" y=3D"527.5" >gro_pull_fro..</text>=0A</g>=0A<g >=0A<title>ip_local=
_out (403 samples, 0.14%)</title><rect x=3D"794.5" y=3D"277" width=3D"1.7" =
height=3D"15.0" fill=3D"rgb(208,152,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"797.53" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__siphash_unaligned (1=
,036 samples, 0.36%)</title><rect x=3D"858.2" y=3D"357" width=3D"4.2" heigh=
t=3D"15.0" fill=3D"rgb(241,119,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"861.1=
8" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>netif_receive_skb_list_inter=
nal (140 samples, 0.05%)</title><rect x=3D"1180.7" y=3D"405" width=3D"0.5" =
height=3D"15.0" fill=3D"rgb(246,0,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
183.68" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (55 s=
amples, 0.02%)</title><rect x=3D"730.0" y=3D"373" width=3D"0.2" height=3D"1=
5.0" fill=3D"rgb(215,138,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"732.98" y=
=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>trigger_load_balance (26 samples=
, 0.01%)</title><rect x=3D"656.0" y=3D"341" width=3D"0.1" height=3D"15.0" f=
ill=3D"rgb(242,44,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"659.00" y=3D"351.=
5" ></text>=0A</g>=0A<g >=0A<title>nft_do_chain (165 samples, 0.06%)</title=
><rect x=3D"795.5" y=3D"213" width=3D"0.7" height=3D"15.0" fill=3D"rgb(237,=
62,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"798.49" y=3D"223.5" ></text>=0A<=
/g>=0A<g >=0A<title>update_process_times (152 samples, 0.05%)</title><rect =
x=3D"318.8" y=3D"405" width=3D"0.6" height=3D"15.0" fill=3D"rgb(219,94,43)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.78" y=3D"415.5" ></text>=0A</g>=0A<=
g >=0A<title>nf_hook_slow (184 samples, 0.06%)</title><rect x=3D"61.9" y=3D=
"437" width=3D"0.7" height=3D"15.0" fill=3D"rgb(222,111,33)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"64.89" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>sys=
vec_apic_timer_interrupt (39 samples, 0.01%)</title><rect x=3D"839.5" y=3D"=
309" width=3D"0.2" height=3D"15.0" fill=3D"rgb(228,164,15)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"842.52" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__h=
rtimer_run_queues (224 samples, 0.08%)</title><rect x=3D"157.1" y=3D"501" w=
idth=3D"0.9" height=3D"15.0" fill=3D"rgb(213,27,6)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"160.13" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_=
64 (9,071 samples, 3.12%)</title><rect x=3D"10.0" y=3D"661" width=3D"36.8" =
height=3D"15.0" fill=3D"rgb(229,113,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"13.00" y=3D"671.5" >do_..</text>=0A</g>=0A<g >=0A<title>efx_tx_send_pendin=
g (51 samples, 0.02%)</title><rect x=3D"798.9" y=3D"165" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(228,30,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"801.=
89" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>sock_read_iter (9,071 sampl=
es, 3.12%)</title><rect x=3D"10.0" y=3D"597" width=3D"36.8" height=3D"15.0"=
 fill=3D"rgb(221,130,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"60=
7.5" >soc..</text>=0A</g>=0A<g >=0A<title>tcp_v4_do_rcv (2,995 samples, 1.0=
3%)</title><rect x=3D"791.7" y=3D"341" width=3D"12.2" height=3D"15.0" fill=
=3D"rgb(225,167,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"794.69" y=3D"351.5"=
 ></text>=0A</g>=0A<g >=0A<title>nf_hook_slow (27 samples, 0.01%)</title><r=
ect x=3D"1181.0" y=3D"309" width=3D"0.1" height=3D"15.0" fill=3D"rgb(205,10=
,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.98" y=3D"319.5" ></text>=0A</=
g>=0A<g >=0A<title>efx_features_check (166 samples, 0.06%)</title><rect x=
=3D"46.2" y=3D"373" width=3D"0.6" height=3D"15.0" fill=3D"rgb(211,146,50)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"49.16" y=3D"383.5" ></text>=0A</g>=0A<g =
>=0A<title>tick_sched_timer (58 samples, 0.02%)</title><rect x=3D"1055.4" y=
=3D"453" width=3D"0.2" height=3D"15.0" fill=3D"rgb(224,199,19)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1058.40" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<titl=
e>update_process_times (29 samples, 0.01%)</title><rect x=3D"775.4" y=3D"14=
9" width=3D"0.1" height=3D"15.0" fill=3D"rgb(227,115,5)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"778.37" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>ip_loc=
al_deliver_finish (366 samples, 0.13%)</title><rect x=3D"59.7" y=3D"421" wi=
dth=3D"1.5" height=3D"15.0" fill=3D"rgb(205,214,12)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"62.68" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>netif_skb=
_features (166 samples, 0.06%)</title><rect x=3D"46.2" y=3D"389" width=3D"0=
=2E6" height=3D"15.0" fill=3D"rgb(229,200,43)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"49.16" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>nf_nat_ipv4_fn (7=
9 samples, 0.03%)</title><rect x=3D"880.1" y=3D"373" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(246,229,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"883.1=
4" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (42 sam=
ples, 0.01%)</title><rect x=3D"775.3" y=3D"197" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(226,184,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.32" y=3D=
"207.5" ></text>=0A</g>=0A<g >=0A<title>__napi_poll (134 samples, 0.05%)</t=
itle><rect x=3D"1189.4" y=3D"517" width=3D"0.6" height=3D"15.0" fill=3D"rgb=
(226,140,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.44" y=3D"527.5" ></te=
xt>=0A</g>=0A<g >=0A<title>sch_direct_xmit (1,360 samples, 0.47%)</title><r=
ect x=3D"10.0" y=3D"389" width=3D"5.5" height=3D"15.0" fill=3D"rgb(235,135,=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"399.5" ></text>=0A</g>=
=0A<g >=0A<title>poll_idle (128 samples, 0.04%)</title><rect x=3D"1188.9" y=
=3D"613" width=3D"0.5" height=3D"15.0" fill=3D"rgb(239,16,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1191.88" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<titl=
e>tick_sched_handle.isra.23 (163 samples, 0.06%)</title><rect x=3D"493.5" y=
=3D"405" width=3D"0.6" height=3D"15.0" fill=3D"rgb(229,100,5)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"496.47" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title=
>update_process_times (65 samples, 0.02%)</title><rect x=3D"695.5" y=3D"341=
" width=3D"0.2" height=3D"15.0" fill=3D"rgb(206,155,22)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"698.48" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__sysv=
ec_apic_timer_interrupt (75 samples, 0.03%)</title><rect x=3D"251.6" y=3D"5=
01" width=3D"0.3" height=3D"15.0" fill=3D"rgb(238,18,4)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"254.61" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>tcp_qu=
eue_rcv (248 samples, 0.09%)</title><rect x=3D"802.8" y=3D"309" width=3D"1.=
0" height=3D"15.0" fill=3D"rgb(206,12,41)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"805.81" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__sk_defer_free_flu=
sh (10,241 samples, 3.52%)</title><rect x=3D"738.8" y=3D"341" width=3D"41.6=
" height=3D"15.0" fill=3D"rgb(206,60,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"741.81" y=3D"351.5" >__s..</text>=0A</g>=0A<g >=0A<title>run_ksoftirqd (27=
8,073 samples, 95.70%)</title><rect x=3D"47.1" y=3D"661" width=3D"1129.2" h=
eight=3D"15.0" fill=3D"rgb(207,193,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"5=
0.05" y=3D"671.5" >run_ksoftirqd</text>=0A</g>=0A<g >=0A<title>dev_gro_rece=
ive (89 samples, 0.03%)</title><rect x=3D"1177.6" y=3D"469" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(219,27,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
180.63" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>___slab_alloc (258 samp=
les, 0.09%)</title><rect x=3D"354.8" y=3D"437" width=3D"1.0" height=3D"15.0=
" fill=3D"rgb(209,206,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"357.75" y=3D"=
447.5" ></text>=0A</g>=0A<g >=0A<title>iommu_get_dma_domain (127 samples, 0=
=2E04%)</title><rect x=3D"35.6" y=3D"341" width=3D"0.5" height=3D"15.0" fil=
l=3D"rgb(221,196,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.60" y=3D"351.5"=
 ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (216 samples=
, 0.07%)</title><rect x=3D"655.3" y=3D"437" width=3D"0.9" height=3D"15.0" f=
ill=3D"rgb(236,224,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"658.29" y=3D"447.=
5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (70 samples, 0.02%)</ti=
tle><rect x=3D"1093.0" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
206,224,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.97" y=3D"495.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__tcp_transmit_skb (1,360 samples, 0.47%)</title>=
<rect x=3D"10.0" y=3D"485" width=3D"5.5" height=3D"15.0" fill=3D"rgb(221,17=
2,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"495.5" ></text>=0A</g=
>=0A<g >=0A<title>efx_tx_map_chunk (42 samples, 0.01%)</title><rect x=3D"13=
=2E4" y=3D"325" width=3D"0.2" height=3D"15.0" fill=3D"rgb(238,61,29)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"16.42" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<=
title>__wake_up_common (45 samples, 0.02%)</title><rect x=3D"801.0" y=3D"27=
7" width=3D"0.2" height=3D"15.0" fill=3D"rgb(228,25,2)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"804.01" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>ip_rcv_=
finish_core.isra.22 (67 samples, 0.02%)</title><rect x=3D"59.4" y=3D"453" w=
idth=3D"0.2" height=3D"15.0" fill=3D"rgb(215,77,52)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"62.35" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer=
_run_queues (150 samples, 0.05%)</title><rect x=3D"1008.4" y=3D"485" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(237,189,54)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1011.36" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_api=
c_timer_interrupt (264 samples, 0.09%)</title><rect x=3D"493.2" y=3D"469" w=
idth=3D"1.0" height=3D"15.0" fill=3D"rgb(211,210,41)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"496.16" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>___slab_=
alloc (145 samples, 0.05%)</title><rect x=3D"345.3" y=3D"421" width=3D"0.5"=
 height=3D"15.0" fill=3D"rgb(232,213,14)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"348.26" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__kfree_skb (9,200 =
samples, 3.17%)</title><rect x=3D"741.6" y=3D"325" width=3D"37.3" height=3D=
"15.0" fill=3D"rgb(212,124,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"744.56" =
y=3D"335.5" >__k..</text>=0A</g>=0A<g >=0A<title>task_tick_fair (29 samples=
, 0.01%)</title><rect x=3D"583.4" y=3D"341" width=3D"0.1" height=3D"15.0" f=
ill=3D"rgb(220,178,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.41" y=3D"351=
=2E5" ></text>=0A</g>=0A<g >=0A<title>tcp_v4_rcv (350 samples, 0.12%)</titl=
e><rect x=3D"59.7" y=3D"389" width=3D"1.5" height=3D"15.0" fill=3D"rgb(231,=
107,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.75" y=3D"399.5" ></text>=0A<=
/g>=0A<g >=0A<title>_raw_spin_lock_irqsave (116 samples, 0.04%)</title><rec=
t x=3D"34.9" y=3D"293" width=3D"0.4" height=3D"15.0" fill=3D"rgb(216,190,3)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"37.85" y=3D"303.5" ></text>=0A</g>=0A<=
g >=0A<title>__rcu_read_unlock (40 samples, 0.01%)</title><rect x=3D"55.4" =
y=3D"533" width=3D"0.2" height=3D"15.0" fill=3D"rgb(247,83,30)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"58.41" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>=
efx_poll (124 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"501" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(205,141,25)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1191.88" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>tcp4_gro_complet=
e (176 samples, 0.06%)</title><rect x=3D"884.9" y=3D"485" width=3D"0.8" hei=
ght=3D"15.0" fill=3D"rgb(231,118,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"88=
7.95" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>intel_iommu_map_pages (1,=
469 samples, 0.51%)</title><rect x=3D"25.3" y=3D"293" width=3D"5.9" height=
=3D"15.0" fill=3D"rgb(239,61,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.27"=
 y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>hash_conntrack_raw (1,213 samp=
les, 0.42%)</title><rect x=3D"857.5" y=3D"373" width=3D"4.9" height=3D"15.0=
" fill=3D"rgb(227,7,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"860.46" y=3D"383=
=2E5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (90 s=
amples, 0.03%)</title><rect x=3D"1055.3" y=3D"533" width=3D"0.4" height=3D"=
15.0" fill=3D"rgb(252,79,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1058.32" y=
=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_map_page (119 samples,=
 0.04%)</title><rect x=3D"1168.6" y=3D"549" width=3D"0.5" height=3D"15.0" f=
ill=3D"rgb(238,216,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.63" y=3D"55=
9.5" ></text>=0A</g>=0A<g >=0A<title>nf_hook_slow (38 samples, 0.01%)</titl=
e><rect x=3D"1181.1" y=3D"325" width=3D"0.1" height=3D"15.0" fill=3D"rgb(24=
2,136,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1184.09" y=3D"335.5" ></text>=
=0A</g>=0A<g >=0A<title>trigger_load_balance (25 samples, 0.01%)</title><re=
ct x=3D"319.3" y=3D"389" width=3D"0.1" height=3D"15.0" fill=3D"rgb(237,203,=
8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"322.29" y=3D"399.5" ></text>=0A</g>=
=0A<g >=0A<title>ip_local_deliver_finish (45 samples, 0.02%)</title><rect x=
=3D"1180.8" y=3D"309" width=3D"0.2" height=3D"15.0" fill=3D"rgb(240,144,40)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.80" y=3D"319.5" ></text>=0A</g>=
=0A<g >=0A<title>check_preemption_disabled (55 samples, 0.02%)</title><rect=
 x=3D"708.2" y=3D"437" width=3D"0.3" height=3D"15.0" fill=3D"rgb(217,198,15=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"711.24" y=3D"447.5" ></text>=0A</g>=
=0A<g >=0A<title>clflush_cache_range (435 samples, 0.15%)</title><rect x=3D=
"27.9" y=3D"261" width=3D"1.7" height=3D"15.0" fill=3D"rgb(208,34,15)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"30.87" y=3D"271.5" ></text>=0A</g>=0A<g >=
=0A<title>hrtimer_interrupt (277 samples, 0.10%)</title><rect x=3D"157.0" y=
=3D"517" width=3D"1.1" height=3D"15.0" fill=3D"rgb(243,82,10)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"160.02" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title=
>__hrtimer_run_queues (34 samples, 0.01%)</title><rect x=3D"755.3" y=3D"229=
" width=3D"0.1" height=3D"15.0" fill=3D"rgb(231,171,13)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"758.28" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>inet_e=
hashfn (28 samples, 0.01%)</title><rect x=3D"738.7" y=3D"325" width=3D"0.1"=
 height=3D"15.0" fill=3D"rgb(208,148,51)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"741.70" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>nft_do_chain_ipv4 (=
6,935 samples, 2.39%)</title><rect x=3D"811.5" y=3D"373" width=3D"28.2" hei=
ght=3D"15.0" fill=3D"rgb(253,188,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"81=
4.52" y=3D"383.5" >n..</text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra=
=2E23 (46 samples, 0.02%)</title><rect x=3D"251.7" y=3D"437" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(247,209,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"254.70" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>nf_ct_get_tuple_ports.=
isra.39 (90 samples, 0.03%)</title><rect x=3D"877.3" y=3D"357" width=3D"0.3=
" height=3D"15.0" fill=3D"rgb(234,133,25)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"880.27" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>__list_del_entry_va=
lid (75 samples, 0.03%)</title><rect x=3D"715.4" y=3D"421" width=3D"0.3" he=
ight=3D"15.0" fill=3D"rgb(222,134,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71=
8.37" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_all (140 samp=
les, 0.05%)</title><rect x=3D"741.6" y=3D"309" width=3D"0.6" height=3D"15.0=
" fill=3D"rgb(249,5,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"744.59" y=3D"31=
9.5" ></text>=0A</g>=0A<g >=0A<title>asm_common_interrupt (124 samples, 0.0=
4%)</title><rect x=3D"1188.9" y=3D"597" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(243,62,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.88" y=3D"607.5"=
 ></text>=0A</g>=0A<g >=0A<title>sch_direct_xmit (436 samples, 0.15%)</titl=
e><rect x=3D"1174.5" y=3D"325" width=3D"1.8" height=3D"15.0" fill=3D"rgb(21=
5,74,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"335.5" ></text>=
=0A</g>=0A<g >=0A<title>efx_poll (2,890 samples, 0.99%)</title><rect x=3D"1=
177.1" y=3D"517" width=3D"11.7" height=3D"15.0" fill=3D"rgb(215,36,36)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1180.11" y=3D"527.5" ></text>=0A</g>=0A<g =
>=0A<title>ip_sublist_rcv (41,971 samples, 14.44%)</title><rect x=3D"713.4"=
 y=3D"437" width=3D"170.4" height=3D"15.0" fill=3D"rgb(238,1,42)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"716.41" y=3D"447.5" >ip_sublist_rcv</text>=0A</g>=
=0A<g >=0A<title>nft_do_chain (412 samples, 0.14%)</title><rect x=3D"882.2"=
 y=3D"373" width=3D"1.6" height=3D"15.0" fill=3D"rgb(237,106,28)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"885.17" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__rcu_read_lock (42 samples, 0.01%)</title><rect x=3D"728.9" y=3D"389" w=
idth=3D"0.2" height=3D"15.0" fill=3D"rgb(236,102,23)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"731.91" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysv=
ec_apic_timer_interrupt (91 samples, 0.03%)</title><rect x=3D"989.1" y=3D"5=
01" width=3D"0.3" height=3D"15.0" fill=3D"rgb(247,141,46)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"992.08" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>ip_s=
ublist_rcv (822 samples, 0.28%)</title><rect x=3D"59.3" y=3D"469" width=3D"=
3.3" height=3D"15.0" fill=3D"rgb(247,155,53)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"62.29" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>skb_gro_receive (1=
35 samples, 0.05%)</title><rect x=3D"58.4" y=3D"501" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(248,98,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.45"=
 y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>strncpy (47 samples, 0.02%)</t=
itle><rect x=3D"61.7" y=3D"373" width=3D"0.1" height=3D"15.0" fill=3D"rgb(2=
07,226,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.65" y=3D"383.5" ></text>=
=0A</g>=0A<g >=0A<title>__efx_rx_packet (192,754 samples, 66.33%)</title><r=
ect x=3D"225.5" y=3D"549" width=3D"782.8" height=3D"15.0" fill=3D"rgb(218,2=
4,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"228.51" y=3D"559.5" >__efx_rx_pac=
ket</text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (77 samples, =
0.03%)</title><rect x=3D"251.6" y=3D"517" width=3D"0.3" height=3D"15.0" fil=
l=3D"rgb(231,164,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"254.61" y=3D"527.5=
" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (194 samples,=
 0.07%)</title><rect x=3D"1008.3" y=3D"533" width=3D"0.8" height=3D"15.0" f=
ill=3D"rgb(209,152,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.27" y=3D"54=
3.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (53 samples,=
 0.02%)</title><rect x=3D"989.2" y=3D"405" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(216,157,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.20" y=3D"415.=
5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (124 samples, 0.04%)</=
title><rect x=3D"868.2" y=3D"341" width=3D"0.5" height=3D"15.0" fill=3D"rgb=
(230,127,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"871.19" y=3D"351.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__dev_flush (211 samples, 0.07%)</title><rect x=
=3D"1173.6" y=3D"565" width=3D"0.9" height=3D"15.0" fill=3D"rgb(221,123,27)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1176.63" y=3D"575.5" ></text>=0A</g>=
=0A<g >=0A<title>__tcp_send_ack.part.58 (74 samples, 0.03%)</title><rect x=
=3D"793.7" y=3D"309" width=3D"0.3" height=3D"15.0" fill=3D"rgb(227,47,26)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"796.65" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>pollwake (35 samples, 0.01%)</title><rect x=3D"801.1" y=3D"261"=
 width=3D"0.1" height=3D"15.0" fill=3D"rgb(234,145,52)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"804.05" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__netif=
_receive_skb_core (1,133 samples, 0.39%)</title><rect x=3D"703.9" y=3D"453"=
 width=3D"4.6" height=3D"15.0" fill=3D"rgb(240,45,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"706.87" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>[unknown=
] (9,071 samples, 3.12%)</title><rect x=3D"10.0" y=3D"709" width=3D"36.8" h=
eight=3D"15.0" fill=3D"rgb(226,164,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
13.00" y=3D"719.5" >[un..</text>=0A</g>=0A<g >=0A<title>asm_common_interrup=
t (134 samples, 0.05%)</title><rect x=3D"1189.4" y=3D"597" width=3D"0.6" he=
ight=3D"15.0" fill=3D"rgb(224,8,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"119=
2.44" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_data (505 sam=
ples, 0.17%)</title><rect x=3D"1185.5" y=3D"437" width=3D"2.0" height=3D"15=
=2E0" fill=3D"rgb(214,147,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1188.48" =
y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>try_to_wake_up (31 samples, 0.0=
1%)</title><rect x=3D"801.1" y=3D"245" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(232,79,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"804.07" y=3D"255.5" =
></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (45 samples, 0.02=
%)</title><rect x=3D"1008.0" y=3D"405" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(206,141,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.02" y=3D"415.5=
" ></text>=0A</g>=0A<g >=0A<title>ipv4_conntrack_defrag (391 samples, 0.13%=
)</title><rect x=3D"842.8" y=3D"389" width=3D"1.6" height=3D"15.0" fill=3D"=
rgb(246,222,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"845.78" y=3D"399.5" ></=
text>=0A</g>=0A<g >=0A<title>tcp_rcv_established (1,360 samples, 0.47%)</ti=
tle><rect x=3D"10.0" y=3D"501" width=3D"5.5" height=3D"15.0" fill=3D"rgb(21=
4,211,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>iommu_dma_alloc_iova.isra.28 (359 samples, 0.12%)</=
title><rect x=3D"34.0" y=3D"325" width=3D"1.4" height=3D"15.0" fill=3D"rgb(=
205,183,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"36.98" y=3D"335.5" ></text>=
=0A</g>=0A<g >=0A<title>efx_tx_map_data (295 samples, 0.10%)</title><rect x=
=3D"1174.7" y=3D"277" width=3D"1.2" height=3D"15.0" fill=3D"rgb(238,206,10)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.66" y=3D"287.5" ></text>=0A</g>=
=0A<g >=0A<title>tick_sched_handle.isra.23 (130 samples, 0.04%)</title><rec=
t x=3D"655.6" y=3D"373" width=3D"0.5" height=3D"15.0" fill=3D"rgb(238,106,4=
2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"658.58" y=3D"383.5" ></text>=0A</g>=
=0A<g >=0A<title>tick_sched_handle.isra.23 (172 samples, 0.06%)</title><rec=
t x=3D"157.3" y=3D"469" width=3D"0.7" height=3D"15.0" fill=3D"rgb(248,55,54=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.34" y=3D"479.5" ></text>=0A</g>=
=0A<g >=0A<title>kmem_cache_free (281 samples, 0.10%)</title><rect x=3D"779=
=2E3" y=3D"325" width=3D"1.1" height=3D"15.0" fill=3D"rgb(205,3,25)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"782.25" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<=
title>sysvec_apic_timer_interrupt (54 samples, 0.02%)</title><rect x=3D"775=
=2E3" y=3D"245" width=3D"0.2" height=3D"15.0" fill=3D"rgb(247,130,4)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"778.30" y=3D"255.5" ></text>=0A</g>=0A<g >=0A=
<title>nf_conntrack_in (149 samples, 0.05%)</title><rect x=3D"61.9" y=3D"42=
1" width=3D"0.6" height=3D"15.0" fill=3D"rgb(218,102,3)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"64.93" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_r=
ead_lock (40 samples, 0.01%)</title><rect x=3D"855.9" y=3D"357" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(232,187,21)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"858.89" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_do_timer=
 (30 samples, 0.01%)</title><rect x=3D"157.2" y=3D"469" width=3D"0.1" heigh=
t=3D"15.0" fill=3D"rgb(235,229,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.=
22" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (28 samples,=
 0.01%)</title><rect x=3D"1008.0" y=3D"373" width=3D"0.2" height=3D"15.0" f=
ill=3D"rgb(233,73,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.04" y=3D"383.=
5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (51 samples, 0.02%)=
</title><rect x=3D"1093.0" y=3D"453" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(226,121,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1096.04" y=3D"463.5" ><=
/text>=0A</g>=0A<g >=0A<title>read (9,071 samples, 3.12%)</title><rect x=3D=
"10.0" y=3D"693" width=3D"36.8" height=3D"15.0" fill=3D"rgb(221,125,9)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"703.5" >read</text>=0A</g>=0A<=
g >=0A<title>timekeeping_advance (32 samples, 0.01%)</title><rect x=3D"493.=
3" y=3D"373" width=3D"0.2" height=3D"15.0" fill=3D"rgb(214,170,27)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"496.34" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<t=
itle>tick_sched_timer (39 samples, 0.01%)</title><rect x=3D"775.3" y=3D"181=
" width=3D"0.2" height=3D"15.0" fill=3D"rgb(219,188,9)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"778.33" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>skb_rel=
ease_head_state (114 samples, 0.04%)</title><rect x=3D"741.7" y=3D"293" wid=
th=3D"0.5" height=3D"15.0" fill=3D"rgb(224,140,1)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"744.70" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>tcp_mstamp_r=
efresh (183 samples, 0.06%)</title><rect x=3D"802.1" y=3D"309" width=3D"0.7=
" height=3D"15.0" fill=3D"rgb(223,5,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"805.06" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>nf_nat_ipv4_pre_routin=
g (899 samples, 0.31%)</title><rect x=3D"877.6" y=3D"389" width=3D"3.7" hei=
ght=3D"15.0" fill=3D"rgb(205,128,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"88=
0.63" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (106 sampl=
es, 0.04%)</title><rect x=3D"493.6" y=3D"373" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(248,201,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.58" y=3D"3=
83.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_dma_unmap (64 samples, 0.02%)=
</title><rect x=3D"1169.1" y=3D"549" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(221,135,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1172.12" y=3D"559.5" ><=
/text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (48 samples, 0.02%)</tit=
le><rect x=3D"318.9" y=3D"373" width=3D"0.2" height=3D"15.0" fill=3D"rgb(22=
6,119,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.92" y=3D"383.5" ></text>=
=0A</g>=0A<g >=0A<title>scheduler_tick (90 samples, 0.03%)</title><rect x=
=3D"583.2" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(221,228,7)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.19" y=3D"367.5" ></text>=0A</g>=0A<g=
 >=0A<title>napi_gro_frags (160,500 samples, 55.23%)</title><rect x=3D"356.=
5" y=3D"533" width=3D"651.8" height=3D"15.0" fill=3D"rgb(214,32,13)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"359.48" y=3D"543.5" >napi_gro_frags</text>=0A<=
/g>=0A<g >=0A<title>scheduler_tick (29 samples, 0.01%)</title><rect x=3D"10=
55.5" y=3D"405" width=3D"0.1" height=3D"15.0" fill=3D"rgb(254,56,37)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"1058.48" y=3D"415.5" ></text>=0A</g>=0A<g >=
=0A<title>sysvec_apic_timer_interrupt (100 samples, 0.03%)</title><rect x=
=3D"1092.9" y=3D"549" width=3D"0.4" height=3D"15.0" fill=3D"rgb(232,52,22)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.88" y=3D"559.5" ></text>=0A</g>=0A=
<g >=0A<title>ip_sublist_rcv (27 samples, 0.01%)</title><rect x=3D"1189.8" =
y=3D"341" width=3D"0.1" height=3D"15.0" fill=3D"rgb(224,130,40)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1192.78" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<tit=
le>nf_conntrack_in (29 samples, 0.01%)</title><rect x=3D"1181.1" y=3D"309" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(247,1,9)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1184.11" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>cpu_startu=
p_entry (3,379 samples, 1.16%)</title><rect x=3D"1176.3" y=3D"677" width=3D=
"13.7" height=3D"15.0" fill=3D"rgb(251,23,8)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1179.28" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_=
timer_interrupt (303 samples, 0.10%)</title><rect x=3D"156.9" y=3D"565" wid=
th=3D"1.3" height=3D"15.0" fill=3D"rgb(231,130,16)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"159.95" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>napi_reuse_=
skb.isra.40 (56 samples, 0.02%)</title><rect x=3D"64.2" y=3D"549" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(210,75,47)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"67.18" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (1=
98 samples, 0.07%)</title><rect x=3D"582.9" y=3D"405" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(232,120,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"585.8=
9" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (44 sam=
ples, 0.02%)</title><rect x=3D"1008.0" y=3D"389" width=3D"0.2" height=3D"15=
=2E0" fill=3D"rgb(216,17,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.02" y=
=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>tcp4_gro_receive (2,476 samples,=
 0.85%)</title><rect x=3D"583.8" y=3D"485" width=3D"10.1" height=3D"15.0" f=
ill=3D"rgb(239,65,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.80" y=3D"495.=
5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (209 samples, 0.07%)</t=
itle><rect x=3D"493.3" y=3D"421" width=3D"0.8" height=3D"15.0" fill=3D"rgb(=
209,115,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.29" y=3D"431.5" ></text=
>=0A</g>=0A<g >=0A<title>scheduler_tick (34 samples, 0.01%)</title><rect x=
=3D"1093.1" y=3D"437" width=3D"0.1" height=3D"15.0" fill=3D"rgb(212,98,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1096.08" y=3D"447.5" ></text>=0A</g>=0A=
<g >=0A<title>ksize (46 samples, 0.02%)</title><rect x=3D"348.7" y=3D"469" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(214,62,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"351.72" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>tcp_v4_d=
o_rcv (1,360 samples, 0.47%)</title><rect x=3D"10.0" y=3D"517" width=3D"5.5=
" height=3D"15.0" fill=3D"rgb(220,1,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"13.00" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_map (1,776 samp=
les, 0.61%)</title><rect x=3D"24.5" y=3D"309" width=3D"7.2" height=3D"15.0"=
 fill=3D"rgb(252,69,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"27.51" y=3D"319.=
5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (277 sam=
ples, 0.10%)</title><rect x=3D"582.7" y=3D"485" width=3D"1.1" height=3D"15.=
0" fill=3D"rgb(245,207,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"585.67" y=3D"=
495.5" ></text>=0A</g>=0A<g >=0A<title>__napi_schedule (96 samples, 0.03%)<=
/title><rect x=3D"1176.6" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"r=
gb(209,60,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.56" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>nf_ct_acct_add (71 samples, 0.02%)</title><rect =
x=3D"869.4" y=3D"357" width=3D"0.3" height=3D"15.0" fill=3D"rgb(242,12,31)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"872.38" y=3D"367.5" ></text>=0A</g>=0A<=
g >=0A<title>_iommu_map (2,422 samples, 0.83%)</title><rect x=3D"24.1" y=3D=
"325" width=3D"9.9" height=3D"15.0" fill=3D"rgb(211,69,19)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"27.14" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>tick=
_sched_timer (60 samples, 0.02%)</title><rect x=3D"251.6" y=3D"453" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(217,164,40)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"254.65" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__napi_alloc_=
skb (28 samples, 0.01%)</title><rect x=3D"1179.8" y=3D"421" width=3D"0.1" h=
eight=3D"15.0" fill=3D"rgb(221,59,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
182.79" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__inet_lookup_establish=
ed (1,059 samples, 0.36%)</title><rect x=3D"722.0" y=3D"389" width=3D"4.3" =
height=3D"15.0" fill=3D"rgb(251,54,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
725.02" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>__local_bh_enable_ip (7=
1 samples, 0.02%)</title><rect x=3D"822.2" y=3D"341" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(213,107,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"825.2=
0" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>napi_gro_frags (63 samples, =
0.02%)</title><rect x=3D"1189.0" y=3D"437" width=3D"0.3" height=3D"15.0" fi=
ll=3D"rgb(248,0,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.05" y=3D"447.5=
" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (269 samples,=
 0.09%)</title><rect x=3D"582.7" y=3D"469" width=3D"1.1" height=3D"15.0" fi=
ll=3D"rgb(244,89,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"585.70" y=3D"479.5=
" ></text>=0A</g>=0A<g >=0A<title>nf_conntrack_in (135 samples, 0.05%)</tit=
le><rect x=3D"794.8" y=3D"229" width=3D"0.5" height=3D"15.0" fill=3D"rgb(25=
0,128,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.76" y=3D"239.5" ></text>=
=0A</g>=0A<g >=0A<title>__iommu_map (143 samples, 0.05%)</title><rect x=3D"=
797.8" y=3D"85" width=3D"0.5" height=3D"15.0" fill=3D"rgb(251,85,30)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"800.76" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<=
title>__ksize (839 samples, 0.29%)</title><rect x=3D"335.1" y=3D"469" width=
=3D"3.4" height=3D"15.0" fill=3D"rgb(205,100,32)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"338.06" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (1=
35 samples, 0.05%)</title><rect x=3D"1189.4" y=3D"629" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(216,137,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.=
44" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>napi_gro_frags (2,721 sampl=
es, 0.94%)</title><rect x=3D"53.4" y=3D"565" width=3D"11.0" height=3D"15.0"=
 fill=3D"rgb(244,217,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.35" y=3D"57=
5.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_dma_unmap (46 samples, 0.02%)<=
/title><rect x=3D"1187.6" y=3D"437" width=3D"0.1" height=3D"15.0" fill=3D"r=
gb(220,105,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.56" y=3D"447.5" ></=
text>=0A</g>=0A<g >=0A<title>swapper (3,380 samples, 1.16%)</title><rect x=
=3D"1176.3" y=3D"725" width=3D"13.7" height=3D"15.0" fill=3D"rgb(209,89,51)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.27" y=3D"735.5" ></text>=0A</g>=
=0A<g >=0A<title>efx_ef10_ev_process (2,412 samples, 0.83%)</title><rect x=
=3D"1178.3" y=3D"501" width=3D"9.8" height=3D"15.0" fill=3D"rgb(209,27,24)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.26" y=3D"511.5" ></text>=0A</g>=0A=
<g >=0A<title>efx_tx_maybe_stop_queue (245 samples, 0.08%)</title><rect x=
=3D"37.1" y=3D"389" width=3D"1.0" height=3D"15.0" fill=3D"rgb(212,56,36)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"40.11" y=3D"399.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_bh (383 samples, 0.13%)</title><rect x=3D"867.1" y=
=3D"357" width=3D"1.6" height=3D"15.0" fill=3D"rgb(216,153,47)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"870.14" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title=
>pfn_to_dma_pte (390 samples, 0.13%)</title><rect x=3D"29.6" y=3D"261" widt=
h=3D"1.6" height=3D"15.0" fill=3D"rgb(240,140,10)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"32.64" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run=
_queues (215 samples, 0.07%)</title><rect x=3D"582.8" y=3D"421" width=3D"0.=
9" height=3D"15.0" fill=3D"rgb(248,153,49)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"585.82" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (=
121 samples, 0.04%)</title><rect x=3D"866.2" y=3D"341" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(207,200,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"869.1=
5" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__list_add_valid (46 samples=
, 0.02%)</title><rect x=3D"1176.7" y=3D"469" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(247,53,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.67" y=3D"479=
=2E5" ></text>=0A</g>=0A<g >=0A<title>skb_gro_receive (27 samples, 0.01%)</=
title><rect x=3D"1180.5" y=3D"389" width=3D"0.2" height=3D"15.0" fill=3D"rg=
b(253,154,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.54" y=3D"399.5" ></t=
ext>=0A</g>=0A<g >=0A<title>check_preemption_disabled (106 samples, 0.04%)<=
/title><rect x=3D"713.0" y=3D"421" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(217,2,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"715.98" y=3D"431.5" ></text=
>=0A</g>=0A<g >=0A<title>fib_table_lookup (332 samples, 0.11%)</title><rect=
 x=3D"719.8" y=3D"357" width=3D"1.3" height=3D"15.0" fill=3D"rgb(227,212,39=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"722.75" y=3D"367.5" ></text>=0A</g>=
=0A<g >=0A<title>__sysvec_apic_timer_interrupt (112 samples, 0.04%)</title>=
<rect x=3D"695.3" y=3D"421" width=3D"0.5" height=3D"15.0" fill=3D"rgb(235,2=
18,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"698.34" y=3D"431.5" ></text>=0A<=
/g>=0A<g >=0A<title>perf_event_task_tick (53 samples, 0.02%)</title><rect x=
=3D"493.6" y=3D"357" width=3D"0.2" height=3D"15.0" fill=3D"rgb(234,37,22)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.61" y=3D"367.5" ></text>=0A</g>=0A<g=
 >=0A<title>dev_gro_receive (52 samples, 0.02%)</title><rect x=3D"1189.1" y=
=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(245,73,54)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1192.06" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<titl=
e>dma_pte_clear_level (31 samples, 0.01%)</title><rect x=3D"1169.2" y=3D"45=
3" width=3D"0.1" height=3D"15.0" fill=3D"rgb(220,188,48)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"1172.20" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__io=
mmu_map (265 samples, 0.09%)</title><rect x=3D"11.6" y=3D"261" width=3D"1.0=
" height=3D"15.0" fill=3D"rgb(242,30,14)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"14.56" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__slab_free (154 sam=
ples, 0.05%)</title><rect x=3D"754.6" y=3D"293" width=3D"0.7" height=3D"15.=
0" fill=3D"rgb(217,219,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"757.64" y=3D=
"303.5" ></text>=0A</g>=0A<g >=0A<title>nf_checksum (70 samples, 0.02%)</ti=
tle><rect x=3D"869.1" y=3D"357" width=3D"0.3" height=3D"15.0" fill=3D"rgb(2=
10,162,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"872.10" y=3D"367.5" ></text>=
=0A</g>=0A<g >=0A<title>nf_nat_packet (201 samples, 0.07%)</title><rect x=
=3D"880.5" y=3D"373" width=3D"0.8" height=3D"15.0" fill=3D"rgb(208,157,19)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"883.47" y=3D"383.5" ></text>=0A</g>=0A<=
g >=0A<title>ksoftirqd/2 (278,126 samples, 95.71%)</title><rect x=3D"46.8" =
y=3D"725" width=3D"1129.5" height=3D"15.0" fill=3D"rgb(215,197,12)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"49.84" y=3D"735.5" >ksoftirqd/2</text>=0A</g>=
=0A<g >=0A<title>__hrtimer_run_queues (87 samples, 0.03%)</title><rect x=3D=
"695.4" y=3D"389" width=3D"0.3" height=3D"15.0" fill=3D"rgb(216,130,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"698.40" y=3D"399.5" ></text>=0A</g>=0A<g >=
=0A<title>__common_interrupt (198 samples, 0.07%)</title><rect x=3D"1176.3"=
 y=3D"581" width=3D"0.8" height=3D"15.0" fill=3D"rgb(219,217,12)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1179.30" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>tcp_gro_receive (57 samples, 0.02%)</title><rect x=3D"1180.4" y=3D"405"=
 width=3D"0.3" height=3D"15.0" fill=3D"rgb(209,156,28)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1183.42" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>hrtime=
r_interrupt (110 samples, 0.04%)</title><rect x=3D"695.3" y=3D"405" width=
=3D"0.5" height=3D"15.0" fill=3D"rgb(207,153,3)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"698.35" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interr=
upt (259 samples, 0.09%)</title><rect x=3D"493.2" y=3D"453" width=3D"1.0" h=
eight=3D"15.0" fill=3D"rgb(231,123,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
496.17" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__release_sock (1,360 s=
amples, 0.47%)</title><rect x=3D"10.0" y=3D"533" width=3D"5.5" height=3D"15=
=2E0" fill=3D"rgb(218,80,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (2=
26 samples, 0.08%)</title><rect x=3D"318.5" y=3D"485" width=3D"1.0" height=
=3D"15.0" fill=3D"rgb(245,127,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.5=
4" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>skb_release_data (155 sample=
s, 0.05%)</title><rect x=3D"60.0" y=3D"341" width=3D"0.6" height=3D"15.0" f=
ill=3D"rgb(251,174,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.00" y=3D"351.=
5" ></text>=0A</g>=0A<g >=0A<title>skb_defer_rx_timestamp (124 samples, 0.0=
4%)</title><rect x=3D"884.4" y=3D"469" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(234,159,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"887.44" y=3D"479.5" =
></text>=0A</g>=0A<g >=0A<title>efx_fast_push_rx_descriptors (18,762 sample=
s, 6.46%)</title><rect x=3D"1093.3" y=3D"581" width=3D"76.2" height=3D"15.0=
" fill=3D"rgb(211,110,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1096.29" y=3D=
"591.5" >efx_fast..</text>=0A</g>=0A<g >=0A<title>dev_hard_start_xmit (426 =
samples, 0.15%)</title><rect x=3D"1174.5" y=3D"309" width=3D"1.7" height=3D=
"15.0" fill=3D"rgb(242,202,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" =
y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>nf_conntrack_tcp_packet (62 sam=
ples, 0.02%)</title><rect x=3D"62.2" y=3D"405" width=3D"0.3" height=3D"15.0=
" fill=3D"rgb(218,43,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"65.22" y=3D"415=
=2E5" ></text>=0A</g>=0A<g >=0A<title>skb_release_data (9,052 samples, 3.12=
%)</title><rect x=3D"742.2" y=3D"309" width=3D"36.7" height=3D"15.0" fill=
=3D"rgb(206,57,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"745.16" y=3D"319.5" =
>skb..</text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (37 samples, 0.01%)<=
/title><rect x=3D"839.5" y=3D"277" width=3D"0.2" height=3D"15.0" fill=3D"rg=
b(246,81,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"842.52" y=3D"287.5" ></tex=
t>=0A</g>=0A<g >=0A<title>kmem_cache_free (461 samples, 0.16%)</title><rect=
 x=3D"776.9" y=3D"293" width=3D"1.9" height=3D"15.0" fill=3D"rgb(229,37,28)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"779.89" y=3D"303.5" ></text>=0A</g>=0A=
<g >=0A<title>tcp_v4_rcv (436 samples, 0.15%)</title><rect x=3D"1174.5" y=
=3D"469" width=3D"1.8" height=3D"15.0" fill=3D"rgb(225,109,26)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1177.50" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<titl=
e>ip_sublist_rcv_finish (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D=
"533" width=3D"1.8" height=3D"15.0" fill=3D"rgb(234,154,27)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1177.50" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>n=
f_hook_slow (8,482 samples, 2.92%)</title><rect x=3D"805.2" y=3D"389" width=
=3D"34.5" height=3D"15.0" fill=3D"rgb(243,203,1)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"808.23" y=3D"399.5" >nf..</text>=0A</g>=0A<g >=0A<title>efx_tx_ma=
ybe_stop_queue (31 samples, 0.01%)</title><rect x=3D"1175.9" y=3D"277" widt=
h=3D"0.1" height=3D"15.0" fill=3D"rgb(226,120,42)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1178.86" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_=
apic_timer_interrupt (81 samples, 0.03%)</title><rect x=3D"251.6" y=3D"533"=
 width=3D"0.3" height=3D"15.0" fill=3D"rgb(220,44,9)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"254.59" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec=
_apic_timer_interrupt (66 samples, 0.02%)</title><rect x=3D"1008.0" y=3D"46=
9" width=3D"0.2" height=3D"15.0" fill=3D"rgb(241,228,16)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"1010.97" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>nft_=
counter_eval (657 samples, 0.23%)</title><rect x=3D"823.8" y=3D"341" width=
=3D"2.6" height=3D"15.0" fill=3D"rgb(246,107,41)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"826.76" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>update_proces=
s_times (159 samples, 0.05%)</title><rect x=3D"583.1" y=3D"373" width=3D"0.=
6" height=3D"15.0" fill=3D"rgb(238,168,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"586.05" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>napi_get_frags (136=
 samples, 0.05%)</title><rect x=3D"52.8" y=3D"549" width=3D"0.6" height=3D"=
15.0" fill=3D"rgb(253,156,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"55.80" y=
=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>__ip_queue_xmit (1,482 samples, =
0.51%)</title><rect x=3D"794.3" y=3D"293" width=3D"6.0" height=3D"15.0" fil=
l=3D"rgb(219,175,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.28" y=3D"303.5=
" ></text>=0A</g>=0A<g >=0A<title>ip_protocol_deliver_rcu (359 samples, 0.1=
2%)</title><rect x=3D"59.7" y=3D"405" width=3D"1.5" height=3D"15.0" fill=3D=
"rgb(225,208,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.71" y=3D"415.5" ></=
text>=0A</g>=0A<g >=0A<title>ipv4_confirm (277 samples, 0.10%)</title><rect=
 x=3D"806.0" y=3D"373" width=3D"1.2" height=3D"15.0" fill=3D"rgb(226,214,3)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"383.5" ></text>=0A</g>=0A=
<g >=0A<title>dma_map_page_attrs (3,403 samples, 1.17%)</title><rect x=3D"2=
2.3" y=3D"373" width=3D"13.8" height=3D"15.0" fill=3D"rgb(245,159,38)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"25.29" y=3D"383.5" ></text>=0A</g>=0A<g >=
=0A<title>__nf_conntrack_find_get (27 samples, 0.01%)</title><rect x=3D"62.=
0" y=3D"405" width=3D"0.1" height=3D"15.0" fill=3D"rgb(220,93,17)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"65.02" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<tit=
le>preempt_count_sub (38 samples, 0.01%)</title><rect x=3D"822.3" y=3D"325"=
 width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,66,6)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"825.34" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>__list_a=
dd_valid (34 samples, 0.01%)</title><rect x=3D"710.0" y=3D"437" width=3D"0.=
1" height=3D"15.0" fill=3D"rgb(240,219,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"712.98" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_=
lock_slowpath (71 samples, 0.02%)</title><rect x=3D"867.9" y=3D"341" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(254,63,4)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"870.90" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interru=
pt (64 samples, 0.02%)</title><rect x=3D"1008.0" y=3D"453" width=3D"0.2" he=
ight=3D"15.0" fill=3D"rgb(217,210,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
010.97" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__build_skb_around (27 =
samples, 0.01%)</title><rect x=3D"52.9" y=3D"501" width=3D"0.1" height=3D"1=
5.0" fill=3D"rgb(253,184,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"55.93" y=
=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid (84 sampl=
es, 0.03%)</title><rect x=3D"482.4" y=3D"501" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(241,139,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"485.43" y=3D"5=
11.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (231 samp=
les, 0.08%)</title><rect x=3D"318.5" y=3D"501" width=3D"1.0" height=3D"15.0=
" fill=3D"rgb(243,32,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.53" y=3D"5=
11.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (289 =
samples, 0.10%)</title><rect x=3D"493.1" y=3D"501" width=3D"1.2" height=3D"=
15.0" fill=3D"rgb(242,55,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.10" y=
=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__domain_mapping (100 samples, 0=
=2E03%)</title><rect x=3D"1175.0" y=3D"165" width=3D"0.4" height=3D"15.0" f=
ill=3D"rgb(228,218,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.00" y=3D"17=
5.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (200 samples, 0.0=
7%)</title><rect x=3D"988.2" y=3D"421" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(223,8,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.15" y=3D"431.5" >=
</text>=0A</g>=0A<g >=0A<title>__netif_receive_skb_list_core (45,008 sample=
s, 15.49%)</title><rect x=3D"701.1" y=3D"469" width=3D"182.7" height=3D"15.=
0" fill=3D"rgb(241,60,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"704.07" y=3D"=
479.5" >__netif_receive_skb_lis..</text>=0A</g>=0A<g >=0A<title>__nf_ct_ref=
resh_acct (122 samples, 0.04%)</title><rect x=3D"866.6" y=3D"357" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(232,59,53)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"869.64" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt =
(48 samples, 0.02%)</title><rect x=3D"775.3" y=3D"213" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(250,215,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.3=
0" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>__napi_alloc_skb (126 sample=
s, 0.04%)</title><rect x=3D"52.8" y=3D"533" width=3D"0.6" height=3D"15.0" f=
ill=3D"rgb(221,212,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"55.84" y=3D"543.=
5" ></text>=0A</g>=0A<g >=0A<title>__do_softirq (134 samples, 0.05%)</title=
><rect x=3D"1189.4" y=3D"549" width=3D"0.6" height=3D"15.0" fill=3D"rgb(222=
,120,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.44" y=3D"559.5" ></text>=
=0A</g>=0A<g >=0A<title>ip_list_rcv (80 samples, 0.03%)</title><rect x=3D"1=
177.7" y=3D"405" width=3D"0.3" height=3D"15.0" fill=3D"rgb(248,75,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1180.67" y=3D"415.5" ></text>=0A</g>=0A<g =
>=0A<title>perf_event_task_tick (41 samples, 0.01%)</title><rect x=3D"655.7=
" y=3D"325" width=3D"0.2" height=3D"15.0" fill=3D"rgb(239,12,29)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"658.70" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<tit=
le>tick_sched_timer (30 samples, 0.01%)</title><rect x=3D"839.5" y=3D"245" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(249,32,20)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"842.54" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>schedule=
_idle (137 samples, 0.05%)</title><rect x=3D"1189.4" y=3D"645" width=3D"0.6=
" height=3D"15.0" fill=3D"rgb(246,128,43)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1192.44" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>__dev_queue_xmit (=
26 samples, 0.01%)</title><rect x=3D"61.0" y=3D"277" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(235,149,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.96=
" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>nf_hook_slow (379 samples, 0.=
13%)</title><rect x=3D"794.6" y=3D"245" width=3D"1.6" height=3D"15.0" fill=
=3D"rgb(236,4,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.62" y=3D"255.5" >=
</text>=0A</g>=0A<g >=0A<title>efx_tx_maybe_stop_queue (46 samples, 0.02%)<=
/title><rect x=3D"13.6" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(230,202,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.61" y=3D"351.5" ></text=
>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (39 samples, 0.01%)<=
/title><rect x=3D"755.3" y=3D"261" width=3D"0.1" height=3D"15.0" fill=3D"rg=
b(205,153,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.28" y=3D"271.5" ></te=
xt>=0A</g>=0A<g >=0A<title>napi_gro_complete (149 samples, 0.05%)</title><r=
ect x=3D"1180.7" y=3D"421" width=3D"0.6" height=3D"15.0" fill=3D"rgb(228,21=
1,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.65" y=3D"431.5" ></text>=0A<=
/g>=0A<g >=0A<title>tcp_event_data_recv (81 samples, 0.03%)</title><rect x=
=3D"801.6" y=3D"309" width=3D"0.3" height=3D"15.0" fill=3D"rgb(230,72,44)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"804.56" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>ip_local_deliver (74 samples, 0.03%)</title><rect x=3D"1180.8" =
y=3D"325" width=3D"0.3" height=3D"15.0" fill=3D"rgb(250,194,27)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1183.79" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<tit=
le>nft_immediate_eval (193 samples, 0.07%)</title><rect x=3D"826.4" y=3D"34=
1" width=3D"0.8" height=3D"15.0" fill=3D"rgb(208,187,36)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"829.43" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>intel=
_iommu_map_pages (225 samples, 0.08%)</title><rect x=3D"11.7" y=3D"245" wid=
th=3D"0.9" height=3D"15.0" fill=3D"rgb(254,4,33)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"14.66" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>dev_hard_start=
_xmit (7,545 samples, 2.60%)</title><rect x=3D"15.5" y=3D"421" width=3D"30.=
7" height=3D"15.0" fill=3D"rgb(220,211,27)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"18.52" y=3D"431.5" >de..</text>=0A</g>=0A<g >=0A<title>validate_xmit_sk=
b_list (64 samples, 0.02%)</title><rect x=3D"799.2" y=3D"197" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(230,16,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
802.20" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>__memcpy (18,683 sample=
s, 6.43%)</title><rect x=3D"913.2" y=3D"501" width=3D"75.9" height=3D"15.0"=
 fill=3D"rgb(233,106,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"916.21" y=3D"5=
11.5" >__memcpy</text>=0A</g>=0A<g >=0A<title>is_vmalloc_addr (37 samples, =
0.01%)</title><rect x=3D"37.0" y=3D"373" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(210,191,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.96" y=3D"383.5" =
></text>=0A</g>=0A<g >=0A<title>napi_skb_cache_get (1,845 samples, 0.63%)</=
title><rect x=3D"348.9" y=3D"469" width=3D"7.5" height=3D"15.0" fill=3D"rgb=
(207,168,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"351.90" y=3D"479.5" ></text=
>=0A</g>=0A<g >=0A<title>__slab_free (42 samples, 0.01%)</title><rect x=3D"=
1184.0" y=3D"453" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,207,29)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1187.03" y=3D"463.5" ></text>=0A</g>=0A<g =
>=0A<title>ip_sublist_rcv_finish (547 samples, 0.19%)</title><rect x=3D"59.=
6" y=3D"453" width=3D"2.2" height=3D"15.0" fill=3D"rgb(249,176,2)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"62.62" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<tit=
le>nf_hook_slow (10,425 samples, 3.59%)</title><rect x=3D"841.5" y=3D"405" =
width=3D"42.3" height=3D"15.0" fill=3D"rgb(245,107,48)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"844.51" y=3D"415.5" >nf_..</text>=0A</g>=0A<g >=0A<title>up=
date_process_times (44 samples, 0.02%)</title><rect x=3D"1055.5" y=3D"421" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(212,148,38)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1058.46" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>efx_rx_=
packet_gro (449 samples, 0.15%)</title><rect x=3D"51.5" y=3D"565" width=3D"=
1.9" height=3D"15.0" fill=3D"rgb(222,207,4)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"54.53" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>dma_pte_clear_level=
 (35 samples, 0.01%)</title><rect x=3D"1169.2" y=3D"469" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(224,121,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"117=
2.18" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (142=
 samples, 0.05%)</title><rect x=3D"1167.9" y=3D"453" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(218,156,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.=
92" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__efx_enqueue_skb (1,212 sa=
mples, 0.42%)</title><rect x=3D"10.0" y=3D"357" width=3D"4.9" height=3D"15.=
0" fill=3D"rgb(213,84,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"3=
67.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (38 samples, 0.01%)=
</title><rect x=3D"755.3" y=3D"245" width=3D"0.1" height=3D"15.0" fill=3D"r=
gb(210,140,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.28" y=3D"255.5" ></t=
ext>=0A</g>=0A<g >=0A<title>fq_enqueue (54 samples, 0.02%)</title><rect x=
=3D"799.5" y=3D"213" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218,120,40)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.48" y=3D"223.5" ></text>=0A</g>=0A<=
g >=0A<title>raw_local_deliver (173 samples, 0.06%)</title><rect x=3D"731.2=
" y=3D"357" width=3D"0.7" height=3D"15.0" fill=3D"rgb(227,180,38)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"734.16" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>clflush_cache_range (27 samples, 0.01%)</title><rect x=3D"1169.2" y=3D"=
421" width=3D"0.1" height=3D"15.0" fill=3D"rgb(225,94,12)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1172.21" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>skb=
_release_all (104 samples, 0.04%)</title><rect x=3D"757.0" y=3D"277" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(219,119,8)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"760.02" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__do_softirq (=
124 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"549" width=3D"0.5" heigh=
t=3D"15.0" fill=3D"rgb(220,198,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191=
=2E88" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (26=
 samples, 0.01%)</title><rect x=3D"755.3" y=3D"181" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(236,107,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.31" =
y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (179 sampl=
es, 0.06%)</title><rect x=3D"655.4" y=3D"405" width=3D"0.7" height=3D"15.0"=
 fill=3D"rgb(253,37,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"658.38" y=3D"41=
5.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_map (63 samples, 0.02%)</title=
><rect x=3D"1168.7" y=3D"501" width=3D"0.2" height=3D"15.0" fill=3D"rgb(214=
,110,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.66" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>preempt_count_add (94 samples, 0.03%)</title><rect =
x=3D"781.7" y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,67,14)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.69" y=3D"335.5" ></text>=0A</g>=0A<=
g >=0A<title>kfree_skb (81 samples, 0.03%)</title><rect x=3D"60.3" y=3D"325=
" width=3D"0.3" height=3D"15.0" fill=3D"rgb(213,112,35)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"63.26" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>nft_met=
a_get_eval (302 samples, 0.10%)</title><rect x=3D"827.2" y=3D"341" width=3D=
"1.2" height=3D"15.0" fill=3D"rgb(208,33,10)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"830.21" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__efx_rx_packet (=
76 samples, 0.03%)</title><rect x=3D"1189.0" y=3D"453" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(213,91,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.0=
0" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__handle_irq_event_percpu (1=
98 samples, 0.07%)</title><rect x=3D"1176.3" y=3D"517" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(245,113,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.=
30" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (=
29 samples, 0.01%)</title><rect x=3D"355.8" y=3D"437" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(249,186,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"358.8=
2" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__ip_queue_xmit (1,360 sampl=
es, 0.47%)</title><rect x=3D"10.0" y=3D"469" width=3D"5.5" height=3D"15.0" =
fill=3D"rgb(241,88,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"479.=
5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (41 samp=
les, 0.01%)</title><rect x=3D"839.5" y=3D"325" width=3D"0.2" height=3D"15.0=
" fill=3D"rgb(207,148,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"842.51" y=3D"=
335.5" ></text>=0A</g>=0A<g >=0A<title>napi_gro_frags (90 samples, 0.03%)</=
title><rect x=3D"1177.6" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(211,53,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.63" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (248 samples, 0.09%)=
</title><rect x=3D"988.1" y=3D"469" width=3D"1.0" height=3D"15.0" fill=3D"r=
gb(235,91,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.07" y=3D"479.5" ></te=
xt>=0A</g>=0A<g >=0A<title>efx_poll (134 samples, 0.05%)</title><rect x=3D"=
1189.4" y=3D"501" width=3D"0.6" height=3D"15.0" fill=3D"rgb(221,13,45)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1192.44" y=3D"511.5" ></text>=0A</g>=0A<g =
>=0A<title>__iommu_unmap (50 samples, 0.02%)</title><rect x=3D"1169.1" y=3D=
"533" width=3D"0.2" height=3D"15.0" fill=3D"rgb(211,200,35)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1172.13" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>e=
fx_ef10_ev_process (104 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"485"=
 width=3D"0.5" height=3D"15.0" fill=3D"rgb(214,68,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1191.93" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>pfn_to_=
dma_pte (35 samples, 0.01%)</title><rect x=3D"1175.3" y=3D"149" width=3D"0.=
1" height=3D"15.0" fill=3D"rgb(226,53,50)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1178.26" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>ipv4_conntrack_in =
(230 samples, 0.08%)</title><rect x=3D"844.4" y=3D"389" width=3D"0.9" heigh=
t=3D"15.0" fill=3D"rgb(224,133,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"847.=
37" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>tcp_data_ready (29 samples,=
 0.01%)</title><rect x=3D"801.4" y=3D"309" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(229,110,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"804.44" y=3D"319.=
5" ></text>=0A</g>=0A<g >=0A<title>clflush_cache_range (35 samples, 0.01%)<=
/title><rect x=3D"798.0" y=3D"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(244,154,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"801.04" y=3D"47.5" ></text=
>=0A</g>=0A<g >=0A<title>ip_protocol_deliver_rcu (45 samples, 0.02%)</title=
><rect x=3D"1180.8" y=3D"293" width=3D"0.2" height=3D"15.0" fill=3D"rgb(237=
,74,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.80" y=3D"303.5" ></text>=
=0A</g>=0A<g >=0A<title>efx_rx_packet (221,016 samples, 76.06%)</title><rec=
t x=3D"158.2" y=3D"565" width=3D"897.5" height=3D"15.0" fill=3D"rgb(227,95,=
50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.18" y=3D"575.5" >efx_rx_packet<=
/text>=0A</g>=0A<g >=0A<title>release_sock (1,360 samples, 0.47%)</title><r=
ect x=3D"10.0" y=3D"549" width=3D"5.5" height=3D"15.0" fill=3D"rgb(248,192,=
2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>efx_tx_send_pending (277 samples, 0.10%)</title><rect x=3D=
"13.8" y=3D"341" width=3D"1.1" height=3D"15.0" fill=3D"rgb(253,85,44)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"16.80" y=3D"351.5" ></text>=0A</g>=0A<g >=
=0A<title>efx_ef10_rx_write (9,256 samples, 3.19%)</title><rect x=3D"1055.7=
" y=3D"581" width=3D"37.6" height=3D"15.0" fill=3D"rgb(234,36,32)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1058.70" y=3D"591.5" >efx..</text>=0A</g>=0A<g >=
=0A<title>dev_hard_start_xmit (1,335 samples, 0.46%)</title><rect x=3D"10.0=
" y=3D"373" width=3D"5.4" height=3D"15.0" fill=3D"rgb(251,21,25)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"13.00" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<titl=
e>ip_output (1,360 samples, 0.47%)</title><rect x=3D"10.0" y=3D"453" width=
=3D"5.5" height=3D"15.0" fill=3D"rgb(245,68,6)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"13.00" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>get_page_from_fr=
eelist (37 samples, 0.01%)</title><rect x=3D"1167.5" y=3D"549" width=3D"0.1=
" height=3D"15.0" fill=3D"rgb(208,148,6)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1170.47" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (=
186 samples, 0.06%)</title><rect x=3D"988.2" y=3D"405" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(215,146,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.21=
" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>napi_reuse_skb.isra.40 (4,628=
 samples, 1.59%)</title><rect x=3D"989.4" y=3D"517" width=3D"18.8" height=
=3D"15.0" fill=3D"rgb(222,139,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.4=
5" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>tcp_add_backlog (1,424 sampl=
es, 0.49%)</title><rect x=3D"785.9" y=3D"341" width=3D"5.8" height=3D"15.0"=
 fill=3D"rgb(225,1,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"788.91" y=3D"351=
=2E5" ></text>=0A</g>=0A<g >=0A<title>alloc_iova_fast (63 samples, 0.02%)</=
title><rect x=3D"13.0" y=3D"261" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
224,172,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.03" y=3D"271.5" ></text>=
=0A</g>=0A<g >=0A<title>iommu_dma_sync_single_for_cpu (6,944 samples, 2.39%=
)</title><rect x=3D"1027.5" y=3D"549" width=3D"28.2" height=3D"15.0" fill=
=3D"rgb(248,137,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.49" y=3D"559.5=
" >i..</text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (62 samples, 0.0=
2%)</title><rect x=3D"801.0" y=3D"293" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(253,63,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"803.98" y=3D"303.5" =
></text>=0A</g>=0A<g >=0A<title>__do_softirq (278,073 samples, 95.70%)</tit=
le><rect x=3D"47.1" y=3D"645" width=3D"1129.2" height=3D"15.0" fill=3D"rgb(=
223,175,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"50.05" y=3D"655.5" >__do_so=
ftirq</text>=0A</g>=0A<g >=0A<title>ip_output (436 samples, 0.15%)</title><=
rect x=3D"1174.5" y=3D"389" width=3D"1.8" height=3D"15.0" fill=3D"rgb(207,1=
29,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"399.5" ></text>=0A=
</g>=0A<g >=0A<title>efx_ef10_ev_process (243,924 samples, 83.94%)</title><=
rect x=3D"65.2" y=3D"581" width=3D"990.5" height=3D"15.0" fill=3D"rgb(227,3=
8,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"68.16" y=3D"591.5" >efx_ef10_ev_pr=
ocess</text>=0A</g>=0A<g >=0A<title>nft_do_chain_ipv4 (80 samples, 0.03%)</=
title><rect x=3D"800.0" y=3D"245" width=3D"0.3" height=3D"15.0" fill=3D"rgb=
(231,78,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.96" y=3D"255.5" ></text=
>=0A</g>=0A<g >=0A<title>kfree_skb (4,980 samples, 1.71%)</title><rect x=3D=
"756.6" y=3D"293" width=3D"20.2" height=3D"15.0" fill=3D"rgb(238,162,28)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"759.57" y=3D"303.5" ></text>=0A</g>=0A<g =
>=0A<title>clflush_cache_range (28 samples, 0.01%)</title><rect x=3D"1175.1=
" y=3D"149" width=3D"0.2" height=3D"15.0" fill=3D"rgb(217,202,39)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1178.15" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<t=
itle>tick_sched_timer (138 samples, 0.05%)</title><rect x=3D"1008.4" y=3D"4=
69" width=3D"0.6" height=3D"15.0" fill=3D"rgb(213,210,28)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1011.41" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>nap=
i_get_frags (9,113 samples, 3.14%)</title><rect x=3D"319.5" y=3D"517" width=
=3D"37.0" height=3D"15.0" fill=3D"rgb(232,174,47)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"322.47" y=3D"527.5" >nap..</text>=0A</g>=0A<g >=0A<title>nf_hook=
_slow_list (39 samples, 0.01%)</title><rect x=3D"1181.1" y=3D"341" width=3D=
"0.1" height=3D"15.0" fill=3D"rgb(247,181,7)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1184.09" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>ip_local_deliver=
 (27,500 samples, 9.46%)</title><rect x=3D"728.0" y=3D"405" width=3D"111.7"=
 height=3D"15.0" fill=3D"rgb(245,8,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
731.00" y=3D"415.5" >ip_local_deli..</text>=0A</g>=0A<g >=0A<title>sock_put=
 (265 samples, 0.09%)</title><rect x=3D"784.8" y=3D"341" width=3D"1.1" heig=
ht=3D"15.0" fill=3D"rgb(221,58,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"787.=
83" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interru=
pt (258 samples, 0.09%)</title><rect x=3D"582.7" y=3D"453" width=3D"1.1" he=
ight=3D"15.0" fill=3D"rgb(205,121,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"5=
85.73" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_map_page (3,25=
8 samples, 1.12%)</title><rect x=3D"22.9" y=3D"357" width=3D"13.2" height=
=3D"15.0" fill=3D"rgb(251,1,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"25.88" =
y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_map (143 samples, 0.05%=
)</title><rect x=3D"1174.8" y=3D"197" width=3D"0.6" height=3D"15.0" fill=3D=
"rgb(216,72,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.85" y=3D"207.5" ></=
text>=0A</g>=0A<g >=0A<title>dma_pte_clear_level (30 samples, 0.01%)</title=
><rect x=3D"1169.2" y=3D"437" width=3D"0.1" height=3D"15.0" fill=3D"rgb(211=
,118,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1172.20" y=3D"447.5" ></text>=
=0A</g>=0A<g >=0A<title>eth_type_trans (229 samples, 0.08%)</title><rect x=
=3D"885.8" y=3D"517" width=3D"1.0" height=3D"15.0" fill=3D"rgb(251,44,22)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"888.83" y=3D"527.5" ></text>=0A</g>=0A<g=
 >=0A<title>tick_sched_handle.isra.23 (152 samples, 0.05%)</title><rect x=
=3D"318.8" y=3D"421" width=3D"0.6" height=3D"15.0" fill=3D"rgb(213,15,0)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"321.78" y=3D"431.5" ></text>=0A</g>=0A<g =
>=0A<title>napi_gro_complete (84 samples, 0.03%)</title><rect x=3D"1177.7" =
y=3D"453" width=3D"0.3" height=3D"15.0" fill=3D"rgb(213,54,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1180.65" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<titl=
e>entry_SYSCALL_64 (9,071 samples, 3.12%)</title><rect x=3D"10.0" y=3D"677"=
 width=3D"36.8" height=3D"15.0" fill=3D"rgb(244,171,5)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"13.00" y=3D"687.5" >ent..</text>=0A</g>=0A<g >=0A<title>__h=
rtimer_run_queues (194 samples, 0.07%)</title><rect x=3D"318.6" y=3D"453" w=
idth=3D"0.8" height=3D"15.0" fill=3D"rgb(205,2,50)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"321.60" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>iommu_map_a=
tomic (34 samples, 0.01%)</title><rect x=3D"35.5" y=3D"325" width=3D"0.1" h=
eight=3D"15.0" fill=3D"rgb(243,79,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"3=
8.45" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (160=
 samples, 0.06%)</title><rect x=3D"493.5" y=3D"389" width=3D"0.6" height=3D=
"15.0" fill=3D"rgb(222,207,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.49" =
y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>ip_route_use_hint (703 samples,=
 0.24%)</title><rect x=3D"718.4" y=3D"405" width=3D"2.9" height=3D"15.0" fi=
ll=3D"rgb(236,12,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"721.40" y=3D"415.5=
" ></text>=0A</g>=0A<g >=0A<title>__efx_rx_packet (3,318 samples, 1.14%)</t=
itle><rect x=3D"50.9" y=3D"581" width=3D"13.5" height=3D"15.0" fill=3D"rgb(=
240,195,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.93" y=3D"591.5" ></text>=
=0A</g>=0A<g >=0A<title>dev_gro_receive (61 samples, 0.02%)</title><rect x=
=3D"1189.6" y=3D"421" width=3D"0.3" height=3D"15.0" fill=3D"rgb(205,29,9)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.65" y=3D"431.5" ></text>=0A</g>=0A<=
g >=0A<title>nf_ct_get_tuple (412 samples, 0.14%)</title><rect x=3D"876.0" =
y=3D"373" width=3D"1.6" height=3D"15.0" fill=3D"rgb(243,165,28)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"878.96" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<titl=
e>update_process_times (143 samples, 0.05%)</title><rect x=3D"988.4" y=3D"3=
73" width=3D"0.6" height=3D"15.0" fill=3D"rgb(243,22,10)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"991.38" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>nf_co=
nntrack_in (7,960 samples, 2.74%)</title><rect x=3D"845.3" y=3D"389" width=
=3D"32.3" height=3D"15.0" fill=3D"rgb(240,47,15)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"848.31" y=3D"399.5" >nf..</text>=0A</g>=0A<g >=0A<title>common_in=
terrupt (124 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"581" width=3D"0=
=2E5" height=3D"15.0" fill=3D"rgb(215,44,5)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1191.88" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>common_interrupt =
(3,089 samples, 1.06%)</title><rect x=3D"1176.3" y=3D"597" width=3D"12.5" h=
eight=3D"15.0" fill=3D"rgb(253,99,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
179.30" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>ip_protocol_deliver_rcu=
 (35 samples, 0.01%)</title><rect x=3D"1177.7" y=3D"325" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(244,60,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180=
=2E72" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_inte=
rrupt (186 samples, 0.06%)</title><rect x=3D"1008.3" y=3D"517" width=3D"0.7=
" height=3D"15.0" fill=3D"rgb(219,152,37)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1011.28" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef10_msi_inter=
rupt (198 samples, 0.07%)</title><rect x=3D"1176.3" y=3D"501" width=3D"0.8"=
 height=3D"15.0" fill=3D"rgb(207,27,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1179.30" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>cpuidle_enter (3,226 s=
amples, 1.11%)</title><rect x=3D"1176.3" y=3D"645" width=3D"13.1" height=3D=
"15.0" fill=3D"rgb(250,108,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.30"=
 y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>napi_get_frags (29 samples, 0.=
01%)</title><rect x=3D"1179.8" y=3D"437" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(227,29,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.79" y=3D"447.5"=
 ></text>=0A</g>=0A<g >=0A<title>tcp_recvmsg_locked (7,711 samples, 2.65%)<=
/title><rect x=3D"15.5" y=3D"549" width=3D"31.3" height=3D"15.0" fill=3D"rg=
b(214,16,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.52" y=3D"559.5" >tc..</=
text>=0A</g>=0A<g >=0A<title>domain_unmap (41 samples, 0.01%)</title><rect =
x=3D"1169.2" y=3D"501" width=3D"0.1" height=3D"15.0" fill=3D"rgb(207,113,32=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1172.16" y=3D"511.5" ></text>=0A</g>=
=0A<g >=0A<title>efx_recycle_rx_pages (3,110 samples, 1.07%)</title><rect x=
=3D"1014.9" y=3D"549" width=3D"12.6" height=3D"15.0" fill=3D"rgb(238,188,50=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1017.86" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>__sysvec_apic_timer_interrupt (39 samples, 0.01%)</title><=
rect x=3D"839.5" y=3D"293" width=3D"0.2" height=3D"15.0" fill=3D"rgb(223,10=
2,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"842.52" y=3D"303.5" ></text>=0A</=
g>=0A<g >=0A<title>nf_hook_slow_list (194 samples, 0.07%)</title><rect x=3D=
"61.8" y=3D"453" width=3D"0.8" height=3D"15.0" fill=3D"rgb(221,31,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"64.84" y=3D"463.5" ></text>=0A</g>=0A<g >=
=0A<title>__tcp_transmit_skb (436 samples, 0.15%)</title><rect x=3D"1174.5"=
 y=3D"421" width=3D"1.8" height=3D"15.0" fill=3D"rgb(235,176,18)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>update_process_times (129 samples, 0.04%)</title><rect x=3D"655.6" y=3D=
"357" width=3D"0.5" height=3D"15.0" fill=3D"rgb(251,216,41)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"658.58" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>ti=
ck_sched_timer (82 samples, 0.03%)</title><rect x=3D"695.4" y=3D"373" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(217,87,16)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"698.42" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>iommu_get_dma_=
domain (27 samples, 0.01%)</title><rect x=3D"13.3" y=3D"293" width=3D"0.1" =
height=3D"15.0" fill=3D"rgb(223,154,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"16.31" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (66 sa=
mples, 0.02%)</title><rect x=3D"989.1" y=3D"421" width=3D"0.3" height=3D"15=
=2E0" fill=3D"rgb(223,123,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.15" y=
=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>ip_route_use_hint (33 samples, 0=
=2E01%)</title><rect x=3D"59.4" y=3D"437" width=3D"0.1" height=3D"15.0" fil=
l=3D"rgb(212,18,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.39" y=3D"447.5" =
></text>=0A</g>=0A<g >=0A<title>efx_rx_packet_gro (25,748 samples, 8.86%)</=
title><rect x=3D"251.9" y=3D"533" width=3D"104.6" height=3D"15.0" fill=3D"r=
gb(212,100,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"254.92" y=3D"543.5" >efx=
_rx_packe..</text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid (35 sample=
s, 0.01%)</title><rect x=3D"710.1" y=3D"437" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(237,138,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"713.12" y=3D"44=
7.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (686 samples, 0.24%)</=
title><rect x=3D"482.8" y=3D"501" width=3D"2.8" height=3D"15.0" fill=3D"rgb=
(228,204,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"485.77" y=3D"511.5" ></tex=
t>=0A</g>=0A<g >=0A<title>memcmp (96 samples, 0.03%)</title><rect x=3D"823.=
4" y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"rgb(245,20,1)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"826.37" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<tit=
le>asm_sysvec_apic_timer_interrupt (260 samples, 0.09%)</title><rect x=3D"9=
88.0" y=3D"485" width=3D"1.1" height=3D"15.0" fill=3D"rgb(237,137,40)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"991.02" y=3D"495.5" ></text>=0A</g>=0A<g >=
=0A<title>__kmalloc_node_track_caller (2,312 samples, 0.80%)</title><rect x=
=3D"339.3" y=3D"453" width=3D"9.4" height=3D"15.0" fill=3D"rgb(226,225,21)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"342.33" y=3D"463.5" ></text>=0A</g>=0A<=
g >=0A<title>__ip_queue_xmit (42 samples, 0.01%)</title><rect x=3D"60.9" y=
=3D"325" width=3D"0.2" height=3D"15.0" fill=3D"rgb(211,213,12)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"63.91" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>=
efx_rx_packet (531 samples, 0.18%)</title><rect x=3D"1179.5" y=3D"485" widt=
h=3D"2.1" height=3D"15.0" fill=3D"rgb(232,220,21)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1182.46" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef10_ev=
_read_ack (63 samples, 0.02%)</title><rect x=3D"1188.1" y=3D"501" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(219,225,4)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1191.05" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>tcp_gro_receive (=
25,104 samples, 8.64%)</title><rect x=3D"593.9" y=3D"485" width=3D"101.9" h=
eight=3D"15.0" fill=3D"rgb(238,47,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"59=
6.86" y=3D"495.5" >tcp_gro_rece..</text>=0A</g>=0A<g >=0A<title>__list_add_=
valid (52 samples, 0.02%)</title><rect x=3D"703.4" y=3D"453" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(222,8,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
06.41" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_alloc_iova.isr=
a.28 (38 samples, 0.01%)</title><rect x=3D"1175.6" y=3D"213" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(206,206,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1178.60" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_alloc_iova.=
isra.28 (66 samples, 0.02%)</title><rect x=3D"13.0" y=3D"277" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(213,128,35)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"16.02" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__nf_conntrack_find_=
get (1,653 samples, 0.57%)</title><rect x=3D"849.5" y=3D"373" width=3D"6.8"=
 height=3D"15.0" fill=3D"rgb(234,71,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"852.54" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>intel_iommu_iotlb_sync=
_map (552 samples, 0.19%)</title><rect x=3D"31.7" y=3D"309" width=3D"2.3" h=
eight=3D"15.0" fill=3D"rgb(206,207,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
34.74" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (30 sam=
ples, 0.01%)</title><rect x=3D"755.3" y=3D"213" width=3D"0.1" height=3D"15.=
0" fill=3D"rgb(226,124,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.30" y=3D=
"223.5" ></text>=0A</g>=0A<g >=0A<title>tcp_v4_do_rcv (72 samples, 0.02%)</=
title><rect x=3D"60.8" y=3D"373" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
214,74,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.84" y=3D"383.5" ></text>=
=0A</g>=0A<g >=0A<title>ipv4_dst_check (267 samples, 0.09%)</title><rect x=
=3D"726.3" y=3D"389" width=3D"1.1" height=3D"15.0" fill=3D"rgb(245,207,21)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"729.34" y=3D"399.5" ></text>=0A</g>=0A<=
g >=0A<title>asm_sysvec_apic_timer_interrupt (112 samples, 0.04%)</title><r=
ect x=3D"390.0" y=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(212,44,=
28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.00" y=3D"527.5" ></text>=0A</g>=
=0A<g >=0A<title>intel_iommu_map_pages (119 samples, 0.04%)</title><rect x=
=3D"797.8" y=3D"69" width=3D"0.5" height=3D"15.0" fill=3D"rgb(225,115,33)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"800.83" y=3D"79.5" ></text>=0A</g>=0A<g =
>=0A<title>dma_sync_single_for_cpu (1,428 samples, 0.49%)</title><rect x=3D=
"1009.1" y=3D"549" width=3D"5.8" height=3D"15.0" fill=3D"rgb(228,22,43)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1012.06" y=3D"559.5" ></text>=0A</g>=0A<g =
>=0A<title>task_tick_fair (42 samples, 0.01%)</title><rect x=3D"493.8" y=3D=
"357" width=3D"0.2" height=3D"15.0" fill=3D"rgb(249,10,43)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"496.83" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>tcp=
_rcv_established (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"437" w=
idth=3D"1.8" height=3D"15.0" fill=3D"rgb(253,184,36)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1177.50" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>check_p=
reemption_disabled (25 samples, 0.01%)</title><rect x=3D"1173.5" y=3D"549" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(236,91,32)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1176.49" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>tcp_rcv=
_established (2,929 samples, 1.01%)</title><rect x=3D"792.0" y=3D"325" widt=
h=3D"11.9" height=3D"15.0" fill=3D"rgb(218,45,31)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"794.96" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>vfs_read (9,=
071 samples, 3.12%)</title><rect x=3D"10.0" y=3D"629" width=3D"36.8" height=
=3D"15.0" fill=3D"rgb(216,151,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"639.5" >vfs..</text>=0A</g>=0A<g >=0A<title>security_sock_rcv_skb (2=
22 samples, 0.08%)</title><rect x=3D"783.9" y=3D"325" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(241,110,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.9=
3" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_do_timer (27 samp=
les, 0.01%)</title><rect x=3D"655.5" y=3D"373" width=3D"0.1" height=3D"15.0=
" fill=3D"rgb(219,227,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"658.47" y=3D"=
383.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (75 samples, 0.03%=
)</title><rect x=3D"251.6" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(213,56,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"254.61" y=3D"495.5" ></t=
ext>=0A</g>=0A<g >=0A<title>dma_map_page_attrs (565 samples, 0.19%)</title>=
<rect x=3D"11.1" y=3D"325" width=3D"2.3" height=3D"15.0" fill=3D"rgb(231,17=
,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.13" y=3D"335.5" ></text>=0A</g>=
=0A<g >=0A<title>__alloc_skb (7,807 samples, 2.69%)</title><rect x=3D"324.7=
" y=3D"485" width=3D"31.7" height=3D"15.0" fill=3D"rgb(222,229,52)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"327.69" y=3D"495.5" >__..</text>=0A</g>=0A<g >=
=0A<title>nft_do_chain_ipv4 (631 samples, 0.22%)</title><rect x=3D"881.3" y=
=3D"389" width=3D"2.5" height=3D"15.0" fill=3D"rgb(234,137,3)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"884.28" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title=
>napi_complete_done (38 samples, 0.01%)</title><rect x=3D"1188.6" y=3D"501"=
 width=3D"0.1" height=3D"15.0" fill=3D"rgb(212,110,39)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1191.58" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>hrtime=
r_interrupt (184 samples, 0.06%)</title><rect x=3D"1008.3" y=3D"501" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(223,190,29)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1011.28" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__alloc_page=
s (41 samples, 0.01%)</title><rect x=3D"1167.5" y=3D"565" width=3D"0.1" hei=
ght=3D"15.0" fill=3D"rgb(227,202,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
70.45" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__dev_queue_xmit (7,711 =
samples, 2.65%)</title><rect x=3D"15.5" y=3D"469" width=3D"31.3" height=3D"=
15.0" fill=3D"rgb(224,0,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.52" y=3D=
"479.5" >__..</text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (82 samples, 0.=
03%)</title><rect x=3D"883.8" y=3D"469" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(234,215,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"886.84" y=3D"479.5"=
 ></text>=0A</g>=0A<g >=0A<title>kfree (195 samples, 0.07%)</title><rect x=
=3D"1186.7" y=3D"421" width=3D"0.8" height=3D"15.0" fill=3D"rgb(234,121,41)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1189.73" y=3D"431.5" ></text>=0A</g>=
=0A<g >=0A<title>irq_exit_rcu (2,891 samples, 0.99%)</title><rect x=3D"1177=
=2E1" y=3D"581" width=3D"11.7" height=3D"15.0" fill=3D"rgb(241,150,12)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1180.11" y=3D"591.5" ></text>=0A</g>=0A<g =
>=0A<title>__efx_rx_packet (87 samples, 0.03%)</title><rect x=3D"1189.6" y=
=3D"453" width=3D"0.3" height=3D"15.0" fill=3D"rgb(253,135,40)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1192.58" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<titl=
e>efx_hard_start_xmit (26 samples, 0.01%)</title><rect x=3D"799.1" y=3D"181=
" width=3D"0.1" height=3D"15.0" fill=3D"rgb(251,56,2)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"802.10" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_a=
pic_timer_interrupt (294 samples, 0.10%)</title><rect x=3D"157.0" y=3D"549"=
 width=3D"1.2" height=3D"15.0" fill=3D"rgb(206,124,26)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"159.98" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>ip_prot=
ocol_deliver_rcu (18,476 samples, 6.36%)</title><rect x=3D"730.2" y=3D"373"=
 width=3D"75.0" height=3D"15.0" fill=3D"rgb(229,126,51)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"733.21" y=3D"383.5" >ip_proto..</text>=0A</g>=0A<g >=0A<ti=
tle>ip_output (1,016 samples, 0.35%)</title><rect x=3D"796.2" y=3D"277" wid=
th=3D"4.1" height=3D"15.0" fill=3D"rgb(211,145,9)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"799.16" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_dma_=
map (474 samples, 0.16%)</title><rect x=3D"11.4" y=3D"293" width=3D"1.9" he=
ight=3D"15.0" fill=3D"rgb(229,54,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14=
=2E39" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interr=
upt (87 samples, 0.03%)</title><rect x=3D"1055.3" y=3D"517" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(232,17,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"10=
58.33" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>ip_sublist_rcv (436 samp=
les, 0.15%)</title><rect x=3D"1174.5" y=3D"549" width=3D"1.8" height=3D"15.=
0" fill=3D"rgb(232,216,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D=
"559.5" ></text>=0A</g>=0A<g >=0A<title>__iommu_dma_map (248 samples, 0.09%=
)</title><rect x=3D"797.7" y=3D"117" width=3D"1.0" height=3D"15.0" fill=3D"=
rgb(207,64,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"800.68" y=3D"127.5" ></t=
ext>=0A</g>=0A<g >=0A<title>napi_gro_complete (46,794 samples, 16.10%)</tit=
le><rect x=3D"695.8" y=3D"501" width=3D"190.0" height=3D"15.0" fill=3D"rgb(=
219,81,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"698.80" y=3D"511.5" >napi_gr=
o_complete</text>=0A</g>=0A<g >=0A<title>tick_sched_do_timer (31 samples, 0=
=2E01%)</title><rect x=3D"988.2" y=3D"389" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(249,156,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.24" y=3D"399.5=
" ></text>=0A</g>=0A<g >=0A<title>__napi_alloc_skb (8,241 samples, 2.84%)</=
title><rect x=3D"323.0" y=3D"501" width=3D"33.4" height=3D"15.0" fill=3D"rg=
b(232,54,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"325.96" y=3D"511.5" >__..<=
/text>=0A</g>=0A<g >=0A<title>update_process_times (51 samples, 0.02%)</tit=
le><rect x=3D"989.2" y=3D"389" width=3D"0.2" height=3D"15.0" fill=3D"rgb(22=
2,162,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.21" y=3D"399.5" ></text>=
=0A</g>=0A<g >=0A<title>memcmp (87 samples, 0.03%)</title><rect x=3D"790.8"=
 y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,179,50)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"793.81" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<tit=
le>net_rx_action (134 samples, 0.05%)</title><rect x=3D"1189.4" y=3D"533" w=
idth=3D"0.6" height=3D"15.0" fill=3D"rgb(245,54,6)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1192.44" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read=
_unlock (80 samples, 0.03%)</title><rect x=3D"697.8" y=3D"485" width=3D"0.3=
" height=3D"15.0" fill=3D"rgb(234,25,33)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"700.78" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>pfn_to_dma_pte (61 =
samples, 0.02%)</title><rect x=3D"12.3" y=3D"213" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(247,134,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.33" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>fib_lookup_good_nhc (27 samples,=
 0.01%)</title><rect x=3D"721.0" y=3D"341" width=3D"0.1" height=3D"15.0" fi=
ll=3D"rgb(216,51,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"723.99" y=3D"351.5=
" ></text>=0A</g>=0A<g >=0A<title>__build_skb_around (1,373 samples, 0.47%)=
</title><rect x=3D"329.5" y=3D"469" width=3D"5.6" height=3D"15.0" fill=3D"r=
gb(227,182,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"332.48" y=3D"479.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__efx_rx_packet (473 samples, 0.16%)</title><re=
ct x=3D"1179.6" y=3D"469" width=3D"1.9" height=3D"15.0" fill=3D"rgb(216,93,=
20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.60" y=3D"479.5" ></text>=0A</g=
>=0A<g >=0A<title>task_tick_fair (26 samples, 0.01%)</title><rect x=3D"319.=
1" y=3D"373" width=3D"0.1" height=3D"15.0" fill=3D"rgb(215,32,47)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"322.12" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>tcp_in_window (38 samples, 0.01%)</title><rect x=3D"795.1" y=3D"197" wi=
dth=3D"0.2" height=3D"15.0" fill=3D"rgb(213,121,5)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"798.13" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_u=
nmap_page (80 samples, 0.03%)</title><rect x=3D"1187.5" y=3D"453" width=3D"=
0.4" height=3D"15.0" fill=3D"rgb(249,144,1)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1190.54" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>dev_gro_receive (=
317 samples, 0.11%)</title><rect x=3D"1180.0" y=3D"437" width=3D"1.3" heigh=
t=3D"15.0" fill=3D"rgb(209,164,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182=
=2E97" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (32=
 samples, 0.01%)</title><rect x=3D"1008.6" y=3D"405" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(229,134,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1011.=
59" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__netif_receive_skb_list_co=
re (139 samples, 0.05%)</title><rect x=3D"1180.7" y=3D"389" width=3D"0.5" h=
eight=3D"15.0" fill=3D"rgb(230,32,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
83.68" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>ip_local_deliver_finish =
(436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"501" width=3D"1.8" heig=
ht=3D"15.0" fill=3D"rgb(215,4,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.=
50" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>_iommu_map (192 samples, 0.=
07%)</title><rect x=3D"1174.8" y=3D"213" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(251,93,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.82" y=3D"223.5"=
 ></text>=0A</g>=0A<g >=0A<title>tcp_data_queue (30 samples, 0.01%)</title>=
<rect x=3D"801.3" y=3D"309" width=3D"0.1" height=3D"15.0" fill=3D"rgb(246,8=
0,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"804.32" y=3D"319.5" ></text>=0A</=
g>=0A<g >=0A<title>__iowrite64_copy (44 samples, 0.02%)</title><rect x=3D"1=
0.8" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(232,36,5)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"13.84" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>asm_sysvec_apic_timer_interrupt (35 samples, 0.01%)</title><rect x=3D"5=
93.7" y=3D"469" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,82,25)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"596.72" y=3D"479.5" ></text>=0A</g>=0A<g >=0A=
<title>tcp_v4_fill_cb (249 samples, 0.09%)</title><rect x=3D"803.9" y=3D"34=
1" width=3D"1.0" height=3D"15.0" fill=3D"rgb(253,174,22)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"806.85" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>intel=
_iommu_iotlb_sync_map (47 samples, 0.02%)</title><rect x=3D"798.3" y=3D"85"=
 width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,195,14)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"801.34" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_=
interrupt (221 samples, 0.08%)</title><rect x=3D"1167.7" y=3D"517" width=3D=
"0.9" height=3D"15.0" fill=3D"rgb(249,31,31)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1170.67" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unloc=
k (63 samples, 0.02%)</title><rect x=3D"884.2" y=3D"469" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(243,163,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"887=
=2E18" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>nf_ct_seq_offset (321 sa=
mples, 0.11%)</title><rect x=3D"874.7" y=3D"341" width=3D"1.3" height=3D"15=
=2E0" fill=3D"rgb(249,167,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"877.65" y=
=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock (394 samples, 0.1=
4%)</title><rect x=3D"780.5" y=3D"341" width=3D"1.6" height=3D"15.0" fill=
=3D"rgb(216,120,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"783.47" y=3D"351.5"=
 ></text>=0A</g>=0A<g >=0A<title>xdp_do_flush (25 samples, 0.01%)</title><r=
ect x=3D"1188.7" y=3D"501" width=3D"0.1" height=3D"15.0" fill=3D"rgb(220,20=
2,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.74" y=3D"511.5" ></text>=0A<=
/g>=0A<g >=0A<title>tick_sched_handle.isra.23 (164 samples, 0.06%)</title><=
rect x=3D"583.0" y=3D"389" width=3D"0.7" height=3D"15.0" fill=3D"rgb(228,18=
,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.03" y=3D"399.5" ></text>=0A</g>=
=0A<g >=0A<title>tcp4_gro_receive (44 samples, 0.02%)</title><rect x=3D"57.=
1" y=3D"517" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,25,5)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"60.12" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<titl=
e>nf_nat_ipv4_local_in (539 samples, 0.19%)</title><rect x=3D"809.3" y=3D"3=
73" width=3D"2.2" height=3D"15.0" fill=3D"rgb(207,155,37)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"812.33" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>xdp_=
do_flush (1,211 samples, 0.42%)</title><rect x=3D"1169.6" y=3D"581" width=
=3D"4.9" height=3D"15.0" fill=3D"rgb(226,60,25)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1172.57" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_ha=
ndle.isra.23 (47 samples, 0.02%)</title><rect x=3D"1055.4" y=3D"437" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(212,46,13)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1058.45" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>sk_filter_tri=
m_cap (522 samples, 0.18%)</title><rect x=3D"782.7" y=3D"341" width=3D"2.1"=
 height=3D"15.0" fill=3D"rgb(250,202,47)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"785.71" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>tcp_try_coalesce (1=
91 samples, 0.07%)</title><rect x=3D"803.0" y=3D"293" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(252,81,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"806.04"=
 y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>napi_gro_complete (904 samples=
, 0.31%)</title><rect x=3D"59.0" y=3D"533" width=3D"3.7" height=3D"15.0" fi=
ll=3D"rgb(218,208,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.99" y=3D"543.5=
" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (46 samples, 0.=
02%)</title><rect x=3D"1174.3" y=3D"549" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(209,103,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.27" y=3D"559.5=
" ></text>=0A</g>=0A<g >=0A<title>__memcpy (280 samples, 0.10%)</title><rec=
t x=3D"63.0" y=3D"533" width=3D"1.2" height=3D"15.0" fill=3D"rgb(252,182,46=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"66.03" y=3D"543.5" ></text>=0A</g>=0A=
<g >=0A<title>tcp_recvmsg (9,071 samples, 3.12%)</title><rect x=3D"10.0" y=
=3D"565" width=3D"36.8" height=3D"15.0" fill=3D"rgb(230,205,38)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"13.00" y=3D"575.5" >tcp..</text>=0A</g>=0A<g >=0A<=
title>__dev_queue_xmit (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"=
357" width=3D"1.8" height=3D"15.0" fill=3D"rgb(225,22,8)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"1177.50" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>tick=
_sched_handle.isra.23 (116 samples, 0.04%)</title><rect x=3D"1008.5" y=3D"4=
53" width=3D"0.5" height=3D"15.0" fill=3D"rgb(217,165,39)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1011.50" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>sch=
eduler_tick (79 samples, 0.03%)</title><rect x=3D"655.7" y=3D"341" width=3D=
"0.3" height=3D"15.0" fill=3D"rgb(213,170,38)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"658.67" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__napi_poll (278=
,069 samples, 95.69%)</title><rect x=3D"47.1" y=3D"613" width=3D"1129.2" he=
ight=3D"15.0" fill=3D"rgb(212,54,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"50=
=2E07" y=3D"623.5" >__napi_poll</text>=0A</g>=0A<g >=0A<title>napi_schedule=
_prep (39 samples, 0.01%)</title><rect x=3D"1176.9" y=3D"485" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(216,88,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1179.95" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__ip_local_out (399 s=
amples, 0.14%)</title><rect x=3D"794.5" y=3D"261" width=3D"1.7" height=3D"1=
5.0" fill=3D"rgb(219,9,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.54" y=3D=
"271.5" ></text>=0A</g>=0A<g >=0A<title>tcp_v4_do_rcv (436 samples, 0.15%)<=
/title><rect x=3D"1174.5" y=3D"453" width=3D"1.8" height=3D"15.0" fill=3D"r=
gb(213,185,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.50" y=3D"463.5" ></=
text>=0A</g>=0A<g >=0A<title>__xsk_map_flush (177 samples, 0.06%)</title><r=
ect x=3D"64.4" y=3D"581" width=3D"0.7" height=3D"15.0" fill=3D"rgb(213,132,=
4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"67.40" y=3D"591.5" ></text>=0A</g>=
=0A<g >=0A<title>update_process_times (170 samples, 0.06%)</title><rect x=
=3D"157.3" y=3D"453" width=3D"0.7" height=3D"15.0" fill=3D"rgb(223,48,9)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"160.35" y=3D"463.5" ></text>=0A</g>=0A<g =
>=0A<title>asm_sysvec_apic_timer_interrupt (26 samples, 0.01%)</title><rect=
 x=3D"493.0" y=3D"485" width=3D"0.1" height=3D"15.0" fill=3D"rgb(234,8,2)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"495.99" y=3D"495.5" ></text>=0A</g>=0A<g=
 >=0A<title>nf_nat_inet_fn (225 samples, 0.08%)</title><rect x=3D"810.4" y=
=3D"357" width=3D"0.9" height=3D"15.0" fill=3D"rgb(230,101,44)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"813.36" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title=
>sysvec_apic_timer_interrupt (90 samples, 0.03%)</title><rect x=3D"989.1" y=
=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"rgb(225,194,49)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"992.08" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title=
>nf_hook_slow_list (10,876 samples, 3.74%)</title><rect x=3D"839.7" y=3D"42=
1" width=3D"44.1" height=3D"15.0" fill=3D"rgb(220,81,53)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"842.68" y=3D"431.5" >nf_h..</text>=0A</g>=0A<g >=0A<title=
>iommu_dma_unmap_page (89 samples, 0.03%)</title><rect x=3D"1169.1" y=3D"56=
5" width=3D"0.4" height=3D"15.0" fill=3D"rgb(234,196,31)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"1172.11" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>efx_=
tx_map_data (304 samples, 0.10%)</title><rect x=3D"797.6" y=3D"165" width=
=3D"1.2" height=3D"15.0" fill=3D"rgb(212,71,31)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"800.60" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_=
add (87 samples, 0.03%)</title><rect x=3D"826.1" y=3D"325" width=3D"0.3" he=
ight=3D"15.0" fill=3D"rgb(207,57,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"82=
9.07" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>inet_recvmsg (9,071 sampl=
es, 3.12%)</title><rect x=3D"10.0" y=3D"581" width=3D"36.8" height=3D"15.0"=
 fill=3D"rgb(207,116,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"591=
=2E5" >ine..</text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (46 samples=
, 0.02%)</title><rect x=3D"583.2" y=3D"341" width=3D"0.2" height=3D"15.0" f=
ill=3D"rgb(236,2,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.21" y=3D"351.5=
" ></text>=0A</g>=0A<g >=0A<title>netif_receive_skb_list_internal (84 sampl=
es, 0.03%)</title><rect x=3D"1177.7" y=3D"437" width=3D"0.3" height=3D"15.0=
" fill=3D"rgb(254,212,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.65" y=3D=
"447.5" ></text>=0A</g>=0A<g >=0A<title>efx_tx_send_pending (34 samples, 0.=
01%)</title><rect x=3D"1176.0" y=3D"277" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(225,52,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.99" y=3D"287.5" =
></text>=0A</g>=0A<g >=0A<title>dev_gro_receive (121,988 samples, 41.98%)</=
title><rect x=3D"390.5" y=3D"517" width=3D"495.3" height=3D"15.0" fill=3D"r=
gb(251,225,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"393.45" y=3D"527.5" >dev_=
gro_receive</text>=0A</g>=0A<g >=0A<title>fib_info_nh_uses_dev (30 samples,=
 0.01%)</title><rect x=3D"719.6" y=3D"357" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(253,194,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"722.63" y=3D"367.=
5" ></text>=0A</g>=0A<g >=0A<title>nft_meta_store_ifname (74 samples, 0.03%=
)</title><rect x=3D"828.4" y=3D"341" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(232,149,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"831.44" y=3D"351.5" ></t=
ext>=0A</g>=0A<g >=0A<title>netif_receive_skb_list_internal (28 samples, 0.=
01%)</title><rect x=3D"1189.8" y=3D"389" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(231,84,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.78" y=3D"399.5"=
 ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (169 samples, 0.06%)</tit=
le><rect x=3D"1167.8" y=3D"485" width=3D"0.7" height=3D"15.0" fill=3D"rgb(2=
29,128,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.81" y=3D"495.5" ></text>=
=0A</g>=0A<g >=0A<title>skb_release_head_state (301 samples, 0.10%)</title>=
<rect x=3D"1184.3" y=3D"421" width=3D"1.2" height=3D"15.0" fill=3D"rgb(234,=
181,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1187.26" y=3D"431.5" ></text>=
=0A</g>=0A<g >=0A<title>clflush_cache_range (68 samples, 0.02%)</title><rec=
t x=3D"12.1" y=3D"213" width=3D"0.2" height=3D"15.0" fill=3D"rgb(226,13,44)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.05" y=3D"223.5" ></text>=0A</g>=0A<=
g >=0A<title>__ip_queue_xmit (7,711 samples, 2.65%)</title><rect x=3D"15.5"=
 y=3D"517" width=3D"31.3" height=3D"15.0" fill=3D"rgb(253,136,14)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"18.52" y=3D"527.5" >__..</text>=0A</g>=0A<g >=0A=
<title>napi_gro_frags (71 samples, 0.02%)</title><rect x=3D"1189.6" y=3D"43=
7" width=3D"0.3" height=3D"15.0" fill=3D"rgb(228,45,8)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1192.64" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>kmallo=
c_slab (277 samples, 0.10%)</title><rect x=3D"346.0" y=3D"437" width=3D"1.1=
" height=3D"15.0" fill=3D"rgb(212,221,54)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"348.96" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>efx_hard_start_xmit=
 (25 samples, 0.01%)</title><rect x=3D"1176.1" y=3D"293" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(222,98,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179=
=2E12" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (76=
 samples, 0.03%)</title><rect x=3D"1092.9" y=3D"501" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(216,116,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.9=
4" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__tcp_transmit_skb (7,711 sa=
mples, 2.65%)</title><rect x=3D"15.5" y=3D"533" width=3D"31.3" height=3D"15=
=2E0" fill=3D"rgb(214,54,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"18.52" y=
=3D"543.5" >__..</text>=0A</g>=0A<g >=0A<title>nft_do_chain (123 samples, 0=
=2E04%)</title><rect x=3D"61.3" y=3D"389" width=3D"0.5" height=3D"15.0" fil=
l=3D"rgb(248,171,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.35" y=3D"399.5"=
 ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.23 (55 samples, 0.0=
2%)</title><rect x=3D"1093.0" y=3D"469" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(213,22,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1096.03" y=3D"479.5"=
 ></text>=0A</g>=0A<g >=0A<title>nf_ct_deliver_cached_events (328 samples, =
0.11%)</title><rect x=3D"808.0" y=3D"357" width=3D"1.3" height=3D"15.0" fil=
l=3D"rgb(205,182,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"811.00" y=3D"367.5=
" ></text>=0A</g>=0A<g >=0A<title>tcp_gro_complete (40 samples, 0.01%)</tit=
le><rect x=3D"885.7" y=3D"485" width=3D"0.1" height=3D"15.0" fill=3D"rgb(22=
9,224,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"888.66" y=3D"495.5" ></text>=
=0A</g>=0A<g >=0A<title>tick_sched_do_timer (37 samples, 0.01%)</title><rec=
t x=3D"493.3" y=3D"405" width=3D"0.2" height=3D"15.0" fill=3D"rgb(238,69,53=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"496.32" y=3D"415.5" ></text>=0A</g>=
=0A<g >=0A<title>scheduler_tick (92 samples, 0.03%)</title><rect x=3D"988.5=
" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(234,101,15)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"991.49" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>ip_local_deliver (542 samples, 0.19%)</title><rect x=3D"59.6" y=3D"437"=
 width=3D"2.2" height=3D"15.0" fill=3D"rgb(254,70,24)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"62.64" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>kmalloc_r=
eserve (2,511 samples, 0.86%)</title><rect x=3D"338.5" y=3D"469" width=3D"1=
0.2" height=3D"15.0" fill=3D"rgb(242,103,46)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"341.52" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock =
(106 samples, 0.04%)</title><rect x=3D"782.1" y=3D"341" width=3D"0.4" heigh=
t=3D"15.0" fill=3D"rgb(215,209,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"785.0=
7" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt =
(114 samples, 0.04%)</title><rect x=3D"695.3" y=3D"437" width=3D"0.5" heigh=
t=3D"15.0" fill=3D"rgb(223,145,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"698.3=
4" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (104 samples,=
 0.04%)</title><rect x=3D"1168.0" y=3D"437" width=3D"0.4" height=3D"15.0" f=
ill=3D"rgb(234,226,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.99" y=3D"44=
7.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (238 samples, 0.08%)=
</title><rect x=3D"988.1" y=3D"437" width=3D"0.9" height=3D"15.0" fill=3D"r=
gb(236,58,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.08" y=3D"447.5" ></te=
xt>=0A</g>=0A<g >=0A<title>update_process_times (45 samples, 0.02%)</title>=
<rect x=3D"251.7" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(232,1=
6,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"254.71" y=3D"431.5" ></text>=0A</=
g>=0A<g >=0A<title>hrtimer_interrupt (94 samples, 0.03%)</title><rect x=3D"=
1092.9" y=3D"517" width=3D"0.4" height=3D"15.0" fill=3D"rgb(222,123,25)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1095.89" y=3D"527.5" ></text>=0A</g>=0A<g =
>=0A<title>kfree (277 samples, 0.10%)</title><rect x=3D"755.4" y=3D"293" wi=
dth=3D"1.2" height=3D"15.0" fill=3D"rgb(207,94,34)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"758.45" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_m=
ap_page (526 samples, 0.18%)</title><rect x=3D"11.3" y=3D"309" width=3D"2.1=
" height=3D"15.0" fill=3D"rgb(209,47,21)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"14.29" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_=
interrupt (37 samples, 0.01%)</title><rect x=3D"1027.3" y=3D"501" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(205,214,29)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1030.34" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrup=
t (25 samples, 0.01%)</title><rect x=3D"493.0" y=3D"437" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(228,186,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"495.=
99" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>timekeeping_advance (25 sam=
ples, 0.01%)</title><rect x=3D"988.3" y=3D"357" width=3D"0.1" height=3D"15.=
0" fill=3D"rgb(254,13,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.27" y=3D"3=
67.5" ></text>=0A</g>=0A<g >=0A<title>__slab_free (34 samples, 0.01%)</titl=
e><rect x=3D"775.1" y=3D"261" width=3D"0.2" height=3D"15.0" fill=3D"rgb(209=
,224,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.13" y=3D"271.5" ></text>=
=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (85 samples, 0.03%)</=
title><rect x=3D"989.1" y=3D"469" width=3D"0.3" height=3D"15.0" fill=3D"rgb=
(209,29,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"992.09" y=3D"479.5" ></text>=
=0A</g>=0A<g >=0A<title>start_secondary (3,379 samples, 1.16%)</title><rect=
 x=3D"1176.3" y=3D"693" width=3D"13.7" height=3D"15.0" fill=3D"rgb(237,147,=
30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.28" y=3D"703.5" ></text>=0A</g=
>=0A<g >=0A<title>task_tick_fair (36 samples, 0.01%)</title><rect x=3D"1168=
=2E2" y=3D"421" width=3D"0.2" height=3D"15.0" fill=3D"rgb(249,112,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1171.25" y=3D"431.5" ></text>=0A</g>=0A<g =
>=0A<title>__sysvec_apic_timer_interrupt (97 samples, 0.03%)</title><rect x=
=3D"1092.9" y=3D"533" width=3D"0.4" height=3D"15.0" fill=3D"rgb(226,192,6)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.88" y=3D"543.5" ></text>=0A</g>=0A=
<g >=0A<title>pfn_to_dma_pte (33 samples, 0.01%)</title><rect x=3D"798.2" y=
=3D"37" width=3D"0.1" height=3D"15.0" fill=3D"rgb(213,23,47)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"801.18" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>=
validate_xmit_skb_list (166 samples, 0.06%)</title><rect x=3D"46.2" y=3D"42=
1" width=3D"0.6" height=3D"15.0" fill=3D"rgb(246,138,12)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"49.16" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>hrtime=
r_interrupt (84 samples, 0.03%)</title><rect x=3D"989.1" y=3D"453" width=3D=
"0.3" height=3D"15.0" fill=3D"rgb(250,129,36)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"992.09" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer=
 (212 samples, 0.07%)</title><rect x=3D"157.2" y=3D"485" width=3D"0.8" heig=
ht=3D"15.0" fill=3D"rgb(221,158,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160=
=2E18" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.2=
3 (146 samples, 0.05%)</title><rect x=3D"988.4" y=3D"389" width=3D"0.6" hei=
ght=3D"15.0" fill=3D"rgb(214,177,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991=
=2E37" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>efx_rx_packet (90 sample=
s, 0.03%)</title><rect x=3D"1189.0" y=3D"469" width=3D"0.3" height=3D"15.0"=
 fill=3D"rgb(215,101,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.97" y=3D"=
479.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (182 samples, 0=
=2E06%)</title><rect x=3D"1167.8" y=3D"501" width=3D"0.7" height=3D"15.0" f=
ill=3D"rgb(214,70,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.76" y=3D"511=
=2E5" ></text>=0A</g>=0A<g >=0A<title>napi_gro_frags (398 samples, 0.14%)</=
title><rect x=3D"1179.9" y=3D"453" width=3D"1.6" height=3D"15.0" fill=3D"rg=
b(241,177,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.90" y=3D"463.5" ></te=
xt>=0A</g>=0A<g >=0A<title>all (290,579 samples, 100%)</title><rect x=3D"10=
=2E0" y=3D"741" width=3D"1180.0" height=3D"15.0" fill=3D"rgb(211,52,3)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"751.5" ></text>=0A</g>=0A<g >=
=0A<title>handle_irq_event_percpu (198 samples, 0.07%)</title><rect x=3D"11=
76.3" y=3D"533" width=3D"0.8" height=3D"15.0" fill=3D"rgb(229,60,21)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"1179.30" y=3D"543.5" ></text>=0A</g>=0A<g >=
=0A<title>__sysvec_apic_timer_interrupt (49 samples, 0.02%)</title><rect x=
=3D"775.3" y=3D"229" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,47,0)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"778.30" y=3D"239.5" ></text>=0A</g>=0A<g =
>=0A<title>tcp_v4_early_demux (1,518 samples, 0.52%)</title><rect x=3D"721.=
3" y=3D"405" width=3D"6.1" height=3D"15.0" fill=3D"rgb(245,172,28)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"724.26" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__napi_poll (124 samples, 0.04%)</title><rect x=3D"1188.9" y=3D"517" w=
idth=3D"0.5" height=3D"15.0" fill=3D"rgb(237,141,11)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1191.88" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_=
apic_timer_interrupt (222 samples, 0.08%)</title><rect x=3D"655.3" y=3D"453=
" width=3D"0.9" height=3D"15.0" fill=3D"rgb(254,191,48)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"658.29" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>fib_va=
lidate_source (625 samples, 0.22%)</title><rect x=3D"718.7" y=3D"389" width=
=3D"2.6" height=3D"15.0" fill=3D"rgb(211,208,0)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"721.72" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>net_rx_action =
(278,069 samples, 95.69%)</title><rect x=3D"47.1" y=3D"629" width=3D"1129.2=
" height=3D"15.0" fill=3D"rgb(241,55,21)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"50.07" y=3D"639.5" >net_rx_action</text>=0A</g>=0A<g >=0A<title>napi_gr=
o_complete (29 samples, 0.01%)</title><rect x=3D"1189.8" y=3D"405" width=3D=
"0.1" height=3D"15.0" fill=3D"rgb(221,161,41)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"1192.78" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef10_tx_wri=
te (34 samples, 0.01%)</title><rect x=3D"799.0" y=3D"149" width=3D"0.1" hei=
ght=3D"15.0" fill=3D"rgb(250,180,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80=
1.96" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>__dev_queue_xmit (812 sam=
ples, 0.28%)</title><rect x=3D"796.5" y=3D"245" width=3D"3.3" height=3D"15.=
0" fill=3D"rgb(239,166,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"799.49" y=3D=
"255.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_map_page (259 samples, 0.=
09%)</title><rect x=3D"1174.8" y=3D"245" width=3D"1.0" height=3D"15.0" fill=
=3D"rgb(205,67,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.76" y=3D"255.5"=
 ></text>=0A</g>=0A<g >=0A<title>dev_qdisc_enqueue (55 samples, 0.02%)</tit=
le><rect x=3D"799.5" y=3D"229" width=3D"0.2" height=3D"15.0" fill=3D"rgb(22=
0,22,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.48" y=3D"239.5" ></text>=
=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (238 samples, 0.08%)</t=
itle><rect x=3D"1167.6" y=3D"549" width=3D"1.0" height=3D"15.0" fill=3D"rgb=
(235,39,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.64" y=3D"559.5" ></text=
>=0A</g>=0A<g >=0A<title>bpf_lsm_socket_sock_rcv_skb (104 samples, 0.04%)</=
title><rect x=3D"784.4" y=3D"309" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(211,81,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"787.41" y=3D"319.5" ></text=
>=0A</g>=0A<g >=0A<title>skb_try_coalesce (105 samples, 0.04%)</title><rect=
 x=3D"803.4" y=3D"277" width=3D"0.4" height=3D"15.0" fill=3D"rgb(212,187,51=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"806.39" y=3D"287.5" ></text>=0A</g>=
=0A<g >=0A<title>tcp_gro_receive (417 samples, 0.14%)</title><rect x=3D"57.=
3" y=3D"517" width=3D"1.7" height=3D"15.0" fill=3D"rgb(207,32,5)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"60.30" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__sock_wfree (274 samples, 0.09%)</title><rect x=3D"1184.4" y=3D"405" wid=
th=3D"1.1" height=3D"15.0" fill=3D"rgb(244,46,7)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1187.37" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>iommu_dma_ma=
p_page (269 samples, 0.09%)</title><rect x=3D"797.6" y=3D"133" width=3D"1.1=
" height=3D"15.0" fill=3D"rgb(250,147,15)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"800.64" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>_iommu_map (371 sam=
ples, 0.13%)</title><rect x=3D"11.5" y=3D"277" width=3D"1.5" height=3D"15.0=
" fill=3D"rgb(235,228,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.51" y=3D"2=
87.5" ></text>=0A</g>=0A<g >=0A<title>efx_hard_start_xmit (123 samples, 0.0=
4%)</title><rect x=3D"14.9" y=3D"357" width=3D"0.5" height=3D"15.0" fill=3D=
"rgb(241,86,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"17.92" y=3D"367.5" ></t=
ext>=0A</g>=0A<g >=0A<title>efx_ef10_tx_write (987 samples, 0.34%)</title><=
rect x=3D"39.8" y=3D"373" width=3D"4.0" height=3D"15.0" fill=3D"rgb(221,212=
,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"42.81" y=3D"383.5" ></text>=0A</g>=
=0A<g >=0A<title>nf_hook_slow (167 samples, 0.06%)</title><rect x=3D"61.2" =
y=3D"421" width=3D"0.6" height=3D"15.0" fill=3D"rgb(242,10,46)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"64.17" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>=
netif_receive_skb_list_internal (890 samples, 0.31%)</title><rect x=3D"59.0=
" y=3D"517" width=3D"3.6" height=3D"15.0" fill=3D"rgb(219,216,35)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"62.03" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<tit=
le>ip_sublist_rcv (129 samples, 0.04%)</title><rect x=3D"1180.7" y=3D"357" =
width=3D"0.5" height=3D"15.0" fill=3D"rgb(244,109,39)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1183.73" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>efx_ef1=
0_tx_limit_len (55 samples, 0.02%)</title><rect x=3D"36.7" y=3D"357" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(213,226,16)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"39.74" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>validate_xmit_=
skb (55 samples, 0.02%)</title><rect x=3D"799.2" y=3D"181" width=3D"0.2" he=
ight=3D"15.0" fill=3D"rgb(218,125,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"8=
02.22" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>efx_dequeue_buffer (1,17=
9 samples, 0.41%)</title><rect x=3D"1183.3" y=3D"469" width=3D"4.8" height=
=3D"15.0" fill=3D"rgb(222,216,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.=
26" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>_iommu_map (198 samples, 0.=
07%)</title><rect x=3D"797.7" y=3D"101" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(215,209,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"800.73" y=3D"111.5"=
 ></text>=0A</g>=0A<g >=0A<title>trigger_load_balance (28 samples, 0.01%)</=
title><rect x=3D"583.6" y=3D"357" width=3D"0.1" height=3D"15.0" fill=3D"rgb=
(254,142,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"586.58" y=3D"367.5" ></tex=
t>=0A</g>=0A<g >=0A<title>perf_event_task_tick (51 samples, 0.02%)</title><=
rect x=3D"988.5" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,77=
,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"991.51" y=3D"351.5" ></text>=0A</g>=
=0A<g >=0A<title>ktime_get (162 samples, 0.06%)</title><rect x=3D"802.1" y=
=3D"293" width=3D"0.7" height=3D"15.0" fill=3D"rgb(248,118,5)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"805.15" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title=
>ip_finish_output2 (436 samples, 0.15%)</title><rect x=3D"1174.5" y=3D"373"=
 width=3D"1.8" height=3D"15.0" fill=3D"rgb(254,119,15)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1177.50" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>__iomm=
u_dma_map (114 samples, 0.04%)</title><rect x=3D"1168.6" y=3D"533" width=3D=
"0.5" height=3D"15.0" fill=3D"rgb(235,105,5)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1171.64" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>nf_confirm (530 =
samples, 0.18%)</title><rect x=3D"807.2" y=3D"373" width=3D"2.1" height=3D"=
15.0" fill=3D"rgb(240,180,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"810.17" y=
=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>intel_iommu_iotlb_sync_map (38 s=
amples, 0.01%)</title><rect x=3D"1168.9" y=3D"501" width=3D"0.2" height=3D"=
15.0" fill=3D"rgb(247,225,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.91" =
y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__do_softirq (2,891 samples, 0.=
99%)</title><rect x=3D"1177.1" y=3D"565" width=3D"11.7" height=3D"15.0" fil=
l=3D"rgb(240,65,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.11" y=3D"575.5"=
 ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (224 samples=
, 0.08%)</title><rect x=3D"1167.7" y=3D"533" width=3D"0.9" height=3D"15.0" =
fill=3D"rgb(212,89,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.66" y=3D"54=
3.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (85 samp=
les, 0.03%)</title><rect x=3D"1055.3" y=3D"501" width=3D"0.4" height=3D"15.=
0" fill=3D"rgb(250,86,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1058.34" y=3D=
"511.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (164 samples, 0.06=
%)</title><rect x=3D"655.4" y=3D"389" width=3D"0.7" height=3D"15.0" fill=3D=
"rgb(247,152,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"658.44" y=3D"399.5" ><=
/text>=0A</g>=0A<g >=0A<title>ip_sublist_rcv_finish (78 samples, 0.03%)</ti=
tle><rect x=3D"1180.8" y=3D"341" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
208,56,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.77" y=3D"351.5" ></text>=
=0A</g>=0A</g>=0A</svg>=0A
--6ymahzmprkdpv54f--
