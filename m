Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5018B6C96F7
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjCZQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 12:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjCZQxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 12:53:02 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753EA2706;
        Sun, 26 Mar 2023 09:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679849542; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cGZWbB5JN/JIFEc3tTB3UP7NtGWQnQ7wzn5V1W/+J/swFJRSb/nsENYDpmPw+waxewiRzj3P7thE4jKuoK/l87SINy7T99nLt3TVJJB0/9ebT6Sf334IVDOxOJo2PSZzIhESXue4gMa7bONc1rujCwt9wZR46HNStKLsWmNaUCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1679849542; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Pm2id/8HeAjvdMr9qeOZKQ4PCbqDMhwjPFnaPN3ne2U=; 
        b=RTZIV7Eqw55cvrY9VRSv1ZIeKV8rx6dttxkLkY4OFR5yfOxMyt/f464JnmYeDNxdlSl50X2BwhkINPOAVAD0718A++NbcRPONIBppW6duVvx51IU9Ho1rtf1cTsi90lpF/0UkeqXz4yeNecx0Z0WFKOkka7ruhB5RTyW7irYL5Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1679849542;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Pm2id/8HeAjvdMr9qeOZKQ4PCbqDMhwjPFnaPN3ne2U=;
        b=DQUDycAW/N2VVqHQJRLR5UEh5qR8iyrxOjIvrJQ/voqNEHyhnzJsRzqGJndXydW3
        auNdHMl5VYyakzSTOntm9w+zydxKC/0ruZcgxlxJuRfay3U9RnmwFSluqk4hlfmwW4D
        YjDy94bbKuIxgk1Af9qngITD/vhn8miIRze2prOQ=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1679849540391603.7287847039937; Sun, 26 Mar 2023 09:52:20 -0700 (PDT)
Message-ID: <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
Date:   Sun, 26 Mar 2023 19:52:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: Move MT7530 phy muxing from DSA to PHY driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com>
 <YyKQKRIYDIVeczl1@lunn.ch> <dad09430-4f33-7f1d-76c7-4dbd0710e950@arinc9.com>
 <YyXiswbZfDh8aZHN@lunn.ch> <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
 <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
Content-Language: en-US
In-Reply-To: <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
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

