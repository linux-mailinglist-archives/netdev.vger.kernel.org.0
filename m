Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE99242C22
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgHLPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:23:08 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCF5C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:23:08 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k18so1186811pfp.7
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P4Rk0jzlUrubpXjvfrJ7oNqhqPh1Usi147yg9RhsvIw=;
        b=QrvJTyRAvs0fhbeiPZL5apZyahOLZl/UJvMArEmhUdbASccA3lU1UJ2BdvcnuNNK25
         NAbws2ZRMlU4pEl9luOjWmVTxdxMQUZIDYpZGBzk4bl9eXbSvgYk+kzirfLAwlatMh9o
         k1yiNqq0ykYVuGkcKgQvKpeI9MiGVVH68tOmVagaUrgeF/ga8Txpk2cKF2xRdZRW1k5G
         kwic4ILidDDBPPHUpc8cdodcQSAS/3GL21kpGAsTKihJm4ZbmJyYsvAshxPnW09efJy6
         DaCdzca/tiu+JpBJCCyg12vDFbVMOORuPULY0QWRZDOszXZH8x12V5YuN9QX3AwnLrGN
         XQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=P4Rk0jzlUrubpXjvfrJ7oNqhqPh1Usi147yg9RhsvIw=;
        b=YP8F6SxrJHEfj2voflCByJ5qRfIOvzmQDWqrOPVLKvjm4NPmUyDVIwrKApulFxFscG
         psYdIztZyunknZlvPj/MLcV8h1TWf8LYQV+cbYo2fmHm+kLB67J6daAPSEhvAA7hFZIb
         SW/sBB9wGA1BQInfDwPQVVy0oteyOqDheJey878UE6URYOkzL9JQGM+1NvBK1cEWaYiv
         U6063MYYuVltlK9vsQrod/u5IgJLdByWDlPSX0yOo9/nt44oWiuZMgxW0KjpjE82vSSn
         dUc9xuNn5tA27B332ptPIPhdprY0l9jmiUKw3DzJO7/tgbrBqqvQYwKPWAnjpL9Go8gU
         b+LQ==
X-Gm-Message-State: AOAM530M7HB+Yq36zx0fkJAt8qmjE5o3XGt4vwtvt59E4IsdD1m3G8Jd
        bw9enFQIiM3rVMaetdKU1Ic=
X-Google-Smtp-Source: ABdhPJzq117PsOGTj9KBNQzvuD8HHS1V5G+78TcFkjbHPE2jnF/z3k3qfZVTUDpm3zceOKxxlUOczw==
X-Received: by 2002:a62:158e:: with SMTP id 136mr111320pfv.36.1597245787519;
        Wed, 12 Aug 2020 08:23:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b20sm2823837pfo.88.2020.08.12.08.23.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Aug 2020 08:23:06 -0700 (PDT)
Date:   Wed, 12 Aug 2020 08:23:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix ef100 design-param checking
Message-ID: <20200812152305.GA171411@roeck-us.net>
References: <311d8274-9c6f-4614-552f-b1d3da64f368@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311d8274-9c6f-4614-552f-b1d3da64f368@solarflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 10:32:49AM +0100, Edward Cree wrote:
> The handling of the RXQ/TXQ size granularity design-params had two
>  problems: it had a 64-bit divide that didn't build on 32-bit platforms,
>  and it could divide by zero if the NIC supplied 0 as the value of the
>  design-param.  Fix both by checking for 0 and for a granularity bigger
>  than our min-size; if the granularity <= EFX_MIN_DMAQ_SIZE then it fits
>  in 32 bits, so we can cast it to u32 for the divide.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> I've only build-tested this, and then only on 64-bit, since our lab's
>  cooling system can't cope with the heatwave and we keep having to shut
>  everything down :(
> 
>  drivers/net/ethernet/sfc/ef100_nic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 36598d0542ed..206d70f9d95b 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -979,7 +979,8 @@ static int ef100_process_design_param(struct efx_nic *efx,
>  		 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
>  		 * This is very unlikely to fail.
>  		 */
> -		if (EFX_MIN_DMAQ_SIZE % reader->value) {
> +		if (!reader->value || reader->value > EFX_MIN_DMAQ_SIZE ||
> +		    EFX_MIN_DMAQ_SIZE % (u32)reader->value) {
>  			netif_err(efx, probe, efx->net_dev,
>  				  "%s size granularity is %llu, can't guarantee safety\n",
>  				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
