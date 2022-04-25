Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1630550E4EA
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbiDYP6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbiDYP6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:58:39 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44A13C739;
        Mon, 25 Apr 2022 08:55:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a15so15171703pfv.11;
        Mon, 25 Apr 2022 08:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hj2WQEXgtYZET1/PaZfEKKBYEubWRIUuesWvAxgw9ic=;
        b=pxsOU1Sy33UHeBh+xTz2V2458CDIVGF4MUItqhkNnvl2+lrPUmKOGO6K3Iwpx9YmfX
         xHmdxAQH1FaB63/43UEBro9q6kGVWIVVmnXgrOvidqLXeoTq1afvz2mDg1LiYA+8Jz2r
         buCy7MPfKmIXPQC4J/XgF61wTd7eqMvRPLjQC4daUIUkbt9O3DDOtWm4BMI4vP4ptG7y
         9stHRPCfALu9lhCWAOeDsgna3hcN0emG6C7ZyOk3VsO49foGN5ScX/yhQxZoyj4vmpch
         wQVuzx5ivalnHSh6KbZ/+jEQSCaJSwyh8bSKQHRJkCMay6vz+lSudqoPJa+tdfsW9K9p
         Er6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hj2WQEXgtYZET1/PaZfEKKBYEubWRIUuesWvAxgw9ic=;
        b=BoJozXYp0mKieGQIj0uKGrGqQR36KkT2CyMQim1/vK/Na8QGT1L1ksF0V5jyOR7BbQ
         rqax9MR6M7wcoPgMruyQUXkznIxeHk7adjL9JOw6ijO509gzFME0wCsSG8YQpsRAKHwT
         4Yj/e/9EiUk6hfACJp5ISTBcPzb1YysuuzSPCYMUpSFxzgUkB1XpftA8NTeGw2XokDiJ
         dhUJ+G/azIPX9XSQQChE1Wy7hcbxeYMUvUpa/8q+t2dG4iFoTtJY67rdRNe4e7SAsVrh
         Erc83+MCjODlWFb6xNwVj3kIzfr3TM0ImjwBSuMyo5dAaqIstab2kZFCpoXa7ym1uzlJ
         NzWQ==
X-Gm-Message-State: AOAM531JAzyla5ongC46coSx99hZ6TRJlW4bqHFs8YQ+htM4kUBIeMu6
        ey2eih4jr50Cmb1okzBQ4V4=
X-Google-Smtp-Source: ABdhPJxrt9TR/uKk3n3daDw6LV/6PdxBko3JOIDO1G9fKyUjo0xtJP/PNylMEIYFcnNnZSB5dfpFcQ==
X-Received: by 2002:a63:8b49:0:b0:3ab:20c3:1992 with SMTP id j70-20020a638b49000000b003ab20c31992mr7016275pge.567.1650902135221;
        Mon, 25 Apr 2022 08:55:35 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 123-20020a620681000000b004fa7c20d732sm11784299pfg.133.2022.04.25.08.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 08:55:34 -0700 (PDT)
Message-ID: <966cad79-f5e2-7193-eb7d-e31ad117fbf0@gmail.com>
Date:   Mon, 25 Apr 2022 08:55:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: phy: fix error check return value of phy_read()
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, cgel.zte@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220419014439.2561835-1-lv.ruyi@zte.com.cn>
 <Yl6mH0HKCGPxgejI@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yl6mH0HKCGPxgejI@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/2022 5:07 AM, Andrew Lunn wrote:
> On Tue, Apr 19, 2022 at 01:44:39AM +0000, cgel.zte@gmail.com wrote:
>> From: Lv Ruyi <lv.ruyi@zte.com.cn>
>>
>> phy_read() returns a negative number if there's an error, but the
>> error-checking code in the bcm87xx driver's config_intr function
>> triggers if phy_read() returns non-zero.  Correct that.
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
>> ---
>>   drivers/net/phy/bcm87xx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
>> index 313563482690..e62b53718010 100644
>> --- a/drivers/net/phy/bcm87xx.c
>> +++ b/drivers/net/phy/bcm87xx.c
>> @@ -146,7 +146,7 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
>>   
>>   	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
>>   		err = phy_read(phydev, BCM87XX_LASI_STATUS);
>> -		if (err)
>> +		if (err < 0)
>>   			return err;
> 
> This should probably have a Fixes: tag, and be for net, not next-next.
> Please read the netdev FAQ about the trees, and submittinng fixes for
> netdev.

Yes, it should be:

Fixes: 15772e4ddf3f ("net: phy: broadcom: remove use of ack_interrupt()")

Also, please subject this change properly with:

net: phy: bcm87xx: Added missing error checking

Thank you
-- 
Florian
