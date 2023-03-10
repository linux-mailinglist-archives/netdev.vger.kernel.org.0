Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587006B35E9
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjCJFHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCJFGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:06:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1C7F4028
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EW/5uJ+gbchj0oFpoN6s2e82FkCV95fwvJDV7j5UgeA=;
        b=ar7/dX7lWOB9jps3BuvFZ65gtlt6vFtKL+dCYdGNFXtgPKMVqTI9tTxfcYB23EroO0/IXt
        NhfuY2jPKUzshIq8llbtXgQXwNvf3eHe3xkvIb7EiHjLNotWWGFUaZ77sSLJQszRj/f3Rv
        zUdQo+E6asHMIo9Ri6IT9XbDlXYcXDs=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-jvnpEsGeMnu91l1eMwmDUQ-1; Fri, 10 Mar 2023 00:05:29 -0500
X-MC-Unique: jvnpEsGeMnu91l1eMwmDUQ-1
Received: by mail-oi1-f200.google.com with SMTP id bf30-20020a056808191e00b003843744eaecso1983733oib.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:05:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EW/5uJ+gbchj0oFpoN6s2e82FkCV95fwvJDV7j5UgeA=;
        b=7SvVXfOgu8nSw5j8e36XTOa0pi1oBFdcxUSHkC18Kg2Wh0RLwYeiB0250n4nPK7TRE
         4o1Jm6nQUR2VelvzF3Wlc3BjekVcUmMOqPrRg43ToPDiE6I55Jc5kwu3HihsfcpdFMAE
         Xf4cgv9/+ZHSW3IhkGHjXHC+MLTXNum7K3bfSllQ8jNAieAHMrdEToajg23lGv4tLbwU
         eB9O9Lh4cMXenseFlcaCuuku24Rc4uxvu3QZ6Gr4J3qD2aC0cXbQLQyA74IUNtYcjZdf
         gHfvdh4u/uGi2enRLSPH9WUs1CwlJUgjEqSc6QvloO577KfnLnGwehldfYSgGJlJ1e5C
         SpzQ==
X-Gm-Message-State: AO0yUKUyri/Apycy96WWRNH/9669rBI5yEACMyJQ696m1i+bhaq2J1XY
        RDQ4stgQ3tQVjLcrehNDNwCYeOfEpEbdI+2akZeNosRC0RltTpLVgpIn1OsLo9GKUKKUkk0Kwhk
        qRbcM10O10RNYFCoW4BgCwbyMWAVgxg4T
X-Received: by 2002:a05:6870:c799:b0:176:3b36:3733 with SMTP id dy25-20020a056870c79900b001763b363733mr7230724oab.9.1678424728358;
        Thu, 09 Mar 2023 21:05:28 -0800 (PST)
X-Google-Smtp-Source: AK7set+0NeZ12HS5lDzKd+RnVyCXkDIaKwwnZVp2wxBrHlOPZvMuZNq34/7zajGvfi9eygPFirjUvjkQjjBzP3w+Ce8=
X-Received: by 2002:a05:6870:c799:b0:176:3b36:3733 with SMTP id
 dy25-20020a056870c79900b001763b363733mr7230707oab.9.1678424727935; Thu, 09
 Mar 2023 21:05:27 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-11-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-11-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:05:16 +0800
Message-ID: <CACGkMEvydZGva7onADoG7H-1a6upjD1bv1Aw90eRDEFp+Hv2Jg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 10/14] sfc: implement filters for receiving traffic
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:38=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> Implement unicast, broadcast and unknown multicast
> filters for receiving different types of traffic.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 157 ++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  36 ++++-
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  17 ++-
>  3 files changed, 207 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet=
/sfc/ef100_vdpa.c
> index 4ba57827a6cd..5c9f29f881a6 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -16,12 +16,166 @@
>  #include "mcdi_filters.h"
>  #include "mcdi_functions.h"
>  #include "ef100_netdev.h"
> +#include "filter.h"
> +#include "efx.h"
>
> +#define EFX_INVALID_FILTER_ID -1
> +
> +/* vDPA queues starts from 2nd VI or qid 1 */
> +#define EF100_VDPA_BASE_RX_QID 1
> +
> +static const char * const filter_names[] =3D { "bcast", "ucast", "mcast"=
 };
