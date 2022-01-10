Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20927489544
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbiAJJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:32:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242945AbiAJJcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641807130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iyl4TrEgHAFJuLyGMyBPC5+9x3M01g3sxwwAORKIjfY=;
        b=Cdlx7ZrSl+1BZ8kUp4S+ks36HxagQOLPnB/rPplBBfwfIsNMs8m0gLZ7/x0i/8bykOyBoW
        WBZ7hGguXHX94DEojPftWqCZjy0aYydKOwGyvqQUv2t9n4NBDYSE8xUx0JMouOJErXCBHu
        ji2kFlQnzElsGbgsQbhhgH6p0ZDWiyI=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-txkP_WghPSiiRYwfnRgr2Q-1; Mon, 10 Jan 2022 04:32:09 -0500
X-MC-Unique: txkP_WghPSiiRYwfnRgr2Q-1
Received: by mail-io1-f72.google.com with SMTP id r139-20020a6b2b91000000b0060445aa664dso10663441ior.9
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Iyl4TrEgHAFJuLyGMyBPC5+9x3M01g3sxwwAORKIjfY=;
        b=alQj3DfvOadD5zcI11SOlaNGgp5+hSVpmNBeP7yTR2nm0ZP45BR8tHL3HBJg4j2Aa1
         Zq6BNHkbZDj5mNi17TXzOHwHuaiVVqgG4kr3o22buqItd5g0YJXb8mLPCnjN6tMt51bu
         S/p4wZ09LS2OCve5+u0MdvUW105YKMNs4iIF+tGw+3Epl9U1/fVGwaztVGuhgmfpGObK
         q/FoxMJZp/WbpBVjpWAMPG7x+Rg1MZADvnhLJIwGFHVgVDbHHwF96adzF0nrH3J6Yixj
         icUXtFgFHKx4mSItC5VxSeZWIAF01yEQ2A2XwHW+9Y4VFK2OXoVKyz1UdHZBwOabR/Kg
         +5xQ==
X-Gm-Message-State: AOAM531xPgk3f5f4vfRRHSk71bu5aMNP1BmOKy+RYHoTK1Lt3TuUimc7
        DwQSSaPOnbf1j/y4boAoXp/ILtwu7CbEk1Ea6WtdKeLegI+gh/tzqFI3cx1JAbMc8Ab61wFGGlN
        Xw6DC9Q4On9eS8IVzk1l6cPEPqI1/8M2j
X-Received: by 2002:a02:294b:: with SMTP id p72mr29392610jap.263.1641807128542;
        Mon, 10 Jan 2022 01:32:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjSOg5e6yYmZF3rbyFsvSaawtmgZ9RidykD/fUVBdmihOoZGlEQbqNq/x8cCXkuJX+c6br4xK/Sel5UlD9uHA=
X-Received: by 2002:a02:294b:: with SMTP id p72mr29392597jap.263.1641807128126;
 Mon, 10 Jan 2022 01:32:08 -0800 (PST)
MIME-Version: 1.0
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com> <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
 <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
 <20220102092207.rxz7kpjii4ermnfo@gmail.com> <20220110085820.zi73go4etyyrkixr@gmail.com>
In-Reply-To: <20220110085820.zi73go4etyyrkixr@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 10 Jan 2022 10:31:57 +0100
Message-ID: <CACT4ouf+zW_Ey=NvJJrNCQ2q7V4xYnxdH7cX1PQcF9-EE1PP9w@mail.gmail.com>
Subject: Re: [PATCH net-next] sfc: The size of the RX recycle ring should be
 more flexible
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin, thanks for the quick fix.

On Mon, Jan 10, 2022 at 9:58 AM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> Ideally the size would depend on the link speed, but the recycle
> ring is created when the interface is brought up before the driver
> knows the link speed. So size it for the maximum speed of a given NIC.
> PowerPC is only supported on SFN7xxx and SFN8xxx NICs.
>
> With this patch on a 40G NIC the number of calls to alloc_pages and
> friends went down from about 18% to under 2%.
> On a 10G NIC the number of calls to alloc_pages and friends went down
> from about 15% to 0 (perf did not capture any calls during the 60
> second test).
> On a 100G NIC the number of calls to alloc_pages and friends went down
> from about 23% to 4%.

Although the problem seemed to be mainly in the case of IOMMU not
present, this patch also changes the ring size for the IOMMU present
case, using the same size for both. Have you checked that performance
is not reduced in the second case?

