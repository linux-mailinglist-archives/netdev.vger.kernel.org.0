Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2212AF38E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKKOam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:30:42 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:34324 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKOai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605105037; x=1636641037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eQwSLKz3XcJYspomITX3s4KppwTX/4B5QZmOwyUr1wI=;
  b=ZTVMbZJJbLQW2oo8Ag2lqZuu+PfC1011yGGeXX4fCxoT0Zh1IJ9wbqKi
   Hk/Tja5SU61c0IlGruETxzOlR35wqNRa1FDV/zUGbaMub14gUx4rugaNu
   xXICORBeF94Ip92qEiWPZerxHYArhQ0O+sTC6GxC6tdaGPubANSgNDEP3
   RMqvXHSiVgWX7nq0+3yS5eKpWOjWW8qXhZnIGp6Pr6SlU8X7FZhY5JsZ2
   sQK9C0llhUcL8Q+BoHJ6oNnHB34vcFKPODs20iESduMPe8wQCV85JItYi
   PiFAmKUiM2OypQ20UIIQ010Ts5ChcnUw7xnKuJYp85jsHC8aC255vTR4F
   g==;
IronPort-SDR: d8DTRE2MFM5D0g3PbD8aV5mvP9KIllAr0fSvuCxGSoSW4MSZb1W8Bp8OGXwgwwshKcuavCFLY7
 CWt3mIfPSstjRrWbYGuiKG/eX+t0b7FUsSFE/ykQI2CZte2K/W8WnhL1oVC8qiS3s7k4jYndKq
 cYEYgc6RAcAxFRMtzUNYjOMsrCrnvJ8K+J1ZNcOGmqZmDH5P7dqz+1Lh6Z2AC2kTrw8i7tA37h
 bAh0+7QFOGdOFRuOWOI6BiqNHQGESNpTo3MnDXJl41RspkIkeLpWkdHR64Tn9xJfaMI+DP5aCd
 RTA=
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="33232780"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 07:30:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 07:30:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 11 Nov 2020 07:30:36 -0700
Date:   Wed, 11 Nov 2020 15:30:35 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip UNG Driver List" <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: Re: [net] net: phy: mscc: adjust the phy support for PTP and MACsec
Message-ID: <20201111143035.fr5dh3eirtxvwqeu@mchp-dev-shegelun>
References: <20201111095511.671539-1-steen.hegelund@microchip.com>
 <160510327378.144114.15670288040387928079@surface.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <160510327378.144114.15670288040387928079@surface.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.11.2020 15:01, Antoine Tenart wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Hi Steen!
>
>Either this is a fix and it would need a Fixes: tag in addition to the
>Signed-off-by: one (you can have a look at the git history to see what
>is the format); or the patch is not a fix and then it should have
>[net-next] in its subject instead of [net].
>
>Please have a look at the relevant documentation,
>https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
>
>Thanks!
>Antoine

Hi Antoine,
Thanks for pointing this out.  It is a fix, so I will add a Fixes tag to
the commit message.

BR
Steen

>
>Quoting Steen Hegelund (2020-11-11 10:55:11)
>> The MSCC PHYs selected for PTP and MACSec was not correct
>>
>> - PTP
>>     - Add VSC8572 and VSC8574
>>
>> - MACsec
>>     - Removed VSC8575
>>
>> The relevant datasheets can be found here:
>>   - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
>>   - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574
>>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
>>
>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>> ---
>>  drivers/net/phy/mscc/mscc_macsec.c | 1 -
>>  drivers/net/phy/mscc/mscc_ptp.c    | 2 ++
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
>> index 1d4c012194e9..72292bf6c51c 100644
>> --- a/drivers/net/phy/mscc/mscc_macsec.c
>> +++ b/drivers/net/phy/mscc/mscc_macsec.c
>> @@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)
>>
>>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>>         case PHY_ID_VSC856X:
>> -       case PHY_ID_VSC8575:
>>         case PHY_ID_VSC8582:
>>         case PHY_ID_VSC8584:
>>                 INIT_LIST_HEAD(&vsc8531->macsec_flows);
>> diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
>> index b97ee79f3cdf..f0537299c441 100644
>> --- a/drivers/net/phy/mscc/mscc_ptp.c
>> +++ b/drivers/net/phy/mscc/mscc_ptp.c
>> @@ -1510,6 +1510,8 @@ void vsc8584_config_ts_intr(struct phy_device *phydev)
>>  int vsc8584_ptp_init(struct phy_device *phydev)
>>  {
>>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>> +       case PHY_ID_VSC8572:
>> +       case PHY_ID_VSC8574:
>>         case PHY_ID_VSC8575:
>>         case PHY_ID_VSC8582:
>>         case PHY_ID_VSC8584:
>> --
>> 2.29.2
>>

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
