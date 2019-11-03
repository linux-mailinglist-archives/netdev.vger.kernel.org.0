Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF98ED2C0
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 10:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKCJhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 04:37:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:36685 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfKCJhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 04:37:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572773801;
        bh=TA237as3MkBMt+PvwCKcVcJOsWdyK8OPmU07tKyOyn0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FVzT/B3m9lNlbmFkRm4TbIGivPYcotkQrhmf2wLmI0urE435A0kpL5ijebUenc8dd
         wdFi9DfMD8wcwghqIqItEl3gySpNuvyIcYN08lNy4PMDwuJ9wN0XSPb3Rgz5wB8Hei
         4M6GTKBztAv/ps4cuYvan18EZ4zSHxX/p8eABPeg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIdeX-1iDBXx3PrJ-00EbP9; Sun, 03
 Nov 2019 10:36:40 +0100
Subject: Re: [PATCH RFC V2 2/6] net: bcmgenet: Avoid touching non-existent
 interrupt
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        Eric Anholt <eric@anholt.net>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-arm-kernel@lists.infradead.org
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
 <1572702093-18261-3-git-send-email-wahrenst@gmx.net>
 <4c88389b-7aad-7a87-8443-3a368690edd7@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <cbf6593a-c455-3e51-6e3e-d45752e4a6a1@gmx.net>
Date:   Sun, 3 Nov 2019 10:36:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4c88389b-7aad-7a87-8443-3a368690edd7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:djwRaN4u4Lqh5MkbBJrR1HlFa0l3kKBD7sqslIPt4AZGUkKjsMw
 NUNtGGi6LShga171+MIdBnGw0UAcKppP/F3mQTMZrwDKugX+UT1VWTpo5Poy1to6//XPTSW
 MbixxjJS2NRj0GfPNVbfL0MBhKBtaTK5fJZyVO9GcZ3AyMo0xO162AP6r+YuA7AAxalkr6j
 +D/pAewA2fB2JHkHCOyAg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dlmr4RIN578=:AYyLOjRcjKcgULSIryBxMC
 nFGM7jefgUYZHOMbYriOMi8RzeWPP0WU9aTFzkR1cmF2TBpmizCSG/aAwEZBRh8lx45/Fu73f
 XbcptMQk6/Od4pS9dyopGY5vDkJ3xV+8KkukM+0rU+GKFPhn0lwyAYFwTGoJpzyqaJG87UOUK
 BuCxeOFWbwMDjiyXSDNSC1tcj1217T1yaxWLWh734BCLKj4GTBPJkd8W/WFAo6E20/+Webfsk
 MOxkVLo6LhZkx2QqHt2P8/fYti1qmHxQkbrWraU5zCsWCVL0prFvV3QxKDPKGCWZtsYuuxWmt
 voIhMRXrnIEyar3/WqwJhsdMXvz4U2GONThqAjJ0wMOFwgyhxpgyduZ378/prHgQAFAyLrtD6
 507nNcuG2iEXgdasgMr4OMoyZ/MpSkgqvZ7NZZAgQv0LIAqUkt5lJ4ygAV+hzWhg7c9hFqCTe
 0E2AQAgAKXYvJJlbaImQEJZ+UOocR8T5Lgs8Lx/tY2EMWMo0MQ4prtYqLo5E1fZc4PtHlvW7x
 THW43RbuZhMAvf32EiEGGjPppXPLETUWuuq2u/bm7iOhZigCSAlSKTnHoJUQs5KTIeMZgVB7W
 g6P9h0BhIfj+9t87tddnPAJAnK/5V+ibLONzdnx71dHflQBsclipDBvDmsFHTL4Rt7E91TI+o
 NsRcgaYfE+n02ar+IJ5Sv4JLvvpEBk4wJW8tMaeySMBZubExjIL1VdtME24GpuzQetdlI49yP
 ZgF5Z+j8kHCEXaARM5kBlheCwkgDfyEESwP5YDeU/cBTdg3K/mHImi/QB7ndtF33KW41O66Gi
 GqlTBI3lttjNPzfV5r5xFH0mZN2GI60oosWr34QFJ7sS1SmoMJ4yvUoh/kTEsNg6YoFTdvZuh
 fbe1lYdGYPPInWMiqedzj9ZP5HG2u1ZAClmYoRzp92rcp9030JzHvWQD/LRUo05bJ06T0OZTH
 JRXZSGolpPUFn8wzfkUtOEkLFTUgVJkjVBHytcFyyF/PBgooHA9Yx94DIJ7aRuPSusyWL6YwU
 SuT2rraZ1IQGbmkxzKkkVUxuBnP9DOBAZXQDHUYo5Ajf0zEMl7EeD7j1HawcUJ95y+jtRY5zn
 BvQrjUtyCd9ksNqO8kCbwVq9/uXxvk7cLAJST5attZZejRcbL9rGmUHQynrSi7F1KbVEesm/e
 GV6449qXPbVk+VR27ug0gHjS+c+ktlI65JY74KSPHBBcCuQ1oT9TLZR8GDjSgvzSlhVOGCOAL
 FGRIFgRoutqT5+DV6Ya1MkP5l4A7yW0qsW6q1EHEXsomZ/LGK96eUFf3D4MM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.11.19 um 20:34 schrieb Florian Fainelli:
> On 11/2/2019 6:41 AM, Stefan Wahren wrote:
>> As platform_get_irq() now prints an error when the interrupt does not
>> exist, we are getting a confusing error message in case the optional
>> WOL IRQ is not defined:
>>
>>   bcmgenet fd58000.ethernet: IRQ index 2 not found
>>
>> Fix this by using the platform_irq_count() helper to avoid touching a
>> non-existent interrupt.
>>
>> Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> ---
>>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index 105b3be..ac554a6 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -3473,7 +3473,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
>>  		err = priv->irq1;
>>  		goto err;
>>  	}
>> -	priv->wol_irq = platform_get_irq(pdev, 2);
>> +	if (platform_irq_count(pdev) > 2)
>> +		priv->wol_irq = platform_get_irq(pdev, 2);
> Or you could use platform_get_irq_optional() for the WoL IRQ line?
Yes, this would be better.
