Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EED333812
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhCJJCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhCJJCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06B2464FEF;
        Wed, 10 Mar 2021 09:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615366949;
        bh=TkA4EcJ+FLBY9RWCgS6XXfVJKoxhsxyug0tNpQ8M1k8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsM3hf4ZNex1ZKTiLum7eJpqEnwYqTyeN5o/iCezg2KQevcntsaOxhzFRYRo3wFxz
         lIKqG9aQDuuVNJqVbNtQ861KNZJtDLmYd6Gt4TLqeVBSly0vyi54XeUFiXQw+xvwP3
         XRvfA16uIkxWkRsLwvtHr7LeOITpRUAMl4QpdOMk=
Date:   Wed, 10 Mar 2021 10:02:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
Message-ID: <YEiLI8fGoa9DoCnF@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:54:03AM -0600, Mike Ximing Chen wrote:
> Intel DLB is an accelerator for the event-driven programming model of
> DPDK's Event Device Library[2]. The library is used in packet processing
> pipelines that arrange for multi-core scalability, dynamic load-balancing,
> and variety of packet distribution and synchronization schemes

The more that I look at this driver, the more I think this is a "run
around" the networking stack.  Why are you all adding kernel code to
support DPDK which is an out-of-kernel networking stack?  We can't
support that at all.

Why not just use the normal networking functionality instead of this
custom char-device-node-monstrosity?

What is missing from todays kernel networking code that requires this
run-around?

thanks,

greg k-h
