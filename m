Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B91784D8
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgCCVZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:25:16 -0500
Received: from correo.us.es ([193.147.175.20]:50944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731484AbgCCVZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 16:25:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7903E6D011
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 22:25:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66D75DA3AE
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 22:25:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C413DA3A8; Tue,  3 Mar 2020 22:25:00 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BAC4DA736;
        Tue,  3 Mar 2020 22:24:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 22:24:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1A17642EE38F;
        Tue,  3 Mar 2020 22:24:58 +0100 (CET)
Date:   Tue, 3 Mar 2020 22:25:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200303212511.ilge4x2k5zmnyr6w@salvia>
References: <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
 <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
 <20200302192437.wtge3ze775thigzp@salvia>
 <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200302214659.v4zm2whrv4qjz3pe@salvia>
 <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
 <20200303202739.6nwq3ru2vf62j2ek@salvia>
 <0452cffa-1054-418f-0a5d-8e15afd87969@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0452cffa-1054-418f-0a5d-8e15afd87969@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 09:06:48PM +0000, Edward Cree wrote:
> On 03/03/2020 20:27, Pablo Neira Ayuso wrote:
> > On Tue, Mar 03, 2020 at 06:55:54PM +0000, Edward Cree wrote:
> >> On 02/03/2020 22:49, Jakub Kicinski wrote:
> >>> On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote:
> >>>> On Mon, Mar 02, 2020 at 12:18:52PM -0800, Jakub Kicinski wrote:
> >>>>> On Mon, 2 Mar 2020 20:24:37 +0100 Pablo Neira Ayuso wrote:  
> >>>>>> It looks to me that you want to restrict the API to tc for no good
> >>>>>> _technical_ reason.  
> >> The technical reason is that having two ways to do things where one would
> >>  suffice means more code to be written, tested, debugged.  So if you want
> >>  to add this you need to convince us that the existing way (a) doesn't
> >>  meet your needs and (b) can't be extended to cover them.
> > One single unified way to express the hardware offload for _every_
> > supported frontend is the way to go. The flow_offload API provides a
> > framework to model all hardware offloads for each existing front-end.
> >
> > I understand your motivation might be a specific front-end of your
> > choice, that's fair enough.
> I think we've misunderstood each other (90% my fault).
> 
> When you wrote "restrict the API to tc" I read that as "restrict growth of
>  the API for flow offloading" (which I *do* want); I've now re-parsed and
>  believe you meant it as "limit the API so that only tc may use it" (which
>  is not my desire at all).
> 
> Thus, when I spoke of "two ways to do things" I meant that _within_ the
>  (unified) flow_offload API there should be a single approach to stats
>  (the counters attached to actions), to which levels above and below it
>  impedance-match as necessary (e.g. by merging netfilter count actions
>  onto the following action as Jakub described) rather than bundling
>  two interfaces (tc-style counters and separate counter actions)
>  into one API (which would mean that drivers would all need to write
>  code to handle both kinds, at no gain of expressiveness).

It's not that natural to express counters like you prefer for
netfilter, but fair enough, we'll carry on that extra burden of
merging counters to actions.

Sometimes decisions just need a second round: I will expect broken
endianness in drivers because of the 32-bit word choice for the
payload mangling API. But that's a different story.

Noone to blame, there is still experimentation going on in this API.

> I was *not* referring to tc and netfilter
>  as the "two different ways", but  I can see why you read it that
>  way.

I don't follow, sorry.

> I hope that makes sense now.

Sure, thank you.
