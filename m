Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20643945EF
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhE1QeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:34:19 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54380 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbhE1QeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:34:01 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14SGWGeS091767;
        Fri, 28 May 2021 11:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1622219536;
        bh=mlabxwIUmJFkYFKeFMhvWL8tbMeOxSHxBp7TYwP5BOQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vJm+LL5rVRUToWebdqcqbvHrgU5XMngULq5+lI7fxEVuRo2SADSJ9JiWSB904eGLy
         rZ1WkjhxPYSTIZi/cKKgp4NKzylJEi2/v+uHD4Url6BT3k4FQ4IO3bKLec5Ywlvay8
         582svwshumR35H/+Mpvmnu1sbCyN+p12dg29VDW8=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14SGWFCi004590
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 May 2021 11:32:16 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 28
 May 2021 11:32:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 28 May 2021 11:32:15 -0500
Received: from [10.247.25.23] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14SGWFln109073;
        Fri, 28 May 2021 11:32:15 -0500
Subject: Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform soft reset and
 retain established link
To:     Andrew Lunn <andrew@lunn.ch>, "Modi, Geet" <geet.modi@ti.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch> <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch>
From:   "Bajjuri, Praneeth" <praneeth@ti.com>
Message-ID: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
Date:   Fri, 28 May 2021 11:32:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YGSk4W4mW8JQPyPl@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 3/31/2021 11:35 AM, Andrew Lunn wrote:
>>      > as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
>>
>>      > 8.6.26 Control Register (CTRL)
>>      > do SW_RESTART to perform a reset not including the registers and is
>>      > acceptable to do this if a link is already present.
>>
>>   
>>
>>      I don't see any code here to determine if the like is present. What if
>>      the cable is not plugged in?
>>
>>      This API is primarily used for reset. Link Status is checked thru different
>> register. This shall not impact the cable plug in/out. With this change, it
>> will align with DP83822 driver API.
> 
> So why is there the comment:
> 
>>      >                                            and is
>>      > acceptable to do this if a link is already present.
> 
> That kind of says, it is not acceptable to do this if the link is not
> present. Which is why i'm asking.

Does the feedback from Geet help in clarity you requested.
Ref:
https://lore.kernel.org/netdev/4838EA12-7BF4-4FF2-8305-7446C3498DDF@ti.com/

> 
> 	 Andrew
> 
