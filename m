Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CAD94949
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfHSP6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:58:08 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40209 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbfHSP6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:58:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EF40721F82;
        Mon, 19 Aug 2019 11:58:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Aug 2019 11:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gpIBDU
        fEZDWpISBZBKSzckdrBhI7tyEF/XdiR6xtils=; b=Dq+rxnHmDSnDxbOUUxbdOI
        h+DMsDLbSLEG6axCOcFuszM9/qfiF46JqMt0jSysoMi0sbEp1hpNmBKnWwbW3/Qj
        os4eZWceQFMejicWLvZKjwoum5c+SFDOsCVY6Ajc8yLmnKzoVKMhzYezxEvjMsRo
        1jOtSiiFfYBuAy1ovQv5jENF838z2O+hJTo58edFJKfHpqQCAni0UiyXOrVrT+Uj
        /ENsgmjmKRWcjTKKAEzCSYbDs0Nj7gncaZy6iBu3AcGEXh8eaNMkSgxKdxsar3/f
        NNelLraLR4SfSf0llYc2gnUPScMSgpq5wp0fAWNI916fT5deaw2Ktp6E+OkSb6Bg
        ==
X-ME-Sender: <xms:DsdaXb480tNg0T9Y5FKVz6FWrttAwiWluQXV-_jVr-gbdJth0T-m4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefledgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:DsdaXWEfff4oQh-ZUn1dkI9CMUKz9vMXvMwZvezpH5N6pPxEEklF4Q>
    <xmx:DsdaXTWAm7GVPHb5PKiLOyKPPL6F7LpcsY-RvG7AE6ZXmEHPTWeVug>
    <xmx:DsdaXSWFBP5uRjGAZx15SaiMkwpnl8K9jnmO0bHlkphrRlvX8o0_NA>
    <xmx:DsdaXRxiJZRu_xpoLr_fOa1Xf6TOMVuTT1oVl8fx-055-e5FiS9ouA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69D5F380083;
        Mon, 19 Aug 2019 11:58:05 -0400 (EDT)
Date:   Mon, 19 Aug 2019 18:58:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, idosch@mellanox.com, jiri@mellanox.com,
        mcroce@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next] netdevsim: Fix build error without CONFIG_INET
Message-ID: <20190819155803.GA16864@splinter>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819120825.74460-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 08:08:25PM +0800, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
> dev.c:(.text+0x67b): undefined reference to `ip_send_check'
> 
> Add CONFIG_INET Kconfig dependency to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks for the patch.

> ---
>  drivers/net/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 48e209e..7bb786e 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -505,7 +505,7 @@ source "drivers/net/hyperv/Kconfig"
>  
>  config NETDEVSIM
>  	tristate "Simulated networking device"
> -	depends on DEBUG_FS
> +	depends on INET && DEBUG_FS
>  	select NET_DEVLINK
>  	help
>  	  This driver is a developer testing tool and software model that can
> -- 
> 2.7.4
> 
> 
