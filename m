Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DDA1F43D2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbgFIR5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:57:12 -0400
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:39502 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387532AbgFIR4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:56:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D3A118019465;
        Tue,  9 Jun 2020 17:56:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1461:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6691:7903:8526:10004:10400:10450:10455:10462:10464:10466:11026:11232:11473:11658:11914:12043:12296:12297:12740:12760:12895:13095:13161:13229:13255:13439:14096:14097:14659:14721:19904:19999:21080:21433:21451:21627:21740:21789:21939:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cover14_010615726dc4
X-Filterd-Recvd-Size: 4084
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 17:56:31 +0000 (UTC)
Message-ID: <2b291c34e10b3b3d9d6e01f8201ec0942e39575f.camel@perches.com>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
From:   Joe Perches <joe@perches.com>
To:     Edward Cree <ecree@solarflare.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
Date:   Tue, 09 Jun 2020 10:56:19 -0700
In-Reply-To: <727b31a0-543b-3dc5-aa91-0d78dc77df9c@solarflare.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-2-stanimir.varbanov@linaro.org>
         <20200609111615.GD780233@kroah.com>
         <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
         <727b31a0-543b-3dc5-aa91-0d78dc77df9c@solarflare.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-09 at 18:42 +0100, Edward Cree wrote:
> On 09/06/2020 17:58, Joe Perches wrote:
> > On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> > > What is wrong with the existing control of dynamic
> > > debug messages that you want to add another type of arbitrary grouping
> > > to it? 
> > There is no existing grouping mechanism.
> > 
> > Many drivers and some subsystems used an internal one
> > before dynamic debug.
> > 
> > $ git grep "MODULE_PARM.*\bdebug\b"|wc -l
> > 501
> > 
> > This is an attempt to unify those homebrew mechanisms.
> In network drivers, this is probablyusing the existing groupings
>  defined by netif_level() - see NETIF_MSG_DRV and friends.  Note
>  that those groups are orthogonal to the level, i.e. they control
>  netif_err() etc. as well, not just debug messages.

These are _not_ netif_<level> control flags.  Some are though.

For instance:

$ git grep "MODULE_PARM.*\bdebug\b" drivers/net | head -10
drivers/net/ethernet/3com/3c509.c:MODULE_PARM_DESC(debug, "debug level (0-6)");
drivers/net/ethernet/3com/3c515.c:MODULE_PARM_DESC(debug, "3c515 debug level (0-6)");
drivers/net/ethernet/3com/3c59x.c:MODULE_PARM_DESC(debug, "3c59x debug level (0-6)");
drivers/net/ethernet/adaptec/starfire.c:MODULE_PARM_DESC(debug, "Debug level (0-6)");
drivers/net/ethernet/allwinner/sun4i-emac.c:MODULE_PARM_DESC(debug, "debug message flags");
drivers/net/ethernet/altera/altera_tse_main.c:MODULE_PARM_DESC(debug, "Message Level (-1: default, 0: no output, 16: all)");
drivers/net/ethernet/amazon/ena/ena_netdev.c:MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
drivers/net/ethernet/amd/atarilance.c:MODULE_PARM_DESC(lance_debug, "atarilance debug level (0-3)");
drivers/net/ethernet/amd/lance.c:MODULE_PARM_DESC(lance_debug, "LANCE/PCnet debug level (0-7)");
drivers/net/ethernet/amd/pcnet32.c:MODULE_PARM_DESC(debug, DRV_NAME " debug level");

These are all level/class output controls.

> Certainly in the case of sfc, and I'd imagine for many other net
>  drivers too, the 'debug' modparam is setting the default for
>  net_dev->msg_enable, which can be changed after probe with
>  ethtool.

True.

> It doesn't look like the proposed mechanism subsumes that (we have
>  rather more than 5 groups, and it's not clear how you'd connect
>  it to the existing msg_enable (which uapi must be maintained); if
>  you don't have a way to do this, better exclude drivers/net/ from
>  your grep|wc because you won't be unifying those - in my tree
>  that's 119 hits.

Likely not.

I agree it'd be useful to attach the modparam control flag
to the dynamic debug use somehow.

cheers, Joe

