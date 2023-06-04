Return-Path: <netdev+bounces-7733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB51D721533
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE61281666
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 06:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C804F1844;
	Sun,  4 Jun 2023 06:35:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45A015C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 06:35:43 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3529CCA;
	Sat,  3 Jun 2023 23:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685860491; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=erCQxd+YBdCkDpaE5BA36sBxMJOluo5Z5jyEdHH0+A4QBsOfvbaHR/17OObiyG3KLxGwtEknxBesdwx4m5r1TefkDxl0JMsWU07dJm5pczsfT2rM2NMBItYJ1M9wyZy61TOFsNt8D6Vk52/TP5q554is9/58nQLmIY5WzU0I+pg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685860491; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=uiMHpFVM/380Kn9y5aEub6KAUoyuCoVXC9Kzr4xifEI=; 
	b=VcFmbyl/t+yizzKPuOrs2+X9BQJvbiEt4mBRq7ycpfeqCkarXSyPBoDpv/DlnXl+awn5Pn2HVu4hUuX2456hHB4UsFoIVoDMYkndULJIownBcrgMt2zY81jNYHi7jBwPPBUhix+Sa3ge6/Iuh3DD01sjbRZwvbmM3RldYEFMAWY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685860491;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=uiMHpFVM/380Kn9y5aEub6KAUoyuCoVXC9Kzr4xifEI=;
	b=FP7DGqNp3yaSsECmpxm5ZVJFfvjz3OXVykRA1xzKAx7GzFV7EDgaELi5CxEnWL6/
	l+elAZIuYXZR7BnTv4RZ6e+7r/O0PaxRXBD09ky7nncEtDOqrQrxzXVmbj+10smbUZX
	ock98qt525KQ/Slcexmyc8dH0cU9/WhfVCe7rp4s=
Received: from [192.168.83.218] (62.74.60.162 [62.74.60.162]) by mx.zohomail.com
	with SMTPS id 1685860488764677.0629841985701; Sat, 3 Jun 2023 23:34:48 -0700 (PDT)
Message-ID: <f9e29db7-7b95-290c-b44c-97cf95476141@arinc9.com>
Date: Sun, 4 Jun 2023 09:34:38 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from
 correct register
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-6-arinc.unal@arinc9.com>
 <20230524165701.pbrcs4e74juzb4r3@skbuf>
 <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
 <20230525133140.xewm6g5rl7sm57d2@skbuf>
Content-Language: en-US
In-Reply-To: <20230525133140.xewm6g5rl7sm57d2@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 25.05.2023 16:31, Vladimir Oltean wrote:
> On Thu, May 25, 2023 at 09:20:08AM +0300, Arınç ÜNAL wrote:
>> On 24.05.2023 19:57, Vladimir Oltean wrote:
>>> On Mon, May 22, 2023 at 03:15:07PM +0300, arinc9.unal@gmail.com wrote:
>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
>>>> macros for reading the crystal frequency were added under the MT7530_HWTRAP
>>>> register. However, the value given to the xtal variable on
>>>> mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.
>>>>
>>>> Although the document MT7621 Giga Switch Programming Guide v0.3 states that
>>>> the value can be read from both registers, use the register where the
>>>> macros were defined under.
>>>>
>>>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>> ---
>>>
>>> I'm sorry, but I refuse this patch, mainly as a matter of principle -
>>> because that's just not how we do things, and you need to understand why.
>>>
>>> The commit title ("read XTAL value from correct register") claims that
>>> the process of reading a field which cannot be changed by software is
>>> any more correct when it is read from HWTRAP rather than MHWTRAP
>>> (modified HWTRAP).
>>>
>>> Your justification is that it's confusing to you if two registers have
>>> the same layout, and the driver has a single set of macros to decode the
>>> fields from both. You seem to think it's somehow not correct to decode
>>> fields from the MHWTRAP register using macros which have just HWTRAP in
>>> the name.
>>
>> No, it doesn't confuse me that two registers share the same layout. My
>> understanding was that the MHWTRAP register should be used for modifying the
>> hardware trap, and the HWTRAP register should be used for reading from the
>> hardware trap.
> 
> My understanding is that reading from the read-only HWTRAP always gives
> you the power-on settings, while reading from the r/w MHWTRAP always
> gives you the current settings. If those settings coincide, as happens
> here, there's no practical difference.

