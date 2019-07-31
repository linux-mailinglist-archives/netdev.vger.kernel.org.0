Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2447C0FC
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGaMRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:17:22 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39530 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfGaMRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 08:17:22 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hsnXd-00026K-St; Wed, 31 Jul 2019 08:17:16 -0400
Date:   Wed, 31 Jul 2019 08:16:46 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Joe Perches <joe@perches.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-ID: <20190731121646.GD9823@hmswarspite.think-freely.org>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
 <20190731111932.GA9823@hmswarspite.think-freely.org>
 <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
> On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> > > fallthrough may become a pseudo reserved keyword so this only use of
> > > fallthrough is better renamed to allow it.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > Are you referring to the __attribute__((fallthrough)) statement that gcc
> > supports?  If so the compiler should by all rights be able to differentiate
> > between a null statement attribute and a explicit goto and label without the
> > need for renaming here.  Or are you referring to something else?
> 
> Hi.
> 
> I sent after this a patch that adds
> 
> # define fallthrough                    __attribute__((__fallthrough__))
> 
> https://lore.kernel.org/patchwork/patch/1108577/
> 
> So this rename is a prerequisite to adding this #define.
> 
why not just define __fallthrough instead, like we do for all the other
attributes we alias (i.e. __read_mostly, __protected_by, __unused, __exception,
etc)

Neil

> > > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> []
> > > @@ -2152,7 +2152,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
> > >  	case SCTP_PARAM_SET_PRIMARY:
> > >  		if (net->sctp.addip_enable)
> > >  			break;
> > > -		goto fallthrough;
> > > +		goto unhandled;
> 
> etc...
> 
> 
> 
