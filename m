Return-Path: <netdev+bounces-8048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B016E7228F9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 243091C20C92
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFD179D9;
	Mon,  5 Jun 2023 14:38:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2685238
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:38:35 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52155E8;
	Mon,  5 Jun 2023 07:38:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685975828; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dukgcjv1DYIFnONs1Q8SkNEm+ZyHR4hYRxha29hiozFpf1DlNATDuO/0sdT5a1UuU9KlIuekq5k3tm9SvdFApuXty8H7x3444lt0lhD9qao0QhF/vaBLvaUSAqbbbflY3gbFF6hDM4WcPv7CYz/UsdMkm0Ag++KkLjuceTUnI94=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685975828; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=IKz+qkd0dZYFQDYfgHpiD6xVkvr5p+/lUtnpFOmRwAQ=; 
	b=C7yljG4aDt4vfHsQdTHGElGvlmjxViYp5L1y2xLFBSui2JLBd0MEXa/ZltQyICIrWODlk3ysHw3QcwoWfGqPQCIegJjL3VW7PT87bm0aSjvQ/AhFz2q0Rg+i2naUJCMkq8FHOnde/b1z8g0K/ZRWjBTcrUGdLQO62v+AtxXvCs8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685975828;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=IKz+qkd0dZYFQDYfgHpiD6xVkvr5p+/lUtnpFOmRwAQ=;
	b=jbhTkyCgioXDKZnCcrHeddw0ZLyB4uhjRyn8bAiPbk6gg/9lgCQ+xX7nfOHRQ+wX
	q+HNNIAQEbLVXmlsMqokEbYe4KGaA1tpVW6ADbEw/Si6UZDiWSwkmHwcOWazqFlFRwM
	HgToi1TGe1iUhGXbFbK8amG5ZCkVyVthqmFNuzss=
Received: from [192.168.83.218] (62.74.57.47 [62.74.57.47]) by mx.zohomail.com
	with SMTPS id 1685975825815348.2953084133545; Mon, 5 Jun 2023 07:37:05 -0700 (PDT)
Message-ID: <e2865f69-3254-4768-7a7a-bb84d76a85eb@arinc9.com>
Date: Mon, 5 Jun 2023 17:36:56 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vladimir Oltean <olteanv@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
 <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
 <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
 <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
 <ZHyqI2oOI4KkvgB8@shell.armlinux.org.uk>
