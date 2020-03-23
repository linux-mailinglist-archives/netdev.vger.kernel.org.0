Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5433918FFA5
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCWUgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:36:42 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60678 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgCWUgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:36:42 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02NKaZOW078713;
        Mon, 23 Mar 2020 15:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584995795;
        bh=WG/uvKP9pVe+3thZYxIhRfu51InRPUkRbwl8Fn+73hg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Mm404XMGQy7Q/pBGwHuXzoqTyrKiE+w5g0fbBuGmGk6gkbg/Tt9HA4KhTvF1T3PXy
         UgPR1YWFQwA4kdSOIqJVaKeDlqkU347xHw6BpFlR8Xfe1uMeT3uHaSi3CmhtmuYJ/m
         9v4sEPPYyl1CgdngOnTI+8NZYiP5sa/n9vEM5etw=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02NKaZtK108922
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 23 Mar 2020 15:36:35 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 23
 Mar 2020 15:36:35 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 23 Mar 2020 15:36:35 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02NKaWaf106433;
        Mon, 23 Mar 2020 15:36:33 -0500
Subject: Re: [PATCH] net: phy: dp83867: w/a for fld detect threshold
 bootstrapping issue
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <dmurphy@ti.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>, <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>
References: <20200317180454.22393-1-grygorii.strashko@ti.com>
 <20200321.201022.719210614219273669.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <e2f46a8d-b544-e31c-c994-672012bea866@ti.com>
Date:   Mon, 23 Mar 2020 22:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200321.201022.719210614219273669.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/03/2020 05:10, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Tue, 17 Mar 2020 20:04:54 +0200
> 
>> When the DP83867 PHY is strapped to enable Fast Link Drop (FLD) feature
>> STRAP_STS2.STRAP_ FLD (reg 0x006F bit 10), the Energy Lost Threshold for
>> FLD Energy Lost Mode FLD_THR_CFG.ENERGY_LOST_FLD_THR (reg 0x002e bits 2:0)
>> will be defaulted to 0x2. This may cause the phy link to be unstable. The
>> new DP83867 DM recommends to always restore ENERGY_LOST_FLD_THR to 0x1.
>>
>> Hence, restore default value of FLD_THR_CFG.ENERGY_LOST_FLD_THR to 0x1 when
>> FLD is enabled by bootstrapping as recommended by DM.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Applied, thank you.
> 

Thank you.

> Let me know if I should queue this up for -stable.
> 

yes, please, as there are real link instability issues were observed without this change.


-- 
Best regards,
grygorii
