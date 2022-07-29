Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795275854D3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiG2R6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiG2R6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:58:05 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF1888F08
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:58:03 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u9so6508920oiv.12
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TaOD8170LDS6jv46TeuuqUup/At1NsHwPRzAJDWoXtg=;
        b=DXNZjnUZNKpdgjJ8RdPE2b3TZ5E7mEcq3++sdq39MP4czoVmboOfqY4LtfYr+EXPAh
         KmpI0H8bHayD5eS4afp98tWXWCZUEWF3lRuIhW1xD/tLIEEiNGy1UhRvvhpJF64h3nu8
         lDhIN8YFe9bAk7WnTZDgrcD8oytxMu87WY7Pl1K0lft3hTB7kBgHsyLlFRLwGtfLe152
         akiRdTrL54d/z6iTBDyE/MrxE5ycoOXFKZE4Dsr6h9yqAUFDn52fq+SPPM7FPZLU6sz6
         sarQep9GqSobbOx1wJEZYcgug+HjmQS0EcIDmGjrypCoY/4fHQP25n7XtI8YZQBDZWTr
         zwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TaOD8170LDS6jv46TeuuqUup/At1NsHwPRzAJDWoXtg=;
        b=Zy99mkV7YA0hLe2kvlewCMe3CSA7WDrcGmHStjrbmqya9l6iFgLKiNAbrVPigPBb6s
         di+tRftKrs5hizJmOTIuYZL3LLP2hhlnguP5KMIwrM46K8Wq7i9zm6SqJt0rRQWNHNUU
         fkZys1k/NglvMsh+N3pP8mdQeNfW0Mx1nYXSLRhw9PzuWbSYibQiFsUQxJ5OqkmxyB3o
         gr5esutHlkHkcfoZfb/5ZB3Ze8ooh+CZbfOYA7F5uiT/pr8LDBoWNOJx5hpMgjdvKWP0
         PvxY52C+4q/g9SiBTKWStHCAL/vSQD8TxT++rgi4fEy/oS8pE0BRothIMbUmOMU8ECWS
         AslA==
X-Gm-Message-State: AJIora9OvojEgVvIBlJMMvtUWknQPHqU6LhRvCxNJVU+nk9W0jcAPJrj
        HtKxRR7sqGHzFCsPixWqFv3huwK5gYqfW84JuF6RSg==
X-Google-Smtp-Source: AGRyM1u3OZRA/GD65M8nlHySo/bNpCMem2Duq71U+iS3h2v8YDxfGKbqCHhIJmokTNqNRoS45jFDPChBgJOeSyxBAL8=
X-Received: by 2002:a05:6808:4d7:b0:33a:9437:32d with SMTP id
 a23-20020a05680804d700b0033a9437032dmr2073932oie.97.1659117482538; Fri, 29
 Jul 2022 10:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com> <20220729132119.1191227-5-vladimir.oltean@nxp.com>