> Reported-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c       |   31 +++++++++++++++++++++++++++=
++++
>  drivers/net/ethernet/sfc/ef100_nic.c  |    9 +++++++++
>  drivers/net/ethernet/sfc/net_driver.h |    2 ++
>  drivers/net/ethernet/sfc/nic_common.h |    5 +++++
>  drivers/net/ethernet/sfc/rx_common.c  |   18 +-----------------
>  drivers/net/ethernet/sfc/rx_common.h  |    6 ++++++
>  drivers/net/ethernet/sfc/siena.c      |    8 ++++++++
>  7 files changed, 62 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/e=
f10.c
> index cf366ed2557c..dc3f95503d9c 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -3990,6 +3990,35 @@ static unsigned int ef10_check_caps(const struct e=
fx_nic *efx,
>         }
>  }
>
> +static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx=
)
> +{
> +       unsigned int ret;
> +
> +       /* There is no difference between PFs and VFs. The side is based =
on
> +        * the maximum link speed of a given NIC.
> +        */
> +       switch (efx->pci_dev->device & 0xfff) {
> +       case 0x0903:    /* Farmingdale can do up to 10G */
> +#ifdef CONFIG_PPC64
> +               ret =3D 4 * EFX_RECYCLE_RING_SIZE_10G;
> +#else
> +               ret =3D EFX_RECYCLE_RING_SIZE_10G;
> +#endif
> +               break;
> +       case 0x0923:    /* Greenport can do up to 40G */
> +       case 0x0a03:    /* Medford can do up to 40G */
> +#ifdef CONFIG_PPC64
> +               ret =3D 16 * EFX_RECYCLE_RING_SIZE_10G;
> +#else
> +               ret =3D 4 * EFX_RECYCLE_RING_SIZE_10G;
> +#endif
> +               break;
> +       default:        /* Medford2 can do up to 100G */
> +               ret =3D 10 * EFX_RECYCLE_RING_SIZE_10G;
> +       }
> +       return ret;
> +}
> +
>  #define EF10_OFFLOAD_FEATURES          \
>         (NETIF_F_IP_CSUM |              \
>          NETIF_F_HW_VLAN_CTAG_FILTER |  \
> @@ -4106,6 +4135,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type =
=3D {
>         .check_caps =3D ef10_check_caps,
>         .print_additional_fwver =3D efx_ef10_print_additional_fwver,
>         .sensor_event =3D efx_mcdi_sensor_event,
> +       .rx_recycle_ring_size =3D efx_ef10_recycle_ring_size,
>  };
>
>  const struct efx_nic_type efx_hunt_a0_nic_type =3D {
> @@ -4243,4 +4273,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type =3D =
{
>         .check_caps =3D ef10_check_caps,
>         .print_additional_fwver =3D efx_ef10_print_additional_fwver,
>         .sensor_event =3D efx_mcdi_sensor_event,
> +       .rx_recycle_ring_size =3D efx_ef10_recycle_ring_size,
>  };
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/=
sfc/ef100_nic.c
> index f79b14a119ae..a07cbf45a326 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -23,6 +23,7 @@
>  #include "ef100_rx.h"
>  #include "ef100_tx.h"
>  #include "ef100_netdev.h"
> +#include "rx_common.h"
>
>  #define EF100_MAX_VIS 4096
>  #define EF100_NUM_MCDI_BUFFERS 1
> @@ -696,6 +697,12 @@ static unsigned int ef100_check_caps(const struct ef=
x_nic *efx,
>         }
>  }
>
> +static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *ef=
x)
> +{
> +       /* Maximum link speed for Riverhead is 100G */
> +       return 10 * EFX_RECYCLE_RING_SIZE_10G;
> +}
> +
>  /*     NIC level access functions
>   */
>  #define EF100_OFFLOAD_FEATURES (NETIF_F_HW_CSUM | NETIF_F_RXCSUM |     \
> @@ -770,6 +777,7 @@ const struct efx_nic_type ef100_pf_nic_type =3D {
>         .rx_push_rss_context_config =3D efx_mcdi_rx_push_rss_context_conf=
ig,
>         .rx_pull_rss_context_config =3D efx_mcdi_rx_pull_rss_context_conf=
ig,
>         .rx_restore_rss_contexts =3D efx_mcdi_rx_restore_rss_contexts,
> +       .rx_recycle_ring_size =3D efx_ef100_recycle_ring_size,
>
>         .reconfigure_mac =3D ef100_reconfigure_mac,
>         .reconfigure_port =3D efx_mcdi_port_reconfigure,
> @@ -849,6 +857,7 @@ const struct efx_nic_type ef100_vf_nic_type =3D {
>         .rx_pull_rss_config =3D efx_mcdi_rx_pull_rss_config,
>         .rx_push_rss_config =3D efx_mcdi_pf_rx_push_rss_config,
>         .rx_restore_rss_contexts =3D efx_mcdi_rx_restore_rss_contexts,
> +       .rx_recycle_ring_size =3D efx_ef100_recycle_ring_size,
>
>         .reconfigure_mac =3D ef100_reconfigure_mac,
>         .test_nvram =3D efx_new_mcdi_nvram_test_all,
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index cc15ee8812d9..c75dc75e2857 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1282,6 +1282,7 @@ struct efx_udp_tunnel {
>   * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
>   * @print_additional_fwver: Dump NIC-specific additional FW version info
>   * @sensor_event: Handle a sensor event from MCDI
> + * @rx_recycle_ring_size: Size of the RX recycle ring
>   * @revision: Hardware architecture revision
>   * @txd_ptr_tbl_base: TX descriptor ring base address
>   * @rxd_ptr_tbl_base: RX descriptor ring base address
> @@ -1460,6 +1461,7 @@ struct efx_nic_type {
>         size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
>                                          size_t len);
>         void (*sensor_event)(struct efx_nic *efx, efx_qword_t *ev);
> +       unsigned int (*rx_recycle_ring_size)(const struct efx_nic *efx);
>
>         int revision;
>         unsigned int txd_ptr_tbl_base;
> diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet=
/sfc/nic_common.h
> index b9cafe9cd568..0cef35c0c559 100644
> --- a/drivers/net/ethernet/sfc/nic_common.h
> +++ b/drivers/net/ethernet/sfc/nic_common.h
> @@ -195,6 +195,11 @@ static inline void efx_sensor_event(struct efx_nic *=
efx, efx_qword_t *ev)
>                 efx->type->sensor_event(efx, ev);
>  }
>
> +static inline unsigned int efx_rx_recycle_ring_size(const struct efx_nic=
 *efx)
> +{
> +       return efx->type->rx_recycle_ring_size(efx);
> +}
> +
>  /* Some statistics are computed as A - B where A and B each increase
>   * linearly with some hardware counter(s) and the counters are read
>   * asynchronously.  If the counters contributing to B are always read
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/=
sfc/rx_common.c
> index 633ca77a26fd..1b22c7be0088 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -23,13 +23,6 @@ module_param(rx_refill_threshold, uint, 0444);
>  MODULE_PARM_DESC(rx_refill_threshold,
>                  "RX descriptor ring refill threshold (%)");
>
> -/* Number of RX buffers to recycle pages for.  When creating the RX page=
 recycle
> - * ring, this number is divided by the number of buffers per page to cal=
culate
> - * the number of pages to store in the RX page recycle ring.
> - */
> -#define EFX_RECYCLE_RING_SIZE_IOMMU 4096
> -#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
> -
>  /* RX maximum head room required.
>   *
>   * This must be at least 1 to prevent overflow, plus one packet-worth
> @@ -141,16 +134,7 @@ static void efx_init_rx_recycle_ring(struct efx_rx_q=
ueue *rx_queue)
>         unsigned int bufs_in_recycle_ring, page_ring_size;
>         struct efx_nic *efx =3D rx_queue->efx;
>
> -       /* Set the RX recycle ring size */
> -#ifdef CONFIG_PPC64
> -       bufs_in_recycle_ring =3D EFX_RECYCLE_RING_SIZE_IOMMU;
> -#else
> -       if (iommu_present(&pci_bus_type))
> -               bufs_in_recycle_ring =3D EFX_RECYCLE_RING_SIZE_IOMMU;
> -       else
> -               bufs_in_recycle_ring =3D EFX_RECYCLE_RING_SIZE_NOIOMMU;
> -#endif /* CONFIG_PPC64 */
> -
> +       bufs_in_recycle_ring =3D efx_rx_recycle_ring_size(efx);
>         page_ring_size =3D roundup_pow_of_two(bufs_in_recycle_ring /
>                                             efx->rx_bufs_per_page);
>         rx_queue->page_ring =3D kcalloc(page_ring_size,
> diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/=
sfc/rx_common.h
> index 207ccd8ba062..fbd2769307f9 100644
> --- a/drivers/net/ethernet/sfc/rx_common.h
> +++ b/drivers/net/ethernet/sfc/rx_common.h
> @@ -18,6 +18,12 @@
>  #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
>                                       EFX_RX_USR_BUF_SIZE)
>
> +/* Number of RX buffers to recycle pages for.  When creating the RX page=
 recycle
> + * ring, this number is divided by the number of buffers per page to cal=
culate
> + * the number of pages to store in the RX page recycle ring.
> + */
> +#define EFX_RECYCLE_RING_SIZE_10G      256
> +
>  static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
>  {
>         return page_address(buf->page) + buf->page_offset;
> diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/=
siena.c
> index 16347a6d0c47..ce3060e15b54 100644
> --- a/drivers/net/ethernet/sfc/siena.c
> +++ b/drivers/net/ethernet/sfc/siena.c
> @@ -25,6 +25,7 @@
>  #include "mcdi_port_common.h"
>  #include "selftest.h"
>  #include "siena_sriov.h"
> +#include "rx_common.h"
>
>  /* Hardware control for SFC9000 family including SFL9021 (aka Siena). */
>
> @@ -958,6 +959,12 @@ static unsigned int siena_check_caps(const struct ef=
x_nic *efx,
>         return 0;
>  }
>
> +static unsigned int efx_siena_recycle_ring_size(const struct efx_nic *ef=
x)
> +{
> +       /* Maximum link speed is 10G */
> +       return EFX_RECYCLE_RING_SIZE_10G;
> +}
> +
>  /***********************************************************************=
***
>   *
>   * Revision-dependent attributes used by efx.c and nic.c
> @@ -1098,4 +1105,5 @@ const struct efx_nic_type siena_a0_nic_type =3D {
>         .rx_hash_key_size =3D 16,
>         .check_caps =3D siena_check_caps,
>         .sensor_event =3D efx_mcdi_sensor_event,
> +       .rx_recycle_ring_size =3D efx_siena_recycle_ring_size,
>  };
>


--=20
=C3=8D=C3=B1igo Huguet

