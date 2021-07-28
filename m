Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91F3D9721
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhG1UyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhG1UyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 16:54:19 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD6AC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 13:54:17 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242] (unknown [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id B055B204F4;
        Wed, 28 Jul 2021 13:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627505656;
        bh=1Yq1pVKzHGC9i/vQDZyK5m1HE31IKdYorItYYVNaxPg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iey6pbu6un3s36qU4ARK2fL/KMbvgB3JiyS0aUGjZPcjUVDSFEain/eOrrWSIDRdt
         z7MQKON7Inoq21mSxzae4VVc9INvOw26VAgdDsnZxFQPu6Cm9pT8Aq0wwSTDAgq+nI
         qWVfubOJ0tHe12jaOqrzj39XSp17jtRaUTP5yYaU=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
 <YPxPF2TFSDX8QNEv@lunn.ch> <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com> <YQHCSxgraGsXsz0J@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <afed8a23-de6b-bcf2-e87f-8b68113abca5@helixd.com>
Date:   Wed, 28 Jul 2021 13:54:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQHCSxgraGsXsz0J@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 1:47 PM, Andrew Lunn wrote:
>> Many thanks for the link; I will build and install it on the target. Hope it
>> will work with the older kernel (5.4.114) we're using.
> 
> Probably not. You need
> 
> commit b71a8d60252111d89dccba92ded7470faef16460
> Author: Andrew Lunn <andrew@lunn.ch>
> Date:   Sun Oct 4 18:12:57 2020 +0200
> 
>      net: dsa: mv88e6xxx: Add per port devlink regions
>      
>      Add a devlink region to return the per port registers.
>      
>      Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>      Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>      Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 5.4 we released in 2019-11-24.
> 
> When debugging issues like this, you really should be using a modern
> kernel. At minimum 5.13, better still, net-next.

You're absolutely right. The issue is we're relying on the upstream 
socfpga Cyclone V kernel, and our custom board requires we rebase our 
local fixes.

But, you're right: using net-next is probably what I try next, if commit 
b71a8d6025 doesn't resolve this issue.

Thank you very much for all of the feedback!
