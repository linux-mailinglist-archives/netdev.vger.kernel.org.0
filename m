Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFDD2E7AFF
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgL3QS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3QS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:18:27 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30390C061799;
        Wed, 30 Dec 2020 08:17:47 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j12so15729961ota.7;
        Wed, 30 Dec 2020 08:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/uyDAirA8VQF0NgEtEzY/g6VOAomyBDYEreP48L36/U=;
        b=LNpQJtKMoVXT5ruUI7JOW34a3e3aQQbF+x4m+8uNOPLTojjJqUe8yCkoWWuB/ZYrJc
         gz+z0rqEIxsl0qjIf3nW40HxsIiPlB0Tjl/GvXHtJGU7sgErhV1xkl5aTtPZFGoSNlzh
         g71YPzmZ0c2h/ramJMEi90Yv5WdkBId2IlC/TkifoUHDowX3GEy/kq05vMOXe18RTTRI
         tX+8D5+E0O1y+UO8g2fcZ6Yt9fdCW5R7pUl+r3Urb+N9tO86PynAMxs+FXjMXA/P1oyP
         r+BJPJeRMlaCSFGwblwV4DmIQzp94AN18a+mW9eQjiliW0dJz5/e2kD5eNlgF/RAxdB+
         mwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uyDAirA8VQF0NgEtEzY/g6VOAomyBDYEreP48L36/U=;
        b=cw9Xo7NuMyfdlgVFXSYm4VV/KBzOEQATBlZtLDZshQCjvwTy7KtgIkRZ0hjqiMBY9N
         G0PH75PrcXscFtTyjXnn1+ZGB5a/+tUAF2to+k8kAFmWOATyQ9hYu3cBSN3TkwmByAaL
         Whn+TBRM8Z/X5vPlWBlxpkXrmUGe/8XR/QX0dOGR04tB90W4UqoYevlLz9Ze1bRVhW0N
         +q8Yzx60U4FEfjtQm4z0LOZWIctW4bOEohNmqALoIa3etOIPgNekkWlUMPaygqhc19rl
         sWppvhlJ5VvJ242H2rpxp1VRvfQjrcGTv2i7iVhQlbAMejMCyLjA7ibP7Vcf9dDBrWqf
         c5Vg==
X-Gm-Message-State: AOAM533SZ9Ns4lMEgNCYN52gwPZ4W+1n2PCYJLdzNhMHZPHADiDUWCSC
        oRhw5OfItMXZDuZmXAON3Rs=
X-Google-Smtp-Source: ABdhPJxTWTUHFZ/ye4izRj5y9293jlqIoBwJHiN+BORC/n3kriEXbz7q74OICZAGaTC7HEFSrCf61g==
X-Received: by 2002:a9d:6a1:: with SMTP id 30mr39303512otx.242.1609345066632;
        Wed, 30 Dec 2020 08:17:46 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:549a:788d:4851:c1b0? ([2600:1700:dfe0:49f0:549a:788d:4851:c1b0])
        by smtp.gmail.com with ESMTPSA id c18sm10404458oib.31.2020.12.30.08.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 08:17:45 -0800 (PST)
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <X+yZvUrul3leWLFq@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d4ad8f1d-63ae-fbf9-fa14-419bf2e3cf9f@gmail.com>
Date:   Wed, 30 Dec 2020 08:17:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X+yZvUrul3leWLFq@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2020 7:16 AM, Andrew Lunn wrote:
>> 2. Allocated ds->slave_mii_bus before calling ds->ops->setup, because
>> we cannot call dsa_slave_mii_bus_init which is private.
>>
>> Any better ideas?
> 
> Do what mv88e6xxx does, allocate the MDIO bus inside the switch
> driver.

Yes, exactly, or you could add additional hooks to allow intercepting
the initialization and de-initialization of the ds->slave_mii_bus,
something like this:

https://github.com/ffainelli/linux/commit/758da087a819cd1a284de074ea7d8eae9f875f0b

which was part of a larger series adding threaded IRQ support to the b53
driver:

https://github.com/ffainelli/linux/commits/b53-irq
-- 
Florian
