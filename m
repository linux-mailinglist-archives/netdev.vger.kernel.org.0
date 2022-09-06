Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F1F5AF102
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiIFQrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiIFQqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:46:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBBD7FF96
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:27:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id kk26so24490218ejc.11
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 09:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=0OozxLkamyMLDKk4u80slhahH/+s0KovGrehlqjA6/g=;
        b=XgMnq+8SWNMH/cOQoHAeuYqKKtHanUodn0wMiQ6C/qlwGJEkp9CLM3kY1sVavdHRpP
         MYBQOhH+fWNKhGvvR+UqO91K/nBMj8EwbIOM5OVxd65hOm3adVrddPjeB85QTDm2PgfP
         KaOsyCmBQnGWQLXJUHM7ACR5RipeXdPLvOjbqzNZ+0O8um7j8II5uRr5n94STEK98a23
         eeyXsunFDOo8ggs3qSrQnIV7NxVYsyrxBFHsYEuho5XmPZy1DW47avPNQtEDOOsAZ3/l
         BGm/IEhfN5QhVrbvj/gPWFTH8dmZJpDT7LeDIF3pMz1nXySg1FmhTzIhuRSmJ0FKC+Af
         zxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0OozxLkamyMLDKk4u80slhahH/+s0KovGrehlqjA6/g=;
        b=d2zsaXtK2YRq1Rd29X1PL2ttkkYRZnq1exzkTfR/qmajQGsfg3h1dDWXz3YBNmdCSi
         b+PK+Ku0o1M9BmRThshhaOwPo0+c3PFxTi4ww8a86EH+TgVj0k/vAVznQn4JQ3RT1Yuv
         AAZChXzNsC7/c7RZSScQ/w4UYciGnUOKH+BINWAPUcMeoRePvokvBwwhyTUGSGk9ycYL
         HT077tI/2TC2znFb8N7E9Fis8NmOUobw3IhJOjHmDV/Cv42Be1eenVesZoiGOiEe+C4l
         JpW39AN47xkszLdZkuQcfDG4YCKZydq4RuQnda6N0wpJ2rrWx6h2LaPjlKvBrfzM7av3
         cE6A==
X-Gm-Message-State: ACgBeo0spqFdzdXdY047ylwkb5HEaezsOaFhslDCAPHKrFrwTNc4WlBS
        PJd2X3H/djCDYRvxUy9ykmo=
X-Google-Smtp-Source: AA6agR539VE3/ljYYTS+aAJfxhyvvGq+xrGwuyDP4IBVCmeYgmF1NldzwCbikaqFjveLNfvZ9Exc1w==
X-Received: by 2002:a17:907:7204:b0:749:7839:4dd2 with SMTP id dr4-20020a170907720400b0074978394dd2mr16866787ejc.714.1662481629682;
        Tue, 06 Sep 2022 09:27:09 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t19-20020a1709067c1300b00730b61d8a5esm6860247ejo.61.2022.09.06.09.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 09:27:09 -0700 (PDT)
Subject: Re: [PATCH net-next] sfc: introduce shutdown entry point in efx pci
 driver
To:     pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Martin Habets <habetsm.xilinx@gmail.com>
References: <20220906105620.26179-1-pieter.jansen-van-vuuren@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <16164cd2-0dce-8bfe-92da-f874184a3127@gmail.com>
Date:   Tue, 6 Sep 2022 17:27:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220906105620.26179-1-pieter.jansen-van-vuuren@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2022 11:56, pieter.jansen-van-vuuren@amd.com wrote:
> From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> 
> Make the device inactive when the system shutdown callback has been
> invoked. This is achieved by freezing the driver and disabling the
> PCI bus mastering.
> 
> Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx.c       | 12 ++++++++++++
>  drivers/net/ethernet/sfc/siena/efx.c | 12 ++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 153d68e29b8b..b85c95e1ae7c 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -1175,6 +1175,17 @@ static int efx_pm_freeze(struct device *dev)
>  	return 0;
>  }
>  
> +static void efx_pci_shutdown(struct pci_dev *pci_dev)
> +{
> +	struct efx_nic *efx = pci_get_drvdata(pci_dev);
> +
> +	if (!efx)
> +		return;
> +
> +	efx_pm_freeze(&pci_dev->dev);
> +	pci_disable_device(pci_dev);
> +}
> +
>  static int efx_pm_thaw(struct device *dev)
>  {
>  	int rc;
> @@ -1279,6 +1290,7 @@ static struct pci_driver efx_pci_driver = {
>  	.probe		= efx_pci_probe,
>  	.remove		= efx_pci_remove,
>  	.driver.pm	= &efx_pm_ops,
> +	.shutdown	= efx_pci_shutdown,
>  	.err_handler	= &efx_err_handlers,
>  #ifdef CONFIG_SFC_SRIOV
>  	.sriov_configure = efx_pci_sriov_configure,
> diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
> index 63d999e63960..cf09521b0c64 100644
> --- a/drivers/net/ethernet/sfc/siena/efx.c
> +++ b/drivers/net/ethernet/sfc/siena/efx.c
> @@ -1148,6 +1148,17 @@ static int efx_pm_freeze(struct device *dev)
>  	return 0;
>  }
>  
> +static void efx_pci_shutdown(struct pci_dev *pci_dev)
> +{
> +	struct efx_nic *efx = pci_get_drvdata(pci_dev);
> +
> +	if (!efx)
> +		return;
> +
> +	efx_pm_freeze(&pci_dev->dev);
> +	pci_disable_device(pci_dev);
> +}
> +
>  static int efx_pm_thaw(struct device *dev)
>  {
>  	int rc;
> @@ -1252,6 +1263,7 @@ static struct pci_driver efx_pci_driver = {
>  	.probe		= efx_pci_probe,
>  	.remove		= efx_pci_remove,
>  	.driver.pm	= &efx_pm_ops,
> +	.shutdown	= efx_pci_shutdown,
>  	.err_handler	= &efx_siena_err_handlers,
>  #ifdef CONFIG_SFC_SIENA_SRIOV
>  	.sriov_configure = efx_pci_sriov_configure,
> 

