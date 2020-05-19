Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9691D9E0A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgESRkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:40:32 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57010 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESRkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:40:32 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JHeNuo109271;
        Tue, 19 May 2020 12:40:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589910023;
        bh=VX4f7WP5h5tP5wO/LCu7/oJFxzbn0P5tW145XSts88M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HGsyShS+68FjBKbB726Pqpf1jKI/ImCc8oEbZPH+ubWpCyIUJkr/6MbAXXy55wTDY
         yt99z9g9U4h81mhLULuM/ROZKDPbqaJn3w1Qd/1RmEznIuvVqmGDY9/PErNgrK8ZUt
         /aIqULyXSxglJknmt7nRpqxl4mny5zqR/L5FWGeo=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04JHeNmq082597
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 12:40:23 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 12:40:23 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 12:40:23 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JHeNI3102491;
        Tue, 19 May 2020 12:40:23 -0500
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200519141813.28167-1-dmurphy@ti.com>
 <20200519141813.28167-3-dmurphy@ti.com>
 <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <65e1b5ca-680e-f82d-cde4-3d5a3eb40884@ti.com>
Date:   Tue, 19 May 2020 12:40:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 5/19/20 11:58 AM, Jakub Kicinski wrote:
> On Tue, 19 May 2020 09:18:11 -0500 Dan Murphy wrote:
>> If the op-mode for the device is not set in the device tree then set
>> the strapped op-mode and store it for later configuration.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ../drivers/net/phy/dp83869.c: In function0 dp83869_set_strapped_mode:
> ../drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
>    171 |  if (val < 0)
>        |          ^

This looks to be a false positive.

phy_read_mmd will return an errno or a value from 0->15

So if errno is returned then this will be true.

Unless I have to do IS_ERR.

I did not get that warning.  But I am using 9.2-gcc.

What compiler are you using?

Dan

