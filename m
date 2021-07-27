Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B123D70FF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhG0IPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbhG0IPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:15:38 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B15CC061757;
        Tue, 27 Jul 2021 01:15:38 -0700 (PDT)
Received: from mwalle01.kontron.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 090102224A;
        Tue, 27 Jul 2021 10:15:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627373736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wzkpiE705hBjrRDTlxVySidFADOCKJFCAvrd4XNPjI=;
        b=i29QLO2HcWu9ux3wGI/xPUh4OqP8xI0ljTCjO56X+lyDaxldxJg4KvzN0m3pMA5NUJw27X
        uSDDzZFH+UqfrPswwSua7yRapfj9u1MkUhAUFjxPRX1sn1NyBR69VNYcoATrHJ4sE8bM/9
        a+f8Pw210QeEK4f689UGzNMy9pa2oYM=
From:   Michael Walle <michael@walle.cc>
To:     andrew@lunn.ch
Cc:     anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kabel@kernel.org, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, pavel@ucw.cz, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Date:   Tue, 27 Jul 2021 10:15:28 +0200
Message-Id: <20210727081528.9816-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <YP9n+VKcRDIvypes@lunn.ch>
References: <YP9n+VKcRDIvypes@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> The last time we discussed this (Andrew, Pavel and I), we've decided
>> that for ethernet PHY controlled LEDs we want the devicename part
>> should be something like
>>    phyN  or  ethphyN  or  ethernet-phyN
>> with N a number unique for every PHY (a simple atomically increased
>> integer for every ethernet PHY).
>
> We might want to rethink this. PHYs typically have 2 or 3 LEDs. So we
> want a way to indicate which LED of a PHY it is. So i suspect we will
> want something like
>
> ethphyN-led0, ethphyN-led1, ethphyN-led2.
>
> I would also suggest N starts at 42, in order to make it clear it is a
> made up arbitrary number, it has no meaning other than it is
> unique. What we don't want is people thinking ethphy0-led0 has
> anything to do with eth0.

Why do we have to distiguish between LEDs connected to the PHY and LEDs
connected to the MAC at all? Why not just name it ethN either if its behind
the PHY or the MAC? Does it really matter from the users POV?

>> I confess that I am growing a little frustrated here, because there
>> seems to be no optimal solution with given constraints and no official
>> consensus for a suboptimal yet acceptable solution.
>
> I do think it is clear that the base name is mostly irrelevant and not
> going to be used in any meaningful way. You are unlikely to access
> these LEDs via /sys/class/leds. You are going to go into
> /sys/class/net/<ifname> and then either follow the device symlink, or
> the phydev symlink and look for LEDs there. And then only the -ledM
> part of the name might be useful. Since the name is mostly
> meaningless, we should just decide and move on.

Even more if it is not relevant ;)

-michael
