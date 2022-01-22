Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4B3496D81
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiAVTCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:02:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34912 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiAVTCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:02:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D888E60EA8;
        Sat, 22 Jan 2022 19:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E6BC340E2;
        Sat, 22 Jan 2022 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642878160;
        bh=SO36fcd9Ftwvt4jmydGyHNgBsA+Y6OnFF6+xWBsSfKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JqEq5dbtbupfQ1SYtPOUX4Ef5KzYeLROmvNiDA7hScXrZepO6w0KRtCGBeqjAyFsU
         SsIdypZIp+hSWpz8GyM1i6dCxp66Ahg7bw6uToNoAnjvEuEZTzRDK9O8J+SuNk2HtM
         RLA4xQfrgR8Dnc/kc1rg42hIXk0yg1gnr0PCfiQ0nFJuELVSuaLLOePGD5T/LHX3UD
         dM+BJeKfQm//v1iFKi1F6iUA4+Mfs0QLT4xq0LRCaKz/bQJIcr2vFEz4xRqUBgLtEI
         4EpcqIi9UF03ABM4VZMU8/KNtO0wzKat/jpb//vql3vkRtOvuw4Gu+/qcN947Cir0c
         a/zwz+RXibktQ==
Date:   Sat, 22 Jan 2022 14:02:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.16 108/217] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
Message-ID: <YexUzGPZVZrJ7RP2@sashalap>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-108-sashal@kernel.org>
 <20220118122316.yas6mmyzog6said3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118122316.yas6mmyzog6said3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 12:23:17PM +0000, Vladimir Oltean wrote:
>Hello Sasha,
>
>On Mon, Jan 17, 2022 at 09:17:51PM -0500, Sasha Levin wrote:
>> From: Colin Foster <colin.foster@in-advantage.com>
>>
>> [ Upstream commit 49af6a7620c53b779572abfbfd7778e113154330 ]
>>
>> Existing felix devices all have an initialized pcs array. Future devices
>> might not, so running a NULL check on the array before dereferencing it
>> will allow those future drivers to not crash at this point
>>
>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/dsa/ocelot/felix.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
>> index f1a05e7dc8181..221440a61e17e 100644
>> --- a/drivers/net/dsa/ocelot/felix.c
>> +++ b/drivers/net/dsa/ocelot/felix.c
>> @@ -823,7 +823,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
>>  	struct felix *felix = ocelot_to_felix(ocelot);
>>  	struct dsa_port *dp = dsa_to_port(ds, port);
>>
>> -	if (felix->pcs[port])
>> +	if (felix->pcs && felix->pcs[port])
>>  		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
>>  }
>>
>> --
>> 2.34.1
>>
>
>Please drop this patch from all stable branches (5.16, 5.15, 5.10).

Dropped, thanks!

-- 
Thanks,
Sasha