I can confirm the bits on the HWTRAP register won't change after
changing the r/w bits on the MHWTRAP register.

	val = mt7530_read(priv, MT753X_HWTRAP);
	val &= ~MT7530_PHY_ACCESS;
	val |= MT7530_MANUAL;
	mt7530_write(priv, MT753X_MHWTRAP, val);

	val = mt7530_read(priv, MT753X_MHWTRAP);
	if (val & MT7530_PHY_ACCESS)
		dev_info(dev, "mhwtrap: MT7530_PHY_ACCESS is set\n");
	else
		dev_info(dev, "mhwtrap: MT7530_PHY_ACCESS is unset\n");

	val = mt7530_read(priv, MT753X_HWTRAP);
	if (val & MT7530_PHY_ACCESS)
		dev_info(dev, "hwtrap: MT7530_PHY_ACCESS is set\n");
	else
		dev_info(dev, "hwtrap: MT7530_PHY_ACCESS is unset\n");

[    4.194897] mt7530-mdio mdio-bus:00: mhwtrap: MT7530_PHY_ACCESS is unset
[    4.201770] mt7530-mdio mdio-bus:00: hwtrap: MT7530_PHY_ACCESS is set

> 
>> I see that the XTAL constants were defined under the HWTRAP
>> register so I thought it would make sense to change the code to read the
>> XTAL values from the HWTRAP register instead. Let me know if you disagree
>> with this.
> 
> I disagree as a matter of principle with the reasoning. The fact that
> XTAL constants are defined under HWTRAP is not a reason to change the
> code to read the XTAL values from the HWTRAP register. The fact that
> XTAL_FSEL is read-only in MHWTRAP is indeed a reason why you *could*
> read it from HWTRAP, but also not one why you *should* make a change.

Makes sense. I have refactored the hardware trap constants definitions
by looking at the documents for MT7530 and MT7531. The registers are the
same on both switches so I combine the bits under MT753X_(M)HWTRAP.

I put the r/w bits on MHWTRAP to MWHTRAP, the read-only bits on HWTRAP
and MHWTRAP to HWTRAP. Mind that the MT7531_CHG_STRAP bit exists only on
the MHWTRAP register.

To follow this, I read XTAL for MT7530 from HWTRAP instead of MHWTRAP
since the XTAL bits are read-only. Would this change make sense as a
matter of refactoring?

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5b77799f41cc..444fa97db7c0 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -420,9 +420,9 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
  	struct mt7530_priv *priv = ds->priv;
  	u32 ncpo1, ssc_delta, i, xtal;
  
-	mt7530_clear(priv, MT7530_MHWTRAP, MHWTRAP_P6_DIS);
+	mt7530_clear(priv, MT753X_MHWTRAP, MT7530_P6_DIS);
  
-	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+	xtal = mt7530_read(priv, MT753X_HWTRAP) & MT7530_XTAL_MASK;
  
  	if (interface == PHY_INTERFACE_MODE_RGMII) {
  		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
@@ -431,21 +431,21 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
  		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
  			   P6_INTF_MODE(1));
  
-		if (xtal == HWTRAP_XTAL_25MHZ)
+		if (xtal == MT7530_XTAL_25MHZ)
  			ssc_delta = 0x57;
  		else
  			ssc_delta = 0x87;
  
  		if (priv->id == ID_MT7621) {
  			/* PLL frequency: 125MHz: 1.0GBit */
-			if (xtal == HWTRAP_XTAL_40MHZ)
+			if (xtal == MT7530_XTAL_40MHZ)
  				ncpo1 = 0x0640;
-			if (xtal == HWTRAP_XTAL_25MHZ)
+			if (xtal == MT7530_XTAL_25MHZ)
  				ncpo1 = 0x0a00;
  		} else { /* PLL frequency: 250MHz: 2.0Gbit */
-			if (xtal == HWTRAP_XTAL_40MHZ)
+			if (xtal == MT7530_XTAL_40MHZ)
  				ncpo1 = 0x0c80;
-			if (xtal == HWTRAP_XTAL_25MHZ)
+			if (xtal == MT7530_XTAL_25MHZ)
  				ncpo1 = 0x1400;
  		}
  
@@ -487,12 +487,12 @@ mt7531_pll_setup(struct mt7530_priv *priv)
  
  	val = mt7530_read(priv, MT7531_CREV);
  	top_sig = mt7530_read(priv, MT7531_TOP_SIG_SR);
-	hwstrap = mt7530_read(priv, MT7531_HWTRAP);
+	hwstrap = mt7530_read(priv, MT753X_HWTRAP);
  	if ((val & CHIP_REV_M) > 0)
