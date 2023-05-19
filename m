Return-Path: <netdev+bounces-3853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E84709262
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A95DB281BD4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9816116;
	Fri, 19 May 2023 09:01:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0316112
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:01:23 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C19BA2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684486831; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fYEAZ8Gp1Hp0qDLdLWLNuxJdMcdp4og0k8UeIyLchBtZFdhKbJ2IFXHl8GCpdmGxmRAuHHnW9/+I/lHtiWgTFQ2FVOJ1ISoqVURgqtCqJQDjGavPEAZQGlz8FQ0Mikv8P4wj/1MNMirY4r3BfljiNSHOKNDyhyP/ekmAaQHWEMk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684486831; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=cYqPkDu+17M5eEnoLNpjB6yRRqv056A2dzxMSkkvE3Y=; 
	b=AV3BJEIX7nlq/cVfWkO9vr68q8zwK9yT+0KkgbVNqAhzhIArhZ77aiqDU8maf7BoorZ9fgHqKwImHSi/GL7wmx0db+vgKGEk4ljRAkU2OnQR0fzpkjfkOwLbtNYtZ4RxM1FznhDTwJqY2dRKW8Cmn5ujdQKVYaF0Xx1tXm8RLd4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684486831;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=cYqPkDu+17M5eEnoLNpjB6yRRqv056A2dzxMSkkvE3Y=;
	b=J7EZEfYxGasTNX87JlwBzDGmBOp6Tar7wN2db44shfPpNplGAhpCH8wMKAzLtFqN
	+jY0PV8UK/sR8/eOtjs0aT1/Pn0YKgtJaA+JMW5GIheQBa6l9bs2mxLFRQJ86iVQA6r
	S4SJk6bt6QJMRO2lXetIhQwzvsxkizos3DurTdRU=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684486830458825.6932578383346; Fri, 19 May 2023 02:00:30 -0700 (PDT)
Message-ID: <e140cec6-132c-0e3a-d48a-88cd176b9875@arinc9.com>
Date: Fri, 19 May 2023 12:00:17 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Choose a default DSA CPU port
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Frank Wunderlich <frank-w@public-files.de>, Felix Fietkau <nbd@nbd.name>,
 netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 John Crispin <john@phrozen.org>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Landen Chao <Landen.Chao@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, mithat.guner@xeront.com
References: <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
 <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
 <20230517161657.a6ej5z53qicqe5aj@skbuf>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <20230518142422.62hm5d4orvy7nroz@skbuf>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230518142422.62hm5d4orvy7nroz@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18.05.2023 17:24, Vladimir Oltean wrote:
> On Thu, May 18, 2023 at 01:36:42PM +0300, Arınç ÜNAL wrote:
>> The frames won't necessarily be trapped to the CPU port the user port is
>> connected to. This operation is only there to make sure the trapped frames
>> always reach the CPU.
> 
> That's kind of understated and I don't regard that as that big of a deal.
> Since control packets cannot be guaranteed to be processed by the
> conduit interface affine to the user port, I would go one step further
> and say: don't even attempt to keep an affinity, just use for that purpose
> the numerically first conduit interface that is up.

Makes sense. Good thing the MT7531 switch is capable of having the control
packets processed by the DSA conduit interface affine to the user port so
it's only the MT7530 switch that we need to implement "don't even attempt
to keep an affinity, just use the numerically first conduit interface that
is up" for.

> 
>> I don't (know how to) check for other conduits being up when changing the
>> trap port. So if a conduit is set down which results in both conduits being
>> down, the trap port will still be changed to the other port which is
>> unnecessary but it doesn't break anything.
>>
>> Looking forward to your comments.
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index b5c8fdd381e5..55c11633f96f 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -961,11 +961,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>>   	mt7530_set(priv, MT753X_MFC, MT753X_BC_FFP(BIT(port)) |
>>   		   MT753X_UNM_FFP(BIT(port)) | MT753X_UNU_FFP(BIT(port)));
>> -	/* Set CPU port number */
>> -	if (priv->id == ID_MT7621)
>> -		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
>> -			   MT7530_CPU_PORT(port));
>> -
>>   	/* Add the CPU port to the CPU port bitmap for MT7531 and switch on
>>   	 * MT7988 SoC. Any frames set for trapping to CPU port will be trapped
>>   	 * to the CPU port the user port is connected to.
>> @@ -2258,6 +2253,10 @@ mt7530_setup(struct dsa_switch *ds)
>>   			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>>   	}
>> +	/* Trap BPDUs to the CPU port */
>> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> +		   MT753X_BPDU_CPU_ONLY);
>> +
> 
> This part will need its own patch + explanation

