Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6078F1AE5E5
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgDQThj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbgDQThj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:37:39 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B1C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:37:39 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id q73so1520474qvq.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FgqzaAqzUse7EkhP7A7fzpKzRWCDmLlTQk1KUcsDcVY=;
        b=HkGcnszDQO6EWcwEd72V7W4XjW/6K94sc/qtdACdVqlizNljyHPaNXwaWLlQ59Zv9a
         MCvhaCxt11f6alnogM08BSvnz6YJHsV48oR4ep7xcyzNK278UWEYVYwQ1x1DMa0u6wA0
         xIPgRU9GOlN4cdo3QC7gGdCwUrjrwG0BuUIBfdDQfJx/CyIKy6eRV2q73l7y5i2HzaQq
         6eOIJDHPA2bZBQLUDOcYxRSxN+jUFMPxpsSyBRHaz06i1aS3EZpIaMMfnDpWG1/hLh5U
         W2eSX5hOCCwsBzP/zcPCkK79Q82Syi+pWfA711IlN5ntClISg3CRjkZVEarM6bjKWgSU
         GUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FgqzaAqzUse7EkhP7A7fzpKzRWCDmLlTQk1KUcsDcVY=;
        b=FVQ6JI5QjBXtvaIeWmNUT8utXLkuooDXSeRIgQLTjf7DsDS4KUBNaTWsrP8XMQYgH9
         ZZ6MkN49X0L0ZcvKO7ZUmGFVXnyWgMucEJMNOWZ3sHqp2MPLDUcFBv8BjWc93D89CBik
         uv1aRjIlYhzk0096JDYFVFUDAmlyLqYkhFiNk0QBIFsku7pxbaIHMqGOE91k9Y0TtIUX
         3Er48Uz28HuoWYmpZrQ/QXcCIMpXSo25tady5QAklXLuFDwZ/fpyt4gixGBiVnZN4E38
         Nu1/gO7+F5nVNC3R+LEloV7m8pR8kJrDvP52Pa3MI2rR7h42gfZIqTqLUCHf8jxNCKoj
         IXrw==
X-Gm-Message-State: AGi0PubIO65heyXmS8tBdd01/IPmikIILNceCXmSjyCmcb2rlLHJcR2A
        NenSfD4x7dBFF2WzroDPEZu7jA==
X-Google-Smtp-Source: APiQypJ2H8WFRl51n5CP5ffkye7mXhRVOUdwVr7/dIkQ3T0wOgOBDMfVYxRkLdzZzH+kql5wTgBKTA==
X-Received: by 2002:a0c:9b89:: with SMTP id o9mr4259189qve.131.1587152258195;
        Fri, 17 Apr 2020 12:37:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id r3sm17425814qkd.3.2020.04.17.12.37.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Apr 2020 12:37:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jPWnw-0004ul-DE; Fri, 17 Apr 2020 16:37:36 -0300
Date:   Fri, 17 Apr 2020 16:37:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200417193736.GK26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:

> +/* client interface functions */
> +static const struct i40e_client_ops i40e_ops = {
> +	.open = i40iw_open,
> +	.close = i40iw_close,
> +	.l2_param_change = i40iw_l2param_change
> +};
> +
> +static struct i40e_client i40iw_client = {
> +	.name = "irdma",
> +	.ops = &i40e_ops,
> +	.type = I40E_CLIENT_IWARP,
> +};
> +
> +int i40iw_probe_dev(struct virtbus_device *vdev)
> +{
> +	struct i40e_virtbus_device *i40e_vdev =
> +			container_of(vdev, struct i40e_virtbus_device, vdev);
> +	struct i40e_info *ldev = i40e_vdev->ldev;
> +
> +	ldev->client = &i40iw_client;
> +
> +	return ldev->ops->client_device_register(ldev);
> +}
> +
> +int i40iw_remove_dev(struct virtbus_device *vdev)
> +{
> +	struct i40e_virtbus_device *i40e_vdev =
> +			container_of(vdev, struct i40e_virtbus_device, vdev);
> +	struct i40e_info *ldev = i40e_vdev->ldev;
> +
> +	ldev->ops->client_device_unregister(ldev);
> +
> +	return 0;
> +}

This would be alot more compelling if the driver didn't go on to just
another crufty layer of register/unregister.

It feels like the virtbus was just dumped on top of the existing
scheme without properly reworking it.

> diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
> new file mode 100644
> index 000000000000..8075b7bf6ae8
> +++ b/drivers/infiniband/hw/irdma/main.c
> @@ -0,0 +1,573 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#include "main.h"
> +
> +bool irdma_upload_context;
> +
> +MODULE_ALIAS("i40iw");

I'm not sure you can do this without deleting i40iw

Jason
