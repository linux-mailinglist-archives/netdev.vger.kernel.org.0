Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A22FCEF5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfKNTxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:53:01 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:12710 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfKNTxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:53:01 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAEJqqvF016725;
        Thu, 14 Nov 2019 11:52:53 -0800
Date:   Fri, 15 Nov 2019 01:14:41 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v2 2/2] cxgb4: add TC-MATCHALL classifier
 ingress offload
Message-ID: <20191114194435.GA12678@chelsio.com>
References: <cover.1573738924.git.rahul.lakkireddy@chelsio.com>
 <90842f5408ecb616c7be1912f803f1689b612172.1573738924.git.rahul.lakkireddy@chelsio.com>
 <20191114102037.6df3aa23@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114102037.6df3aa23@cakuba.netronome.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, November 11/14/19, 2019 at 10:20:37 -0800, Jakub Kicinski wrote:
> On Thu, 14 Nov 2019 21:04:05 +0530, Rahul Lakkireddy wrote:
> > Add TC-MATCHALL classifier ingress offload support. The same actions
> > supported by existing TC-FLOWER offload can be applied to all incoming
> > traffic on the underlying interface.
> > 
> > Only 1 ingress matchall rule can be active at a time on the underlying
> > interface.
> > 
> > Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> > ---
> > v2:
> > - Removed logic to fetch free index from end of TCAM. Must maintain
> >   same ordering as in kernel.
> 
> The ordering in the kernel is by filter priority/pref. Not the order of
> addition (which AFAIK you're intending to preserve here?).
> 
> Since you're only offloading the policer presumably you want to limit
> the port speed. The simplest way to make sure the rule ordering is right
> is to only accept the policer as the highest prio rule. I believe OvS
> installs it always with prio 1.

Ok, I've misunderstood your comment earlier. Will add a check in patch 1
to reject policer, if prio is not 1.

Thanks,
Rahul
