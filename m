Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF41B78CE
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgDXPFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726717AbgDXPFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:05:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2523C09B045;
        Fri, 24 Apr 2020 08:05:37 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r14so4928483pfg.2;
        Fri, 24 Apr 2020 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d4gGd17nKXAZGsG4iVsACxdSRpoMmpH7XJzq4FM92WM=;
        b=n4peOn/s/AQG8koZqpSrfBKGJB1DH60y3deG8H5m2P1g+SuMSiEtld5J5vGAWrpX0P
         /BUSssIG+0rGdcPoF7u9ME1/E966Jawd9DhaaeB9DFgQJPdWlXJW0VRD0ptv4yQUNbs6
         1gv82m6FH6lxsMio7sDaVO6b7Oa02eHBW5Ey5HPBxq8EygtY2sCPUhExZPSFmfT1QtJf
         IfY/9dlNW2HJUowUcrbDkjBpwrseWQBFA0pksskUfQKy+N7yllXmZWGJnGRWAgPOrg2O
         XFl6L3WIocCB/mPND6GqF2jdJmXMj/KWzUv/XNsfQOGuPq+nCp0H5BSJPjdIpp+Aidy5
         0mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d4gGd17nKXAZGsG4iVsACxdSRpoMmpH7XJzq4FM92WM=;
        b=ZsWWIO9vSMWYborJp5iyZflbYN2iCY7LJIhIPOKP45nCQJlGWZsp09TBUfzCOP3/Qb
         KSRRzylMq4SopQ0ZLzOLiJ0L8CdSw7GuzSAZrLOZrN3XWN7cDaKV0YlIvlYw3VenLBlD
         8bRPfshiIe2sykjv41yjZezomSB/G4sIhdH0iHEFBDyXXqWAGM/of5vt3tlEou7+zbR8
         qrqJWJjCUrdXASA6HjTcJI7nEbN90Q4jztz5S17p2MA4W1UHZgO/0GMduOu/EKE2dDrq
         evOOhaiObqVkf1xQbL6dhfgqUZYZSGWlOuakDjhA3pvBinYaRAuC/4WS08Ube3faQLXf
         nPGQ==
X-Gm-Message-State: AGi0PuYNr37SqLE5XX6poIbgChOP3vtP2ZVXkx3lce7wVsYME/v82bJg
        QG11P/BqEz05rVxio8RrQIq+aPen
X-Google-Smtp-Source: APiQypKcZXLckuTzIO760BvGIrtUlZK84e+1m4OPJqIJ8UnZ6DtIh82hQIS4MhMMyJvGV1m8X2uTUQ==
X-Received: by 2002:a63:2143:: with SMTP id s3mr9510994pgm.20.1587740736829;
        Fri, 24 Apr 2020 08:05:36 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y24sm6058461pfn.211.2020.04.24.08.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 08:05:35 -0700 (PDT)
Subject: Re: [PATCH] net: openvswitch: use do_div() for 64-by-32 divisions:
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <20200424121051.5056-1-geert@linux-m68k.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d2c14a2d-4e7b-d36a-be90-e987b1ea6183@gmail.com>
Date:   Fri, 24 Apr 2020 08:05:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424121051.5056-1-geert@linux-m68k.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/24/20 5:10 AM, Geert Uytterhoeven wrote:
> On 32-bit architectures (e.g. m68k):
> 
>     ERROR: modpost: "__udivdi3" [net/openvswitch/openvswitch.ko] undefined!
>     ERROR: modpost: "__divdi3" [net/openvswitch/openvswitch.ko] undefined!
> 
> Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
> Reported-by: noreply@ellerman.id.au
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  net/openvswitch/meter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 915f31123f235c03..3498a5ab092ab2b8 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -393,7 +393,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
>  		 * Start with a full bucket.
>  		 */
>  		band->bucket = (band->burst_size + band->rate) * 1000ULL;
> -		band_max_delta_t = band->bucket / band->rate;
> +		band_max_delta_t = do_div(band->bucket, band->rate);
>  		if (band_max_delta_t > meter->max_delta_t)
>  			meter->max_delta_t = band_max_delta_t;
>  		band++;
> 

This is fascinating... Have you tested this patch ?

Please double check what do_div() return value is supposed to be !

Thanks.
