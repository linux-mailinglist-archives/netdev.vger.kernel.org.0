Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5D376AED
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEGUAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhEGUAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 16:00:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29B3C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 12:58:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y26so11569172eds.4
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pHcAsX+yNsgg/QVrgCXo4QqNSJXjToCjiYQvKi7Hqq0=;
        b=eu32InUIgVw9UfDbvHAowGHa9ztg2Z3mKT9MuyWdN/Ybymgv2y7hczYeSADiCuQZ5a
         XFhRivRlov7iQt33nThvwn847lJb8HM3rpdlf+gLB0ABXo39XH8l5OWhrv5s8eDUqS65
         +kBjYJ+J7Zrm9zj8uRQcg4ZzYXUiA+0+cCAnpQ9Yr52cIvlnwKKM+mSwDbAfTXC8SbWN
         SXiQ+fPQ4oIG4rOzBfBRDo5nrHJWjG622ckWjKJpbUusEElvf2b6STJ/80+CEiw1aed0
         BAWysovA6bUw2iu7k0QaffLr07y1OsBVlkGcxQEe6Kv+4iP2ymyIVptjsYIZb9RzpO+J
         75lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pHcAsX+yNsgg/QVrgCXo4QqNSJXjToCjiYQvKi7Hqq0=;
        b=cFPkuuaBw5vda0rh0rS/ed5MvMPqLjy7thh+JKRaV4XzCZlAbss8iGfLwbIet6qAZK
         JONBAemvcdGGaplQ9v7387UHViSG3qgr7ToA9K8etJey/WfVu8bUHXGmwwwwszd6xq7t
         VTRPc+NjwX6Dkg5NiOuJcEZAA+fHu4lmQr/fJfFcPb1Bktc6IS8vi+zYHMOCPj7uIhfu
         biD4KefgmTHQQcjv84DVRLs019XS+vOqxTh+kUyLRgEhKCFtl5Bx7rbYG2RhM+Kd40HV
         B7HHQyu+ytwNBj5ziCXBltaMMpwUjq2IYpewo2w+zbyqOM3O6qNUFDi7bETh14NGlahH
         ttSQ==
X-Gm-Message-State: AOAM531JLMH4PbtU+0cSjEF137oWeXfbeSIEsyJIE16ehoNyrvvgr6Qn
        /sMO36AX7vtXNtmyoUMtLz0=
X-Google-Smtp-Source: ABdhPJxfZPfYh1UeKPBYvFutAA4/Xa5Zjmuw8BMjQB76OS9Jnm1swHA0g4xe2Y0k7EL/kh/TF1Idmw==
X-Received: by 2002:aa7:c382:: with SMTP id k2mr13765355edq.189.1620417536657;
        Fri, 07 May 2021 12:58:56 -0700 (PDT)
Received: from [192.168.0.129] ([82.77.79.69])
        by smtp.gmail.com with ESMTPSA id y20sm4894158edw.45.2021.05.07.12.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 12:58:56 -0700 (PDT)
Subject: Re: [net-next 4/6] enetc_ptp: support ptp virtual clock
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210507085756.20427-5-yangbo.lu@nxp.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <41018700-c51c-61ed-762d-01c08e7f13f5@gmail.com>
Date:   Fri, 7 May 2021 22:58:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210507085756.20427-5-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.05.2021 11:57, Yangbo Lu wrote:
> Add support for ptp virtual clock.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>   drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
> index bc594892507a..52de736df800 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
> @@ -10,6 +10,16 @@
>   int enetc_phc_index = -1;
>   EXPORT_SYMBOL(enetc_phc_index);
>   
> +struct ptp_vclock_cc ptp_qoriq_vclock_cc = {
^ static

> +	.cc.read		= ptp_qoriq_clock_read,
> +	.cc.mask		= CYCLECOUNTER_MASK(64),
> +	.cc.shift		= 28,
> +	.cc.mult		= (1 << 28),
> +	.refresh_interval	= (HZ * 60),
> +	.mult_num		= (1 << 6),
> +	.mult_dem		= 15625,
> +};
> +
