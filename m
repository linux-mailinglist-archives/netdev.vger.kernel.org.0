Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3602CE186
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgLCWYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbgLCWYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 17:24:52 -0500
Date:   Thu, 3 Dec 2020 14:24:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607034251;
        bh=Zr/89+pOI8j1IPxXkFjH3sfC7DYmfGTlISIa4l3iDJU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=k6aAaQ2F8HG/9l7LJRh2LxHEilEIDFaWG+vrtFBn17k9Xm9i2wrVR82qD1Eg4ZOQW
         ON5or1pYihYHwck1jKXuuJUYHXvZgHUQhLPziZSWVX0bzMegSTojj4eEk0DMBr45Wq
         rEGchPm96UFSaRU8J9mmgurb+8DTOUFKnzVh3ZmrhSw0boGhYD28VAxUyXw4a5QLQD
         jwAQy3ZCpeG1ptITO4hyhK6frf7NqeoSjGuraDAyiBNOV96ldVJwJSIebw8/AVLvbk
         nVsscK5II+oN0uEpQkDbGKBaBGaTGvn17T4d9OL1GN0yafy+HN6lAkbEjXx2paH638
         AiNioJyWg0SvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Morris <jmorris@namei.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] security: add const qualifier to struct
 sock in various places
Message-ID: <20201203142409.3bbc068f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <alpine.LRH.2.21.2012040407080.9312@namei.org>
References: <20201130153631.21872-1-fw@strlen.de>
        <20201130153631.21872-2-fw@strlen.de>
        <20201202112848.46bf4ea6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <alpine.LRH.2.21.2012040407080.9312@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 04:07:16 +1100 (AEDT) James Morris wrote:
> On Wed, 2 Dec 2020, Jakub Kicinski wrote:
> > On Mon, 30 Nov 2020 16:36:29 +0100 Florian Westphal wrote:  
> > > A followup change to tcp_request_sock_op would have to drop the 'const'
> > > qualifier from the 'route_req' function as the
> > > 'security_inet_conn_request' call is moved there - and that function
> > > expects a 'struct sock *'.
> > > 
> > > However, it turns out its also possible to add a const qualifier to
> > > security_inet_conn_request instead.
> > > 
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  The code churn is unfortunate.  Alternative would be to change
> > >  the function signature of ->route_req:
> > >  struct dst_entry *(*route_req)(struct sock *sk, ...
> > >  [ i.e., drop 'const' ].  Thoughts?  
> > 
> > Security folks - is this okay to merge into net-next?
> > 
> > We can put it on a branch and pull into both trees if the risk 
> > of conflicts is high.  
> 
> Acked-by: James Morris <jamorris@linux.microsoft.com>

Thank you!

Into net-next it goes..
