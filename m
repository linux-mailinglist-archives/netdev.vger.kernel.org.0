Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93310A28EA
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfH2V0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:26:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45852 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbfH2V0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:26:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so2254995pgp.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=GWW8DLxytIiCzhfA2BJxy+/D87jQXnHMbpMx/kGEXeU=;
        b=SZGvIs6E9TskHAVTLovdtnJ3wivDhHJPTxAcX2m2/O1Wt5ZB7JkMLW3C/v0a5DlJxr
         kjzCc0WgKXUVgNOgxXOQ7+n9XK0EqyIfi5o5jL95OK457mBy/xfRT7k+/qgv7XA0NeDb
         y7kSQTHOux1UP/gcY1ok2//XPPs84aEiEh1sH34eRHiUcUxmdrxWoX9OlPh6xLAqUJ8+
         9EengEykizGIUvi9nrVmOWE0jEoiC7Hb5vnkHtIX4Tc989bmaW53jkxPE7c7C5hSquY/
         8uz2XnV9v7Rv7MZg+uWTtl6GYByJIbw4MFDqFTYOEJK5is/VxOuY3EEc38vbskFjl2I2
         PDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GWW8DLxytIiCzhfA2BJxy+/D87jQXnHMbpMx/kGEXeU=;
        b=k060Shh/bjx3Zd+7n7xgm5vERn32Z+KuRpwTZYZQ2mjS44fAcjH03LFqO6QcUXqXH8
         sc1bY07NYP4mTvN6/52/sO6OIamLQGAqpBwbnO13wklMfdO4EBZmkNtOUlN3uUfB25qX
         W+vI0qjhwRA3/VOIoqzmrZ3O4YqSmM5m2t+tvRCGJG2YHsZgBw/YjJ3oUduC33eLgl6A
         gdf/Q8XOM+vwUYO/DpNBjaNwDyCBeVMzWBsUWjVQktpg7kbBhhWKguh4xBJGk+rD5akL
         DCzZcoLCEm+9Hg4Bo1KjZFrWqwwyfrFVIW8S5gfV1CvQUBz796m2m7FHWZzymiJ/YV3d
         7jOA==
X-Gm-Message-State: APjAAAVWUsb5L5HlPYl3kQPK3IOhIu/kyE4SV107us9y3ZdAIds7Lrfy
        n6fihbYsBKF+t15a92dtxkyA0VBE/Ws=
X-Google-Smtp-Source: APXvYqzgsuapLgy6KYdw7jRoVvKrtPqUVQIKBUbs4nUAFFRMYUPAiPFENsbmkHB/pRiOPNxRcrVZ9Q==
X-Received: by 2002:a63:4a51:: with SMTP id j17mr10144639pgl.284.1567113998895;
        Thu, 29 Aug 2019 14:26:38 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id v67sm6499918pfb.45.2019.08.29.14.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 14:26:38 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/15] MIPS: SGI-IP27: restructure ioc3
 register access
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
 <20190829155014.9229-3-tbogendoerfer@suse.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d9192f8c-a8a6-86aa-62eb-91826163bb43@pensando.io>
Date:   Thu, 29 Aug 2019 14:26:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829155014.9229-3-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 8:50 AM, Thomas Bogendoerfer wrote:
> Break up the big ioc3 register struct into functional pieces to
> make use in sub-function drivers more straightforward. And while
> doing that get rid of all volatile access by using readX/writeX.
>
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---

> diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
> index 6bdb48d41276..5886bee89d06 100644
> --- a/arch/mips/sgi-ip27/ip27-console.c
> +++ b/arch/mips/sgi-ip27/ip27-console.c
> @@ -35,6 +35,7 @@ void prom_putchar(char c)
>   {
>   	struct ioc3_uartregs *uart = console_uart();
>   
> -	while ((uart->iu_lsr & 0x20) == 0);
> -	uart->iu_thr = c;
> +	while ((readb(&uart->iu_lsr) & 0x20) == 0)
> +		;
> +	writeb(c, &uart->iu_thr);
>   }

Is it ever possible to never see your bit get set?
Instead of a tight forever spin, you might add a short delay and a retry 
limit.

I see this in several other times in the following code as well.  It 
might be interesting to see how many times through and perhaps how many 
usecs are normally spent in these loops.

Not a binding request, just a thought...

sln


