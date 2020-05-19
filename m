Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6EB1D9FBA
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgESSlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:41:53 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51672 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESSlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:41:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JIfjkO053693;
        Tue, 19 May 2020 13:41:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589913705;
        bh=GLDfaTKUNFaww2qeQ7ar1unuT0uERBavkAEEdjsusNs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=e/KIP5lJA1mE1DLItbytQN+Xfjlt3S7jX4LTz+S1WE1By8Q1iWr8cZ2tZAABix1yJ
         lf8zhJo4/r2lfJ4gVnXFn+1Ti3uoNVKzx0AMY3wLwANtK+49H6AkQ5GK4J3Gs6ZvK3
         7guPrn9jyd716CHgCGS28zgHZO/pIq+ovoRdUj64=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JIfjjD001933;
        Tue, 19 May 2020 13:41:45 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 13:41:45 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 13:41:45 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JIfjMK076058;
        Tue, 19 May 2020 13:41:45 -0500
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200519141813.28167-1-dmurphy@ti.com>
 <20200519141813.28167-3-dmurphy@ti.com>
 <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200519182916.GM624248@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <c45bae32-d26f-cbe5-626b-2afae4a557b3@ti.com>
Date:   Tue, 19 May 2020 13:41:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519182916.GM624248@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/19/20 1:29 PM, Andrew Lunn wrote:
> On Tue, May 19, 2020 at 09:58:18AM -0700, Jakub Kicinski wrote:
>> On Tue, 19 May 2020 09:18:11 -0500 Dan Murphy wrote:
>>> If the op-mode for the device is not set in the device tree then set
>>> the strapped op-mode and store it for later configuration.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ../drivers/net/phy/dp83869.c: In function0 dp83869_set_strapped_mode:
>> ../drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
>>    171 |  if (val < 0)
>>        |          ^
> Hi Jakub
>
> This happens a lot with PHY drivers. The register being read is a u16,
> so that is what people use.

Yes this is what happened but phy_read_mmd returns an int so the 
declaration of val should be an int.

I will update that in v2


> Is this now a standard GCC warning? Or have you turned on extra
> checking?
I still was not able to reproduce this warning with gcc-9.2.  I would 
like to know the same


Dan

