Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F0D1444C2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgAUTE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgAUTE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 14:04:26 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37A9424656;
        Tue, 21 Jan 2020 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579633465;
        bh=i9YMYRWEjV2kdaxUh9oT1XYrc6bBurP59uHneUIZCYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=np9gKpCGkjglG1qYBT7986GvxtLDwQQdpqtybmVoWP/4NKRAfaaP/FAMPbP98HWJz
         08mnwPwvGa1W1mfo4AiTTzPD8nfEhCsF3ItwJo71PzirpcrvS17zZJhowcNgMutYyZ
         0R4swHjj5SkY588ez7r6tynl02qTo/N7WdZv7G8U=
Date:   Tue, 21 Jan 2020 21:04:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next-mlx5 02/13] net/mlx5: Add new driver lib for
 mappings unique ids to data
Message-ID: <20200121190420.GM51881@unreal>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
 <1579623382-6934-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579623382-6934-3-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 06:16:11PM +0200, Paul Blakey wrote:
> Add a new interface for mapping data to a given id range (max_id),
> and back again. It supports variable sized data, and different
> allocators, and read/write locks.
>
> This mapping interface also supports delaying the mapping removal via
> a workqueue. This is for cases where we need the mapping to have
> some grace period in regards to finding it back again, for example
> for packets arriving from hardware that were marked with by a rule
> with an old mapping that no longer exists.
>
> We also provide a first implementation of the interface is idr_mapping
> that uses idr for the allocator and a mutex lock for writes
> (add/del, but not for find).
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> ---

I have many issues with this patch, but two main are:
1. This is general implementation without proper documentation and test
which doesn't belong to driver code.
2. It looks very similar to already existing code, for example xarray.

Thanks
