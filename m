Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7915B6DA4DD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 23:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbjDFVoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 17:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDFVon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 17:44:43 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDF59EC5;
        Thu,  6 Apr 2023 14:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680817429; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AlEkeDDLh1S57LcW+MhMjeu5fGJShDPvUxLGxVmhUt27lURr4otlLBohlOkXs69iC5B7c1rzzfZGvGuIwga8LllAiFvf8PwUiFlck3due6dI+cKysFDX02QiRnfbE2J82qeqtbqHcNIcZbJcOFmRu6iO2mx3n9gnR67MSBM8Gxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680817429; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=bVE9spa830jciEurhBWqjwWCocYdpwZjmnytSHBmldo=; 
        b=P6LnP9dNw8GN/wX461OxQzmsSmfr4edLN6CHv6FTR1+beYwmqbILS5ZBwWaDLz/93hIED/TjFDTUX3vzUnHJscjporZyRDrBDAEiOfZWIkRIpWTxrOhvSPs9btp0Fur1YSm0kc1ZXeQNcbX5nEz6Urxe2l374pUrO5+slhX7m5o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680817429;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=bVE9spa830jciEurhBWqjwWCocYdpwZjmnytSHBmldo=;
        b=eaZLIFgS5iARc4YQQQEMS+njWNQCN9vINNo1mV+ZjZhd1jo6CUE5F+QcRESC73Wm
        JCXN9EL2Pob1gjeg5OWY/evfqBmFqJKa9JcJuiW6WfHtuKPffkU8ulG7AYHnnjbXeOT
        e30Q16TkAydJ8apHkzILBY84Y/StV9AusOs061hg=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680817428744230.95149889101833; Thu, 6 Apr 2023 14:43:48 -0700 (PDT)
Message-ID: <e413a182-ce93-5831-09f5-19d34d7f7fcf@arinc9.com>
Date:   Fri, 7 Apr 2023 00:43:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications
 for MT7988
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406100445.52915-1-arinc.unal@arinc9.com>
 <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.04.2023 14:07, Russell King (Oracle) wrote:
> On Thu, Apr 06, 2023 at 01:04:45PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> On the switch on the MT7988 SoC, there are only 4 PHYs. There's only port 6
>> as the CPU port, there's no port 5. Split the switch statement with a check
>> to enforce these for the switch on the MT7988 SoC. The internal phy-mode is
>> specific to MT7988 so put it for MT7988 only.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>
>> Daniel, this is based on the information you provided me about the switch.
>> I will add this to my current patch series if it looks good to you.
>>
>> Arınç
>>
>> ---
>>   drivers/net/dsa/mt7530.c | 67 ++++++++++++++++++++++++++--------------
>>   1 file changed, 43 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index 6fbbdcb5987f..f167fa135ef1 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
>>   	phy_interface_zero(config->supported_interfaces);
>>   
>>   	switch (port) {
>> -	case 0 ... 4: /* Internal phy */
>> +	case 0 ... 3: /* Internal phy */
>>   		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>>   			  config->supported_interfaces);
>>   		break;
>> @@ -2710,37 +2710,56 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>   	struct mt7530_priv *priv = ds->priv;
>>   	u32 mcr_cur, mcr_new;
>>   
>> -	switch (port) {
>> -	case 0 ... 4: /* Internal phy */
>> -		if (state->interface != PHY_INTERFACE_MODE_GMII &&
>> -		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
>> -			goto unsupported;
>> -		break;
>> -	case 5: /* Port 5, a CPU port. */
>> -		if (priv->p5_interface == state->interface)
>> +	if (priv->id == ID_MT7988) {
>> +		switch (port) {
>> +		case 0 ... 3: /* Internal phy */
>> +			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> 
> How do these end up with PHY_INTERFACE_MODE_INTERNAL ? phylib defaults
> to GMII mode without something else being specified in DT.
> 
> Also note that you should *not* be validating state->interface in the
> mac_config() method because it's way too late to reject it - if you get
> an unsupported interface here, then that is down to the get_caps()
> method being buggy. Only report interfaces in get_caps() that you are
> prepared to handle in the rest of the system.

This is already the case for all three get_caps(). The supported 
interfaces for each port are properly defined.

Though mt7988_mac_port_get_caps() clears the 
config->supported_interfaces bitmap before reporting the supported 
interfaces. I don't think this is needed as all bits in the bitmap 
should already be initialized to zero when the phylink_config structure 
is allocated.

I'm not sure if your suggestion is to make sure the supported interfaces 
are properly reported on get_caps(), or validate state->interface 
somewhere else.

Arınç
