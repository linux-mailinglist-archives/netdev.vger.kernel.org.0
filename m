Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3681119049
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfLJTEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:04:41 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42326 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfLJTEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:04:41 -0500
Received: by mail-oi1-f194.google.com with SMTP id j22so10819260oij.9
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 11:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qQUP1b6nyXYgmeIoxTMSdm6/nJ4NuICoBz1i3Y5W8K0=;
        b=fR3Lx4vAf3gPFJAQoT6uGTu3pG7pMWAFkMQudNvdltjII0DLLugBMO6nlzd8RAcCSR
         1XBOgjLaYMpZmMEjT9wvqbd0kTkNj/U90li4t2VjV/PzRGPg8+08ooDOQEdky+oCq6Hj
         SBItLgzGVdRs4Kg60uj/ZUalc6ISL2TpXLayBYlII73QNWebMNw+tF0zcarvk0eLhsEx
         s6xI7UhXLRhTO2KmnSyVXiG++h3gBGPh+DEhzSNk9NrXDcB1EUf38FbH8hdjTRKlw6kO
         4N58dIanOqYRPsuwJGF3RiTOZliMbqrme3vo3hX5lgmPenbIMNpH0yVazLPFXicb7Z+l
         nThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qQUP1b6nyXYgmeIoxTMSdm6/nJ4NuICoBz1i3Y5W8K0=;
        b=VxsIG2R7b2fQtE1yS0hFjRHwoDX7Mu5vsx4VdPGuQiFyr1WcEwANh6y/+KoJhCyiIA
         bzxIh03q1RJvTJX9v3C161eDSEYhE/jL+c2VDcMmavpMMboBFAkvJ+7ZMp54rC84rLlx
         eJUOf0oyCVr1pHl3QZickRV4l+VW4cBTIeU6XkhZw00SdVUuxI8Yk64pNzFOk9UVUwwR
         n8UFuV2lCZhLFPMTzji30Rn/e82jnEhw9ycOQbps4AYS1EZ1KZ1+SJ3AyMvyriagKwx2
         F5Swf1YycImOqS1gN2fzchwTkhIha9PR3KhpqQHUkObDvPRI4WBi42IuyoIg/xI+7/R+
         d6aw==
X-Gm-Message-State: APjAAAXnHAHx+/MNlmYSzVlBlheFR4lnue21HAW5Zw/RSSYzqQUzNpvu
        7oEXXnLOjRxk8W+XKRq3lZqbXg==
X-Google-Smtp-Source: APXvYqySQr5Hh+2xvwGVSoQOcZOMKSJGI0TBqzMZX08FD285xAK4Bz4QTXaLp4Nx8nTX8hPGFKy3ug==
X-Received: by 2002:aca:4587:: with SMTP id s129mr322896oia.124.1576004680305;
        Tue, 10 Dec 2019 11:04:40 -0800 (PST)
Received: from ziepe.ca ([217.140.111.136])
        by smtp.gmail.com with ESMTPSA id k203sm1717145oih.7.2019.12.10.11.04.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 11:04:39 -0800 (PST)
Received: from jgg by LT-JGG-7470.mtl.com with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iekoI-00001o-Bo; Tue, 10 Dec 2019 15:04:38 -0400
Date:   Tue, 10 Dec 2019 15:04:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191210190438.GF46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:20PM -0800, Jeff Kirsher wrote:
> +{
> +	struct i40e_info *ldev = (struct i40e_info *)rf->ldev.if_ldev;

Why are there so many casts in this file? Is this really container of?

> +	hdl = kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
> +	if (!hdl)
> +		return -ENOMEM;
> +
> +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));

Yikes, use structs and container of for things like this please.

> +	iwdev->param_wq = alloc_ordered_workqueue("l2params", WQ_MEM_RECLAIM);
> +	if (!iwdev->param_wq)
> +		goto error;

Leon usually asks why another work queue at this point, at least have
a comment justifying why. Shouldn't it have a better name?

> +/* client interface functions */
> +static const struct i40e_client_ops i40e_ops = {
> +	.open = i40iw_open,
> +	.close = i40iw_close,
> +	.l2_param_change = i40iw_l2param_change
> +};

Wasn't the whole point of virtual bus to avoid stuff like this? Why
isn't a client the virtual bus object and this information extended
into the driver ops?

