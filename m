Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B91522631C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGTPT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:19:58 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:35042 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725815AbgGTPT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:19:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5B7E11847A0C0;
        Mon, 20 Jul 2020 15:19:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2693:2828:2902:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4250:4321:5007:6119:6742:7576:7903:10004:10400:10848:10967:11026:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21067:21080:21433:21451:21627:21740:21939:30034:30054:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: wound04_440fc9526f25
X-Filterd-Recvd-Size: 2452
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon, 20 Jul 2020 15:19:54 +0000 (UTC)
Message-ID: <de4b0ef6b1b7b58acc184d1d7e80456f6c3b56c0.camel@perches.com>
Subject: Re: [PATCH v2 net-next 01/14] qed: convert link mode from u32 to
 bitmap
From:   Joe Perches <joe@perches.com>
To:     Alexander Lobakin <alobakin@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2@marvell.com,
        QLogic-Storage-Upstream@marvell.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 20 Jul 2020 08:19:52 -0700
In-Reply-To: <20200720092306.355-1-alobakin@marvell.com>
References: <20200719212100.GM1383417@lunn.ch>
         <20200719201453.3648-1-alobakin@marvell.com>
         <20200719201453.3648-2-alobakin@marvell.com>
         <20200720092306.355-1-alobakin@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-20 at 12:23 +0300, Alexander Lobakin wrote:
> Date: Sun, 19 Jul 2020 23:21:00 +0200 From: Andrew Lunn <andrew@lunn.ch>
> > On Sun, Jul 19, 2020 at 11:14:40PM +0300, Alexander Lobakin wrote:
> > > Currently qed driver already ran out of 32 bits to store link modes,
> > > and this doesn't allow to add and support more speeds.
> > > Convert link mode to bitmap that will always have enough space for
> > > any number of speeds and modes.
[]
> > Why not just throw away all these QED_LM_ defines and use the kernel
> > link modes? The fact you are changing the u32 to a bitmap suggests the
> > hardware does not use them.
> 
> I've just double-checked, and you're right, management firmware operates
> with NVM_* definitions, while QED_LM_* are used only in QED and QEDE to
> fill Ethtool link settings.
> I didn't notice this while working on the series, but it would be really
> a lot better to just use generic definitions.
> So I'll send v3 soon.

While you're at it, why are you using __set_bit and not set_bit?