Will split.

> .
>>   	/* Setup VLAN ID 0 for VLAN-unaware bridges */
>>   	ret = mt7530_setup_vlan0(priv);
>>   	if (ret)
>> @@ -2886,6 +2885,50 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
>>   	.pcs_an_restart = mt7530_pcs_an_restart,
>>   };
>> +static void
>> +mt753x_master_state_change(struct dsa_switch *ds,
>> +			   const struct net_device *master,
>> +			   bool operational)
>> +{
>> +	struct mt7530_priv *priv = ds->priv;
>> +	struct dsa_port *cpu_dp = master->dsa_ptr;
>> +	unsigned int trap_port;
>> +
>> +	/* Set the CPU port to trap frames to for MT7530. There can be only one
>> +	 * CPU port due to MT7530_CPU_PORT having only 3 bits. Any frames set
>> +	 * for trapping to CPU port will be trapped to the CPU port connected to
>> +	 * the most recently set up DSA conduit. If the most recently set up DSA
>> +	 * conduit is set down, frames will be trapped to the CPU port connected
>> +	 * to the other DSA conduit.
>> +	 */
>> +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621) {
> 
> Just return early which saves one level of indentation.
> 
> 	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
> 		return;

Will do.

> 
>> +		trap_port = (mt7530_read(priv, MT753X_MFC) & MT7530_CPU_PORT_MASK) >> 4;
>> +		dev_info(priv->dev, "trap_port is %d\n", trap_port);
>> +		if (operational) {
>> +			dev_info(priv->dev, "the conduit for cpu port %d is up\n", cpu_dp->index);
>> +
>> +			/* This check will be unnecessary if we find a way to
>> +			 * not change the trap port to the other port when a
>> +			 * conduit is set down which results in both conduits
>> +			 * being down.
>> +			 */
>> +			if (!(cpu_dp->index == trap_port)) {
>> +				dev_info(priv->dev, "trap to cpu port %d\n", cpu_dp->index);
>> +				mt7530_set(priv, MT753X_MFC, MT7530_CPU_EN);
>> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(cpu_dp->index));
>> +			}
>> +		} else {
>> +			if (cpu_dp->index == 5 && trap_port == 5) {
>> +				dev_info(priv->dev, "the conduit for cpu port 5 is down, trap frames to port 6\n");
>> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(6));
>> +			} else if (cpu_dp->index == 6 && trap_port == 6) {
>> +				dev_info(priv->dev, "the conduit for cpu port 6 is down, trap frames to port 5\n");
>> +				mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_PORT_MASK, MT7530_CPU_PORT(5));
>> +			}
>> +		}
> 
> I believe that the implementation where you cache the "operational"
> value of previous calls will be cleaner. Something like this (written in
> an email client, so take it with a grain of salt):
> 
> struct mt7530_priv {
> 	unsigned long active_cpu_ports;
> 	...
> };
> 
> 	if (operational)
> 		priv->active_cpu_ports |= BIT(cpu_dp->index);
> 	else
> 		priv->active_cpu_ports &= ~BIT(cpu_dp->index);
> 
> 	if (priv->active_cpu_ports) {
> 		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_EN | MT7530_CPU_PORT_MASK,
> 			   MT7530_CPU_EN |
> 			   MT7530_CPU_PORT(__ffs(priv->active_cpu_ports)));

This is nice and simple, thank you.

> 	} else {
> 		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_EN | MT7530_CPU_PORT_MASK,
> 			   MT7530_CPU_PORT(0));

If I understand correctly, the MT7530_CPU_EN bit here wouldn't be modified
since it's not on the set parameter. On top of this, I believe we can
completely get rid of the else case. The MT7530_CPU_PORT bits will be
overwritten when there's an active CPU port so there's no need to clear
them when there's no active CPU ports. MT7530_CPU_EN might as well stay
set.

Arınç

