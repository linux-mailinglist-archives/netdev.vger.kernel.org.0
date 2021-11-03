Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE64440EE
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhKCMB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:01:56 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:51424 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhKCMB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1635940759; x=1667476759;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7rdF4NdfNB9nxiTZiM3YjsgOLHGvGQpa/fbZZV96k8=;
  b=dePlM8oS9kt1NmE23GwypmsidyDDRyAlPhx624+C8oOi7aQFsLkxQh/5
   KmDv2jcUBftS+7MWq0nyBjryFcYE9uuM3z8+ETW3arXjCbApNhm3Lp6e7
   ZSElvRfYHUEj9HgY/bKwky0tOtNG2ZiEGIrprph8Sf9LBHh9yVrdwkNkR
   VRJRPEAoXSsqcdNnqdws3DsPz666senN9HGu6mrr++k5Pv5qH/hUu+qat
   cjVdn/hJ9o6Minv7XwMwwamcTzeJ/H1fKUwIXj1xrGkED5PYJR1LD0vzZ
   Q5p67OdvlkxwXf0u0J8R62G2NJ3kPsP0LhCeFCnIf1UQIbRBJAf3bSaHY
   A==;
X-IronPort-AV: E=Sophos;i="5.87,205,1631570400"; 
   d="scan'208";a="20323835"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 03 Nov 2021 12:59:18 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 03 Nov 2021 12:59:18 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 03 Nov 2021 12:59:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1635940758; x=1667476758;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7rdF4NdfNB9nxiTZiM3YjsgOLHGvGQpa/fbZZV96k8=;
  b=VMhEW0PbjUSijTyfA5hHgHblj+vJY2gJi330hKDhr55lyTAucPPOhxiP
   mdGpdbERikj6AZ8HdtEwXVIOfHZcvdYQtSYXTDQ2OuoyBGy5CZU44+i9h
   tqDzI73kmlofReVZzoiL3DGCgv7fhJtfsmFHtY0MbHaA3kEz53vew60IX
   VxlEOeFx0t4LT/vdPc0Zj5MOV7GaGAx/Vi9iGDW9Jfaau1t6CYlHhLYQE
   NwkT8Jn4ixLBcGWFBM7Ey6+lzzN8+1K2+RYcKcrDZu94niLVbzynxf7SX
   F3jAaOcy+OpmhApKEQEAq/pl8Xm6rtXcw/WZXp/e5q9ufWIPEd5j/255U
   g==;
X-IronPort-AV: E=Sophos;i="5.87,205,1631570400"; 
   d="scan'208";a="20323834"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 03 Nov 2021 12:59:18 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 9B22D280065;
        Wed,  3 Nov 2021 12:59:18 +0100 (CET)
Message-ID: <77c9849442e7e4a747aebd79747fd88c383c6b57.camel@ew.tq-group.com>
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is
 not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Nov 2021 12:59:16 +0100
In-Reply-To: <e8e0f07afbae8333c94c198a20a66a9448c32ce6.camel@ew.tq-group.com>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <YW7SWKiUy8LfvSkl@lunn.ch>
         <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
         <YXBk8gwuCqrxDbVY@lunn.ch>
         <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
         <YXFh/nLTqvCsLAXj@lunn.ch>
         <7a478c1f25d2ea96ff09cee77d648e9c63b97dcf.camel@ew.tq-group.com>
         <YXK1E9LLDCfajzmR@lunn.ch>
         <e8e0f07afbae8333c94c198a20a66a9448c32ce6.camel@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-10-26 at 13:54 +0200, Matthias Schiffer wrote:
> On Fri, 2021-10-22 at 14:56 +0200, Andrew Lunn wrote:
> > > Hmm, lots of network drivers? I tried to find an example, but all
> > > drivers that generate -EPROBE_DEFER for missing PHYs at all don't have
> > > an internal MDIO bus and thus avoid the circular dependency.
> > 
> > Try drivers/net/dsa.
> > 
> > These often have mdio busses which get registered and then
> > unregistered. There are also IRQ drivers which do the same.
> > 
> > 	Andrew
> 
> 
> All drivers I looked at were careful to register the MDIO bus in the
> last part of the probe function, so that the only errors that could 
> happen after that (and thus require to unregister the bus device again)
> would not be -EPROBE_DEFER.
> 
> The documented infinite loop is easy to reproduce: You just need two
> separate device instances with misbehaving probe() functions that
> return -EPROBE_DEFER after registering and unregistering some
> subdevice. If the missing device that causes the deferral never appears
> (for example because its driver is not available), the two devices will
> be probed ad infinitum.
> 
> I agree with the documentation that a driver should not do this, and
> thus we need another way to deal with the cyclic dependency between an
> Ethernet interface and a PHY on its internal MDIO bus.
> 
> While I think that a generic solution would be theoretically possible
> by ensuring that the probing loop makes some kind of "progress", I
> think this would set a precedent for "expensive" operations happening
> before a -EPROBE_DEFER return, which should be avoided even when no
> infinite loop results.
> 
> Matthias

Does anyone have a suggestion how to proceed with this issue?

