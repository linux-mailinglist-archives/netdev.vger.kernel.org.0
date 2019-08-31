Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20ADDA45C2
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 20:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfHaSSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 14:18:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34623 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfHaSSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 14:18:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so6626038pfp.1;
        Sat, 31 Aug 2019 11:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iy7rBemvXpB/a7jfondm/RaUeP0fWIvhcgopOT0OvTo=;
        b=li0oxTjexSJqivDxNVCqnqKNsc8bi2X+9iOdosxLVCdzGUKmgs9vQbKHLu6J7/lll3
         GHlWJvHq4z8aVxQ+iQ27QtS2yZvrXEYN+zxbvntfvnpvKiKKNtBcXhbRL8xQ1yE4QUG8
         ctG9f/UEllWDOGmFAagUG3M+wTo1gRCnB0UrcbdrGufPYj23bYOniyMKAus6+ysGI++Q
         6gEzcGlxnVexJqTd1kUdlELmlmKQX8WcvDTwLvKBIqlUeTU/S25dvq2Z7rpZQdCTYex/
         tRH7xCoSSVf1GNpIqFKzgJRbn54LOQfBPbDVJay9USD5NH6I9q3zs2CTi8Bby6inSbj+
         VRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iy7rBemvXpB/a7jfondm/RaUeP0fWIvhcgopOT0OvTo=;
        b=oefCHZ+sLbheO6YsyA0JnhTYFZIiXac6zpQ7+AQ0hRwYYuBopeRxVATXCQjHeloEMi
         wjTr1P0nadVni5kWtO3aAxfc1T/8PwR+IZfvuLS/xdV1i4vayFdu71LHVEu+YQifmCsl
         AgMqKEBL/7jOczQbgW/EXvu3VdNbQpWLPKwxsn5QKoD4QB3AGSX6YqaW42LDQ0GC5Y25
         iPNKBW1K3rlKdR3wHGkvClrsXs15Rdp8zqIVNvK97c4sk5fNB+LzqG+SfficK6zh3Nmg
         erVuoPpjaEA4hv4m/VuTCsn88QGoZ0YPK6P2J50LRL71oACUkWawYI8PWxo3dEUh9xKt
         JNjQ==
X-Gm-Message-State: APjAAAUVXrznkIaBmbgxmCqxTFvGuR7Q+kYoHwFUT2FGpnqIklI6a7f6
        YURc+Vjk4dtzV5XKtQuyvkM=
X-Google-Smtp-Source: APXvYqyXHuQTJdiZGadL81H51xdNORimQObj3fpZ5wUeNpOc2l2gyOCjz/7caw/tVM4bhNyyAvDV8g==
X-Received: by 2002:a63:10a:: with SMTP id 10mr18413865pgb.281.1567275534426;
        Sat, 31 Aug 2019 11:18:54 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b126sm11102824pfb.110.2019.08.31.11.18.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 11:18:53 -0700 (PDT)
Date:   Sat, 31 Aug 2019 11:18:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hui Peng <benquike@gmail.com>
Cc:     security@kernel.org, Mathias Payer <mathias.payer@nebelwelt.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
Message-ID: <20190831181852.GA22160@roeck-us.net>
References: <20190819220230.10597-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819220230.10597-1-benquike@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
> `dev` (struct rsi_91x_usbdev *) field of adapter
> (struct rsi_91x_usbdev *) is allocated  and initialized in
> `rsi_init_usb_interface`. If any error is detected in information
> read from the device side,  `rsi_init_usb_interface` will be
> freed. However, in the higher level error handling code in
> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
> again, in which `dev` will be freed again, resulting double free.
> 
> This patch fixes the double free by removing the free operation on
> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
> used in `rsi_disconnect`, in that code path, the `dev` field is not
>  (and thus needs to be) freed.
> 
> This bug was found in v4.19, but is also present in the latest version
> of kernel.
> 
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Signed-off-by: Hui Peng <benquike@gmail.com>

FWIW:

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).

Are there any plans to apply this patch to the upstream kernel anytime
soon ? If not, are there reasons to believe that the problem is not as
severe as its CVSS score may indicate ?

Thanks,
Guenter

> ---
>  drivers/net/wireless/rsi/rsi_91x_usb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
> index c0a163e40402..ac917227f708 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
> @@ -640,7 +640,6 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
>  	kfree(rsi_dev->tx_buffer);
>  
>  fail_eps:
> -	kfree(rsi_dev);
>  
>  	return status;
>  }
> -- 
> 2.22.1
> 
