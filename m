Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449761F9C33
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgFOPsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFOPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:48:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C73C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=th4gD7twGiu96ZuI2JLCZu8yW3lFiM55LOE9/NVfaaY=; b=ZFaeaMT0Aoi4T+B2zem2gvgRpr
        xER3KhKdC7xqxwj2KCpfTQxxiC6I8UxcHWR2IgNJl5SnY5S+d3Lx3wCtH3ZxLZL+3eq6YRRULwwQ2
        ddsN7LMkCKyyjudQThiB7TUusisLupYJa4gvleGg/62DVr+iLbO06ISaxAZFfGBv76CyKwp6uKxi8
        BEKoDk5H/rYLFAEy53yaD5b7fxJBeCywClJ+C+WSJxA2WvhmUf2OvffpH/Yj8CVzRLT0nkwKzk7aW
        FdFe2FVRigGPFyRXoFgNHItMYzpqWYci08YGFucLAwb+Pb7pVp31yTd3q6A7DrRcHzlWkGrAyb3Cp
        fA2IRLjw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkrLL-0005RD-QB; Mon, 15 Jun 2020 15:48:15 +0000
Subject: Re: [PATCH 2/5] Huawei BMA: Adding Huawei BMA driver: host_cdev_drv
To:     yunaixin03610@163.com, netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
References: <20200615145906.1013-1-yunaixin03610@163.com>
 <20200615145906.1013-3-yunaixin03610@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0c724b75-f90d-a0f2-fbdb-4cd220b8e142@infradead.org>
Date:   Mon, 15 Jun 2020 08:48:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615145906.1013-3-yunaixin03610@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 6/15/20 7:59 AM, yunaixin03610@163.com wrote:
> diff --git a/drivers/net/ethernet/huawei/bma/Kconfig b/drivers/net/ethernet/huawei/bma/Kconfig
> index 1a92c1dd83f3..12979128fa9d 100644
> --- a/drivers/net/ethernet/huawei/bma/Kconfig
> +++ b/drivers/net/ethernet/huawei/bma/Kconfig
> @@ -1 +1,2 @@
> -source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
> \ No newline at end of file
> +source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
> +source "drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig"
> \ No newline at end of file

Please fix those warnings above.

> diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
> index 8f589f7986d6..c9bbcbf2a388 100644
> --- a/drivers/net/ethernet/huawei/bma/Makefile
> +++ b/drivers/net/ethernet/huawei/bma/Makefile
> @@ -2,4 +2,5 @@
>  # Makefile for BMA software driver
>  # 
>  
> -obj-$(CONFIG_BMA) += edma_drv/
> \ No newline at end of file
> +obj-$(CONFIG_BMA) += edma_drv/
> +obj-$(CONFIG_BMA) += cdev_drv/
> \ No newline at end of file

Same here.

> diff --git a/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig b/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
> new file mode 100644
> index 000000000000..97829c5487c2
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Huawei BMA software driver configuration
> +#
> +
> +config BMA
> +	tristate "Huawei BMA Software Communication Driver"
> +
> +	---help---

Just use
	help
here.  Use of ---help--- is being phased out.

> +	  This driver supports Huawei BMA Software. It is used 
> +	  to communication between Huawei BMA and BMC software.

	  to communicate

> +

thanks.
-- 
~Randy

