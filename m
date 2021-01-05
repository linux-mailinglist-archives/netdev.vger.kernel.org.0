Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090CE2EB59D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbhAEW7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 17:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbhAEW7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 17:59:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A93D22E00;
        Tue,  5 Jan 2021 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887537;
        bh=yvJWF3Atmch9FILnbqt/QhYjAjr7OwsXdfUPbuO+iRc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e1EKylGCYebCczfXcfcJEHEw4BpAEWIsvSBX6o1AfbEKGSIrWDuTUUcWlHT2rnZ4Y
         izZ812JOdoWRnRuf5vtuKbJicnsSwz28RLURStkW5dWPtuy8kyWaWWulcsYMWIxG6s
         wH1W+iTWUfE9p2YVvFWrSD3B97fafcDeFVKhhBTY/8g7X5jVLQc+6fd1FQo5K2+GWo
         myXxj1XXLbYZOyolzq4D5JYqA4j36hsnJDrvRglhmzIBV9HYCUTadl8e/GJ95eIqb6
         A8uv034Ho9Rsd2oRFT5kir5jz8LCvXNjCFxWpldnVd/x6fEM6XEU8K9MG+wIhLHvr8
         eWkvZxld8NM2w==
Message-ID: <84f00137e923162ece24462f56aa204b7a561256.camel@kernel.org>
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
Date:   Tue, 05 Jan 2021 14:58:55 -0800
In-Reply-To: <1c573f4e9cbfac79a959fb978459874f19307328.camel@kernel.org>
References: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
         <1c573f4e9cbfac79a959fb978459874f19307328.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-05 at 13:02 -0800, Saeed Mahameed wrote:
> On Mon, 2020-12-28 at 16:48 +0800, Dinghao Liu wrote:
> > mlx5e_create_ttc_table_groups() frees ft->g on failure of
> > kvzalloc(), but such failure will be caught by its caller
> > in mlx5e_create_ttc_table() and ft->g will be freed again
> > in mlx5e_destroy_flow_table(). The same issue also occurs
> > in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
> > kfree() to avoid double free.
> > 
> > Fixes: 7b3722fa9ef64 ("net/mlx5e: Support RSS for GRE tunneled
                       ^ this is one digit too much..
Fixes line must start with a 12 char SHA and not 13 :).

I fixed this up, no need to do anything but just FYI.

> > packets")
> > Fixes: 33cfaaa8f36ff ("net/mlx5e: Split the main flow steering
> > table")
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> > ---
> > 
> > Changelog:
> > 
> > v2: - Set ft->g to NULL after kfree() instead of removing kfree().
> >       Refine commit message.
> > 
> 
> applied to net-next-mlx5,
> Thanks!
> 

