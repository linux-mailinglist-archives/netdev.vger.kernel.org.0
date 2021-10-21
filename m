Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4DF43633C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhJUNna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:43:30 -0400
Received: from s2.neomailbox.net ([5.148.176.60]:1146 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhJUNna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:43:30 -0400
Subject: Re: [PATCH net-next] gre/sit: Don't generate link-local addr if
 addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
References: <20211020200618.467342-1-ssuryaextr@gmail.com>
 <9bd488de-f675-d879-97aa-d27948494ed1@unstable.cc>
 <20211021132229.GA6483@ICIPI.localdomain>
From:   Antonio Quartulli <a@unstable.cc>
Message-ID: <f22b0813-6088-1fb1-b429-6a6596ffd877@unstable.cc>
Date:   Thu, 21 Oct 2021 15:41:42 +0200
MIME-Version: 1.0
In-Reply-To: <20211021132229.GA6483@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 21/10/2021 15:22, Stephen Suryaputra wrote:
> On Thu, Oct 21, 2021 at 02:52:44PM +0200, Antonio Quartulli wrote:
>>
>> Maybe I am missing something, but why checking the mode only for
>> pointtopoint? If mode is NONE shouldn't this routine just abort
>> regardless of the interface setup?
>>
> If it isn't pointtopoint, the function sets up IPv4-compatible IPv6
> address, i.e. non link-local (FE80::). addr_gen_mode NONE (1) is only
> controlling the generation of link-local address. Quoting from the
> sysctl doc:
> 
> addr_gen_mode - INTEGER
> 	Defines how link-local and autoconf addresses are generated.
> 
> 	0: generate address based on EUI64 (default)
> 	1: do no generate a link-local address, use EUI64 for addresses generated
> 	   from autoconf
> 	2: generate stable privacy addresses, using the secret from
> 	   stable_secret (RFC7217)
> 	3: generate stable privacy addresses, using a random secret if unset
> 
> So, I thought the checking should be strictly when the link-local
> address is about to be generated.

Right.

IMHO it makes sense.

Acked-by: Antonio Quartulli <a@unstable.cc>

-- 
Antonio Quartulli
