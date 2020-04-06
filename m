Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392CD19F7E7
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgDFOZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:25:57 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:43228 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgDFOZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586183155; x=1617719155;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UXzCuqx6XZgdIt0F7s7TA6ZJVX4IiMnBpMRn1/zp2lI=;
  b=QcZr/hLTIPjmKiog/1kVSphAqE+AiZDWm6CmI8urHtq9/s2OoxzqcdxF
   J520CDSYIn317v9nKpBkXwAWVnsYL9e7J6ELQssNsMNxo36xyzPODEO8+
   iElFA7pQ0zhd4ngU+z2RJkOLIDO8CH/mqr9pMAk2s8/2oLct4khUgmLp9
   VFUNAjAGUiDoKOMmYgKLbe7HfYvyEaPxgadvowCVlzxaO4k5m3TDsrpSe
   mpvowjpCmRshdP+Ehj8LCB082RS9ayZI0fh6oT4dnSTiLerO4Ogyh7mOR
   FP9DBos0z8qZiRUb7r68pU3LAWFYdMPIZc3vRSoHHKDKFk9yWZ1EdO52Z
   A==;
IronPort-SDR: H5syFWIQd+kmpgpKXjZxdOQf82lfiky2bmuHF7wNpAAIWVIBlb8ry5JVAOMq8BMW8jGJaUfab2
 OrW+cRC7l7TKi15Mx2PnZ1eOpoQCakci6MnXG+wnowIxWCcQdIhgnqb+/XWJZ7zfa1MWlB/H32
 LRBV4tPMh7xjsjQ8zHozNVZMBey22a0WKQvgYzaGsG2ELGLvcLadjtO42cdFpWVa5C4T6V8bZS
 CfXObXN/FT6jhyT9z1nyujtZiJjZVkiSp4cim4QjP3wxJmghANoWS6VY7ioJ4AXFIG5BFwSnGc
 VZs=
X-IronPort-AV: E=Sophos;i="5.72,351,1580799600"; 
   d="scan'208";a="71358618"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2020 07:25:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 6 Apr 2020 07:26:05 -0700
Received: from [10.205.29.84] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 6 Apr 2020 07:25:59 -0700
Subject: Re: [RFC PATCH 0/3] net: macb: Wake-on-Lan magic packet fixes
To:     Harini Katakam <harinik@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rafal Ozieblo <rafalo@cadence.com>,
        <sergio.prado@e-labworks.com>, <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Michal Simek <michal.simek@xilinx.com>
References: <cover.1585917191.git.nicolas.ferre@microchip.com>
 <CAFcVECLkPxN0nk=jr9AxJoV3i1jHBoY4s3yeodHDO2uOZspQPg@mail.gmail.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <9e2ab6cd-526d-f1b5-4bd0-4a8f80d9dd8f@microchip.com>
Date:   Mon, 6 Apr 2020 16:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAFcVECLkPxN0nk=jr9AxJoV3i1jHBoY4s3yeodHDO2uOZspQPg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harini,

On 03/04/2020 at 15:36, Harini Katakam wrote:
> Hi Nicolas,
> 
> On Fri, Apr 3, 2020 at 6:45 PM <nicolas.ferre@microchip.com> wrote:
>>
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Hi,
>> Here are some of my early patches in order to fix WoL magic-packet on the
>> current macb driver.
>> Addition of this feature to GEM types of IPs is yet to come. I would like to
>> have your feedback on these little patches first so that I can continue
>> investigating the addition of GEM WoL magic-packet.
>>
>> Harini, I know that you have patches for GEM in order to integrate WoL ARP
>> mode [1]. I'll try to integrate some of your work but would need that this feature
>> is better integrated in current code. For instance, the choice of "magic
>> packet" or "ARP" should be done by ethtool options and DT properties. For
>> matching with mainline users, MACB and GEM code must co-exist.
> 
> Agree. I'll try to test this series and get back to you next week.
> 
>> The use of dumb buffers for RX seems also fairly platform specific and we would
>> need to think more about it.
> 
> I know that the IP versions from r1p10 have a mechanism to disable DMA queues
> (bit 0 of the queue pointer register) which is cleaner. But for
> earlier IP versions,

Which IP name are you referring to? GEM, GEM-GXL? What is the value of 
register 0xFC then?

> I remember discussing with Cadence and there is no way to keep RX
> enabled for WOL
> with RX DMA disabled. I'm afraid that means there should be a bare
> minimum memory
> region with a dummy descriptor if you do not want to process the
> packets. That memory
> should also be accessible while the rest of the system is powered
> down. Please let me

Very interesting information Harini, thanks a lot for having shared it.

My GEM IP has 0xFC at value: 0x00020203. But I don't see a way to keep 
DMA queues disabled by using the famous bit that you mention above.

> know if you think of any other solution.

I'm trying all this right now. I keep you posted.

Thanks and best regards,
   Nicolas


-- 
Nicolas Ferre
