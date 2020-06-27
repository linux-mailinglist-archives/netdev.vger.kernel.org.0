Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404C220BF1B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgF0HBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:01:39 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:48919 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgF0HBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 03:01:39 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05R71YNk032414;
        Sat, 27 Jun 2020 00:01:35 -0700
Date:   Sat, 27 Jun 2020 12:18:56 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/3] cxgb4: add mirror action to TC-MATCHALL
 offload
Message-ID: <20200627064855.GB24993@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
 <9a8e0a8df764f44f6dce0c3fbb9dd56aa8d049ab.1593085107.git.rahul.lakkireddy@chelsio.com>
 <20200626211844.40ed466c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626211844.40ed466c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, June 06/26/20, 2020 at 21:18:44 -0700, Jakub Kicinski wrote:
> On Thu, 25 Jun 2020 17:28:41 +0530 Rahul Lakkireddy wrote:
> > +	if (refcount_read(&pi->vi_mirror_refcnt) > 1) {
> > +		refcount_dec(&pi->vi_mirror_refcnt);
> > +		return;
> > +	}
> 
> FWIW this looks very dodgy. If you know nothing changes the count
> between the read and the dec here, you probably don't need atomic
> refcounts at all..

Currently, all the callers accessing this refcount and its related
data is having the RTNL lock held by the stack. Perhaps this is a
false sense of security, especially if the stack API may change in
the future.

I'll add a proper lock to protect this data in v2 to be on the safer
side.

Thanks,
Rahul
