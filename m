Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB17B38730
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfFGJlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 05:41:22 -0400
Received: from mx-relay11-hz1.antispameurope.com ([94.100.132.211]:41860 "EHLO
        mx-relay11-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbfFGJlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 05:41:22 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay11-hz1.antispameurope.com;
 Fri, 07 Jun 2019 11:41:10 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Fri, 7 Jun
 2019 11:41:08 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
Date:   Fri, 7 Jun 2019 11:41:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606135903.GE19590@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay11-hz1.antispameurope.com with AD2DBAE5EB0
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.210
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06.06.19 15:59, Andrew Lunn wrote:
> On Thu, Jun 06, 2019 at 03:47:06PM +0200, Benjamin Beckmeyer wrote:
>> On 06.06.19 15:35, Andrew Lunn wrote:
>>>> >From our hardware developer I know now that we are using a "mini" SFF 
>>>> which has no i2c eeprom. 
>>> O.K. Does this mini SFF have LOS, TX-Disable, etc? Are these connected
>>> to GPIOs? I assume the SFF is fibre? And it needs the SERDES to speak
>>> 1000BaseX, not SGMII?
>> Nope, no LOS no tx-disable etc. Yeah, the SFF is fibre. Exactly, it needs 
>> SERDES to speak 1000BaseX.
> O.K. Then try something like what ZII devel B does:
>
>                                        port@3 {
>                                                 reg = <3>;
>                                                 label = "optical3";
>
>                                                 fixed-link {
>                                                         speed = <1000>;
>                                                         full-duplex;
>                                                 };
>
>
> What this does not give you is any link monitoring. I don't have the
> datasheet of this device, but i assume it has two banks of registers
> for the SERDES? And you can get the sync status? Similar to how the
> 6352 works. But with a fixed link this will be ignored.
>
>>>> Switch				|	external
>>>> Port 0 - internal serdes 0x0c --|-------Mini SFF 1x8 Transceiver
>>>> 				|
>>>> Port 0 - internal serdes 0x0d --|-------Mini SFF 1x8 Transceiver
>>>> 				|
>>>> Port 2 ----------RGMII----------|-------KSZ9031 PHY 0x02(strap)--Transceiver
>>>> 				|
>>>> Port 3 - internal PHY 0x03 -----|-------Transceiver
>>>> 				|
>>>> Port 3 - internal PHY 0x04 -----|-------Transceiver
>>>> 				|			
>>>> Port 5 - CPU-Port RMII ---------|-------CPU
>>>> 				|
>>>> Port 6 ----------RGMII----------|-------KSZ9031 PHY 0x06(strap)--Transceiver
>>> So the current state is that just the SFF ports are not working? All
>>> the copper PHYs are O.K.
>>>
>>>     Andrew
>>>
>> The external copper PHYs are still not working properly, but if I set them to
>> fixed-link, I see data coming in with I start tcpdump on my device. Just with
>> some odd header but I'm not that far with DSA-tags and these stuff.
> If you build libpcap & tcpdump from the latest sources, it will
> understand these headers.
>
> 	Andrew

Hi Andrew,

thanks for all the help. We had a problem with the external PHY and our mdio bus.
Now all port are recognized. I set the Serdes ports to a fixed-link, but at the 
moment  I can't test them. Booting kernel 4.9.109 I'm having the interfaces now.
So first of all. success! Great.

So all ports are now in forwarding mode (Switch port register 0x4 of all ports 
are 0x7f), but I don't reach it over ping. Even the ARP request are not forwarded.
The behavior is vice versa. The port status register shows for all copper ports
0x1007 when no link is up so the PHYs are recognized correctly and I tested it 
while the port is up and down. Even the indirect read via PHY COMMAND is working 
with all PHYs now. 
Do I have to set up the DSA in any kind? Or have to set up forwarding mode in 
software?
	Benjamin

