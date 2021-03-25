Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6770D348DE7
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCYKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhCYKXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:23:10 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54226C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:23:10 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id a8so1564788oic.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cfmttfuVk2hkfILwtDSnYCIXKWn/ddSmsi+3KgyUnLo=;
        b=EgyMuDhd7X3kfbCqwXooUM1b31jKURIZIpuoztag9g7PoETnjHn+w8YCa/qGvuHRDL
         AiQfnZlm7YybIb7EL3yuParlfwoLEqiesrYFPY8u7gYhqQXmmb1zPoyr+m7OiR0sUhFn
         q50FccYFgzChOSkVAAZifl730Oj8mznYJnQqwXySXdxyXvNsfWJrAbkRock3dUbC2vss
         jO8U8m8wWv+hvu+GYnLoqvS5Z890c/dbSvpb3tu6BzcPmAR2sPGvXv54Gwosm+yDnnzK
         qI6wdHfnkEDtlc6R9dCqSxuzrROTyLTDGzQIAgRX2ecn3pEQTbAgYwkCDvLGRI/Rxf21
         AFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cfmttfuVk2hkfILwtDSnYCIXKWn/ddSmsi+3KgyUnLo=;
        b=U78uVVJLLdQHUA/QTs0BsBE1fMoIpvIG3PkCa0IAwDLaf7iFXzHw+FBqpY1Es2Ivdt
         ZZ6EQYWGC0f+WLRk6iGRhLaWePyIYQWtC9jSrTF6xSywOLU2TV3wIKzr5U+/fznNJrR8
         yMs2bIlQZa/ga+4Wv39xW9Gp3EOmEdyhMxodoexsa/kd5IyHd4cCN4RtwRNS+DDDx4BC
         TBJHG0EPFXFgUhcmoVuoF35R5fxw/hFOb2P9bmRRwp8iKaWVmYhaqFLNxoQ9VQkMwcqm
         nyADsZ34OMHVbNGIMWHu1ueKpnA5W4iH70Z8A13QShN7jqMOJorJlSq6KaOukS3fjPbe
         vfPw==
X-Gm-Message-State: AOAM532xhBniyePeOZXP0YOZfSC8p+ZTa3PHe8BduU/NGhGXQnsgXTW4
        0/+tbbGLPp0Q3WLDrFn7z4O6oiz5GfM=
X-Google-Smtp-Source: ABdhPJwI+26FVQntwv8ZFQaN8W5sgLOlQ6IRVLwQCopPk+/9MFqpjSSQawN5At2q/Q4GnZyXxaR9FQ==
X-Received: by 2002:a54:408a:: with SMTP id i10mr5599335oii.141.1616667789750;
        Thu, 25 Mar 2021 03:23:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f197sm1248894oob.38.2021.03.25.03.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 03:23:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Mar 2021 03:23:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64
 calcalation
Message-ID: <20210325102307.GA163632@roeck-us.net>
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323080229.28283-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:02:29PM +0800, Yangbo Lu wrote:
> Current calculation for diff of TMR_ADD register value may have
> 64-bit overflow in this code line, when long type scaled_ppm is
> large.
> 
> adj *= scaled_ppm;
> 
> This patch is to resolve it by using mul_u64_u64_div_u64().
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/ptp/ptp_qoriq.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> index 68beb1bd07c0..f7f220700cb5 100644
> --- a/drivers/ptp/ptp_qoriq.c
> +++ b/drivers/ptp/ptp_qoriq.c
> @@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  	tmr_add = ptp_qoriq->tmr_add;
>  	adj = tmr_add;
>  
> -	/* calculate diff as adj*(scaled_ppm/65536)/1000000
> -	 * and round() to the nearest integer
> +	/*
> +	 * Calculate diff and round() to the nearest integer
> +	 *
> +	 * diff = adj * (ppb / 1000000000)
> +	 *      = adj * scaled_ppm / 65536000000
>  	 */
> -	adj *= scaled_ppm;
> -	diff = div_u64(adj, 8000000);
> -	diff = (diff >> 13) + ((diff >> 12) & 1);
> +	diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);

mul_u64_u64_div_u64() is not exported. As result, every build with
CONFIG_PTP_1588_CLOCK_QORIQ=m (ie every allmodconfig build) fails with:

ERROR: modpost: "mul_u64_u64_div_u64" [drivers/ptp/ptp-qoriq.ko] undefined!

or a similar error.

Guenter
