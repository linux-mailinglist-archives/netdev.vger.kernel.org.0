Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387874AAA33
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 17:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbiBEQkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 11:40:23 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:51647 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiBEQkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 11:40:22 -0500
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1nGO6W-008YXJ-4Z; Sat, 05 Feb 2022 17:40:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@osmocom.org>)
        id 1nGO0q-003EQf-Pp;
        Sat, 05 Feb 2022 17:34:12 +0100
Date:   Sat, 5 Feb 2022 17:34:12 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Message-ID: <Yf6nBDg/v1zuTf8l@nataraja>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127163900.374645-1-marcin.szycik@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin, Wojciech,

thanks for the revised patch. In general it looks fine to me.

Do you have a public git tree with your patchset applied?  I'm asking as
we do have automatic testing in place at https://jenkins.osmocom.org/ where I
just need to specify a remote git repo andit will build this kernel and
run the test suite.

Some minor remarks below, all not critical, just some thoughts.

It might make sense to mention in the commit log that this patch by itself
would create GTP-U without GTP ECHO capabilities, and that a subsequent
patch will address this.

> This patch allows to create GTP device without providing
> IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user does not
> provide file handles to the sockets, then GTP module takes care
> of creating UDP sockets by itself. 

I'm wondering if we should make this more explicit, i.e. rather than
implicitly creating the kernel socket automagically, make this mode
explicit upon request by some netlink attribute.

> Sockets are created with the
> commonly known UDP ports used for GTP protocol (GTP0_PORT and
> GTP1U_PORT).

I'm wondering if there are use cases that need to operate on
non-standard ports.  The current module can be used that way (as the
socket is created in user space). If the "kernel socket mode" was
requested explicitly via netlink attribute, one could just as well
pass along the port number[s] this way.

-- 
- Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
