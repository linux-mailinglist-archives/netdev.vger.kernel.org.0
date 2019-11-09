Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5223F5EAE
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfKILUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:20:22 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40590 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfKILUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 06:20:21 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iTOmo-0003te-Kn; Sat, 09 Nov 2019 12:20:10 +0100
Date:   Sat, 9 Nov 2019 12:20:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ander Juaristi <a@juaristi.eus>,
        wenxu <wenxu@ucloud.cn>, Thomas Gleixner <tglx@linutronix.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 09/16] netfilter: nft_meta: use 64-bit time arithmetic
Message-ID: <20191109112010.GC15063@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Arnd Bergmann <arnd@arndb.de>,
        y2038@lists.linaro.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ander Juaristi <a@juaristi.eus>,
        wenxu <wenxu@ucloud.cn>, Thomas Gleixner <tglx@linutronix.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
References: <20191108213257.3097633-1-arnd@arndb.de>
 <20191108213257.3097633-10-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108213257.3097633-10-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 10:32:47PM +0100, Arnd Bergmann wrote:
> On 32-bit architectures, get_seconds() returns an unsigned 32-bit
> time value, which also matches the type used in the nft_meta
> code. This will not overflow in year 2038 as a time_t would, but
> it still suffers from the overflow problem later on in year 2106.

I wonder if the assumption that people will still use nft_meta 80 years
from now is an optimistic or pessimistic one. :)

> Change this instance to use the time64_t type consistently
> and avoid the deprecated get_seconds().
> 
> The nft_meta_weekday() calculation potentially gets a little slower
> on 32-bit architectures, but now it has the same behavior as on
> 64-bit architectures and does not overflow.
> 
> Fixes: 63d10e12b00d ("netfilter: nft_meta: support for time matching")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Phil Sutter <phil@nwl.cc>
