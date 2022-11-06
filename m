Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81761DFDD
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 02:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKFBEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 21:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiKFBEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 21:04:36 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEFE6162
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 18:04:35 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h193so7482527pgc.10
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 18:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8pbRgRMz93MgJ3ng2WonNZ1J1vZ2TR/siGch9DGVzP8=;
        b=fNEwbcRqsrKmm6B2fsd8BA3yW2/xPlsb1n5nvQW0YYKW2998A031LXngON1n1ygcE0
         L+t+V2kAXi9oVANEMZlTVhlBwz9w2p9BoKtX6rjklMVDxBxCIW0zpTk69uCoRPaYb7PG
         R6jfhLcb0vyBTIfcaiWpPxCwE5Qp+LMvanG6FeoL/7wTqPgrqwq0yb+AgxgSdKFKAzEJ
         VZ9jFyEFwsC2hM/qaPupf082247TJnteD+aT6H2Kg1Ypm3u8cfv0N3GtatlggMBudnaY
         ZoLZ1/TacVJZ4tjd+15xiUiRwoGPJ1IEmCjAK8MZGOmZiYpSp3aaq5ZxRVUXpRhLX6Hj
         T7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pbRgRMz93MgJ3ng2WonNZ1J1vZ2TR/siGch9DGVzP8=;
        b=0NVBBXpSSkQm3ldwNETxtjZUW8hTsj+FSpKk7ZUiIE2tfBrZIDeHHGGZkArzp1YruL
         NPbVrTjGsTlkqeS7ULlIWI97Beh3r4/dGe+Iehs8BSRXJ/Qhhs5riikK2qx1K6Dtf/sK
         Miz8Eh6qANzidvOX4TTBAzZTRqBcNsQjk0ZBjQXlfFOIMwYXUT9pv/lZKLFz0CGtaMP6
         8CrgYV3IQtHb5leWRmHxhj+o04X1olZ32d3vwW36uVAz9L+or6mbGk7XdE0n1BEZg1qa
         red4wzJDZNnWZSNYEV1z/N+yAgj3pWPsNViOGt9DnluNkIHzCAPqpxmHWgUkn3uMyXEw
         WsFA==
X-Gm-Message-State: ACrzQf1KjfnN6IxUndeB3oNPVzUX0+7mzm3rRiVmjlwypLZeqdSxeVHF
        1K0q5dwcGIjA0hdaeQPRfknhlzBxlu4=
X-Google-Smtp-Source: AMsMyM4BIWLXhPDao6wzX9bLUIkKUEzmZ8/ZzG4sNmolBNemlLYywSTYf5WsXy7H22Xcpry6qMJfQg==
X-Received: by 2002:a65:6e0e:0:b0:434:59e0:27d3 with SMTP id bd14-20020a656e0e000000b0043459e027d3mr35622998pgb.185.1667696674501;
        Sat, 05 Nov 2022 18:04:34 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:5dd9:75de:bccf:6555? ([2600:8802:b00:4a48:5dd9:75de:bccf:6555])
        by smtp.gmail.com with ESMTPSA id 2-20020a630602000000b0046ff3634a78sm1795844pgg.71.2022.11.05.18.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Nov 2022 18:04:33 -0700 (PDT)
Message-ID: <c68ba566-debb-8c3a-f97d-535b3eca49fe@gmail.com>
Date:   Sat, 5 Nov 2022 18:04:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
 <7186132a-7040-7131-396d-f1d6321e39d7@gmail.com>
 <Y2U/Ts5WqIf8pjJI@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y2U/Ts5WqIf8pjJI@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2022 9:35 AM, Russell King (Oracle) wrote:
> On Fri, Nov 04, 2022 at 08:40:56AM -0700, Florian Fainelli wrote:
>> On 11/4/2022 4:35 AM, Russell King (Oracle) wrote:
>>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>>> index 18a3847bd82b..6676971128d1 100644
>>> --- a/drivers/net/dsa/bcm_sf2.c
>>> +++ b/drivers/net/dsa/bcm_sf2.c
>>> @@ -727,6 +727,10 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
>>>    		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
>>>    		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
>>>    		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
>>> +
>>> +		/* FIXME 1: Are RGMII_RXID and RGMII_ID actually supported?
>>> +		 * See FIXME 2 and FIXME 3 below.
>>> +		 */
>>
>> They are supported, just not tested and still don't have hardware to test, I
>> suppose you can include both modes for simplicity if they end up being
>> broken, a fix would be submitted.
> 
> Okay, that sounds like we can add them to the switch() in
> bcm_sf2_sw_mac_config(). I assume id_mode_dis should be zero for
> these other modes.

Yes please.

> 
>>> +static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
>>> +				unsigned long *supported,
>>> +				struct phylink_link_state *state)
>>> +{
>>> +	u32 caps;
>>> +
>>> +	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
>>> +
>>> +	/* Pause modes are only programmed for these modes - see FIXME 3.
>>> +	 * So, as pause modes are not configured for other modes, disable
>>> +	 * support for them. If FIXME 3 is updated to allow the other RGMII
>>> +	 * modes, these should be included here as well.
>>> +	 */
>>> +	if (!(state->interface == PHY_INTERFACE_MODE_RGMII ||
>>> +	      state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>>> +	      state->interface == PHY_INTERFACE_MODE_MII ||
>>> +	      state->interface == PHY_INTERFACE_MODE_REVMII))
>>> +		caps &= ~(MAC_ASYM_PAUSE | MAC_SYM_PAUSE);
>>
>> Can be programmed on all ports.
> 
> If I understand you correctly, I think you mean that this can be
> programmed on all ports that support the RGMII control register:
> 
>          if (phy_interface_mode_is_rgmii(interface) ||
>              interface == PHY_INTERFACE_MODE_MII ||
>              interface == PHY_INTERFACE_MODE_REVMII) {
>                  reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
>                  reg = reg_readl(priv, reg_rgmii_ctrl);
>                  reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
> 
>                  if (tx_pause)
>                          reg |= TX_PAUSE_EN;
>                  if (rx_pause)
>                          reg |= RX_PAUSE_EN;
> 
>                  reg_writel(priv, reg, reg_rgmii_ctrl);
>          }
> 
> We seem to have several places in the code that make this decision -
> bcm_sf2_sw_mac_link_set(). I'm guessing, looking at
> bcm_sf2_reg_rgmii_cntrl(), that we _could_ use the device ID and port
> number in bcm_sf2_sw_get_caps() to narrow down whether the pause
> modes are supported - as ports that do not have the RGMII control
> register can't have pause modes programmed?
> 
> So for the BCM4908, it's just port 7, and for everything else it's
> ports 0-2.
> 
> That would mean something like:
> 
> static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
>                                  struct phylink_config *config)
> {
> ...
> 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
> ...
> 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000;
> 
> 	if (priv->type == BCM4908_DEVICE_ID ? port == 7 :
> 	    (port >= 0 && port < 3))
> 		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
> 
> may be sensible?

Sorry, I should have been way more specific here, all ports support 
pause frames, however only a subset of the ports, those connected over 
RGMII require to program the reg_rgmii_ctrl offset with the advertised 
pause settings.

> 
> It brings up another question: if the port supports this register, but
> we aren't using one of the rgmii, mii or revmii modes, should we be
> clearing the pause bits in this register if we're telling the system
> that pause isn't supported, or does the hardware not look at this RGMII
> register unless its in one of those three modes?

It is the latter, the hardware does not look at this RGMII register 
unless it is one of the 4 possible RGMII modes, MII, or reverse MII.
-- 
Florian
