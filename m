Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27832B7970
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgKRIwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:52:03 -0500
Received: from mail.zeus.flokli.de ([88.198.15.28]:54754 "EHLO zeus.flokli.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgKRIwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 03:52:03 -0500
Received: from localhost (ip-178-200-107-224.hsi07.unitymediagroup.de [178.200.107.224])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: flokli@flokli.de)
        by zeus.flokli.de (Postfix) with ESMTPSA id 7CB0AF3BC7C;
        Wed, 18 Nov 2020 08:52:01 +0000 (UTC)
Date:   Wed, 18 Nov 2020 09:51:53 +0100
From:   Florian Klink <flokli@flokli.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
Message-ID: <20201118085153.5tgnzdwuywzsaxti@ws.flokli.de>
References: <20201115224509.2020651-1-flokli@flokli.de>
 <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
 <20201117170712.0e5a8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0c2869ad-1176-9554-0c47-1f514981c6b4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c2869ad-1176-9554-0c47-1f514981c6b4@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> I looked at this yesterday and got distracted diving into the generated
>>> file to see the difference:
>>>
>>> #define CONFIG_IPV6 1
>>>
>>> vs
>>>
>>> #define CONFIG_IPV6_MODULE 1
>
>Digging up ancient history. ;)
>
>> Interesting.
>>
>> drivers/net/ethernet/netronome/nfp/flower/action.c:#ifdef CONFIG_IPV6
>>
>> Oops.
>
>Notify the maintainer!

Yeah, this is super scary stuff - allmodyes-like configs are quite
common in generic distros, and I assume similar mistakes could have
happened in many other places in the kernel as well.

I wonder if the "ifdef CONFIG_…" pattern should be discouraged, and
"IS_ENABLED(CONFIG_…)" used instead, at least for all tristate config
options.

Florian