-		xtal = (top_sig & PAD_MCM_SMI_EN) ? HWTRAP_XTAL_FSEL_40MHZ :
-						    HWTRAP_XTAL_FSEL_25MHZ;
+		xtal = (top_sig & PAD_MCM_SMI_EN) ? MT7531_XTAL_FSEL_40MHZ :
+						    MT7531_XTAL_FSEL_25MHZ;
  	else
-		xtal = hwstrap & HWTRAP_XTAL_FSEL_MASK;
+		xtal = hwstrap & MT7531_XTAL25;
  
  	/* Step 1 : Disable MT7531 COREPLL */
  	val = mt7530_read(priv, MT7531_PLLGP_EN);
@@ -521,13 +521,13 @@ mt7531_pll_setup(struct mt7530_priv *priv)
  	usleep_range(25, 35);
  
  	switch (xtal) {
-	case HWTRAP_XTAL_FSEL_25MHZ:
+	case MT7531_XTAL_FSEL_25MHZ:
  		val = mt7530_read(priv, MT7531_PLLGP_CR0);
  		val &= ~RG_COREPLL_SDM_PCW_M;
  		val |= 0x140000 << RG_COREPLL_SDM_PCW_S;
  		mt7530_write(priv, MT7531_PLLGP_CR0, val);
  		break;
-	case HWTRAP_XTAL_FSEL_40MHZ:
+	case MT7531_XTAL_FSEL_40MHZ:
  		val = mt7530_read(priv, MT7531_PLLGP_CR0);
  		val &= ~RG_COREPLL_SDM_PCW_M;
  		val |= 0x190000 << RG_COREPLL_SDM_PCW_S;
@@ -902,32 +902,32 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
  
  	mutex_lock(&priv->reg_mutex);
  
-	val = mt7530_read(priv, MT7530_MHWTRAP);
+	val = mt7530_read(priv, MT753X_MHWTRAP);
  
-	val |= MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
-	val &= ~MHWTRAP_P5_RGMII_MODE & ~MHWTRAP_PHY0_SEL;
+	val |= MT7530_P5_MAC_SEL | MT7530_P5_DIS;
+	val &= ~MT7530_P5_RGMII_MODE & ~MT7530_P5_PHY0_SEL;
  
  	switch (priv->p5_mode) {
  	case MUX_PHY_P0:
  		/* MUX_PHY_P0: P0 -> P5 -> SoC MAC */
-		val |= MHWTRAP_PHY0_SEL;
+		val |= MT7530_P5_PHY0_SEL;
  		fallthrough;
  	case MUX_PHY_P4:
  		/* MUX_PHY_P4: P4 -> P5 -> SoC MAC */
-		val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
+		val &= ~MT7530_P5_MAC_SEL & ~MT7530_P5_DIS;
  
  		/* Setup the MAC by default for the cpu port */
  		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
  		break;
  	default:
  		/* GMAC5: P5 -> SoC MAC or external PHY */
-		val &= ~MHWTRAP_P5_DIS;
+		val &= ~MT7530_P5_DIS;
  		break;
  	}
  
  	/* Setup RGMII settings */
  	if (phy_interface_mode_is_rgmii(interface)) {
-		val |= MHWTRAP_P5_RGMII_MODE;
+		val |= MT7530_P5_RGMII_MODE;
  
  		/* P5 RGMII RX Clock Control: delay setting for 1000M */
  		mt7530_write(priv, MT7530_P5RGMIIRXCR, CSR_RGMII_EDGE_ALIGN);
@@ -943,7 +943,7 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
  			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
  	}
  
-	mt7530_write(priv, MT7530_MHWTRAP, val);
+	mt7530_write(priv, MT753X_MHWTRAP, val);
  
  	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, mode=%s, phy-mode=%s\n", val,
  		mt7530_p5_mode_str(priv->p5_mode), phy_modes(interface));
@@ -2188,7 +2188,7 @@ mt7530_setup(struct dsa_switch *ds)
  	}
  
  	/* Waiting for MT7530 got to stable */
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
+	INIT_MT7530_DUMMY_POLL(&p, priv, MT753X_HWTRAP);
  	ret = readx_poll_timeout(_mt7530_read, &p, val, val != 0,
  				 20, 1000000);
  	if (ret < 0) {
@@ -2203,7 +2203,7 @@ mt7530_setup(struct dsa_switch *ds)
  		return -ENODEV;
  	}
  
