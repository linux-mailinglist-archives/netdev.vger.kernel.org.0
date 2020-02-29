Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A917490A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 20:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgB2T4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 14:56:08 -0500
Received: from correo.us.es ([193.147.175.20]:46570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgB2T4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 14:56:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2EF7BC22FB
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 20:55:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 204E9DA72F
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 20:55:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D5D7DA3AC; Sat, 29 Feb 2020 20:55:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EC05DA736;
        Sat, 29 Feb 2020 20:55:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 29 Feb 2020 20:55:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AABCF42EE38E;
        Sat, 29 Feb 2020 20:55:52 +0100 (CET)
Date:   Sat, 29 Feb 2020 20:56:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Marian Pritsak <marianp@mellanox.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200229195602.gwq3vlifugseuc6c@salvia>
References: <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho>
 <20200228195909.dfdhifnjy4cescic@salvia>
 <20200229080120.GP26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229080120.GP26061@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 09:01:20AM +0100, Jiri Pirko wrote:
> Fri, Feb 28, 2020 at 08:59:09PM CET, pablo@netfilter.org wrote:
> >Hi Pirko,
> >
> >On Tue, Feb 25, 2020 at 05:22:03PM +0100, Jiri Pirko wrote:
> >[...]
> >> Eh, that is not that simple. The existing users are used to the fact
> >> that the actions are providing counters by themselves. Having and
> >> explicit counter action like this would break that expectation.
> >> Also, I think it should be up to the driver implementation. Some HW
> >> might only support stats per rule, not the actions. Driver should fit
> >> into the existing abstraction, I think it is fine.
> >
> >Something like the sketch patch that I'm attaching?
> 
> But why? Actions are separate entities, with separate counters. The
> driver is either able to offload that or not. Up to the driver to
> abstract this out.

You can add one counter for each action through FLOW_ACTION_COUNTER.
Then, one single tc action maps to two flow_actions, the action itself
and the counter action. Hence, the tc frontend only needs to append a
counter after the action.

Why this might be a problem from the driver side? From reading this
thread, my understanding is that:

1) Some drivers have the ability to attach to immediate/delayed
   counters.
2) The immediate counters might be a limited resource while delayed
   counters are abundant.
3) Some drivers have counters per-filter, not per-action. In that
   case, for each counter action in the rule, the driver might decide
   to make all counter actions refer to the per-filter counter.

Thank you!
