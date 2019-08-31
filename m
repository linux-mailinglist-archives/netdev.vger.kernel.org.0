Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58144A45AA
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 20:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfHaSCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 14:02:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44652 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbfHaSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 14:02:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so4769778plr.11;
        Sat, 31 Aug 2019 11:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5nRMB4IW4JokHlubGZbzIicn3I6oGCg/ecnx4Zzd8hA=;
        b=kx5tTAva1/o/PL169ZPjnoyZD+Ansp+1mDodo04gQgShU0TCdcNZeOtUPK8+fZVhL5
         lew9KtupKB9J0+INUGzw38Vf92JsoEUQ2O8fZamM0DYkxK9IANZyC1hdUhlOOqtZhVsZ
         M0HSVCJZNNH3QU/4dNl+iV8TEqYfkFq8ttTN0RmGw+UuoRVqtkIp1BdTGqW8Lf6ONbn+
         iYAAnBb+t72WurZSBl7N6pyI7EzvAE4Y4yT4nokOzak/s5SZTqg5e8/FvWKXSI9ufl7v
         FnmclSqtXjwwLEfELSnCmsks1svDXwMJOZfM/klrdezoRhK5HnBNVDFBFruS2D0FRNoe
         mI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5nRMB4IW4JokHlubGZbzIicn3I6oGCg/ecnx4Zzd8hA=;
        b=exYRsJf42zZBAKzykyv9YiFYbwhKnPLl62XenWBmg7NcQCq6waRPeM/ijHcvYrVgXw
         hqstKx+b95sPcH/jofcN/qlSIHOm3EnZ7dWk8QC9WJD+AMnWTRcR8qVrUnfjwmx4Rb96
         SUKgU8nUqsrudNfMpHJfSXN5NoDKLcq9CiYRNlZIS8iWiP5MtJheHx/57O2VJ28XYdO1
         Znt5HVixbWWaH2W9+KnJ71SlurS2yAELzPbWV4cnkBT+pZ73Enk+mmKYYEOAxKyrodxE
         r52Rlg6PYkplukXdkUbIqnRafAubG6KR38TogOYt2UzTKrYLfIJn/11d42KRoO8tUpax
         5c9g==
X-Gm-Message-State: APjAAAXhne/epR6LAvB0Q6yAa5I7f+T2YfiDohGOv1/1stbXnoMy95qB
        Wgxm3WcX4d9jlCwxmsNRsEU=
X-Google-Smtp-Source: APXvYqzXNrh3ap8PtFUb7zdMAzzda5/eC6jYpkT/S06cjKI69hbYwJ0L/MpexlnS1Vx7pc8YHhxmfQ==
X-Received: by 2002:a17:902:f204:: with SMTP id gn4mr21912191plb.23.1567274542452;
        Sat, 31 Aug 2019 11:02:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r23sm16174082pfg.10.2019.08.31.11.02.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 11:02:21 -0700 (PDT)
Date:   Sat, 31 Aug 2019 11:02:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hui Peng <benquike@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix a NULL-ptr-deref bug in
 ath6kl_usb_alloc_urb_from_pipe
Message-ID: <20190831180219.GA20860@roeck-us.net>
References: <20190804002905.11292-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804002905.11292-1-benquike@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 08:29:04PM -0400, Hui Peng wrote:
> The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath6kl_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath6kl_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> 	endpoint = &iface_desc->endpoint[i].desc;
> 
> 	// get the address from endpoint descriptor
> 	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
> 						endpoint->bEndpointAddress,
> 						&urbcount);
> 	......
> 	// select the pipe object
> 	pipe = &ar_usb->pipes[pipe_num];
> 
> 	// initialize the ar_usb field
> 	pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
> `ath6kl_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref.
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>

I don't see this patch in the upstream kernel or in -next.

At the same time, it is supposed to fix CVE-2019-15098, which has
a CVSS v2.0 score of 7.8 (high).

Is this patch going to be applied to the upstream kernel ?  If not,
are there reasons to believe that the vulnerability is not as severe
as its CVSS score indicates ?

Thanks,
Guenter

> ---
>  drivers/net/wireless/ath/ath6kl/usb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
> index 4defb7a0330f..53b66e9434c9 100644
> --- a/drivers/net/wireless/ath/ath6kl/usb.c
> +++ b/drivers/net/wireless/ath/ath6kl/usb.c
> @@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pipe *pipe)
>  	struct ath6kl_urb_context *urb_context = NULL;
>  	unsigned long flags;
>  
> +	/* bail if this pipe is not initialized */
> +	if (!pipe->ar_usb)
> +		return NULL;
> +
>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>  	if (!list_empty(&pipe->urb_list_head)) {
>  		urb_context =
> @@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(struct ath6kl_usb_pipe *pipe,
>  {
>  	unsigned long flags;
>  
> +	/* bail if this pipe is not initialized */
> +	if (!pipe->ar_usb)
> +		return;
> +
>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>  	pipe->urb_cnt++;
>  
> -- 
> 2.22.0
> 
