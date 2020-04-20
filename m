Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158731B0D8B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgDTN6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:58:05 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33092 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbgDTN6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:58:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jQWvq-0002GP-MT; Mon, 20 Apr 2020 15:57:54 +0200
Date:   Mon, 20 Apr 2020 15:57:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420135754.GD32392@breakpoint.cc>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123915.nrqancwjb7226l7e@salvia>
 <20200420134826.GH6581@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420134826.GH6581@nanopsycho.orion>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, Apr 20, 2020 at 02:39:15PM CEST, pablo@netfilter.org wrote:
> >On Mon, Apr 20, 2020 at 01:28:22PM +0100, Edward Cree wrote:
> >> On 20/04/2020 12:52, Jiri Pirko wrote:
> >> > However for TC, when user specifies "HW_STATS_DISABLED", the driver
> >> > should not do stats.
> >>
> >> What should a driver do if the user specifies DISABLED, but the stats
> >>  are still needed for internal bookkeeping (e.g. to prod an ARP entry
> >>  that's in use for encapsulation offload, so that it doesn't get
> >>  expired out of the cache)?  Enable the stats on the HW anyway but
> >>  not report them to FLOW_CLS_STATS?  Or return an error?
> >
> >My interpretation is that HW_STATS_DISABLED means that the front-end
> >does not care / does not need counters. The driver can still allocate
> 
> That is wrong interpretation. If user does not care, he specifies "ANY".
> That is the default.
> 
> When he says "DISABLED" he means disabled. Not "I don't care".

Under what circumstances would the user care about this?
Rejecting such config seems to be just to annoy user?

I mean, the user is forced to use SW datapath just because HW can't turn
off stats?!  Same for a config change, why do i need to change my rules
to say 'enable stats' even though I don't need them in first place?

Unlike the inverse (want feature X but HW can't support it), it makes
no sense to me to reject with an error here:
stats-off is just a hint that can be safely ignored.
