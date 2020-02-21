Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228CA1677B8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgBUInX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:43:23 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45942 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730127AbgBUHxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 02:53:38 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01L7rABf123736;
        Fri, 21 Feb 2020 01:53:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582271590;
        bh=4oe8zWumyH1U/XLfwq2hHrnruwHoFbfKJKSxe0/eD4A=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=m5iOI48LxCt9hBXs9jVzOFlNoQDGfM09SOucuNdRdLcsBPGKDvT8cTIa/2A1Mn3os
         bqsUUuzUX9mRu4cqGRLtOGsCSGHzvqYLKqk4kqDZ4eeI40lK6MgJqvswYpcFoDT0Yq
         bUft9eWP9YpyyHFYDM49x2uuO8EZZX7KIr4Ct3fQ=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01L7rA9Q023230
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Feb 2020 01:53:10 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 21
 Feb 2020 01:53:09 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 21 Feb 2020 01:53:09 -0600
Received: from [172.24.190.4] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01L7r5hr091996;
        Fri, 21 Feb 2020 01:53:05 -0600
Subject: Re: [PATCH v2 2/3] can: m_can: m_can_platform: Add support for
 enabling transceiver
To:     Dan Murphy <dmurphy@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-3-faiz_abbas@ti.com>
 <250f905a-33c3-dd17-15c9-e282299dd742@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <8885c00b-7b73-0448-7e9d-ecb19fe84adf@ti.com>
Date:   Fri, 21 Feb 2020 13:24:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <250f905a-33c3-dd17-15c9-e282299dd742@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On 17/02/20 8:40 pm, Dan Murphy wrote:
> Faiz
> 
> On 2/17/20 8:28 AM, Faiz Abbas wrote:
>> CAN transceivers on some boards have a standby line which can be
>> toggled to enable/disable the transceiver. Model this as an optional
>> fixed xceiver regulator.
>>
>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>> Acked-by: Sriram Dash <sriram.dash@samsung.com>
>> ---
>>   drivers/net/can/m_can/m_can_platform.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/can/m_can/m_can_platform.c
>> b/drivers/net/can/m_can/m_can_platform.c
>> index 38ea5e600fb8..719468fab507 100644
>> --- a/drivers/net/can/m_can/m_can_platform.c
>> +++ b/drivers/net/can/m_can/m_can_platform.c
>> @@ -6,6 +6,7 @@
>>   // Copyright (C) 2018-19 Texas Instruments Incorporated -
>> http://www.ti.com/
>>     #include <linux/platform_device.h>
>> +#include <linux/regulator/consumer.h>
>>     #include "m_can.h"
>>   @@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device
>> *pdev)
>>   {
>>       struct m_can_classdev *mcan_class;
>>       struct m_can_plat_priv *priv;
>> +    struct regulator *reg_xceiver;
>>       struct resource *res;
>>       void __iomem *addr;
>>       void __iomem *mram_addr;
>> @@ -111,6 +113,10 @@ static int m_can_plat_probe(struct
>> platform_device *pdev)
>>         m_can_init_ram(mcan_class);
>>   +    reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
>> +    if (PTR_ERR(reg_xceiver) == -EPROBE_DEFER)
>> +        return -EPROBE_DEFER;
>> +
> 
> Where is this regulator enabled?

I have set regulator-boot-on flag in the dt so this didn't require an
enable.

> Shouldn't the regulator be managed by runtime PM as well?
> 

Let me try this out.

Thanks,
Faiz

