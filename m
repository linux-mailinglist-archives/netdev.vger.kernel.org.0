Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139FA15F7D7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgBNUjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:39:35 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39156 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730124AbgBNUjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:39:35 -0500
Received: by mail-qk1-f195.google.com with SMTP id a141so633679qkg.6
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 12:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Oo2pkt9CWUlNP26Aj7JvVAs5/HfWe+DbVSstrn3Z6gc=;
        b=k8B2BMcBuBEpjJJsaYiFY9ohOkUn5y3CX8Sd1VA71RY3hItJXp0r+ILL1z88yJ2/5X
         vX3bxjRipFItXTIB/YKj//obdqSmpbBQpHq1bfFcpwlOt0jnnYJ2f/m0VMxAABbnVEke
         aStTmViZ4cQ1HM78CeVhIoNrUyb9KdtvcC/URJXFL/QTyEaA9uoUhG7F1M/Nk5O+mYYh
         zCXZmV06MmNf/jywmpjQ94TqlWqf79AL8A0OJ7LEB6iAD+eMgT6ISUdfHzWMOP04Lden
         fapQ3C3eS7z+Skk5MNY94HX7YdLagwwZrVVFBrLJZ+B+rJQQQJvk4+wwETguUn+xq8Yl
         G2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Oo2pkt9CWUlNP26Aj7JvVAs5/HfWe+DbVSstrn3Z6gc=;
        b=o7chXY+Hvh1ztrxUJWWau+IWZ43oqNFQvcRyuK3v/l0GVAhGRf/27zmnkaybc7iFA3
         44IXoky6t+3+qL+JK4pJFpGmkD0cfH6yXj5H0SYaStzYPi3kQHtIi75BSjljYDutErbW
         I9RESkWEtq3w6ze1kOM8RpClTD8gQHiNsnurHAPRCP710BW40g7c9RBh/v337WIOakUu
         QG3hGuedt80ZLXFxZpNk/Q11HzfwpM2VsetUdQD9Lu9ZDBYhOXWF4mPgMoHl6E2fuXRh
         5ImvUU4j9MBEW/xCcnmBysEBURBiyAIWK5WljV2Otth+KWoC2U0/WMBq0CP6hugb/z4A
         yliw==
X-Gm-Message-State: APjAAAWacdx2jHypeL4JX1midj7HsaPjFCBCTz7eE4Tf8Z4Ioo+nQVEa
        nk9jNhX/vb7eM3IP8zLzGZVVcQ==
X-Google-Smtp-Source: APXvYqzwO6JQOeYA+Za+/OfE7SOU/V7tggwhq/PHZc6nlA1nx/UeepixWmCET6bSM8qdVH/CC4M07Q==
X-Received: by 2002:a05:620a:146a:: with SMTP id j10mr4158323qkl.19.1581712773573;
        Fri, 14 Feb 2020 12:39:33 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z6sm3752017qkz.101.2020.02.14.12.39.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 12:39:33 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j2hkK-0007Jp-IQ; Fri, 14 Feb 2020 16:39:32 -0400
Date:   Fri, 14 Feb 2020 16:39:32 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 02/25] ice: Create and register virtual bus for
 RDMA
