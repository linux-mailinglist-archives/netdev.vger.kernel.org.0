Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2E35B68A
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhDKSRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhDKSRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 14:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A25A6109F;
        Sun, 11 Apr 2021 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618165046;
        bh=YXf8Yyuuop+Bs4/HJM1E6o7/73iH/bZFU6Te9hUNYt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gl4p3og+nvvhqXxjNI2Bo2nO6kZbgSRXuLqbln13LysVX4+t4Y6tx6jnyypmTD5Hn
         0Gmh8/rIrDkLIPBZ900ttMM7gkqisyGrzLg8YztdyKGyCpV7yu+iGwgM3NUxNc4B9S
         WCJlfJHZEXzDmViVkzRR4lltsI/SiwSS2XnCKOKnbwqSeZX+2ofmqEEgroTcu40Ppv
         xLkIfQlW7WjOWKhL167Gt04SkDCHFzXFk5BHxckoHjvDHpyeSalFYiOkkB9D85Dvv6
         KVyU9HEb5la8xh7dMDAN3oTL/7LAhvIeF/my5bL6b5egm/aVy0tJMuNXSpArovnK/M
         CfZN4dwbp1T/A==
Date:   Sun, 11 Apr 2021 14:17:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        f.fainelli@gmail.com, davem@davemloft.net
Subject: Re: [PATCH stable-5.4 0/2] net: dsa: lantiq_gswip: backports for
 Linux 5.4
Message-ID: <YHM9NX1AuNk6CCMn@sashalap>
References: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
 <YHMoRAAVSKvfF6b9@sashalap>
 <CAFBinCDmkJinzxG0XVoLvCnA+a4wDDfKyg-5GiHs0abAMsi1Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFBinCDmkJinzxG0XVoLvCnA+a4wDDfKyg-5GiHs0abAMsi1Cg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 07:17:46PM +0200, Martin Blumenstingl wrote:
>Hi Sasha,
>
>On Sun, Apr 11, 2021 at 6:48 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Sun, Apr 11, 2021 at 12:23:42PM +0200, Martin Blumenstingl wrote:
>> >Hello,
>> >
>> >This backports two patches (which could not be backported automatically
>> >because the gswip_phylink_mac_link_up function is different in Linux 5.4
>> >compared to 5.7 and newer) for the lantiq_gswip driver:
>> >- commit 3e9005be87777afc902b9f5497495898202d335d upstream.
>> >- commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.
>> >
>> >This is the first time that I am doing such a backport so I am not
>> >sure how to mention the required modifications. I added them at the
>> >bottom of each patch with another Signed-off-by. If this is not correct
>> >then please suggest how I can do it rights.
>>
>> Hey Martin,
>>
>> Your backport works, but I'd rather take 5b502a7b2992 ("net: dsa:
>> propagate resolved link config via mac_link_up()") along with the
>> backport instead. This means that we don't diverge from upstream too
>> much and will make future backports easier.
>>
>> I've queued up these 3 commits to 5.4, thanks!
>in general I am fine with your suggested approach. however, I think at
>least one more backport is required then:
>91a208f2185ad4855ff03c342d0b7e4f5fc6f5df ("net: phylink: propagate
>resolved link config via mac_link_up()")
>Patches should be backported in a specific order also so we don't
>break git bisect:
>- phylink patch
>- dsa patch
>- the two lantiq GSWIP patches

Good point, I haven't realized there's an additional phylink patch
(which on it's own requires more dependencies and follow-ups). In this
case I'll just grab your backport, thanks!

-- 
Thanks,
Sasha
