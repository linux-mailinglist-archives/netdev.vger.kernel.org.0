Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6928D4973CB
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbiAWRtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 12:49:13 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17433 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiAWRtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 12:49:13 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1642960109; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=j7uqZ3uwvuF1I9hP9HaHYPcidRWKSpOholKukqUGDxC7YaE9m9KLBgEPmm62mY9bJSNrEVMYyn3SvB9TU4w/Jv0u1MHg6q8lYR0vkkfAps9ttCIXp3onboe9F1LPJjIcHoqFvTfZeE8UhIgzg9TxWkWQDunbdHo2uj3NWKuA26I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1642960109; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+eH2PmYS7tvCH6Q20kS59btHpbfUOjKupc/umJyNmOY=; 
        b=Hzn5Fhcd8KR5rfQx2ckUioTp7S/zlexQVZVclmDdrMbQVb9BUiSjwrDDF4YiiF6TqZDIR9e037yW972CuUi1ZwQlr8R1gO1j9Jr+XPCCo+l6EH+u9Ze+rlvIlh8Oo/jWigQWyKNyHrB9YthSLUYsKByi72UZ6xFnJqPEd/TfgCA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1642960109;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=+eH2PmYS7tvCH6Q20kS59btHpbfUOjKupc/umJyNmOY=;
        b=hjkOGn2PGskaRzUpQ7Arz55/nwl3+xOkgttcy31Y7bkaoc0MFll1eeXXB6L7TrbP
        rct/XRxi9uFAW5MAtXB0RGlUEQNyY4RqFqqXYZ8j5/A9gZEIeQi1drWk2DHQ6pGH7EU
        jHSK9EMOkqVOBH0AEHON15vkvSpSfZPkizY6ssEM=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1642960108103128.06493738732195; Sun, 23 Jan 2022 09:48:28 -0800 (PST)
Message-ID: <1c100b5b-1ea2-cb66-96e0-d0127b50f1a2@arinc9.com>
Date:   Sun, 23 Jan 2022 20:48:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
 <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
 <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com> <Ye1zwIFUa5LPQbQm@lunn.ch>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Ye1zwIFUa5LPQbQm@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/2022 18:26, Andrew Lunn wrote:
> On Sun, Jan 23, 2022 at 11:33:04AM +0300, Arınç ÜNAL wrote:
>> Hey Deng,
>>
>> On 23/01/2022 09:51, DENG Qingfang wrote:
>>> Hi,
>>>
>>> Do you set the ethernet pinmux correctly?
>>>
>>> &ethernet {
>>>       pinctrl-names = "default";
>>>       pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
>>> };
>>
>> This fixed it! We did have &rgmii2_pins on the gmac1 node (it was originally
>> on external_phy) so we never thought to investigate the pinctrl
>> configuration further! Turns out &rgmii2_pins needs to be defined on the
>> ethernet node instead.
> 
> PHYs are generally external, so pinmux on them makes no sense. PHYs in
> DT are not devices in the usual sense, so i don't think the driver
> core will handle pinmux for them, even if you did list them.
> 
> This could be interesting for the DT compliance checker. Ideally we
> want it to warn if it finds a pinmux configuration in a PHY node.

I don't see any warnings about it:

$ cpp -nostdinc -I include -I arch -undef -x assembler-with-cpp 
drivers/staging/mt7621-dts/mt7621.dtsi mt7621.dtsi.preprocessed
$ dtc -I dts -O dtb -p 0x1000 mt7621.dtsi.preprocessed -o mt7621.dtb
drivers/staging/mt7621-dts/mt7621.dtsi:28.21-33.4: Warning 
(unit_address_vs_reg): /cpuintc@0: node has a unit name, but no reg property
drivers/staging/mt7621-dts/mt7621.dtsi:40.34-47.6: Warning 
(unit_address_vs_reg): /fixedregulator@0: node has a unit name, but no 
reg property
drivers/staging/mt7621-dts/mt7621.dtsi:49.39-56.4: Warning 
(unit_address_vs_reg): /fixedregulator@1: node has a unit name, but no 
reg property
drivers/staging/mt7621-dts/mt7621.dtsi:410.11-449.7: Warning 
(unit_address_vs_reg): /ethernet@1e100000/mdio-bus/switch0@0/ports: node 
has a reg or ranges property, but no unit name
drivers/staging/mt7621-dts/mt7621.dtsi:28.21-33.4: Warning 
(unique_unit_address): /cpuintc@0: duplicate unit-address (also used in 
node /fixedregulator@0)

> 
> It also sounds like you had them somewhere else wrong?

Yes, it was under the phy_external node:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/staging/mt7621-dts/mt7621.dtsi#n350

I had put it under gmac1 node instead since we didn't enable the 
phy_external node.

Arınç
