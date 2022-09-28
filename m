Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8595ED81E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiI1IrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiI1Iqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:46:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D50DCCCC
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:43:20 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x18so18635839wrm.7
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date;
        bh=sKYtF+4bneEpzD5XCOl9iEXvSCtijesFtpfBhrph+3A=;
        b=dNzXoFN3pApmHDgMx/074r0dkvSK7IGEVahtC0dEzlndyuSYnTRNRKYKhRVIPhaIxL
         BbY75kTKqjVQOQbyq/Vm/SMlSSaMQ6rtcXw4KsBHF7635viE4+IR7/MgYObV8Wt4i4Mz
         bgxc2aFmo+EA0gQOmqFpZirFtm2ycbVhvxxo01S5+v/owr2BBaIQM7ka4dBUtRKluzB5
         htWWbxwF8TKCymjdN3jzApkyGnrPW253pm79yYQ6ZNK2UK7/lKcid31sxMZFJ3d4v+Cy
         Xu+mVg3rLRIKcR9btW3EcUfStFmCJEDg5Bs8da33VEnbYIPk0KhNgL5yxhqbF2Vqc+O9
         k1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sKYtF+4bneEpzD5XCOl9iEXvSCtijesFtpfBhrph+3A=;
        b=J+WxRZvaY/elgIwoAstQksHR1IdN2SKkitNNmekWmQKgI9O6p9t6iKS5gKLXalgEg0
         spCSnvth0Cwbv8sVMX/QXX1zSWDd7W+AL1OdWaf5pTO5N8VV8idwZTPXpPkWh7Nz9iaa
         LThlrkweyoSCScgu8/O/mtz70KrgzIDN51gX5UDQHUW/uiy4IFNlRcWjNAes8nVIOZEd
         NQ4r56mD5uFe05GX40ifA4Dy/z/aljfV2IVugnlmE4f9E4+evrIGpej79mzHXOXP1C3c
         JMh6NCKqHdsD3uIEzw4RGyF8szmtQ7htwrYcEiqHZpqhpIuSc46rN8ZGYEUua4jP2snV
         DFTQ==
X-Gm-Message-State: ACrzQf2IFcoKePhUAZJMCrMUKRhHFFjohUCq2FdvMzqs+MSnFYPEws/q
        S2RiyHvLAeaems+COwfo1qY=
X-Google-Smtp-Source: AMsMyM7oOcM74JpdrHV0mvePa2DuVSo2YSwDZs3Wp95B4WUQjuitMPBo5Hry95mtpUJjGXxl0LgIew==
X-Received: by 2002:a5d:5254:0:b0:22c:cae2:ddcb with SMTP id k20-20020a5d5254000000b0022ccae2ddcbmr368772wrc.633.1664354598815;
        Wed, 28 Sep 2022 01:43:18 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm1183319wmq.37.2022.09.28.01.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 01:43:18 -0700 (PDT)
Date:   Wed, 28 Sep 2022 09:43:14 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     ecree@xilinx.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 1/6] sfc: bind blocks for TC offload on EF100
Message-ID: <YzQJIiRPI7i+orJu@gmail.com>
Mail-Followup-To: ecree@xilinx.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <097c1e9d6122630f909fb0c25868b6ce253a89c2.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <097c1e9d6122630f909fb0c25868b6ce253a89c2.1664218348.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 07:57:31PM +0100, ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Bind direct blocks for the MAE-admin PF and each VF representor.
> Currently these connect to a stub efx_tc_flower() that only returns
>  -EOPNOTSUPP; subsequent patches will implement flower offloads to the
>  Match-Action Engine.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/Makefile       |   2 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c |   4 +
>  drivers/net/ethernet/sfc/ef100_nic.c    |   3 +
>  drivers/net/ethernet/sfc/ef100_rep.c    |  16 +++
>  drivers/net/ethernet/sfc/tc.c           |  14 ++-
>  drivers/net/ethernet/sfc/tc.h           |   7 ++
>  drivers/net/ethernet/sfc/tc_bindings.c  | 157 ++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/tc_bindings.h  |  23 ++++
>  8 files changed, 224 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/tc_bindings.c
>  create mode 100644 drivers/net/ethernet/sfc/tc_bindings.h
>
<snip>

