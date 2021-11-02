Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9403B44364D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhKBTPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:15:46 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37258 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBTPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 15:15:45 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A2JCiXa068572;
        Tue, 2 Nov 2021 14:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635880364;
        bh=SBcWv8IuDwt6CEmB+nJa+eEEs/ZFYCeP0/GIllCBAl0=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=Z+PsH0b6GnQkVbZwTdBqydxoGFHS7bP92iZpmRi9BHz6QnLEQn/xbxt+flAu3wvQ8
         uC6FOANWeZKw4oK/KQCZJYCX0DCvRUdHC2Gnl5uSQMZwgf9lNv10Ednu84BOICDB2f
         kpcVaUsKRppyRBas0dd6rjJBsBzMERPP3gdhGM5k=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A2JCixM101261
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Nov 2021 14:12:44 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 2
 Nov 2021 14:12:43 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 2 Nov 2021 14:12:43 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A2JCfm2059686;
        Tue, 2 Nov 2021 14:12:42 -0500
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch> <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch> <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
Message-ID: <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
Date:   Tue, 2 Nov 2021 21:12:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2021 20:37, Grygorii Strashko wrote:
> Hi Russell, Andrew,
> 
> Thanks a lot for you comments.
> 
> On 02/11/2021 19:41, Russell King (Oracle) wrote:
>> On Tue, Nov 02, 2021 at 07:19:46PM +0200, Grygorii Strashko wrote:
>>> It would require MDIO bus lock, which is not a solution,
>>> or some sort of batch processing, like for mmd:
>>>   w reg1 val1
>>>   w reg2 val2
>>>   w reg1 val3
>>>   r reg2
>>>
>>> What Kernel interface do you have in mind?
>>
>> That is roughly what I was thinking, but Andrew has basically said no
>> to it.
>>
>>> Sry, but I have to note that demand for this become terribly high, min two pings in months
>>
>> Feel free to continue demanding it, but it seems that at least two of
>> the phylib maintainers are in agreement that providing generic
>> emulation of C45 accesses in kernel space is just not going to happen.
>>
> 
> not ready to give up.
> 
> One more idea how about mdiobus_get_phy(), so we can search for PHY and
> if present try to use proper API phy_read/phy_write_mmd?
> 
> 

smth like below
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c83d..8ebe59b5647d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -285,6 +285,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
         u16 val = mii_data->val_in;
         bool change_autoneg = false;
         int prtad, devad;
+       struct phy_device *phydev_rq = phydev;
  
         switch (cmd) {
         case SIOCGMIIPHY:
@@ -300,8 +301,18 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
                         prtad = mii_data->phy_id;
                         devad = mii_data->reg_num;
                 }
-               mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
-                                                devad);
+
+               if (prtad != phydev->mdio.addr)
+                       phydev_rq = mdiobus_get_phy(phydev->mdio.bus, prtad);
+
+               if (!phydev_rq) {
+                       mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
+               } else if (mdio_phy_id_is_c45(mii_data->phy_id) && !phydev->is_c45) {
+                       mii_data->val_out = phy_read_mmd(phydev_rq, mdio_phy_id_devad(mii_data->phy_id), mii_data->reg_num);
+               } else {
+                       mii_data->val_out = phy_read(phydev_rq, mii_data->reg_num);
+               }
+
                 return 0;
  
         case SIOCSMIIREG:

-- 
Best regards,
grygorii
