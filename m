Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92A45802D5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiGYQhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiGYQhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:37:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6448D107
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:37:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y9so10894303pff.12
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HMiphmlvTCxNHEQstRBZac8e02I7y5hSwWe37yrUVhE=;
        b=TzHC57hZacoXODO/E77oYYxOumnngbVhfieu1w9upnfn05UvuP0v1pLc/BqHpc1rro
         KcfPy7sYKwfXctL3om8N5pYc7UJtwa27lrEfjKgrinzyE4hqNPoK5eZXp5k1qbdKxZ+6
         xbrva3gk4vu/gNJ0mvP5eVxuUaAH2bjvh4ZMO6H5WtYYoS45jQM8Q92U3snerEhrkC1z
         Eu5vQv7d1ai41ycG6q/KFbau1LkLYSXFyZGIBP6HVCc28tmBzYewyEQ+f+EVG+ayfuDS
         N8mAm3SdDE3B2kiLQ3xKWCK8DeF3UJ/L0mcwGCPWedFJ9Rks+k/yKmp7Pdu+zm4MvxQF
         C1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HMiphmlvTCxNHEQstRBZac8e02I7y5hSwWe37yrUVhE=;
        b=gLrnvgtrCY7t4IKa8Q8wNZqHo2YPA7/AmsofUZSybabaGgaVtwApEFhB5eQigwYrrM
         f18FIauIzGtWet5W8pFCUty5DbxDiko9OFzHPRfoACWEvVStiaN0plkGEVW1XyzJVyBb
         tpCL3LVEPWjCufl1LHc6+zNGk8whUts+QrGxfEZrO2+wVsX2pQdo+2PaSCM+tO3AAu2z
         9noHiq+FRD8oQuyQ3WJsZiQDzI259n9wYb0FUcTdx3LwwAhGE9D4dQtVX25Oqz6lroUN
         Qtb0WnKSSWscK1OX4DFZ9t7xWgwYr09089bCQbCXCeUnhSOKPZ+ZIfCUkEUJJVzFBOar
         ytrw==
X-Gm-Message-State: AJIora/GeVPHYqT1eRENY3/dPUagFJMfd+PKkWl1bwXBcqpRFbSG0lPb
        INCL7HkGECJmUnnJcffIDb8=
X-Google-Smtp-Source: AGRyM1t1Hrx5c1kGede1/3Ra6aBxPax1FWVV5qxqRcFKxWVYUGdCbxFssYmb1N1ZEb7s6kSBdwaZZA==
X-Received: by 2002:a63:4645:0:b0:41a:6c24:4fa3 with SMTP id v5-20020a634645000000b0041a6c244fa3mr11796823pgk.114.1658767061493;
        Mon, 25 Jul 2022 09:37:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id on1-20020a17090b1d0100b001f21646d1a4sm21448453pjb.1.2022.07.25.09.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 09:37:41 -0700 (PDT)
Message-ID: <eabe2419-9e90-28b3-0b2a-7d779f0f1864@gmail.com>
Date:   Mon, 25 Jul 2022 09:37:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
 <Ytw5XrDYa4FQF+Uk@lunn.ch> <20220724142158.dsj7yytiwk7welcp@skbuf>
 <df5bb0c3-d0c6-9184-5c46-f6888f9c601d@gmail.com>
 <20220724202839.klkwevxaqxnvbfha@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220724202839.klkwevxaqxnvbfha@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/22 13:28, Vladimir Oltean wrote:
