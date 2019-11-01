Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B18EC9CC
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfKAUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:46:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:49190 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAUqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 16:46:18 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1KkAFO125498;
        Fri, 1 Nov 2019 15:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572641170;
        bh=zybgR7hDF/o4db+iKiuX3H8IVivapUrRQjOn5yGa7K8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=otXhBIFK/UWifwkl7A3yKL1MaKFpvk1+SsSgCvQpHNfBhk8PnSMnhQEnZNzwgOFyF
         xLYwYNBDB1UhUieFQKE+yzeXoGf3ni5chqRp2+k6XsXPq59N6FQUMQoMF5E2tEFnAD
         WQ1xdXTH59r03zrOb+IUWXr1nwV4Puyqp3+QY3do=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1KkAJG041314;
        Fri, 1 Nov 2019 15:46:10 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 15:45:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 15:45:56 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1Kk6n3017157;
        Fri, 1 Nov 2019 15:46:07 -0500
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029122422.GL15259@lunn.ch>
 <d87c72e1-cb91-04a2-c881-0d8eec4671e2@ti.com>
 <20191101203913.GD31534@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8f3eb934-7dcd-b43a-de96-6a864ef67c92@ti.com>
Date:   Fri, 1 Nov 2019 22:46:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101203913.GD31534@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2019 22:39, Andrew Lunn wrote:
>>>> +static const struct devlink_ops cpsw_devlink_ops;
>>>
>>> It would be nice to avoid this forward declaration.
>>
>> It's not declaration, it's definition of devlink_ops without any standard callbacks implemented.
> 
> Ho Grygorii
> 
> Ah, yes.
> 
> How about
> 
> = {
>    };
> 
> to make it clearer?

NP

> 
>>>> +static const struct devlink_param cpsw_devlink_params[] = {
>>>> +	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_ALE_BYPASS,
>>>> +			     "ale_bypass", DEVLINK_PARAM_TYPE_BOOL,
>>>> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
>>>> +			     cpsw_dl_ale_ctrl_get, cpsw_dl_ale_ctrl_set, NULL),
>>>> +};
>>>
>>> Is this documented?
>>
>> In patch 9. But I'll update it and add standard devlink parameter definition, like:
>>
>> ale_bypass	[DEVICE, DRIVER-SPECIFIC]
>> 		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes
>> 		Type: bool
>> 		Configuration mode: runtime
> 
> And please you the standard file naming and location,
> Documentation/networking/devlink-params-foo.txt
Ok. I will.
But I'd like to clarify:
- drivers documentation placed in ./Documentation/networking/device_drivers/ti/
so could you confirm pls, that you want me to add devlink-params documentation in separate file
and palace it in ./Documentation/networking/ folder directly?
   

-- 
Best regards,
grygorii
