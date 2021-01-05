Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033D22EB492
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhAEVCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbhAEVCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:02:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D63722D5A;
        Tue,  5 Jan 2021 21:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609880525;
        bh=lkfu/yGCz0v+4bYOWSKGrg3X2lmj23RLMWEMbkw1kys=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fU1SKYgevGtvEkgYg2qwRFYFCovoqtVztLhurcZkIOag0wgdRf4uLols3FYF1+cT5
         8Xww8ljPRsiiSHV9rfgiYrPmbCLH7922DnU1camtWUejNlPNJQ7RNu0ZmkF1Sr+7gh
         SwV5eui/heWPVV1OtCm5jyQ7uGoMGMAJw093zbJm5GJwoiC/WDOVopG0wcUeDAnvrG
         eI+AnNu3DGYXCcTEf1+ZwDghABEpigXLMAxY/U6KgbFW/DjoKOYFSDPJoFdudy7+SA
         s+dzzNkqzPoVj5X7yyD1vnvi9GzLiWrYLk3dD3TuN9ku2KPvf8NEA/Z300CHqe/XAL
         gbZio2t+8Durg==
Message-ID: <1c573f4e9cbfac79a959fb978459874f19307328.camel@kernel.org>
Subject: Re: [PATCH] [v2] net/mlx5e: Fix two double free cases
From:   Saeed Mahameed <saeed@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Gal Pressman <galp@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 05 Jan 2021 13:02:03 -0800
In-Reply-To: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
References: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-28 at 16:48 +0800, Dinghao Liu wrote:
> mlx5e_create_ttc_table_groups() frees ft->g on failure of
> kvzalloc(), but such failure will be caught by its caller
> in mlx5e_create_ttc_table() and ft->g will be freed again
> in mlx5e_destroy_flow_table(). The same issue also occurs
> in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
> kfree() to avoid double free.
> 
> Fixes: 7b3722fa9ef64 ("net/mlx5e: Support RSS for GRE tunneled
> packets")
> Fixes: 33cfaaa8f36ff ("net/mlx5e: Split the main flow steering
> table")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
> 
> Changelog:
> 
> v2: - Set ft->g to NULL after kfree() instead of removing kfree().
>       Refine commit message.
> 

applied to net-next-mlx5,
Thanks!

