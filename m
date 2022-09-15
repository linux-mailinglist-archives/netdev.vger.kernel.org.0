Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6015B967F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiIOIhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiIOIhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:37:31 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F0F97EDF;
        Thu, 15 Sep 2022 01:37:27 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F8av5d020223;
        Thu, 15 Sep 2022 03:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663231017;
        bh=2RSmklK1TVuVRmWe/70Gpjzew728xNGbXx1E3M+lpr8=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=SpCm8zgKOL/xH+6QYS9hvm1VYeoEBIuy1znTpdRovLDu9xZs7LUrdNrXbob4fdXYE
         SdUQxG0OXJlbZv1B1gn/bGHjyRvvaGYY1+DzyQ2Vn3cSqQURh8qKVmGMg2iCz5i/Cn
         hxHb3a4gfERI7btHXOlSmaP7o+0CY2r4WUuFZELk=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F8avuA055725
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 03:36:57 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 03:36:57 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 03:36:57 -0500
Received: from [10.24.69.241] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F8alx3095898;
        Thu, 15 Sep 2022 03:36:47 -0500
Message-ID: <baa51dc7-3605-0001-386a-35e386b920da@ti.com>
Date:   Thu, 15 Sep 2022 14:06:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 2/8] net: ethernet: ti: am65-cpsw: Add support for SERDES
 configuration
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-3-s-vadapalli@ti.com>
 <YyH1TH0UqCzN37J2@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyH1TH0UqCzN37J2@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 14/09/22 21:07, Russell King (Oracle) wrote:
> On Wed, Sep 14, 2022 at 03:20:47PM +0530, Siddharth Vadapalli wrote:
>> @@ -1427,6 +1471,9 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
>>  	struct net_device *ndev = port->ndev;
>>  	int tmo;
>>  
>> +	/* disable phy */
>> +	am65_cpsw_disable_phy(port->slave.ifphy);
>> +
> 
> This seems really strange. If you have a serdes interface which
> presumably supports SGMII, 1000base-X etc, then link status is sent
> across the serdes interface. If you power down the serdes, then you
> can't receive the link status, and so mac_link_up() won't be called.
> 
> Are you really sure you want to be enabling and disabling the PHY
> in mac_link_down()/mac_link_up() ?

Thank you for reviewing the patch. The PHY passed to the
"am65_cpsw_disable_phy()" and "am65_cpsw_disable_phy()" functions within
the "am65_cpsw_nuss_mac_link_down()" and "am65_cpsw_nuss_mac_link_up()"
functions respectively, is the CPSW ethernet MAC's PHY and not the
SERDES PHY. The SERDES PHY is powered on through the function call to
the "am65_cpsw_init_phy()" function.

The calls to the functions "am65_cpsw_enable_phy()" and
"am65_cpsw_disable_phy()" within the "am65_cpsw_nuss_mac_link_up()" and
"am65_cpsw_nuss_mac_link_down()" functions respectively, try to power on
and power off the CPSW ethernet MAC's phy. Looking at it again,they do
nothing, since the driver corresponding to the ethernet MAC's PHY which
happens to be drivers/phy/ti/phy-gmii-sel.c, does not provide any
methods to power on and power off the ethernet MAC's PHY. I have just
realized that this is stale code and will remove it in the v2 series.

Also, I realize now that I did not invoke "am65_cpsw_disable_phy()" on
the SERDES PHY in the driver's remove function. I will fix this in the
v2 series.

Regards,
Siddharth.
