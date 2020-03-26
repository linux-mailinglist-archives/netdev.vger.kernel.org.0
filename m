Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA3719492B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgCZU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:29:22 -0400
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:59896 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726363AbgCZU3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:29:22 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 5365518033D30;
        Thu, 26 Mar 2020 20:29:21 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2691:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6742:8985:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12438:12740:12895:13018:13019:13069:13071:13311:13357:13439:13894:14180:14181:14659:14721:21060:21080:21627:21788:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bells46_513c0c0a8540a
X-Filterd-Recvd-Size: 2293
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Thu, 26 Mar 2020 20:29:18 +0000 (UTC)
Message-ID: <bc4056226b76834aa3fc52cce2d96855afa2c440.camel@perches.com>
Subject: Re: [PATCH net-next 7/9] net: phy: enable qoriq backplane support
From:   Joe Perches <joe@perches.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     florinel.iordache@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, kuba@kernel.org, corbet@lwn.net,
        shawnguo@kernel.org, leoyang.li@nxp.com, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, linux-kernel@vger.kernel.org
Date:   Thu, 26 Mar 2020 13:27:26 -0700
In-Reply-To: <20200326201310.GB11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
         <1585230682-24417-8-git-send-email-florinel.iordache@nxp.com>
         <ba3b1a69496eb08cb071dace96fd385ff8f838e7.camel@perches.com>
         <20200326201310.GB11004@lunn.ch>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-26 at 21:13 +0100, Andrew Lunn wrote:
> > > +static int qoriq_backplane_config_init(struct phy_device *bpphy)
> > > +{
> > []
> > > +	for (i = 0; i < bp_phy->num_lanes; i++) {
> > []
> > > +		ret = of_address_to_resource(lane_node, 0, &res);
> > > +		if (ret) {
> > > +			bpdev_err(bpphy,
> > > +				  "could not obtain lane memory map for index=%d, ret = %d\n",
> > > +				  i, ret);
> > > +			return ret;
> > 
> > This could use the new vsprintf %pe extension:
> 
> Hi Joe

Hello Andrew.

> Probably a FAQ. But is there plans to extend vsprintf to take an int
> errno value, rather than having to do this ugly ERR_PTR(ret) every
> time? Format string %de ?

Uwe Kleine-König proposed one a couple times.

https://lkml.org/lkml/2019/8/27/1456

Though I believe one %<type><extra> extension mechanism
in vsprintf is enough.  At least the %p<foo> use is
unlikely to ever have desired but dropped output after
an output of %p.  It seems less true for %[diux].




