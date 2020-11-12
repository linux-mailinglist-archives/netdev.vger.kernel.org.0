Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9972B00F4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgKLINw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:13:52 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:23022 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLINv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605168830; x=1636704830;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ItFpNbmKR7OdhMzHJF470N6EX32UEcaOk9xfLGe7gDc=;
  b=jXVVO2I4xKrVN7Xx9iw2CbCBDypbaZz3kNrJ/5+QY/a4zW6vSA6mqKnL
   7pGCdl4/Ikno+vEYo5Smnw5j5Qy4619e8dKyX2PxahVqkZPfpovoQxh+R
   AuqWTrgABcRy83N4CdWDdiSD2veWH9NqfpiBulPM07riaLc7fZ7GU8QxC
   Hjp2AZfgFDohLOc+WV25Gw+MV42AuBa5K92Rxo/MajUW6uQOcOjjxzEWz
   9tjWsaBJO+Tsl4OkRy0MW8QrQ7xyIny+h1LhA09ALoatrjdZm3Zo1dPRo
   9mTdNMu/8p387+aKFBf5x3GtAdyJn3AIbfBg1S+vfVZhzQ4qAB1ZbjfST
   A==;
IronPort-SDR: uktn7miP3jsCzH/NEyJa7oaQ8Y3xr23MLP/Eeln2ATiCBr/OJVdmz2Nxvohptl5vF8x1tOU9v3
 6pHesvmKgk6LQGKaDu8S4ulDblUDf/Gu4kMIqd/b1M9WNFOfwwtTtgMZztO5FYbM6Ifj9Aeou7
 UVjavyGeO4Q1FPed0R6D4fcllF4BwT91iveEclEueHllYTH1Mj/94vYXw3Jsc+5Qe24xxLlvA5
 xXzGCQGC1L7Bxz/VSkCSmxweapDpHKqRNx8cH/E2q5gafrod0GlZIjPokKIYf3d23Qibd+NGN4
 6Lk=
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="93386858"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2020 01:13:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 01:13:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 12 Nov 2020 01:13:49 -0700
Date:   Thu, 12 Nov 2020 09:13:48 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [net v2] net: phy: mscc: adjust the phy support for PTP and
 MACsec
Message-ID: <20201112081348.iazemmss2vwjv63v@mchp-dev-shegelun>
References: <20201111151753.840364-1-steen.hegelund@microchip.com>
 <160511213375.165477.17752694389005766821@surface.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <160511213375.165477.17752694389005766821@surface.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.11.2020 17:28, Antoine Tenart wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Hi Steen,
>
>Quoting Steen Hegelund (2020-11-11 16:17:53)
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
>> History:
>> v1 -> v2:
>>   - Added "fixes:" tags to the commit message
>>
>> Fixes: bb56c016a1257 ("net: phy: mscc: split the driver into separate files")
>
>This commit splitting the driver didn't introduced the issue, it only
>moved code around. You can remove this Fixes tag. (You usually/should
>have a single Fixes tag per patch).
>
OK.  I get that.

>> Fixes: ab2bf93393571 ("net: phy: mscc: 1588 block initialization")
>
>The PTP and the MACsec support were introduced in separate patches (and
>were introduced in different releases of the kernel). This patch is
>fixing two different issues then, and its changes can't apply to the
>same kernel versions. You should send them in two separate patches.
>
OK.

>With the changes sent in two different patches, I would suggest to only
>send the MACsec one as a fix for net (it's really fixing something, by
>removing a non-compatible PHY from using MACsec) and the PTP one for
>net-next as it's adding PTP support for two new PHYs (not fixing
>anything).
>

I will split the patch as you suggested.

>When you do so, please use the following commands to format the patches,
>to end up with the correct prefix in the subject:
>git format-patch --subject-prefix='PATCH net' ...
>git format-patch --subject-prefix='PATCH net-next' ...
>
>Thanks!
>Antoine
>
Thanks for the comments, Antoine,

BR
Steen
>
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
