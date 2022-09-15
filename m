Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD25B9789
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIOJgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIOJf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:35:59 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E3174DF1;
        Thu, 15 Sep 2022 02:35:58 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F9ZYmo017194;
        Thu, 15 Sep 2022 04:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663234534;
        bh=ZqlwKipWWBwqNMDlQeWidZRKes3p7b+3rjYNO5D59kw=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=FEylberaJX4iZU07VA4aakxSwjUokj+AiWr1SehxTaXb6OnHgmzdcylrFgrlJE6JE
         Ra5TzusYJHIC5zVTjLRqZvgz/rfAKRAAv9K0rKAIIF80MHLb8yuw/oBXKRfN+SoM3X
         oPuCZ7i3PDGxZxfLnP4DropwK9hdXxz2/iYu9Le0=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F9ZYPS087012
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 04:35:34 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 04:35:33 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 04:35:33 -0500
Received: from [10.24.69.241] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F9ZSbk014554;
        Thu, 15 Sep 2022 04:35:29 -0500
Message-ID: <7a5dd6b3-389f-13a2-7c96-8e97e0ab4e55@ti.com>
Date:   Thu, 15 Sep 2022 15:05:28 +0530
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
Subject: Re: [PATCH 6/8] net: ethernet: ti: am65-cpsw: Add support for SGMII
 mode for J7200 CPSW5G
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-7-s-vadapalli@ti.com>
 <YyH2zCscSV5KQtZ9@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyH2zCscSV5KQtZ9@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 14/09/22 21:14, Russell King (Oracle) wrote:
> On Wed, Sep 14, 2022 at 03:20:51PM +0530, Siddharth Vadapalli wrote:
>> Add support for SGMII mode in both fixed-link MAC2MAC master mode and
>> MAC2PHY modes for CPSW5G ports.
>>
>> Add SGMII mode to the list of extra_modes in j7200_cpswxg_pdata.
>>
>> The MAC2PHY mode has been tested in fixed-link mode using a bootstrapped
>> PHY. The MAC2MAC mode has been tested by a customer with J7200 SoC on
>> their device.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 19 ++++++++++++++++---
>>  1 file changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 1739c389af20..3f40178436ff 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -75,7 +75,15 @@
>>  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
>>  
>>  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
>> +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
> 
> This doesn't seem to be used in this patch, should it be part of some
> other patch in the series?
> 
>>  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
>> +#define AM65_CPSW_SGMII_CONTROL_MASTER_MODE	BIT(5)
> 
> Ditto.
> 
>> +
>> +#define MAC2MAC_MR_ADV_ABILITY_BASE		(BIT(15) | BIT(0))
>> +#define MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX	BIT(12)
>> +#define MAC2MAC_MR_ADV_ABILITY_1G		BIT(11)
>> +#define MAC2MAC_MR_ADV_ABILITY_100M		BIT(10)
>> +#define MAC2PHY_MR_ADV_ABILITY			BIT(0)
> 
> Most of the above don't seem to be used, and the only one that seems to
> be used is used in a variable declaration where the variable isn't used,
> and thus us also unused.
> 
>>  
>>  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
>>  #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
>> @@ -1493,6 +1501,7 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>  	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
>>  							  phylink_config);
>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>> +	u32 mr_adv_ability = MAC2MAC_MR_ADV_ABILITY_BASE;
> 
> This doesn't seem to be used; should it be part of a different patch?
> 
> I get the impression that most of this patch should be elsewhere in this
> series.

Thank you for pointing it out. These should have been a part of the
previous patch [PATCH 5/8]. Sorry for the confusion. I will fix this in
the v2 series.

Regards,
Siddharth.
