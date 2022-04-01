Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85C4EEEB1
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbiDAOB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346643AbiDAOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:01:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B119658E4D;
        Fri,  1 Apr 2022 06:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648821574; x=1680357574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HS53eDMBd+hdkP/TyH5YuRd2CDwQeuvPwLfTlKoio/U=;
  b=Ja4j8SaxTHieed+YIkIudM2wslEMmwH/gb8Q5vMKyDvZ91oueSe5YAal
   ERdctjPdhW2GAw+ru24I2DVKUV33d7csp1p0KeT2UZpbcfw36a4XEaRWY
   nfqGi7AtjGHcx/E5+/3+zaMF6kby3WkovhOTOZTpqv0eJp74Lve2997N+
   H6VURtew43hg/dDJfzGiiyocBrrJEeTmBjbtYE309KYIu/ZVeR8Kzjg8l
   floX2jIxW/N3OS3Qvv98ML1ixp7ArfIBrQwTqaP8oCDw2IsjibJhfg6vU
   vWERQbDUTxIlHXAThAQDU+2NZqnPNhdgY3RnM3ZkcfEqJuaLYuhZ3bEMp
   g==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="90927628"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 06:59:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 06:59:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Apr 2022 06:59:32 -0700
Date:   Fri, 1 Apr 2022 15:59:18 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <Divya.Koppera@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net 2/3] net: phy: micrel: Remove latency from driver
Message-ID: <20220401135918.4tvwe6cfyku6l5wf@lx-anielsen>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
 <20220401094805.3343464-3-horatiu.vultur@microchip.com>
 <Ykb0RgM+fnzOUTNx@lunn.ch>
 <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.04.2022 15:34, Horatiu Vultur wrote:
>The 04/01/2022 14:47, Andrew Lunn wrote:
>>
>> On Fri, Apr 01, 2022 at 11:48:04AM +0200, Horatiu Vultur wrote:
>> > Based on the discussions here[1], the PHY driver is the wrong place
>> > to set the latencies, therefore remove them.
>> >
>> > [1] https://lkml.org/lkml/2022/3/4/325
>> >
>> > Fixes: ece19502834d84 ("net: phy: micrel: 1588 support for LAN8814 phy")
>> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>
>> Thanks for the revert.
>>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>
>> > -static struct kszphy_latencies lan8814_latencies = {
>> > -     .rx_10          = 0x22AA,
>> > -     .tx_10          = 0x2E4A,
>> > -     .rx_100         = 0x092A,
>> > -     .tx_100         = 0x02C1,
>> > -     .rx_1000        = 0x01AD,
>> > -     .tx_1000        = 0x00C9,
>> > -};
>>
>> What are the reset defaults of these?
>
>Those are actually the reset values.
>
>> I'm just wondering if we should
>> explicitly set them to 0, so we don't get into a mess where some
>> vendor bootloader sets values but mainline bootloader does not,
>> breaking a configuration where the userspace daemon does the correct?
>
>It would be fine for me to set them to 0. But then definitely we need a
>way to set these latencies from userspace.
I would like to keep the default values. With default values, you can
get PTP working (accuracy is not great - but it is much better than
if set to zero).

There is no risk of bootloaders to pre-load other values, as the kernel
will reset the PHY, and after reset we will be back to these numbers.

/Allan

