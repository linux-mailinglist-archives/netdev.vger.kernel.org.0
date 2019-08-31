Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04BA4659
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfHaVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 17:31:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42317 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHaVbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 17:31:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so5278054pgb.9;
        Sat, 31 Aug 2019 14:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+MuizemRZBK7y4EPhOqkcNh+j3OitGqWAcLb/tYmDlY=;
        b=TYMs+h7XCkfnxW83esvEWCGtDELyZlP8PT7UFYEOYvWJlufam6JCZZ41EigPpYgj+H
         Rzh63zgCszHOICTd4uVZqVWkungT0vepiqQQCl/nQTxWDiCt9BMmgoAYswM889QuOJb+
         svvv2J3bs3yJ1CrrHkrxYcoKmJvq5lpybFwgjMLKnn3pjiMp0FMTLYxFrtkq7QxjUTeE
         uGsRPPmXTJ8McFUtRlfCx/jaLJi8/7IdMPKMn0vbAS4V+TCBsF0en1RJQgai/nipxFjQ
         hQRXoJPP6DXGDl0ruz9HqR/X7zg54oZmH3WmW3yzLzWnoWYqcNhVtu40J6kn1bf8PSzG
         5L7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+MuizemRZBK7y4EPhOqkcNh+j3OitGqWAcLb/tYmDlY=;
        b=Mg+oYTDz6pQ3c4fbYDUjlhA1ktwqKKZz1XK5IrXcDYlfvS+ZIBRy6x0KdS/QAsMb3F
         TGJZr77VjoBO2rks556penxCByCwli6WLacwtF8DzC9DWN5NeyJBZBVTr+b1zbN41peL
         u031cy8MFve32hgG6Otsc4rSwFAAhX7lSxAtt3DPajKoF5lECyHGvynORiSQOi9SW3Nl
         TfL5gWI9S2p3acr3xE0sT32zlXsWeR+690yVXnRLeKaBgL4ZwsRJimFBD9TCAYGtKgYk
         ev1TRVrxdm2F3pLTM/l7AzHxF+hhc2+4MfOZ2qnN8Wp+QU4WMH3VQEjkHuYkfo5dy3+T
         jfyw==
X-Gm-Message-State: APjAAAUQjF4W2/ngDm2hXBe5i+0uBIxsTKxheDn1XZqBuHD31uusuWwu
        yZwD/j9av5BBkS67Z2D8UvfUro3+
X-Google-Smtp-Source: APXvYqx6dkz/egpBz/ct/gn7oOQDRpCEXLMhME5Je/qRTDtWscVFP6YpGe7O1hPZaouNPMMKrHAggg==
X-Received: by 2002:aa7:908b:: with SMTP id i11mr24179327pfa.199.1567287101743;
        Sat, 31 Aug 2019 14:31:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g14sm11062488pfb.150.2019.08.31.14.31.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 14:31:40 -0700 (PDT)
Date:   Sat, 31 Aug 2019 14:31:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hui Peng <benquike@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
Message-ID: <20190831213139.GA32507@roeck-us.net>
References: <20190804003101.11541-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804003101.11541-1-benquike@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Aug 03, 2019 at 08:31:01PM -0400, Hui Peng wrote:
> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath10k_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath10k_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>         endpoint = &iface_desc->endpoint[i].desc;
> 
>         // get the address from endpoint descriptor
>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>                                                 endpoint->bEndpointAddress,
>                                                 &urbcount);
>         ......
>         // select the pipe object
>         pipe = &ar_usb->pipes[pipe_num];
> 
>         // initialize the ar_usb field
>         pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
> `ath10k_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref.
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>

This patch fixes CVE-2019-15099, which has CVSS scores of 7.5 (CVSS 3.0)
and 7.8 (CVSS 2.0). Yet, I don't find it in the upstream kernel or in Linux
next.

Is the patch going to be applied to the upstream kernel anytime soon ? If
not, is there reason to believe that its severity may not be as high as the
CVSS score indicates ?

Thanks,
Guenter

> ---
>  drivers/net/wireless/ath/ath10k/usb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
> index e1420f67f776..14d86627b47f 100644
> --- a/drivers/net/wireless/ath/ath10k/usb.c
> +++ b/drivers/net/wireless/ath/ath10k/usb.c
> @@ -38,6 +38,10 @@ ath10k_usb_alloc_urb_from_pipe(struct ath10k_usb_pipe *pipe)
>  	struct ath10k_urb_context *urb_context = NULL;
>  	unsigned long flags;
>  
> +	/* bail if this pipe is not initialized */
> +	if (!pipe->ar_usb)
> +		return NULL;
> +
>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>  	if (!list_empty(&pipe->urb_list_head)) {
>  		urb_context = list_first_entry(&pipe->urb_list_head,
> @@ -55,6 +59,10 @@ static void ath10k_usb_free_urb_to_pipe(struct ath10k_usb_pipe *pipe,
>  {
>  	unsigned long flags;
>  
> +	/* bail if this pipe is not initialized */
> +	if (!pipe->ar_usb)
> +		return NULL;
> +
>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>  
>  	pipe->urb_cnt++;
> -- 
> 2.22.0
> 
