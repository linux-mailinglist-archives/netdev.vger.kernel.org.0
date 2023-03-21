Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC476C32FD
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCUNfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUNfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:35:33 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D330823878;
        Tue, 21 Mar 2023 06:35:16 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LDYs7e002214;
        Tue, 21 Mar 2023 08:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679405694;
        bh=fu74MSoCTG0w6GTv0Ur+zehWS5U3Dg1BBUlTqx8fiW8=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=y1YBVMktmEiHwjQaCYd1QxRv4BBvCUnDNI/I8i/YcmMrpvM+gN2TQc/qVs7NT8kg4
         C40dsDUsQ+NJlXoeupVn2w5ToDNOd/MBsAlACUemCbjNvk7BBYKgpukd1D9BVC9juV
         ocibyebLSfso1Z61m3OaXO/1g+1srqgf4TqMddEE=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LDYsh1018731
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 08:34:54 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 08:34:54 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 08:34:54 -0500
Received: from [10.249.131.130] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LDYoAE017787;
        Tue, 21 Mar 2023 08:34:51 -0500
Message-ID: <9b9ba199-8379-0840-b99a-d729f8ad33e1@ti.com>
Date:   Tue, 21 Mar 2023 19:04:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 2/4] net: ethernet: ti: am65-cpsw: Add support
 for SGMII mode
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
 <20230321111958.2800005-3-s-vadapalli@ti.com>
 <ZBmVGu2vf1ADmEuN@shell.armlinux.org.uk>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZBmVGu2vf1ADmEuN@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 21-03-2023 16:59, Russell King (Oracle) wrote:
> On Tue, Mar 21, 2023 at 04:49:56PM +0530, Siddharth Vadapalli wrote:
>> Add support for configuring the CPSW Ethernet Switch in SGMII mode.
>>
>> Depending on the SoC, allow selecting SGMII mode as a supported interface,
>> based on the compatible used.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index cba8db14e160..d2ca1f2035f4 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -76,6 +76,7 @@
>>  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
>>  
>>  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
>> +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
>>  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
> 
> Isn't this misplaced? Shouldn't AM65_CPSW_SGMII_MR_ADV_ABILITY_REG come
> after AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE, rather than splitting that
> from its register offset definition?

Thank you for reviewing the patch. The registers are as follows:
CONTROL_REG offset 0x10
STATUS_REG offset  0x14
MR_ADV_REG offset  0x18

Since the STATUS_REG is not used in the driver, its offset is omitted.
The next register is the MR_ADV_REG, which I placed after the
CONTROL_REG. I grouped the register offsets together, to represent the
order in which the registers are placed. Due to this, the
MR_ADV_ABILITY_REG offset is placed after the CONTROL_REG offset define.

Please let me know if I should move it after the CONTROL_MR_AN_ENABLE
define instead.

> 
> If the advertisement register is at 0x18, and the lower 16 bits is the
> advertisement, are the link partner advertisement found in the upper
> 16 bits?

The MR_LP_ADV_ABILITY_REG is at offset 0x020, which is the the register
corresponding to the Link Partner advertised value. Also, the
AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE Bit is in the CONTROL_REG. The CPSW
Hardware specification describes the process of configuring the CPSW MAC
for SGMII mode as follows:
1. Write 0x1 (ADVERTISE_SGMII) to the MR_ADV_ABILITY_REG register.
2. Enable auto-negotiation in the CONTROL_REG by setting the
AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE bit.

> 
>>  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
>> @@ -1496,9 +1497,14 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>>  	struct am65_cpsw_common *common = port->common;
>>  
>> -	if (common->pdata.extra_modes & BIT(state->interface))
>> +	if (common->pdata.extra_modes & BIT(state->interface)) {
>> +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
>> +			writel(ADVERTISE_SGMII,
>> +			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
>> +
> 
> I think we can do better with this, by implementing proper PCS support.
> 
> It seems manufacturers tend to use bought-in IP for this, so have a
> look at drivers/net/pcs/ to see whether any of those (or the one in
> the Mediatek patch set on netdev that has recently been applied) will
> idrive your hardware.
> 
> However, given the definition of AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
> I suspect you won't find a compatible implementation.

I have tested with an SGMII Ethernet PHY in the standard SGMII MAC2PHY
configuration. I am not sure if PCS support will be required or not. I
hope that the information shared above by me regarding the CPSW
Hardware's specification for configuring it in SGMII mode will help
determine what the right approach might be. Please let me know whether
the current implementation is acceptable or PCS support is necessary.

Regards,
Siddharth.
