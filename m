Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91549501B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346098AbiATO1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345906AbiATO1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:27:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1406DC061574;
        Thu, 20 Jan 2022 06:27:54 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id br17so22297185lfb.6;
        Thu, 20 Jan 2022 06:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cyvoMCv80wDsc8wkvJlV/oGl77HzpweZAfsKlFkUjNo=;
        b=pGd0rpB8v4HQoVTL2HRvdgEKPq6p6f5D4YRXtPtuwLhYlgUXv+w3MjyaEkttp1XH+D
         P+KZutwCeItzHnixPHrJxuWX9vy8Hn26lDQHzu7giJpY4qWgdJ1mG+bZ1XultoRRLsPp
         FHaWOqtE2Vdqdga7bi2dGrFCdNQ2bI2dYUkpiDwS7iYoInnqin3W7iaJ1F78iTX/WmZa
         nNsLNhu3P8BY6Dd/RTlKnkC8lum4kLE9lf9t8HbcpoFvrAenkSJqmj+ekYQiuxptWVSC
         RyViZ1jcG8fq+msp7J5P1kXKYfhAQ/JQnw7xE+twoSYRnGJVA+Jbw1w3ZLJV1bAqAYZm
         HquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cyvoMCv80wDsc8wkvJlV/oGl77HzpweZAfsKlFkUjNo=;
        b=FyRMAt0E+pFx93qqJQYChzI/irfx2KKIlDw9DrNawOaR0zJYLv+EWgLnVzhtDtqZly
         Su2dn4OTSPwsB5CxYyt+Kg5gQguoPBNzE8riIdiLc2VOX5HANZXuigESo0SRpuKbijTY
         WBzg6SHxj6y3sS99rnY4akySALk+g74yDQzbd7Bv3sKRvNxlHZ1UYgrdqiHIZ3/aj2fG
         KfjjxJ5HAcrzFMMpPuOlwIJVGt5NV6voobE+YqZVGC4UNnTCOut4L0KsGz103J4PBU/5
         FDzrP9aIkbMjLB0PtKrl7ReokOHnSS5+KM/3nL8hRzM5OLGA+VnfF0byRHsZXXhA/bFI
         P/gw==
X-Gm-Message-State: AOAM53335gR2uNnDU95DwipQO8sX/7q3Kmoem9tfiiB4JMf1i7VdryHk
        6zflkHLIaV6Tsg0D5F8mCxvX6a8FP9TA/Q==
X-Google-Smtp-Source: ABdhPJyJyeS9rCHqmFWnTJK7qiGZ9sRurUfaeSX/QytySHLMiR+cmx0w2YTc+zNy2iGtLCWalIDFcA==
X-Received: by 2002:a05:6512:4012:: with SMTP id br18mr32507876lfb.405.1642688872259;
        Thu, 20 Jan 2022 06:27:52 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id l5sm374597lfp.61.2022.01.20.06.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 06:27:51 -0800 (PST)
Message-ID: <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
Date:   Thu, 20 Jan 2022 17:27:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in
 peak_usb_create_dev
Content-Language: en-US
To:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120130605.55741-1-dzm91@hust.edu.cn>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220120130605.55741-1-dzm91@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

On 1/20/22 16:05, Dongliang Mu wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> The error handling code of peak_usb_create_dev forgets to reset the
> next_siblings of previous entry.
> 
> Fix this by nullifying the (dev->prev_siblings)->next_siblings in the
> error handling code.
> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> index b850ff8fe4bd..f858810221b6 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -894,6 +894,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
>   		dev->adapter->dev_free(dev);
>   
>   lbl_unregister_candev:
> +	/* remove the dangling pointer in next_siblings */
> +	if (dev->prev_siblings)
> +		(dev->prev_siblings)->next_siblings = NULL;
>   	unregister_candev(netdev);
>   
>   lbl_restore_intf_data:


Is this pointer used somewhere? I see, that couple of
struct peak_usb_adapter::dev_free() functions use it, but
peak_usb_disconnect() sets dev->next_siblings to NULL before calling 
->dev_free().

Do you have a calltrace or oops log?




With regards,
Pavel Skripkin
