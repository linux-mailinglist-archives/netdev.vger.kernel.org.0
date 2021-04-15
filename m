Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C08360431
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhDOIW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:22:59 -0400
Received: from void.so ([95.85.17.176]:41074 "EHLO void.so"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhDOIW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 04:22:58 -0400
Received: from void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTP id F09992ADF5A
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:22:34 +0300 (MSK)
Received: from void.so ([127.0.0.1])
        by void.so (void.so [127.0.0.1]) (amavisd-new, port 10024) with LMTP
        id gYpjUW4-Ke1I for <netdev@vger.kernel.org>;
        Thu, 15 Apr 2021 11:22:34 +0300 (MSK)
Received: from rnd (unknown [91.244.183.205])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by void.so (Postfix) with ESMTPSA id 476742ADF59
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:22:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=void.so; s=mail;
        t=1618474954; bh=GdHPtaW1+JirtHfDXN+g3afLnhc1ndHodz+XJCt+1+c=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=PwwcLG9IVxAqv8UrfXZgBUlyD/m2cgz5B+rnxC98EQH2VEcVbvojODFEotmbM70+H
         quxUHN0FUn+jHHwtazSO7Yjt05vXG7uDa+SSGC1V60AWVnmk/SFESndttverTalBmU
         BTgbL3TMd7pVorfL37xQcSOrnf7U+ZrKwQoPrlfU=
Date:   Thu, 15 Apr 2021 11:20:46 +0300
From:   Pavel Balaev <mail@void.so>
To:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
Message-ID: <YHf3XtDOhDfUppSS@rnd>
References: <YHWGmPmvpQAT3BcV@rnd>
 <08aba836-162e-b5d3-7a93-0488489be798@gmail.com>
 <YHaa0pRCTKFbEhA2@rnd>
 <bcf3a5d5-bfbd-d8d3-05e9-ad506e6a689e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bcf3a5d5-bfbd-d8d3-05e9-ad506e6a689e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 08:24:11PM -0700, David Ahern wrote:
> On 4/14/21 12:33 AM, Pavel Balaev wrote:
> >>
> >> This should work the same for IPv6.
> > I wanted to add IPv6 support after IPv4 will be approved,
> > anyway no problem, will add IPv6 in next version 
> >> And please add test cases under tools/testing/selftests/net.
> > This feature cannot be tested whithin one host instance, becasue the same seed
> > will be used by default for all netns, so results will be the same
> > anyway, should I use QEMU for this tests?
> >  
> > 
> 
> why not make the seed per namespace?
In patch seed is maked per namespace. I mean that I cannot check default
behaviour whitin one host: sysctl net.ipv4.fib_multipath_hash_seed=random.
In this case system random seed will be used (same for all netns,
as it was before my patch).

We can only test two cases:

netns0: net.ipv4.fib_multipath_hash_seed=${SEED_0}
netns1: net.ipv4.fib_multipath_hash_seed=${SEED_1}

flows direction will not be the same.

netns0: net.ipv4.fib_multipath_hash_seed=${SEED_0}
netns1: net.ipv4.fib_multipath_hash_seed=${SEED_0}

flows direction will be the same.

Is this enough?
