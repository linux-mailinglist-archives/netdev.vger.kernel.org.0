Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0F64C401
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbiLNGrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiLNGq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:46:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012A427FF0
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671000337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v2KQ20azENrWlpIXgyPYqWNgjTYAx1e3sSejLKL9vow=;
        b=K2zSYITeg6YqMx4tTlBXv/TicuKo0h7nX1wxQiCrRIg1eInCeW1b2McHzlunCV2Epe0LJt
        4w/ebSvQtMrpHF/MWHnxVI5brbk4D1yIApYOgYojtqh5O2cM+X7cYfN5B2USYm0I0dXrXZ
        ix7Q4FySt99LX12ozrmcuYqQ+igadm4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-xEif0njnNk-4O91wdC55QA-1; Wed, 14 Dec 2022 01:45:34 -0500
X-MC-Unique: xEif0njnNk-4O91wdC55QA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1437fb9949bso4903185fac.5
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:45:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2KQ20azENrWlpIXgyPYqWNgjTYAx1e3sSejLKL9vow=;
        b=jdg9YwLlK8uMlv7bCNs2/T9GmAK6kwCjmGsGdW4rJ8WPyGsC7Ek6+Ztmikd5II0txu
         GyJh+w35DsoaLHmtegASwNlsiJNkMTqaIlGAz1DglW7kqgbojTE3egmNzFhMevUZ4s+9
         FZU2EK42wlAMHr15oEgN+KMALKNtNFYsW1ILKJJfwDTvS9gFXozo7V/DRcW6eXkosZWO
         +O7A7A/ywD5ml/5rne/7AdpdebKE8MB64VYfOljNYgCBZPZq2raWq5UIXI9MbDZQSOiT
         yPsmyAKKW/VyrCo3oG7iVAYAXyCxoXCO5uB3/xU8664lyY8VoiujdILHvnpbm1jR7g2E
         Sorg==
X-Gm-Message-State: ANoB5pnc0Ix/15r/S85eO1SZlk4SAdKFl2E/azMRyurV9qSGVrCf8vUI
        sI1ZxjSuP9wVcorCdsQ7c7gjY5lyfiWdPJqPRTZILu8Ty69PczyRbbkOCBXA3Rwqg5AsoHlzUhn
        QUvqmzFwL5M9foyGJv2qqopB/DYi9dAGW
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr48697768otb.237.1671000333406;
        Tue, 13 Dec 2022 22:45:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5I79yBPGo1C+IpDxbeyXdMdgrFCGinX6RcAZRE5/0EPgf38hOicBhnKpFMgzV4YlUEFETGHmTKLklDNTq5Gog=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr48697758otb.237.1671000333117; Tue, 13
 Dec 2022 22:45:33 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-8-gautam.dawar@amd.com>
In-Reply-To: <20221207145428.31544-8-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Dec 2022 14:45:22 +0800
Message-ID: <CACGkMEsgJCniBiggqX4V+quhBY-Dj1Jnr7H+YD4w6gESOX1SmQ@mail.gmail.com>
Subject: Re: [PATCH net-next 07/11] sfc: implement filters for receiving traffic
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> Implement unicast, broadcast and unknown multicast
> filters for receiving different types of traffic.

I suggest squashing this into the patch that implements set_config().

