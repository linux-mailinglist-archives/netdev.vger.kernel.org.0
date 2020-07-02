Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FE921200C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgGBJgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgGBJgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 05:36:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E32A20760;
        Thu,  2 Jul 2020 09:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593682565;
        bh=M4Ip9Xi6j29k90rtJdYsp/qDfZss+ZwZqpmQqMK9gsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hhzbx65hHJto1xxHZkkSVSHj9Std5XFTJhAtcZdTDKbgu+dV0Zr7Gw5Ug5Kjbd1BX
         opkbChqhXbpJ57eX8tOIE1zGq9ZnejVQQPCDPk9YtWlRq1hvtXY/qjKvmLgyUXQe0y
         iwO9Dk85vCubCQWxkyMMueQV9k4JeW6OcGJioewc=
Date:   Thu, 2 Jul 2020 12:36:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: Mark PM functions as __maybe_unused
Message-ID: <20200702093601.GB4837@unreal>
References: <20200702091946.5144-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702091946.5144-1-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 05:19:46PM +0800, Wei Yongjun wrote:
> In certain configurations without power management support, the
> following warnings happen:
>
> drivers/net/ethernet/mellanox/mlx4/main.c:4388:12:
>  warning: 'mlx4_resume' defined but not used [-Wunused-function]
>  4388 | static int mlx4_resume(struct device *dev_d)
>       |            ^~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx4/main.c:4373:12: warning:
>  'mlx4_suspend' defined but not used [-Wunused-function]
>  4373 | static int mlx4_suspend(struct device *dev_d)
>       |            ^~~~~~~~~~~~
>
> Mark these functions as __maybe_unused to make it clear to the
> compiler that this is going to happen based on the configuration,
> which is the standard for these types of functions.
>
> Fixes: 0e3e206a3e12 ("mlx4: use generic power management")

I can't find this SHA-1, where did you get it?
And why doesn't mlx5 need this change?

Fixes: 86a3e5d02c20 ("net/mlx4_core: Add PCI calls for suspend/resume")

Thanks
