Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAAC1DABCB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgETHRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgETHRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:17:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 810F5206C3;
        Wed, 20 May 2020 07:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589959030;
        bh=PBK/JdU5C0V9yOJ9AUusS5Q5DzdfTJRFrXitsz2s75U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ummPR1E4vL4ADNh8HZZgia56uTDYATv3c9nhnmhK71r2KQSWmODKbbHo4DiOZaBN
         uSJ/b7AzECSXfRbmlP8EPTfbUG2uFRctzDlt/E01wsFMrIKnHIQoTUxkfweSA0PrUG
         mn2pN8n/ZNJTa/24D+FStX7PoWonH7CH3dHmPIH0=
Date:   Wed, 20 May 2020 09:17:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-19
Message-ID: <20200520071707.GA2365898@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:15AM -0700, Jeff Kirsher wrote:
> This series contains the initial implementation of the Virtual Bus,
> virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus.
> 
> The primary purpose of the Virtual bus is to put devices on it and hook the
> devices up to drivers.  This will allow drivers, like the RDMA drivers, to
> hook up to devices via this Virtual bus.
> 
> The associated irdma driver designed to use this new interface, is still
> in RFC currently and was sent in a separate series.  The latest RFC
> series follows this series, named "Intel RDMA Driver Updates 2020-05-19".  
> 
> This series currently builds against net-next tree.
> 
> Revision history:
> v2: Made changes based on community feedback, like Pierre-Louis's and
>     Jason's comments to update virtual bus interface.
> v3: Updated the virtual bus interface based on feedback from Jason and
>     Greg KH.  Also updated the initial ice driver patch to handle the
>     virtual bus changes and changes requested by Jason and Greg KH.
> v4: Updated the kernel documentation based on feedback from Greg KH.
>     Also added PM interface updates to satisfy the sound driver
>     requirements.  Added the sound driver changes that makes use of the
>     virtual bus.

Why didn't you change patch 2 like I asked you to?

And I still have no idea why you all are not using the virtual bus in
the "ice" driver implementation.  Why is it even there if you don't need
it?  I thought that was the whole reason you wrote this code, not for
the sound drivers.

How can you get away with just using a virtual device but not the bus?
What does that help out with?  What "bus" do those devices belong to?

Again, please fix up patch 2 to only add virtual device/bus support to,
right now it is just too much of a mess with all of the other
functionality you are adding in there to be able to determine if you are
using the new api correctly.

And again, didn't I ask for this last time?

greg k-h
