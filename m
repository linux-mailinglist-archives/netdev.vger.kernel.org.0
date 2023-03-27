Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B068D6CAD2B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjC0Si2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbjC0SiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:38:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2921469F;
        Mon, 27 Mar 2023 11:38:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ek18so40084110edb.6;
        Mon, 27 Mar 2023 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679942292;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nLcZ+qrcIgnqBo+U06+wPoGBwMC2BfvNUbagKz8WaXA=;
        b=Orq60UWEuwu2H2PPv3K7xkXg2YPLaPKObVj87R00l9spmhZHKTrG3jQwE4YkRwBKzx
         I1dGyiIT5BpQctEGtKUJgfHT1uMgPZwYvWYb1e+Ow7l16f2rjae/W8sPnrAxie+N2R7C
         q/5ybHe7f3CyuFPIdkBTmjlliBiGPCNayS1aPn1Z2/SqjJ1Hk+xa7Rg4rfMRMfZQK82o
         I3tVNgUKtV0UHKl3yoRo3PdY8KQXQoVyO3aXKNv8xdHJyqE18gW91Z1w70eBxAJHvkdk
         IpjdYKOwRVcTpE9PntMkhGebMGdACiCaf+a0U7JMcrPmnJb4KaRluC1BPitW2k9xf9N6
         EVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679942292;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLcZ+qrcIgnqBo+U06+wPoGBwMC2BfvNUbagKz8WaXA=;
        b=OC6BoBFQJv4UZVrVLm/Ir+FzQ345RSqDlBIdLcmKbGb3FsGPzuU5/Xf9X57y989sli
         M1OA3ssPHxpsDtJf63azxVqiwPLgfuPXgGbY+2vxfaXoCe/tTahZmbaHPJN6cQEBypfC
         aRAwQHTJsOuJM1f1+7zhTEJ+uAWCM+FLbIG/DzPpihsEGMrlotjtXz0tysfxqyGE5+KC
         7nsDl+Nps5ytyfE+aK62JXPyeLsC/qBT2HhDzEffmKBI8GUp0iAIfbqyAyjOsK1PiJjY
         nNQ8KuTa3vTJw1nHVyh1SmEY44IxTchucPt8KJ1p6ih69hdu6fBdD+fZzoyMqc0qpqtt
         H3YA==
X-Gm-Message-State: AAQBX9fSK3B9ZAWUzzb6oYvQN5At+si3RQR0y1UuSpJCA24WGuNBTODG
        0XJd/ytSpkzaQTHnytRhzHk=
X-Google-Smtp-Source: AKy350bYfp6Lxy5+de6zhDv28RxPJ+gjb6yuG1b5+tRvrdnJIvmpv2oO9r6pB2k4n0jsOJdB3Zchnw==
X-Received: by 2002:a05:6402:48e:b0:4ad:7056:23a5 with SMTP id k14-20020a056402048e00b004ad705623a5mr12952202edv.14.1679942292011;
        Mon, 27 Mar 2023 11:38:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id r12-20020a50c00c000000b00501d2f10d19sm10527273edb.20.2023.03.27.11.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:38:11 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:38:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thibaut <hacks@slashdirt.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: Move MT7530 phy muxing from DSA to PHY driver
Message-ID: <20230327183809.vhft6rqek3kisytb@skbuf>
References: <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
 <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
 <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com>
 <YyKQKRIYDIVeczl1@lunn.ch>
 <dad09430-4f33-7f1d-76c7-4dbd0710e950@arinc9.com>
 <YyXiswbZfDh8aZHN@lunn.ch>
 <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
 <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
 <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
 <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
 <20ede15d-c5b0-bf96-4fe3-7639b4d646f8@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 07:52:12PM +0300, Arınç ÜNAL wrote:
> I'm currently working on the mt7530 driver and I think I found a way
> that takes the least effort, won't break the ABI, and most importantly,
> will work.

This sounds promising....

> As we acknowledged, the registers are in the switch address space. This
> must also mean that the switch must be properly probed before doing
> anything with the registers.
> 
> I'm not sure how exactly making a tiny driver would work in this case.

I'm not sure how it would work, either. It sounds like the driver for
the mdio-bus address @1f should have been a parent driver (MFD or not)
with 2 (platform device) children, one for the switch and another for
the HWTRAP registers and whatever else might be needed for the PHY
multiplexing. The parent (mdio_device) driver deals with the chip-wide
reset, resources, and manages the registers, giving them regmaps.
The driver with the mux probably just exports a symbol representing a
function that gets called by the "mediatek,eth-mac" driver and/or the
switch driver.

