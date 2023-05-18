Return-Path: <netdev+bounces-3577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADAA707E35
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9FA9281886
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B9F2A9E8;
	Thu, 18 May 2023 10:37:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC411C95
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:37:27 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64674EC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684406216; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=den1gAErOd2LDH5kLGGIBri2/0Onz65nMKfPha82ETstQmcN3LGCZzftEvpQsHcoTOzahbPW/B72gbB1eg3udEpSnZiyKtMxmm6Er28bLgadFkJv5z9lEuZ9YsL295wLuF8XoGgGfNFsLl/X8uDnwqwP7DM/b8YHqmy8JwxKB/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684406216; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=CFvHjSylmPnL7H52NzUujvp7/2U7c7lsjqvmZbfy+3I=; 
	b=FBc75W/prE94EaygAiLKzjGW2TanrIyu1ei02+zPTvK+TxNfNozLUH8ZnjIrfnlBe8ClKGzjHBjA9XNLg6w+Vn+3JN/mMfZNtTMortv32BXKmWIg+vzsq7J2VIxCie+xjl4QRAW84ZeW0QRVNTlUCXeTmdVTSPLIzoxTbL26OQE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684406216;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=CFvHjSylmPnL7H52NzUujvp7/2U7c7lsjqvmZbfy+3I=;
	b=E4QJbN7gBAzzx+sZwc76YH9+zGSI/sAs35836XO3oJ3Ttqn9L4XhC4a+C2USVs/A
	v4Cd8Osb2vt8EMjbZ/tat0t7FfKUVbZzUwKmsdRJqufId5UFas+bid+B2f5IgQ8XaFW
	inBacHKAYaLlx15r0hwReXuR9VGSfZBdKsvlcAXs=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684406214421333.573235803232; Thu, 18 May 2023 03:36:54 -0700 (PDT)
Message-ID: <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
Date: Thu, 18 May 2023 13:36:42 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Choose a default DSA CPU port
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Frank Wunderlich <frank-w@public-files.de>, Felix Fietkau <nbd@nbd.name>,
 netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 John Crispin <john@phrozen.org>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Landen Chao <Landen.Chao@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, mithat.guner@xeront.com
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
 <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
 <20230517161657.a6ej5z53qicqe5aj@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230517161657.a6ej5z53qicqe5aj@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17.05.2023 19:16, Vladimir Oltean wrote:
> On Wed, May 17, 2023 at 07:14:01PM +0300, Arınç ÜNAL wrote:
>> On 17.05.2023 19:10, Vladimir Oltean wrote:
>>> On Tue, May 16, 2023 at 10:29:27PM +0300, Arınç ÜNAL wrote:
>>>> For MT7530, the port to trap the frames to is fixed since CPU_PORT is only
>>>> of 3 bits so only one CPU port can be defined. This means that, in case of
>>>> multiple ports used as CPU ports, any frames set for trapping to CPU port
>>>> will be trapped to the numerically greatest CPU port.
>>>
>>> *that is up
>>
>> Yes, the DSA conduit interface of the CPU port must be up. Otherwise, these
>> frames won't appear anywhere. I should mention this on my patch, thanks.
> 
> Well, mentioning it in the patch or in a comment is likely not going to
> be enough. You likely have to implement ds->ops->master_state_change()
> and update the MT7530_MFC register to a value that is always valid when
> the conduit interfaces come and go.

Thanks for pointing this out. I have done this below and confirm frames are
trapped as expected.

The frames won't necessarily be trapped to the CPU port the user port is
connected to. This operation is only there to make sure the trapped frames
always reach the CPU.

I don't (know how to) check for other conduits being up when changing the
trap port. So if a conduit is set down which results in both conduits being
down, the trap port will still be changed to the other port which is
unnecessary but it doesn't break anything.

Looking forward to your comments.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b5c8fdd381e5..55c11633f96f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -961,11 +961,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
  	mt7530_set(priv, MT753X_MFC, MT753X_BC_FFP(BIT(port)) |
  		   MT753X_UNM_FFP(BIT(port)) | MT753X_UNU_FFP(BIT(port)));
  