> diff --git a/drivers/net/ethernet/sfc/tc_bindings.c b/drivers/net/ethernet/sfc/tc_bindings.c
> new file mode 100644
> index 000000000000..d9401ee7b8e1
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/tc_bindings.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/****************************************************************************
> + * Driver for Solarflare network controllers and boards
> + * Copyright 2022 Xilinx Inc.

New files should have "Copyright 2022 Advanced Micro Devices, Inc."
Same for the .h file below.

-- 
Martin Habets <habetsm.xilinx@gmail.com>

> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include "tc_bindings.h"
> +#include "tc.h"
> +
> +struct efx_tc_block_binding {
> +	struct list_head list;
> +	struct efx_nic *efx;
> +	struct efx_rep *efv;
> +	struct net_device *otherdev; /* may actually be us */
> +	struct flow_block *block;
> +};
> +
> +static struct efx_tc_block_binding *efx_tc_find_binding(struct efx_nic *efx,
> +							struct net_device *otherdev)
> +{
> +	struct efx_tc_block_binding *binding;
> +
> +	ASSERT_RTNL();
> +	list_for_each_entry(binding, &efx->tc->block_list, list)
> +		if (binding->otherdev == otherdev)
> +			return binding;
> +	return NULL;
> +}
> +
> +static int efx_tc_block_cb(enum tc_setup_type type, void *type_data,
> +			   void *cb_priv)
> +{
> +	struct efx_tc_block_binding *binding = cb_priv;
> +	struct flow_cls_offload *tcf = type_data;
> +
> +	switch (type) {
> +	case TC_SETUP_CLSFLOWER:
> +		return efx_tc_flower(binding->efx, binding->otherdev,
> +				     tcf, binding->efv);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static void efx_tc_block_unbind(void *cb_priv)
> +{
> +	struct efx_tc_block_binding *binding = cb_priv;
> +
> +	list_del(&binding->list);
> +	kfree(binding);
> +}
> +
> +static struct efx_tc_block_binding *efx_tc_create_binding(
> +			struct efx_nic *efx, struct efx_rep *efv,
> +			struct net_device *otherdev, struct flow_block *block)
> +{
> +	struct efx_tc_block_binding *binding = kmalloc(sizeof(*binding), GFP_KERNEL);
> +
> +	if (!binding)
> +		return ERR_PTR(-ENOMEM);
> +	binding->efx = efx;
> +	binding->efv = efv;
> +	binding->otherdev = otherdev;
> +	binding->block = block;
> +	list_add(&binding->list, &efx->tc->block_list);
> +	return binding;
> +}
> +
> +int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
> +		       struct flow_block_offload *tcb, struct efx_rep *efv)
> +{
> +	struct efx_tc_block_binding *binding;
> +	struct flow_block_cb *block_cb;
> +	int rc;
> +
> +	if (tcb->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> +		return -EOPNOTSUPP;
> +
> +	if (WARN_ON(!efx->tc))
> +		return -ENETDOWN;
> +
> +	switch (tcb->command) {
> +	case FLOW_BLOCK_BIND:
> +		binding = efx_tc_create_binding(efx, efv, net_dev, tcb->block);
> +		if (IS_ERR(binding))
> +			return PTR_ERR(binding);
> +		block_cb = flow_block_cb_alloc(efx_tc_block_cb, binding,
> +					       binding, efx_tc_block_unbind);
> +		rc = PTR_ERR_OR_ZERO(block_cb);
> +		netif_dbg(efx, drv, efx->net_dev,
> +			  "bind %sdirect block for device %s, rc %d\n",
> +			  net_dev == efx->net_dev ? "" :
> +			  efv ? "semi" : "in",
> +			  net_dev ? net_dev->name : NULL, rc);
> +		if (rc) {
> +			list_del(&binding->list);
> +			kfree(binding);
> +		} else {
> +			flow_block_cb_add(block_cb, tcb);
> +		}
> +		return rc;
> +	case FLOW_BLOCK_UNBIND:
> +		binding = efx_tc_find_binding(efx, net_dev);
> +		if (binding) {
> +			block_cb = flow_block_cb_lookup(tcb->block,
> +							efx_tc_block_cb,
> +							binding);
> +			if (block_cb) {
> +				flow_block_cb_remove(block_cb, tcb);
> +				netif_dbg(efx, drv, efx->net_dev,
> +					  "unbound %sdirect block for device %s\n",
> +					  net_dev == efx->net_dev ? "" :
> +					  binding->efv ? "semi" : "in",
> +					  net_dev ? net_dev->name : NULL);
> +				return 0;
> +			}
> +		}
> +		/* If we're in driver teardown, then we expect to have
> +		 * already unbound all our blocks (we did it early while
> +		 * we still had MCDI to remove the filters), so getting
> +		 * unbind callbacks now isn't a problem.
> +		 */
> +		netif_cond_dbg(efx, drv, efx->net_dev,
> +			       !efx->tc->up, warn,
> +			       "%sdirect block unbind for device %s, was never bound\n",
> +			       net_dev == efx->net_dev ? "" : "in",
> +			       net_dev ? net_dev->name : NULL);
> +		return -ENOENT;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +/* .ndo_setup_tc implementation
> + * Entry point for flower block and filter management.
> + */
> +int efx_tc_setup(struct net_device *net_dev, enum tc_setup_type type,
> +		 void *type_data)
> +{
> +	struct efx_nic *efx = efx_netdev_priv(net_dev);
> +
> +	if (efx->type->is_vf)
> +		return -EOPNOTSUPP;
> +	if (!efx->tc)
> +		return -EOPNOTSUPP;
> +
> +	if (type == TC_SETUP_CLSFLOWER)
> +		return efx_tc_flower(efx, net_dev, type_data, NULL);
> +	if (type == TC_SETUP_BLOCK)
> +		return efx_tc_setup_block(net_dev, efx, type_data, NULL);
> +
> +	return -EOPNOTSUPP;
> +}
> diff --git a/drivers/net/ethernet/sfc/tc_bindings.h b/drivers/net/ethernet/sfc/tc_bindings.h
> new file mode 100644
> index 000000000000..bcd63c270585
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/tc_bindings.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/****************************************************************************
> + * Driver for Solarflare network controllers and boards
> + * Copyright 2022 Xilinx Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#ifndef EFX_TC_BINDINGS_H
> +#define EFX_TC_BINDINGS_H
> +#include "net_driver.h"
> +
> +#include <net/sch_generic.h>
> +
> +struct efx_rep;
> +
> +int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
> +		       struct flow_block_offload *tcb, struct efx_rep *efv);
> +int efx_tc_setup(struct net_device *net_dev, enum tc_setup_type type,
> +		 void *type_data);
> +#endif /* EFX_TC_BINDINGS_H */
