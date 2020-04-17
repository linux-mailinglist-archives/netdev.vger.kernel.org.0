Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB311ADCE3
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgDQMHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 08:07:03 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41036 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgDQMHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 08:07:02 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03HC6hnv000596;
        Fri, 17 Apr 2020 07:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587125203;
        bh=EzH3YxuoL3K+W9EnJg8cY1fwb5eXAbwJZcryLRdN1Y8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vJucq13R7ulppcwNJZG0rFJc2a35ib1Y353Veb0NlAjhcxlHtKfBKUGLfG7S+2wtR
         WB3/wcWP/LPVxVOC7rjdn3ZQwqrITu20Ckp0Q2Ia34VFAWTYhvCNKbYR6BGTXX4yN6
         6vAeMgiaa0U6Ob5YKwGxRDcXF0VBD0NA1SjMM5Cc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03HC6hPk111509
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Apr 2020 07:06:43 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 17
 Apr 2020 07:06:43 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 17 Apr 2020 07:06:43 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03HC6g4x072420;
        Fri, 17 Apr 2020 07:06:42 -0500
Subject: Re: [PATCH] can: tcan4x5x: Replace depends on REGMAP_SPI with depends
 on SPI
To:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        <linux-kernel@vger.kernel.org>
CC:     Collabora Kernel ML <kernel@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200413141013.506613-1-enric.balletbo@collabora.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <fd411219-f528-683c-ab39-1786a99c392b@ti.com>
Date:   Fri, 17 Apr 2020 07:00:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200413141013.506613-1-enric.balletbo@collabora.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enric

On 4/13/20 9:10 AM, Enric Balletbo i Serra wrote:
> regmap is a library function that gets selected by drivers that need
> it. No driver modules should depend on it. Instead depends on SPI and
> select REGMAP_SPI. Depending on REGMAP_SPI makes this driver only build
> if another driver already selected REGMAP_SPI, as the symbol can't be
> selected through the menu kernel configuration.
>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> ---
>
>   drivers/net/can/m_can/Kconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
> index 1ff0b7fe81d6..c10932a7f1fe 100644
> --- a/drivers/net/can/m_can/Kconfig
> +++ b/drivers/net/can/m_can/Kconfig
> @@ -16,7 +16,8 @@ config CAN_M_CAN_PLATFORM
>   
>   config CAN_M_CAN_TCAN4X5X
>   	depends on CAN_M_CAN
> -	depends on REGMAP_SPI
> +	depends on SPI
> +	select REGMAP_SPI
>   	tristate "TCAN4X5X M_CAN device"
>   	---help---
>   	  Say Y here if you want support for Texas Instruments TCAN4x5x


Reviewed-by: Dan Murphy <dmurphy@ti.com>