In-Reply-To: <20220729132119.1191227-5-vladimir.oltean@nxp.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 29 Jul 2022 19:57:50 +0200
Message-ID: <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
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
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 29 lip 2022 o 15:21 Vladimir Oltean <vladimir.oltean@nxp.com> napisa=
=C5=82(a):
>
> There is a desire coming from Russell King to make all DSA drivers
> register unconditionally with phylink, to simplify the code paths:
> https://lore.kernel.org/netdev/YtGPO5SkMZfN8b%2Fs@shell.armlinux.org.uk/
>
> However this is not possible today without risking to break drivers
> which rely on a different mechanism, that where ports are manually
> brought up to the highest link speed during setup, and never touched by
> phylink at runtime.
>
> This happens because DSA was not always integrated with phylink, and
> when the early drivers were converted from platform data to the new DSA
> bindings, there was no information kept in the platform data structures
> about port link speeds, so as a result, there was no information
> translated into the first DT bindings.
>
> https://lore.kernel.org/all/YtXFtTsf++AeDm1l@lunn.ch/
>
> Today we have a workaround in place, introduced by commit a20f997010c4
> ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed"),
> where shared ports would be checked for the presence of phy-handle/
> fixed-link/managed OF properties, and if missing, phylink registration
> would be skipped.
>
> We modify the logic of this workaround such as to stop the proliferation
> of more port OF nodes with lacking information, to put an upper bound to
> the number of switches for which a link management description must be
> faked in order for phylink registration to become possible for them.
>
> Today we have drivers introduced years after the phylink migration of
> CPU/DSA ports, and yet we're still not completely sure whether all new
> drivers use phylink, because this depends on dynamic information
> (DT blob, which may very well not be upstream, because why would it).
> Driver maintainers may even be unaware about the fact that omitting
> fixed-link/phy-handle for CPU/DSA ports is legal, and even works with
> some of the old pre-phylink drivers.
>
> Add central validation in DSA for the OF properties required by phylink,
> in an attempt to sanitize the environment for future driver writers, and
> as much as possible for existing driver maintainers.
>
> Technically no driver except sja1105 and felix (partially) validates
> these properties, but perhaps due to subtle reasons, some of the
> other existing drivers may not actually work properly with a port OF
> node that lacks a complete description. There isn't any way to know
> except by deleting the fixed-link (or phy-mode or both) on a CPU port
> and trying.
>
> We can't fully know what is the situation with downstream DT blobs,
> but we can guess the overall trend by studying the DT blobs that were
> submitted upstream. If there are upstream blobs that have lacking
> descriptions, we take it as very likely that there are many more
> downstream blobs that do so too. If all upstream blobs have complete
> descriptions, we take that as a hint that the driver is a candidate for
> strict validation (considering that most bindings are copy-pasted).
> If there are no upstream DT blobs, we take the conservative route of
> skipping validation, unless the driver maintainer instructs us
> otherwise.
>
> The driver situation is as follows:
>
> ar9331
> ~~~~~~
>
>     compatible strings:
>     - qca,ar9331-switch
>
>     1 occurrence in mainline device trees, part of SoC dtsi
>     (arch/mips/boot/dts/qca/ar9331.dtsi), description is not problematic.
>
>     Verdict: opt into validation.
>
> b53
> ~~~
>
>     compatible strings:
>     - brcm,bcm5325
>     - brcm,bcm53115
>     - brcm,bcm53125
>     - brcm,bcm53128
>     - brcm,bcm5365
>     - brcm,bcm5389
>     - brcm,bcm5395
>     - brcm,bcm5397
>     - brcm,bcm5398
>
>     - brcm,bcm53010-srab
>     - brcm,bcm53011-srab
>     - brcm,bcm53012-srab
>     - brcm,bcm53018-srab
>     - brcm,bcm53019-srab
>     - brcm,bcm5301x-srab
>     - brcm,bcm11360-srab
>     - brcm,bcm58522-srab
>     - brcm,bcm58525-srab
>     - brcm,bcm58535-srab
>     - brcm,bcm58622-srab
>     - brcm,bcm58623-srab
>     - brcm,bcm58625-srab
>     - brcm,bcm88312-srab
>     - brcm,cygnus-srab
>     - brcm,nsp-srab
>     - brcm,omega-srab
>
>     - brcm,bcm3384-switch
>     - brcm,bcm6328-switch
>     - brcm,bcm6368-switch
>     - brcm,bcm63xx-switch
>
>     I've found at least these mainline DT blobs with problems:
>
>     arch/arm/boot/dts/bcm47094-linksys-panamera.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/bcm47189-tenda-ac9.dts
>     - lacks phy-mode and fixed-link
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
>     Verdict: opt all switches out of strict validation.
>
> bcm_sf2
> ~~~~~~~
>
>     compatible strings:
>     - brcm,bcm4908-switch
>     - brcm,bcm7445-switch-v4.0
>     - brcm,bcm7278-switch-v4.0
>     - brcm,bcm7278-switch-v4.8
>
>     A single occurrence in mainline
>     (arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi), part of a SoC
>     dtsi, valid description. Florian Fainelli explains that most of the
>     bcm_sf2 device trees lack a full description for the internal IMP
>     ports.
>
>     Verdict: opt the BCM4908 into strict validation, and opt out the
>     rest. Note that even though BCM4908 has strict DT bindings, it still
>     does not register with phylink on the IMP port due to it implementing
>     ->adjust_link().
>
> hellcreek
> ~~~~~~~~~
>
>     compatible strings:
>     - hirschmann,hellcreek-de1soc-r1
>
>     No occurrence in mainline device trees. Kurt Kanzenbach confirms
>     that the downstream device tree lacks phy-mode and fixed link, and
>     needs work.
>
>     Verdict: opt out of validation.
>
> lan9303
> ~~~~~~~
>
>     compatible strings:
>     - smsc,lan9303-mdio
>     - smsc,lan9303-i2c
>
>     1 occurrence in mainline device trees:
>     arch/arm/boot/dts/imx53-kp-hsc.dts
>     - no phy-mode, no fixed-link
>
>     Verdict: opt out of validation.
>
> lantiq_gswip
> ~~~~~~~~~~~~
>
>     compatible strings:
>     - lantiq,xrx200-gswip
>     - lantiq,xrx300-gswip
>     - lantiq,xrx330-gswip
>
>     No occurrences in mainline device trees. Martin Blumenstingl
>     confirms that the downstream OpenWrt device trees lack a proper
>     fixed-link and need work, and that the incomplete description can
>     even be seen in the example from
>     Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt.
>
>     Verdict: opt out of validation.
>
> microchip ksz
> ~~~~~~~~~~~~~
>
>     compatible strings:
>     - microchip,ksz8765
>     - microchip,ksz8794
>     - microchip,ksz8795
>     - microchip,ksz8863
>     - microchip,ksz8873
>     - microchip,ksz9477
>     - microchip,ksz9897
>     - microchip,ksz9893
>     - microchip,ksz9563
>     - microchip,ksz8563
>     - microchip,ksz9567
>     - microchip,lan9370
>     - microchip,lan9371
>     - microchip,lan9372
>     - microchip,lan9373
>     - microchip,lan9374
>
>     5 occurrences in mainline device trees, all descriptions are valid.
>     But we had a snafu for the ksz8795 and ksz9477 drivers where the
>     phy-mode property would be expected to be located directly under the
>     'switch' node rather than under a port OF node. It was fixed by
>     commit edecfa98f602 ("net: dsa: microchip: look for phy-mode in port
>     nodes"). The driver still has compatibility with the old DT blobs.
>     The lan937x support was added later than the above snafu was fixed,
>     and even though it has support for the broken DT blobs by virtue of
>     sharing a common probing function, I'll take it that its DT blobs
>     are correct.
>
>     Verdict: opt lan937x into validation, and the others out.
>
> mt7530
> ~~~~~~
>
>     compatible strings
>     - mediatek,mt7621
>     - mediatek,mt7530
>     - mediatek,mt7531
>
>     Multiple occurrences in mainline device trees, one is part of an SoC
>     dtsi (arch/mips/boot/dts/ralink/mt7621.dtsi), all descriptions are
>     fine.
>
>     Verdict: opt into strict validation.
>
> mv88e6060
> ~~~~~~~~~
>
>     compatible string:
>     - marvell,mv88e6060
>
>     no occurrences in mainline, nobody knows anybody who uses it.
>
>     Verdict: opt out of strict validation.
>
> mv88e6xxx
> ~~~~~~~~~
>
>     compatible strings:
>     - marvell,mv88e6085
>     - marvell,mv88e6190
>     - marvell,mv88e6250
>
>     Device trees that have incomplete descriptions of CPU or DSA ports:
>     arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
>     - lacks phy-mode
>     arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/vf610-zii-spb4.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/vf610-zii-cfu1.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
>     - lacks phy-mode on CPU port, fixed-link on DSA ports
>     arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
>     - lacks phy-mode on CPU port
>     arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/vf610-zii-scu4-aib.dts
>     - lacks fixed-link on xgmii DSA ports and/or in-band-status on
>       2500base-x DSA ports, and phy-mode on CPU port
>     arch/arm/boot/dts/imx6qdl-gw5904.dtsi
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/kirkwood-dir665.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
>     - lacks phy-mode
>     arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
>     - lacks phy-mode and fixed-link
>     arch/arm/boot/dts/armada-388-clearfog.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/armada-xp-linksys-mamba.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/armada-385-linksys.dtsi
>     - lacks phy-mode
>     arch/arm/boot/dts/imx6q-b450v3.dts
>     arch/arm/boot/dts/imx6q-b850v3.dts
>     - has a phy-handle but not a phy-mode?
>     arch/arm/boot/dts/armada-370-rd.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/kirkwood-linksys-viper.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/imx51-zii-rdu1.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
>     - lacks phy-mode
>     arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
>     - lacks phy-mode
>     arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
>     - lacks phy-mode and fixed-link
>
>     Verdict: opt out of validation.
>
> ocelot
> ~~~~~~
>
>     compatible strings:
>     - mscc,vsc9953-switch
>     - felix (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) is a PCI
>       device, has no compatible string
>
>     2 occurrences in mainline, both are part of SoC dtsi and complete.
>
>     Verdict: opt into strict validation.
>
> qca8k
> ~~~~~
>
>     compatible strings:
>     - qca,qca8327
>     - qca,qca8328
>     - qca,qca8334
>     - qca,qca8337
>
>     5 occurrences in mainline device trees, none of the descriptions are
>     problematic.
>
>     Verdict: opt into validation.
>
> realtek
> ~~~~~~~
>
>     compatible strings:
>     - realtek,rtl8366rb
>     - realtek,rtl8365mb
>
>     2 occurrences in mainline, both descriptions are fine, additionally
>     rtl8365mb.c has a comment "The device tree firmware should also
>     specify the link partner of the extension port - either via a
>     fixed-link or other phy-handle."
>
>     Verdict: opt into validation.
>
> rzn1_a5psw
> ~~~~~~~~~~
>
>     compatible strings:
>     - renesas,rzn1-a5psw
>
>     One single occurrence, part of SoC dtsi
>     (arch/arm/boot/dts/r9a06g032.dtsi), description is fine.
>
>     Verdict: opt into validation.
>
> sja1105
> ~~~~~~~
>
>     Driver already validates its port OF nodes in
>     sja1105_parse_ports_node().
>
>     Verdict: opt into validation.
>
> vsc73xx
> ~~~~~~~
>
>     compatible strings:
>     - vitesse,vsc7385
>     - vitesse,vsc7388
>     - vitesse,vsc7395
>     - vitesse,vsc7398
>
>     2 occurrences in mainline device trees, both descriptions are fine.
>
>     Verdict: opt into validation.
>
> xrs700x
> ~~~~~~~
>
>     compatible strings:
>     - arrow,xrs7003e
>     - arrow,xrs7003f
>     - arrow,xrs7004e
>     - arrow,xrs7004f
>
>     no occurrences in mainline, we don't know.
>
>     Verdict: opt out of strict validation.
>
> Because there is a pattern where newly added switches reuse existing
> drivers more often than introducing new ones, I've opted for deciding
> who gets to skip validation based on an OF compatible match table in the
> DSA core. The alternative would have been to add another boolean
> property to struct dsa_switch, like configure_vlan_while_not_filtering.
> But this avoids situations where sometimes driver maintainers obfuscate
> what goes on by sharing a common probing function, and therefore
> making new switches inherit old quirks.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Acked-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk> # realtek
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2:
> - sort drivers alphabetically, and other rewordings in the commit
>   message
> - move validation inside dsa_shared_port_link_register_of(), where it is
>   better placed considering the future work that might take place here
> - perform validation for everyone, just don't enforce it for the
>   switches listed, as suggested by Andrew Lunn
>
>  net/dsa/port.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 170 insertions(+), 5 deletions(-)
>
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 4b6139bff217..c07a7c69d5e0 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1650,22 +1650,187 @@ static int dsa_shared_port_phylink_register(stru=
ct dsa_port *dp)
>         return err;
>  }
>
> +/* During the initial DSA driver migration to OF, port nodes were someti=
mes
> + * added to device trees with no indication of how they should operate f=
rom a
> + * link management perspective (phy-handle, fixed-link, etc). Additional=
ly, the
> + * phy-mode may be absent. The interpretation of these port OF nodes dep=
ends on
> + * their type.
> + *
> + * User ports with no phy-handle or fixed-link are expected to connect t=
o an
> + * internal PHY located on the ds->slave_mii_bus at an MDIO address equa=
l to
> + * the port number. This description is still actively supported.
> + *
> + * Shared (CPU and DSA) ports with no phy-handle or fixed-link are expec=
ted to
> + * operate at the maximum speed that their phy-mode is capable of. If th=
e
> + * phy-mode is absent, they are expected to operate using the phy-mode
> + * supported by the port that gives the highest link speed. It is unspec=
ified
> + * if the port should use flow control or not, half duplex or full duple=
x, or
> + * if the phy-mode is a SERDES link, whether in-band autoneg is expected=
 to be
> + * enabled or not.
> + *
> + * In the latter case of shared ports, omitting the link management desc=
ription
> + * from the firmware node is deprecated and strongly discouraged. DSA us=
es
> + * phylink, which rejects the firmware nodes of these ports for lacking
> + * required properties.
> + *
> + * For switches in this table, DSA will skip enforcing validation and wi=
ll
> + * later omit registering a phylink instance for the shared ports, if th=
ey lack
> + * a fixed-link, a phy-handle, or a managed =3D "in-band-status" propert=
y.
> + * It becomes the responsibility of the driver to ensure that these port=
s
> + * operate at the maximum speed (whatever this means) and will interoper=
ate
> + * with the DSA master or other cascade port, since phylink methods will=
 not be
> + * invoked for them.
> + *
> + * If you are considering expanding this table for newly introduced swit=
ches,
> + * think again. It is OK to remove switches from this table if there are=
n't DT
> + * blobs in circulation which rely on defaulting the shared ports.
> + */
> +static const char * const dsa_switches_dont_enforce_validation[] =3D {
> +#if IS_ENABLED(CONFIG_NET_DSA_XRS700X)
> +       "arrow,xrs7003e",
> +       "arrow,xrs7003f",
> +       "arrow,xrs7004e",
> +       "arrow,xrs7004f",
> +#endif
> +#if IS_ENABLED(CONFIG_B53)
> +       "brcm,bcm5325",
> +       "brcm,bcm53115",
> +       "brcm,bcm53125",
> +       "brcm,bcm53128",
> +       "brcm,bcm5365",
> +       "brcm,bcm5389",
> +       "brcm,bcm5395",
> +       "brcm,bcm5397",
> +       "brcm,bcm5398",
> +       "brcm,bcm53010-srab",
> +       "brcm,bcm53011-srab",
> +       "brcm,bcm53012-srab",
> +       "brcm,bcm53018-srab",
> +       "brcm,bcm53019-srab",
> +       "brcm,bcm5301x-srab",
> +       "brcm,bcm11360-srab",
> +       "brcm,bcm58522-srab",
> +       "brcm,bcm58525-srab",
> +       "brcm,bcm58535-srab",
> +       "brcm,bcm58622-srab",
> +       "brcm,bcm58623-srab",
> +       "brcm,bcm58625-srab",
> +       "brcm,bcm88312-srab",
> +       "brcm,cygnus-srab",
> +       "brcm,nsp-srab",
> +       "brcm,omega-srab",
> +       "brcm,bcm3384-switch",
> +       "brcm,bcm6328-switch",
> +       "brcm,bcm6368-switch",
> +       "brcm,bcm63xx-switch",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
> +       "brcm,bcm7445-switch-v4.0",
> +       "brcm,bcm7278-switch-v4.0",
> +       "brcm,bcm7278-switch-v4.8",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
> +       "hirschmann,hellcreek-de1soc-r1",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_LANTIQ_GSWIP)
> +       "lantiq,xrx200-gswip",
> +       "lantiq,xrx300-gswip",
> +       "lantiq,xrx330-gswip",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_MV88E6060)
> +       "marvell,mv88e6060",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_MV88E6XXX)
> +       "marvell,mv88e6085",
> +       "marvell,mv88e6190",
> +       "marvell,mv88e6250",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)
> +       "microchip,ksz8765",
> +       "microchip,ksz8794",
> +       "microchip,ksz8795",
> +       "microchip,ksz8863",
> +       "microchip,ksz8873",
> +       "microchip,ksz9477",
> +       "microchip,ksz9897",
> +       "microchip,ksz9893",
> +       "microchip,ksz9563",
> +       "microchip,ksz8563",
> +       "microchip,ksz9567",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_MDIO)
> +       "smsc,lan9303-mdio",
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_I2C)
> +       "smsc,lan9303-i2c",
> +#endif
> +       NULL,
> +};
> +

I'm ok with enforcing the phylink usage and updating the binding
description, so the CPU / DSA ports have a proper full description of
the link. What I find problematic is including the drivers' related
ifdefs and compat strings in the subsystem's generic code. With this
change, if someone adds a new driver (or extends the existing ones),
they will have to add the string in the driver AND net/dsa...

How about the following scenario:
- Remove allow/blocklist from this patch and validate the description
always (no opt out). For an agreed timeframe (1 year? 2 LTS releases?)
it wouldn't cause the switch probe to fail, but instead of
dev_warn/dev_err, there should be a big fat WARN_ON(). Spoiled bootlog
will encourage users to update the device trees.
- After the deadline, the switch probe should start failing with
improper description and everyone will have to use phylink.
- Announce the binding change and start updating DT binding
description schema (adding the validation on that level too).
?

Best regards,
Marcin
