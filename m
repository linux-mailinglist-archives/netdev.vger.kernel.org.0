Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009A12B661E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbgKQOBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:01:24 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36844 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387562AbgKQOA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:00:59 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE0pFr078503;
        Tue, 17 Nov 2020 08:00:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605621651;
        bh=IRXrpQKQSd5gA7IrwYkGoDS5kdYPeIdfK1pxJXpAd04=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gMEuoss5YCgctlsV8nUL3lA+QiKK6D3edcSJcseFCfDIu4i64JOg/aSdb+T+iOlyj
         kSmQMuUDfg4vQ6OcX/RIorb1YUiv4RToYh8T00m6MrLOFb3p4xk4DZNuNq4Wm4VZqc
         80Irb6UnSgwlNVamoo4YavkZd2+sH3lvwrfFNCnI=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHE0pU2012141
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 08:00:51 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 08:00:50 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 08:00:50 -0600
Received: from [10.250.39.187] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE0oLG017715;
        Tue, 17 Nov 2020 08:00:50 -0600
Subject: Re: [net 11/15] can: tcan4x5x: tcan4x5x_can_remove(): fix order of
 deregistration
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
 <20201115174131.2089251-12-mkl@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <67debcb1-5fb6-76bd-b1b1-24d97389aa6b@ti.com>
Date:   Tue, 17 Nov 2020 08:00:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115174131.2089251-12-mkl@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 11/15/20 11:41 AM, Marc Kleine-Budde wrote:
> Change the order in tcan4x5x_can_remove() to be the exact inverse of
> tcan4x5x_can_probe(). First m_can_class_unregister(), then power down the
> device.
>
> Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
> Cc: Dan Murphy <dmurphy@ti.com>
> Link: http://lore.kernel.org/r/20201019154233.1262589-10-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   drivers/net/can/m_can/tcan4x5x.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
> index f058bd9104e9..4fdb7121403a 100644
> --- a/drivers/net/can/m_can/tcan4x5x.c
> +++ b/drivers/net/can/m_can/tcan4x5x.c
> @@ -527,10 +527,10 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
>   {
>   	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
>   
> -	tcan4x5x_power_enable(priv->power, 0);
> -
>   	m_can_class_unregister(priv->mcan_dev);
>   
> +	tcan4x5x_power_enable(priv->power, 0);
> +
>   	return 0;
>   }
>   

Reviewed-by: Dan Murphy<dmurphy@ti.com>

