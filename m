Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6452D8641
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 12:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437478AbgLLLkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 06:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgLLLku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 06:40:50 -0500
X-Greylist: delayed 1027 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Dec 2020 03:40:10 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA22C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 03:40:10 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@netfilter.org>)
        id 1ko2zN-0007nf-Ca; Sat, 12 Dec 2020 12:23:01 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@netfilter.org>)
        id 1ko2zF-003sUY-Ub; Sat, 12 Dec 2020 12:22:53 +0100
Date:   Sat, 12 Dec 2020 12:22:53 +0100
From:   Harald Welte <laforge@netfilter.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 10/12] gtp: add IPv6 support
Message-ID: <X9SoDToVmUdhgP0D@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-11-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-11-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

thanks again for your patches, they are very much appreciated.

However, I don't think that it is "that easy".

PDP contexts (at least) in GPRS/EDGE and UMTS come in three flavors:
* IPv4 only
* IPv6 only
* IPv4v6 (i.e. both an IPv4 and an IPv6 address within the same tunnel)

See for example osmo-ggsn at https://git.osmocom.org/osmo-ggsn
for an userspace implementation that covers all three cases,
as well as a related automatic test suite containing cases
for all three flavors at
https://git.osmocom.org/osmo-ttcn3-hacks/tree/ggsn_tests

If I read your patch correctly

On Fri, Dec 11, 2020 at 01:26:10PM +0100, Jonas Bonn wrote:
> -	struct in_addr		ms_addr_ip4;
> -	struct in_addr		peer_addr_ip4;
> +	struct in6_addr		ms_addr;
> +	struct in6_addr		peer_addr;

this simply replaces the (inner) IPv4 "MS addr" with an IPv6 "MS addr".

Sure, it is an improvement over v4-only.  But IMHO any follow-up
change to introduce v4v6 PDP contexts would require significant changes,
basically re-introducing the ms_add_ip4 member which you are removing here.

Therefore, I argue very much in favor of intrducing proper IPv6 support
(including v4v6) in one go.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
