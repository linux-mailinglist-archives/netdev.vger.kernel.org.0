Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6D1AECA1
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgDRMuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 08:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgDRMuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 08:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C3821D79;
        Sat, 18 Apr 2020 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587214253;
        bh=YA9ircK04lHIXBvqfidwJGcIuaIdkoipM8rQTMjnsiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mmh7m/qJRhDeinxPfMoZwl13o+Ur5NluQGZJRg0SKUyYudmxA35rTxtcWmQi6F53Q
         SwejsXpFOKA3AC1AyinOoVm6ZVvuoO2/wQoklqgFvkzr1DvvLtDucxuTxtGJIADuNz
         +AyDHLjUt8fyKYyyHWq9lGXtfqhPDqccsUT08wWA=
Date:   Sat, 18 Apr 2020 14:50:51 +0200
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
Subject: Re: [net-next 1/9] Implementation of Virtual Bus
Message-ID: <20200418125051.GA3473692@kroah.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:10:26AM -0700, Jeff Kirsher wrote:
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-20 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for more information
> + */
> +
> +#ifndef _VIRTUAL_BUS_H_
> +#define _VIRTUAL_BUS_H_
> +
> +#include <linux/device.h>
> +
> +struct virtbus_device {
> +	struct device dev;
> +	const char *name;

struct device already has a name, why do you need another one?

> +	void (*release)(struct virtbus_device *);

A bus should have the release function, not the actual device itself.  A
device should not need function pointers.

> +	int id;

Shouldn't that be a specific type, like u64 or something?

thanks,

greg k-h
