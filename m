Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4631C6F62
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEFLdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:33:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53606 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgEFLdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:33:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4784F6007C;
        Wed,  6 May 2020 11:33:37 +0000 (UTC)
Received: from us4-mdac16-58.ut7.mdlocal (unknown [10.7.66.29])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 45D762009A;
        Wed,  6 May 2020 11:33:37 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C2C761C004F;
        Wed,  6 May 2020 11:33:36 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EA1EF480059;
        Wed,  6 May 2020 11:33:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 6 May 2020
 12:33:29 +0100
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
To:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505193145.GA9789@salvia>
 <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505214321.GA13591@salvia>
 <20200505162942.393ed266@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e8de6def-8232-598a-6724-e790296a251b@solarflare.com>
Date:   Wed, 6 May 2020 12:33:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200505162942.393ed266@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25402.001
X-TM-AS-Result: No-1.360000-8.000000-10
X-TMASE-MatchedRID: xcONGPdDH5q8rRvefcjeTfZvT2zYoYOwC/ExpXrHizz6I9i0e8hghcfB
        RYvA7Qimi2Vy1lps1qHlUb21iTHhT6ZY4PxfRMWEQ24lJ40XApgbAqzdFRyxuESbbPTiMagTgMp
        BuJUGNe3B0ki7dmSgF3rBsLkzYdezjaYSACRQiDd3wUVuihU/jpAoP2KG7EfPAa6hrn8pQDCNBv
        RmKMdxcCoLt8AP659Oeb3f20kKgFL4kBiMXhevoVD5LQ3Tl9H7AQ8mtiWx//qbuvvgpZZI+ZGE1
        OovlhYFD6bYMz71y+Jy8eYYZSzHFUKPluOEKT3/GJADAbBHGUxUIaneDj+GO9EZrmyNM/Ru1gVf
        qaZEz0Y93QAR2QK7TAdcruc0/YQGWAPmaH6lUzUcLuEDP+gqcn2K69afcnwqwCTIeJgMBBt2UK6
        xU6n4PzxhqvlusG8LCn8TaV9gGVxNfs8n85Te8oMbH85DUZXy3QfwsVk0UbsIoUKaF27lxRLFe2
        Pv+4fcApe+rkXSUUsw2YFU65oCoKvPjrTp1tjW26FBdjXvnBXnoooiiK1rxT14trqG5oXoSMDTC
        Dmd7+xum14wZGJWfaKAQfLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.360000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25402.001
X-MDID: 1588764817-23GW24dK6FNV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 00:29, Jakub Kicinski wrote:
> IIRC we went from the pure bitfield implementation (which was my
> preference) to one where 0 means disabled.
>
> Unfortunately we ended up with a convoluted API where drivers have to
> check for magic 0 or 'any' values.
Yeah, I said something dumb a couple of threads ago and combined the
 good idea (a DISABLED bit) with the bad idea (0 as magic DONT_CARE
 value), sorry for leading Pablo on a bit of a wild goose chase there.
(It has some slightly nice properties if you're trying to write out-of-
 tree drivers that work with multiple kernel versions, but that's never
 a good argument for anything, especially when it requires a bunch of
 extra code in the in-tree drivers to handle it.)

> On Tue, 5 May 2020 23:43:21 +0200 Pablo Neira Ayuso wrote:
>> And what is the semantic for 0 (no bit set) in the kernel in your
>> proposal?
It's illegal, the kernel never does it, and if it ever does then the
 correct response from drivers is to say "None of the things I can
 support (including DISABLED) were in the bitmask, so -EOPNOTSUPP".
Which is what drivers written in the natural way will do, for free.

>> Jiri mentioned there will be more bits coming soon. How will you
>> extend this model (all bit set on for DONT_CARE) if new bits with
>> specific semantics are showing up?
If those bits are additive (e.g. a new type like IMMEDIATE and
 DISABLED), then all-bits-on works fine.  If they're orthogonal flags,
 ideally there should be two bits, one for "flag OFF is acceptable"
 and one for "flag ON is acceptable", that way 0b11 still means don't
 care.  And 0b00 gets EOPNOTSUPP regardless of the rest of the bits.

>> Combining ANY | DISABLED is non-sense, it should be rejected.
It's not nonsense; it means what it says ("I accept any of the modes
 (which enable stats); I also accept disabled stats").

-ed
