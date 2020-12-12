Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2202D85C0
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438651AbgLLKKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389306AbgLLKKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 05:10:45 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4B1C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 02:10:05 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1ql-0004LQ-QJ; Sat, 12 Dec 2020 11:10:03 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1nt-003qLc-3L; Sat, 12 Dec 2020 11:07:05 +0100
Date:   Sat, 12 Dec 2020 11:07:05 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 07/12] gtp: use ephemeral source port
Message-ID: <X9SWSYXxzYQoaCt7@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-8-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-8-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

On Fri, Dec 11, 2020 at 01:26:07PM +0100, Jonas Bonn wrote:
> From 3GPP TS 29.281:
> "...the UDP Source Port or the Flow Label field... should be set dynamically
> by the sending GTP-U entity to help balancing the load in the transport
> network."

You unfortuantely didn't specifiy which 3GPP release you are referring to.

At least in V15.7.0 (2020-01)  Release 15 I can only find:

"For the messages described below, the UDP Source Port (except as
specified for the Echo Response message) may be allocated either
statically or dynamically by the sending GTP-U entity.  NOTE: Dynamic
allocation of the UDP source port can help balancing the load in the
network, depending on network deployments and network node
implementations."

For GTPv0, TS 29.060 states:

"The UDP Source Port is a locally allocated port number at the sending
GSN/RNC."

unfortuantely it doesn't say if it's a locally allocated number globally
for that entire GSN/RNC, or it's dynamic per flow or per packet.

As I'm aware of a lot of very tight packet filtering between GSNs,
I would probably not go for fully dynamic source port allocation
without some kind of way how the user (GTP-control instance) being
able to decide on that policy.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
