Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01770582791
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiG0NXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiG0NXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:23:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE986286C8;
        Wed, 27 Jul 2022 06:23:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ss3so31341477ejc.11;
        Wed, 27 Jul 2022 06:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ayPa/GZCzBmV18GA2CcqJouuDXqqazHUYXcxfZQt5Qk=;
        b=N2oreEZXHbrgxxvKSrTLf9RPStvwycLt9TRco/24QsLXJDN7ct9B9zaS7rUHi2wI8H
         YSZVQOqyRB7hdk7elEoYp4nMf3G5TCl+EimJjabGHh6fpT+Z5Fq8VQVkR3V3e9ol9rCN
         RDTHKEAqUt1uUbQXmXwnsbm54ZrZUCXVFTR0QhcgwVrrX4ZNXtGttqCx48Gye8SpvXCu
         a03VyvpQSSOieyFfzBq0gX7XjXTRorABYVI+DY1J1xzQXgRoOAWKaQgPPizOAZAn7+FE
         PzhycyVUERLf6lyi4vuPAQmYzpCP5JQyKCkBUvQrTCYMsQ5jkBS3qTpzuyvEfYxyDY+X
         Cpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ayPa/GZCzBmV18GA2CcqJouuDXqqazHUYXcxfZQt5Qk=;
        b=18eeWaTGsz4FJK7wYfCXGjZ43rigA/iCUjtWD7PaLeeR3gxHu6jdqwNOgB2PMJLj2K
         S5Mp2xtQ4SsK9AZE5jGXEDMXm0XhTkwYP0VVna130V4R9fp15mkthoUT6Pdt1cbcdtXK
         u/J9+uPxGt+XiqeuHLhLm0jNMkOyFMR1brX1IlkSeTB24t4fXjjZndpFlR8T5Ovf9m0i
         cWqTBH8KCbXYlMZUWHl2axrIdLn4FfuHTAWlb4xkLOnK8vQTWuSu7YAqDYHmcBtiqWag
         ySoKAg94qbpgb+1KOv33Zss9T3fVHZpD328M7jwURCai8Bs6ePqfMUQpGZAl6rcSvdde
         kOcg==
X-Gm-Message-State: AJIora/2kS4ZE4m24+tJRaDqV2UMqnAlkTCnyUJ57dRBmZR5zDSH461G
        /vcDlwnKNhUxCLJEGdPhDmQ=
X-Google-Smtp-Source: AGRyM1t9/6Uspcvpt5DCU1AD3LoBl3+HD5bZlMl5pTZsKUDirNlgY6DpdZ0tKygtdVqKetnEgDF1rg==
X-Received: by 2002:a17:907:9801:b0:72f:1a8d:8dbe with SMTP id ji1-20020a170907980100b0072f1a8d8dbemr17279098ejc.537.1658928192268;
        Wed, 27 Jul 2022 06:23:12 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id k20-20020a17090632d400b006fee7b5dff2sm7690271ejk.143.2022.07.27.06.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 06:23:11 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:23:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220727132309.7g275ytefdhqmxip@skbuf>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
 <20220726112344.3ar7s7khiacqueus@skbuf>
 <174b5e64-a250-e1b2-43b9-474b915ddc22@gmail.com>
 <20220727012929.bcptskmb75kr7w6y@skbuf>
 <f4e6515c-db5d-84f0-e1ed-b00d998f91f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4e6515c-db5d-84f0-e1ed-b00d998f91f3@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 07:17:24PM -0700, Florian Fainelli wrote:
> > > I would prefer if also we sort of "transferred" the 'fixed-link'
> > > parameters from the DSA Ethernet controller attached to the CPU port
> > > onto the PHYLINK instance of the CPU port in the switch as they ought
> > > to be strictly identical otherwise it just won't work. This would
> > > ensure that we continue to force the link and it would make me sleep
> > > better a night to know that the IMP port is operating strictly the
> > > same way it was. My script compares register values before/after for
> > > the registers that are static and this was flagged as a difference.
> > 
> > There are several problems with transferring the parameters. Most
> > obvious derives from what we discussed about speed = <2000> just above:
> > the DSA master won't have it, either, because it's a non-standard speed.
> > Additionally, the DSA master may be missing the phy-mode too.
> > 
> > Second has to do with how we transfer the phy-mode assuming it isn't
> > missing on the master. RGMII modes are clearly problematic precisely
> > because we have so many driver interpretations of what they mean.
> > But "mii" and "rmii" aren't all that clear-cut either. Do we translate
> > into "mii" and "rmii" for DSA, or "rev-mii" and "rev-rmii"?
> > bcm_sf2 understands "rev-mii", but mv88e6xxx doesn't.
> 
> Yep, you have me convinced. I suppose the course of action for me is to
> update the DTSes to also include a fixed-link property and phy-mode property
> in the CPU node, even if that duplicates what the Ethernet controller node
> already has, and then given a cycle or two, merge this patch series.

I don't want to say that the 'peeking at the master' technique can't be
used at all, maybe if it would only come down to internal ports, and you
could give me a guarantee that the master does have a valid DT description
for your SoCs, we could consider doing this as a transition thing for
bcm_sf2 (on non-4908, see more below).

Having said that, I looked again at my analysis for bcm_sf2:
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

and I notice that I said that arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
*does* have a valid (complete at least) OF node description for the CPU port:

	port@8 {
		reg = <8>;
		phy-mode = "internal";
		ethernet = <&enet>;

		fixed-link {
			speed = <1000>;
			full-duplex;
		};
	};

but I didn't have the information that the speed is wrong (you said you
want it to operate at 2G).

Additionally (and curiously), the "enet" node lacks any link
description:

	enet: ethernet@2000 {
		compatible = "brcm,bcm4908-enet";
		reg = <0x2000 0x1000>;

		interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>,
			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
		interrupt-names = "rx", "tx";
	};

My question is, do you use the DTS file as seen in the mainline kernel
at all, or is it just for some sort of reference?

In case the 4908 really does have a fixed-link at 1000 provided by the
bootloader, you should be free to move the IMP setup code to
phylink_mac_link_up(), because phylink does have what it needs to run,
and just hack it to 2G for this SoC due to driver level knowledge,
despite what phylink thinks is going on. This can take place indefinitely.
In the long term, I don't know what else to suggest beyond fixing the
device tree to report the proper speed, sorry.