Content-Language: en-US
In-Reply-To: <ZHyqI2oOI4KkvgB8@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4.06.2023 18:13, Russell King (Oracle) wrote:
> On Sun, Jun 04, 2023 at 04:14:31PM +0300, Arınç ÜNAL wrote:
>> On 4.06.2023 16:07, Russell King (Oracle) wrote:
>>> On Sun, Jun 04, 2023 at 03:55:17PM +0300, Vladimir Oltean wrote:
>>>> On Sun, Jun 04, 2023 at 01:18:04PM +0100, Russell King (Oracle) wrote:
>>>>> I don't remember whether Vladimir's firmware validator will fail for
>>>>> mt753x if CPU ports are not fully described, but that would be well
>>>>> worth checking. If it does, then we can be confident that phylink
>>>>> will always be used, and those bypassing calls should not be necessary.
>>>>
>>>> It does, I've just retested this:
>>>>
>>>> [    8.469152] mscc_felix 0000:00:00.5: OF node /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 of CPU port 4 lacks the required "phy-handle", "fixed-link" or "managed" properties
>>>> [    8.494571] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch
>>>> [    8.502151] mscc_felix: probe of 0000:00:00.5 failed with error -22
>>>
>>> ... which isn't listed in dsa_switches_apply_workarounds[], and
>>> neither is mt753x. Thanks.
>>>
>>> So, that should be sufficient to know that the CPU port will always
>>> properly described, and thus bypassing phylink in mt753x for the CPU
>>> port should not be necessary.
>>
>> Perfect! If I understand correctly, there's this code - specific to MT7531
>> and MT7988 ports being used as CPU ports - which runs in addition to what's
>> in mt753x_phylink_mac_config():
>>
>> 	mt7530_write(priv, MT7530_PMCR_P(port),
>> 		     PMCR_CPU_PORT_SETTING(priv->id));
>>
>> This should be put on mt753x_phylink_mac_config(), under priv->id ==
>> ID_MT7531, priv->id == ID_MT7988, and dsa_is_cpu_port(ds, port) checks?
> 
> Please remember that I have very little knowledge of MT753x, so in
> order to answer this question, I've read through the mt7530 driver
> code.
> 
> Looking at mt7530.h:
> 
> #define  PMCR_CPU_PORT_SETTING(id)      (PMCR_FORCE_MODE_ID((id)) | \
>                                           PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
>                                           PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
>                                           PMCR_TX_EN | PMCR_RX_EN | \
>                                           PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
>                                           PMCR_FORCE_SPEED_1000 | \
>                                           PMCR_FORCE_FDX | PMCR_FORCE_LNK)
> 
> This seems to be some kind of port control register that sets amongst
> other things parameters such as whether flow control is enabled, the
> port speed, the duplex setting, whether link is forced up, etc.
> 
> Looking at what mt753x_phylink_mac_link_up() does:
> 
> 1. it sets PMCR_RX_EN | PMCR_TX_EN | PMCR_FORCE_LNK.
> 2. it sets PMCR_FORCE_SPEED_1000 if speed was 1000Mbps, or if using
>     an internal, TRGMII, 1000base-X or 2500base-X phy interface mode.
> 3. it sets PMCR_FORCE_FDX if full duplex was requested.
> 4. it sets PMCR_TX_FC_EN if full duplex was requested with tx pause.
> 5. it sets PMCR_RX_FC_EN if full duplex was requested with rx pause.
> 
> So, provided this is called with the appropriate parameters, for a
> fixed link, that will leave the following:
> 
> 	PMCR_FORCE_MODE_ID(id)
> 	PMCR_IFG_XMIT(1)
> 	PMCR_MAC_MODE
> 	PMCR_BACKOFF_EN
> 	PMCR_BACKPR_EN
> 
> If we now look at mt753x_phylink_mac_config(), this sets
> PMCR_IFG_XMIT(1), PMCR_MAC_MODE, PMCR_BACKOFF_EN, PMCR_BACKPR_EN,
> and PMCR_FORCE_MODE_ID(priv->id), which I believe is everything that
> PMCR_CPU_PORT_SETTING(priv->id) is doing.
> 
> So, Wouldn't a fixed-link description indicating 1Gbps, full duplex
> with pause cause phylink to call both mt753x_phylink_mac_config() and
> mt753x_phylink_mac_link_up() with appropriate arguments to set all
> of these parameters in PMCR?
> 
> Now, I'm going to analyse something else. mt7531_cpu_port_config()
> is called from mt753x_cpu_port_enable(), which is itself called from
> mt7531_setup_common(). That is ultimately called from the DSA switch
> ops .setup() method.
> 
> This method is called from dsa_switch_setup() for each switch in the
> DSA tree. dsa_tree_setup_switches() calls this, and is called from
> dsa_tree_setup().  Once dsa_tree_setup_switches() finishes
> successfully, dsa_tree_setup_ports() will be called. This will then
> setup DSA and CPU ports, which will then setup a phylink instance
> for these ports. phylink will parse the firmware description for
> the port. DSA will then call dsa_port_enable().
> 
> dsa_port_enable() will then call any port_enable() method in the
> mt7530.c driver, which will be mt7530_port_enable(). This then...
> 
>          mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
> 
> which is:
> 
> #define  PMCR_LINK_SETTINGS_MASK        (PMCR_TX_EN | PMCR_FORCE_SPEED_1000 | \
>                                           PMCR_RX_EN | PMCR_FORCE_SPEED_100 | \
>                                           PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
>                                           PMCR_FORCE_FDX | PMCR_FORCE_LNK | \
>                                           PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100)
> 
> So it wipes out all the PMCR settings that mt7531_cpu_port_config()
> performed - undoing *everything* below that switch() statement in
> mt7531_cpu_port_config()!
> 
> Once the port_enable() method returns, DSA will then call
> phylink_start(), which will trigger phylink to bring up the link
> according to the settings it has, which will mean phylink calls
> the mac_config(), pcs_config(), pcs_link_up() and mac_link_up()
> with the appropriate parameters for the firmware described link.

