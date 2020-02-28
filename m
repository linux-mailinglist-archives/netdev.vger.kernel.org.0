Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D717401E
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1TK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1TK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:10:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A1420637;
        Fri, 28 Feb 2020 19:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582917028;
        bh=B0TG8l6j88oAgneV8YtHGKqD5dKPVbsBC890D0n5Xnk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TVnfi8jArDNNNsFMfeZaFMfLAs4+MafVYQ2GlfI326bSqbG2hJfUONCs5xY74bTK1
         uxrvCijWIv9ZR5iAU6639ZoftMvhhASw+8mH66ywJli0B6WXqCZy5QPopYrAaGaQEH
         ErqZp38isibEterqJvp4US+AqD/7EdNInvcyyI08=
Date:   Fri, 28 Feb 2020 11:10:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Message-ID: <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228004446.159497-9-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
        <20200228004446.159497-9-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 16:44:38 -0800 Saeed Mahameed wrote:
> From: Jianbo Liu <jianbol@mellanox.com>
> 
> Add a devlink parameter to control the number of large groups in a
> autogrouped flow table. The default value is 15, and the range is between 1
> and 1024.
> 
> The size of each large group can be calculated according to the following
> formula: size = 4M / (fdb_large_groups + 1).
> 
> Examples:
> - Set the number of large groups to 20.
>     $ devlink dev param set pci/0000:82:00.0 name fdb_large_groups \
>       cmode driverinit value 20
> 
>   Then run devlink reload command to apply the new value.
>     $ devlink dev reload pci/0000:82:00.0
> 
> - Read the number of large groups in flow table.
>     $ devlink dev param show pci/0000:82:00.0 name fdb_large_groups
>     pci/0000:82:00.0:
>       name fdb_large_groups type driver-specific
>         values:
>           cmode driverinit value 20
> 
> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Slicing memory up sounds like something that should be supported via
the devlink-resource API, not by params and non-obvious calculations :(
