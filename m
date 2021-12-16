Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE18478017
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 23:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhLPWqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 17:46:00 -0500
Received: from sender3-op-o12.zoho.com ([136.143.184.12]:17857 "EHLO
        sender3-op-o12.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhLPWqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 17:46:00 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2021 17:46:00 EST
ARC-Seal: i=1; a=rsa-sha256; t=1639693846; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Pa4thlR+AuRzElDUZYwdaN/YxL9E4GkfEwu3Kad6wCcA0vDLTPhTipKzq0+84sbCsX7IcMAgoWo9RXtHvqJXaSQy9YNcpUOkMVp3u2xQ8HFF0isFJN7HSOu8zNkhBw4MlUJnzJPxk+hzosN9AazSp1bYR1RErfGwbhglQV+MoM8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1639693846; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6w0FdC2HJeku0HSV0Ycp46ai+Pk/fwL+4y9kYAYAH1s=; 
        b=fCL0aGp9h3dMz5noYjJ3uhxd6T19cF1ED95uV7crTDhbwPqjQeHHAWW4SWpnnn++X3wIrsXsDpZuUv0rA84jtUHv/i4UnU3yDvHUxx7Ud8xacak/qW65A3cMuKunrenUvkrt0BBx1+c9DhAL1n7tIM2udx/+FTtMcP37aKarthU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1639693846;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=6w0FdC2HJeku0HSV0Ycp46ai+Pk/fwL+4y9kYAYAH1s=;
        b=gUZJsbus5Bqd3dVIODBugSpX8QrOWOf/YtV4HruqZ8EcGe5reNcEi9cHazZ7mwHa
        rNKQuN+mpRC3vb3USqWaJ8W66R0y8CBjUjNoxOZ826zYGXVBt1CvOigtRQKER+bRS0R
        kMoln1JJGBQUlpRSB0La+j27dD043MSOUVDNLJGU=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1639693844929831.2577492589123; Thu, 16 Dec 2021 14:30:44 -0800 (PST)
Message-ID: <04624be2-14f6-84a1-2c9b-1ac026633afa@arinc9.com>
Date:   Fri, 17 Dec 2021 01:30:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and
 RTL8367S
Content-Language: en-US
To:     luizluca@gmail.com, netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk
References: <20211216201342.25587-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's insight to what I've tested.

I tested an RTL8365MB-VC switch connected through SMI on an Asus 
RT-AC88U router.

I applied this patch series on net-next of 17 December 2021 using the 
OpenWrt master branch with slight modifications to run the net-next kernel.

First, I enabled every option introduced with this patch series to make 
sure there's nothing wrong with the compilation process.

Then, I disabled the MDIO & rtl8366rb subdriver options along with the 
now optional rtl4_a tag option. Therefore compiling the kernel with only 
the SMI, rtl8367c subdriver & rtl8_4 tag options enabled.

Everything compiles and the driver works as expected in both cases.

Cheers.
Arınç

On 16/12/2021 23:13, luizluca@gmail.com wrote:
> This series refactors the current Realtek DSA driver to support MDIO
> connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
> switch, with one of those 2 external ports supporting SGMII/High-SGMII.
> 
> The old realtek-smi driver was linking subdrivers into a single
> realtek-smi.ko After this series, each subdriver will be an independent
> module required by either realtek-smi (platform driver) or the new
> realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
> independent, and they might even work side-by-side, although it will be
> difficult to find such device. The subdriver can be individually
> selected but only at buildtime, saving some storage space for custom
> embedded systems.
> 
> The subdriver rtl8365mb was renamed to rtl8367c. rtl8367c is not a real
> model, but it is the name Realtek uses for their driver that supports
> RTL8365MB-VC, RTL8367S and other siblings. The subdriver name was not
> exposed to userland, but now it will be used as the module name. If
> there is a better name, this is the last opportunity to rename it again
> without affecting userland.
> 
> Existing realtek-smi devices continue to work untouched during the
> tests. The realtek-smi was moved into a realtek subdirectory, but it
> normally does not break things.
> 
> I couldn't identify a fixed relation between port numbers (0..9) and
> external interfaces (0..2), and I'm not sure if it is fixed for each
> chip version or a device configuration. Until there is more info about
> it, there is a new port property "realtek,ext-int" that can inform the
> external interface.
> 
> The rtl8367c still can only use those external interface ports as a
> single CPU port. Eventually, a different device could use one of those
> ports as a downlink to a second switch or as a second CPU port. RTL8367S
> has an SGMII external interface, but my test device (TP-Link Archer
> C5v4) uses only the second RGMII interface. We need a test device with
> more external ports in use before implementing those features.
> 
> The rtl8366rb subdriver was not tested with this patch series, but it
> was only slightly touched. It would be nice to test it, especially in an
> MDIO-connected switch.
> 
> Best,
> 
> Luiz
> 
> 
