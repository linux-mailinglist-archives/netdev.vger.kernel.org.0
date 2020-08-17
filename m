Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7682474A6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392125AbgHQTMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392111AbgHQTMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:12:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53445C061389;
        Mon, 17 Aug 2020 12:12:44 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o23so19144437ejr.1;
        Mon, 17 Aug 2020 12:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9J/lb0D5NJq8nshus3wpAPKv03Iej7G41qLDnaD7ZZE=;
        b=Ri2UXMCbnZeD8m8+99fYky9iiUcTrd0Hp4jVgZsnKftGQBH+Zd//2i2nx/pL9BzQlk
         IklaxJZuXiu6M6v+In7dXWZqgnG1eaaaqdFC8Iw3m1CztCGA4ddWEIvpYqNXJjwhM/+/
         TjCZxPZftYk/OytPVS7SyJXJeHfxRlK4darZMN3rAQLRfnEw5DIH2aq+LDGmiVb/ovqV
         YUbsNCxtO4PT58SemWnGgWrKj1MgT1ALGKAv/1awRMAB38oyIjhQhB2VI/2osEKly2re
         bul7tvYLdb0lLs0mXm6Tu6n0NsJpIZNdKJ9yPyVx7OYJQ6mPNIxTKf9BM5yT0wkmH0Ze
         nhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9J/lb0D5NJq8nshus3wpAPKv03Iej7G41qLDnaD7ZZE=;
        b=J3FhOBZBI14Fhb7M36S7gLLMkJb7ETocqM9L9jo5GdiXqJKPWqiET1GJOoNUI06QHK
         oBA3I8siLzjg8epcR3N6tTYwEiSSN+uJCUb45H7WV78Xic6Pd3FZZadsE3ewzwqdTwmj
         gasVEJHYv35xdfpbkNjXP+6k9PoLTGZluyI/JSg3koJX/P2zER67ujKMMd8BnSO6hAhG
         0UFglElv0O5fDpGRKn3J2+LDxGUDSezp5zWPZcjsVCxDIdt0Wg/jZGH9tFJVqK+3QC4R
         CteWgqiLjh9HnnmjI4TrT0PNpRxfzBpPrKTWRfFwCOlHjZj7u5U8SJXhtwBCkeeBEVes
         5mTg==
X-Gm-Message-State: AOAM531/qZuqG3ZFqYO2cv+aWsgkJqns/EOJoWwAgVO1WfP2p0SnI97P
        Mn1MzWW4A2ASFCVojOZJPdKTYxXEFkY=
X-Google-Smtp-Source: ABdhPJzTXFH0us7zoscbydo84QvxmlbcWul7hiWHvIo6cki61uxsT1X/URq1+y4jFS25bB5o4POL4Q==
X-Received: by 2002:a17:907:372:: with SMTP id rs18mr16048513ejb.146.1597691562752;
        Mon, 17 Aug 2020 12:12:42 -0700 (PDT)
Received: from debian64.daheim (pd9e293c0.dip0.t-ipconnect.de. [217.226.147.192])
        by smtp.gmail.com with ESMTPSA id a23sm13944927eds.37.2020.08.17.12.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:12:41 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k7kYj-00065j-2d; Mon, 17 Aug 2020 21:12:41 +0200
Subject: Re: [PATCH 03/16] wireless: ath: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.cryptic@gmail.com>, kvalo@codeaurora.org,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
 <20200817090637.26887-4-allen.cryptic@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <e22d8564-b4de-d8a2-e607-d6776db7b38b@gmail.com>
Date:   Mon, 17 Aug 2020 21:12:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817090637.26887-4-allen.cryptic@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

looking at the other patches in this series, I think this patch's 
subject "ath:" tag was supposed to be "carl9170:"?

(so the full subject is:
"wireless: carl9170: convert tasklets to use new tasklet_setup() API")

On 2020-08-17 11:06, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
Seems to work.

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/usb.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
> index ead79335823a..e4eb666c6eea 100644
> --- a/drivers/net/wireless/ath/carl9170/usb.c
> +++ b/drivers/net/wireless/ath/carl9170/usb.c
> @@ -377,9 +377,9 @@ void carl9170_usb_handle_tx_err(struct ar9170 *ar)
>   	}
>   }
>   
> -static void carl9170_usb_tasklet(unsigned long data)
> +static void carl9170_usb_tasklet(struct tasklet_struct *t)
>   {
> -	struct ar9170 *ar = (struct ar9170 *) data;
> +	struct ar9170 *ar = from_tasklet(ar, t, usb_tasklet);
>   
>   	if (!IS_INITIALIZED(ar))
>   		return;
> @@ -1082,8 +1082,7 @@ static int carl9170_usb_probe(struct usb_interface *intf,
>   	init_completion(&ar->cmd_wait);
>   	init_completion(&ar->fw_boot_wait);
>   	init_completion(&ar->fw_load_wait);
> -	tasklet_init(&ar->usb_tasklet, carl9170_usb_tasklet,
> -		     (unsigned long)ar);
> +	tasklet_setup(&ar->usb_tasklet, carl9170_usb_tasklet);
>   
>   	atomic_set(&ar->tx_cmd_urbs, 0);
>   	atomic_set(&ar->tx_anch_urbs, 0);
> 

