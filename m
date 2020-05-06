Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88B11C7E32
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgEFXy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:54:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgEFXy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 19:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i5SChk+zstmRUqVCkB9sn/d7aCdBLyMGi0W5bL62CaQ=; b=ZCMTsaEAcY8Hp8OdIzUqTY3Tvx
        P2ucgvkf2wgwtkxKY7iS2Xe9ur7eRtaBIIGGhrKtmdw4rZFxK4gKizsfVvazswd2CuktZkXLKjQBP
        dR1aCnSxLlkBYHd+TapNqgoW6sZJ8Xjq6WAOievCWRhVGfulTYjY3xtF5xujRUS6Q9cQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jWTsP-0019PW-1l; Thu, 07 May 2020 01:54:57 +0200
Date:   Thu, 7 May 2020 01:54:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: Kernel crash in DSA/Marvell 6176 switch in 5.4.36
Message-ID: <20200506235457.GM224913@lunn.ch>
References: <CAOK2joE-4AWxvT5YWoCFTUb6WhwpSST2bLavKvL8SZi1D3_2VQ@mail.gmail.com>
 <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> MDIO bus. Followed example in
> Documentation/devicetree/bindings/dsa/marvell.txt */


>                             compatible = "marvell,mv88e6xxx-mdio-external";

6176 does not have an external MDIO bus. Only the 6390 family
does. The 6176 has just one bus, which is both internal and external.

>                             #address-cells = <1>;
>                             #size-cells = <0>;
>                           };
>                      };
>    Here is log of the 5.4.36 kernel crash. Can someone point to what
> could be going on here?
> 
> 63] mdio_bus !soc!pcie@1ffc000!pcie@2,1!pcie@3,0!igb0!mdio@0!switch0@0!md:
> ports has invalid PHY address

"ports has invalid PHY address" does not exist in 5.4.36.

> [    2.239378] mdio_bus
> !soc!pcie@1ffc000!pcie@2,1!pcie@3,0!igb0!mdio@0!switch0@0!md: scan phy
> ports at address 0
> [    2.240858] mmcblk1: mmc1:0007 SDCIT 29.2 GiB
> [    2.244341] ------------[ cut here ]------------
> [    2.244355] WARNING: CPU: 2 PID: 44 at kernel/kmod.c:137 0x800433d0
> [    2.244359] Modules linked in:
> [    2.244372] CPU: 2 PID: 44 Comm: kworker/u8:3 Not tainted 5.4.36 #0
> [    2.244377] Hardware name: Freescale i.MX6 Quad/DualLite (Device
> Tree)
> [    2.244386] Workqueue: events_unbound 0x80041cbc
> [    2.244402] Function entered at [<80016344>] from [<8001299c>]
> [    2.244408] Function entered at [<8001299c>] from [<8053a850>]
> [    2.244413] Function entered at [<8053a850>] from [<80024108>]
> [    2.244418] Function entered at [<80024108>] from [<80024174>]
> [    2.244423] Function entered at [<80024174>] from [<800433d0>]
> [    2.244429] Function entered at [<800433d0>] from [<802e8ec0>]
> [    2.244435] Function entered at [<802e8ec0>] from [<802ea4c0>]
> [    2.244440] Function entered at [<802ea4c0>] from [<802ea63c>]
> [    2.244444] Function entered at [<802ea63c>] from [<803d5a40>]
> [    2.244449] Function entered at [<803d5a40>] from [<803d617c>]
> [    2.244456] Function entered at [<803d617c>] from [<802ed25c>]
> [    2.244461] Function entered at [<802ed25c>] from [<802ef0c0>]
> [    2.244466] Function entered at [<802ef0c0>] from [<802ebb0c>]
> [    2.244470] Function entered at [<802ebb0c>] from [<8027804c>]

This is useless to us. You need to enable symbols in the image. I
think that is CONFIG_DEBUG_INFO.

> [    2.245041] mv88e6085 0000:03:00.0-1538:00: no ports child node found

static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
                                     struct device_node *dn)
{
        struct device_node *ports, *port;
        struct dsa_port *dp;
        int err = 0;
        u32 reg;

        ports = of_get_child_by_name(dn, "ports");
        if (!ports) {
                dev_err(ds->dev, "no ports child node found\n");
                return -EINVAL;
        }

This would indicate your 'port' node is misplaced somehow.

     Andrew
