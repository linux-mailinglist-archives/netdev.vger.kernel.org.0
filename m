Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69C8B9DD8
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 14:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407599AbfIUMbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 08:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407595AbfIUMbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Sep 2019 08:31:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5403520665;
        Sat, 21 Sep 2019 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569069061;
        bh=lsQlU8wmqKATMvuaOpTs9Qxl9tYUMDDLLlOKfX7nCuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYiKpGrE8ZR/oZ5MFYYDBzGgmBMrEwe2PahI3waeuNeNdRXzQssXk839U/oUwoDet
         ny0ugx8euAxyZ+WaTAMkcTD6oAVR9KmtNDg9SKj6G+2+kb7LlXGWR2BwNwilNCgL5R
         HhRGjEd59g61mLgUWDPvDUpKHMd2MIDFEDpxtgd8=
Date:   Sat, 21 Sep 2019 14:30:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, jreuter@yaina.de,
        ralf@linux-mips.org, alex.aring@gmail.com, orinimron123@gmail.com
Subject: Re: [PATCH 4/5] ieee802154: enforce CAP_NET_RAW for raw sockets
Message-ID: <20190921123058.GA2462840@kroah.com>
References: <20190920073549.517481-1-gregkh@linuxfoundation.org>
 <20190920073549.517481-5-gregkh@linuxfoundation.org>
 <5c100446-037a-cdc2-5491-fd10385a98fd@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c100446-037a-cdc2-5491-fd10385a98fd@datenfreihafen.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 21, 2019 at 01:58:55PM +0200, Stefan Schmidt wrote:
> Hello.
> 
> On 20.09.19 09:35, Greg Kroah-Hartman wrote:
> > From: Ori Nimron <orinimron123@gmail.com>
> > 
> > When creating a raw AF_IEEE802154 socket, CAP_NET_RAW needs to be
> > checked first.
> > 
> > Signed-off-by: Ori Nimron <orinimron123@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/ieee802154/socket.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> > index badc5cfe4dc6..d93d4531aa9b 100644
> > --- a/net/ieee802154/socket.c
> > +++ b/net/ieee802154/socket.c
> > @@ -1008,6 +1008,9 @@ static int ieee802154_create(struct net *net, struct socket *sock,
> >  
> >  	switch (sock->type) {
> >  	case SOCK_RAW:
> > +		rc = -EPERM;
> > +		if (!capable(CAP_NET_RAW))
> > +			goto out;
> >  		proto = &ieee802154_raw_prot;
> >  		ops = &ieee802154_raw_ops;
> >  		break;
> > 
> 
> I assume this will go as a whole series into net. If you want me to pick
> it up into my tree directly let me know.
> 
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

That's up to the networking maintainer, if he does not suck it in, I'll
resend and ask you to take it.

thanks,

greg k-h