I'm slowly learning how DSA and phylink works, this is the full code
path I could make up for the MT7530 DSA subdriver:

mt7530_probe() & mt7988_probe()
    -> mt7530_probe_common()
    -> dsa_register_switch()
       -> dsa_switch_probe()
          -> dsa_tree_setup()
             -> dsa_tree_setup_switches()
                -> dsa_switch_setup()
                   -> ds->ops->setup(): mt753x_setup()
                      -> mt7530_setup()
                         -> mt753x_cpu_port_enable()
                      -> mt7531_setup()
                         -> mt7531_setup_common()
                            -> mt753x_cpu_port_enable()
                               -> priv->info->cpu_port_config():
                                  mt7531_cpu_port_config()
                      -> mt7988_setup()
                         -> mt7531_setup_common()
                            -> mt753x_cpu_port_enable()
                               -> priv->info->cpu_port_config():
                                  mt7988_cpu_port_config()
             -> dsa_tree_setup_ports()
                -> dsa_port_setup()
                   -> dsa_shared_port_link_register_of()
                      -> dsa_shared_port_link_register_of()
                         -> dsa_shared_port_phylink_register()
                            -> dsa_port_phylink_create()
                               -> ds->ops->phylink_get_caps():
                                  mt753x_phylink_get_caps()
                               -> phylink_create()
                                  -> INIT_WORK(&pl->resolve, phylink_resolve)
                   -> dsa_port_enable()
                      -> dsa_port_enable_rt()
                         -> ds->ops->port_enable():
                            mt7530_port_enable()
                         -> phylink_start()
                            -> phylink_mac_initial_config()
                               -> phylink_major_config()
                                  -> phylink_mac_config()
                                     -> pl->mac_ops->mac_config():
                                        dsa_port_phylink_mac_config()
                                        -> ds->ops->phylink_mac_config():
                                           mt753x_phylink_mac_config()
                                  -> pl->pcs->ops->pcs_config():
                                     mt753x_pcs_config()
                            -> phylink_enable_and_run_resolve()
                               -> phylink_run_resolve()
                                  -> queue_work(system_power_efficient_wq, &pl->resolve)
                                     -> phylink_link_up()
                                        -> pl->pcs->ops->pcs_link_up():
                                           mtk_pcs_lynxi_link_up()
                                        -> pl->mac_ops->mac_link_up():
                                           dsa_port_phylink_mac_link_up()
                                           -> ds->ops->phylink_mac_link_up():
                                              mt753x_phylink_mac_link_up()

> 
> So I think I have the answer to my initial thought: do the calls in
> mt7531_cpu_port_config() to the phylink methods have any use what so
> ever? The answer is no, they are entirely useless. The same goes for
> the other cpu_port_config() methods that do something similar. The
> same goes for the PMCR register write that's changing any bits
> included in PMCR_LINK_SETTINGS_MASK.
> 
> What that means is that mt7988_cpu_port_config() can be entirely
> removed, it serves no useful purpose what so ever. For
> mt7531_cpu_port_config(), it only needs to set priv->p[56]_interface
> which, as far as I can see, probably only avoids mac_config() doing
> any pad setup (that's a guess.)

This is what I also believe and the reason why I made this patch to
simplify it. Looks like I'll just remove priv->info->cpu_port_config()
instead.

Arınç

