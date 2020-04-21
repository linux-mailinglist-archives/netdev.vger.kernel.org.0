Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77BC1B21FA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgDUIrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgDUIrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:47:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18AA92072D;
        Tue, 21 Apr 2020 08:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587458859;
        bh=DLGo69Hmv7O3kG2ucEVX9+YSA4M5+2rZB8nCAFIDh0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxPQVhoJjAp0j3NX2DUBgccDQrLnlMtP9xGceyW/2ZtNJQM5mm5xljsOBR1FxpPja
         w6o0dz8FOZM4KMdY3y1htQyQdN/jrRi4ZRXRXU9h0ia8fsozAvah6YQeF0CqpB8/vO
         nG/YdxbwGh/jrzI2oRU5xxbCmAFvSl6giyzgEbV0=
Date:   Tue, 21 Apr 2020 10:47:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
Message-ID: <20200421084737.GE716720@kroah.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> +struct virtbus_driver {
> +	int (*probe)(struct virtbus_device *);
> +	int (*remove)(struct virtbus_device *);
> +	void (*shutdown)(struct virtbus_device *);
> +	int (*suspend)(struct virtbus_device *, pm_message_t);
> +	int (*resume)(struct virtbus_device *);
> +	struct device_driver driver;
> +	const struct virtbus_dev_id *id_table;
> +};

You create this type of driver, but then never use it in your
implementations that happen to create virtbus devices.  So does that
imply that you do not need virbus_drivers at all?  Why add all of this
code that never gets used?

Or perhaps you should be creating a virbus driver?  I can't tell, but as
it is, this series is not ready to be merged.

greg k-h
