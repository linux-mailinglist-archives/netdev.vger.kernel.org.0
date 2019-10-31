Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDAEB609
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbfJaRW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:22:57 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:38451 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbfJaRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:22:57 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F3D4922487;
        Thu, 31 Oct 2019 18:22:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572542573;
        bh=0fQn8J+Kg8/qf+a/0vkp3JOugLpSh1Dl2VWX2whBuF4=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=Vc1TOFMbc7wpbIIG8zLgOB3I0KhAi4uO1/wBcuW3szUioH68leIr78gX6t69rkAnU
         jb4OjfId/UqtNw7H44PmvTgYjLzVThaaOq/bC/ht7IqjrYhzNCwXeSwuQH/tBLOl5G
         pFaoUquAy00L2OmBODOgUHjpmyYdUhyEpaHeh5Yo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Oct 2019 18:22:52 +0100
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
In-Reply-To: <B3B13FB8-42D9-42F9-8106-536F574FA35B@walle.cc>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-4-michael@walle.cc>
 <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
 <B3B13FB8-42D9-42F9-8106-536F574FA35B@walle.cc>
Message-ID: <e867d1a9a1e4b878aa0dafe413e9a6f7@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-10-31 00:59, schrieb Michael Walle:
>>> +
>>> +	if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
>>> +		priv->flags |= AT803X_KEEP_PLL_ENABLED;
>> 
>> This should probably be a PHY tunable rather than a Device Tree
>> property
>> as this delves more into the policy than the pure hardware 
>> description.
> 
> To be frank. I'll first need to look into PHY tunables before answering 
> ;)
> But keep in mind that this clock output might be used anywhere on the
> board. It must not have something to do with networking. The PHY has a
> crystal and it can generate these couple of frequencies regardless of
> its network operation.

Although it could be used to provide any clock on the board, I don't 
know
if that is possible at the moment, because the PHY is configured in
config_init() which is only called when someone brings the interface up,
correct?

Anyway, I don't know if that is worth the hassle because in almost all
cases the use case is to provide a fixed clock to the MAC for an RGMII
interface. I don't know if that really fits a PHY tunable, because in
the worst case the link won't work at all if the SoC expects an
always-on clock.

-- 
-michael
