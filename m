Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181BC6CB0D3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjC0Vkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC0Vky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:40:54 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A5E10E0;
        Mon, 27 Mar 2023 14:40:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679953217; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=CnqINhD0JxYCrwBPv605MLbpVlDOzikzzOxOqj5qhUn0jxgEGJ6AHpJp4RQyhMeWo68TyUefTkYpRbx6Ke6mNv9T+o7uyUGHyIprfSwF1HeKZJeJVUKMvCTRAao0jwvQufiafF5W9O1KcW5yfDc9qwrNM6QxNqxhLM/KP7r2vdc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1679953217; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Iti3YmQ6QZRAkK86zoA/mBc7nxnJTi9AuPJgslPE2wc=; 
        b=ShjxFBxP/n3E1cZ6exsXU+jEOSGxLZ2i3SCpULATaQTFouG9fNQmVp+dh8oDCPOWzzlIQYROl3qNied90gyAUEkO5bZoukCaoQ+mJ//h2l/K6f3QRNHQ0slwUwqqlxzYcoYKCOm4Qf/faOmlnGzARenqmX1IAyCR5GCy3zcnVd8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1679953217;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Iti3YmQ6QZRAkK86zoA/mBc7nxnJTi9AuPJgslPE2wc=;
        b=amoEXdo1W0O1xOFLjV/vj//zzZy5O0GYz95A4bsF8pJJjRH3FEYhklQnuXW5SVWp
        yMaHeP4ITbKFLgdr8fxgZYUUgwcoR0vyTg11x0Tt8L6x2O6ba1SwFONbe9+WfVCVBFV
        qWWV/gzezLq+07VIf85HinUc9l4SuQift2wWcFiI=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1679953215654371.39539986878196; Mon, 27 Mar 2023 14:40:15 -0700 (PDT)
Message-ID: <a97eb87d-bc36-cb31-b887-1feef40c4d34@arinc9.com>
Date:   Tue, 28 Mar 2023 00:40:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Move MT7530 phy muxing from DSA to PHY driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thibaut <hacks@slashdirt.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
 <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
 <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com> <YyKQKRIYDIVeczl1@lunn.ch>
 <dad09430-4f33-7f1d-76c7-4dbd0710e950@arinc9.com> <YyXiswbZfDh8aZHN@lunn.ch>
 <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
 <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
 <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
 <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
 <20230327183809.vhft6rqek3kisytb@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230327183809.vhft6rqek3kisytb@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2023 21:38, Vladimir Oltean wrote:
> On Sun, Mar 26, 2023 at 07:52:12PM +0300, Arınç ÜNAL wrote:
>> I'm currently working on the mt7530 driver and I think I found a way
>> that takes the least effort, won't break the ABI, and most importantly,
>> will work.
> 
> This sounds promising....
> 
>> As we acknowledged, the registers are in the switch address space. This
>> must also mean that the switch must be properly probed before doing
>> anything with the registers.
>>
>> I'm not sure how exactly making a tiny driver would work in this case.
> 
> I'm not sure how it would work, either. It sounds like the driver for
> the mdio-bus address @1f should have been a parent driver (MFD or not)
> with 2 (platform device) children, one for the switch and another for
> the HWTRAP registers and whatever else might be needed for the PHY
> multiplexing. The parent (mdio_device) driver deals with the chip-wide
> reset, resources, and manages the registers, giving them regmaps.
> The driver with the mux probably just exports a symbol representing a
> function that gets called by the "mediatek,eth-mac" driver and/or the
> switch driver.
> 
> BTW, I have something vaguely similar to this in a stalled WIP branch
> for sja1105, but things like this get really complicated really quickly
> if the DSA driver's DT bindings weren't designed from day one to not
> cover the entire switch's register map.
> 
>> I figured we can just run the phy muxing code before the DSA driver
>> exits because there are no (CPU) ports defined on the devicetree. Right
>> after probing is done on mt7530_probe, before dsa_register_switch() is run.
> 
> Aren't there timing issues, though? When is the earliest moment that the
> "mediatek,eth-mac" driver needs the HWTRAP muxing to be changed?
> The operation of changing that from the "mediatek,mt7530" driver is
> completely asynchronous to the probing of "mediatek,eth-mac".
> What's the worst that will happen with incorrect (not yet updated) GMII
> signal muxing? "Just" some lost packets?

We're not doing any changes to the MediaTek SoC's MAC if that's what 
you're asking. The phy muxing on the mt7530 DSA driver merely muxes PHY4 
of the switch to GMAC5 of the switch. Whatever MAC connected to GMAC5 
can access the muxed PHY.

It's just the current ABI that requires the MAC to be mediatek,eth-mac. 
PHY muxing can still be perfectly done with a simple property like 
mediatek,mt7530-muxphy = <0>;.

properties:
   mediatek,mt7530-muxphy:
     description:
       Set the PHY to mux to GMAC5. Only PHY0 or PHY4 can be muxed.
     enum:
       - 0
       - 4
     maxItems: 1

Whether or not PHY muxing will work with non-MediaTek MACs is still 
unknown as there is no known hardware that combines a standalone MT7530 
with a non-MediaTek SoC. Though in theory, it should work.

