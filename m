Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1926355
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfEVL7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 07:59:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42478 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfEVL7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 07:59:21 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id D5F9D25AD5F;
        Wed, 22 May 2019 21:59:18 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id DBE9194053F; Wed, 22 May 2019 13:59:16 +0200 (CEST)
Date:   Wed, 22 May 2019 13:59:16 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     Ulrich Hecht <uli@fpond.eu>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, magnus.damm@gmail.com
Subject: Re: [PATCH] ravb: implement MTU change while device is up
Message-ID: <20190522115916.vlnbna2vxnf7zhod@verge.net.au>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
 <434070244.1141414.1557385064484@webmail.strato.com>
 <20190509101020.4ozvazptoy53gh55@verge.net.au>
 <344020243.1186987.1557415941124@webmail.strato.com>
 <20190513121807.cutayiact3qdbxt4@verge.net.au>
 <20190520120954.ffz2ius5nvojkxlh@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520120954.ffz2ius5nvojkxlh@katana>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 02:09:54PM +0200, Wolfram Sang wrote:
> 
> > > > > > >    How about the code below instead?
> > > > > > > 
> > > > > > > 	if (netif_running(ndev))
> > > > > > > 		ravb_close(ndev);
> > > > > > > 
> > > > > > >  	ndev->mtu = new_mtu;
> > > > > > > 	netdev_update_features(ndev);
> > > > > > 
> > > > > > Is there a need to call netdev_update_features() even if the if is not 
> > > > > > running?
> > > > > 
> > > > > In my testing, it didn't seem so.
> > > > 
> > > > That may be because your testing doesn't cover cases where it would make
> > > > any difference.
> > > 
> > > Cases other than changing the MTU while the device is up?
> > 
> > I was thinking of cases where listeners are registered for the
> > notifier that netdev_update_features() triggers.
> 
> Where are we here? Is this a blocker?

I don't think this is a blocker but I would lean towards leaving
netdev_update_features() in unless we are certain its not needed.

