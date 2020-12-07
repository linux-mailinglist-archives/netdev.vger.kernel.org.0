Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B659B2D0FBB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgLGLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:52:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54117 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgLGLwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:52:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id k10so11222343wmi.3;
        Mon, 07 Dec 2020 03:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cq2jFqDwIfrHoFOscYqfVgmZg47FDTLhoPP6+XAE2X8=;
        b=cLnEBmmTvVorb3orFqYas6JyWceC4RR7/ZlQ839ETQcCGPCYl6a3aJ4tePmJHzNbj+
         uH5PKrfaqKTVwsVqejBAbnrl9iLPzAIxpFdec/vR1cHuugitT1yp3q63RiAik72ojjbG
         GZW2AZTm+7dgCPEeEB0htb7Nidz1yRBjw9wrk9HGgvj/+5KuxJLlYc+e7BILTpG9Qval
         ecE1iFgtgQa0oSEm0+Hxw9fx3P4P71j3RVy3vohd/u8todu6fPmAL+HLPbBfxtqteNSq
         BMTwBnH1gJpQrjG8tu3Z4I1qRubQ0cKPKcnqJpKShryJXQy3UR0/1wtGzhEQj/uQ9j72
         TY3g==
X-Gm-Message-State: AOAM532JhRUhBOyPVaHDQe/kp4LelQxBIqBF/ajEYN8JmPybh44WqO8d
        kBR5bUz3+CLnLyOVBXTVDgs=
X-Google-Smtp-Source: ABdhPJyggceK9kt1VON7RQM0pfXWP5R4vsXfjlVOjCpVKWVLZL7ubApXA+vTShbTcFEzdCKvK/06GQ==
X-Received: by 2002:a1c:3c09:: with SMTP id j9mr18047135wma.180.1607341910456;
        Mon, 07 Dec 2020 03:51:50 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id y2sm14522546wrn.31.2020.12.07.03.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:51:49 -0800 (PST)
Date:   Mon, 7 Dec 2020 12:51:47 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Change irqflags
Message-ID: <20201207115147.GA26206@kozik-lap>
References: <20201207113827.2902-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207113827.2902-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 08:38:27PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> change irqflags from IRQF_TRIGGER_HIGH to IRQF_TRIGGER_RISING for stable
> Samsung's nfc interrupt handling.

1. Describe in commit title/subject the change. Just a word "change irqflags" is
   not enough.

2. Describe in commit message what you are trying to fix. Before was not
   stable? The "for stable interrupt handling" is a little bit vauge.

3. This is contradictory to the bindings and current DTS. I think the
   driver should not force the specific trigger type because I could
   imagine some configuration that the actual interrupt to the CPU is
   routed differently.

   Instead, how about removing the trigger flags here and fixing the DTS
   and bindings example?

Best regards,
Krzysztof

> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index e1bdde105f24..016f6b6df849 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -213,7 +213,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  		return ret;
>  
>  	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
> -		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>  		S3FWRN5_I2C_DRIVER_NAME, phy);
>  	if (ret)
>  		s3fwrn5_remove(phy->common.ndev);
> -- 
> 2.17.1
> 