>  static struct virtio_device_id ef100_vdpa_id_table[] =3D {
>         { .device =3D VIRTIO_ID_NET, .vendor =3D PCI_VENDOR_ID_REDHAT_QUM=
RANET },
>         { 0 },
>  };
>
> +static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
> +                                    struct efx_filter_spec *spec,
> +                                    u32 qid, u8 *mac_addr)
> +{
> +       int rc;
> +
> +       efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
> +
> +       if (mac_addr) {
> +               rc =3D efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSP=
EC,
> +                                             mac_addr);
> +               if (rc)
> +                       pci_err(efx->pci_dev,
> +                               "Filter set eth local failed, err: %d\n",=
 rc);
> +       } else {
> +               efx_filter_set_mc_def(spec);
> +       }
> +
> +       rc =3D efx_filter_insert_filter(efx, spec, true);
> +       if (rc < 0)
> +               pci_err(efx->pci_dev,
> +                       "Filter insert failed, err: %d\n", rc);
> +
> +       return rc;
> +}
> +
> +static int ef100_vdpa_delete_filter(struct ef100_vdpa_nic *vdpa_nic,
> +                                   enum ef100_vdpa_mac_filter_type type)
> +{
> +       struct vdpa_device *vdev =3D &vdpa_nic->vdpa_dev;
> +       int rc;
> +
> +       if (vdpa_nic->filters[type].filter_id =3D=3D EFX_INVALID_FILTER_I=
D)
> +               return rc;
> +
> +       rc =3D efx_filter_remove_id_safe(vdpa_nic->efx,
> +                                      EFX_FILTER_PRI_AUTO,
> +                                      vdpa_nic->filters[type].filter_id)=
;
> +       if (rc) {
> +               dev_err(&vdev->dev, "%s filter id: %d remove failed, err:=
 %d\n",
> +                       filter_names[type], vdpa_nic->filters[type].filte=
r_id,
> +                       rc);
> +       } else {
> +               vdpa_nic->filters[type].filter_id =3D EFX_INVALID_FILTER_=
ID;
> +               vdpa_nic->filter_cnt--;
> +       }
> +       return rc;
> +}
> +
> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
> +                         enum ef100_vdpa_mac_filter_type type)
> +{
> +       struct vdpa_device *vdev =3D &vdpa_nic->vdpa_dev;
> +       struct efx_nic *efx =3D vdpa_nic->efx;
> +       /* Configure filter on base Rx queue only */
> +       u32 qid =3D EF100_VDPA_BASE_RX_QID;
> +       struct efx_filter_spec *spec;
> +       u8 baddr[ETH_ALEN];
> +       int rc;
> +
> +       /* remove existing filter */
> +       rc =3D ef100_vdpa_delete_filter(vdpa_nic, type);
> +       if (rc < 0) {
> +               dev_err(&vdev->dev, "%s MAC filter deletion failed, err: =
%d",
> +                       filter_names[type], rc);
> +               return rc;
> +       }
> +
> +       /* Configure MAC Filter */
> +       spec =3D &vdpa_nic->filters[type].spec;
> +       if (type =3D=3D EF100_VDPA_BCAST_MAC_FILTER) {
> +               eth_broadcast_addr(baddr);
> +               rc =3D ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
> +       } else if (type =3D=3D EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
> +               rc =3D ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
> +       } else {
> +               /* Ensure we have a valid mac address */
> +               if (!vdpa_nic->mac_configured ||
> +                   !is_valid_ether_addr(vdpa_nic->mac_address))
> +                       return -EINVAL;
> +
> +               rc =3D ef100_vdpa_set_mac_filter(efx, spec, qid,
> +                                              vdpa_nic->mac_address);
> +       }
> +
> +       if (rc >=3D 0) {
> +               vdpa_nic->filters[type].filter_id =3D rc;
> +               vdpa_nic->filter_cnt++;
> +
> +               return 0;
> +       }
> +
> +       dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
> +               filter_names[type], rc);
> +
> +       if (type !=3D EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
> +               ef100_vdpa_filter_remove(vdpa_nic);
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       enum ef100_vdpa_mac_filter_type filter;
> +       int err =3D 0;
> +       int rc;
> +
> +       for (filter =3D EF100_VDPA_BCAST_MAC_FILTER;
> +            filter <=3D EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
> +               rc =3D ef100_vdpa_delete_filter(vdpa_nic, filter);
> +               if (rc < 0)
> +                       /* store status of last failed filter remove */
> +                       err =3D rc;
> +       }
> +       return err;
> +}
> +
> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       struct vdpa_device *vdev =3D &vdpa_nic->vdpa_dev;
> +       enum ef100_vdpa_mac_filter_type filter;
> +       int rc;
> +
> +       /* remove existing filters, if any */
> +       rc =3D ef100_vdpa_filter_remove(vdpa_nic);
> +       if (rc < 0) {
> +               dev_err(&vdev->dev,
> +                       "MAC filter deletion failed, err: %d", rc);
> +               goto fail;
> +       }
> +
> +       for (filter =3D EF100_VDPA_BCAST_MAC_FILTER;
> +            filter <=3D EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
> +               if (filter =3D=3D EF100_VDPA_UCAST_MAC_FILTER &&
> +                   !vdpa_nic->mac_configured)
> +                       continue;

Nit: is this better to move this inside ef100_vdpa_add_filter()?

> +               rc =3D ef100_vdpa_add_filter(vdpa_nic, filter);
> +               if (rc < 0)
> +                       goto fail;
> +       }
> +fail:
> +       return rc;
> +}
> +
>  int ef100_vdpa_init(struct efx_probe_data *probe_data)
>  {
>         struct efx_nic *efx =3D &probe_data->efx;
> @@ -185,6 +339,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struc=
t efx_nic *efx,
>                 goto err_put_device;
>         }
>
> +       for (i =3D 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
> +               vdpa_nic->filters[i].filter_id =3D EFX_INVALID_FILTER_ID;
> +
>         rc =3D get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet=
/sfc/ef100_vdpa.h
> index 58791402e454..49fb6be04eb3 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -72,6 +72,22 @@ enum ef100_vdpa_vq_type {
>         EF100_VDPA_VQ_NTYPES
>  };
>
> +/**
> + * enum ef100_vdpa_mac_filter_type - vdpa filter types
> + *
> + * @EF100_VDPA_BCAST_MAC_FILTER: Broadcast MAC filter
> + * @EF100_VDPA_UCAST_MAC_FILTER: Unicast MAC filter
> + * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to=
 allow
> + *     IPv6 Neighbor Solicitation Message
> + * @EF100_VDPA_MAC_FILTER_NTYPES: Number of vDPA filter types
> + */
> +enum ef100_vdpa_mac_filter_type {
> +       EF100_VDPA_BCAST_MAC_FILTER,
> +       EF100_VDPA_UCAST_MAC_FILTER,
> +       EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER,
> +       EF100_VDPA_MAC_FILTER_NTYPES,
> +};
> +
>  /**
>   * struct ef100_vdpa_vring_info - vDPA vring data structure
>   *
> @@ -107,6 +123,17 @@ struct ef100_vdpa_vring_info {
>         struct vdpa_callback cb;
>  };
>
> +/**
> + * struct ef100_vdpa_filter - vDPA filter data structure
> + *
> + * @filter_id: filter id of this filter
> + * @efx_filter_spec: hardware filter specs for this vdpa device
> + */
> +struct ef100_vdpa_filter {
> +       s32 filter_id;
> +       struct efx_filter_spec spec;
> +};
> +
>  /**
>   *  struct ef100_vdpa_nic - vDPA NIC data structure
>   *
> @@ -116,6 +143,7 @@ struct ef100_vdpa_vring_info {
>   * @lock: Managing access to vdpa config operations
>   * @pf_index: PF index of the vDPA VF
>   * @vf_index: VF index of the vDPA VF
> + * @filter_cnt: total number of filters created on this vdpa device
>   * @status: device status as per VIRTIO spec
>   * @features: negotiated feature bits
>   * @max_queue_pairs: maximum number of queue pairs supported
> @@ -123,6 +151,7 @@ struct ef100_vdpa_vring_info {
>   * @vring: vring information of the vDPA device.
>   * @mac_address: mac address of interface associated with this vdpa devi=
ce
>   * @mac_configured: true after MAC address is configured
> + * @filters: details of all filters created on this vdpa device
>   * @cfg_cb: callback for config change
>   */
>  struct ef100_vdpa_nic {
> @@ -133,6 +162,7 @@ struct ef100_vdpa_nic {
>         struct mutex lock;
>         u32 pf_index;
>         u32 vf_index;
> +       u32 filter_cnt;
>         u8 status;
>         u64 features;
>         u32 max_queue_pairs;
> @@ -140,6 +170,7 @@ struct ef100_vdpa_nic {
>         struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * =
2];
>         u8 *mac_address;
>         bool mac_configured;
> +       struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
>         struct vdpa_callback cfg_cb;
>  };
>
> @@ -147,7 +178,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_dat=
a);
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>  int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
> -void ef100_vdpa_irq_vectors_free(void *data);
> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
> +                         enum ef100_vdpa_mac_filter_type type);
>  int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>  void ef100_vdpa_irq_vectors_free(void *data);
>  int ef100_vdpa_reset(struct vdpa_device *vdev);
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethe=
rnet/sfc/ef100_vdpa_ops.c
> index 95a2177f85a2..db86c2693950 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -261,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa=
_nic *vdpa_nic)
>         vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_INITIALIZED;
>         vdpa_nic->status =3D 0;
>         vdpa_nic->features =3D 0;
> +       ef100_vdpa_filter_remove(vdpa_nic);
>         for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>                 reset_vring(vdpa_nic, i);
>         ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
> @@ -295,7 +296,7 @@ static int start_vdpa_device(struct ef100_vdpa_nic *v=
dpa_nic)
>         rc =3D ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>                                           vdpa_nic->max_queue_pairs * 2);
>         if (rc < 0) {
> -               pci_err(efx->pci_dev,
> +               dev_err(&vdpa_nic->vdpa_dev.dev,

This should be done in the previous patch.

Thanks


>                         "vDPA IRQ alloc failed for vf: %u err:%d\n",
>                         nic_data->vf_index, rc);
>                 return rc;
> @@ -309,9 +310,19 @@ static int start_vdpa_device(struct ef100_vdpa_nic *=
vdpa_nic)
>                 }
>         }
>
> +       rc =3D ef100_vdpa_filter_configure(vdpa_nic);
> +       if (rc < 0) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: vdpa configure filter failed, err: %d\n",
> +                       __func__, rc);
> +               goto err_filter_configure;
> +       }
> +
>         vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_STARTED;
>         return 0;
>
> +err_filter_configure:
> +       ef100_vdpa_filter_remove(vdpa_nic);
>  clear_vring:
>         for (j =3D 0; j < i; j++)
>                 delete_vring(vdpa_nic, j);
> @@ -680,8 +691,10 @@ static void ef100_vdpa_set_config(struct vdpa_device=
 *vdev, unsigned int offset,
>         }
>
>         memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
> -       if (is_valid_ether_addr(vdpa_nic->mac_address))
> +       if (is_valid_ether_addr(vdpa_nic->mac_address)) {
>                 vdpa_nic->mac_configured =3D true;
> +               ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILT=
ER);
> +       }
>  }
>
>  static int ef100_vdpa_suspend(struct vdpa_device *vdev)
> --
> 2.30.1
>

