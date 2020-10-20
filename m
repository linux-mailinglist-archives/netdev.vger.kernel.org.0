Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B16A2942C5
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437992AbgJTTO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:14:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:52766 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390695AbgJTTO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 15:14:28 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09KJENMj040352;
        Tue, 20 Oct 2020 14:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603221263;
        bh=rq754Vqcj0asto5tv94NCjKiITcNWnK048kvmYNEa5I=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=y2KYYxZNNv/oYZ6cVgehV4Mz6FZWaeCKg72DWyS79aZqPGA9lLQXuaxb95TrMT+Bv
         wP2ixEk/LvFccJA69L7ZuqY1UTmsfQv4YxLFY0kFT7Z2P+NQ/Dw4aCIP0uP95LbEAf
         9LtSrV90F4U0CsdkwSUUDxwi9bbw+pzysFir8Gxc=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09KJENxV037733
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 14:14:23 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 20
 Oct 2020 14:14:23 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 20 Oct 2020 14:14:23 -0500
Received: from [10.250.39.65] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09KJEMep055605;
        Tue, 20 Oct 2020 14:14:22 -0500
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201020171221.730-1-dmurphy@ti.com>
 <20201020171221.730-3-dmurphy@ti.com> <20201020185601.GJ139700@lunn.ch>
 <20201020190717.GK139700@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <331e3c73-38ca-3224-c682-5ed3a4ed9f73@ti.com>
Date:   Tue, 20 Oct 2020 14:14:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201020190717.GK139700@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 10/20/20 2:07 PM, Andrew Lunn wrote:
>> Humm. Are 1v and 2.4v advertised so it can be auto negotiated? Maybe a
>> PHY tunable is not correct? Is this voltage selection actually more
>> like pause and EEE?
> [Goes and looks at the datasheet]
>
> Register 0x20E, bit 13:
>
> 1 = Advertise that the 10BASE-T1L PHY has increased transmit/
> receive level ability
> 0 = Do not advertise that the 10BASE-T1L PHY has increased
> transmit/receive level ability (default)
>
> So does this mean 2.4v?

This can also be strapped to a certain voltage level.  The device may 
not have the regulators on board to drive a 2.4v signal. 1v signal AVDD 
is 1.8v and 2.4v the AVDD needs to be at least 3.3v


This Strap defines the voltage level
requested by PHY during auto
negotiation. It is reflected in bit 12 of
0x20E. While using Force mode for
Linkup, the strap controls the output
voltage and reflects in bit 12 of 0x18F6

Bit 12

1 = Enable 2.4 Vpp operating mode
0 = Enable 1.0 Vpp operating mode

So maybe this is a hybrid of tunable for master/slave and a DT for 
voltage level since the ability of the board to drive the signal can vary.

Dan


>   	Andrew
