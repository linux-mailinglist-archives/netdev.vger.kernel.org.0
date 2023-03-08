Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ABE6B0EFB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCHQlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCHQlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:41:20 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B936B8F06;
        Wed,  8 Mar 2023 08:41:17 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t15so15982755wrz.7;
        Wed, 08 Mar 2023 08:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678293676;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0hixepby8ZCCQCn1U7cWOgA/dVWJcHpapAYtQnOePs=;
        b=oFW9eqmoJ8SfPxM3Vf841USquUgE6Z45IyA0KZmQs87yFyfnd8QadIBYE9Ybvh5qHy
         +nqrOXsEQSXmQ0VFsdv/IQdeH3Jiy4NozDEbIXWM/gXY5WAVRiol3/N6dRxnKj9XPsR7
         S8IIS77lQhGBDRfA3vs7+UI6U08tdF2BCSQHRIVDxIaYcI5278A8FQp7yuidkeFpisJO
         rzW9IthaK7U6jZUV8peHENuYNuLJIuumPmOtlwWDL/HlyGHbU2GhE4uiZua46m+EVo9Q
         xlAU6uODKykjgqe9hAKbBK+Jr3daIe58PiteB9fSYNkLC8mFtsLYIADvBD7j1IT19cU1
         z7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678293676;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0hixepby8ZCCQCn1U7cWOgA/dVWJcHpapAYtQnOePs=;
        b=klL7HbcXBbn7KgSq07OxYQT+joiXRRhwgyF5JV8lfYG3///CWdcvbOdndVHG2rXRxm
         W70uNpYwkBvuZj5tEoN7vQp6LSv1QvRmeIaBmnX9sByY06XzxpoGfuVuAUOsvEF8lZ/M
         Zsbd8b0ULkaV/o1HLZChMu4zfG9LV4cut+ach5V4BuuyST+Y9B5oht7NI3QZbCfAx6es
         fN2ABRWsydiOI/e5VcZDJAG+fC+9Ipv8OC3C9GAFPz5BL4OB5aj6WAF/FDf259q2iIwd
         FuuspYwHCEede9N60BIQ3gVx6recs4ZPZgWNeOIUr2VnYr3VTnsajJphy4t/8O8GFf8Y
         DaDw==
X-Gm-Message-State: AO0yUKWkwCO2s1js0f1e9MSjdTsE4rlib1u07DHV9CxIlSDQnvxklRIB
        ZICiseeiFdA1yq2j1Bj4VhBfztKZx64=
X-Google-Smtp-Source: AK7set+vjadK2VW4rIXQphUen7ODUtW9S2zFYSZ2Ge1r8IlY1G/JYxz1hsDIDRw1rc01ebyiEsy7kQ==
X-Received: by 2002:a5d:4ec5:0:b0:2c7:1e32:f7ff with SMTP id s5-20020a5d4ec5000000b002c71e32f7ffmr11471809wrv.16.1678293675841;
        Wed, 08 Mar 2023 08:41:15 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v5-20020a5d43c5000000b002c55de1c72bsm15258930wrr.62.2023.03.08.08.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:41:15 -0800 (PST)
Date:   Wed, 8 Mar 2023 16:41:13 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 06/14] sfc: implement vDPA management device
 operations
Message-ID: <ZAi6qWwHYKIQ1ay/@gmail.com>
Mail-Followup-To: Gautam Dawar <gautam.dawar@amd.com>,
        linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-7-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307113621.64153-7-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 05:06:08PM +0530, Gautam Dawar wrote:
