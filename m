Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6A18FAB4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgCWRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgCWRB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:01:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A941720735;
        Mon, 23 Mar 2020 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584982887;
        bh=7tmCZHVG0haQMMfQaXKGfvCkeQtsMbpAmACMnqoUcJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGiiBBvcbC+wBP57HVIVlQn9O8FxUIf5wwRNqVgJmBatptsJfWcctZJTbUOnoJzs/
         30xLVvPzDTYS29PuhSU35RxrN1QDFgsGAiKRUssZEPJaz/nbtei6rtRWEor++WXomF
         ESTgXW1dasRoQG2/yFbz6U70cjvZ+s9QS1E6aRSY=
Date:   Mon, 23 Mar 2020 10:01:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Oz Shlomo <ozsh@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix actions_match_supported()
 return
Message-ID: <20200323100124.0a07236f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200323100215.GB26299@kadam>
References: <20200320132305.GB95012@mwanda>
        <35fcb57643c0522b051318e75b106100422fb1dc.camel@mellanox.com>
        <20200323100215.GB26299@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 13:02:16 +0300 Dan Carpenter wrote:
> On Sat, Mar 21, 2020 at 02:43:08AM +0000, Saeed Mahameed wrote:
> > On Fri, 2020-03-20 at 16:23 +0300, Dan Carpenter wrote:  
> > > The actions_match_supported() function returns a bool, true for
> > > success
> > > and false for failure.  This error path is returning a negative which
> > > is cast to true but it should return false.
> > > 
> > > Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > index 044891a03be3..e5de7d2bac2b 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > @@ -3058,7 +3058,7 @@ static bool actions_match_supported(struct
> > > mlx5e_priv *priv,
> > >  			 */
> > >  			NL_SET_ERR_MSG_MOD(extack,
> > >  					   "Can't offload mirroring
> > > with action ct");
> > > -			return -EOPNOTSUPP;
> > > +			return false;
> > >  		}
> > >  	} else {
> > >  		actions = flow->nic_attr->action;  
> > 
> > applied to net-next-mlx5   
> 
> I can never figure out which tree these are supposed to be applied to.
> :(  Is there a trick to it?

Not as far as I know :/ Upstream maintainers usually know which
sub-maintainers like to take patches into their own tree first.

Tagging things as "net-next" is perfectly fine in this case.

We could ask all maintainers who want to funnel patches via their own
trees to add T: entries in MAINTAINERS, but I'm not sure how practical
that is.
