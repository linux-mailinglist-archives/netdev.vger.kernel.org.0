Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85675F22D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 06:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfGDEdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 00:33:41 -0400
Received: from mx-relay64-hz1.antispameurope.com ([94.100.133.232]:53677 "EHLO
        mx-relay64-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbfGDEdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 00:33:41 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay64-hz1.antispameurope.com;
 Thu, 04 Jul 2019 06:33:39 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 4 Jul
 2019 06:33:38 +0200
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <eedf83cd-3795-21c5-419e-6a5a8e79ace0@eks-engel.de>
Date:   Thu, 4 Jul 2019 06:33:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703155518.GE18473@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay64-hz1.antispameurope.com with DC2C15C094A
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.2220
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03.07.19 17:55, Andrew Lunn wrote:
> On Wed, Jul 03, 2019 at 03:10:34PM +0200, Benjamin Beckmeyer wrote:
>> Hey folks,
>>
>> I'm having a problem with a custom i.mx6ul board. When DSA is loaded I can't 
>> get access to the switch via MDIO, but the DSA is working properly. I set up
>> a bridge for testing and the switch is in forwarding mode and i can ping the 
>> board. But the MDIO access isn't working at address 2 for the switch. When I 
>> delete the DSA from the devicetree and start the board up, I can access the 
>> switch via MDIO.
>>
>> With DSA up and running:
>>
>> mii -i 2 0 0x9800
>> mii -i 2 1
>> phyid:2, reg:0x01 -> 0x4000
>> mii -i 2 0 0x9803
>> mii -i 2 1
>> phyid:2, reg:0x01 -> 0x4000
>> mii -i 2 1 0x1883
>> mii -i 2 1
>> phyid:2, reg:0x01 -> 0x4000
> Hi Benjamin
>
> I'm guessing that the driver is also using register 0 and 1 at the
> same time you are, e.g. to poll the PHYs for link status etc.
>
> There are trace points for MDIO, so you can get the kernel to log all
> registers access. That should confirm if i'm right.
>
> 	  Andrew

Hi Andrew,
I will do so. Haven't done it before, so maybe it takes some time.

I'm just wondering why I haven't these problems with another switching
chip. Here we use the 88E6390 in multi chip addressing mode, in the 
other custom board we have a 88E6321 in single chip addressing mode, 
but there the registers would be polled too. Maybe you know a answer?

Thanks again for your fast reply.

