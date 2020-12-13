Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D42D8CC7
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 12:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394847AbgLMLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394777AbgLMLcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:32:14 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FABC0613CF;
        Sun, 13 Dec 2020 03:31:33 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ce23so18607055ejb.8;
        Sun, 13 Dec 2020 03:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TjWjwM1ceLhbF1IYJl3oWPHfyZ88hbVMXIeiKOfmwOM=;
        b=vPvvh2iQ0r9ZbJoXMCDIftnNA4fETiNQFFFHNFtTvfww3hKWzjIscr3aHAUNvJNsBo
         Ivf0d9Mvb99JMJV9ehcDPkg7swsKEMl7+Y/hUHya1SLUv75EVwMKcVXA4wQhFYugquwI
         v+qVZoFUku+Z4S07otlNJUYYZFwuVftQM+5pKMuoRFtJsCSR2/FO/OAFm9dwXHUCnb0g
         nyevY+rBPRTACXhZ931IzFg7Awoce5sQ06vu7Ya86N9A/av13YTjQRgaXCWsCWUM/pP3
         fYNitfafK87nYGzSZSaCif4DP/TVC+LUGSPprBAe6V1QO0w7yMUKiZ5MZM5KRMECQCql
         1tPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TjWjwM1ceLhbF1IYJl3oWPHfyZ88hbVMXIeiKOfmwOM=;
        b=EPZo4+7oQFfLJk0ZS3qUAK86+YMOtgsKgGeVfNfutAZw0oJzQ8vv/4gBlFbVK+kvGT
         rOkxMkDN7A2yYRFYeUz0WnWmOqj0tN2dq4nSya5lnCqvcWczzHhFcMpiBn2WyCRD8BPe
         sCFm5MyVqb8xJBJ4YtXgWAC8GA7qq3uQw47UVVbVDduD+7mVgxuSOVQLpu5oN8eYGUOo
         MlLEzvc5en3d5iL5s2jDHMoo1v7c8wrZwhtUmZGqFtmT3tJcluTJZ3AVrsgJFlogpllq
         o+iUB1w3AFdYxVntzXe764yTyIiYOHwWrflfOkSdfEZ7RpXq5zJCFEDkzMGrbI2EDMgV
         AkPQ==
X-Gm-Message-State: AOAM5336vObGJtUfVxATbeeFPQIsqQbKSpSS/FjrWKDDuCQBPagXJL5v
        zaZJhwhgQ1lPaNnZ1CaFO+M=
X-Google-Smtp-Source: ABdhPJyEr8C9Ogdb1mA5xMC+43Vgspphph1JMIeMGN8re3oj2ZBqnM3siDmfQyHHB65lUudEMrQXmA==
X-Received: by 2002:a17:906:4bc5:: with SMTP id x5mr1966810ejv.55.1607859092305;
        Sun, 13 Dec 2020 03:31:32 -0800 (PST)
Received: from [192.168.0.107] ([77.127.34.194])
        by smtp.gmail.com with ESMTPSA id d6sm11014971ejy.114.2020.12.13.03.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 03:31:31 -0800 (PST)
Subject: Re: [patch 21/30] net/mlx4: Use effective interrupt affinity
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
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
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20201210192536.118432146@linutronix.de>
 <20201210194044.672935978@linutronix.de>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <57c3f9d3-7262-9916-626b-c2234de763f0@gmail.com>
Date:   Sun, 13 Dec 2020 13:31:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210194044.672935978@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2020 9:25 PM, Thomas Gleixner wrote:
> Using the interrupt affinity mask for checking locality is not really
> working well on architectures which support effective affinity masks.
> 
> The affinity mask is either the system wide default or set by user space,
> but the architecture can or even must reduce the mask to the effective set,
> which means that checking the affinity mask itself does not really tell
> about the actual target CPUs.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_cq.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
> @@ -117,7 +117,7 @@ int mlx4_en_activate_cq(struct mlx4_en_p
>   			assigned_eq = true;
>   		}
>   		irq = mlx4_eq_get_irq(mdev->dev, cq->vector);
> -		cq->aff_mask = irq_get_affinity_mask(irq);
> +		cq->aff_mask = irq_get_effective_affinity_mask(irq);
>   	} else {
>   		/* For TX we use the same irq per
>   		ring we assigned for the RX    */
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