On 19.09.2022 01:58, Florian Fainelli wrote:
> 
> 
> On 9/18/2022 4:28 AM, Arınç ÜNAL wrote:
>> On 17.09.2022 18:07, Andrew Lunn wrote:
>>>>> Where in the address range is the mux register? Officially, PHY
>>>>> drivers only have access to PHY registers, via MDIO. If the mux
>>>>> register is in the switch address space, it would be better if the
>>>>> switch did the mux configuration. An alternative might be to represent
>>>>> the mux in DT somewhere, and have a mux driver.
>>>>
>>>> I don't know this part very well but it's in the register for hw trap
>>>> modification which, I think, is in the switch address space.
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c?id=1f9a6abecf538cc73635f6082677a2f4dc9c89a4#n941
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.h?id=1f9a6abecf538cc73635f6082677a2f4dc9c89a4#n500
>>>>
>>>> Like you said, I don't think we can move away from the DSA driver, 
>>>> and would
>>>> rather keep the driver do the mux configuration.
>>>>
>>>> We could change the check for phy muxing to define the phy muxing 
>>>> bindings
>>>> in the DSA node instead. If I understand correctly, the mdio address 
>>>> for
>>>> PHYs is fake, it's for the sole purpose of making the driver check if
>>>> there's request for phy muxing and which phy to mux. I'm saying this 
>>>> because
>>>> the MT7530 switch works fine at address 0 while also using phy0 as a 
>>>> slave
>>>> interface.
>>>>
>>>> A property could be introduced on the DSA node for the MT7530 DSA 
>>>> driver:
>>>>
>>>>      mdio {
>>>>          #address-cells = <1>;
>>>>          #size-cells = <0>;
>>>>
>>>>          switch@0 {
>>>>              compatible = "mediatek,mt7530";
>>>>              reg = <0>;
>>>>
>>>>              reset-gpios = <&pio 33 0>;
>>>>
>>>>              core-supply = <&mt6323_vpa_reg>;
>>>>              io-supply = <&mt6323_vemc3v3_reg>;
>>>>
>>>>              mt7530,mux-phy = <&sw0_p0>;
>>>>
>>>>              ethernet-ports {
>>>>                  #address-cells = <1>;
>>>>                  #size-cells = <0>;
>>>>
>>>>                  sw0_p0: port@0 {
>>>>                      reg = <0>;
>>>>                  };
>>>>              };
>>>>          };
>>>>      };
>>>>
>>>> This would also allow using the phy muxing feature with any ethernet 
>>>> mac.
>>>> Currently, phy muxing check wants the ethernet mac to be gmac1 of a 
>>>> MediaTek
>>>> SoC. However, on a standalone MT7530, the switch can be wired to any 
>>>> SoC's
>>>> ethernet mac.
>>>>
>>>> For the port which is set for PHY muxing, do not bring it as a slave
>>>> interface, just do the phy muxing operation.
>>>>
>>>> Do not fail because there's no CPU port (ethernet property) defined 
>>>> when
>>>> there's only one port defined and it's set for PHY muxing.
>>>>
>>>> I don't know if the ethernet mac needs phy-handle defined in this case.
>>>
>>>  From mediatek,mt7530.yaml:
>>>
>>>    Port 5 modes/configurations:
>>>    1. Port 5 is disabled and isolated: An external phy can interface 
>>> to the 2nd
>>>       GMAC of the SOC.
>>>       In the case of a build-in MT7530 switch, port 5 shares the 
>>> RGMII bus with 2nd
>>>       GMAC and an optional external phy. Mind the GPIO/pinctl 
>>> settings of the SOC!
>>>    2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 
>>> 2nd GMAC.
>>>       It is a simple MAC to PHY interface, port 5 needs to be setup 
>>> for xMII mode
>>>       and RGMII delay.
>>>    3. Port 5 is muxed to GMAC5 and can interface to an external phy.
>>>       Port 5 becomes an extra switch port.
>>>       Only works on platform where external phy TX<->RX lines are 
>>> swapped.
>>>       Like in the Ubiquiti ER-X-SFP.
>>>    4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 
>>> 2nd CPU port.
>>>       Currently a 2nd CPU port is not supported by DSA code.
>>>
>>> So this mux has a scope bigger than the switch, it also affects one of
>>> the SoCs MACs.
>>>
>>> The phy-handle should have all the information you need, but it is
>>> scattered over multiple locations. It could be in switch port 5, or it
>>> could be in the SoC GMAC node.
>>>
>>> Although the mux is in the switches address range, could you have a
>>> tiny driver using that address range. Have this tiny driver export a
>>> function to set the mux. Both the GMAC and the DSA driver make use of
>>> the function, which should be enough to force the tiny driver to load
>>> first. The GMAC and the DSA driver can then look at there phy-handle,
>>> and determine how the mux should be set. The GMAC should probably do
>>> that before register_netdev. The DSA driver before it registers the
>>> switch with the DSA core.
>>>
>>> Does that solve all your ordering issues?
>>
>> I believe it does.
>>
>>>
>>> By using the phy-handle, you don't need any additional properties, so
>>> backwards compatibility should not be a problem. You can change driver
>>> code as much as you want, but ABI like DT is fixed.
>>
>> Understood, thanks Andrew!
> 
> Yes this seems like a reasonably good idea, I would be a bit concerned 
> about possibly running into issues with fw_devlink=on and whichever 
> driver is managing the PHY device not being an actual PHY device driver 
> provider and thus preventing the PHY device consumers from probing. This 
> is not necessarily an issue right now though because 'phy-handle' is not 
> (yet again) part of of_supplier_bindings.
> 
> Maybe what you can do is just describe that mux register space using a 
> dedicated DT node, and use a syscon phandle for both the switch and/or 
> the MAC and have them use an exported symbol routine that is responsible 
> for configuring the mux in an atomic and consistent way.

I'm currently working on the mt7530 driver and I think I found a way
that takes the least effort, won't break the ABI, and most importantly,
will work.

As we acknowledged, the registers are in the switch address space. This
must also mean that the switch must be properly probed before doing
anything with the registers.

I'm not sure how exactly making a tiny driver would work in this case.

