Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8487495C86
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 10:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379669AbiAUJHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 04:07:51 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17471 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbiAUJHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 04:07:50 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1642756034; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=g3WSl5HLtnPQ/4irXOwRFgm6O8obVtA7M0rzjjvnFmtwdTmZvIKAwOn6dR8G0xUbr74Vpwc73H1q/e/OkA6P2Zxw5ECBS5cJi8apL3ancFjDKWz0TFIRfhOXmrv0HVdsalv1DfmEAeSiiP4rf5uJlR9J97HsjpMluILW5O/GTsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1642756034; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8Bc02x62b+RWldLlZRzRf6UlJVa06aKPQyA1pkVMgWc=; 
        b=TC9ZsX4ka7gzmqxXNREqkJkjNXgB9osGiXhleSW0x+GAKqKcUFVYC0l0tdKHlLvb72xC+uVlzIpctkCpiTSar3NJSsHnTUxt2FUOMj1YAivq/Br9vemvwnVC+vc3uc1KpkUXEN51uXbVCktU8pzBr6GfppgPDFgLqLGf0D6yKXY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1642756034;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=8Bc02x62b+RWldLlZRzRf6UlJVa06aKPQyA1pkVMgWc=;
        b=NXvv7LJJ6RKmVdswxmwJWez/M5UCfdmL7NV8WARnaETyOHCZcujFs8w9SBYANeQE
        ekt1J7CPlO5Khci1+N/IU8LorBvdxbmIT++0BFggp1aFXAp639iN3FnBKsVgM73Oaxa
        dZoQfbTQ49i2wHmdfanW4XUNd15R2Tv5Gjh9TrE0=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1642756033399367.95935709673347; Fri, 21 Jan 2022 01:07:13 -0800 (PST)
Message-ID: <be8e3fba-a76c-9bb1-39ee-d6069f234c93@arinc9.com>
Date:   Fri, 21 Jan 2022 12:07:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        gregkh@linuxfoundation.org
References: <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com>
 <CAJq09z5Pvo4tJNw0yKK2LYSNEdQTd4sXPpKFJbCNA-jUwmNctw@mail.gmail.com>
 <2091fa77-5578-c1bb-8457-3be4029b014d@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <2091fa77-5578-c1bb-8457-3be4029b014d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 06:50, Florian Fainelli wrote:
> 
> 
> On 1/20/2022 7:42 PM, Luiz Angelo Daros de Luca wrote:
>>> Are we talking about an in tree driver? If so which is it?
>>
>> Yes, the one the patch touches: rtl8365mb.
> 
> I meant the DSA master network device, but you answered that, it uses a 
> mt7260a SoC, but there is no Ethernet driver upstream for it yet?
> 
> git grep ralink,mt7620-gsw *
> Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt: 
> compatible = "ralink,mt7620-gsw";
> 
>>
>> My device uses a mt7620a SoC and traffic passes through its mt7530
>> switch with vlan disabled before reaching the realtek switch. It still
>> loads a swconfig driver but I think it might work without one.
> 
> Ah so you have a cascade of switches here, that could confuse your 
> Ethernet MAC. Do you have a knob to adjust where to calculate the 
> checksum from, say a L2 or L3 offset for instance?

The company I currently work for has got their own mt7621a board with an 
external rtl8367s switch.

According to Documentation/devicetree/bindings/net/dsa/mt7530.txt I can 
either connect the rtl switch directly to the second GMAC of the mt7621 
SoC or to MT7530's GMAC5 to create a cascade.

I've been running gregkh/staging staging-next branch but I can't seem to 
have traffic flow on the RGMII2 bus which is shared by the 2nd GMAC of 
the SoC, MT7530's GMAC5 and an external phy (rtl switch in this case).

None of the documented configurations work:
PHY0/4 <-> 2nd GMAC
External phy <-> 2nd GMAC
External phy <-> MT7530's GMAC5

Arınç