> To allow vDPA device creation and deletion, add a vDPA management
> device per function. Currently, the vDPA devices can be created
> only on a VF. Also, for now only network class of vDPA devices
> are supported.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/Makefile         |   2 +-
>  drivers/net/ethernet/sfc/ef10.c           |   2 +-
>  drivers/net/ethernet/sfc/ef100_nic.c      |  27 ++-
>  drivers/net/ethernet/sfc/ef100_nic.h      |   9 +
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 228 ++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  84 ++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  30 +++
>  drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
>  drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
>  drivers/net/ethernet/sfc/net_driver.h     |   6 +
>  10 files changed, 393 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> 
> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
> index 3a2bb98d1c3f..bd8ba588b968 100644
> --- a/drivers/net/ethernet/sfc/Makefile
> +++ b/drivers/net/ethernet/sfc/Makefile
> @@ -12,7 +12,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
>  sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>                             mae.o tc.o tc_bindings.o tc_counters.o
>  
> -sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o
> +sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
>  obj-$(CONFIG_SFC)	+= sfc.o
>  
>  obj-$(CONFIG_SFC_FALCON) += falcon/
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 7022fb2005a2..366ecd3c80b1 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -589,7 +589,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
>  	if (rc)
>  		goto fail4;
>  
> -	rc = efx_get_pf_index(efx, &nic_data->pf_index);
> +	rc = efx_get_fn_info(efx, &nic_data->pf_index, NULL);
>  	if (rc)
>  		goto fail5;
>  
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 8a9fff239d07..bda4fcbe1126 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -1164,7 +1164,7 @@ static int ef100_probe_main(struct efx_nic *efx)
>  	if (rc)
>  		goto fail;
>  
> -	rc = efx_get_pf_index(efx, &nic_data->pf_index);
> +	rc = efx_get_fn_info(efx, &nic_data->pf_index, &nic_data->vf_index);
>  	if (rc)
>  		goto fail;
>  
> @@ -1280,13 +1280,36 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  
>  int ef100_probe_vf(struct efx_nic *efx)
>  {
> -	return ef100_probe_main(efx);
> +#if defined(CONFIG_SFC_VDPA)
> +	struct ef100_nic_data *nic_data;
> +	int err;
> +#endif

This looks like an opportunity to use __maybe_unused in stead of the #ifdef.
See section "Conditional Compilation" in Documentation/process/coding-style.rst

> +	int rc;
> +
> +	rc = ef100_probe_main(efx);
> +	if (rc)
> +		return rc;
> +
> +#if defined(CONFIG_SFC_VDPA)

and use IS_ENABLED() here as per that same section.

> +	nic_data = efx->nic_data;
> +	if (nic_data->vdpa_supported) {
> +		err = ef100_vdpa_register_mgmtdev(efx);
> +		if (err)
> +			pci_warn(efx->pci_dev,
> +				 "vdpa_register_mgmtdev failed, rc: %d\n", err);
> +	}
> +#endif
> +	return 0;
>  }
>  
>  void ef100_remove(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  
> +#if defined(CONFIG_SFC_VDPA)
> +	if (nic_data->vdpa_supported)
> +		ef100_vdpa_unregister_mgmtdev(efx);
> +#endif

Same comment here.

Martin

>  	if (IS_ENABLED(CONFIG_SFC_SRIOV) && efx->mae) {
>  		efx_ef100_fini_reps(efx);
>  		efx_fini_mae(efx);
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> index 117a73d0795c..71404bfc2a5a 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -68,6 +68,13 @@ enum ef100_bar_config {
>  	EF100_BAR_CONFIG_VDPA,
>  };
>  
> +#ifdef CONFIG_SFC_VDPA
> +enum ef100_vdpa_class {
> +	EF100_VDPA_CLASS_NONE,
> +	EF100_VDPA_CLASS_NET,
> +};
> +#endif
> +
>  struct ef100_nic_data {
>  	struct efx_nic *efx;
>  	struct efx_buffer mcdi_buf;
> @@ -75,9 +82,11 @@ struct ef100_nic_data {
>  	u32 datapath_caps2;
>  	u32 datapath_caps3;
>  	unsigned int pf_index;
> +	unsigned int vf_index;
>  	u16 warm_boot_count;
>  #ifdef CONFIG_SFC_VDPA
>  	bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
> +	enum ef100_vdpa_class vdpa_class;
>  #endif
>  	u8 port_id[ETH_ALEN];
>  	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index 268c973f7376..4c5a98c9d6c3 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -10,11 +10,17 @@
>  #include <linux/err.h>
>  #include <linux/vdpa.h>
>  #include <linux/virtio_net.h>
> +#include <uapi/linux/vdpa.h>
>  #include "ef100_vdpa.h"
>  #include "mcdi_vdpa.h"
>  #include "mcdi_filters.h"
>  #include "ef100_netdev.h"
>  
> +static struct virtio_device_id ef100_vdpa_id_table[] = {
> +	{ .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
> +	{ 0 },
> +};
> +
>  int ef100_vdpa_init(struct efx_probe_data *probe_data)
>  {
>  	struct efx_nic *efx = &probe_data->efx;
> @@ -41,17 +47,239 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
>  	return rc;
>  }
>  
> +static void ef100_vdpa_delete(struct efx_nic *efx)
> +{
> +	if (efx->vdpa_nic) {
> +		/* replace with _vdpa_unregister_device later */
> +		put_device(&efx->vdpa_nic->vdpa_dev.dev);
> +	}
> +}
> +
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>  {
>  	struct efx_nic *efx = &probe_data->efx;
> +	struct ef100_nic_data *nic_data;
>  
>  	if (efx->state != STATE_VDPA && efx->state != STATE_DISABLED) {
>  		pci_err(efx->pci_dev, "Invalid efx state %u", efx->state);
>  		return;
>  	}
>  
> +	/* Handle vdpa device deletion, if not done explicitly */
> +	ef100_vdpa_delete(efx);
> +	nic_data = efx->nic_data;
> +	nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>  	efx->state = STATE_PROBED;
>  	down_write(&efx->filter_sem);
>  	efx_mcdi_filter_table_remove(efx);
>  	up_write(&efx->filter_sem);
>  }
> +
> +static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +	struct efx_nic *efx = vdpa_nic->efx;
> +	u16 mtu;
> +	int rc;
> +
> +	vdpa_nic->net_config.max_virtqueue_pairs =
> +		cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
> +
> +	rc = efx_vdpa_get_mtu(efx, &mtu);
> +	if (rc) {
> +		dev_err(&vdpa_nic->vdpa_dev.dev,
> +			"%s: Get MTU for vf:%u failed:%d\n", __func__,
> +			vdpa_nic->vf_index, rc);
> +		return rc;
> +	}
> +	vdpa_nic->net_config.mtu = cpu_to_efx_vdpa16(vdpa_nic, mtu);
> +	vdpa_nic->net_config.status = cpu_to_efx_vdpa16(vdpa_nic,
> +							VIRTIO_NET_S_LINK_UP);
> +	return 0;
> +}
> +
> +static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
> +						const char *dev_name,
> +						enum ef100_vdpa_class dev_type,
> +						const u8 *mac)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	struct ef100_vdpa_nic *vdpa_nic;
> +	int rc;
> +
> +	nic_data->vdpa_class = dev_type;
> +	vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
> +				     vdpa_dev, &efx->pci_dev->dev,
> +				     &ef100_vdpa_config_ops,
> +				     1, 1,
> +				     dev_name, false);
> +	if (!vdpa_nic) {
> +		pci_err(efx->pci_dev,
> +			"vDPA device allocation failed for vf: %u\n",
> +			nic_data->vf_index);
> +		nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	mutex_init(&vdpa_nic->lock);
> +	efx->vdpa_nic = vdpa_nic;
> +	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
> +	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
> +	vdpa_nic->efx = efx;
> +	vdpa_nic->pf_index = nic_data->pf_index;
> +	vdpa_nic->vf_index = nic_data->vf_index;
> +	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
> +	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
> +
> +	rc = get_net_config(vdpa_nic);
> +	if (rc)
> +		goto err_put_device;
> +
> +	if (mac) {
> +		ether_addr_copy(vdpa_nic->mac_address, mac);
> +		vdpa_nic->mac_configured = true;
> +	}
> +
> +	/* _vdpa_register_device when its ready */
> +
> +	return vdpa_nic;
> +
> +err_put_device:
> +	/* put_device invokes ef100_vdpa_free */
> +	put_device(&vdpa_nic->vdpa_dev.dev);
> +	return ERR_PTR(rc);
> +}
> +
> +static void ef100_vdpa_net_dev_del(struct vdpa_mgmt_dev *mgmt_dev,
> +				   struct vdpa_device *vdev)
> +{
> +	struct ef100_nic_data *nic_data;
> +	struct efx_nic *efx;
> +	int rc;
> +
> +	efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
> +	nic_data = efx->nic_data;
> +
> +	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
> +	if (rc)
> +		pci_err(efx->pci_dev,
> +			"set_bar_config EF100 failed, err: %d\n", rc);
> +	else
> +		pci_dbg(efx->pci_dev,
> +			"vdpa net device deleted, vf: %u\n",
> +			nic_data->vf_index);
> +}
> +
> +static int ef100_vdpa_net_dev_add(struct vdpa_mgmt_dev *mgmt_dev,
> +				  const char *name,
> +				  const struct vdpa_dev_set_config *config)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic;
> +	struct ef100_nic_data *nic_data;
> +	const u8 *mac = NULL;
> +	struct efx_nic *efx;
> +	int rc, err;
> +
> +	if (config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> +		if (!is_valid_ether_addr(config->net.mac)) {
> +			pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
> +				config->net.mac);
> +			return -EINVAL;
> +		}
> +		mac = (const u8 *)config->net.mac;
> +	}
> +
> +	efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
> +	if (efx->vdpa_nic) {
> +		pci_warn(efx->pci_dev,
> +			 "vDPA device already exists on this VF\n");
> +		return -EEXIST;
> +	}
> +
> +	nic_data = efx->nic_data;
> +
> +	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_VDPA);
> +	if (rc) {
> +		pci_err(efx->pci_dev,
> +			"set_bar_config vDPA failed, err: %d\n", rc);
> +		goto err_set_bar_config;
> +	}
> +
> +	vdpa_nic = ef100_vdpa_create(efx, name, EF100_VDPA_CLASS_NET, mac);
> +	if (IS_ERR(vdpa_nic)) {
> +		pci_err(efx->pci_dev,
> +			"vDPA device creation failed, vf: %u, err: %ld\n",
> +			nic_data->vf_index, PTR_ERR(vdpa_nic));
> +		rc = PTR_ERR(vdpa_nic);
> +		goto err_set_bar_config;
> +	} else {
> +		pci_dbg(efx->pci_dev,
> +			"vdpa net device created, vf: %u\n",
> +			nic_data->vf_index);
> +	}
> +
> +	return 0;
> +
> +err_set_bar_config:
> +	err = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
> +	if (err)
> +		pci_err(efx->pci_dev,
> +			"set_bar_config EF100 failed, err: %d\n", err);
> +
> +	return rc;
> +}
> +
> +static const struct vdpa_mgmtdev_ops ef100_vdpa_net_mgmtdev_ops = {
> +	.dev_add = ef100_vdpa_net_dev_add,
> +	.dev_del = ef100_vdpa_net_dev_del
> +};
> +
> +int ef100_vdpa_register_mgmtdev(struct efx_nic *efx)
> +{
> +	struct vdpa_mgmt_dev *mgmt_dev;
> +	u64 features;
> +	int rc;
> +
> +	mgmt_dev = kzalloc(sizeof(*mgmt_dev), GFP_KERNEL);
> +	if (!mgmt_dev)
> +		return -ENOMEM;
> +
> +	rc = efx_vdpa_get_features(efx, EF100_VDPA_DEVICE_TYPE_NET, &features);
> +	if (rc) {
> +		pci_err(efx->pci_dev, "%s: MCDI get features error:%d\n",
> +			__func__, rc);
> +		goto err_get_features;
> +	}
> +
> +	efx->mgmt_dev = mgmt_dev;
> +	mgmt_dev->device = &efx->pci_dev->dev;
> +	mgmt_dev->id_table = ef100_vdpa_id_table;
> +	mgmt_dev->ops = &ef100_vdpa_net_mgmtdev_ops;
> +	mgmt_dev->supported_features = features;
> +	mgmt_dev->max_supported_vqs = EF100_VDPA_MAX_QUEUES_PAIRS * 2;
> +	mgmt_dev->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
> +
> +	rc = vdpa_mgmtdev_register(mgmt_dev);
> +	if (rc) {
> +		pci_err(efx->pci_dev,
> +			"vdpa_mgmtdev_register failed, err: %d\n", rc);
> +		goto err_mgmtdev_register;
> +	}
> +
> +	return 0;
> +
> +err_mgmtdev_register:
> +err_get_features:
> +	kfree(mgmt_dev);
> +	efx->mgmt_dev = NULL;
> +
> +	return rc;
> +}
> +
> +void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx)
> +{
> +	if (efx->mgmt_dev) {
> +		vdpa_mgmtdev_unregister(efx->mgmt_dev);
> +		kfree(efx->mgmt_dev);
> +		efx->mgmt_dev = NULL;
> +	}
> +}
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index ccc5eb0a2a84..1101b30f56e7 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -17,6 +17,24 @@
>  
>  #if defined(CONFIG_SFC_VDPA)
>  
> +/* Max queue pairs currently supported */
> +#define EF100_VDPA_MAX_QUEUES_PAIRS 1
> +
> +/**
> + * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
> + *
> + * @EF100_VDPA_STATE_INITIALIZED: State after vDPA NIC created
> + * @EF100_VDPA_STATE_NEGOTIATED: State after feature negotiation
> + * @EF100_VDPA_STATE_STARTED: State after driver ok
> + * @EF100_VDPA_STATE_NSTATES: Number of VDPA states
> + */
> +enum ef100_vdpa_nic_state {
> +	EF100_VDPA_STATE_INITIALIZED,
> +	EF100_VDPA_STATE_NEGOTIATED,
> +	EF100_VDPA_STATE_STARTED,
> +	EF100_VDPA_STATE_NSTATES
> +};
> +
>  enum ef100_vdpa_device_type {
>  	EF100_VDPA_DEVICE_TYPE_NET,
>  };
> @@ -27,7 +45,73 @@ enum ef100_vdpa_vq_type {
>  	EF100_VDPA_VQ_NTYPES
>  };
>  
> +/**
> + *  struct ef100_vdpa_nic - vDPA NIC data structure
> + *
> + * @vdpa_dev: vdpa_device object which registers on the vDPA bus.
> + * @vdpa_state: NIC state machine governed by ef100_vdpa_nic_state
> + * @efx: pointer to the VF's efx_nic object
> + * @lock: Managing access to vdpa config operations
> + * @pf_index: PF index of the vDPA VF
> + * @vf_index: VF index of the vDPA VF
> + * @status: device status as per VIRTIO spec
> + * @features: negotiated feature bits
> + * @max_queue_pairs: maximum number of queue pairs supported
> + * @net_config: virtio_net_config data
> + * @mac_address: mac address of interface associated with this vdpa device
> + * @mac_configured: true after MAC address is configured
> + */
> +struct ef100_vdpa_nic {
> +	struct vdpa_device vdpa_dev;
> +	enum ef100_vdpa_nic_state vdpa_state;
> +	struct efx_nic *efx;
> +	/* for synchronizing access to vdpa config operations */
> +	struct mutex lock;
> +	u32 pf_index;
> +	u32 vf_index;
> +	u8 status;
> +	u64 features;
> +	u32 max_queue_pairs;
> +	struct virtio_net_config net_config;
> +	u8 *mac_address;
> +	bool mac_configured;
> +};
> +
>  int ef100_vdpa_init(struct efx_probe_data *probe_data);
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data);
> +int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
> +void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
> +
> +static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +	return virtio_legacy_is_little_endian() ||
> +		(vdpa_nic->features & (1ULL << VIRTIO_F_VERSION_1));
> +}
> +
> +static inline u16 efx_vdpa16_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
> +				    __virtio16 val)
> +{
> +	return __virtio16_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
> +}
> +
> +static inline __virtio16 cpu_to_efx_vdpa16(struct ef100_vdpa_nic *vdpa_nic,
> +					   u16 val)
> +{
> +	return __cpu_to_virtio16(efx_vdpa_is_little_endian(vdpa_nic), val);
> +}
> +
> +static inline u32 efx_vdpa32_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
> +				    __virtio32 val)
> +{
> +	return __virtio32_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
> +}
> +
> +static inline __virtio32 cpu_to_efx_vdpa32(struct ef100_vdpa_nic *vdpa_nic,
> +					   u32 val)
> +{
> +	return __cpu_to_virtio32(efx_vdpa_is_little_endian(vdpa_nic), val);
> +}
> +
> +extern const struct vdpa_config_ops ef100_vdpa_config_ops;
>  #endif /* CONFIG_SFC_VDPA */
>  #endif /* __EF100_VDPA_H__ */
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> new file mode 100644
> index 000000000000..f1ce011adc43
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Driver for AMD network controllers and boards
> + * Copyright(C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include <linux/vdpa.h>
> +#include "ef100_vdpa.h"
> +
> +static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
> +{
> +	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
> +}
> +
> +static void ef100_vdpa_free(struct vdpa_device *vdev)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (vdpa_nic) {
> +		mutex_destroy(&vdpa_nic->lock);
> +		vdpa_nic->efx->vdpa_nic = NULL;
> +	}
> +}
> +
> +const struct vdpa_config_ops ef100_vdpa_config_ops = {
> +	.free	             = ef100_vdpa_free,
> +};
> diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
> index d3e6d8239f5c..4415f19cf68f 100644
> --- a/drivers/net/ethernet/sfc/mcdi_functions.c
> +++ b/drivers/net/ethernet/sfc/mcdi_functions.c
> @@ -413,7 +413,8 @@ int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
>  	return 0;
>  }
>  
> -int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
> +int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
> +		    unsigned int *vf_index)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
>  	size_t outlen;
> @@ -426,6 +427,10 @@ int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
>  	if (outlen < sizeof(outbuf))
>  		return -EIO;
>  
> -	*pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
> +	if (pf_index)
> +		*pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
> +
> +	if (efx->type->is_vf && vf_index)
> +		*vf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_VF);
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
> index b0e2f53a0d9b..76dc0a13463e 100644
> --- a/drivers/net/ethernet/sfc/mcdi_functions.h
> +++ b/drivers/net/ethernet/sfc/mcdi_functions.h
> @@ -28,6 +28,7 @@ void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
>  void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
>  int efx_fini_dmaq(struct efx_nic *efx);
>  int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
> -int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index);
> +int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
> +		    unsigned int *vf_index);
>  
>  #endif
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 3dc9eae5a81d..1da71deac71c 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1090,6 +1090,12 @@ struct efx_nic {
>  	int rx_packet_len_offset;
>  	int rx_packet_ts_offset;
>  	bool rx_scatter;
> +#ifdef CONFIG_SFC_VDPA
> +	/** @mgmt_dev: vDPA Management device */
> +	struct vdpa_mgmt_dev *mgmt_dev;
> +	/** @vdpa_nic: vDPA device structure (EF100) */
> +	struct ef100_vdpa_nic *vdpa_nic;
> +#endif
>  	struct efx_rss_context rss_context;
>  	struct mutex rss_lock;
>  	u32 vport_id;
> -- 
> 2.30.1
