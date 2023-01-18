Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC6671B8C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjARMKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjARMJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:09:43 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAB94956F;
        Wed, 18 Jan 2023 03:28:19 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30IBS1xb057677;
        Wed, 18 Jan 2023 05:28:01 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674041281;
        bh=at1vaeGY8DDdVFlJntRD04T4GBNpSZ9lJveSQsHFpVI=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=clSpdEQmDyBTow75TnJqdDKLPN0BbuGugLIN1MDY3Jy73pki97acL7CI2ABC9pgco
         R+kBD5OD92N8oX6XD6JbIrgbmBI/6dipxZos84qZqSIbya5TFqlsQfkgK1OeFb9Pl3
         ppVNUGrK8JLPfSgRvm+p4Ep7H9Vqb4WuO5aZJ3es=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30IBS1Dd093279
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Jan 2023 05:28:01 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 18
 Jan 2023 05:28:01 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 18 Jan 2023 05:28:01 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30IBRthi007034;
        Wed, 18 Jan 2023 05:27:56 -0600
Message-ID: <260c19fe-d831-eaac-d7fb-e38495f3eda0@ti.com>
Date:   Wed, 18 Jan 2023 16:57:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v6 3/3] net: ethernet: ti: am65-cpsw: Add support
 for SERDES configuration
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
 <20230104103432.1126403-4-s-vadapalli@ti.com>
 <CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com>
 <69d39885-68df-7c94-5a98-5f1e174c7316@ti.com>
 <CAMuHMdX0+7UyjbR7HLVqghU3dpa+VEL9oV6tkLSZxcZdhM=UXQ@mail.gmail.com>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <CAMuHMdX0+7UyjbR7HLVqghU3dpa+VEL9oV6tkLSZxcZdhM=UXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Geert,

On 18/01/23 15:57, Geert Uytterhoeven wrote:
> Hi Siddarth,
> 
> On Wed, Jan 18, 2023 at 6:48 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
>> On 17/01/23 19:25, Geert Uytterhoeven wrote:
>>> On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
>>>> Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.
>>>>
>>>> Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
>>>> am65_cpsw_disable_serdes_phy() and am65_cpsw_enable_serdes_phy().
>>>>
>>>> Add new member "serdes_phy" to struct "am65_cpsw_slave_data" to store the
>>>> SERDES PHY for each port, if it exists. Use it later while disabling the
>>>> SERDES PHY for each port.
>>>>
>>>> Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
>>>> by invoking am65_cpsw_enable_serdes_phy().
>>>>
>>>> Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
>>>> am65_cpsw_disable_serdes_phy().
>>>>
>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>
>>> Thanks for your patch, which is now commit dab2b265dd23ef8f ("net:
>>> ethernet: ti: am65-cpsw: Add support for SERDES configuration")
>>> in net-next.
>>>
>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> 
>>>> +static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np,
>>>> +                                    struct am65_cpsw_port *port)
>>>> +{
>>>> +       const char *name = "serdes-phy";
>>>> +       struct phy *phy;
>>>> +       int ret;
>>>> +
>>>> +       phy = devm_of_phy_get(dev, port_np, name);
>>>> +       if (PTR_ERR(phy) == -ENODEV)
>>>> +               return 0;
>>>> +
>>>> +       /* Serdes PHY exists. Store it. */
>>>
>>> "phy" may be a different error here (e.g. -EPROBE_DEFER)...
>>
>> The Serdes is automatically configured for multi-link protocol (Example: PCIe +
>> QSGMII) by the Serdes driver, due to which it is not necessary to invoke the
>> Serdes configuration via phy_init(). However, for single-link protocol (Example:
>> Serdes has to be configured only for SGMII), the Serdes driver doesn't configure
>> the Serdes unless requested. For this case, the am65-cpsw driver explicitly
>> invokes phy_init() for the Serdes to be configured, by looking up the optional
>> device-tree phy named "serdes-phy". For this reason, the above section of code
>> is actually emulating a non-existent "devm_of_phy_optional_get()". The
>> "devm_of_phy_optional_get()" function is similar to the
>> "devm_phy_optional_get()" function in the sense that the "serdes-phy" phy in the
>> device-tree is optional and it is not truly an error if the property isn't present.
> 
> Yeah, I noticed while adding devm_phy_optional_get(), and looking for
> possible users.
> See "[PATCH treewide 0/7] phy: Add devm_of_phy_optional_get() helper"
> https://lore.kernel.org/all/cover.1674036164.git.geert+renesas@glider.be

Thank you for working on this.

> 
>> Thank you for pointing out that if the Serdes driver is built as a module and
>> the am65-cpsw driver runs first, then the "phy" returned for "serdes-phy" will
>> be "-EPROBE_DEFER".
>>
>>>
>>>> +       port->slave.serdes_phy = phy;
>>>> +
>>>> +       ret =  am65_cpsw_enable_phy(phy);
>>>
>>> ... so it will crash when dereferencing phy in phy_init().
>>>
>>> I think you want to add an extra check above:
>>>
>>>     if (IS_ERR(phy))
>>>             return PTR_ERR(phy);
>>
>> Please let me know if posting a "Fixes" patch for fixing this net-next commit is
>> the right process to address this.
> 
> I think it is, as devm_of_phy_optional_get() might not make it in time.

I posted the patch at:
https://lore.kernel.org/r/20230118112136.213061-1-s-vadapalli@ti.com

> 
>>>> @@ -1959,6 +2021,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>>>
>>> Right out of context we have:
>>>
>>>                 port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
>>>                 if (IS_ERR(port->slave.ifphy)) {
>>>                         ret = PTR_ERR(port->slave.ifphy);
>>>                         dev_err(dev, "%pOF error retrieving port phy: %d\n",
>>>                                 port_np, ret);
>>>
>>> So if there is only one PHY (named "serdes-phy") in DT, it will be
>>> used for both ifphy and serdes_phy. Is that intentional?
>>
>> The PHY corresponding to "ifphy" is meant to be the CPSW MAC's PHY and not the
>> Serdes PHY. The CPSW MAC's PHY is configured by the
>> drivers/phy/ti/phy-gmii-sel.c driver and this is NOT an optional PHY, unlike the
>> Serdes PHY. Therefore, it is assumed that the CPSW MAC's PHY is always provided
>> in the device-tree, while the Serdes PHY is optional, depending on whether the
>> Serdes is being configured for single-link protocol or multi-link protocol.
>> Please let me know if this appears to be an issue and I will fix it based on
>> your suggestion.
> 
> Hence this should be documented in the DT bindings. Please document
> there can be 1 or 2 phys, with an optional "phys-names" property,
> listing "ifphy" and "serdes-phy" (the DT people might request a rename).

I will work on this.

Regards,
Siddharth.