Message-ID: <20200214203932.GY31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212191424.1715577-3-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 11:14:01AM -0800, Jeff Kirsher wrote:
> +/**
> + * ice_init_peer_devices - initializes peer devices
> + * @pf: ptr to ice_pf
> + *
> + * This function initializes peer devices on the virtual bus.
> + */
> +int ice_init_peer_devices(struct ice_pf *pf)
> +{
> +	struct ice_vsi *vsi = pf->vsi[0];
> +	struct pci_dev *pdev = pf->pdev;
> +	struct device *dev = &pdev->dev;
> +	int status = 0;
> +	int i;
> +
> +	/* Reserve vector resources */
> +	status = ice_reserve_peer_qvector(pf);
> +	if (status < 0) {
> +		dev_err(dev, "failed to reserve vectors for peer drivers\n");
> +		return status;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
> +		struct ice_peer_dev_int *peer_dev_int;
> +		struct ice_peer_drv_int *peer_drv_int;
> +		struct iidc_qos_params *qos_info;
> +		struct iidc_virtbus_object *vbo;
> +		struct msix_entry *entry = NULL;
> +		struct iidc_peer_dev *peer_dev;
> +		struct virtbus_device *vdev;
> +		int j;
> +
> +		/* structure layout needed for container_of's looks like:
> +		 * ice_peer_dev_int (internal only ice peer superstruct)
> +		 * |--> iidc_peer_dev
> +		 * |--> *ice_peer_drv_int
> +		 *
> +		 * iidc_virtbus_object (container_of parent for vdev)
> +		 * |--> virtbus_device
> +		 * |--> *iidc_peer_dev (pointer from internal struct)
> +		 *
> +		 * ice_peer_drv_int (internal only peer_drv struct)
> +		 */
> +		peer_dev_int = devm_kzalloc(dev, sizeof(*peer_dev_int),
> +					    GFP_KERNEL);
> +		if (!peer_dev_int)
> +			return -ENOMEM;
> +
> +		vbo = kzalloc(sizeof(*vbo), GFP_KERNEL);
> +		if (!vbo) {
> +			devm_kfree(dev, peer_dev_int);
> +			return -ENOMEM;
> +		}
> +
> +		peer_drv_int = devm_kzalloc(dev, sizeof(*peer_drv_int),
> +					    GFP_KERNEL);

To me, this looks like a lifetime mess. All these devm allocations
against the parent object are being referenced through the vbo with a
different kref lifetime. The whole thing has very unclear semantics
who should be cleaning up on error

> +		if (!peer_drv_int) {
> +			devm_kfree(dev, peer_dev_int);
> +			kfree(vbo);

ie here we free two things

> +			return -ENOMEM;
> +		}
> +
> +		pf->peers[i] = peer_dev_int;
> +		vbo->peer_dev = &peer_dev_int->peer_dev;
> +		peer_dev_int->peer_drv_int = peer_drv_int;
> +		peer_dev_int->peer_dev.vdev = &vbo->vdev;
> +
> +		/* Initialize driver values */
> +		for (j = 0; j < IIDC_EVENT_NBITS; j++)
> +			bitmap_zero(peer_drv_int->current_events[j].type,
> +				    IIDC_EVENT_NBITS);
> +
> +		mutex_init(&peer_dev_int->peer_dev_state_mutex);
> +
> +		peer_dev = &peer_dev_int->peer_dev;
> +		peer_dev->peer_ops = NULL;
> +		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
> +		peer_dev->peer_dev_id = ice_peers[i].id;
> +		peer_dev->pf_vsi_num = vsi->vsi_num;
> +		peer_dev->netdev = vsi->netdev;
> +
> +		peer_dev_int->ice_peer_wq =
> +			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
> +						i);
> +		if (!peer_dev_int->ice_peer_wq)
> +			return -ENOMEM;

Here we free nothing

> +
> +		peer_dev->pdev = pdev;
> +		qos_info = &peer_dev->initial_qos_info;
> +
> +		/* setup qos_info fields with defaults */
> +		qos_info->num_apps = 0;
> +		qos_info->num_tc = 1;
> +
> +		for (j = 0; j < IIDC_MAX_USER_PRIORITY; j++)
> +			qos_info->up2tc[j] = 0;
> +
> +		qos_info->tc_info[0].rel_bw = 100;
> +		for (j = 1; j < IEEE_8021QAZ_MAX_TCS; j++)
> +			qos_info->tc_info[j].rel_bw = 0;
> +
> +		/* for DCB, override the qos_info defaults. */
> +		ice_setup_dcb_qos_info(pf, qos_info);
> +
> +		/* make sure peer specific resources such as msix_count and
> +		 * msix_entries are initialized
> +		 */
> +		switch (ice_peers[i].id) {
> +		case IIDC_PEER_RDMA_ID:
> +			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
> +				peer_dev->msix_count = pf->num_rdma_msix;
> +				entry = &pf->msix_entries[pf->rdma_base_vector];
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		peer_dev->msix_entries = entry;
> +		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT,
> +				      false);
> +
> +		vdev = &vbo->vdev;
> +		vdev->name = ice_peers[i].name;
> +		vdev->release = ice_peer_vdev_release;
> +		vdev->dev.parent = &pdev->dev;
> +
> +		status = virtbus_dev_register(vdev);
> +		if (status) {
> +			virtbus_dev_unregister(vdev);
> +			vdev = NULL;

Here we double unregister and free nothing.

You need to go through all of this really carefully and make some kind
of sane lifetime model and fix all the error unwinding :(

Why doesn't the release() function of vbo trigger the free of all this
peer related stuff?

Use a sane design model of splitting into functions to allocate single
peices of memory, goto error unwind each function, and build things up
properly.

Jason
