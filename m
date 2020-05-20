Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ECF1DB437
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgETMyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgETMyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:54:39 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088B0C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:54:39 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id fb16so1232690qvb.5
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LhyHeyAm+9m4HfkQWcbuv4oOoc3dEWc7U4EmNHbG8rY=;
        b=O7DAnPcIpe9Pp+CbrHjZtI7FxwzQR9mRoVeZrhoed4+0OczRVGs5jgil2g/MBlLyVF
         /i/BIg3lCSU+X2Qj5MI9NfVhQE7dA+/tt90fh8oo3dWBB/ByATqqYqwP1AjHL6oCli4L
         xScJC0nnHitfhgLIlUj4ddXBT2G/9kavhl0jkRjHJV2ffj+PCqZ4EhcpA0r2/8u9KdVz
         7/DgKE37XSr4qnkDx4H5UlAhACDEELR4b3t0ev8LY7j8UfHFcoYPBYt0EWP5u2Uhgp5D
         aZ257noNz9DQ8c+bqxwWiZDnht2Po4eVVweEKYZEUs8As4zK03VWxEZXu27zoHe2Karq
         +9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LhyHeyAm+9m4HfkQWcbuv4oOoc3dEWc7U4EmNHbG8rY=;
        b=Mb5UxFT0OEm2QEJ+pFOisPP3RkfElXAxXqgYSO6aHS7GrU5BBIjoWhuBp+W/aO76mY
         99zubCsVenmCcZJPhC+MumzJUTPAj2qTlJw77M9yxSFw+hVNfcBRw+MjNBQHll1ZLwKs
         M7pwMLb+hXhixIW8KGUnGiylp42xFHsU1YzNbwCrPGI/YDi92SLLH6rwohDfu/pvfzrB
         u7RNUy/6k+vWBrZS/IEbr9D3X7Sv/LmLoNvWEHpZIymN2WKsAm8jWK30fNDM5p8oMP5/
         08BX5dgsNmIDB0dswYH73m6ZW6oRHy17qeAllqAhYuignIBJwz24ky52tl3XT4O9BVmC
         C3Yg==
X-Gm-Message-State: AOAM533b/eloHKhubcYUVbr1TJzGqqQ+8BzSFgaoCPKMb/W6KiahfWmy
        Tx/cKbzdvK7661zhEZLEdzE/sA==
X-Google-Smtp-Source: ABdhPJzY2k/OQktCjNAMtYKx2gTXP65mUS+djUzPv/mchRiFOk2Soe/Jv4V5FRWI5F3VisQGUkDy7g==
X-Received: by 2002:a0c:ba99:: with SMTP id x25mr4675499qvf.119.1589979278178;
        Wed, 20 May 2020 05:54:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t195sm901007qke.110.2020.05.20.05.54.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2020 05:54:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbOF3-000690-8a; Wed, 20 May 2020 09:54:37 -0300
Date:   Wed, 20 May 2020 09:54:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200520125437.GH31189@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:25AM -0700, Jeff Kirsher wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> 
> A client in the SOF (Sound Open Firmware) context is a
> device that needs to communicate with the DSP via IPC
> messages. The SOF core is responsible for serializing the
> IPC messages to the DSP from the different clients. One
> example of an SOF client would be an IPC test client that
> floods the DSP with test IPC messages to validate if the
> serialization works as expected. Multi-client support will
> also add the ability to split the existing audio cards
> into multiple ones, so as to e.g. to deal with HDMI with a
> dedicated client instead of adding HDMI to all cards.
> 
> This patch introduces descriptors for SOF client driver
> and SOF client device along with APIs for registering
> and unregistering a SOF client driver, sending IPCs from
> a client device and accessing the SOF core debugfs root entry.
> 
> Along with this, add a couple of new members to struct
> snd_sof_dev that will be used for maintaining the list of
> clients.

If you want to use sound as the rational for virtual bus then drop the
networking stuff and present a complete device/driver pairing based on
this sound stuff instead.

> +int sof_client_dev_register(struct snd_sof_dev *sdev,
> +			    const char *name)
> +{
> +	struct sof_client_dev *cdev;
> +	struct virtbus_device *vdev;
> +	unsigned long time, timeout;
> +	int ret;
> +
> +	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
> +	if (!cdev)
> +		return -ENOMEM;
> +
> +	cdev->sdev = sdev;
> +	init_completion(&cdev->probe_complete);
> +	vdev = &cdev->vdev;
> +	vdev->match_name = name;
> +	vdev->dev.parent = sdev->dev;
> +	vdev->release = sof_client_virtdev_release;
> +
> +	/*
> +	 * Register virtbus device for the client.
> +	 * The error path in virtbus_register_device() calls put_device(),
> +	 * which will free cdev in the release callback.
> +	 */
> +	ret = virtbus_register_device(vdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* make sure the probe is complete before updating client list */
> +	timeout = msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
> +	time = wait_for_completion_timeout(&cdev->probe_complete, timeout);

This seems bonkers - the whole point of something like virtual bus is
to avoid madness like this.

> +	if (!time) {
> +		dev_err(sdev->dev, "error: probe of virtbus dev %s timed out\n",
> +			name);
> +		virtbus_unregister_device(vdev);

Unregister does kfree? In general I've found that to be a bad idea,
many drivers need to free up resources after unregistering from their
subsystem.

> +#define virtbus_dev_to_sof_client_dev(virtbus_dev) \
> +	container_of(virtbus_dev, struct sof_client_dev, vdev)

Use static inline

Jason
