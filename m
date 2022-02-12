Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02C4B346A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 12:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiBLLKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 06:10:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiBLLKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 06:10:12 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F222654C
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 03:10:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIqI0-000bvq-QS; Sat, 12 Feb 2022 12:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIqDi-005Btu-4b;
        Sat, 12 Feb 2022 12:05:38 +0100
Date:   Sat, 12 Feb 2022 12:05:38 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Message-ID: <YgeUgvrjGcDYOvm2@nataraja>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
 <Yf6rKbkyzCnZE/10@nataraja>
 <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YgYpZzOo3FQG+SY2@nataraja>
 <MW4PR11MB577686D883EEBDB2C9E0FEB2FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
 <MW4PR11MB5776F58DE5585DEA423716A4FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB5776F58DE5585DEA423716A4FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Fri, Feb 11, 2022 at 12:48:35PM +0000, Drewek, Wojciech wrote:
> I have one question. The new cmd should be allowed to send echo request
> only to the peers stored in the kernel space (PDP contexts) or the userspace
> daemon has its own list of peers and any request should be allowed to be send?

I think we can expect userspace to know the peers (after all, it has created those
sessions and knows about the peer IP addresses), so we don't have to verify
in the kernel if it is a "valid" peer or not.

So a pure "send GTP ECHO req to given IP" and a corresponding "received GTP ECHO resp
from given IP" (with relevant parameters) without tracking any state in the kernel should
be sufficient.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