> 
>>
>> For proof of concept, I've moved some necessary switch probing code from
>> mt7530_setup() to mt7530_probe(). After the switch is properly reset,
>> phy4 is muxed, before dsa_register_switch() is run.
> 
> This is fragile because someone eager for some optimizations could move
> the code back the way it was, and say: "the switch initialization costs
> X ms and is done X times, because dsa_register_switch() -> ... ->
> of_find_net_device_by_node() returns -EPROBE_DEFER the first X-1 times.
> If we move the switch initialization to ds->ops->setup(), it will run
> only once, after the handle to the DSA master has been obtained, and
> this gives us a boost in kernel startup time."
> 
> It's even more fragile because currently (neither before nor after your change),
> mt7530_remove() does not do the mirror opposite of mt7530_probe(), and somebody
> eager from the future will notice this, and add an error handling path for
> dsa_register_switch(), which calls the opposite of regulator_enable(),
> regulator_disable(), saying "hey, there's no reason to let the regulators
> on if the switch failed to probe, it consumes power for nothing!".
> 
> It's an open question whether that regulator is needed for anything after
> the HWMUX registers has been changed, or if it can indeed be turned off.
> Not knowing this, it's hard to say if the change is okay or not.
> It seems that there's a high probability it will work for a while,
> by coincidence.

Let's just say that since it's needed for probing, it's best it stays 
on. This should prevent mt7530_remove() from going further if phy muxing 
is enabled.

> @@ -3167,6 +3173,9 @@ mt7530_remove(struct mdio_device *mdiodev)
>  	if (!priv)
>  		return;
>  
> +	if (priv->p5_intf_sel == (P5_INTF_SEL_PHY_P0 || P5_INTF_SEL_PHY_P4))
> +		return;
> +
>  	ret = regulator_disable(priv->core_pwr);
>  	if (ret < 0)
>  		dev_err(priv->dev,

Is mt7530_remove(), or to be more inclusive, the .remove operation of 
mdio_driver, run only when the switch fails to probe? If not, with the 
diff above, the switch won't be disabled in both of the cases (phy 
muxing only, phy muxing + normal DSA ports) if mt7530_remove() is run 
for some other reason.

> 
>>
>> [    0.650721] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
>> [    0.660285] mt7530 mdio-bus:1f: muxing phy4 to gmac5
>> [    0.665284] mt7530 mdio-bus:1f: no ports child node found
>> [    0.670688] mt7530: probe of mdio-bus:1f failed with error -22
>> [    0.679118] mtk_soc_eth 1e100000.ethernet: generated random MAC address b6:9c:4d:eb:1f:8e
>> [    0.688922] mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 15
>>
>> ---
>>
>> # ifup eth0
>> [   30.674595] mtk_soc_eth 1e100000.ethernet eth0: configuring for fixed/rgmii link mode
>> [   30.683451] mtk_soc_eth 1e100000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>> # ping 192.168.2.2
>> PING 192.168.2.2 (192.168.2.2): 56 data bytes
>> 64 bytes from 192.168.2.2: seq=0 ttl=64 time=0.688 ms
>> 64 bytes from 192.168.2.2: seq=1 ttl=64 time=0.375 ms
>> 64 bytes from 192.168.2.2: seq=2 ttl=64 time=0.357 ms
>> 64 bytes from 192.168.2.2: seq=3 ttl=64 time=0.323 ms
>>
>> ---
>>
>> # ip a
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>>      inet 127.0.0.1/8 scope host lo
>>         valid_lft forever preferred_lft forever
>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>>      link/ether b6:9c:4d:eb:1f:8e brd ff:ff:ff:ff:ff:ff
>>      inet 192.168.2.1/24 scope global eth0
>>         valid_lft forever preferred_lft forever
>>
>> There is a lot to do, such as fixing the method to read from the
>> devicetree as it relies on the mac node the CPU port is connected to but
>> when this is finalised, we should be able to use it like this:
>>
>> mac@1 {
>> 	compatible = "mediatek,eth-mac";
>> 	reg = <1>;
>> 	phy-mode = "rgmii";
>> 	phy-handle = <&ethphy0>;
>> };
>>
>> mdio-bus {
>> 	#address-cells = <1>;
>> 	#size-cells = <0>;
>>
>> 	ethphy0: ethernet-phy@0 {
>> 		reg = <0>;
>> 	};
>>
>> 	switch@1f {
>> 		compatible = "mediatek,mt7530";
>> 		reg = <0x1f>;
>> 		reset-gpios = <&pio 33 0>;
>> 		core-supply = <&mt6323_vpa_reg>;
>> 		io-supply = <&mt6323_vemc3v3_reg>;
>> 	};
>> };
> 
> And this is fragile because the "mediatek,eth-mac" driver only works
> because of the side effects of a driver that began to probe, and failed.
> Someone, seeing that "mediatek,mt7530" fails to probe, and knowing that
> the switch ports are not needed/used on that board, could put a
> status = "disabled"; property under the switch@1f node.

This should help.

> 	if (priv->p5_intf_sel == (P5_INTF_SEL_PHY_P0 || P5_INTF_SEL_PHY_P4)) {
> 		dev_info(priv->dev,
> 			 "PHY muxing is enabled, gracefully exiting\n");
> 		return;
> 	}

Arınç
