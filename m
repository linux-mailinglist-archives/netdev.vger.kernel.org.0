Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CED58D80C
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbiHILbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 07:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiHILaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 07:30:46 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDE195B2;
        Tue,  9 Aug 2022 04:30:44 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 279BUPum006208;
        Tue, 9 Aug 2022 06:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660044625;
        bh=+DACkBDSrKIpgBdmU5fA9yyzJiQ302qqvnbGNS/kuws=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=sTV3JNLELwibr7QAETx4OGu1p3aTQHrcO9hcB9/ZWgRxrSxs/9p1N2CVb2sZQiqQa
         VSQ2UPUOE6G/OhqW9ozoELR1ihncQPjEeauR16Jtu5d5kFvOsr22qd3fBdGKuaiOMB
         RMg80eDD+/bTuk7WK6CQGiIHE22YKaAHKiZkf1Gw=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 279BUP1W017832
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 9 Aug 2022 06:30:25 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 9
 Aug 2022 06:30:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 9 Aug 2022 06:30:24 -0500
Received: from [10.24.69.79] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 279BULwT122324;
        Tue, 9 Aug 2022 06:30:21 -0500
Message-ID: <27860709-db8f-49be-fec7-a76496bfb948@ti.com>
Date:   Tue, 9 Aug 2022 17:00:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [EXTERNAL] Re: [RESEND PATCH] net: ethernet: ti: davinci_mdio:
 Add workaround for errata i2329
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <vigneshr@ti.com>
References: <20220808111229.11951-1-r-gunasekaran@ti.com>
 <YvFubdCiU7J8Ufi4@lunn.ch>
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <YvFubdCiU7J8Ufi4@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 09/08/22 1:43 am, Andrew Lunn wrote:
>> +static int davinci_mdio_sw_read(struct mii_bus *bus, int phy_id, int phy_reg)
>> +{
>> +	struct davinci_mdio_data *data = bus->priv;
>> +	u32 reg, i;
>> +	int ret;
>> +	u8 ack;
>> +
>> +	if (phy_reg & ~PHY_REG_MASK || phy_id & ~PHY_ID_MASK)
>> +		return -EINVAL;
>> +
>> +	ret = pm_runtime_get_sync(data->dev);
>> +	if (ret < 0) {
>> +		pm_runtime_put_noidle(data->dev);
>> +		return ret;
>> +	}
>> +
>> +	davinci_mdio_disable(data);
>> +	davinci_mdio_enable_manual_mode(data);
>> +	davinci_mdio_sw_preamble(data);
>> +
>> +	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
>> +	davinci_mdio_sw_set_bit(data, MDIO_OE);
>> +
>> +	 /* Issue clause 22 MII read function {0,1,1,0} */
>> +	davinci_mdio_man_send_pattern(data, C22_BITRANGE, C22_READ_PATTERN);
>> +
>> +	/* Send the device number MSB first */
>> +	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_id);
>> +
>> +	/* Send the register number MSB first */
>> +	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_reg);
>> +
>> +	/* Send turn around cycles */
>> +	davinci_mdio_sw_clr_bit(data, MDIO_OE);
>> +
>> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
>> +
>> +	ack = davinci_mdio_test_man_bit(data, MDIO_PIN);
>> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
>> +
>> +	reg = 0;
>> +	if (ack == 0) {
>> +		for (i = MDIO_BITRANGE; i; i = i >> 1) {
>> +			if (davinci_mdio_test_man_bit(data, MDIO_PIN))
>> +				reg |= i;
>> +
>> +			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
>> +		}
>> +	} else {
>> +		for (i = MDIO_BITRANGE; i; i = i >> 1)
>> +			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
>> +
>> +		reg = 0xFFFF;
>> +	}
>> +
>> +	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
>> +	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
>> +	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
>> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
> 
> You appear to of re-invented drivers/net/mdio/mdio-bitbang.c
> 
> If there is a reason this cannot be used, please at least state it in
> the commit message.
>
Thanks for reviewing the patch. Since mdiobb_{read,write}() are exported, I can 
invoke these in my mdio read/write implementation. I will rework and send the v2 patch

>      Andrew

-- 
Regards,
Ravi