BTW, I have something vaguely similar to this in a stalled WIP branch
for sja1105, but things like this get really complicated really quickly
if the DSA driver's DT bindings weren't designed from day one to not
cover the entire switch's register map.

> I figured we can just run the phy muxing code before the DSA driver
> exits because there are no (CPU) ports defined on the devicetree. Right
> after probing is done on mt7530_probe, before dsa_register_switch() is run.

Aren't there timing issues, though? When is the earliest moment that the
"mediatek,eth-mac" driver needs the HWTRAP muxing to be changed?
The operation of changing that from the "mediatek,mt7530" driver is
completely asynchronous to the probing of "mediatek,eth-mac".
What's the worst that will happen with incorrect (not yet updated) GMII
signal muxing? "Just" some lost packets?

> 
> For proof of concept, I've moved some necessary switch probing code from
> mt7530_setup() to mt7530_probe(). After the switch is properly reset,
> phy4 is muxed, before dsa_register_switch() is run.

This is fragile because someone eager for some optimizations could move
the code back the way it was, and say: "the switch initialization costs
X ms and is done X times, because dsa_register_switch() -> ... ->
of_find_net_device_by_node() returns -EPROBE_DEFER the first X-1 times.
If we move the switch initialization to ds->ops->setup(), it will run
only once, after the handle to the DSA master has been obtained, and
this gives us a boost in kernel startup time."

It's even more fragile because currently (neither before nor after your change),
mt7530_remove() does not do the mirror opposite of mt7530_probe(), and somebody
eager from the future will notice this, and add an error handling path for
dsa_register_switch(), which calls the opposite of regulator_enable(),
regulator_disable(), saying "hey, there's no reason to let the regulators
on if the switch failed to probe, it consumes power for nothing!".

It's an open question whether that regulator is needed for anything after
the HWMUX registers has been changed, or if it can indeed be turned off.
Not knowing this, it's hard to say if the change is okay or not.
It seems that there's a high probability it will work for a while,
by coincidence.

> 
> [    0.650721] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> [    0.660285] mt7530 mdio-bus:1f: muxing phy4 to gmac5
> [    0.665284] mt7530 mdio-bus:1f: no ports child node found
> [    0.670688] mt7530: probe of mdio-bus:1f failed with error -22
> [    0.679118] mtk_soc_eth 1e100000.ethernet: generated random MAC address b6:9c:4d:eb:1f:8e
> [    0.688922] mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 15
> 
> ---
> 
> # ifup eth0
> [   30.674595] mtk_soc_eth 1e100000.ethernet eth0: configuring for fixed/rgmii link mode
> [   30.683451] mtk_soc_eth 1e100000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> # ping 192.168.2.2
> PING 192.168.2.2 (192.168.2.2): 56 data bytes
> 64 bytes from 192.168.2.2: seq=0 ttl=64 time=0.688 ms
> 64 bytes from 192.168.2.2: seq=1 ttl=64 time=0.375 ms
> 64 bytes from 192.168.2.2: seq=2 ttl=64 time=0.357 ms
> 64 bytes from 192.168.2.2: seq=3 ttl=64 time=0.323 ms
> 
> ---
> 
> # ip a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>        valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>     link/ether b6:9c:4d:eb:1f:8e brd ff:ff:ff:ff:ff:ff
>     inet 192.168.2.1/24 scope global eth0
>        valid_lft forever preferred_lft forever
> 
> There is a lot to do, such as fixing the method to read from the
> devicetree as it relies on the mac node the CPU port is connected to but
> when this is finalised, we should be able to use it like this:
> 
> mac@1 {
> 	compatible = "mediatek,eth-mac";
> 	reg = <1>;
> 	phy-mode = "rgmii";
> 	phy-handle = <&ethphy0>;
> };
> 
> mdio-bus {
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 
> 	ethphy0: ethernet-phy@0 {
> 		reg = <0>;
> 	};
> 
> 	switch@1f {
> 		compatible = "mediatek,mt7530";
> 		reg = <0x1f>;
> 		reset-gpios = <&pio 33 0>;
> 		core-supply = <&mt6323_vpa_reg>;
> 		io-supply = <&mt6323_vemc3v3_reg>;
> 	};
> };

And this is fragile because the "mediatek,eth-mac" driver only works
because of the side effects of a driver that began to probe, and failed.
Someone, seeing that "mediatek,mt7530" fails to probe, and knowing that
the switch ports are not needed/used on that board, could put a
status = "disabled"; property under the switch@1f node.
