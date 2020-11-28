Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BB2C730D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgK1Vt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387591AbgK1TpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:45:23 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B106821D40;
        Sat, 28 Nov 2020 19:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606592682;
        bh=vjEo6+1NJr1fhU60twyQ6fj6sEFRGZbdUzpwIu7j6VU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SZmfqg6AkOW8YagPITqTw/j76W7w0gWiC5dDx7lY8HLXM1eUdPX/k61F+rU4Oda0e
         VEN8ZuP8sErc3FnsjCj2cELwAuWks8T0AM6s1Ad5PJZjIwoYjozfrRIueWEv0u0/RA
         62XUNB3iGH5Czihh1vOh9oVen+wBSGQSye0yaUeA=
Date:   Sat, 28 Nov 2020 11:44:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, wenxu@ucloud.cn, paulb@nvidia.com,
        ozsh@nvidia.com, ahleihel@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] net/sched: act_ct: enable stats for HW
 offloaded entries
Message-ID: <20201128114441.4e5b9afb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128023144.GC449907@localhost.localdomain>
References: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
        <20201127180032.52b320a5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201128023144.GC449907@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 23:31:44 -0300 Marcelo Ricardo Leitner wrote:
> On Fri, Nov 27, 2020 at 06:00:32PM -0800, Jakub Kicinski wrote:
> > On Thu, 26 Nov 2020 15:40:49 -0300 Marcelo Ricardo Leitner wrote:  
> > > By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
> > > commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
> > > offload") are not effective when using act_ct.
> > > 
> > > While at it, now that we have the flag set, protect the call to
> > > nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
> > > nf_conn_acct for act_ct SW offload in flowtable") with the check on
> > > NF_FLOWTABLE_COUNTER, as also done on other places.
> > > 
> > > Note that this shouldn't impact performance as these stats are only
> > > enabled when net.netfilter.nf_conntrack_acct is enabled.
> > > 
> > > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>  
> > 
> > Why no Fixes tag and not targeting net here?  
> 
> Well, I don't know if it was left out on purpose or not/missed.
> What I know is that act_ct initially had no support for stats of
> offloaded entries. ef803b3cf96a wasn't specific to act_ct (and didn't
> have to update it), while some support on act_ct was introduced with
> beb97d3a3192, but only for sw offload. So it seems to me that it's
> just a new piece(/incremental development) that nobody had cared so
> far.
> 
> If you see it otherwise, I'm happy to change. I'll just need a hint on
> which commit I should use for the Fixes tag (as it's not clear to me,
> per above).

I don't know the code well enough to override, so I'll trust your
judgment :)

Applied to net-next, thanks!
