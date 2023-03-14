Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36F86B9E32
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCNSW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCNSW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:22:57 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D63A9DFC;
        Tue, 14 Mar 2023 11:22:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678818109; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=D4i9/oTLSLk394ZwoD80SvbBPKmmbAi7Re4lFe9cDkrfUCT6mezA90KEBkr/lJFbk7GS9gc0oGDOopk+bZiBV/ar+uHR3nf5eYu88f2JSpiv3V+9fR37/CVjfzhybtwFiPgTYCfIke/8d8MptuT8zaO/eVUKpM2FC1GvF4ZWqkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678818109; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xR2ZuMBgL0CR3gcHLjvqNZioqN17cEC9aRmXB7527zk=; 
        b=W/FYTpvgT1byFHRbWt97MhdSyUFSVN8y/n5Q60opw2F1uiG7P96tOtLN5VobZlEpCtyCZ2vW7IX07xrvXMM/1IyL5ngwgE8y8UWEikOt7MIVQqzQE1eGVOdQIMm2MavrjfOH76TjviTuwiY02ZtlhetkitucAunS3WcZGONly+E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678818109;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=xR2ZuMBgL0CR3gcHLjvqNZioqN17cEC9aRmXB7527zk=;
        b=QJDdUEtFvFUGGQyT+Y85S9VcGvWVwZi9XElFU+Nqy1eOtoxb/CAu2ABlE2jHRtfC
        3StiErNC3t49HoQbp2+qjgEaEprxj3luGwu5Z1d8RrT/FunShBvh6PgdxmbxpnznXn+
        kI+BefOVZPKEof2Z+isc/+X/7ztglYuQ8UdNm+oE=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1678818108571530.742693346108; Tue, 14 Mar 2023 11:21:48 -0700 (PDT)
Message-ID: <c07651cd-27b4-5ba4-8116-398522327d27@arinc9.com>
Date:   Tue, 14 Mar 2023 21:21:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
 <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
 <ZBCyqdfaeF/q8oZr@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZBCyqdfaeF/q8oZr@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 20:45, Daniel Golle wrote:
> On Tue, Mar 14, 2023 at 08:16:35PM +0300, Arınç ÜNAL wrote:
>> On 9.03.2023 13:57, Daniel Golle wrote:
>>> [...]
>>> +static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
>>> +{
>>> +	struct mt7530_priv *priv = context;
>>> +
>>> +	*val = mt7530_read(priv, reg);
>>> +	return 0;
>>> +};
>>> +
>>> +static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
>>> +{
>>> +	struct mt7530_priv *priv = context;
>>> +
>>> +	mt7530_write(priv, reg, val);
>>> +	return 0;
>>> +};
>>> +
>>> +static int mt7530_regmap_update_bits(void *context, unsigned int reg,
>>> +				     unsigned int mask, unsigned int val)
>>> +{
>>> +	struct mt7530_priv *priv = context;
>>> +
>>> +	mt7530_rmw(priv, reg, mask, val);
>>> +	return 0;
>>> +};
>>> +
>>> +static const struct regmap_bus mt7531_regmap_bus = {
>>> +	.reg_write = mt7530_regmap_write,
>>> +	.reg_read = mt7530_regmap_read,
>>> +	.reg_update_bits = mt7530_regmap_update_bits,
>>
>> These new functions can be used for both switches, mt7530 and mt7531,
>> correct?
> 
> In theory, yes, they could be used on all switch ICs supported by the
> mt7530.c driver. In practise they are used on MT7531 only because MT7530
> and MT7621 don't have any SGMII/SerDes ports, but only MT7531 does.
> 
> 
>> If so, I believe they are supposed to be called mt753x since
>> 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
>> hardware").
>>
>> mt753x: functions that can be used for mt7530 and mt7531 switches.
>> mt7530: functions specific to mt7530 switch.
>> mt7531: functions specific to mt7531 switch.
> 
> Good catch, so mt7530_* is for sure not accurate. I used that naming
> due to existing function names mt7530_read, mt7530_write and mt7530_rmw.

I was going to send a mail to netdev mailing list to ask for opinions 
whether we should rename the mt7530 DSA driver to mt753x and rename 
these functions you mentioned to mt753x so it's crystal clear what code 
is for what hardware. Now that we glossed over it here, I guess I can 
ask it here instead.

> 
> Given the situation I've explained above I think that mt753x_* would
> be the best and I will change that for v14.
> 
> Thank you for reviewing!

Sounds good, cheers.

Arınç
