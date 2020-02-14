Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41ECF15E674
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392871AbgBNQUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405224AbgBNQUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:32 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4612472D;
        Fri, 14 Feb 2020 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697231;
        bh=V/EDnm96acT9qk1c6SHMF0KqVGZhxiZZ6WOI0t4tuj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ie8ma1uu/iwSfuIPDTRQeYUqZNX/WfKMI8i+/FdzY8wUg+xIneQSPrK+8USeBOrGU
         r+ZyhBjybpeKK2unxu5l7Xbpz/CN4y6eqtymOHlDoP0uDpM3T4wv/ls8xzMAbOp4PT
         FxNnECzcmk4TqbM6BrxNYeVLAWtZzzqf6Jjt5Dcs=
Date:   Fri, 14 Feb 2020 08:20:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cris Forno <cforno12@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tlfalcon@linux.ibm.com, davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH, net-next, v4, 1/2] ethtool: Factored out similar
 ethtool link settings for virtual devices to core
Message-ID: <20200214082028.3d82d957@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200213201410.6912-2-cforno12@linux.vnet.ibm.com>
References: <20200213201410.6912-1-cforno12@linux.vnet.ibm.com>
        <20200213201410.6912-2-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Feb 2020 14:14:09 -0600 Cris Forno wrote:
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e43..149f982 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -394,6 +394,8 @@ struct ethtool_ops {
>  					  struct ethtool_coalesce *);
>  	int	(*set_per_queue_coalesce)(struct net_device *, u32,
>  					  struct ethtool_coalesce *);
> +	bool    (*virtdev_validate_link_ksettings)(const struct
> +						   ethtool_link_ksettings *);

Could this callback be passed to ethtool_virtdev_set_link_ksettings()
as an argument instead of being in the global structure? Callers need
to pass speed and duplex pointers anyway.

>  	int	(*get_link_ksettings)(struct net_device *,
>  				      struct ethtool_link_ksettings *);
>  	int	(*set_link_ksettings)(struct net_device *,

