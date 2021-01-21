Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ADD2FE673
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbhAUJfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbhAUJet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:34:49 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7980C061757;
        Thu, 21 Jan 2021 01:34:08 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id 2so611259qvd.0;
        Thu, 21 Jan 2021 01:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PHgXNcLpWWzH48/dEVacVS3r+5/FS5gKDqP8o+U8Fbk=;
        b=QDbao1aPN30IFtTKaNmeQlKxNFVzghZhV/f/YoZKj7UkARYK7s4OWesYgtrSMRWVM4
         1aEFsGxaV/ufnIT2Qga9xVYeMmBPKIpCisMvYt5nXNVaiIwbi7a3po8rEMzSwew7i5nO
         RWDyKai5ZUNziyF1la/kS7Pe6WhZZhWsxW8+EceDsRnUiOZS+x2phbFNtbhTnGibACyi
         hygK5cqHoy7SQ6UlGUdAE1T+BQiNJ/8Kas9X04GwgL/yVubyBS1M6ESqkw24UROYKomx
         vxdoNc9JuyuPG/wcM3LQY8BEOTUgTVpAxyHmQn95X90wDQ6mNikI5oGiOytLX2n36YRx
         iWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PHgXNcLpWWzH48/dEVacVS3r+5/FS5gKDqP8o+U8Fbk=;
        b=NaQXHR5PA6hfiI2pOp3eYkZgTL2LiLMIlWCOsBCkbDsDnwqamXaNcs2CsRr0DJOeUB
         Gz1b2lk3p2LW3oVBU26iVC/kOOhmUYZ8zbHA/SEbkLVHn6gq1CRIoWokxvOsRKm/3KaE
         OTj2e7yjnaaueGwA5rFWA8FwiybeaaFrDDM/x6IHbhJApBgzjSVl0NkxIHzmOXcW+IDk
         lT2DUNSuSOmL8VB1uuCwut7WuTHGLT5TBw1/9Z4RsER80pEf7dh5zoEGffNKQ6GnBwWb
         BsLskhZ6QAMkc8p4hiXgGM2nxv9BMp63bryZp0ngJVWFQuep5ysPXG3yFRTtpUYZHe34
         +PyA==
X-Gm-Message-State: AOAM531B9kpiyXlT5PCQFp3OT1KO7X3qzD0Zw9W1pvVKWi2fN7gxPZlZ
        253qBko63s3vJNkmhx17SzYA6xm4qJ/fdOxZ71M=
X-Google-Smtp-Source: ABdhPJzrCd0yY+Wsifr9FFyAJltKMKfsPjrBFFxm/HughiVS8ddT6x6q9zC1SKN8/iqn6XlzU6fipg==
X-Received: by 2002:a0c:8203:: with SMTP id h3mr13433464qva.0.1611221647748;
        Thu, 21 Jan 2021 01:34:07 -0800 (PST)
Received: from [0.0.0.0] ([2001:19f0:5:2661:5400:2ff:fe99:4621])
        by smtp.gmail.com with ESMTPSA id s6sm93016qtx.63.2021.01.21.01.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 01:34:07 -0800 (PST)
Subject: Re: [PATCH v2] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210121091005.74417-1-suyanjun218@gmail.com>
 <20210121092115.dasphwfzfkthcy64@hardanger.blackshift.org>
From:   Su <suyanjun218@gmail.com>
Message-ID: <5ed3d488-3ea6-cc07-a04d-73a6678d772a@gmail.com>
Date:   Thu, 21 Jan 2021 17:33:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210121092115.dasphwfzfkthcy64@hardanger.blackshift.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sizeof(u32) is hardcoded. IMO it's better to use the config value in 
regmap.

Thanks

在 2021/1/21 下午5:21, Marc Kleine-Budde 写道:
> On Thu, Jan 21, 2021 at 05:10:05PM +0800, Su Yanjun wrote:
>
> Please describe why you change this.
>
>> No functional effect.
> Not quite:
>
> scripts/bloat-o-meter shows:
>
> add/remove: 0/0 grow/shrink: 3/0 up/down: 104/0 (104)
> Function                                     old     new   delta
> mcp251xfd_handle_tefif                       980    1028     +48
> mcp251xfd_irq                               3716    3756     +40
> mcp251xfd_handle_rxif_ring                   964     980     +16
> Total: Before=20832, After=20936, chg +0.50%
>
>> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
>> ---
>>   drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
>> index f07e8b737d31..b15bfd50b863 100644
>> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
>> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
>> @@ -181,6 +181,12 @@ static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
>>   	return 0;
>>   }
>>   
>> +static inline int
>> +mcp251xfd_get_val_bytes(const struct mcp251xfd_priv *priv)
>> +{
>> +	return regmap_get_val_bytes(priv->map_reg);
> You're always using the "map_reg" here
>
>> +}
>> +
>>   static inline u8
>>   mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
>>   				union mcp251xfd_write_reg_buf *write_reg_buf,
>> @@ -1308,6 +1314,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
>>   		       const u8 offset, const u8 len)
>>   {
>>   	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
>> +	int val_bytes = mcp251xfd_get_val_bytes(priv);
>>   
>>   	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
>>   	    (offset > tx_ring->obj_num ||
>> @@ -1322,7 +1329,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
>>   	return regmap_bulk_read(priv->map_rx,
> But this works on map_rx.
>
>>   				mcp251xfd_get_tef_obj_addr(offset),
>>   				hw_tef_obj,
>> -				sizeof(*hw_tef_obj) / sizeof(u32) * len);
>> +				sizeof(*hw_tef_obj) / val_bytes * len);
>>   }
>>   
>>   static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
>> @@ -1511,11 +1518,12 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
>>   		      const u8 offset, const u8 len)
>>   {
>>   	int err;
>> +	int val_bytes = mcp251xfd_get_val_bytes(priv);
>>   
>>   	err = regmap_bulk_read(priv->map_rx,
> Same here
>
>>   			       mcp251xfd_get_rx_obj_addr(ring, offset),
>>   			       hw_rx_obj,
>> -			       len * ring->obj_size / sizeof(u32));
>> +			       len * ring->obj_size / val_bytes);
>>   
>>   	return err;
>>   }
>> @@ -2139,6 +2147,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
>>   	struct mcp251xfd_priv *priv = dev_id;
>>   	irqreturn_t handled = IRQ_NONE;
>>   	int err;
>> +	int val_bytes = mcp251xfd_get_val_bytes(priv);
>>   
>>   	if (priv->rx_int)
>>   		do {
>> @@ -2162,7 +2171,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
>>   		err = regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
> Here it's map_reg.
>
>>   				       &priv->regs_status,
>>   				       sizeof(priv->regs_status) /
>> -				       sizeof(u32));
>> +				       val_bytes);
>>   		if (err)
>>   			goto out_fail;
>>   
>> -- 
>> 2.25.1
> Marc
>
