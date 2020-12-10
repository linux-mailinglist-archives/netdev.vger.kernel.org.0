Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC22D68D1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393817AbgLJUfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:35:48 -0500
Received: from ale.deltatee.com ([204.191.154.188]:48742 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393790AbgLJUf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 15:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=noa+454Phd4GD+cflUApEkbCBzQWdQM9xVdZ/BdtqiE=; b=ommLdATmScZCO3Nr0B0IKtaBD0
        EKrjnXBUtbfueazgUtm6VU6b3S0wYy6KVx4WAtwNJ/AqnjHK72Gy9Jsmxppzw/gnUhc4xUowZeQ7A
        VcHLuqMKttCxw8ez7I7uwmRr5QxGnTAmGxi8uXmfqMPsZhh7JjrJm5C+6KJYTWYREg/IlUxXKnLyU
        oiYCxI5xB8TP98NfY73pg38uPmgt4JkWMiii1mD9wV9ZT2fBKdzZ4FLSmo62RegEoh6XSnUbSd6AH
        TQacvQpLTj7RMyXxinaZaJU5rRKy+bJdREoJnd68m2upWyg2kGwzuZR1wf8InfiqQYZmWP3SPWvYA
        gjpGnwDw==;
Received: from s01060023bee90a7d.cg.shawcable.net ([24.64.145.4] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1knSdJ-0002Fm-25; Thu, 10 Dec 2020 13:33:50 -0700
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20201210192536.118432146@linutronix.de>
 <20201210194044.255887860@linutronix.de>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3526d997-a629-9843-7060-78d9e0a487c5@deltatee.com>
Date:   Thu, 10 Dec 2020 13:33:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210194044.255887860@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.145.4
X-SA-Exim-Rcpt-To: xen-devel@lists.xenproject.org, sstabellini@kernel.org, jgross@suse.com, boris.ostrovsky@oracle.com, leon@kernel.org, saeedm@nvidia.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net, tariqt@nvidia.com, Zhiqiang.Hou@nxp.com, m.karthikeyan@mobiveil.co.in, linux-pci@vger.kernel.org, michal.simek@xilinx.com, bhelgaas@google.com, robh@kernel.org, lorenzo.pieralisi@arm.com, lee.jones@linaro.org, linux-gpio@vger.kernel.org, linus.walleij@linaro.org, tvrtko.ursulin@linux.intel.com, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, wambui.karugax@gmail.com, chris@chris-wilson.co.uk, pankaj.laxminarayan.bharadiya@intel.com, daniel@ffwll.ch, airlied@linux.ie, rodrigo.vivi@intel.com, joonas.lahtinen@linux.intel.com, jani.nikula@linux.intel.com, linux-s390@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk, linux-parisc@vger.kernel.org, afzal.mohd.ma@gmail.com, deller@gmx.de, James.Bottomley@HansenPartnership.com, linux-ntb@googlegroups.com, allenbh@gmail.com, dave.jiang@intel.com, jdmason@kudzu.us, maz@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,NICE_REPLY_A autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [patch 17/30] NTB/msi: Use irq_has_action()
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-12-10 12:25 p.m., Thomas Gleixner wrote:
> Use the proper core function.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jon Mason <jdmason@kudzu.us>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Allen Hubbe <allenbh@gmail.com>
> Cc: linux-ntb@googlegroups.com

Looks good to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/ntb/msi.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- a/drivers/ntb/msi.c
> +++ b/drivers/ntb/msi.c
> @@ -282,15 +282,13 @@ int ntbm_msi_request_threaded_irq(struct
>  				  struct ntb_msi_desc *msi_desc)
>  {
>  	struct msi_desc *entry;
> -	struct irq_desc *desc;
>  	int ret;
>  
>  	if (!ntb->msi)
>  		return -EINVAL;
>  
>  	for_each_pci_msi_entry(entry, ntb->pdev) {
> -		desc = irq_to_desc(entry->irq);
> -		if (desc->action)
> +		if (irq_has_action(entry->irq))
>  			continue;
>  
>  		ret = devm_request_threaded_irq(&ntb->dev, entry->irq, handler,
> 
