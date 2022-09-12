Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169725B6008
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiILSOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiILSOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:14:47 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D76271;
        Mon, 12 Sep 2022 11:14:46 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id u28so3720155qku.2;
        Mon, 12 Sep 2022 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=YPKBe9B3XbC8RUfPOGArlb9dr+0GqBtfH24k5Otusrk=;
        b=YacZ7pCFkqrvZCQtCIGbDt2MYK3i+sd3xi1qTDTf1RqY9UYfccxhJQwuo4vjytaVrV
         LvCX0WexjcADJKv1qBmMPN/ovyIa+1a5ZV13RyU452y2Rt7Jh8lM24X5lmw701OWu1hU
         P21rekXqi5mPPJWZ1Emm/j4CYCwUSVXdIzHVELNE4vT/TUrKmW9Hvxu69GESQ2rK3jsO
         eaMp4Yo8i5cPA1GX+OFYToufY0+7aWTdgpnr0ALI3B+vUg7jgXHVzB1Zf81gry1D8YPH
         MJ9NK5UXiSgdO7gj9jvgTPBxwTIHMZbOXFP68b6QZhK7o3hDKKUNptDkh2Vjcxrpo5Vn
         5WAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YPKBe9B3XbC8RUfPOGArlb9dr+0GqBtfH24k5Otusrk=;
        b=zGTfv8dwjR//+61/3e4Zf/99Q+ZLuFGSlBhmGg4VtBaNpO/u+moHZGarIoGzwPbiEZ
         qbgptA8XiYdInh5nV6tc4om424rr2a61CjJes51hd3reNIATMMfYD+S6XyiFwFflpk3g
         O1JT2v2d0wyiKVEJGX6x23CBCfifqrr7FoHjr1OGTxzaLHtairaBlsloEjHO/09u5Lc4
         Dy3CR+5ACo74wE6FE5gxjIJ5mqzAp945KtVGsDQZnsTc3v96ciQe9Ek+Sr+gS8AzcsIb
         /Vf9/2Z7tDZzFA12GarAJ7cN3HH7m+A+ZXwW5hBEVDLb+ZFTs6aFjm8+W2ypw9o8GzQM
         JWVA==
X-Gm-Message-State: ACgBeo0ICPVOkd5shmFUptuKBoECMWyYCml9Rhnl8o9m6NPU+pON8TNJ
        JDkmFf71+WFXCtrQEq4SX3o=
X-Google-Smtp-Source: AA6agR7c8yiYGI7DfCu1B8qVctmxFMSXhsf+Q5RWzOlwmH2G0Mg5/eO01vwQ5HjoS3ZQmqA1jtGMaw==
X-Received: by 2002:a05:620a:d8c:b0:6a7:91a4:2669 with SMTP id q12-20020a05620a0d8c00b006a791a42669mr20165762qkl.269.1663006485451;
        Mon, 12 Sep 2022 11:14:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d5-20020a05622a15c500b0035bb6298526sm2342497qty.17.2022.09.12.11.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:14:44 -0700 (PDT)
Message-ID: <2380c655-a6ba-7cdb-06d1-9c7856ff6cce@gmail.com>
Date:   Mon, 12 Sep 2022 11:14:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: broadcom: bcm4908enet: add platform_get_irq_byname
 error checking
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Yu Zhe <yuzhe@nfschina.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
References: <20220909062545.16696-1-yuzhe@nfschina.com>
 <Yx8YDUaxXBEFYyON@kadam>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yx8YDUaxXBEFYyON@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 04:29, Dan Carpenter wrote:
> On Fri, Sep 09, 2022 at 02:25:45PM +0800, Yu Zhe wrote:
>> The platform_get_irq_byname() function returns negative error codes on error,
>> check it.
>>
>> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
>> ---
>>   drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> index c131d8118489..d985056db6c2 100644
>> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> @@ -705,6 +705,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
>>   		return netdev->irq;
>>   
>>   	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
>> +	if (enet->irq_tx < 0)
>> +		return enet->irq_tx;
>>   
> 
> If you read the driver, then you will see that this is deliberate.
> Search for irq_tx and read the comments.  I'm not a subsystem expert so
> I don't know if this an ideal way to write the code, but it's done
> deliberately so please don't change it unless you can test it.

Yup, the transmit interrupt is deemed optional, or at least was up to 
some point during the driver development. There is however a worthy bug 
you could fix:

   static int bcm4908_enet_stop(struct net_device *netdev)
   {
           struct bcm4908_enet *enet = netdev_priv(netdev);
           struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
           struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;

           netif_stop_queue(netdev);
           netif_carrier_off(netdev);
           napi_disable(&rx_ring->napi);
           napi_disable(&tx_ring->napi);

           bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
           bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);

           bcm4908_enet_dma_uninit(enet);

           free_irq(enet->irq_tx, enet);

We might attempt to free an invalid interrupt here ^^

           free_irq(enet->netdev->irq, enet);

           return 0;
-- 
Florian
