Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A738621FD3C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgGNTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:22:11 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:34252 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727930AbgGNTWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:22:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 0685B181D337B;
        Tue, 14 Jul 2020 19:22:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6691:7514:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12438:12555:12663:12740:12760:12895:12986:13439:14181:14659:14721:21080:21324:21451:21627:30054:30055:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: turn41_0b16cbc26ef3
X-Filterd-Recvd-Size: 4228
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 14 Jul 2020 19:22:06 +0000 (UTC)
Message-ID: <ce637b26b496dd99be8f272e6ec82333338321dc.camel@perches.com>
Subject: Re: [PATCH 6/6] staging: qlge: qlge_ethtool: Remove one byte memset.
From:   Joe Perches <joe@perches.com>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 14 Jul 2020 12:22:05 -0700
In-Reply-To: <20200714190602.GA14742@blackclown>
References: <cover.1594642213.git.usuraj35@gmail.com>
         <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
         <20200713141749.GU2549@kadam>
         <a323c1e47e8de871ff7bb72289740cb0bc2d27f8.camel@perches.com>
         <20200714190602.GA14742@blackclown>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 00:36 +0530, Suraj Upadhyay wrote:
> On Tue, Jul 14, 2020 at 11:57:23AM -0700, Joe Perches wrote:
> > On Mon, 2020-07-13 at 17:17 +0300, Dan Carpenter wrote:
> > > On Mon, Jul 13, 2020 at 05:52:22PM +0530, Suraj Upadhyay wrote:
> > > > Use direct assignment instead of using memset with just one byte as an
> > > > argument.
> > > > Issue found by checkpatch.pl.
> > > > 
> > > > Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> > > > ---
> > > > Hii Maintainers,
> > > > 	Please correct me if I am wrong here.
> > > > ---
> > > > 
> > > >  drivers/staging/qlge/qlge_ethtool.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
> > > > index 16fcdefa9687..d44b2dae9213 100644
> > > > --- a/drivers/staging/qlge/qlge_ethtool.c
> > > > +++ b/drivers/staging/qlge/qlge_ethtool.c
> > > > @@ -516,8 +516,8 @@ static void ql_create_lb_frame(struct sk_buff *skb,
> > > >  	memset(skb->data, 0xFF, frame_size);
> > > >  	frame_size &= ~1;
> > > >  	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
> > > > -	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > > > -	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> > > > +	skb->data[frame_size / 2 + 10] = (unsigned char)0xBE;
> > > > +	skb->data[frame_size / 2 + 12] = (unsigned char)0xAF;
> > > 
> > > Remove the casting.
> > > 
> > > I guess this is better than the original because now it looks like
> > > ql_check_lb_frame().  It's still really weird looking though.
> > 
> > There are several of these in the intel drivers too:
> > 
> > drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> > drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> > drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[frame_size + 10], 0xBE, 1);
> > drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[frame_size + 12], 0xAF, 1);
> > drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->data[frame_size + 10], 0xBE, 1);
> > drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->data[frame_size + 12], 0xAF, 1);
> > drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> 
> Thanks to point this out,
> 	I will be sending a patchset for that soon.


It _might_ be useful to create and use a standard
mechanism for the loopback functions:

	<foo>create_lbtest_frame
and
	<foo>check_lbtest_frame

Maybe use something like:

	ether_loopback_frame_create
and
	ether_loopback_frame_check