> +int i40iw_probe(struct virtbus_device *vdev)
> +{
> +	struct i40e_info *ldev =
> +		container_of(vdev, struct i40e_info, vdev);
> +
> +	if (!ldev)
> +		return -EINVAL;

eh? how can that happen

> +
> +	if (!ldev->ops->client_device_register)
> +		return -EINVAL;

How can this happen too? If it doesn't support register then don't
create a virtual device, surely?

I've really developed a strong distate to these random non-functional
'ifs' that seem to get into things.

If it is functional then fine, but if it is an assertion write it as
if (WARN_ON()) to make it clear to readers it can't happen by design


> +/**
> + * irdma_lan_register_qset - Register qset with LAN driver
> + * @vsi: vsi structure
> + * @tc_node: Traffic class node
> + */
> +static enum irdma_status_code irdma_lan_register_qset(struct irdma_sc_vsi *vsi,
> +						      struct irdma_ws_node *tc_node)
> +{
> +	struct irdma_device *iwdev = vsi->back_vsi;
> +	struct iidc_peer_dev *ldev = (struct iidc_peer_dev *)iwdev->ldev->if_ldev;

Again with the casts.. Please try to clean up the casting in this driver

> +	struct iidc_res rdma_qset_res = {};
> +	int ret;
> +
> +	if (ldev->ops->alloc_res) {

Quite an abnormal coding style to put the entire function under an if,
just if() return 0 ? Many examples of this

> +/**
> + * irdma_log_invalid_mtu: log warning on invalid mtu
> + * @mtu: maximum tranmission unit
> + */
> +static void irdma_log_invalid_mtu(u16 mtu)
> +{
> +	if (mtu < IRDMA_MIN_MTU_IPV4)
> +		pr_warn("Current MTU setting of %d is too low for RDMA traffic. Minimum MTU is 576 for IPv4 and 1280 for IPv6\n",
> +			mtu);
> +	else if (mtu < IRDMA_MIN_MTU_IPV6)
> +		pr_warn("Current MTU setting of %d is too low for IPv6 RDMA traffic, the minimum is 1280\n",
> +			mtu);
> +}

Don't use pr_* stuff in drivers that have a struct device.

> +/**
> + * irdma_event_handler - Called by LAN driver to notify events
> + * @ldev: Peer device structure
> + * @event: event from LAN driver
> + */
> +static void irdma_event_handler(struct iidc_peer_dev *ldev,
> +				struct iidc_event *event)
> +{
> +	struct irdma_l2params l2params = {};
> +	struct irdma_device *iwdev;
> +	int i;
> +
> +	iwdev = irdma_get_device(ldev->netdev);
> +	if (!iwdev)
> +		return;
> +
> +	if (test_bit(IIDC_EVENT_LINK_CHANGE, event->type)) {

Is this atomic? Why using test_bit?

> +		ldev->ops->reg_for_notification(ldev, &events);
> +	dev_info(rfdev_to_dev(dev), "IRDMA VSI Open Successful");

Lets not do this kind of logging..

> +static void irdma_close(struct iidc_peer_dev *ldev, enum iidc_close_reason reason)
> +{
> +	struct irdma_device *iwdev;
> +	struct irdma_pci_f *rf;
> +
> +	iwdev = irdma_get_device(ldev->netdev);
> +	if (!iwdev)
> +		return;
> +
> +	irdma_put_device(iwdev);
> +	rf = iwdev->rf;
> +	if (reason == IIDC_REASON_GLOBR_REQ || reason == IIDC_REASON_CORER_REQ ||
> +	    reason == IIDC_REASON_PFR_REQ || rf->reset) {
> +		iwdev->reset = true;
> +		rf->reset = true;
> +	}
> +
> +	if (iwdev->init_state >= CEQ0_CREATED)
> +		irdma_deinit_rt_device(iwdev);
> +
> +	kfree(iwdev);

Mixing put and kfree? So confusing. Why are there so many structs and
so much indirection? Very hard to understand if this is right or not.

> new file mode 100644
> index 000000000000..b418e76a3302
> +++ b/drivers/infiniband/hw/irdma/main.c
> @@ -0,0 +1,630 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#include "main.h"
> +
> +/* Legacy i40iw module parameters */
> +static int resource_profile;
> +module_param(resource_profile, int, 0644);
> +MODULE_PARM_DESC(resource_profile, "Resource Profile: 0=PF only, 1=Weighted VF, 2=Even Distribution");
> +
> +static int max_rdma_vfs = 32;
> +module_param(max_rdma_vfs, int, 0644);
> +MODULE_PARM_DESC(max_rdma_vfs, "Maximum VF count: 0-32 32=default");
> +
> +static int mpa_version = 2;
> +module_param(mpa_version, int, 0644);
> +MODULE_PARM_DESC(mpa_version, "MPA version: deprecated parameter");
> +
> +static int push_mode;
> +module_param(push_mode, int, 0644);
> +MODULE_PARM_DESC(push_mode, "Low latency mode: deprecated parameter");
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug flags: deprecated parameter");

Generally no to module parameters

> +static struct workqueue_struct *irdma_wq;

Another wq already?

> +struct irdma_pci_f {
> +	bool ooo;
> +	bool reset;
> +	bool rsrc_created;
> +	bool stop_cqp_thread;
> +	bool msix_shared;

Linus has spoken poorly about lots of bools in a struct. Can this be a
bitfield?

> +/***********************************************************/
> +/**
> + * to_iwdev - get device
> + * @ibdev: ib device
> + **/

Maybe some of these comment blocks are not so valuable :\

> +	spin_lock_irqsave(&rf->rsrc_lock, flags);
> +
> +	bit_is_set = test_bit(rsrc_num, rsrc_array);

Again, are these atomics? Looks like no, why test_bit?

Jason
