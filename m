Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B652A3DC2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgKCHfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:35:15 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:33287 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725968AbgKCHfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 02:35:14 -0500
Received: from [192.168.0.2] (ip5f5af1b7.dynamic.kabel-deutschland.de [95.90.241.183])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 35C6020646DD7;
        Tue,  3 Nov 2020 08:35:10 +0100 (CET)
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
 <20201102231307.13021-3-pmenzel@molgen.mpg.de>
 <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
Date:   Tue, 3 Nov 2020 08:35:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,


Am 03.11.20 um 01:19 schrieb Jakub Kicinski:
> On Tue,  3 Nov 2020 00:13:07 +0100 Paul Menzel wrote:
>> From: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
>>
>> The ops field might no be defined, so add a check.
> 
> This change should be first, otherwise AFAIU if someone builds the
> kernel in between the commits (e.g. for bisection) it will crash.

Patch `[PATCH 1/2] ethernet: igb: Support PHY BCM5461S` has

     phy->ops.force_speed_duplex = igb_phy_force_speed_duplex_82580;

so the ordering does not matter. I do not know, if Jeffrey can comment, 
but probably the check was just adding during development. Maybe an 
assert should be added instead?

>> The patch is taken from Open Network Linux (ONL), and it was added there
>> as part of the patch
>>
>>      packages/base/any/kernels/3.16+deb8/patches/driver-support-intel-igb-bcm5461X-phy.patch
>>
>> in ONL commit f32316c63c (Support the BCM54616 and BCM5461S.) [1]. Part
>> of this commit was already upstreamed in Linux commit eeb0149660 (igb:
>> support BCM54616 PHY) in 2017.
>>
>> I applied the forward-ported
>>
>>      packages/base/any/kernels/5.4-lts/patches/0002-driver-support-intel-igb-bcm5461S-phy.patch
>>
>> added in ONL commit 5ace6bcdb3 (Add 5.4 LTS kernel build.) [2].
>>
>> [1]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/f32316c63ce3a64de125b7429115c6d45e942bd1
>> [2]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/5ace6bcdb37cb8065dcd1d4404b3dcb6424f6331
> 
> No need to put this in every commit message.
> 
> We preserve the cover letter in tree as a merge commit message, so
> explaining things once in the cover letter is sufficient.

I remember, but still find it confusing. If I look at a commit with `git 
show …`, I normally do not think of also looking at a possible cover 
letter as not many subsystems/projects do it, and I assume a commit is 
self-contained.

Could you share your development process

>> Cc: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
> 
> Jefferey will need to provide a sign-off as the author.

According to *Developer's Certificate of Origin 1.1* [3], it’s my 
understanding, that it is *not* required. The items (a), (b), and (c) 
are connected by an *or*.

>         (b) The contribution is based upon previous work that, to the best
>             of my knowledge, is covered under an appropriate open source
>             license and I have the right under that license to submit that
>             work with modifications, whether created in whole or in part 
>             by me, under the same open source license (unless I am
>             permitted to submit under a different license), as indicated
>             in the file; or

>> Cc: John W Linville <linville@tuxdriver.com>
>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul


[3]: 
https://www.kernel.org/doc/html/v5.9/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
