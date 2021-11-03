Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D830444877
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 19:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhKCSpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 14:45:13 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47646 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 14:45:12 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A3IgNV1077205;
        Wed, 3 Nov 2021 13:42:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635964943;
        bh=ITh8datjcB1pR9d1o9fFJSmT+Wo30raT9v1X19SdMQU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=r2L8ZK+976zJKHazeiaAw46F0Yf0BMms8ZlO7CmrCp6VxsLv15hmFtMnHPgWbo8DG
         3ZM9vfcqY2tX+wWWzn+CB1qZbGw93Bt6doLnc0gVuUOfQpehApvriTw8WfKJEJtTk5
         UtjDZpLqjDV05msQKJrbSYRbJL1SZHIlCOSF5k8U=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A3IgNUV033583
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Nov 2021 13:42:23 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 3
 Nov 2021 13:42:23 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 3 Nov 2021 13:42:22 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A3IgJiA076322;
        Wed, 3 Nov 2021 13:42:20 -0500
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk> <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com> <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com> <YYHXcyCOPiUkk8Tz@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <01a0ebf9-5d3f-e886-4072-acb9bf418b12@ti.com>
Date:   Wed, 3 Nov 2021 20:42:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYHXcyCOPiUkk8Tz@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/11/2021 02:27, Andrew Lunn wrote:
>>> What i find interesting is that you and the other resent requester are
>>> using the same user space tool. If you implement C45 over C22 in that
>>> tool, you get your solution, and it will work for older kernels as
>>> well. Also, given the diverse implementations of this IOTCL, it
>>> probably works for more drivers than just those using phy_mii_ioctl().
>>
>> Do you mean change uapi, like
>>   add mdio_phy_id_is_c45_over_c22() and
>>   flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?
> 
> No, i mean user space implements C45 over C22. Make phytool write
> MII_MMD_CTRL and MII_MMD_DATA to perform a C45 over C22.

Now I give up - as mentioned there is now way to sync User space vs Kernel
MMD transactions and so no way to get trusted results.


Thanks all for participating in discussion.

-- 
Best regards,
grygorii