>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 159 ++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  35 +++++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  27 +++-
>  3 files changed, 220 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index 41eb7aef6798..04d64bfe3c93 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -17,12 +17,168 @@
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
> +static const char * const filter_names[] = { "bcast", "ucast", "mcast" };
>  static struct virtio_device_id ef100_vdpa_id_table[] = {
>         { .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
>         { 0 },
>  };
>
> +static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
> +                                    struct efx_filter_spec *spec,
> +                                    u32 qid,
> +                                    u8 *mac_addr)
> +{
> +       int rc;
> +
> +       efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
> +
> +       if (mac_addr) {
> +               rc = efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSPEC,
> +                                             mac_addr);
> +               if (rc)
> +                       pci_err(efx->pci_dev,
> +                               "Filter set eth local failed, err: %d\n", rc);
> +       } else {
> +               efx_filter_set_mc_def(spec);
> +       }
> +
> +       rc = efx_filter_insert_filter(efx, spec, true);
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
> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
> +       int rc;
> +
> +       if (vdpa_nic->filters[type].filter_id == EFX_INVALID_FILTER_ID)
> +               return rc;
> +
> +       rc = efx_filter_remove_id_safe(vdpa_nic->efx,
> +                                      EFX_FILTER_PRI_AUTO,
> +                                      vdpa_nic->filters[type].filter_id);
> +       if (rc) {
> +               dev_err(&vdev->dev, "%s filter id: %d remove failed, err: %d\n",
> +                       filter_names[type], vdpa_nic->filters[type].filter_id,
> +                       rc);
> +       } else {
> +               vdpa_nic->filters[type].filter_id = EFX_INVALID_FILTER_ID;
> +               vdpa_nic->filter_cnt--;
> +       }
> +       return rc;
> +}
> +
> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
> +                         enum ef100_vdpa_mac_filter_type type)
> +{
> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
> +       struct efx_nic *efx = vdpa_nic->efx;
> +       /* Configure filter on base Rx queue only */
> +       u32 qid = EF100_VDPA_BASE_RX_QID;
> +       struct efx_filter_spec *spec;
> +       u8 baddr[ETH_ALEN];
> +       int rc;
> +
> +       /* remove existing filter */
> +       rc = ef100_vdpa_delete_filter(vdpa_nic, type);
> +       if (rc < 0) {
> +               dev_err(&vdev->dev, "%s MAC filter deletion failed, err: %d",
> +                       filter_names[type], rc);
> +               return rc;
> +       }
> +
> +       /* Configure MAC Filter */
> +       spec = &vdpa_nic->filters[type].spec;
> +       if (type == EF100_VDPA_BCAST_MAC_FILTER) {
> +               eth_broadcast_addr(baddr);
> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
> +       } else if (type == EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
> +       } else {
> +               /* Ensure we have everything required to insert the filter */
> +               if (!vdpa_nic->mac_configured ||
> +                   !vdpa_nic->vring[0].vring_created ||
> +                   !is_valid_ether_addr(vdpa_nic->mac_address))
> +                       return -EINVAL;
> +
> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid,
> +                                              vdpa_nic->mac_address);
> +       }
> +
> +       if (rc >= 0) {
> +               vdpa_nic->filters[type].filter_id = rc;
> +               vdpa_nic->filter_cnt++;

I'm not sure I get this, but the code seems doesn't allow the driver
to set multiple uc filters, so I think filter_cnt should be always 3?
If yes, I don't see how filter_cnt can help here.

> +
> +               return 0;
> +       }
> +
> +       dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
> +               filter_names[type], rc);
> +
> +       if (type != EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
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
> +       int err = 0;
> +       int rc;
> +
> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
> +               rc = ef100_vdpa_delete_filter(vdpa_nic, filter);
> +               if (rc < 0)
> +                       /* store status of last failed filter remove */
> +                       err = rc;
> +       }
> +       return err;
> +}
> +
> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
> +       enum ef100_vdpa_mac_filter_type filter;
> +       int rc;
> +
> +       /* remove existing filters, if any */
> +       rc = ef100_vdpa_filter_remove(vdpa_nic);
> +       if (rc < 0) {
> +               dev_err(&vdev->dev,
> +                       "MAC filter deletion failed, err: %d", rc);
> +               goto fail;
> +       }
> +
> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
> +               if (filter == EF100_VDPA_UCAST_MAC_FILTER &&
> +                   !vdpa_nic->mac_configured)
> +                       continue;
> +               rc = ef100_vdpa_add_filter(vdpa_nic, filter);
> +               if (rc < 0)
> +                       goto fail;
> +       }
> +fail:
> +       return rc;
> +}
> +
>  int ef100_vdpa_init(struct efx_probe_data *probe_data)
>  {
>         struct efx_nic *efx = &probe_data->efx;
> @@ -168,6 +324,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>         ether_addr_copy(vdpa_nic->mac_address, mac);
>         vdpa_nic->mac_configured = true;
>
> +       for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
> +               vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
> +
>         for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++)
>                 vdpa_nic->vring[i].irq = -EINVAL;
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index 3cc33daa0431..a33edd6dda12 100644
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
> + * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to allow
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
> @@ -109,6 +125,17 @@ struct ef100_vdpa_vring_info {
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
> @@ -118,6 +145,7 @@ struct ef100_vdpa_vring_info {
>   * @lock: Managing access to vdpa config operations
>   * @pf_index: PF index of the vDPA VF
>   * @vf_index: VF index of the vDPA VF
> + * @filter_cnt: total number of filters created on this vdpa device
>   * @status: device status as per VIRTIO spec
>   * @features: negotiated feature bits
>   * @max_queue_pairs: maximum number of queue pairs supported
> @@ -125,6 +153,7 @@ struct ef100_vdpa_vring_info {
>   * @vring: vring information of the vDPA device.
>   * @mac_address: mac address of interface associated with this vdpa device
>   * @mac_configured: true after MAC address is configured
> + * @filters: details of all filters created on this vdpa device
>   * @cfg_cb: callback for config change
>   */
>  struct ef100_vdpa_nic {
> @@ -135,6 +164,7 @@ struct ef100_vdpa_nic {
>         struct mutex lock;
>         u32 pf_index;
>         u32 vf_index;
> +       u32 filter_cnt;
>         u8 status;
>         u64 features;
>         u32 max_queue_pairs;
> @@ -142,6 +172,7 @@ struct ef100_vdpa_nic {
>         struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>         u8 *mac_address;
>         bool mac_configured;
> +       struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
>         struct vdpa_callback cfg_cb;
>  };
>
> @@ -149,6 +180,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>  int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
> +                         enum ef100_vdpa_mac_filter_type type);
>  int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>  void ef100_vdpa_irq_vectors_free(void *data);
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> index b7efd3e0c901..132ddb4a647b 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -135,6 +135,15 @@ static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>         if (vdpa_nic->vring[idx].vring_ctx)
>                 delete_vring_ctx(vdpa_nic, idx);
>
> +       if (idx == 0 && vdpa_nic->filter_cnt != 0) {
> +               rc = ef100_vdpa_filter_remove(vdpa_nic);
> +               if (rc < 0) {
> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
> +                               "%s: vdpa remove filter failed, err:%d\n",
> +                               __func__, rc);
> +               }
> +       }
> +
>         return rc;
>  }
>
> @@ -193,8 +202,22 @@ static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>                 vdpa_nic->vring[idx].doorbell_offset_valid = true;
>         }
>
> +       /* Configure filters on rxq 0 */
> +       if (idx == 0) {

This seems tricky, can we move this to set_status() when DRIVER_OK is set?

Thanks


> +               rc = ef100_vdpa_filter_configure(vdpa_nic);
> +               if (rc < 0) {
> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
> +                               "%s: vdpa configure filter failed, err:%d\n",
> +                               __func__, rc);
> +                       goto err_filter_configure;
> +               }
> +       }
> +
>         return 0;
>
> +err_filter_configure:
> +       ef100_vdpa_filter_remove(vdpa_nic);
> +       vdpa_nic->vring[idx].doorbell_offset_valid = false;
>  err_get_doorbell_offset:
>         efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>                                &vring_dyn_cfg);
> @@ -578,8 +601,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>         }
>
>         memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
> -       if (is_valid_ether_addr(vdpa_nic->mac_address))
> +       if (is_valid_ether_addr(vdpa_nic->mac_address)) {
>                 vdpa_nic->mac_configured = true;
> +               ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
> +       }
>  }
>
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
> --
> 2.30.1
>

