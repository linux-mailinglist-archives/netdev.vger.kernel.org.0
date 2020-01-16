Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAE713DB15
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgAPNFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgAPNFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:05:08 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0A52075B;
        Thu, 16 Jan 2020 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579179907;
        bh=A3mKxItf9+NyyOg8vXy39/HhGF1QgFXPBdeaDgAToZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXCW+s+sb8Vx3spg6JExdhswXSE0f+D8d6A/NvhnYXI9YT7lT7VnlsS64gxQklmQE
         UpdKI7TDPcP/BRnRvvD32O9nMlJqnBUmhgW1txD+hxkmRIm34aPwloSKmM8NNALk8k
         FHjzalPM0fiBLxpUqo6na+cfnLKcliaClsg6XKlo=
Date:   Thu, 16 Jan 2020 05:05:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hongbo Yao <yaohongbo@huawei.com>
Cc:     <chenzhou10@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] drivers/net: netdevsim depends on INET
Message-ID: <20200116050506.18c2cce3@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200116125219.166830-1-yaohongbo@huawei.com>
References: <20200116125219.166830-1-yaohongbo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 20:52:19 +0800, Hongbo Yao wrote:
> If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
> Building drivers/net/netdevsim/fib.o will get the following error:
> 
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
> 
> Correct the Kconfig for netdevsim.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 83c9e13aa39ae("netdevsim: add software driver for testing
> offloads")

Please provide a _correct_ Fixes tag, and don't line wrap it.
The commit you're pointing to doesn't use any of the fib functions 
so how can it be to blame?

> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
> ---
>  drivers/net/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 77ee9afad038..25a8f9387d5a 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -549,6 +549,7 @@ source "drivers/net/hyperv/Kconfig"
>  config NETDEVSIM
>  	tristate "Simulated networking device"
>  	depends on DEBUG_FS
> +	depends on INET
>  	depends on IPV6 || IPV6=n
>  	select NET_DEVLINK
>  	help

