Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0353671356
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 06:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjARFuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 00:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjARFtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 00:49:03 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7EE552AF;
        Tue, 17 Jan 2023 21:48:09 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30I5leEq121959;
        Tue, 17 Jan 2023 23:47:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674020860;
        bh=BrJrsYVahMtFpU7O/aRpM2BujKcpQcSo61rQrOwBF2c=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=xNDM/P2bqUZW035+W21sWSPw45hmBZPWV9ZKdcHsRW/PY3DrnckP/wYMu7VGsgwEI
         lBV7j/+8UNJM03v6O2UgxKseFzmm95R+WIfxTwnyNVmFqgUFc28fAMpFz6Sk/zxofW
         JBJaGC2X8yy+v3yvCF70Ezxwp5tZp3cRp0Zn0OO4=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30I5leAC052855
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Jan 2023 23:47:40 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 17
 Jan 2023 23:47:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 17 Jan 2023 23:47:39 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30I5lYrO023611;
        Tue, 17 Jan 2023 23:47:35 -0600
Message-ID: <69d39885-68df-7c94-5a98-5f1e174c7316@ti.com>
Date:   Wed, 18 Jan 2023 11:17:33 +0530
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
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com>
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

Thank you for reviewing the patch.

On 17/01/23 19:25, Geert Uytterhoeven wrote:
> Hi Siddharth,
> 
> On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
>> Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.
>>
>> Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
>> am65_cpsw_disable_serdes_phy() and am65_cpsw_enable_serdes_phy().
>>
>> Add new member "serdes_phy" to struct "am65_cpsw_slave_data" to store the
>> SERDES PHY for each port, if it exists. Use it later while disabling the
>> SERDES PHY for each port.
>>
>> Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
>> by invoking am65_cpsw_enable_serdes_phy().
>>
>> Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
>> am65_cpsw_disable_serdes_phy().
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
> Thanks for your patch, which is now commit dab2b265dd23ef8f ("net:
> ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> in net-next.
> 
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1416,6 +1416,68 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
>>         .ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
>>  };
>>
>> +static void am65_cpsw_disable_phy(struct phy *phy)
>> +{
>> +       phy_power_off(phy);
>> +       phy_exit(phy);
>> +}
>> +
>> +static int am65_cpsw_enable_phy(struct phy *phy)
>> +{
>> +       int ret;
>> +
>> +       ret = phy_init(phy);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       ret = phy_power_on(phy);
>> +       if (ret < 0) {
>> +               phy_exit(phy);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void am65_cpsw_disable_serdes_phy(struct am65_cpsw_common *common)
>> +{
>> +       struct am65_cpsw_port *port;
>> +       struct phy *phy;
>> +       int i;
>> +
>> +       for (i = 0; i < common->port_num; i++) {
>> +               port = &common->ports[i];
>> +               phy = port->slave.serdes_phy;
>> +               if (phy)
>> +                       am65_cpsw_disable_phy(phy);
>> +       }
>> +}
>> +
>> +static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np,
>> +                                    struct am65_cpsw_port *port)
>> +{
>> +       const char *name = "serdes-phy";
>> +       struct phy *phy;
>> +       int ret;
>> +
>> +       phy = devm_of_phy_get(dev, port_np, name);
>> +       if (PTR_ERR(phy) == -ENODEV)
>> +               return 0;
>> +
>> +       /* Serdes PHY exists. Store it. */
> 
> "phy" may be a different error here (e.g. -EPROBE_DEFER)...

The Serdes is automatically configured for multi-link protocol (Example: PCIe +
QSGMII) by the Serdes driver, due to which it is not necessary to invoke the
Serdes configuration via phy_init(). However, for single-link protocol (Example:
Serdes has to be configured only for SGMII), the Serdes driver doesn't configure
the Serdes unless requested. For this case, the am65-cpsw driver explicitly
invokes phy_init() for the Serdes to be configured, by looking up the optional
device-tree phy named "serdes-phy". For this reason, the above section of code
is actually emulating a non-existent "devm_of_phy_optional_get()". The
"devm_of_phy_optional_get()" function is similar to the
"devm_phy_optional_get()" function in the sense that the "serdes-phy" phy in the
device-tree is optional and it is not truly an error if the property isn't present.

Thank you for pointing out that if the Serdes driver is built as a module and
the am65-cpsw driver runs first, then the "phy" returned for "serdes-phy" will
be "-EPROBE_DEFER".

> 
>> +       port->slave.serdes_phy = phy;
>> +
>> +       ret =  am65_cpsw_enable_phy(phy);
> 
> ... so it will crash when dereferencing phy in phy_init().
> 
> I think you want to add an extra check above:
> 
>     if (IS_ERR(phy))
>             return PTR_ERR(phy);

Please let me know if posting a "Fixes" patch for fixing this net-next commit is
the right process to address this.

> 
>> +       if (ret < 0)
>> +               goto err_phy;
>> +
>> +       return 0;
>> +
>> +err_phy:
>> +       devm_phy_put(dev, phy);
>> +       return ret;
>> +}
>> +
>>  static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
>>                                       const struct phylink_link_state *state)
>>  {
>> @@ -1959,6 +2021,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
> 
> Right out of context we have:
> 
>                 port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
>                 if (IS_ERR(port->slave.ifphy)) {
>                         ret = PTR_ERR(port->slave.ifphy);
>                         dev_err(dev, "%pOF error retrieving port phy: %d\n",
>                                 port_np, ret);
> 
> So if there is only one PHY (named "serdes-phy") in DT, it will be
> used for both ifphy and serdes_phy. Is that intentional?

The PHY corresponding to "ifphy" is meant to be the CPSW MAC's PHY and not the
Serdes PHY. The CPSW MAC's PHY is configured by the
drivers/phy/ti/phy-gmii-sel.c driver and this is NOT an optional PHY, unlike the
Serdes PHY. Therefore, it is assumed that the CPSW MAC's PHY is always provided
in the device-tree, while the Serdes PHY is optional, depending on whether the
Serdes is being configured for single-link protocol or multi-link protocol.
Please let me know if this appears to be an issue and I will fix it based on
your suggestion.

Regards,
Siddharth.
