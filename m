Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958A66738C2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjASMiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjASMhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:37:45 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1737E4B9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:34:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r2so1705828wrv.7
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zOzA/VIj2HovaaRSEt4XVcP3UGrIWiv+7dLhUJOiX+w=;
        b=c2xft7FLlTIsxOlWTW9rGS39K4sWZbBX831+HeNV+jTqlj8aSfVxwTEZ6XETIpsOeq
         Cjb5sGERr+Vmr47XmOfF3U0qch8Qg3QlHRI93b+f7O3UHxBOtdQaMqB5lFQHCJvDha5a
         I6cZa/otstI5Semdkn1D9sB/T8f6ayWl6OofcJ8IA09PCiunyVKjFA+yRvajQgzP7odg
         TSPnhtfFYSlzLZEBOdRNW/us5mQ1AvXt2L5sYuxLbkM4+l8K7JdDwuci27uHsWkGAJBm
         twSv8VXtOb1IHDwdfztcL+L6cBbXMa8thoSJWXOCyZzgEMUPWH1OhDFj/MRJxP1kKCUD
         KEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOzA/VIj2HovaaRSEt4XVcP3UGrIWiv+7dLhUJOiX+w=;
        b=7ZcW+N3JsH071hI3MniLVyLXcN6nG6PJB81eXfuM6JuUhuO/QAnvqRhv3Ml1lJfk32
         Xe8vBVNOaF2BeVveQzTa0rtE+3XcUuQNmld8kLqlV6K37RxHsRMAFzZP+6YghZvOoua2
         tb4YUjF9EXOQXeFfIj1Z+oe7iTlJkqesLcNW7Rsw7M1ouwA+CCvCO8Yh1ZFAMpPVsmNr
         xwe3vOsdatEIiyi/L3il7hMHfQCWoVxQC0j8FTw+gFwTZqbjqTPd+Tsa4K58CXo5Q4wa
         06YD8i4/3MDuGBxAQoeqcLf1ZmqiC7bhRyfr3Dh9b4x0++CthhbtjyUUfUPpgWjwrbgJ
         fKqw==
X-Gm-Message-State: AFqh2krT5M3rD7Myr2AuCwsG5SJh9+8SsGGXDfSCiQEqYslMY9WTGaCF
        w6Tc12AY6ClDRXHH8mRt1glzjQ==
X-Google-Smtp-Source: AMrXdXtbFCDpVPZuPlHtq/eZt/V96I0pg4SkkDOH/FMqtlnF45DhVkUKM3FO5WVxep5T3U599u3B3Q==
X-Received: by 2002:adf:a3d9:0:b0:2bd:deaf:6a88 with SMTP id m25-20020adfa3d9000000b002bddeaf6a88mr9245884wrb.17.1674131597846;
        Thu, 19 Jan 2023 04:33:17 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id q18-20020adfdfd2000000b002bdc129c8f6sm22200129wrn.43.2023.01.19.04.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 04:33:17 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:33:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm@gmail.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 4/7] sfc: add devlink port support for ef100
