Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58568312873
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBGXs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBGXsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:48:54 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C5FC06174A;
        Sun,  7 Feb 2021 15:48:14 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id h6so13926630oie.5;
        Sun, 07 Feb 2021 15:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tY7ZarVBXtt0fxIv2A1izlyj0khfnqWTNJNCQnvk4PI=;
        b=Elg1Zfw/ZKrrru5A7FqxO/VNBPAkhKQ4kGNuoCYl9k6ZyiKhYPc72vKpooqzt7VZq0
         KvAHwLbsnubkRLz0THQtaQDBClV3xPd/SX5r66A3xOZEi1aoVI2ubKGreR5Ehq7kwJGA
         vp1RFTdThVkNYrlpSVdHmGJ4JD6bPQadx3lwIxAvjNDCzgFPKs4SCTBSAJlFOdc4UZue
         /qFDuAJDnfMtRahrb63DwEYfqxBt8fu0LrMztif8JRye5HCiIJk3YoJJUh9i3cGmJHbl
         ywC7U7U/oVE4L/adLVD287Xx7WqB6LB8d81rr1KDnsI8WVSRgPst+gZezPaBmOcrJoBO
         Bitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tY7ZarVBXtt0fxIv2A1izlyj0khfnqWTNJNCQnvk4PI=;
        b=KeDFgOmEigh4NOPVohqN0f90RKJeuE7SRFXZBSrDaOMOhzCUzFUVeIA3UU+Aja7/Zw
         TCQ3jsnoOiloAYLtL3XpJiFkk7qk8oJBzO1ngxvoYvCP/DC1iskP69DDKnovHnaXCMIC
         V/g7p1KHnwJNSQ4jili8eZE18LijZZKee1hZ8H9ofATeHRDVrprPn90JCa24fiUX5MDC
         MU866cZ4F7HcL9GxNmPI5zVpzEQSplR/039aQ5gV2mY5ypND1pXetZ3F0d57s4s6narR
         422ase22Ii+ehLh0kYAxohLNATv0pwAMiuhfO77ye++Ukt9go3IoF8tMs3/ThqfValmg
         TPcg==
X-Gm-Message-State: AOAM5329hBobFBhR5hDj0XkwZSLOLHzCqi7u3YgdkG/cLm2uG0ZKGtId
        ApEpOSulYs6ObHPAN3SlSlfKORARM2E=
X-Google-Smtp-Source: ABdhPJxkuyodp8oSc3Syrza1sBUt5BN1gH3N3v6U19nhzctso4Hft+Umx6ZEK72dws6Kjh/W3TooaQ==
X-Received: by 2002:aca:3b06:: with SMTP id i6mr9560639oia.81.1612741693429;
        Sun, 07 Feb 2021 15:48:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k21sm1752368otl.27.2021.02.07.15.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 15:48:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v1 2/2] mei: bus: change remove callback to return void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org
References: <20210207222224.97547-1-uwe@kleine-koenig.org>
 <20210207222224.97547-2-uwe@kleine-koenig.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <3bf2c0dd-9c96-573c-e9db-dd0c66ff1523@roeck-us.net>
Date:   Sun, 7 Feb 2021 15:48:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210207222224.97547-2-uwe@kleine-koenig.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/21 2:22 PM, Uwe Kleine-König wrote:
> The driver core ignores the return value of mei_cl_device_remove() so
> passing an error value doesn't solve any problem. As most mei drivers'
> remove callbacks return 0 unconditionally and returning a different value
> doesn't have any effect, change this prototype to return void and return 0
> unconditionally in mei_cl_device_remove(). The only driver that could
> return an error value is modified to emit an explicit warning in the error
> case.
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
> ---
>  drivers/misc/mei/bus.c           | 5 ++---
>  drivers/misc/mei/hdcp/mei_hdcp.c | 7 +++++--
>  drivers/nfc/microread/mei.c      | 4 +---
>  drivers/nfc/pn544/mei.c          | 4 +---
>  drivers/watchdog/mei_wdt.c       | 4 +---

Acked-by: Guenter Roeck <linux@roeck-us.net>

