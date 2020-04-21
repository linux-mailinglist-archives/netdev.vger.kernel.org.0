Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F3F1B2597
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgDUMIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUMIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:08:51 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C11BC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:08:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l25so14196818qkk.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3FhjQ0bL3FcnfxRJzwU2birDevO5bn+c/zKDG6q4ojY=;
        b=N5hGOnvmCUPCUcy5qlF8TnpMPyS5NrUDPwMg5ziycNEn6xaHz+vUgwmOfqMDzovFqM
         KitZtnSid0LTXK7MGOmRnsmIOeaZ8zMh8hq9FUSjgBj2njm4ACScqR6yvId/hNp2z7lE
         wiu/eXTamuCQ8Z1XkqPoim29eogc0Pv45t865NTWzrAty898+iGQ27i9IVdEaBjMRZ+7
         bqmvujumQb3naOHgLwk9ik7dvsnrtaVuYuDMjn7Go91BpmZE8ImRtGMy8ULNmFRKJGWd
         Gi6J7w2usbq0oBlSR50+KazBhWUS918rRZzzuLs5bEsFq2YkWA3DQ0og6zkppm2QjEnY
         2BZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3FhjQ0bL3FcnfxRJzwU2birDevO5bn+c/zKDG6q4ojY=;
        b=Siv7i0HBT8TXh3a1tEaqAqFu6/rT668h0w8GsZ0y9vuRnzAx7B/jfbTee9PyL9lsa0
         MjV7W7A/lFlm2XQkMxfTyMaVZFuKhv3soThjfHVbT927fB2JdkghqGNHK7zlXlg3fJpD
         XqNtC68x61TLyitMY45rk7dbd2sGUTt1534dwaMAg7AdIN/bEUWuQ9hg3L4wJ8fmxDxA
         KQV7ML1QiprHTiXmKgGY41ucaGbhzkkXGfJcH8Ln7aw/Mk5EZqNwY1+gh3Io2/Ewrfj1
         IgNKUIEmjn20epDFHhYfg7+FchnuL56e7SohqNmiJzt9KzeLRgGV3HGTDMbOnXXFHiAw
         2R0Q==
X-Gm-Message-State: AGi0PubEufcYe9mtZxldDVg78q/G2kdyFfBbsz9lzqfCwqBgw//cO+rB
        BW5y7JHjmWDBLMJLhJiY6Qj2TA==
X-Google-Smtp-Source: APiQypIj0hH3787ssUZ6URQylyWbMjelHPcljWGv7eRHlsoDIsY260nUcnsi5hmoo4c/Ctks8RpB0A==
X-Received: by 2002:a37:7906:: with SMTP id u6mr19843423qkc.489.1587470929241;
        Tue, 21 Apr 2020 05:08:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o27sm1583527qko.71.2020.04.21.05.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 05:08:48 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jQrho-0007vI-1O; Tue, 21 Apr 2020 09:08:48 -0300
Date:   Tue, 21 Apr 2020 09:08:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
Message-ID: <20200421120848.GR26002@ziepe.ca>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> +/**
> + * virtbus_release_device - Destroy a virtbus device
> + * @_dev: device to release
> + */
> +static void virtbus_release_device(struct device *_dev)
> +{
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +	int ida = vdev->id;
> +
> +	vdev->release(vdev);
> +	ida_simple_remove(&virtbus_dev_ida, ida);
> +}
> +
> +/**
> + * virtbus_register_device - add a virtual bus device
> + * @vdev: virtual bus device to add
> + */
> +int virtbus_register_device(struct virtbus_device *vdev)
> +{
> +	int ret;
> +
> +	if (!vdev->release) {
> +		dev_err(&vdev->dev, "virtbus_device MUST have a .release callback that does something.\n");
> +		return -EINVAL;
> +	}
> +	
> +	/* Don't return on error here before the device_initialize.
> +	 * All error paths out of this function must perform a
> +	 * put_device(), unless the release callback does not exist,
> +	 * so that the .release() callback is called, and thus have
> +	 * to occur after the device_initialize.
> +	 */
> +	device_initialize(&vdev->dev);
> +
> +	vdev->dev.bus = &virtual_bus_type;
> +	vdev->dev.release = virtbus_release_device;
> +
> +	/* All device IDs are automatically allocated */
> +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> +
> +	if (ret < 0) {
> +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> +		goto device_pre_err;

This still has the problem I described, why are you resending without
fixing?

Jason
