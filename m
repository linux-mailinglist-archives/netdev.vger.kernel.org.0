Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB112B6622
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbgKQOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:01:23 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36940 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732424AbgKQOBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:01:14 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE1A5b078664;
        Tue, 17 Nov 2020 08:01:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605621670;
        bh=BuKutXxuKyCD/OH7HB7RFLWUUS4B4SmSSghZlJn9Y30=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dwfptb4zJz7Q64O3qgV5FHpc6c2eq4xwDF9mOoOxuk4WGi+1KEayRQss9STnqNLDD
         7/Grvk0IQnBCNdkl/T/PWSAvLurkLm0kt7afjHi1zErZc745n9yWNVsc9mqm04H9pr
         i5hiMjD2W2TvktK3ZP0bcbXfhtFsGCg3KGj7ytxk=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHE1ANK091459
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 08:01:10 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 08:01:09 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 08:01:09 -0600
Received: from [10.250.39.187] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE19O1018587;
        Tue, 17 Nov 2020 08:01:09 -0600
Subject: Re: [net 10/15] can: tcan4x5x: tcan4x5x_can_probe(): add missing
 error checking for devm_regmap_init()
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
 <20201115174131.2089251-11-mkl@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a9629b43-b3f1-cbee-70a9-62e4c1b0b234@ti.com>
Date:   Tue, 17 Nov 2020 08:01:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115174131.2089251-11-mkl@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 11/15/20 11:41 AM, Marc Kleine-Budde wrote:
> This patch adds the missing error checking when initializing the regmap
> interface fails.
>
> Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
> Cc: Dan Murphy <dmurphy@ti.com>
> Link: http://lore.kernel.org/r/20201019154233.1262589-7-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   drivers/net/can/m_can/tcan4x5x.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
> index eacd428e07e9..f058bd9104e9 100644
> --- a/drivers/net/can/m_can/tcan4x5x.c
> +++ b/drivers/net/can/m_can/tcan4x5x.c
> @@ -487,6 +487,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
>   
>   	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
>   					&spi->dev, &tcan4x5x_regmap);
> +	if (IS_ERR(priv->regmap)) {
> +		ret = PTR_ERR(priv->regmap);
> +		goto out_clk;
> +	}
>   
>   	ret = tcan4x5x_power_enable(priv->power, 1);
>   	if (ret)


Reviewed-by: Dan Murphy<dmurphy@ti.com>

