Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66D1195D9F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0S10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:27:26 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:52816 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgC0S10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:27:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id DC564181D330D;
        Fri, 27 Mar 2020 18:27:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3872:4321:5007:6742:7901:10004:10394:10400:10848:11026:11473:11658:11914:12043:12297:12740:12760:12895:13069:13141:13230:13311:13357:13439:14181:14659:14721:21080:21451:21627:21789:30029:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: comb05_5cf10df77e138
X-Filterd-Recvd-Size: 1870
Received: from XPS-9350 (unknown [172.58.92.163])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Fri, 27 Mar 2020 18:27:18 +0000 (UTC)
Message-ID: <32d1dee7e9c7dd104cd7405a22fb5d5e3ef61303.camel@perches.com>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
From:   Joe Perches <joe@perches.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 11:25:26 -0700
In-Reply-To: <20200327142245.GF11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
         <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
         <20200327142245.GF11004@lunn.ch>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-03-27 at 15:22 +0100, Andrew Lunn wrote:
> > +/* Backplane custom logging */
> > +#define BPDEV_LOG(name) \
> > +	char log_buffer[LOG_BUFFER_SIZE]; \
> > +	va_list args; va_start(args, msg); \
> > +	vsnprintf(log_buffer, LOG_BUFFER_SIZE - 1, msg, args); \
> > +	if (!bpphy->attached_dev) \
> > +		dev_##name(&bpphy->mdio.dev, log_buffer); \
> > +	else \
> > +		dev_##name(&bpphy->mdio.dev, "%s: %s", \
> > +			netdev_name(bpphy->attached_dev), log_buffer); \
> > +	va_end(args)

This could also use %pV instead of an intermediate buffer.

It's also bad form to use macros with required
external variables.