-	if (val == HWTRAP_XTAL_20MHZ) {
+	if (val == MT7530_XTAL_20MHZ) {
  		dev_err(priv->dev,
  			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
  			__func__);
@@ -2215,7 +2215,7 @@ mt7530_setup(struct dsa_switch *ds)
  		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
  		     SYS_CTRL_REG_RST);
  
-	if (val == HWTRAP_XTAL_40MHZ)
+	if (val == MT7530_XTAL_40MHZ)
  		mt7530_pll_setup(priv);
  
  	/* Lower P5 RGMII Tx driving, 8mA */
@@ -2230,10 +2230,10 @@ mt7530_setup(struct dsa_switch *ds)
  	/* Directly access the PHY registers via C_MDC/C_MDIO. The bit that
  	 * enables modifying the hardware trap must be set for this.
  	 */
-	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_PHY_ACCESS;
-	val |= MHWTRAP_MANUAL;
-	mt7530_write(priv, MT7530_MHWTRAP, val);
+	val = mt7530_read(priv, MT753X_MHWTRAP);
+	val &= ~MT7530_PHY_ACCESS;
+	val |= MT7530_CHG_TRAP;
+	mt7530_write(priv, MT753X_MHWTRAP, val);
  
  	/* Trap BPDUs to the CPU port */
  	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
@@ -2411,7 +2411,7 @@ mt7531_setup(struct dsa_switch *ds)
  	}
  
  	/* Waiting for MT7530 got to stable */
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
+	INIT_MT7530_DUMMY_POLL(&p, priv, MT753X_HWTRAP);
  	ret = readx_poll_timeout(_mt7530_read, &p, val, val != 0,
  				 20, 1000000);
  	if (ret < 0) {
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 2664057b3cd2..d7451943f5d6 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -445,31 +445,29 @@ enum mt7531_clk_skew {
  };
  
  /* Register for hw trap status */
-#define MT7530_HWTRAP			0x7800
-#define  HWTRAP_XTAL_MASK		(BIT(10) | BIT(9))
-#define  HWTRAP_XTAL_25MHZ		(BIT(10) | BIT(9))
-#define  HWTRAP_XTAL_40MHZ		(BIT(10))
-#define  HWTRAP_XTAL_20MHZ		(BIT(9))
-
-#define MT7531_HWTRAP			0x7800
-#define  HWTRAP_XTAL_FSEL_MASK		BIT(7)
-#define  HWTRAP_XTAL_FSEL_25MHZ		BIT(7)
-#define  HWTRAP_XTAL_FSEL_40MHZ		0
-/* Unique fields of (M)HWSTRAP for MT7531 */
-#define  XTAL_FSEL_S			7
-#define  XTAL_FSEL_M			BIT(7)
-#define  PHY_EN				BIT(6)
-#define  CHG_STRAP			BIT(8)
+#define MT753X_HWTRAP			0x7800
+#define  MT7530_XTAL_MASK		(BIT(10) | BIT(9))
+#define  MT7530_XTAL_25MHZ		(BIT(10) | BIT(9))
+#define  MT7530_XTAL_40MHZ		(BIT(10))
+#define  MT7530_XTAL_20MHZ		(BIT(9))
  
  /* Register for hw trap modification */
-#define MT7530_MHWTRAP			0x7804
-#define  MHWTRAP_PHY0_SEL		BIT(20)
-#define  MHWTRAP_MANUAL			BIT(16)
-#define  MHWTRAP_P5_MAC_SEL		BIT(13)
-#define  MHWTRAP_P6_DIS			BIT(8)
-#define  MHWTRAP_P5_RGMII_MODE		BIT(7)
-#define  MHWTRAP_P5_DIS			BIT(6)
-#define  MHWTRAP_PHY_ACCESS		BIT(5)
+#define MT753X_MHWTRAP			0x7804
+#define  MT7530_P5_PHY0_SEL		BIT(20)
+#define  MT7530_CHG_TRAP		BIT(16)
+#define  MT7530_P5_MAC_SEL		BIT(13)
+#define  MT7530_P6_DIS			BIT(8)
+#define  MT7530_P5_RGMII_MODE		BIT(7)
+#define  MT7530_P5_DIS			BIT(6)
+#define  MT7530_PHY_ACCESS		BIT(5)
+#define  MT7531_CHG_STRAP		BIT(8)
+#define  MT7531_XTAL25			BIT(7)
+#define  MT7531_PHY_EN			BIT(6)
+
+enum mt7531_xtal_fsel {
+	MT7531_XTAL_FSEL_40MHZ,
+	MT7531_XTAL_FSEL_25MHZ,
+};
  
  /* Register for TOP signal control */
  #define MT7530_TOP_SIG_CTRL		0x7808

Arınç

