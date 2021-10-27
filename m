Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0843C560
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhJ0InI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:43:08 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25489 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbhJ0InI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635324044; x=1666860044;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ei6aJ4NBv6rekmLj3yugqSXt+OtL2wsArvFXf7CSFlE=;
  b=TRL3Yn+dOWR/tEiLrjvZIIHzZl078JlXMCoQAqDF2Vhjw5btGEsDEtif
   CiyqQXyCHqOMzjjZR6InVhujfMv9RvjcJqsAI0xByyU9rUKnP2/oCJf0g
   KYkKlkxvgvz7fotEcj+Ow0D6yBxbPg6EFc1ev1DlpnXE2dgZCK4EeCsbw
   PtsxGThZfalaN0MRlQgktlLDwehfQaZSRxSpT7IBcjuVPJbvpIq5YzsBr
   4kmWilivvB1S9vZR10SywvJ/Bbd+Gi33PHez6s616Pe8RmEejEEGjGmy0
   LlbBnt6rJXvXNluq0IKRs2JPQFSqyzvru6lrpeMx+dx5nb0Azpn0aqHAw
   w==;
IronPort-SDR: luo/hmkrKwxCNiiGuDLzwUUAl2Ec3dsIBm2eO25u+bsdC7YMGKsgyakrOHm/yb/0utuOtTbSWV
 3FXN4m8DxmKP67dpxKXkckj9yY4lfH18TnXCyxYaRGsH9nrG7tFa03yyNymEKIMMB6WLm6kpLq
 YD8xZEtBCHyyGwHSkNRNlFca+Znp4Jz03tAPX9kbNjiLHPIqgff8Iz1SlxUnEOXc0iVcvDyZfW
 C0+u0BXrEoJHF6BKTs7a0/paB4i+xzbazcQuaASHekOFMVFfrMgLwHdwsUmO4LyaOsqAJUnws/
 GASWsDeEyv7VorNY2sFZRTJA
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="141228245"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 01:40:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 01:40:39 -0700
Received: from [10.171.246.59] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 27 Oct 2021 01:40:37 -0700
Subject: Re: [PATCH] net: macb: Fix mdio child node detection
To:     Claudiu Beznea - M18063 <Claudiu.Beznea@microchip.com>,
        Guenter Roeck <linux@roeck-us.net>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20211026173950.353636-1-linux@roeck-us.net>
 <c6a5361b-5199-766a-c85a-f802ca77670e@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <bdc2d3c3-546d-a007-4516-feb500a3f48b@microchip.com>
Date:   Wed, 27 Oct 2021 10:40:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c6a5361b-5199-766a-c85a-f802ca77670e@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 at 10:38, Claudiu Beznea - M18063 wrote:
> On 26.10.2021 20:39, Guenter Roeck wrote:
>> Commit 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it
>> exists") added code to detect if a 'mdio' child node exists to the macb
>> driver. Ths added code does, however, not actually check if the child node
>> exists, but if the parent node exists. This results in errors such as
>>
>> macb 10090000.ethernet eth0: Could not attach PHY (-19)
>>
>> if there is no 'mdio' child node. Fix the code to actually check for
>> the child node.
>>
>> Fixes: 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it exists")
>> Cc: Sean Anderson <sean.anderson@seco.com>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>> ---
> 
> Patch solves the failure also on sama5d2_xplained. You can add:
> 
> Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Guener, Claudiu, thanks so much!
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Best regards,
   Nicolas


>>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 309371abfe23..ffce528aa00e 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -901,7 +901,7 @@ static int macb_mdiobus_register(struct macb *bp)
>>           * directly under the MAC node
>>           */
>>          child = of_get_child_by_name(np, "mdio");
>> -       if (np) {
>> +       if (child) {
>>                  int ret = of_mdiobus_register(bp->mii_bus, child);
>>
>>                  of_node_put(child);
>> --
>> 2.33.0
>>
> 


-- 
Nicolas Ferre
