Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C06B257091
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 22:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgH3Urq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 16:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3Urp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 16:47:45 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063C7C061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 13:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=58jyAbVOfzWgjTzqSHr61sbmqb85OHW3L1u64weCF+M=; b=hlMPGDTu4yVZX3376OIssOliEX
        PgJFrO5yVK94JPwzqplqoevOMdOquLIUS5uVr7nIQgmlr2PPk1YiIaJLlRcptqMKGuKe/p/vxJBPh
        QHAnbgWp3M5sxlm+/xke54zwvca4h1DxHh54JgWCWBkMIczyHM/hyZ1/yY0H+cMgskKi6MVzQz8F/
        FKn1W184UuR3ZrgRDzcH8vjGwqT6KH5dxqpYDoljBOCfkAkd/2PCQ4n0gef6bDfc+C2Y3nhse42tU
        /oboVBT3vunzQsu2Bmd/FVippoFhmZ0Gxkc4G8tiEIRJC7rReFgxR9dc6zkzNa85MR1u/kliOxKHF
        ym6SIhYg==;
Received: from [185.135.2.40] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kCUEp-008y5G-CY; Sun, 30 Aug 2020 22:47:43 +0200
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
References: <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
 <20200829151553.GB2912863@lunn.ch>
 <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
 <20200829160047.GD2912863@lunn.ch>
 <79bcab16-5802-c075-1615-06c64078b6c9@arf.net.pl>
 <20200829231632.GB2966560@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <f1067d43-afe9-c59d-946d-54754fa602f0@arf.net.pl>
Date:   Sun, 30 Aug 2020 22:47:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829231632.GB2966560@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-08-30 o 01:16, Andrew Lunn pisze:
>> I meant that with the split description of the mdio node the mdio bus for
>> use in the system would be selected almost automatically. Suppose that I can
>> do the device tree "my way":
>> &fec2 {
>> ...
>>      mdio { phy2 ... };
>> ...
>> };
>> &fec1 {
>> ...
>>      mdio { phy1 ... };
>> ...
>> };
>> This emphasizes which PHY is intended for use by which FEC, that's why it
>> looks more natural for me.
> And it looks really wrong to me. It suggests there are two busses, and
> each PHY is on its own bus. When in fact there is one MDIO bus with
> two PHYs. Device tree should represents the real hardware, not some
> pseudo description.
>
>       Andrew

Sure, the "split" variant may cause a misleading first impression for a 
human reader. Similarly, one might argue that having both PHYs under one 
mdio node suggests that both PHYs are connected to the same FEC. One way 
or another, the device tree is a pretty complex thing and requires some 
effort to read it correctly. The important thing is if the kernel is 
getting the correct information.

The discussion got a bit off-topic, though. I'm not advocating any 
particular structure of the device tree, nor I'm saying any should be 
supported, as long the existing standard(s) make(s) it possible to do 
their job(s).

Getting back to the original problem, I have tried the solution with 
clocks defined under phy nodes, and it didn't work. eth0 was up, but 
eth1 again faced "fec 2188000.ethernet eth1: Unable to connect to phy". 
Details below, maybe it was my fault.

imx6ull.dtsi defines:

                         fec1: ethernet@2188000 {
                                 compatible = "fsl,imx6ul-fec", 
"fsl,imx6q-fec";
                                 reg = <0x2188000 0x4000>;
                                 interrupts = <GIC_SPI 118 
IRQ_TYPE_LEVEL_HIGH>,
                                              <GIC_SPI 119 
IRQ_TYPE_LEVEL_HIGH>;
                                 clocks = <&clks IMX6UL_CLK_ENET>,
                                          <&clks IMX6UL_CLK_ENET_AHB>,
                                          <&clks IMX6UL_CLK_ENET_PTP>,
                                          <&clks IMX6UL_CLK_ENET_REF>,
                                          <&clks IMX6UL_CLK_ENET_REF>;
                                 clock-names = "ipg", "ahb", "ptp",
                                               "enet_clk_ref", "enet_out";
                                 stop-mode = <&gpr 0x10 3>;
                                 fsl,num-tx-queues=<1>;
                                 fsl,num-rx-queues=<1>;
                                 fsl,magic-packet;
                                 fsl,wakeup_irq = <0>;
                                 status = "disabled";
                         };

                        fec2: ethernet@20b4000 {
                                 compatible = "fsl,imx6ul-fec", 
"fsl,imx6q-fec";
                                 reg = <0x20b4000 0x4000>;
                                 interrupts = <GIC_SPI 120 
IRQ_TYPE_LEVEL_HIGH>,
                                              <GIC_SPI 121 
IRQ_TYPE_LEVEL_HIGH>;
                                 clocks = <&clks IMX6UL_CLK_ENET>,
                                          <&clks IMX6UL_CLK_ENET_AHB>,
                                          <&clks IMX6UL_CLK_ENET_PTP>,
                                          <&clks IMX6UL_CLK_ENET2_REF_125M>,
                                          <&clks IMX6UL_CLK_ENET2_REF_125M>;
                                 clock-names = "ipg", "ahb", "ptp",
                                               "enet_clk_ref", "enet_out";
                                 stop-mode = <&gpr 0x10 4>;
                                 fsl,num-tx-queues=<1>;
                                 fsl,num-rx-queues=<1>;
                                 fsl,magic-packet;
                                 fsl,wakeup_irq = <0>;
                                 status = "disabled";
                         };

so in my top-level dts file (which includes imx6ull.dtsi) I've tried:

&fec1 {
         pinctrl-names = "default";
         pinctrl-0 = <&pinctrl_enet1>;
         phy-mode = "rmii";
         phy-handle = <&ethphy0>;
         status = "okay";
};

&fec2 {
         pinctrl-names = "default";
         pinctrl-0 = <&pinctrl_enet2>, <&pinctrl_enet2_mdio>;
         phy-mode = "rmii";
         phy-handle = <&ethphy1>;
         status = "okay";

         mdio {
                 #address-cells = <1>;
                 #size-cells = <0>;

                 ethphy0: ethernet-phy@0 {
                         reg = <0>;
                         clocks = <&clks IMX6UL_CLK_ENET_REF>;
                 };

                 ethphy1: ethernet-phy@1 {
                         reg = <1>;
                         clocks = <&clks IMX6UL_CLK_ENET2_REF_125M>;
                 };
         };
};

Adding compatible = "..." and max-speed = "..." didn't change anything.

Please, let me know if I omitted something important in the test, and if 
I should repeat it with amended device tree.

Best regards,
Adam

