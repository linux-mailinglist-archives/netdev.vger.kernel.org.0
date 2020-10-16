Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884C7290423
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404884AbgJPLfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394795AbgJPLfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 07:35:00 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372E7C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:35:00 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg9so1914144edb.12
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e+s7S2Soy2VIlYlckpEXgNYW3eigMt/yLBVs8eP/nRk=;
        b=CVsOyxLy4XlLVLz2sIrqOqFNpWyeK9w8ZnvLVmo8t0jvhzMmxmrGf58LyWCCIY+aEH
         uxeMZggVcWeLcujLyqr+Yv4nDsoxgavwu/AAj8nh1HrdS/LDGHY44s5s6FrPkH6s5ahM
         7qp6aUnvc/MENGLFM/Gg0Rz2u2gqsZ6oHeUdvhdg6yW2rfwh6/MwA/CnGb6dxpoxXyx2
         iC65BQ6rVyzT8kfxEAeKhgeoYEniBfKAb5Yi0LJId7CgoxIL2PeXRJSuvwRK3nToIsWm
         kl6smK0XXQI75qmqrazawbeRFtCkReeEc689Vft1nKeIvjhPwWNJXX2JMCuY7Hk/7sX5
         yr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e+s7S2Soy2VIlYlckpEXgNYW3eigMt/yLBVs8eP/nRk=;
        b=IwIyRwj/mArmspaV+1BnFYDGPebvNmdacBXs1VNKSm2uany5/8xL2i1LLDZ5WBiLqe
         zd31konJ6n7vBkN41qtNKP/d4AeZpUIezDNRO1dXG8CqAeaT0bClHgy3oy2sltaCWbRO
         nJ0R2PpNoVv2Q6YccxGMZ2HH5B9C/k6Op0sHS4DSqRoUKqb90npPoBLxAE7Z0IWvCY6K
         wOv7jvzj6VxPM/j5Jztgyzd8BnBBW2B8dE57ytCB76HAkMX2w9Mhw5l6AckxOpYgut3d
         e9m8nRYoZSPMjuK7xdx4SqCtHejaw2MiKtpBlPxerY0S8Y/s5Bo9XkaqMhGv4BTo3CBs
         e34g==
X-Gm-Message-State: AOAM530OHk2T52C8qyV5D0kCX8XYDXDV6rXDdpSnZepFjI44gP9SoasB
        +U2gLJ6g4giazlcmd4Bo3uApb3p9pzA=
X-Google-Smtp-Source: ABdhPJwedUSX/5d9gEq5MycCz4TKsyA7on+ZsOwtjCZ9zd4+Da+9/454EsM+F5IAVdxmKsoZhwhP3Q==
X-Received: by 2002:aa7:c2d8:: with SMTP id m24mr3433567edp.90.1602848098922;
        Fri, 16 Oct 2020 04:34:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:51b3:5acb:4e57:82fe? (p200300ea8f23280051b35acb4e5782fe.dip0.t-ipconnect.de. [2003:ea:8f23:2800:51b3:5acb:4e57:82fe])
        by smtp.googlemail.com with ESMTPSA id x22sm1372098ejc.102.2020.10.16.04.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 04:34:58 -0700 (PDT)
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
To:     Mike Galbraith <efault@gmx.de>, netdev <netdev@vger.kernel.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
Date:   Fri, 16 Oct 2020 13:34:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.10.2020 13:26, Mike Galbraith wrote:
> 
> When the kernel is built with PREEMPT_RT or booted with threadirqs,
> irqs are not disabled when rtl8169_interrupt() is called, inspiring
> __raise_softirq_irqoff() to gripe.  Use plain napi_schedule().
> 

I'm aware of the topic, but missing the benefits of the irqoff version
unconditionally doesn't seem to be the best option. See also:
https://lore.kernel.org/linux-arm-kernel/20201008162749.860521-1-john@metanate.com/
Needed is a function that dynamically picks the right version.

> Signed-off-by: Mike Galbraith <efault@gmx.de>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4573,7 +4573,7 @@ static irqreturn_t rtl8169_interrupt(int
>  	}
> 
>  	rtl_irq_disable(tp);
> -	napi_schedule_irqoff(&tp->napi);
> +	napi_schedule(&tp->napi);
>  out:
>  	rtl_ack_events(tp, status);
> 
> 

