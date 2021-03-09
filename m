Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A0A3321E9
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhCIJ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhCIJ0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 04:26:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB2B565220;
        Tue,  9 Mar 2021 09:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615281966;
        bh=o/3NqzHuRsosyW7jHcQ96l/yDZF5aR4qiQII6OMRd+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=se8J1KvJ6z23RZ6tOKnl+ss+4rG93hIiOA9OeJ4KeWvRoDRrITIcDbH/dEDsLSmm0
         T7i+6U+UEltCCsHJnsk1H/g3szkGNMAWYQaRw+FrWsTar8/zHs9nX0IWQKj+QzrKg6
         moUv8uY4gxlhst6/++z4tEq91JQlgPzxlWS9R5nA=
Date:   Tue, 9 Mar 2021 10:26:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: Re: [PATCH v10 04/20] dlb: add device ioctl layer and first three
 ioctls
Message-ID: <YEc/KwOPzvnozaV4@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-5-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210175423.1873-5-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:54:07AM -0600, Mike Ximing Chen wrote:
> +/*
> + * DLB_CMD_CREATE_SCHED_DOMAIN: Create a DLB 2.0 scheduling domain and reserve
> + *	its hardware resources. This command returns the newly created domain
> + *	ID and a file descriptor for accessing the domain.
> + *
> + * Output parameters:
> + * @response.status: Detailed error code. In certain cases, such as if the
> + *	ioctl request arg is invalid, the driver won't set status.
> + * @response.id: domain ID.
> + * @domain_fd: file descriptor for performing the domain's ioctl operations
> + * @padding0: Reserved for future use.

For all of your paddingX fields, you MUST check that they are set to 0
by userspace now, otherwise they will never be able to actually be used
in the future.

But why do you need them at all anyway?  If something needs to be
changed in the future, just add a new ioctl, don't modify something that
is already working.  Are you _SURE_ you need this type of functionality?

thanks,

greg k-h
