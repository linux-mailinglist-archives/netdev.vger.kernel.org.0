Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35442E7AFD
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgL3QQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgL3QQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:16:39 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1396C061799;
        Wed, 30 Dec 2020 08:15:59 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q205so19066132oig.13;
        Wed, 30 Dec 2020 08:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sT1WfvZ/VNnT+yFaWuGoi/l7Bq1FMUDHZOCC1Y2+fPE=;
        b=ethJ4BLM6aV4G/eZ9jcZg5lqzDbFG2IfsH7b4uaCZR9REUgYTXWiPs5FIeEPR57Vxx
         Aft8UtClyiKajFgK74xqklRmLnUUyg9d3F+ZBgJjZyJIm/71Og5HJWVNEgMKoMglJfC9
         5uPpbbxMVtRnIcBDUEDcu998/tKDg8hWX0jsO1vSTmMqkfBoR9K5if9tuabQegzqUsB+
         LGLlTRqh3FBi3nXgoijiBcEeYoupqPiW3Eko5C49pv7sR5rJjsePRhgMSSRlN4fCh0+7
         VuDngK9QfwDK9eiLVC+NjPpluyrLgyJiCl+HMJ5XG8yBgrqNp/qfrbUjDiduBwdzmjIj
         Ub1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sT1WfvZ/VNnT+yFaWuGoi/l7Bq1FMUDHZOCC1Y2+fPE=;
        b=iiuHLM0/7WqICStEcnLTRQEiKVrLGfLw7UtxVwkWt4Jj6roe8v8/Md4xoeAduktdxa
         dyxtZMKFkicQ5811hwbO50Wd/erfJ0kn40GmgfOi00W+WyDSXy5sQC2yYwZnZvvMluzb
         0/n+wFJ2kvktRIZTxgcsID+dwRLwFYHfzIfXRXLN8wVJjCwwFDjULLXfMN7YdBlveqHU
         rFxVAvIrqAvKH8bL6nlrq7kPW1VVqadIKQ0+gs+yWfCgPx2YsOYiUR3zjkgqHTQNSQx3
         /GjgLobqzinPQxn+Ssvz21o9NoAwLmA17aZ6pxgubDz7alWN+diZ0UsDzYaq9JbhC4MS
         CGvA==
X-Gm-Message-State: AOAM530aq5CHTFaTyS/z8jODEwSDblpV6FkANkUu9UN33kguzN2cIcn0
        i9JnMaVnUYQy8rgOOFgmBXM=
X-Google-Smtp-Source: ABdhPJxkAuKmzzPyrPRqPj0G3+aF8DzJxOnTYHUg43sHLpgCHtEew7hUypkyDpPQf97bis89/nR4Cg==
X-Received: by 2002:a54:4711:: with SMTP id k17mr5569826oik.149.1609344959037;
        Wed, 30 Dec 2020 08:15:59 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:549a:788d:4851:c1b0? ([2600:1700:dfe0:49f0:549a:788d:4851:c1b0])
        by smtp.gmail.com with ESMTPSA id z3sm10684023otq.22.2020.12.30.08.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 08:15:58 -0800 (PST)
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
 <CALW65jbV-RwbmmiGjfq8P-ZcApOW0YyN6Ez5FvhhP4dgaA+VjQ@mail.gmail.com>
 <fa7951e1-4a98-8488-d724-3eda9b97e376@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <546a8430-8865-1be8-4561-6681c7fa8ef8@gmail.com>
Date:   Wed, 30 Dec 2020 08:15:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <fa7951e1-4a98-8488-d724-3eda9b97e376@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2020 1:12 AM, Heiner Kallweit wrote:
> On 30.12.2020 10:07, DENG Qingfang wrote:
>> Hi Heiner,
>> Thanks for your reply.
>>
>> On Wed, Dec 30, 2020 at 3:39 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>> I don't think that's the best option.
>>
>> I'm well aware of that.
>>
>>> You may want to add a PHY driver for your chip. Supposedly it
>>> supports at least PHY suspend/resume. You can use the RTL8366RB
>>> PHY driver as template.
>>
>> There's no MediaTek PHY driver yet. Do we really need a new one just
>> for the interrupts?
>>
> Not only for the interrupts. The genphy driver e.g. doesn't support
> PHY suspend/resume. And the PHY driver needs basically no code,
> just set the proper callbacks.

That statement about not supporting suspend/resume is not exactly true,
the generic "1g" PHY driver only implements suspend/resume through the
use of the standard BMCR power down bit, but not anything more
complicated than that.

Interrupt handling within the PHY itself is not defined by the existing
standard registers and will typically not reside in a standard register
space either, so just for that reason you do need a custom PHY driver.
There are other advantages if you need to expose additional PHY features
down the road like PHY counters, energy detection, automatic power down etc.

I don't believe we will see discrete/standalone Mediatek PHY chips, but
if that happens, then you would already have a framework for supporting
them.
-- 
Florian
