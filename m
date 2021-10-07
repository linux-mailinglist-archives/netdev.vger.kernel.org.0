Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5824253EE
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhJGNYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:24:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50825 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhJGNYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633612928; x=1665148928;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9lc2emZW+fYjx0z/aw1TLmtEEjeYBQwKTxnJwftoaLo=;
  b=RuxuwgIPNocwpLvLXf1bRmWcoe1SDVzsehq6c2LHQIVwe2c0fG6WoJ7U
   1d7DtFL9hUE/FF5uQSn6wj26F9VsDC8YJbLvwFDFXOoQ8ydP4m7Tg3/pK
   oWDsyjvcEiSLNVfpMsEuinIlc35moKO0zwsjVFSh7cBSL01/cpQ8D+ac4
   2gh0KYo14wIEuWM/m3BzOt0w6UguIRZsFoHwf2hvNJciO/NDKNp2q8jLa
   V7GhinhK37vYM7Z5uMpLml8V/U9SS5SENuuz6C2qsbjyDY1rezECLp/hf
   Fdxtl9VEIh1PdJ3BZ74xJgt5y87+o/pj4PrTEYnWhrLGum5v6YTTrvxg7
   Q==;
IronPort-SDR: vav1I1rK/l2eLMsaJAifPWZNi5C8+JKoKYM2kPRT/a08CgkykhLPIraPqIaDccU7pADiMjc8jv
 25C0YZxV2UM4AhpMGJghzEJQdEMDLb9KU2wKLVgd3kXTjN2lAGmUfqDihGu9FphC0y2RNXlK4T
 pll0O1CBGF9XnmhwhedSBUfBmuYicYVe7kmSM1qt72BqJKc7ZayH/DafZl3H9XmDHPvrqgGh1w
 Gkr+rQSQ+i3D5b2GlTL13je/pE12GYLbp9XCxSzIYoZDPrXaHbGobTpg+8tqNnq+lvIfR2hd6B
 u4O73olZrZJVXnQ8vfVW/0o4
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="139396859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 06:22:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 06:22:06 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 7 Oct 2021 06:22:05 -0700
Subject: Re: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
To:     Sean Anderson <sean.anderson@seco.com>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-9-sean.anderson@seco.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <b1401da6-5bab-2e4c-e667-aca0bbf013dc@microchip.com>
Date:   Thu, 7 Oct 2021 15:22:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211004191527.1610759-9-sean.anderson@seco.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2021 at 21:15, Sean Anderson wrote:
> While we're on the subject, could someone clarify the relationship
> between the various speed capabilities? What's the difference between
> MACB_CAPS_GIGABIT_MODE_AVAILABLE, MACB_CAPS_HIGH_SPEED, MACB_CAPS_PCS,
> and macb_is_gem()? Would there ever be a GEM without GIGABIT_MODE?

Yes. GEM is a new revision of the IP that is capable of doing Gigabit 
mode or not. sama7g5_emac_config is typically one of those doing only 
10/100.

> HIGH_SPEED without PCS? Why doesn't SGMII care if we're a gem (I think
> this one is a bug, because it cares later on)?

MACB_CAPS_HIGH_SPEED and MACB_CAPS_PCS were added by 
e4e143e26ce8f5f57c60a994bdc63d0ddce3a823 ("net: macb: add support for 
high speed interface"). In this commit it is said that "This controller 
has separate MAC's and PCS'es for low and high speed paths." Maybe it's 
a hint.

Best regards,
   Nicolas


-- 
Nicolas Ferre
