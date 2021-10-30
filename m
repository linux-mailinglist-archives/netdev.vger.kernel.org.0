Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C876440AE5
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhJ3SJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 14:09:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhJ3SJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 14:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Mbi+N4JCINGOU2rjcKHc60MWlv4IX9XG/n6qKqPywPQ=; b=gQc7Wp4tLHiZ7BHXj1GzPxqnJj
        Hp8AirOAhETNOSunOg0L4HqeeGEKtdrs9KTyS0saKunvEkuHi7716FPs6ZpzPuxEyI5QPCRugUL6S
        easf5o8/xBKSk0ccEXuu23dKLsfm9zCXXbgDYNpGzBrPWSPdBWUvyDIFdtwTJe87pavo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mgsju-00CBtO-W9; Sat, 30 Oct 2021 20:05:58 +0200
Date:   Sat, 30 Oct 2021 20:05:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V5 net-next 6/6] net: hns3: remove the way to set tx
 spare buf via module parameter
Message-ID: <YX2JhqOTKOiB/EPO@lunn.ch>
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
 <20211030131001.38739-7-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030131001.38739-7-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 09:10:01PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> The way to set tx spare buf via module parameter is not such
> convenient as the way to set it via ethtool.
> 
> So,remove the way to set tx spare buf via module parameter.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 076631d7727d..032547a2ad2f 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -53,10 +53,6 @@ static int debug = -1;
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, " Network interface message level setting");
>  
> -static unsigned int tx_spare_buf_size;
> -module_param(tx_spare_buf_size, uint, 0400);
> -MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
> -

This might be considered ABI. By removing it, are you breaking users
setup?

	Andrew
