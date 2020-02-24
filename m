Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0059716A506
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgBXLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:38:32 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:35573 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXLib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:38:31 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8123C22F00;
        Mon, 24 Feb 2020 12:38:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582544309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATJ7FEy8mNyFSf7mhjpZz7vvqF1vlw/dfVmlo7ml+8I=;
        b=nZYC8M/aCrC+rIryhmGaMHYYKK0YbOA2Ghg3VEpxrmxItu0RVkt5amPnhs4SEW9Mcrqvol
        EZdxmg2J5fXFTfjYW3LznIRbxzlQNJydD/3VqQSqpvff3Fi18WH69ka3ldWbJBw6hLueNQ
        Nc9a1Vzkrfnl/KKUa/RLAelYQeGNuKM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 Feb 2020 12:38:26 +0100
From:   Michael Walle <michael@walle.cc>
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 devicetree 0/6] DT bindings for Felix DSA switch on
 LS1028A
In-Reply-To: <20200224112026.GF27688@dragon>
References: <20200223204716.26170-1-olteanv@gmail.com>
 <20200224112026.GF27688@dragon>
Message-ID: <f92f01d60589d94bb25a38dd828200b0@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: /
X-Spam-Status: No, score=-0.10
X-Rspamd-Server: web
X-Spam-Score: -0.10
X-Rspamd-Queue-Id: 8123C22F00
X-Spamd-Result: default: False [-0.10 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[13];
         NEURAL_HAM(-0.00)[-0.684];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[gmail.com,kernel.org,arm.com,vger.kernel.org,lunn.ch,nxp.com,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

Am 2020-02-24 12:20, schrieb Shawn Guo:
> On Sun, Feb 23, 2020 at 10:47:10PM +0200, Vladimir Oltean wrote:
>> This series officializes the device tree bindings for the embedded
>> Ethernet switch on NXP LS1028A (and for the reference design board).
>> The driver has been in the tree since v5.4-rc6.
>> 
>> It also performs some DT binding changes and minor cleanup, as per
>> feedback received in v1 and v2:
>> 
>> - I've changed the DT bindings for the internal ports from "gmii" to
>>   "internal". This means changing the ENETC phy-mode as well, for
>>   uniformity. So I would like the entire series to be merged through a
>>   single tree, probably the devicetree one - something which David
>>   Miller has aggreed to, here [0].
>> - Disabled all Ethernet ports in the LS1028A DTSI by default, which
>>   means not only the newly introduced switch ports, but also RGMII
>>   standalone port 1.
>> 
>> [0]: https://lkml.org/lkml/2020/2/19/973
>> 
>> Claudiu Manoil (2):
>>   arm64: dts: fsl: ls1028a: add node for Felix switch
>>   arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
>> 
>> Vladimir Oltean (4):
>>   arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for 
>> ENETC
>>     RCIE
>>   arm64: dts: fsl: ls1028a: disable all enetc ports by default
> 
> I applied these 4 DTS patches with changing prefix to 'arm64: dts: 
> ls1028a: '.

Oh, then the kontron-sl28 boards won't have ethernet because the nodes 
are
disabled now. I'll send a patch shortly which explicitly sets the status 
to
"okay", hopefully you can pick it up so it'll end up in the same pull 
request
as this one:

   arm64: dts: fsl: ls1028a: disable all enetc ports by default

-michael

> 
> Shawn
> 
>>   net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
>>   dt-bindings: net: dsa: ocelot: document the vsc9959 core
>> 
>>  .../devicetree/bindings/net/dsa/ocelot.txt    | 116 
>> ++++++++++++++++++
>>  .../boot/dts/freescale/fsl-ls1028a-qds.dts    |   1 +
>>  .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |  61 ++++++++-
>>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |  89 +++++++++++++-
>>  drivers/net/dsa/ocelot/felix.c                |   3 +-
>>  drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
>>  6 files changed, 265 insertions(+), 8 deletions(-)
>>  create mode 100644 
>> Documentation/devicetree/bindings/net/dsa/ocelot.txt
>> 
>> --
>> 2.17.1
>> 
