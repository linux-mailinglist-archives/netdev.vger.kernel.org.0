Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A766B225A3
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 03:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfESBWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 21:22:55 -0400
Received: from sobre.alvarezp.com ([173.230.155.94]:52786 "EHLO
        sobre.alvarezp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbfESBWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 21:22:55 -0400
Received: from [192.168.15.64] (unknown [189.205.206.165])
        by sobre.alvarezp.com (Postfix) with ESMTPSA id 5342F1E2B1;
        Sat, 18 May 2019 20:22:54 -0500 (CDT)
From:   Octavio Alvarez <octallk1@alvarezp.org>
Subject: Re: PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
 <20190518215802.GI63920@meh.true.cz>
Message-ID: <56e0a7a9-19e7-fb60-7159-6939bd6d8a45@alvarezp.org>
Date:   Sat, 18 May 2019 20:22:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190518215802.GI63920@meh.true.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: uk-UA
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Petr,

On 5/18/19 4:58 PM, Petr Štetiar wrote:
>> Linux version 5.1.0-12511-g72cf0b07418a (alvarezp@alvarezp-samsung)
> 
> What do I need to do/apply in order to get the same source tree with
> 72cf0b07418a hash? I'm not able to find that commit.

It's the most recent master, so my guess is just fetch it.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72cf0b07418a9c8349aa9137194b1ccba6e54a9d

commit 72cf0b07418a9c8349aa9137194b1ccba6e54a9d (HEAD -> master,
origin/master, origin/HEAD)
Merge: 0ef0fd351550 56df90b631fc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 17 13:57:54 2019 -0700

    Merge tag 'sound-fix-5.2-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound

>>         iap = of_get_mac_address(hw->pdev->dev.of_node);
>> -       if (iap)
>> +       if (!IS_ERR(iap))
> 
> I'm just shooting out of the blue, as I don't have currently any rational
> explanation for that now, but could you please change the line above to
> following:
> 
>           if (!IS_ERR_OR_NULL(iap))

It worked! Thank you for being so quick!

$ sudo dmesg | grep sky2
[    1.520831] sky2: driver version 1.30
[    1.521197] sky2 0000:06:00.0: Yukon-2 FE+ chip revision 0
[    1.522574] sky2 0000:06:00.0 eth0: addr e8:11:32:8d:86:49
[   52.881706] sky2 0000:06:00.0 eth0: enabling interface
[   54.455020] sky2 0000:06:00.0 eth0: Link is up at 100 Mbps, full
duplex, flow control rx
[  235.562317] sky2 0000:06:00.0 eth0: disabling interface
[  238.947494] sky2 0000:06:00.0 eth0: enabling interface