I figured we can just run the phy muxing code before the DSA driver
exits because there are no (CPU) ports defined on the devicetree. Right
after probing is done on mt7530_probe, before dsa_register_switch() is run.

For proof of concept, I've moved some necessary switch probing code from
mt7530_setup() to mt7530_probe(). After the switch is properly reset,
phy4 is muxed, before dsa_register_switch() is run.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b0d9ea7b8e6d..0c1d9f83e73b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2085,7 +2085,6 @@ mt7530_setup(struct dsa_switch *ds)
  	struct device_node *dn = NULL;
  	struct device_node *phy_node;
  	struct device_node *mac_np;
-	struct mt7530_dummy_poll p;
  	phy_interface_t interface;
  	struct dsa_port *cpu_dp;
  	u32 id, val;
@@ -2111,58 +2110,6 @@ mt7530_setup(struct dsa_switch *ds)
  	ds->assisted_learning_on_cpu_port = true;
  	ds->mtu_enforcement_ingress = true;
  
-	if (priv->id == ID_MT7530) {
-		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
-		ret = regulator_enable(priv->core_pwr);
-		if (ret < 0) {
-			dev_err(priv->dev,
-				"Failed to enable core power: %d\n", ret);
-			return ret;
-		}
-
-		regulator_set_voltage(priv->io_pwr, 3300000, 3300000);
-		ret = regulator_enable(priv->io_pwr);
-		if (ret < 0) {
-			dev_err(priv->dev, "Failed to enable io pwr: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	/* Reset whole chip through gpio pin or memory-mapped registers for
-	 * different type of hardware
-	 */
-	if (priv->mcm) {
-		reset_control_assert(priv->rstc);
-		usleep_range(1000, 1100);
-		reset_control_deassert(priv->rstc);
-	} else {
-		gpiod_set_value_cansleep(priv->reset, 0);
-		usleep_range(1000, 1100);
-		gpiod_set_value_cansleep(priv->reset, 1);
-	}
-
-	/* Waiting for MT7530 got to stable */
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
-	ret = readx_poll_timeout(_mt7530_read, &p, val, val != 0,
-				 20, 1000000);
-	if (ret < 0) {
-		dev_err(priv->dev, "reset timeout\n");
-		return ret;
-	}
-
-	id = mt7530_read(priv, MT7530_CREV);
-	id >>= CHIP_NAME_SHIFT;
-	if (id != MT7530_ID) {
-		dev_err(priv->dev, "chip %x can't be supported\n", id);
-		return -ENODEV;
-	}
-
-	/* Reset the switch through internal reset */
-	mt7530_write(priv, MT7530_SYS_CTRL,
-		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-		     SYS_CTRL_REG_RST);
-
  	mt7530_pll_setup(priv);
  
  	/* Lower Tx driving for TRGMII path */
@@ -3079,6 +3026,9 @@ mt7530_probe(struct mdio_device *mdiodev)
  {
  	struct mt7530_priv *priv;
  	struct device_node *dn;
+	struct mt7530_dummy_poll p;
+	u32 id, val;
+	int ret;
  
  	dn = mdiodev->dev.of_node;
  
@@ -3155,6 +3105,91 @@ mt7530_probe(struct mdio_device *mdiodev)
  	mutex_init(&priv->reg_mutex);
  	dev_set_drvdata(&mdiodev->dev, priv);
  
+	if (priv->id == ID_MT7530) {
+		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
+		ret = regulator_enable(priv->core_pwr);
+		if (ret < 0) {thought a bit of what exactly
+			dev_err(priv->dev,
+				"Failed to enable core power: %d\n", ret);
+			return ret;
+		}
+
+		regulator_set_voltage(priv->io_pwr, 3300000, 3300000);
+		ret = regulator_enable(priv->io_pwr);
+		if (ret < 0) {
+			dev_err(priv->dev, "Failed to enable io pwr: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	/* Reset whole chip through gpio pin or memory-mapped registers for
+	 * different type of hardware
+	 */
+	if (priv->mcm) {
+		reset_control_assert(priv->rstc);
+		usleep_range(1000, 1100);
+		reset_control_deassert(priv->rstc);
+	} else {
+		gpiod_set_value_cansleep(priv->reset, 0);
+		usleep_range(1000, 1100);
+		gpiod_set_value_cansleep(priv->reset, 1);
+	}
+
+	/* Waiting for MT7530 got to stable */
+	INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
+	ret = readx_poll_timeout(_mt7530_read, &p, val, val != 0,
+				 20, 1000000);
+	if (ret < 0) {
+		dev_err(priv->dev, "reset timeout\n");
+		return ret;
+	}
+
+	id = mt7530_read(priv, MT7530_CREV);
+	id >>= CHIP_NAME_SHIFT;
+	if (id != MT7530_ID) {
+		dev_err(priv->dev, "chip %x can't be supported\n", id);
+		return -ENODEV;
+	}
+
+	/* Reset the switch through internal reset */
+	mt7530_write(priv, MT7530_SYS_CTRL,
+		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
+		     SYS_CTRL_REG_RST);
+
+	/* Setup phy muxing */
+	mutex_lock(&priv->reg_mutex);
+
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+
+	val |= MHWTRAP_MANUAL | MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
+	val &= ~MHWTRAP_P5_RGMII_MODE & ~MHWTRAP_PHY0_SEL;
+
+	/* MT7530_P5_MODE_GPHY_P4: 2nd GMAC -> P5 -> P4 */
+	val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
+
+	/* Setup the MAC by default for the cpu port */
+	mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
+
+	val |= MHWTRAP_P5_RGMII_MODE;
+
+	/* P5 RGMII RX Clock Control: delay setting for 1000M */
+	mt7530_write(priv, MT7530_P5RGMIIRXCR, CSR_RGMII_EDGE_ALIGN);
+
+	/* P5 RGMII TX Clock Control: delay x */
+	mt7530_write(priv, MT7530_P5RGMIITXCR,
+		     CSR_RGMII_TXC_CFG(0x10 + 4));
+
+	/* reduce P5 RGMII Tx driving, 8mA */
+	mt7530_write(priv, MT7530_IO_DRV_CR,
+		     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+
+	mt7530_write(priv, MT7530_MHWTRAP, val);
+
+	dev_info(priv->dev, "muxing phy4 to gmac5\n");
+
+	mutex_unlock(&priv->reg_mutex);
+
  	return dsa_register_switch(priv->ds);
  }
  

[    0.650721] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
[    0.660285] mt7530 mdio-bus:1f: muxing phy4 to gmac5
[    0.665284] mt7530 mdio-bus:1f: no ports child node found
[    0.670688] mt7530: probe of mdio-bus:1f failed with error -22
[    0.679118] mtk_soc_eth 1e100000.ethernet: generated random MAC address b6:9c:4d:eb:1f:8e
[    0.688922] mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 15

---

# ifup eth0
[   30.674595] mtk_soc_eth 1e100000.ethernet eth0: configuring for fixed/rgmii link mode
[   30.683451] mtk_soc_eth 1e100000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
# ping 192.168.2.2
PING 192.168.2.2 (192.168.2.2): 56 data bytes
64 bytes from 192.168.2.2: seq=0 ttl=64 time=0.688 ms
64 bytes from 192.168.2.2: seq=1 ttl=64 time=0.375 ms
64 bytes from 192.168.2.2: seq=2 ttl=64 time=0.357 ms
64 bytes from 192.168.2.2: seq=3 ttl=64 time=0.323 ms

---

# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
     inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
     link/ether b6:9c:4d:eb:1f:8e brd ff:ff:ff:ff:ff:ff
     inet 192.168.2.1/24 scope global eth0
        valid_lft forever preferred_lft forever

There is a lot to do, such as fixing the method to read from the
devicetree as it relies on the mac node the CPU port is connected to but
when this is finalised, we should be able to use it like this:

mac@1 {
	compatible = "mediatek,eth-mac";
	reg = <1>;
	phy-mode = "rgmii";
	phy-handle = <&ethphy0>;
};

mdio-bus {
	#address-cells = <1>;
	#size-cells = <0>;

	ethphy0: ethernet-phy@0 {
		reg = <0>;
	};

	switch@1f {
		compatible = "mediatek,mt7530";
		reg = <0x1f>;
		reset-gpios = <&pio 33 0>;
		core-supply = <&mt6323_vpa_reg>;
		io-supply = <&mt6323_vemc3v3_reg>;
	};
};

Arınç
