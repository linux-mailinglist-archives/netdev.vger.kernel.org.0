Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54212D5539
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387811AbgLJITY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:19:24 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34540 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387534AbgLJITI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 03:19:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id g25so2289638wmh.1;
        Thu, 10 Dec 2020 00:18:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LQkGEYd3krV+Z3bgXSv+63USQGfgVXpXR+vwfP4BQCs=;
        b=NOL4m84U6qKfNrympHFrOmU7mGM1w1gPHU5ErnevIOlDwhu9ha5TLTc5kqbB1GivHr
         JCHoJae2fWgLDWON1XyEkky/QMb7ArPe+FwFZFF9Qnyzj4xH4yCXmETcl836tJSiVBC5
         argeBV470cVJHURJXW/J6lJKXQYW8fdcHz2p1aDo+YGppq4n2mukLBDd8lYMcsvJnbZZ
         IWvoucuimDDb82xggTSj07r3dogpEiLiYraYA+DpMuVQHCRyqDo7iWywi48+Vh1R9ehG
         OJ0O3lN2tuDMZ/8zweR4BwLXg6oMMKRqN2LPV196wWvPCVzg+IakuIWrrktEw2Z/FI3U
         UOoQ==
X-Gm-Message-State: AOAM532aYCefsKTSi2OF0N3C4YEsWF+P1fzT9rETAx+oU3dBB7mG+82E
        YZVU+28Bx+yw3KkOsmtDunI=
X-Google-Smtp-Source: ABdhPJzobk+kyfH4IaVIUVdA4tztlyolb0iUT9kGkge6VnZKnOwInCXsjw6M7XGVjoTByVPdgV1xpQ==
X-Received: by 2002:a7b:c5c6:: with SMTP id n6mr6552880wmk.131.1607588305727;
        Thu, 10 Dec 2020 00:18:25 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id h20sm8889440wrb.21.2020.12.10.00.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 00:18:24 -0800 (PST)
Date:   Thu, 10 Dec 2020 09:18:22 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 2/2] nfc: s3fwrn5: Remove hard coded
 interrupt trigger type from the i2c module
Message-ID: <20201210081822.GA3573@kozik-lap>
References: <20201208141012.6033-1-bongsu.jeon@samsung.com>
 <20201208141012.6033-3-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201208141012.6033-3-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 11:10:12PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> For the flexible control of interrupt trigger type, remove the hard coded
> interrupt trigger type in the i2c module. The trigger type will be loaded
>  from a dts.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index e1bdde105f24..42f1f610ac2c 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -179,6 +179,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {
>  	struct s3fwrn5_i2c_phy *phy;
> +	struct irq_data *irq_data;
> +	unsigned long irqflags;
>  	int ret;
>  
>  	phy = devm_kzalloc(&client->dev, sizeof(*phy), GFP_KERNEL);
> @@ -212,8 +214,11 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> +	irq_data = irq_get_irq_data(client->irq);
> +	irqflags = irqd_get_trigger_type(irq_data) | IRQF_ONESHOT;

This patch is wrong and should not be applied. David, please give few
days to review the patches. :)

The irqd_get_trigger_type is not necessary.

I'll send follow ups to correct this.

Best regards,
Krzysztof


> +
>  	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
> -		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +		s3fwrn5_i2c_irq_thread_fn, irqflags,
>  		S3FWRN5_I2C_DRIVER_NAME, phy);
>  	if (ret)
>  		s3fwrn5_remove(phy->common.ndev);
> -- 
> 2.17.1
> 
