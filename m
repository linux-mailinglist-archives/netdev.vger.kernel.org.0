Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797AD388E64
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353471AbhESMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232671AbhESMxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 08:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABB961007;
        Wed, 19 May 2021 12:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621428709;
        bh=Z+GUaK6Vc6lSJWfaRYuD+KXYU6Iu4azZ6NZXx9TBN5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OujxalV5Jij21E6hZ8j14v6di5ULDEwKfZXvTyL29kwVa0VbwJv6vocZcBf5/17Ux
         vk3Iog3KQRJRnSyumR/BDfYisEIJH4N4ZSEgLQndOWjdYUJnQh7XgW5YNYjLDOoGBL
         aaPyjRq/U/Mit5qP3sorztAwrHoqJcPLVfrrz5IpbACO8cb/15X0zpKekLRFPYO42I
         tCdjUT1jaVJDbgSPt5lZUiaWoIx0Cixe6IxiQXKr2+e6dSRG4wdmaCL4gzY3Gj5WGM
         ilzpkUkDqz3nkN+WMQV/OIIuU6nZQXo1rYHVbqilOZGNiQSv3f++h0wYPnXRBzUlAq
         2Up65IHlwnUKg==
Date:   Wed, 19 May 2021 15:51:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH v5 06/22] i40e: Register auxiliary devices to provide RDMA
Message-ID: <YKUJ4rnZf4u4qUYc@unreal>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-7-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514141214.2120-7-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 09:11:58AM -0500, Shiraz Saleem wrote:
> Convert i40e to use the auxiliary bus infrastructure to export
> the RDMA functionality of the device to the RDMA driver.
> Register i40e client auxiliary RDMA device on the auxiliary bus per
> PCIe device function for the new auxiliary rdma driver (irdma) to
> attach to.
> 
> The global i40e_register_client and i40e_unregister_client symbols
> will be obsoleted once irdma replaces i40iw in the kernel
> for the X722 device.
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/net/ethernet/intel/Kconfig            |   1 +
>  drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
>  drivers/net/ethernet/intel/i40e/i40e_client.c | 152 ++++++++++++++++++++++----
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
>  4 files changed, 136 insertions(+), 20 deletions(-)

The amount of obfuscation in this driver is astonishing.

I would expect that after this series, the i40e_client_add_*() would be cleaned,
for example simple grep of I40E_CLIENT_VERSION_MAJOR shows that i40e_register_client()
still have no-go code.

Thanks
