Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853C84FCAD
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfFWQ0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 12:26:30 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:59793 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726612AbfFWQ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 12:26:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 1B447100E86C0;
        Sun, 23 Jun 2019 16:26:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:560:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:7576:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12297:12438:12555:12663:12740:12760:12895:13069:13311:13357:13439:14096:14097:14180:14181:14659:14721:21080:21324:21451:21627:30034:30054:30075:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: wire66_1b61c99b2863e
X-Filterd-Recvd-Size: 2367
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Sun, 23 Jun 2019 16:26:28 +0000 (UTC)
Message-ID: <76a3c9ed832dd1183a5c38bf5e581a4b080d06c0.camel@perches.com>
Subject: Re: [PATCH] sis900: increment revision number
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, venza@brownhat.org
Cc:     sergej.benilov@googlemail.com, netdev@vger.kernel.org
Date:   Sun, 23 Jun 2019 09:26:26 -0700
In-Reply-To: <20190623.083724.172652862205625872.davem@davemloft.net>
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
         <8eb161f4757cc55d7138bf5d30014e8fb8e38a0d.camel@perches.com>
         <7038d64e-0d3c-6b13-04fd-b614efbf5162@brownhat.org>
         <20190623.083724.172652862205625872.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-23 at 08:37 -0700, David Miller wrote:
> From: Daniele Venzano <venza@brownhat.org>
> Date: Sun, 23 Jun 2019 11:13:28 +0200
> 
> > Hello,
> > 
> > I think it is good to know just by looking at the sources that the
> > driver is still kept up-to-date, so I am in favor of this patch.
> 
> I absolutely, strongly, disagree.
> 
> These are pointless.

Perhaps (most)? all the .get_drvinfo function calls where the
driver version is returned should use the default release.

This is similar to net/wireless/ethtool.c

Maybe:
---
 net/core/ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4d1011b2e24f..644a2043714c 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -23,6 +23,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/sched/signal.h>
 #include <linux/net.h>
+#include <linux/utsname.h>
 #include <net/devlink.h>
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
@@ -806,6 +807,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 		devlink_compat_running_version(dev, info.fw_version,
 					       sizeof(info.fw_version));
 
+	strlcpy(info.version, init_utsname()->release, sizeof(info.version));
+
 	if (copy_to_user(useraddr, &info, sizeof(info)))
 		return -EFAULT;
 	return 0;


