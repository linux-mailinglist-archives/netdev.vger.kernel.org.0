Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6646AB4ED
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCFDHp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 5 Mar 2023 22:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFDHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:07:44 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0CD14998;
        Sun,  5 Mar 2023 19:07:24 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 31FD724E362;
        Mon,  6 Mar 2023 11:06:51 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 11:06:51 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Mar
 2023 11:06:50 +0800
Message-ID: <bc79afab-17d1-8789-3325-8e6d62123dce@starfivetech.com>
Date:   Mon, 6 Mar 2023 11:06:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface
 settings
Content-Language: en-US
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-9-samin.guo@starfivetech.com>
 <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/3/4 0:50:54, Emil Renner Berthing 写道:
> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>>
>> dwmac supports multiple modess. When working under rmii and rgmii,
>> you need to set different phy interfaces.
>>
>> According to the dwmac document, when working in rmii, it needs to be
>> set to 0x4, and rgmii needs to be set to 0x1.
>>
>> The phy interface needs to be set in syscon, the format is as follows:
>> starfive,syscon: <&syscon, offset, mask>
>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 46 +++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>> index 566378306f67..40fdd7036127 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>> @@ -7,10 +7,15 @@
>>   *
>>   */
>>
>> +#include <linux/mfd/syscon.h>
>>  #include <linux/of_device.h>
>> +#include <linux/regmap.h>
>>
>>  #include "stmmac_platform.h"
>>
>> +#define MACPHYC_PHY_INFT_RMII  0x4
>> +#define MACPHYC_PHY_INFT_RGMII 0x1
> 
> Please prefix these with something like STARFIVE_DWMAC_
>
Hi, Emil, These definitions come from the datasheet of dwmac. However, add STARDRIVE_ DWMAC is a good idea. I will fix it,thanks.
>>  struct starfive_dwmac {
>>         struct device *dev;
>>         struct clk *clk_tx;
>> @@ -53,6 +58,46 @@ static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
>>                 dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>>  }
>>
>> +static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +       struct starfive_dwmac *dwmac = plat_dat->bsp_priv;
>> +       struct of_phandle_args args;
>> +       struct regmap *regmap;
>> +       unsigned int reg, mask, mode;
>> +       int err;
>> +
>> +       switch (plat_dat->interface) {
>> +       case PHY_INTERFACE_MODE_RMII:
>> +               mode = MACPHYC_PHY_INFT_RMII;
>> +               break;
>> +
>> +       case PHY_INTERFACE_MODE_RGMII:
>> +       case PHY_INTERFACE_MODE_RGMII_ID:
>> +               mode = MACPHYC_PHY_INFT_RGMII;
>> +               break;
>> +
>> +       default:
>> +               dev_err(dwmac->dev, "Unsupported interface %d\n",
>> +                       plat_dat->interface);
>> +       }
>> +
>> +       err = of_parse_phandle_with_fixed_args(dwmac->dev->of_node,
>> +                                              "starfive,syscon", 2, 0, &args);
>> +       if (err) {
>> +               dev_dbg(dwmac->dev, "syscon reg not found\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       reg = args.args[0];
>> +       mask = args.args[1];
>> +       regmap = syscon_node_to_regmap(args.np);
>> +       of_node_put(args.np);
> 
> I think the above is basically
> unsigned int args[2];
> syscon_regmap_lookup_by_phandle_args(dwmac->dev_of_node,
> "starfive,syscon", 2, args);
> 
> ..but as Andrew points out another solution is to use platform match
> data for this. Eg.
> 
> static const struct starfive_dwmac_match_data starfive_dwmac_jh7110_data {
>   .phy_interface_offset = 0xc,
>   .phy_interface_mask = 0x1c0000,
> };
> 
> static const struct of_device_id starfive_dwmac_match[] = {
>   { .compatible = "starfive,jh7110-dwmac", .data =
> &starfive_dwmac_jh7110_data },
>   { /* sentinel */ }
> };
> 
> and in the probe function:
> 
Hi Emil, Yes，this is usually a good solution, and I have considered this plan before.
However, gmac0 of jh7110 is different from the reg/mask of gmac1.
You can find it in patch-9:

&gmac0 {
	starfive,syscon = <&aon_syscon 0xc 0x1c0000>;
};

&gmac1 {
	starfive,syscon = <&sys_syscon 0x90 0x1c>;
};

In this case, using match_data of starfive,jh7110-dwma does not seem to be compatible.

> struct starfive_dwmac_match_data *pdata = device_get_match_data(&pdev->dev);
> 
>> +       if (IS_ERR(regmap))
>> +               return PTR_ERR(regmap);
>> +
>> +       return regmap_update_bits(regmap, reg, mask, mode << __ffs(mask));
>> +}
>> +
>>  static int starfive_dwmac_probe(struct platform_device *pdev)
>>  {
>>         struct plat_stmmacenet_data *plat_dat;
>> @@ -93,6 +138,7 @@ static int starfive_dwmac_probe(struct platform_device *pdev)
>>         plat_dat->bsp_priv = dwmac;
>>         plat_dat->dma_cfg->dche = true;
>>
>> +       starfive_dwmac_set_mode(plat_dat);
> 
> The function returns errors in an int, but you never check it :(
> 
Thank you for pointing out that it will be added in the next version.
>>         err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>>         if (err) {
>>                 stmmac_remove_config_dt(pdev, plat_dat);


Best regards,
Samin

>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv

-- 
Best regards,
Samin
