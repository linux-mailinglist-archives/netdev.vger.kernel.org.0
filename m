Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D06B608ED0
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 19:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJVRaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 13:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJVRaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 13:30:02 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8902F3B445;
        Sat, 22 Oct 2022 10:29:59 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 23 Oct 2022 02:29:58 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 61C8320584CE;
        Sun, 23 Oct 2022 02:29:58 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Sun, 23 Oct 2022 02:29:58 +0900
Received: from [10.212.158.208] (unknown [10.212.158.208])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id DCF4FB62A4;
        Sun, 23 Oct 2022 02:29:57 +0900 (JST)
Subject: Re: [PATCH net] net: ethernet: ave: Remove duplicate suspend/resume
 calls for phy
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221021174552.6828-1-hayashi.kunihiko@socionext.com>
 <2333ef88-6e3e-a5ad-dcdc-89a405ba2f9e@gmail.com>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <6d2e3944-68f0-1443-b017-13d66650e17a@socionext.com>
Date:   Sun, 23 Oct 2022 02:29:57 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2333ef88-6e3e-a5ad-dcdc-89a405ba2f9e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/10/22 5:55, Heiner Kallweit wrote:
> On 21.10.2022 19:45, Kunihiko Hayashi wrote:
>> Since AVE has its own suspend/resume functions, there is no need to call
>> mdio_bus suspend/resume functions. Set phydev->mac_managed_pm to true
>> to avoid the calls.
>>
> The commit description doesn't make clear (any longer) what the issue
> is that you're fixing. You should mention the WARN_ON() dump here
> like in your first attempt.

Indeed, I forgot to mention the WARN_ON() dump issue.

>> In addition, ave_open() executes __phy_resume() via phy_start() in
>> ave_resume(), so no need to call phy_resume() explicitly. Remove it.
>>
> This sounds like an improvement, being independent of the actual fix.
> The preferred approach would be:
> - submit the fix to net
> - submit the improvement in a separate patch to net-next

Ah, I see.
The one is for fixing WARN_ON() dump, and the other isn't affected
by the behavior, but it should be duplicate removal.

I'll separate it into two patches.

Thank you,

---
Best Regards
Kunihiko Hayashi
