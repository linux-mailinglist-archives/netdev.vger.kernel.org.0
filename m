Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3285E2695FB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINUDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINUDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 16:03:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354A5207EA;
        Mon, 14 Sep 2020 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600113781;
        bh=l4Q4WPuEytbe/ZhzYL6FNXk2+70d3f/3OC4oKlTk4zA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0JSe+BRQnuBv9MknhqUcoIWiIpdTzU2B5ghDLqRhoYOujklgzUCKnb+onVuFSSefW
         r2lpUr1U/uIgk6W06goftBPLsMY/Q8Xp/4ZvmCFni+w8B2Xj4mAGXixYnbRsXjzwvQ
         qoFgKuL6vgVD8Z8GCq7T2NMhBBp8XAPZPGkEDPbM=
Date:   Mon, 14 Sep 2020 13:02:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     David Miller <davem@davemloft.net>, luojiaxing@huawei.com,
        idos@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value
 to ring_cons but not used it anymore in mlx4_en_xmit()
Message-ID: <20200914130259.6b0e2ec6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
References: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
        <20200912.182219.1013721666435098048.davem@davemloft.net>
        <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Sep 2020 13:12:05 +0300 Tariq Toukan wrote:
> 2. When MLX4_EN_PERF_STAT is not defined, we should totally remove the 
> local variable declaration, not only its usage.

I was actually wondering about this when working on the pause stat
patch. Where is MLX4_EN_PERF_STAT ever defined?

$ git grep MLX4_EN_PERF_STAT
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:#ifdef MLX4_EN_PERF_STAT
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:#endif /* MLX4_EN_PERF_STAT */
drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h:#ifdef MLX4_EN_PERF_STAT

