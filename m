Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFAC412ACA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbhIUB6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhIUBuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:07 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B435C06AB1D;
        Mon, 20 Sep 2021 14:56:47 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so18742098pgc.6;
        Mon, 20 Sep 2021 14:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kY/4eMbED4CLtz6FkJE/bYjN2trJmqcJcBgHfiCqU6o=;
        b=bOO4yQ0nZzQgEuX1DLTzV9WniMTMSauFJDXNpUhKe7qX4Qy9rVoUV8W4RWWhgPbNQI
         +7dZyowGszGTR8YabQ5aWV2weDZb5+RK6oHgmO3u9A2Gwz36c8F5KvSR4GZHvUuo2FwC
         qaj2s+ZV4Q412NuIFPsvVHjAv3+IMnXR1ZbjHHuBHFKbqsTXLwUWrwHdIeLBaLCiRLSV
         5O9cdT4FPGre+whF+uMGz/HBSFfM1PtIpFHXP7ComNKLO07Rl+IJA3UTkAywtg82N1sJ
         LIUTbcxD7KR84EOI+z/HJm5zb8qYQ9ZWFvmCsnur2LNBYcKznrBCbOx7ZUo6IzYg2P2O
         Tqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kY/4eMbED4CLtz6FkJE/bYjN2trJmqcJcBgHfiCqU6o=;
        b=vtSdXte1db8SJdv1l8ZiLdklqhh43OdKdB0dZlyeW4QRAjGKlAST2gzcSYC6DKamps
         /UIDanZ8RGv7X0M8HvXD1OJkz1n+wr+xUdR7pIqbA7YsP1MwBY2qxG754OS4QdN3ZnLz
         uXeasgPMZCcHTDRdJbdel1hVr6HioJ9g7fxUaXwU+mVBAFNs9Y0eruJH2g3BI3qd7IiT
         glv+dHZQ8zJQGOU6sDfL4Ug3BKa/K1jI6gobsKw+wvTQ0bvJP9yjoVc3KqsJk3+cC9dS
         78k3xHvr4Ghn8oTDTtrWKuUKR6OxKbsXgQxnJ/Y8lIHNat8m8j44ODzvR3lIQxJqz8GL
         JV4g==
X-Gm-Message-State: AOAM530fluLxg8v5LDNDgINHxlenf+2Q81ufEmwcOdX+NJesEuF7JIEV
        iSY1rrrEdms+I3w54N3CiFY=
X-Google-Smtp-Source: ABdhPJxQ8au0fvrMAOuU6/c0e4rCbbkPKrRZ9f6h4RiRmI2S+b1nnyXx4Y5P4zhFV1yekAos2s8zdQ==
X-Received: by 2002:a63:35cc:: with SMTP id c195mr25143261pga.373.1632175006686;
        Mon, 20 Sep 2021 14:56:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i12sm356346pjv.19.2021.09.20.14.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 14:56:45 -0700 (PDT)
Subject: Re: [PATCH 7/9] net: mdio: mdio-bcm-iproc: simplify getting
 .driver_data
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
 <20210920090522.23784-8-wsa+renesas@sang-engineering.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6a8ffcab-4534-1692-5f6a-8a7906d07a09@gmail.com>
Date:   Mon, 20 Sep 2021 14:56:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920090522.23784-8-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 2:05 AM, Wolfram Sang wrote:
> We should get 'driver_data' from 'struct device' directly. Going via
> platform_device is an unneeded step back and forth.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> 
> Build tested only. buildbot is happy.
> 
>  drivers/net/mdio/mdio-bcm-iproc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-bcm-iproc.c b/drivers/net/mdio/mdio-bcm-iproc.c
> index 77fc970cdfde..5666cfab15b9 100644
> --- a/drivers/net/mdio/mdio-bcm-iproc.c
> +++ b/drivers/net/mdio/mdio-bcm-iproc.c
> @@ -181,8 +181,7 @@ static int iproc_mdio_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM_SLEEP
>  static int iproc_mdio_resume(struct device *dev)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct iproc_mdio_priv *priv = platform_get_drvdata(pdev);
> +	struct iproc_mdio_priv *priv = dev_get_drvdata(dev);

The change looks good to me, however if you change from
platform_get_drvdata() to dev_get_drvdata(), you might also want to
change from using platform_set_drvdata() to dev_set_drvdata() for
symmetry no? If not, then maybe this patch should be dropped?
-- 
Florian
