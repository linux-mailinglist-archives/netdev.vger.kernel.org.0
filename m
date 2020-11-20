Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDC12BB833
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgKTVRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:17:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbgKTVRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 16:17:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318722224E;
        Fri, 20 Nov 2020 21:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605907021;
        bh=3o42xR/oopO/mERodmzHQ9mZqOBed0ZCPYYqPErn++4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bvxQnVUGwQVyDJhUqXAJAgv+z9FNU3wQlWyy20fwspDIwlJ+ksyQUSObJeRFE58MB
         qt1PX+vx1ADzMz1amtfifndYzTt20vXEoeIMQ2L2n7WgoIHX6jqvRnKsTgyCNhzQGn
         /fTuAfZwIX2CsAE0vunG6auGjQA97TyymDQ0F9Uc=
Date:   Fri, 20 Nov 2020 13:17:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: avoid potential use-after-free
 error
Message-ID: <20201120131700.0bc63655@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120210436.scmic7ygrzviy53o@skbuf>
References: <20201119110906.25558-1-ceggers@arri.de>
        <20201120180149.wp4ehikbc2ngvwtf@skbuf>
        <20201120125921.1cb76a12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201120210436.scmic7ygrzviy53o@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 23:04:36 +0200 Vladimir Oltean wrote:
> On Fri, Nov 20, 2020 at 12:59:21PM -0800, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 20:01:49 +0200 Vladimir Oltean wrote:  
> > > On Thu, Nov 19, 2020 at 12:09:06PM +0100, Christian Eggers wrote:  
> > > > If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> > > > immediately. Shouldn't store a pointer to freed memory.
> > > >
> > > > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > > > Fixes: 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
> > > > ---  
> > >
> > > IMO this is one of the cases to which the following from
> > > Documentation/process/stable-kernel-rules.rst does not apply:
> > >
> > >  - It must fix a real bug that bothers people (not a, "This could be a
> > >    problem..." type thing).
> > >
> > > Therefore, specifying "net-next" as the target tree here as opposed to
> > > "net" is the correct choice.  
> >
> > The commit message doesn't really explain what happens after.
> >
> > Is the dangling pointer ever accessed?  
> 
> Nothing happens afterwards. He explained that he accessed it once while
> working on his ksz9477 PTP series. There's no code affected by this in
> mainline.

Ah, great, I'll drop the Fixes tag altogether then.
