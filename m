Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504422E3076
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 09:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgL0Idr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 03:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgL0Idr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 03:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24648207AB;
        Sun, 27 Dec 2020 08:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609057986;
        bh=wBte6beHPRpjRvAESlVnOERm+wcqSPP76lv0VK7bjb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pbtv4OxAzXefuY8pMhqUz+S2jO1NwMIlUmRw23lkyLwqgj6bYk3vIvBEzbsmSidTV
         Eol2/ZBY4yYdlDb0CAx+cdKORPZbdm3RsOj2bFVsRUfClqmjMJlTXuYH9RjuKMDnyC
         KMYrnto7w8iXZvmIWEDV4IwV5CbkQhMgbnGj1QYx/6DvUWrIdOA7RyjbQUbEYH7Dab
         7+EH7vaiJSaPq9R/wxX1cRHmINpJwJT/pUKhorNTudR3x1HVH5pOkciIWfRti5tpvN
         Z6bllFvEvhaj9Jkt1RPOe9SybBxTq+or9HrTIRz2SAU0MTToutYJteo0G9/iplIohv
         mVRtcajvAWkwg==
Date:   Sun, 27 Dec 2020 10:33:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Message-ID: <20201227083302.GD4457@unreal>
References: <20201221112731.32545-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221112731.32545-1-dinghao.liu@zju.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 07:27:31PM +0800, Dinghao Liu wrote:
> When mlx5_create_flow_group() fails, ft->g should be
> freed just like when kvzalloc() fails. The caller of
> mlx5e_create_l2_table_groups() does not catch this
> issue on failure, which leads to memleak.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 1 +
>  1 file changed, 1 insertion(+)
>

Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
