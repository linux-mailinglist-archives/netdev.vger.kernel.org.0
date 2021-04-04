Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05FE35370A
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 08:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhDDGZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 02:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhDDGZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 02:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFFA61247;
        Sun,  4 Apr 2021 06:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617517548;
        bh=K8HD8TX5u2dUALpuFYyYEWSZqL/EoPe6tfx8ELwXFf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xc+CE5MOqDbvKOCtNGOGZhCsys3oh+mCInui9+p62ULYFPQyuGvlmfTWW5xUE2TqA
         ZbY5xvcaLBPUEYz7AYWGu8eTkuzbDnlu4Ky6SPZoJh3txEnnyGbMZg3xb4IZhlRaqU
         VIpQpb74V7QZFe5Np6Z+942p4nlFAuYOL4+LczWG3fO7zW782B4SlK0lSA9IXygiUe
         fUvfwMbiTYzTP+1vKcJl0mkwSkLPHGckrq6v56bMy+tATRDN17H5oTI2NmPDH3Kan1
         HF2CMR6Z2UCmx/mt3Er4GV/uRTcjnKYq3Q4Fe1O3t3aTuvbXzoHEYveWLXL7+Pdktm
         v58FdYSqjA1SA==
Date:   Sun, 4 Apr 2021 09:25:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linuxarm@openeuler.org
Subject: Re: [PATCH net 1/2] net: hns3: Remove the left over redundant check
 & assignment
Message-ID: <YGlb6CgaW5r4lwaC@unreal>
References: <20210403013520.22108-1-salil.mehta@huawei.com>
 <20210403013520.22108-2-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403013520.22108-2-salil.mehta@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 02:35:19AM +0100, Salil Mehta wrote:
> This removes the left over check and assignment which is no longer used
> anywhere in the function and should have been removed as part of the
> below mentioned patch.
> 
> Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling reset_event")
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index e3f81c7e0ce7..7ad0722383f5 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -3976,8 +3976,6 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
>  	 * want to make sure we throttle the reset request. Therefore, we will
>  	 * not allow it again before 3*HZ times.
>  	 */
> -	if (!handle)
> -		handle = &hdev->vport[0].nic;

The comment above should be updated too, and probably the signature of
hclge_reset_event() worth to be changed.

Thanks

>  
>  	if (time_before(jiffies, (hdev->last_reset_time +
>  				  HCLGE_RESET_INTERVAL))) {
> -- 
> 2.17.1
> 
