Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707CC44F9DF
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 19:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhKNSFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 13:05:17 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58656 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhKNSFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 13:05:06 -0500
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 469AC25AEF5;
        Mon, 15 Nov 2021 05:02:09 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id E537B27F0; Sun, 14 Nov 2021 19:02:06 +0100 (CET)
Date:   Sun, 14 Nov 2021 19:02:06 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>, pablo@netfilter.org
Cc:     GuoYong Zheng <zhenggy@chinatelecom.cn>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: remove unused variable for ip_vs_new_dest
Message-ID: <20211114180206.GA2757@vergenet.net>
References: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
 <25e945b7-9027-43cb-f79c-573fdce42a26@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25e945b7-9027-43cb-f79c-573fdce42a26@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 13, 2021 at 11:56:36AM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Fri, 5 Nov 2021, GuoYong Zheng wrote:
> 
> > The dest variable is not used after ip_vs_new_dest anymore in
> > ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.
> > 
> > Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
> 
> 	Looks good to me for -next, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Thanks GuoYong,

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider this for nf-next at your convenience.

> 
> > ---
> >  net/netfilter/ipvs/ip_vs_ctl.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index e62b40b..494399d 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -959,8 +959,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
> >   *	Create a destination for the given service
> >   */
> >  static int
> > -ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
> > -	       struct ip_vs_dest **dest_p)
> > +ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
> >  {
> >  	struct ip_vs_dest *dest;
> >  	unsigned int atype, i;
> > @@ -1020,8 +1019,6 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
> >  	spin_lock_init(&dest->stats.lock);
> >  	__ip_vs_update_dest(svc, dest, udest, 1);
> >  
> > -	*dest_p = dest;
> > -
> >  	LeaveFunction(2);
> >  	return 0;
> >  
> > @@ -1095,7 +1092,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
> >  		/*
> >  		 * Allocate and initialize the dest structure
> >  		 */
> > -		ret = ip_vs_new_dest(svc, udest, &dest);
> > +		ret = ip_vs_new_dest(svc, udest);
> >  	}
> >  	LeaveFunction(2);
> >  
> > -- 
> > 1.8.3.1
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
