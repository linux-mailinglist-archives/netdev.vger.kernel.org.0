Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6965B118C47
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfLJPQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:16:09 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:55768 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfLJPQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:16:08 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBAFFiD7105272;
        Tue, 10 Dec 2019 09:15:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575990944;
        bh=SPqMpDNgTazLOmVVu6pQbTE2uwLvoIZ+26juZp6eI9Y=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fZXzPK2KFdy3xInOpXTsY1pPEtcjBrTOztIfg0dvQkTa9IopH059JXDkcwoucJQ5M
         J+qv/8EtpIEWS/kIzP5kePnzoj1zoL6YGP8RO0mnQC0kw9NwczBHECRoAkYYRxxOk/
         XT/a/JKX9CwAAQGwNc9Np2i9D07lHxDIlnKmbVRY=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBAFFikx055545
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Dec 2019 09:15:44 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 10
 Dec 2019 09:15:43 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 10 Dec 2019 09:15:43 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBAFFh7d024012;
        Tue, 10 Dec 2019 09:15:43 -0600
Subject: Re: [PATCH][next] can: tcan45x: Fix inconsistent IS_ERR and PTR_ERR
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Nyekjaer <sean@geanix.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20191210150532.GA12732@embeddedor>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f1c40cbe-28de-55e9-ec19-9401f2c0de03@ti.com>
Date:   Tue, 10 Dec 2019 09:13:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210150532.GA12732@embeddedor>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gustavo

On 12/10/19 9:05 AM, Gustavo A. R. Silva wrote:
> Fix inconsistent IS_ERR and PTR_ERR in tcan4x5x_parse_config.
>
> The proper pointer to be passed as argument is tcan4x5x->device_wake_gpio.
>
> This bug was detected with the help of Coccinelle.
>
> Fixes: 2de497356955 ("can: tcan45x: Make wake-up GPIO an optional GPIO")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/net/can/m_can/tcan4x5x.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
> index 4e1789ea2bc3..6676ecec48c3 100644
> --- a/drivers/net/can/m_can/tcan4x5x.c
> +++ b/drivers/net/can/m_can/tcan4x5x.c
> @@ -355,7 +355,7 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
>   	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
>   						    GPIOD_OUT_HIGH);
>   	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
> -		if (PTR_ERR(tcan4x5x->power) == -EPROBE_DEFER)
> +		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
>   			return -EPROBE_DEFER;
>   
>   		tcan4x5x_disable_wake(cdev);


Acked-by: Dan Murphy <dmurphy@ti.com>

