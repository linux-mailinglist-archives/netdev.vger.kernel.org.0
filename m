Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FC44D50E2
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243256AbiCJRv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiCJRvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:51:25 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD812F144
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 09:50:22 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nSMvM-002f1t-HE; Thu, 10 Mar 2022 18:50:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nSMu7-009Hfi-Hm;
        Thu, 10 Mar 2022 18:48:47 +0100
Date:   Thu, 10 Mar 2022 18:48:47 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: Re: PFCP support in kernel
Message-ID: <Yio5/+Ko77tu4Vi6@nataraja>
References: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <Yiju8kbN87kROucg@nataraja>
 <MW4PR11MB5776AB46BC5702BD0120A7C3FD0B9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB5776AB46BC5702BD0120A7C3FD0B9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Thu, Mar 10, 2022 at 03:24:07PM +0000, Drewek, Wojciech wrote:

> > I'm sorry, I have very limited insight into geneve/vxlan.  It may
> > be of interest to you that within Osmocom we are currently implementing
> > a UPF that uses nftables as the backend.  The UPF runs in userspace,
> > handles a minimal subset of PFCP (no qos/shaping, for example), and then
> > installs rules into nftables to perform packet matching and
> > manipulation.  Contrary to the old kernel GTP driver, this approach is
> > more flexible as it can also cover the TEID mapping case which you find
> > at SGSN/S-GW or in roaming hubs.  We currently are just about to
> > complete a prof-of-concept of that.
> 
> That's interesting, I have two questions:
> - is it going to be possible to math packets based on SEID?

I'm sorry, I'm not following you.  The SEID I know (TS 29.244 Section 5.6.2)
has only significance on the PFCP session between control and user plane.

The PFCP peers (e.g. SMF and UPF in a PGW use case) use the SEID to
differentiate between different PFCP sessions.

IMHO this has nothing to do with matching of user plane packets in the
actual UFP?

> - any options for offloading this nftables  filters to the hardware?

You would have to talk to the netfilter project if there are any related
approaches for nftables hardware offload, I am no longer involved in
netfilter development for more than a decade by now.

In the context of the "osmo-upf" proof-of-concept we're working on at
sysmocom, the task is explicitly to avoid any type of hardware
acceleration and to see what kind of performance we can reach with a
current mainline kernel in pure software.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
