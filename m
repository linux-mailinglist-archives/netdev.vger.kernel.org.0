Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07011783F5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbgCCU1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:27:45 -0500
Received: from correo.us.es ([193.147.175.20]:57300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgCCU1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 15:27:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 86950DA394
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 21:27:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78CDFDA7B2
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 21:27:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 606ACDA3B4; Tue,  3 Mar 2020 21:27:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C579DA72F;
        Tue,  3 Mar 2020 21:27:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 21:27:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E2B5242EE38E;
        Tue,  3 Mar 2020 21:27:25 +0100 (CET)
Date:   Tue, 3 Mar 2020 21:27:39 +0100
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
Message-ID: <20200303202739.6nwq3ru2vf62j2ek@salvia>
References: <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
 <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
 <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
 <20200302192437.wtge3ze775thigzp@salvia>
 <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200302214659.v4zm2whrv4qjz3pe@salvia>
 <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 06:55:54PM +0000, Edward Cree wrote:
> On 02/03/2020 22:49, Jakub Kicinski wrote:
> > On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote:
> >> On Mon, Mar 02, 2020 at 12:18:52PM -0800, Jakub Kicinski wrote:
> >>> On Mon, 2 Mar 2020 20:24:37 +0100 Pablo Neira Ayuso wrote:  
> >>>> It looks to me that you want to restrict the API to tc for no good
> >>>> _technical_ reason.  
> 
> The technical reason is that having two ways to do things where one would
>  suffice means more code to be written, tested, debugged.  So if you want
>  to add this you need to convince us that the existing way (a) doesn't
>  meet your needs and (b) can't be extended to cover them.

One single unified way to express the hardware offload for _every_
supported frontend is the way to go. The flow_offload API provides a
framework to model all hardware offloads for each existing front-end.

I understand your motivation might be a specific front-end of your
choice, that's fair enough.

> > Also neither proposal addresses the problem of reporting _different_
> > counter values at different stages in the pipeline, i.e. moving from
> > stats per flow to per action. But nobody seems to be willing to work 
> > on that.
> For the record, I produced a patch series[1] to support that, but it
>  wasn't acceptable because none of the in-tree drivers implemented the
>  facility.  My hope is that we'll be upstreaming our new driver Real
>  Soon Now™, at which point I'll rebase and repost those changes.
> Alternatively if any other vendor wants to support it in their driver
>  they could use those patches as a base.

Great, I am very much looking forward to reviewing your upstream code.

Just keep in my mind that whatever proposal you make must work for
netfilter too.

Thank you.
