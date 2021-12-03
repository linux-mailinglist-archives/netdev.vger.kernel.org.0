Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D5B467603
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380330AbhLCLTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380300AbhLCLTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:19:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8C6C06173E;
        Fri,  3 Dec 2021 03:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85867B82699;
        Fri,  3 Dec 2021 11:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69591C53FC7;
        Fri,  3 Dec 2021 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638530137;
        bh=+VtZ720b1eMR2w9XruLEqclYzZuxf13k+cp9MR0wM7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WW8Rv1chafJ63oKFySO33qK76ix85fbU9Os7SzhIPO9xrVjcLvYe1t1GxuJldCI3K
         5JnnCWA4ycdpa/lyShRJ7BdVMcBl+QMubVRfJyfrkab/ADWw8mhnqdn21eZWv3iEly
         k3uXabalQlyy+bYeAXq6utY+DKmHGQsibnHUisljKO2+bY+pGtzvUjeqR0AFUstmCJ
         qxbr3cHXF4OJ9EYVzULhsAIyCmO8S7pdNhCBc7JvnjukVJuY2rG1pZ1qPvGuVzeudu
         6ya5iZ6cJbSxqflT8lZ8F7d4LfzmKJoAJwK3oSHoW9u/xMDhEuakf58wRTpfy2KNDC
         cwk182aL0u6Xg==
Date:   Fri, 3 Dec 2021 13:15:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH net-next 07/11] net: hns3: add void before function which
 don't receive ret
Message-ID: <Yan8VDXC0BtBRVGz@unreal>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
 <20211203092059.24947-8-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203092059.24947-8-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 05:20:55PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add void before function which don't receive ret to improve code
> readability.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

NAK,

Please stop to do it and fix your static analyzer.
https://lore.kernel.org/linux-rdma/20211119172830.GL876299@ziepe.ca/

We don't add (void) in the kernel and especially for the functions that
already declared as void.

   void devlink_register(struct devlink *devlink)

Thanks

> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> index 4c441e6a5082..9c3199d3c8ee 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> @@ -120,7 +120,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
>  	hdev->devlink = devlink;
>  
>  	devlink_set_features(devlink, DEVLINK_F_RELOAD);
> -	devlink_register(devlink);
> +	(void)devlink_register(devlink);
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> index fdc19868b818..75d2926729d3 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> @@ -122,7 +122,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
>  	hdev->devlink = devlink;
>  
>  	devlink_set_features(devlink, DEVLINK_F_RELOAD);
> -	devlink_register(devlink);
> +	(void)devlink_register(devlink);
>  	return 0;
>  }
>  
> -- 
> 2.33.0
> 
