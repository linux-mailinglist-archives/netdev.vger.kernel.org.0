Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13792D934A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 07:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgLNGi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 01:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgLNGi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 01:38:59 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34FC0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 22:38:18 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id n26so20956155eju.6
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 22:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aOHfkm0teAcnfRNG4mO8qFxgF/Cu1iIFNonJtBdSO2U=;
        b=BqARR727KmD+lU7B5EuZO7ICDgpOZbXaKDosuAm8eRYvCyDRbSWpuJnMprO0gzjkyj
         xyGSQdoZBajDOQPTH8l4wvvLw1FYea9X4G5W/mmZHjvEM1GJ/doTerdozwunzA62Bvo+
         rimOM7lZC+18I5YjWKt+NICD2brqQd7LlUR0G9ufKkx1WVxfMRiWR0aOpTv5cUh3Bxcu
         sa2dJmyoIay302Sh+jGjXrOAZJSbtpyUyCcoS7TyfhKHMetmPeWNlkkLwWWFtXtMMvH1
         PW4S69sLu4cakpz4F/GY/Nl8/8dtHmISThFRHh8LMkXCljCTLxf9QXZJq0GNrcJzIfIQ
         nXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aOHfkm0teAcnfRNG4mO8qFxgF/Cu1iIFNonJtBdSO2U=;
        b=WXxuhwctCeZdsiFOpFxRdJ1x58y17VwfOUs5y0bf4W2GdyafFV7O/Rv9FycvfddyB4
         mjHcxbtp/0im+p95WANFmg0M6Z15QO7FNTgOVj2pmhljEAnkWdF17ebt+d8uqEGbvIJ8
         EojNyqzdYr6XfGqALUf3E4WInPCL3h4dGm1LThDeZ0fgCIRDQg12F627NOZqHqpRBT0U
         qeWlLUx1iFMcxXrqcmmxsYZwx2eug8z/Voh6k0+tRnDo8ritLO5c/XYcfcjxz4rv8iet
         vdO9zJ8wDthaIbaWPDRdO7JJPdcotajpshewndyvimZSvVe7oGKmORnrr14byrkW/LEb
         6+hQ==
X-Gm-Message-State: AOAM531e1WY341OmuEyp7WAktOemtM90OZNsVf3EUZyq5aqRUsav5qu1
        eh63JdJGAHvmilnQDZX/zcw=
X-Google-Smtp-Source: ABdhPJyxpmDnVB7y0lo7iNWp+ekNybe8pS6suLmdxh4aWjTkORzRnfvp67TYc+FBlMfLwCSAgX1FSg==
X-Received: by 2002:a17:906:234d:: with SMTP id m13mr21439016eja.270.1607927897498;
        Sun, 13 Dec 2020 22:38:17 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id d3sm11042141edt.32.2020.12.13.22.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 22:38:15 -0800 (PST)
Subject: Re: [PATCH v1 net-next 05/15] nvme-tcp: Add DDP offload control path
To:     Shai Malin <smalin@marvell.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
Cc:     Yoray Zack <yorayz@mellanox.com>,
        "yorayz@nvidia.com" <yorayz@nvidia.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "benishay@nvidia.com" <benishay@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "ogerlitz@nvidia.com" <ogerlitz@nvidia.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-6-borisp@mellanox.com>
 <PH0PR18MB3845486FF240614CA08E7B4CCCCB0@PH0PR18MB3845.namprd18.prod.outlook.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <0a272589-940c-6488-9cb9-1833400f38b3@gmail.com>
Date:   Mon, 14 Dec 2020 08:38:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <PH0PR18MB3845486FF240614CA08E7B4CCCCB0@PH0PR18MB3845.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2020 19:15, Shai Malin wrote:
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index c0c33320fe65..ef96e4a02bbd 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -14,6 +14,7 @@
>  #include <linux/blk-mq.h>
>  #include <crypto/hash.h>
>  #include <net/busy_poll.h>
> +#include <net/tcp_ddp.h>
>  
>  #include "nvme.h"
>  #include "fabrics.h"
> @@ -62,6 +63,7 @@ enum nvme_tcp_queue_flags {
>  	NVME_TCP_Q_ALLOCATED	= 0,
>  	NVME_TCP_Q_LIVE		= 1,
>  	NVME_TCP_Q_POLLING	= 2,
> +	NVME_TCP_Q_OFFLOADS     = 3,
>  };
> 
> The same comment from the previous version - we are concerned that perhaps 
> the generic term "offload" for both the transport type (for the Marvell work) 
> and for the DDP and CRC offload queue (for the Mellanox work) may be 
> misleading and confusing to developers and to users.
> 
> As suggested by Sagi, we can call this NVME_TCP_Q_DDP. 
> 

While I don't mind changing the naming here. I wonder  why not call the
toe you use TOE and not TCP_OFFLOAD, and then offload is free for this?

Moreover, the most common use of offload in the kernel is for partial offloads
like this one, and not for full offloads (such as toe).
