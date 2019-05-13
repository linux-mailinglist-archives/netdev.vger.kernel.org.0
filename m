Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09601B5AF
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfEMMSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:18:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57826 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfEMMSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 08:18:11 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 58D1D25AD63;
        Mon, 13 May 2019 22:18:09 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 37659E22B88; Mon, 13 May 2019 14:18:07 +0200 (CEST)
Date:   Mon, 13 May 2019 14:18:07 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, wsa@the-dreams.de, magnus.damm@gmail.com
Subject: Re: [PATCH] ravb: implement MTU change while device is up
Message-ID: <20190513121807.cutayiact3qdbxt4@verge.net.au>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
 <434070244.1141414.1557385064484@webmail.strato.com>
 <20190509101020.4ozvazptoy53gh55@verge.net.au>
 <344020243.1186987.1557415941124@webmail.strato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <344020243.1186987.1557415941124@webmail.strato.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 05:32:21PM +0200, Ulrich Hecht wrote:
> 
> > On May 9, 2019 at 12:10 PM Simon Horman <horms@verge.net.au> wrote:
> > 
> > 
> > On Thu, May 09, 2019 at 08:57:44AM +0200, Ulrich Hecht wrote:
> > > 
> > > > On May 8, 2019 at 6:52 PM Niklas Söderlund <niklas.soderlund@ragnatech.se> wrote:
> > > > 
> > > > 
> > > > Hi Sergei,
> > > > 
> > > > On 2019-05-08 18:59:01 +0300, Sergei Shtylyov wrote:
> > > > > Hello!
> > > > > 
> > > > > On 05/08/2019 06:21 PM, Ulrich Hecht wrote:
> > > > > 
> > > > > > Uses the same method as various other drivers: shut the device down,
> > > > > > change the MTU, then bring it back up again.
> > > > > > 
> > > > > > Tested on Renesas D3 Draak board.
> > > > > > 
> > > > > > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> > > > > 
> > > > >    You should have CC'ed me (as an reviewer for the Renesas drivers).
> > > 
> > > Sorry, will do next time.
> > > 
> > > > > 
> > > > >    How about the code below instead?
> > > > > 
> > > > > 	if (netif_running(ndev))
> > > > > 		ravb_close(ndev);
> > > > > 
> > > > >  	ndev->mtu = new_mtu;
> > > > > 	netdev_update_features(ndev);
> > > > 
> > > > Is there a need to call netdev_update_features() even if the if is not 
> > > > running?
> > > 
> > > In my testing, it didn't seem so.
> > 
> > That may be because your testing doesn't cover cases where it would make
> > any difference.
> 
> Cases other than changing the MTU while the device is up?

I was thinking of cases where listeners are registered for the
notifier that netdev_update_features() triggers.
