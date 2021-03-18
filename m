Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD64340044
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCRHak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhCRHaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:30:30 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F30C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 00:30:30 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j11so2972550lfg.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 00:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LVqWXWpPGB/J0FM6Yc08PPeeO6lAl4ydgiHpMS7WhQ0=;
        b=MFptWpypwMY5wsUPSI/dmvDQllL12c05aDA4Fza4wCKIyOzLSTjbgH73jk04hCzF8M
         uk56z9kxFdKuWFaeKSNusBn9UYAgNoajyvyHt3mvhUa0R8KVd8egcCvrtX5GDUxmJgf8
         6ubIPhuTPrxFAJ8NGRmHEA/v6YfzuwdAdp/pSpzB955O/zz6ZSbC9sMVu1Vr+tJj1y8s
         rURBj3DqnIlHzprVG5fFngTNzNLy6JlK2OFoCYV8oWqJYLubi81ryzAqABjkD5Lm6ewm
         47IvnYufAi1mOEd9txzgpoUGamhan5yJA0j3IZtdzrIRZsRYSjjrv/onXoobra5qcL1O
         uT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LVqWXWpPGB/J0FM6Yc08PPeeO6lAl4ydgiHpMS7WhQ0=;
        b=OWECEmd8YmFGeugCKItMYMNXXJjFjUX/d90lQrcVPgsBzRXPEc5MVx0tnqtkwPd1Fn
         v8qxVznreaz/VrjV4dVo/ng9He7iF4ERKosDh8UuScXN/8JaiTiRRQ7ohsFKUds3qiG+
         5HG1QzoMPbbeK6MrzbwJYbvTtxhwgQUMVyP0j2lq4CAPkXYuljlM5dkWW8tWEHEbbFkS
         uCrGk8oUaCuVsPf4zdwKmwu8ONi+dtfIGafCh4sBKxvCntwU7/8zm6EDf7ARAeLSrR8h
         FNmGlfw5iVTwIgmyyts0TqhM4I+7+xalzau1yPYF0EYQnOvcqiUHXcnfQnr382Y05YCx
         WM7A==
X-Gm-Message-State: AOAM530h0jd63pUz5RPglvynbR9Aeze2Eqb0g8iDDCB0nSEsxtfIlv5g
        LtIKkvVH08P4Ke9d1cI8xJc=
X-Google-Smtp-Source: ABdhPJxVxmSrKAyhiRayVHwiIcUwS8b3tGGkpZEat3MoYtfglrkVSIY/2Vbm7wdP5RIbPBU64pfe+w==
X-Received: by 2002:ac2:4465:: with SMTP id y5mr4555466lfl.70.1616052628558;
        Thu, 18 Mar 2021 00:30:28 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id e25sm135721ljo.113.2021.03.18.00.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 00:30:28 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: bcm_sf2: add function finding RGMII
 register
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210317143706.30809-1-zajec5@gmail.com>
 <20210317143706.30809-2-zajec5@gmail.com>
 <49f01c3d-7149-299e-d191-7ffdfb975039@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <ebd5018c-35af-60b7-d44b-e583ec18f2e7@gmail.com>
Date:   Thu, 18 Mar 2021 08:30:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <49f01c3d-7149-299e-d191-7ffdfb975039@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.03.2021 22:20, Florian Fainelli wrote:
> On 3/17/2021 7:37 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
>> 1. It doesn't validate port argument
>> 2. It doesn't support chipsets with non-lineral RGMII regs layout
>>
>> Missing port validation could result in getting register offset from out
>> of array. Random memory -> random offset -> random reads/writes. It
>> affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).
> 
> That is entirely fair, however as a bug fix this is not necessarily the
> simplest way to approach this.

I'm not sure if I understand. Should I fix it in some totally different
way? Or should I just follow your inline suggestions?


>> Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   drivers/net/dsa/bcm_sf2.c      | 51 ++++++++++++++++++++++++++++++----
>>   drivers/net/dsa/bcm_sf2_regs.h |  2 --
>>   2 files changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>> index ba5d546d06aa..942773bcb7e0 100644
>> --- a/drivers/net/dsa/bcm_sf2.c
>> +++ b/drivers/net/dsa/bcm_sf2.c
>> @@ -32,6 +32,30 @@
>>   #include "b53/b53_priv.h"
>>   #include "b53/b53_regs.h"
>>   
>> +static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
> 
> This is not meant to be used outside the file, so I would be keen on
> removing the bcm_sf2_ prefix to make the name shorter and closer to the
> original macro name.

Most or all local functions use such a prefix. E.g.:
bcm_sf2_num_active_ports()
bcm_sf2_recalc_clock()
bcm_sf2_imp_setup()
bcm_sf2_gphy_enable_set()
bcm_sf2_port_intr_enable()
bcm_sf2_port_intr_disable()
bcm_sf2_port_setup()
bcm_sf2_port_disable()

It would be inconsistent to have RGMII reg function not follow that.


>> +{
>> +	switch (priv->type) {
>> +	case BCM4908_DEVICE_ID:
>> +		/* TODO */
>> +		break;
>> +	default:
>> +		switch (port) {
>> +		case 0:
>> +			return REG_RGMII_0_CNTRL;
>> +		case 1:
>> +			return REG_RGMII_1_CNTRL;
>> +		case 2:
>> +			return REG_RGMII_2_CNTRL;
>> +		default:
>> +			break;
>> +		}
>> +	}
>> +
>> +	WARN_ONCE(1, "Unsupported port %d\n", port);
>> +
>> +	return 0;
> 
> maybe return -1 or -EINVAL just in case 0 happens to be a valid offset
> in the future. Checking the return value is not necessarily going to be
> helpful as it needs immediate fixing, so what we could do is keep the
> WARN_ON, and return the offset of REG_SWITCH_STATUS which is a read-only
> register. This will trigger the bus arbiter logic to return an error
> because a write was attempted from a read-only register.
> 
> What do you think?

Great, thanks!
