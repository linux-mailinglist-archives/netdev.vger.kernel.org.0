Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00B4B4D5B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 14:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfIQMEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 08:04:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35224 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbfIQMEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 08:04:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 913D2205A6;
        Tue, 17 Sep 2019 14:04:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id p4YxxdqhAhOM; Tue, 17 Sep 2019 14:04:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2EE7620299;
        Tue, 17 Sep 2019 14:04:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 14:04:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BF61731803B6;
 Tue, 17 Sep 2019 14:04:13 +0200 (CEST)
Date:   Tue, 17 Sep 2019 14:04:13 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next v2 6/6] xfrm: add espintcp (RFC 8229)
Message-ID: <20190917120413.GF2879@gauss3.secunet.de>
References: <cover.1568192824.git.sd@queasysnail.net>
 <ce5eb26c12fa07e905b9d83ef8c07485c5516ffe.1568192824.git.sd@queasysnail.net>
 <20190917112649.GE2879@gauss3.secunet.de>
 <20190917115743.GA89567@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190917115743.GA89567@bistromath.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 01:57:43PM +0200, Sabrina Dubroca wrote:
> 2019-09-17, 13:26:49 +0200, Steffen Klassert wrote:
> > On Wed, Sep 11, 2019 at 04:13:07PM +0200, Sabrina Dubroca wrote:
> > ...
> > > diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> > > index 51bb6018f3bf..e67044527fb7 100644
> > > --- a/net/xfrm/Kconfig
> > > +++ b/net/xfrm/Kconfig
> > > @@ -73,6 +73,16 @@ config XFRM_IPCOMP
> > >  	select CRYPTO
> > >  	select CRYPTO_DEFLATE
> > >  
> > > +config XFRM_ESPINTCP
> > > +	bool "ESP in TCP encapsulation (RFC 8229)"
> > > +	depends on XFRM && INET_ESP
> > > +	select STREAM_PARSER
> > > +	select NET_SOCK_MSG
> > > +	help
> > > +	  Support for RFC 8229 encapsulation of ESP and IKE over TCP sockets.
> > > +
> > > +	  If unsure, say N.
> > > +
> > 
> > One nitpick: This is IPv4 only, so please move this below the ESP
> > section in net/ipv4/Kconfig and use the naming convention there.
> > I.e. bool "IP: ESP in TCP encapsulation (RFC 8229)"
> 
> That's temporary, though, the next step will be to make it work for
> both IPv4 and IPv6. Do you prefer I move it to net/ipv4/Kconfig for
> now, and then back to net/xfrm/Kconfig when I add IPv6 support?

We have separate config options for ESP4 and ESP6, so we should
also have separate config options for 'ESP in TCP' for IPv4 and IPv6.
So this should go to net/ipv4/Kconfig. When you add IPv6 support
place it in net/ipv6/Kconfig.
