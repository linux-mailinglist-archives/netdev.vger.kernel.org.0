Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F673F7EFA
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhHYXXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhHYXXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 19:23:37 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89681C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=34IjE8Y9sbM4vh8ISPj7uI5P0DwXfJCDtMrNuak/CPQ=; b=oEpxLAZ4c1dY0Dj7GPawTcWUgE
        IYMruJTIO8NbaLlF0zRfeMYfkO99LkUwkzvykQ3sMBAjZ2jLFh2p/bws6vMIaIVaxFq4dlMI6Ba/+
        stOmxSOC0dRqULReVxtLptrocf9iwiT2xLhXAw5LYchNtOEz1HZNgEfS45sXlN2kX0birqzSD6Pst
        0TnghpMVmIs4+kDpV380zNXZSLB+NieJYnTI5htyKgo+8HEG1a5FzBR5jbnwkJN+WGFk6i2z7VCvO
        9u+0+3UKcajNi7BGSKq4OhYq1fLwoq0bFgsk3lrU4/8Dm8kt9n7iULnXq76fjMrzE9+nDyEPYUC1w
        vEIfjM2w==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJ2EI-008hN4-Ka; Wed, 25 Aug 2021 23:22:46 +0000
Subject: Re: [PATCH net-next] ptp: ocp: Simplify Kconfig.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@kernel.org,
        richardcochran@gmail.com, kernel-team@fb.com
References: <20210825211733.264844-1-jonathan.lemon@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <09355764-4444-e530-c14b-1f3d9d947b61@infradead.org>
Date:   Wed, 25 Aug 2021 16:22:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825211733.264844-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 2:17 PM, Jonathan Lemon wrote:
> Remove the 'imply' statements, these apparently are not doing
> what I expected.  Platform modules which are used by the driver
> still need to be enabled in the overall config for them to be
> used, but there isn't a hard dependency on them.
> 
> Use 'depend' for selectable modules which provide functions
> used directly by the driver.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   drivers/ptp/Kconfig | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 32660dc11354..f02bedf41264 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -171,16 +171,10 @@ config PTP_1588_CLOCK_OCP
>   	tristate "OpenCompute TimeCard as PTP clock"
>   	depends on PTP_1588_CLOCK
>   	depends on HAS_IOMEM && PCI
> -	depends on SPI && I2C && MTD
> +	depends on I2C && MTD
> +	depends on SERIAL_8250
>   	depends on !S390
> -	imply SPI_MEM
> -	imply SPI_XILINX
> -	imply MTD_SPI_NOR
> -	imply I2C_XILINX
> -	select SERIAL_8250
>   	select NET_DEVLINK
> -
> -	default n
>   	help
>   	  This driver adds support for an OpenCompute time card.
>   
> 

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
