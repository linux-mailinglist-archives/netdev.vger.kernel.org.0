Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935D2177D64
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgCCRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:25:33 -0500
Received: from correo.us.es ([193.147.175.20]:35874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgCCRZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:25:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F4766D004
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 18:25:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EE5EDA3A9
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 18:25:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D87EDA3A4; Tue,  3 Mar 2020 18:25:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51199DA3C4;
        Tue,  3 Mar 2020 18:25:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 18:25:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 228AA426CCBA;
        Tue,  3 Mar 2020 18:25:12 +0100 (CET)
Date:   Tue, 3 Mar 2020 18:25:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200303172525.2p6jwa6u7qx5onji@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
 <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
 <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
 <20200302192437.wtge3ze775thigzp@salvia>
 <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200302214659.v4zm2whrv4qjz3pe@salvia>
 <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 02:49:28PM -0800, Jakub Kicinski wrote:
> On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote:
[...]
> > The real question is: if you think this tc counter+action scheme can
> > be used by netfilter, then please explain how.
> 
> In Jiri's latest patch set the counter type is per action, so just
> "merge right" the counter info into the next action and the models 
> are converted.

The input "merge right" approach might work.

> If user is silly and has multiple counter actions in a row - the
> pipe/no-op action comes into play (that isn't part of this set, 
> as Jiri said).

Probably gact pipe action with counters can be mapped to the counter
action that netfilter needs. Is this a valid use-case you consider for
the tc hardware offload?

> Can you give us examples of what wouldn't work? Can you for instance
> share the counter across rules?

Yes, there might be counters that are shared accross rules, see
nfacct. Two different rules might refer to the same counter, IIRC
there is a way to do this in tc too.

> Also neither proposal addresses the problem of reporting _different_
> counter values at different stages in the pipeline, i.e. moving from
> stats per flow to per action. But nobody seems to be willing to work 
> on that.

You mean, in case that different counter types are specified, eg. one
action using delayed and another action using immediate?

> AFAICT with Jiri's change we only need one check in the drivers to
> convert from old scheme to new, with explicit action we need two
> (additional one being ignoring the counter action). Not a big deal,
> but 1 is less than 2 🤷‍♂️

What changes are expected to retrieve counter stats?

Will per-flow stats remain in place after this place?

Thank you.
