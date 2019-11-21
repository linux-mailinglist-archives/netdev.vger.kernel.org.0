Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7C6104E45
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUIpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:45:42 -0500
Received: from mars.blocktrron.ovh ([51.254.112.43]:39826 "EHLO
        mail.blocktrron.ovh" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUIpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:45:42 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2019 03:45:40 EST
Received: from [IPv6:2003:e5:3f0b:d900:a9cf:9b4e:2f8a:599f] (p200300E53F0BD900A9CF9B4E2F8A599F.dip0.t-ipconnect.de [IPv6:2003:e5:3f0b:d900:a9cf:9b4e:2f8a:599f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 653351FA94;
        Thu, 21 Nov 2019 09:38:50 +0100 (CET)
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
To:     Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20191118181505.32298-1-marek.behun@nic.cz>
 <20191119102744.GD32742@smile.fi.intel.com>
 <alpine.DEB.2.21.1911201053330.25420@ramsan.of.borg>
 <20191121020822.GD18325@lunn.ch>
From:   David Bauer <mail@david-bauer.net>
Autocrypt: addr=mail@david-bauer.net; prefer-encrypt=mutual; keydata=
 mQENBFYkGEcBCADbRMHdOXmszxrmE9G/gWUD4/HXklOfn+hyBpEcOul+GKAet0oFxznkchJe
 hO5MbEFYsnM8TZVxjnEi70c3luF1m4JycjgQ91GJ52+xvLV0dVz+L99JBgVJNRDvvt68rLVq
 A8/LCdkXctZ+GBfrtTYQ6dOeuQf/qWuwlNTvuG92uWVZjncyWOmQX73gv+1MTRsCmIGNYQu1
 ZDVyhr3YsTgJIXTHUCxBHQBDglkb3L5lK9WHPf1puQ2grNbUg9VSmo4a9IzUpRauNtCDUFxi
 1m1e5VnmU5O5/xZyDzwmpWog9tUfScS7X9pdVNQ+2W3zCRrotFEn6FKdD01mhIsLnczjABEB
 AAG0IkRhdmlkIEJhdWVyIDxtYWlsQGRhdmlkLWJhdWVyLm5ldD6JAVkEEwEIAEMCGwMHCwkI
 BwMCAQYVCAIJCgsEFgIDAQIeAQIXgAIZARYhBNcEMml7fEwnOA/No7qzlxS0pLh4BQJbLRhu
 BQkIy2cnAAoJELqzlxS0pLh4It8IALb1ea/ezwy8v65zmTeIepeuO5umWzWIy7fLaAsxzJbH
 rO6rCTnRN5ZLyzuxNlhYMyvXAJL7kmPuEOOzHk5xh3soV24VZLSryzGeB6TG3g8L6D0guJ72
 JMM/2HGP8g1zu/IfIM94DZJk7WEuRKG5sndZp49s/voKhrMqAvAU4G03knpEN5SbJx5RA/Wf
 i5stipz2vqS87jHgOVTL1m67Wg9jhKuzJbSlt+m8rHZCQ9dCQQLtqbHugnyOrFhKxwfGFEMB
 aV0sKwoBfjtWP/g3kb9L5wOvRj8UnDRLTB/fVnOsMD18ILEiNqc6FCh4hIb4y2QQEc0nb68f
 imjr4Hz7TOe5AQ0EViQYRwEIALqz1V6kWIvCTVN/6QN9fepVSwSw+5IiiVBGtf2rtdqujCRD
 bGi96a2ZLYRQzlSQvCZ51skgoZFmIW2YhPP90qiZssSEQxgY1rf+DEYnjWmFSgi3iHqYXRk2
 cY7OI3ZT8D2tAFu9pIAxZpD5FdQznJmUhljeTJw+lGOoxctf1xjHZcRcU6GUFMpFBc4xaLC0
 hUN24HT5pDpklxskPFH91VncDaOsLesqszGaUHWx3hogRfogdADvycUp/bQB80kZO/XqexWN
 GUNJYS4axWM2ND25bWV1h9aFjPpOwFM7FwAyra0VihnnNn7dTL5vBpFztY0IFPlvqyc1Vw8y
 vgtShA0AEQEAAYkBPAQYAQgAJgIbDBYhBNcEMml7fEwnOA/No7qzlxS0pLh4BQJbLRiFBQkI
 y2c+AAoJELqzlxS0pLh4LIcH/jnL+ytxRSAh8VX3U2xrMOhBFOkJbW9fj6UgE2iFfZUEOBZl
 q6fZTYn1LOTOECrnLC6eNUQsnZ2u+/N93I5Fmof0MIICUbVabEVmbF/jCFkKjrTPFv/DbNZy
 c+X2ugyX7LsJT+CdvtPT9fObTLCS1nQc3G49syEGVEIzPNyIFzJbFLyh1AfRxmnzAwlal6xK
 S82CsKe+n2lwWg2dyyoJYqwM2G6hAg/ZFqRBZ1RH6TsACGMnwvmsfW/871mPt/mOTCDoH1s1
 tcsgxxtD87UnEqA4zL8dqi5uRA82ZznWaq3mzOGKcBkgEcxi8nnQWW+EyTiZWC+wJ9xT4kLh
 z03IzJQ=
Message-ID: <94309e1b-d8f0-676f-5865-cff94832d830@david-bauer.net>
Date:   Thu, 21 Nov 2019 09:38:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121020822.GD18325@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 11/21/19 3:08 AM, Andrew Lunn wrote:
>> The difference with the non-optional case is that
>> __devm_reset_control_get() registers a cleanup function if there's
>> no error condition, even for NULL (which is futile, will send a patch).
>>
>> However, more importantly, mdiobus_register_reset() calls a devm_*()
>> function on "&mdiodev->dev" ("mdio_bus ee700000.ethernet-ffffffff:01"),
>> which is a different device than the one being probed
>> (("ee700000.ethernet"), see also the callstack below).
>> In fact "&mdiodev->dev" hasn't been probed yet, leading to the WARNING
>> when it is probed later.
>>
>>     [<c0582de8>] (mdiobus_register_device) from [<c05810e0>] (phy_device_register+0xc/0x74)
>>     [<c05810e0>] (phy_device_register) from [<c0675ef4>] (of_mdiobus_register_phy+0x144/0x17c)
>>     [<c0675ef4>] (of_mdiobus_register_phy) from [<c06760f0>] (of_mdiobus_register+0x1c4/0x2d0)
>>     [<c06760f0>] (of_mdiobus_register) from [<c0589f0c>] (sh_eth_drv_probe+0x778/0x8ac)
>>     [<c0589f0c>] (sh_eth_drv_probe) from [<c0516ce8>] (platform_drv_probe+0x48/0x94)
>>
>> Has commit 71dd6c0dff51b5f1 ("net: phy: add support for
>> reset-controller") been tested with an actual reset present?

I'm using it on a AR9132 board, however the mdio bus is probed before the
ethernet driver, hence why i was not experiencing this misbehavior.

>>
>> Are Ethernet drivers not (no longer) allowed to register MDIO busses?
> 
> That is not good. The devm_reset_control_get() call need replaces with
> an unmanaged version, and a call to reset_control_put() added to
> mdiobus_unregister_device().
> 
> David, could you look at this, it was a patch from you that added
> this.

I will prepare patches to fix this bug.

Best wishes
David

> 
> 	Andrew
> 
