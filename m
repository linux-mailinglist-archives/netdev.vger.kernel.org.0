Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2CC32D9AA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhCDSvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235268AbhCDSul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 13:50:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3678E64F62;
        Thu,  4 Mar 2021 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614883801;
        bh=8TEBVrJx6zvAMycwaRz05lhz6ZfrWIcjBL8kdVPqmow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t6Lrs14H3reWWXieS9bCa/3NYokBgj4xg8C2qjZxoYnQjFOqR/KiC4RAVthkRU3Xd
         uSQUAGv3LViFK72sh1f2+joqozTkhQH+l6MvDj9sJkG7Mv9jBSSsUIzQi3LYpOQ3cV
         rWHff2dZco8L9sH4Zhg5wjbmh8yGxFrrXNgnt8X3ZDkbApeGOC25LtOL1dH5UXv7DL
         wEwiaujpAlbt8rj++OxU+vnFBNcsz+sIlfWkmGenNsgYZ/fP8sAZPyIHpDF6jM8J0a
         bz+vUnw/oyd0H7rE29FHQjT8Rhg4Tfqx4MTockkWqEcrR5o8M5/EKbjvGWmmAaADhW
         Y+zXKnsUmFPYQ==
Date:   Thu, 4 Mar 2021 10:50:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Yongxin Liu <yongxin.liu@windriver.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net 1/3] net: ethernet: ixgbe: don't propagate -ENODEV
 from ixgbe_mii_bus_init()
Message-ID: <20210304105000.5c001707@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304010649.1858916-2-anthony.l.nguyen@intel.com>
References: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
        <20210304010649.1858916-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Mar 2021 17:06:47 -0800 Tony Nguyen wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> It's a valid use-case for ixgbe_mii_bus_init() to return -ENODEV - we
> still want to finalize the registration of the ixgbe device. Check the
> error code and don't bail out if err == -ENODEV.
> 
> This fixes an issue on C3000 family of SoCs where four ixgbe devices
> share a single MDIO bus and ixgbe_mii_bus_init() returns -ENODEV for
> three of them but we still want to register them.
> 
> Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
> Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Are you sure this is not already fixed upstream by:

bd7f14df9492 ("ixgbe: fix probing of multi-port devices with one MDIO")

?