-	/* Set CPU port number */
-	if (priv->id == ID_MT7621)
-		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
-			   MT7530_CPU_PORT(port));
-
  	/* Add the CPU port to the CPU port bitmap for MT7531 and switch on
  	 * MT7988 SoC. Any frames set for trapping to CPU port will be trapped
  	 * to the CPU port the user port is connected to.
@@ -2258,6 +2253,10 @@ mt7530_setup(struct dsa_switch *ds)
  			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
  	}
  
+	/* Trap BPDUs to the CPU port */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
  	/* Setup VLAN ID 0 for VLAN-unaware bridges */
  	ret = mt7530_setup_vlan0(priv);
  	if (ret)
@@ -2886,6 +2885,50 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
  	.pcs_an_restart = mt7530_pcs_an_restart,
  };
  
+static void
+mt753x_master_state_change(struct dsa_switch *ds,
+			   const struct net_device *master,
+			   bool operational)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	unsigned int trap_port;
+
+	/* Set the CPU port to trap frames to for MT7530. There can be only one
+	 * CPU port due to MT7530_CPU_PORT having only 3 bits. Any frames set
+	 * for trapping to CPU port will be trapped to the CPU port connected to
+	 * the most recently set up DSA conduit. If the most recently set up DSA
+	 * conduit is set down, frames will be trapped to the CPU port connected
+	 * to the other DSA conduit.
+	 */
+	if (priv->id == ID_MT7530 || priv->id == ID_MT7621) {
+		trap_port = (mt7530_read(priv, MT753X_MFC) & MT7530_CPU_PORT_MASK) >> 4;
+		dev_info(priv->dev, "trap_port is %d\n", trap_port);
+		if (operational) {
+			dev_info(priv->dev, "the conduit for cpu port %d is up\n", cpu_dp->index);
+
+			/* This check will be unnecessary if we find a way to
+			 * not change the trap port to the other port when a
+			 * conduit is set down which results in both conduits
+			 * being down.
+			 */
+			if (!(cpu_dp->index == trap_port)) {
+				dev_info(priv->dev, "trap to cpu port %d\n", cpu_dp->index);
+				mt7530_set(priv, MT753X_MFC, MT7530_CPU_EN);
+				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(cpu_dp->index));
+			}
+		} else {
+			if (cpu_dp->index == 5 && trap_port == 5) {
+				dev_info(priv->dev, "the conduit for cpu port 5 is down, trap frames to port 6\n");
+				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(6));
+			} else if (cpu_dp->index == 6 && trap_port == 6) {
+				dev_info(priv->dev, "the conduit for cpu port 6 is down, trap frames to port 5\n");
+				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(5));
+			}
+		}
+	}
+}
+
  static int
  mt753x_setup(struct dsa_switch *ds)
  {
@@ -2999,6 +3042,7 @@ const struct dsa_switch_ops mt7530_switch_ops = {
  	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
  	.get_mac_eee		= mt753x_get_mac_eee,
  	.set_mac_eee		= mt753x_set_mac_eee,
+	.master_state_change	= mt753x_master_state_change,
  };
  EXPORT_SYMBOL_GPL(mt7530_switch_ops);
  
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index fd2a2f726b8a..2abd3c5ce05a 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -41,8 +41,8 @@ enum mt753x_id {
  #define  MT753X_UNU_FFP(x)		(((x) & 0xff) << 8)
  #define  MT753X_UNU_FFP_MASK		MT753X_UNU_FFP(~0)
  #define  MT7530_CPU_EN			BIT(7)
-#define  MT7530_CPU_PORT(x)		((x) << 4)
-#define  MT7530_CPU_MASK		(0xf << 4)
+#define  MT7530_CPU_PORT(x)		(((x) & 0x7) << 4)
+#define  MT7530_CPU_PORT_MASK		MT7530_CPU_PORT(~0)
  #define  MT7530_MIRROR_EN		BIT(3)
  #define  MT7530_MIRROR_PORT(x)		((x) & 0x7)
  #define  MT7530_MIRROR_MASK		0x7

Arınç