>  include/linux/mei_cl_bus.h       | 2 +-
>  6 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
> index 50d617e7467e..54dddae46705 100644
> --- a/drivers/misc/mei/bus.c
> +++ b/drivers/misc/mei/bus.c
> @@ -879,17 +879,16 @@ static int mei_cl_device_remove(struct device *dev)
>  {
>  	struct mei_cl_device *cldev = to_mei_cl_device(dev);
>  	struct mei_cl_driver *cldrv = to_mei_cl_driver(dev->driver);
> -	int ret = 0;
>  
>  	if (cldrv->remove)
> -		ret = cldrv->remove(cldev);
> +		cldrv->remove(cldev);
>  
>  	mei_cldev_unregister_callbacks(cldev);
>  
>  	mei_cl_bus_module_put(cldev);
>  	module_put(THIS_MODULE);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static ssize_t name_show(struct device *dev, struct device_attribute *a,
> diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
> index 9ae9669e46ea..6a455ebe4891 100644
> --- a/drivers/misc/mei/hdcp/mei_hdcp.c
> +++ b/drivers/misc/mei/hdcp/mei_hdcp.c
> @@ -845,16 +845,19 @@ static int mei_hdcp_probe(struct mei_cl_device *cldev,
>  	return ret;
>  }
>  
> -static int mei_hdcp_remove(struct mei_cl_device *cldev)
> +static void mei_hdcp_remove(struct mei_cl_device *cldev)
>  {
>  	struct i915_hdcp_comp_master *comp_master =
>  						mei_cldev_get_drvdata(cldev);
> +	int ret;
>  
>  	component_master_del(&cldev->dev, &mei_component_master_ops);
>  	kfree(comp_master);
>  	mei_cldev_set_drvdata(cldev, NULL);
>  
> -	return mei_cldev_disable(cldev);
> +	ret = mei_cldev_disable(cldev);
> +	if (ret)
> +		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n")
>  }
>  
>  #define MEI_UUID_HDCP GUID_INIT(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
> diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
> index 5dad8847a9b3..8fa7771085eb 100644
> --- a/drivers/nfc/microread/mei.c
> +++ b/drivers/nfc/microread/mei.c
> @@ -44,15 +44,13 @@ static int microread_mei_probe(struct mei_cl_device *cldev,
>  	return 0;
>  }
>  
> -static int microread_mei_remove(struct mei_cl_device *cldev)
> +static void microread_mei_remove(struct mei_cl_device *cldev)
>  {
>  	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
>  
>  	microread_remove(phy->hdev);
>  
>  	nfc_mei_phy_free(phy);
> -
> -	return 0;
>  }
>  
>  static struct mei_cl_device_id microread_mei_tbl[] = {
> diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
> index 579bc599f545..5c10aac085a4 100644
> --- a/drivers/nfc/pn544/mei.c
> +++ b/drivers/nfc/pn544/mei.c
> @@ -42,7 +42,7 @@ static int pn544_mei_probe(struct mei_cl_device *cldev,
>  	return 0;
>  }
>  
> -static int pn544_mei_remove(struct mei_cl_device *cldev)
> +static void pn544_mei_remove(struct mei_cl_device *cldev)
>  {
>  	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
>  
> @@ -51,8 +51,6 @@ static int pn544_mei_remove(struct mei_cl_device *cldev)
>  	pn544_hci_remove(phy->hdev);
>  
>  	nfc_mei_phy_free(phy);
> -
> -	return 0;
>  }
>  
>  static struct mei_cl_device_id pn544_mei_tbl[] = {
> diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
> index 5391bf3e6b11..53165e49c298 100644
> --- a/drivers/watchdog/mei_wdt.c
> +++ b/drivers/watchdog/mei_wdt.c
> @@ -619,7 +619,7 @@ static int mei_wdt_probe(struct mei_cl_device *cldev,
>  	return ret;
>  }
>  
> -static int mei_wdt_remove(struct mei_cl_device *cldev)
> +static void mei_wdt_remove(struct mei_cl_device *cldev)
>  {
>  	struct mei_wdt *wdt = mei_cldev_get_drvdata(cldev);
>  
> @@ -636,8 +636,6 @@ static int mei_wdt_remove(struct mei_cl_device *cldev)
>  	dbgfs_unregister(wdt);
>  
>  	kfree(wdt);
> -
> -	return 0;
>  }
>  
>  #define MEI_UUID_WD UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, \
> diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
> index 959ad7d850b4..07f5ef8fc456 100644
> --- a/include/linux/mei_cl_bus.h
> +++ b/include/linux/mei_cl_bus.h
> @@ -68,7 +68,7 @@ struct mei_cl_driver {
>  
>  	int (*probe)(struct mei_cl_device *cldev,
>  		     const struct mei_cl_device_id *id);
> -	int (*remove)(struct mei_cl_device *cldev);
> +	void (*remove)(struct mei_cl_device *cldev);
>  };
>  
>  int __mei_cldev_driver_register(struct mei_cl_driver *cldrv,
> 

