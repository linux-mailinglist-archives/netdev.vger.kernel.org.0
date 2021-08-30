Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A3E3FBCD5
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhH3TX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhH3TXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 15:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D0A60ED6;
        Mon, 30 Aug 2021 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630351350;
        bh=bD/PRX2r6uMy0nvYwzbiesOU91GqKICjrpxoivduALw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T19AiTfTnKyfwpgvpfv9IKG7CwFyVDnmV/mPUC0e6TOvWEVKVJ2wDB87Y1OSsUyfp
         KC0MT9n/MLMFT5iuHKDdyH/VntBfk1Jg5XJPrY0Jqz9VxRx2/HKQr7OmSRlCfjDqu0
         EmDjt9STRLwjYp4e9OssvkLkc5066zWAv58kfEt5NbMFmDshc7TJQjCBRHy0rOYc/t
         VgbS7EXNoOCRPvoJE8BAXvc2vkcdFwDkMDeQjovoP2al0ihfkyj48q6/OM78wjy8km
         SDqeV1LuqJ57ECSpg9ZCWsGehI/lfAYSC/s7DY5rIax/0tgbyi0Z2jHbAZm+jpfKzt
         cdwLBElFdT3Hw==
Date:   Mon, 30 Aug 2021 15:22:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     wens@kernel.org, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
Message-ID: <YS0v9UbzoHkiU9om@sashalap>
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
 <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
 <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 09:57:51AM +0200, Michael Riesch wrote:
>Hi ChenYu,
>
>On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>> <michael.riesch@wolfvision.net> wrote:
>>>
>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>> unbalanced pm_runtime_enable warnings.
>>>
>>> In the commit to be reverted, support for power management was
>>> introduced to the Rockchip glue code. Later, power management support
>>> was introduced to the stmmac core code, resulting in multiple
>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>
>>> The multiple invocations happen in rk_gmac_powerup and
>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>> in conjunction.
>>>
>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>>
>> I just found that Ethernet stopped working on my RK3399 devices,
>> and I bisected it down to this patch.
>
>Oh dear. First patch in a kernel release for a while and I already break
>things.
>
>Cc: Sasha as this patch has just been applied to 5.13-stable.

I'll drop it for now, thanks for letting me know!

-- 
Thanks,
Sasha