Message-ID: <Y8k4jFnloCfylMUV@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-5-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-5-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 12:31:37PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the data when enumerating mports, create devlink ports just before
>netdevs are registered and removing those devlink ports after netdev has
>been unregister.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>---
> drivers/net/ethernet/sfc/ef100_netdev.c |  14 ++-
> drivers/net/ethernet/sfc/ef100_rep.c    |  23 +++++
> drivers/net/ethernet/sfc/ef100_rep.h    |   6 ++
> drivers/net/ethernet/sfc/efx_devlink.c  | 114 ++++++++++++++++++++++++
> drivers/net/ethernet/sfc/efx_devlink.h  |   7 ++
> drivers/net/ethernet/sfc/net_driver.h   |   1 +
> 6 files changed, 161 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>index ddcc325ed570..4a5d028f757e 100644
>--- a/drivers/net/ethernet/sfc/ef100_netdev.c
>+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>@@ -24,6 +24,7 @@
> #include "rx_common.h"
> #include "ef100_sriov.h"
> #include "tc_bindings.h"
>+#include "efx_devlink.h"
> 
> static void ef100_update_name(struct efx_nic *efx)
> {
>@@ -280,6 +281,9 @@ static int ef100_register_netdev(struct efx_nic *efx)
> 	net_dev->max_mtu = EFX_MAX_MTU;
> 	net_dev->ethtool_ops = &ef100_ethtool_ops;
> 
>+	if (!efx->type->is_vf)
>+		ef100_pf_set_devlink_port(efx);

Again, why no port for VF while you are at it?


>+
> 	rtnl_lock();
> 
> 	rc = dev_alloc_name(net_dev, net_dev->name);
>@@ -302,6 +306,7 @@ static int ef100_register_netdev(struct efx_nic *efx)
> 
> fail_locked:
> 	rtnl_unlock();
>+	ef100_pf_unset_devlink_port(efx);
> 	netif_err(efx, drv, efx->net_dev, "could not register net dev\n");
> 	return rc;
> }
>@@ -312,6 +317,7 @@ static void ef100_unregister_netdev(struct efx_nic *efx)
> 		efx_fini_mcdi_logging(efx);
> 		efx->state = STATE_PROBED;
> 		unregister_netdev(efx->net_dev);
>+		ef100_pf_unset_devlink_port(efx);
> 	}
> }
> 
>@@ -405,16 +411,16 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
> 	/* Don't fail init if RSS setup doesn't work. */
> 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
> 
>-	rc = ef100_register_netdev(efx);
>-	if (rc)
>-		goto fail;
>-
> 	if (!efx->type->is_vf) {
> 		rc = ef100_probe_netdev_pf(efx);
> 		if (rc)
> 			goto fail;
> 	}
> 
>+	rc = ef100_register_netdev(efx);
>+	if (rc)
>+		goto fail;
>+
> 	efx->netdev_notifier.notifier_call = ef100_netdev_event;
> 	rc = register_netdevice_notifier(&efx->netdev_notifier);
> 	if (rc) {
>diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
>index 9cd1a3ac67e0..ff0c8da61919 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.c
>+++ b/drivers/net/ethernet/sfc/ef100_rep.c
>@@ -16,6 +16,7 @@
> #include "mae.h"
> #include "rx_common.h"
> #include "tc_bindings.h"
>+#include "efx_devlink.h"
> 
> #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
> 
>@@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
> 			i, rc);
> 		goto fail1;
> 	}
>+	ef100_rep_set_devlink_port(efv);
> 	rc = register_netdev(efv->net_dev);
> 	if (rc) {
> 		pci_err(efx->pci_dev,
>@@ -304,10 +306,12 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
> 			i, rc);
> 		goto fail2;
> 	}
>+
> 	pci_dbg(efx->pci_dev, "Representor for VF %d is %s\n", i,
> 		efv->net_dev->name);
> 	return 0;
> fail2:
>+	ef100_rep_unset_devlink_port(efv);
> 	efx_ef100_deconfigure_rep(efv);
> fail1:
> 	efx_ef100_rep_destroy_netdev(efv);
>@@ -323,6 +327,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
> 		return;
> 	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
> 	unregister_netdev(rep_dev);
>+	ef100_rep_unset_devlink_port(efv);
> 	efx_ef100_deconfigure_rep(efv);
> 	efx_ef100_rep_destroy_netdev(efv);
> }
>@@ -339,6 +344,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
> 		efx_ef100_vfrep_destroy(efx, efv);
> }
> 
>+bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
>+{
>+	return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
>+	       mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
>+}
>+
>+bool ef100_mport_on_local_intf(struct efx_nic *efx,
>+			       struct mae_mport_desc *mport_desc)
>+{
>+	bool pcie_func;
>+	struct ef100_nic_data *nic_data = efx->nic_data;

Reverse christmas tree ordering please:
***************
*********
****




>+
>+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
>+
>+	return nic_data->have_local_intf && pcie_func &&
>+		     mport_desc->interface_idx == nic_data->local_mae_intf;
>+}
>+
> void efx_ef100_init_reps(struct efx_nic *efx)
> {
> 	struct ef100_nic_data *nic_data = efx->nic_data;
>diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
>index 328ac0cbb532..9cca41614982 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.h
>+++ b/drivers/net/ethernet/sfc/ef100_rep.h
>@@ -22,6 +22,8 @@ struct efx_rep_sw_stats {
> 	atomic64_t rx_dropped, tx_errors;
> };
> 
>+struct devlink_port;
>+
> /**
>  * struct efx_rep - Private data for an Efx representor
>  *
>@@ -54,6 +56,7 @@ struct efx_rep {
> 	spinlock_t rx_lock;
> 	struct napi_struct napi;
> 	struct efx_rep_sw_stats stats;
>+	struct devlink_port *dl_port;
> };
> 
> int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
>@@ -69,4 +72,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
> extern const struct net_device_ops efx_ef100_rep_netdev_ops;
> void efx_ef100_init_reps(struct efx_nic *efx);
> void efx_ef100_fini_reps(struct efx_nic *efx);
>+struct mae_mport_desc;
>+bool ef100_mport_on_local_intf(struct efx_nic *efx,
>+			       struct mae_mport_desc *mport_desc);
> #endif /* EF100_REP_H */
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>index c506f8f35d25..bb19d3ad7ffd 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.c
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -16,6 +16,8 @@
> #include "mcdi.h"
> #include "mcdi_functions.h"
> #include "mcdi_pcol.h"
>+#include "mae.h"
>+#include "ef100_rep.h"
> 
> /* Custom devlink-info version object names for details that do not map to the
>  * generic standardized names.
>@@ -381,6 +383,52 @@ struct efx_devlink {
> 	struct efx_nic *efx;
> };
> 
>+static void efx_devlink_del_port(struct devlink_port *dl_port)
>+{
>+	if (!dl_port)
>+		return;
>+	devlink_port_unregister(dl_port);
>+	kfree(dl_port);
>+}
>+
>+static int efx_devlink_add_port(struct efx_nic *efx,
>+				struct mae_mport_desc *mport,
>+				struct devlink_port *dl_port)
>+{
>+	struct devlink_port_attrs attrs = {};
>+	bool external = false;
>+	int err;
>+
>+	if (!ef100_mport_on_local_intf(efx, mport))
>+		external = true;
>+
>+	switch (mport->mport_type) {
>+	case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
>+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>+		attrs.phys.port_number = mport->port_idx;
>+		devlink_port_attrs_set(dl_port, &attrs);
>+		break;
>+	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
>+		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL) {

No need for {}'s in this if-else


>+			devlink_port_attrs_pci_vf_set(dl_port, 0, mport->pf_idx,
>+						      mport->vf_idx,
>+						      external);
>+		} else {
>+			devlink_port_attrs_pci_pf_set(dl_port, 0, mport->pf_idx,
>+						      external);
>+		}
>+		break;
>+	default:
>+		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
>+		return 0;
>+	}
>+
>+	dl_port->index = mport->mport_id;
>+	err = devlink_port_register(efx->devlink, dl_port, mport->mport_id);

Just return.


>+
>+	return err;
>+}
>+
> static int efx_devlink_info_get(struct devlink *devlink,
> 				struct devlink_info_req *req,
> 				struct netlink_ext_ack *extack)
>@@ -396,6 +444,72 @@ static const struct devlink_ops sfc_devlink_ops = {
> 	.info_get			= efx_devlink_info_get,
> };
> 
>+static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>+{
>+	struct mae_mport_desc *mport;
>+	struct devlink_port *dl_port;
>+	u32 id;
>+
>+	if (efx_mae_lookup_mport(efx, idx, &id)) {
>+		/* This should not happen. */
>+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>+			pci_warn(efx->pci_dev, "No mport ID found for PF.\n");
>+		else
>+			pci_warn(efx->pci_dev, "No mport ID found for VF %u.\n",
>+				 idx);
>+		return NULL;
>+	}
>+
>+	mport = efx_mae_get_mport(efx, id);
>+	if (!mport) {
>+		/* This should not happen. */
>+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>+			pci_warn(efx->pci_dev, "No mport found for PF.\n");
>+		else
>+			pci_warn(efx->pci_dev, "No mport found for VF %u.\n",
>+				 idx);
>+		return NULL;
>+	}
>+
>+	dl_port = kzalloc(sizeof(*dl_port), GFP_KERNEL);
>+	if (!dl_port)
>+		return NULL;
>+
>+	if (efx_devlink_add_port(efx, mport, dl_port)) {
>+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>+			pci_warn(efx->pci_dev,
>+				 "devlink port creation for PF failed.\n");
>+		else
>+			pci_warn(efx->pci_dev,
>+				 "devlink_port creationg for VF %u failed.\n",
>+				 idx);
>+		kfree(dl_port);
>+		return NULL;
>+	}
>+
>+	return dl_port;
>+}
>+
>+void ef100_rep_set_devlink_port(struct efx_rep *efv)
>+{
>+	efv->dl_port = ef100_set_devlink_port(efv->parent, efv->idx);
>+}
>+
>+void ef100_pf_set_devlink_port(struct efx_nic *efx)
>+{
>+	efx->dl_port = ef100_set_devlink_port(efx, MAE_MPORT_DESC_VF_IDX_NULL);
>+}
>+
>+void ef100_rep_unset_devlink_port(struct efx_rep *efv)
>+{
>+	efx_devlink_del_port(efv->dl_port);
>+}
>+
>+void ef100_pf_unset_devlink_port(struct efx_nic *efx)
>+{
>+	efx_devlink_del_port(efx->dl_port);
>+}
>+
> void efx_fini_devlink(struct efx_nic *efx)
> {
> 	if (efx->devlink) {
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>index 997f878aea93..a834c393a9ad 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.h
>+++ b/drivers/net/ethernet/sfc/efx_devlink.h
>@@ -17,4 +17,11 @@
> int efx_probe_devlink(struct efx_nic *efx);
> void efx_fini_devlink(struct efx_nic *efx);
> 
>+struct mae_mport_desc;
>+struct efx_rep;
>+
>+void ef100_pf_set_devlink_port(struct efx_nic *efx);
>+void ef100_rep_set_devlink_port(struct efx_rep *efv);
>+void ef100_pf_unset_devlink_port(struct efx_nic *efx);
>+void ef100_rep_unset_devlink_port(struct efx_rep *efv);
> #endif	/* _EFX_DEVLINK_H */
>diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>index bc9efbfb3d6b..20f43695d082 100644
>--- a/drivers/net/ethernet/sfc/net_driver.h
>+++ b/drivers/net/ethernet/sfc/net_driver.h
>@@ -1185,6 +1185,7 @@ struct efx_nic {
> 	struct efx_tc_state *tc;
> 
> 	struct devlink *devlink;
>+	struct devlink_port *dl_port;
> 	unsigned int mem_bar;
> 	u32 reg_base;
> 
>-- 
>2.17.1
>