> On Sun, Jul 24, 2022 at 09:59:14AM -0700, Florian Fainelli wrote:
>> Le 24/07/2022 à 07:21, Vladimir Oltean a écrit :
>>> On Sat, Jul 23, 2022 at 08:09:34PM +0200, Andrew Lunn wrote:
>>>> Hi Vladimir
>>>>
>>>> I think this is a first good step.
>>>>
>>>>> +static const char * const dsa_switches_skipping_validation[] = {
>>>>
>>>> One thing to consider is do we want to go one step further and make
>>>> this dsa_switches_dont_enforce_validation
>>>>
>>>> Meaning always run the validation, and report what is not valid, but
>>>> don't enforce with an -EINVAL for switches on the list?
>>>
>>> Can do. The question is what are our prospects of eventually getting rid
>>> of incompletely specified DT blobs. If they're likely to stay around
>>> forever, maybe printing with dev_err() doesn't sound like such a great
>>> idea?
>>>
>>> I know what's said in Documentation/devicetree/bindings/net/dsa/marvell.txt
>>> about not putting a DT blob somewhere where you can't update it, but
>>> will that be the case for everyone? Florian, I think some bcm_sf2 device
>>> trees are pretty much permanent, based on some of your past commits?
>>
>> The Device Tree blob is provided and runtime populated by the bootloader, so
>> we can definitively make changes and missing properties are always easy to
>> add as long as we can keep a reasonable window of time (2 to 3 years seems
>> to be about the right window) for people to update their systems. FWIW, all
>> of the bcm_sf2 based systems have had a fixed-link property for the CPU
>> port.
> 
> Ok, so does this mean I can remove these from dsa_switches_dont_enforce_validation?
> 
> #if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
> 	"brcm,bcm7445-switch-v4.0",
> 	"brcm,bcm7278-switch-v4.0",
> 	"brcm,bcm7278-switch-v4.8",
> #endif

The DTB that is being passed just specifies port 8 with its 'reg' and 'label = "cpu"' and 'ethernet' phandle to the Ethernet controller node.

The Ethernet controller node does specify the correct 'phy-mode' and 'fixed-link' properties, so I suppose we can turn on validation if we do support such an use case of "looking beyond" what the CPU port node provided us and replicating that into the CPU-port local phylink creation. There are actually many DTSes in that situation, now there are a few cases where we do have some interesting combinations:

- internal switches are typically wired up over GMII or some internal fabric, but the end result is that the ports sort of "automatically" work provided that you have the same link parameters on both side, either explicitly or just by having the hardware and or driver default to some sane settings. In that case, omitting 'fixed-link' on the CPU port node seems reasonable provided that we can retrieve that same piece information from looking at the 'ethernet' or 'link' phandle properties and use that to configure the phylink instance on the CPU/DSA port(s)

- external switches do require providing information on either side of the link, especially for 'phy-mode' (especially true with RGMII), however 'fixed-link' could be somehow omitted if we just matched what the CPU/DSA port has

> 
>>>> Maybe it is too early for that, we first need to submit patches to the
>>>> mainline DT files to fixes those we can?
>>>>
>>>> Looking at the mv88e6xxx instances, adding fixed-links should not be
>>>> too hard. What might be harder is the phy-mode, in particular, what
>>>> RGMII delay should be specified.
>>>
>>> Since DT blobs and kernels have essentially separate lifetimes, I'm
>>> thinking it doesn't matter too much if we first fix the mainline DT
>>> blobs or not; it's not like that would avoid users seeing errors.
>>>
>>> Anyway I'm thinking it would be useful in general to verbally resolve
>>> some of the incomplete DT descriptions I've pointed out here. This would
>>> be a good indication whether we can add automatic logic that comes to
>>> the same resolution at least for all known cases.
>>
>> Agreed.
> 
> Ok, so let's start with b53?
> 
> Correct me if I'm wrong, I'm just looking at code and it's been a while
> since I've transitioned my drivers from adjust_link.
> 
> Essentially since b53 still implements b53_adjust_link, this makes
> dsa_port_link_register_of() (what is called for DSA_PORT_TYPE_CPU and
> DSA_PORT_TYPE_DSA) take the following route:
> 
> int dsa_port_link_register_of(struct dsa_port *dp)
> {
> 	struct dsa_switch *ds = dp->ds;
> 	struct device_node *phy_np;
> 	int port = dp->index;
> 
> 	if (!ds->ops->adjust_link) { // this is false, b53 has adjust_link
> 		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> 		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> 			if (ds->ops->phylink_mac_link_down)
> 				ds->ops->phylink_mac_link_down(ds, port,
> 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> 			of_node_put(phy_np);
> 			return dsa_port_phylink_register(dp);
> 		}
> 		of_node_put(phy_np);
> 		return 0;
> 	} // as a result, we never register with phylink for CPU/DSA ports, Russell's logic is avoided
> 
> 	dev_warn(ds->dev,
> 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n"); // you do see this warning
> 
> 	if (of_phy_is_fixed_link(dp->dn))
> 		return dsa_port_fixed_link_register_of(dp);
> 	else
> 		return dsa_port_setup_phy_of(dp, true);
> }
> 
> So one of dsa_port_fixed_link_register_of() or dsa_port_setup_phy_of()
> is going to get called in your case.
> 
> If you have a fixed-link in your device tree, dsa_port_fixed_link_register_of()
> will fake a call to adjust_link() with the fixed PHY that has its
> phydev->interface populated based on phy-mode (if missing, this defaults to NA).
> The b53_adjust_link() function cares about phydev->interface only to the
> extent of checking for RGMII delays, otherwise it doesn't matter that
> the phy-mode is missing (arch/arm/boot/dts/bcm47094-linksys-panamera.dts),
> for practical purposes.
> 
> If your description is missing a fixed-link (arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts),
> the other function will get called, dsa_port_setup_phy_of().
> Essentially this will call dsa_port_get_phy_device(), which will return
> NULL, so we will exit early, do nothing and return 0. Right?
> 
> So b53 is going to be unaffected by Russell's changes, due to it still
> implementing adjust_link.

Pretty much yes.

> 
> 
> 
> Now on to the device trees, let's imagine for a second you'll actually
> delete b53_adjust_link:
> 
>     arch/arm/boot/dts/bcm47094-linksys-panamera.dts
>     - lacks phy-mode
> 
> phylink will call b53_srab_phylink_get_caps() to determine the maximum
> supported interface. b53_srab_phylink_get_caps() will circularly look at
> its current interface, p->mode (which is PHY_INTERFACE_MODE_NA, right?
> because we lack a phy-mode), and not populate config->supported_interfaces
> with anything.
> 
> So what is the expected phy-mode here? phylink couldn't find it :)
> I think this is a case where the b53 driver would need to be patched to
> report a default_interface for ports 5, 7 and 8 of brcm,bcm53012-srab.

SRAB means the switch is internal to the SoC, so GMII would be an appropriate PHY interface if we cared so much as to representation *exactly* how the RTL was designed, but that could also be substituted by PHY_INTERFACE_MODE_INTERNAL or PHY_INTERFACE_MODE_NA IMHO, as long as we match the CPU port's 'fixed-link' property.

> 
>     arch/arm/boot/dts/bcm47189-tenda-ac9.dts
>     - lacks phy-mode and fixed-link
> 
> If my above logic was correct, things here are even worse, because when
> phylink can't determine the supported_interfaces (no phy-mode), it can't
> determine the speed for the fixed-link either.
> 
>     arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
>     arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
>     arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
>     arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
>     arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
>     arch/arm/boot/dts/bcm953012er.dts
>     arch/arm/boot/dts/bcm4708-netgear-r6250.dts
>     arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
>     arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
>     arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/bcm53016-meraki-mr32.dts
>     - lacks phy-mode
> 
> I guess that the bottom line is that the b53 driver is safe due to adjust_link.
> Beyond that, it's up to you how much you want to polish things up.
> It's going to be quite a bit of work to bring everything up to date.

The plan is still to remove adjust_link, the same plan that has been not worked on for years, so do quote me on that and remind me again in 4 years. That said, the bgmac driver does register a fixed link for its CPU port, sort of "on its own" if it does find one. This is largely historical due to the driver having started on MIPS-based chips where there was no DT to describe anything.

I do think that we should however fix these various DTSes to have the necessary properties, and it should not be an issue because those devices do not have any bootloader awareness of DT and the DTB is always shipped with the kernel image that OpenWrt/Buildroot uses do install.
-- 
Florian
