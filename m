Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D406540B633
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhINRtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231723AbhINRtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 13:49:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF44660EE7;
        Tue, 14 Sep 2021 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631641663;
        bh=XwFlKQprbS5Xsut4+KVkQ9rCehkueeb5Va+IvjAKMe4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KSv+RtTpPHB8oKm9pr3uJGiIUDjyo2a5hOdIoMlnQ+P24YDigyFarSm+jspCdwnaF
         78wzNARuX57eydl869SJQaHVt0n+G1NmLKKEHCwNPgxa6qAD3uhsKdlKXTwojUKZ7H
         e7udUMegacreRABX8g+Klx5kSDDa8xPkubf2ga8jzzyOtSw/eAwSGSkqgPnkSsnnfs
         DJLgqqWkeSW2lf1sKx3nerYD0NvR/aGS0vURmuOHsA4rK3TLz3D+S8yshF0EsjYWLd
         EFkngxWr8o95rvJkavLuM9rA/6eGaHB/RYfqc4goNJ0MsM6pB+TnxV2cG/eGWX4zkF
         xaDCKjKF8Ujdw==
Date:   Tue, 14 Sep 2021 10:47:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Yufeng Mo <moyufeng@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, shenjian15@huawei.com,
        lipeng321@huawei.com, yisen.zhuang@huawei.com,
        linyunsheng@huawei.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, salil.mehta@huawei.com,
        linuxarm@huawei.com, linuxarm@openeuler.org, dledford@redhat.com,
        jgg@ziepe.ca, netanel@amazon.com, akiyano@amazon.com,
        thomas.lendacky@amd.com, irusskikh@marvell.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        rohitm@chelsio.com, jacob.e.keller@intel.com,
        ioana.ciornei@nxp.com, vladimir.oltean@nxp.com,
        sgoutham@marvell.com, sbhatta@marvell.com, saeedm@nvidia.com,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
Message-ID: <20210914104741.78b21e72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a366c691-fb81-8e30-3853-3260ceabf080@linux.ibm.com>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
        <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
        <a366c691-fb81-8e30-3853-3260ceabf080@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 20:31:29 +0300 Julian Wiedmann wrote:
> > -	if (!dev->ethtool_ops->set_coalesce)
> > +	if (!dev->ethtool_ops->set_coalesce && !dev->ethtool_ops->get_coalesce)
> >  		return -EOPNOTSUPP;
> >    
> 
> This needs to be
> 
> 	if (!set_coalesce || !get_coalesce)
> 		return -EOPNOTSUPP;
> 
> Otherwise you end up calling a NULL pointer below if just _one_ of the
> callbacks is available.

Good catch, care to send a fix?
