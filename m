Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA3177630
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 05:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfG0DOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 23:14:34 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:58931 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbfG0DOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 23:14:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id A8E15182CED2A;
        Sat, 27 Jul 2019 03:14:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:4321:4605:5007:6119:7576:7903:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12740:12760:12895:13069:13163:13229:13255:13311:13357:13439:14180:14181:14659:14721:21060:21080:21212:21433:21451:21627:30012:30054:30062:30090:30091,0,RBL:23.242.70.174:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: crush31_276c62a312e60
X-Filterd-Recvd-Size: 3010
Received: from XPS-9350 (cpe-23-242-70-174.socal.res.rr.com [23.242.70.174])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 27 Jul 2019 03:14:30 +0000 (UTC)
Message-ID: <d594eab0036305be337c25add9c0bde965ef1213.camel@perches.com>
Subject: Re: [PATCH V2 net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
From:   Joe Perches <joe@perches.com>
To:     liuyonglong <liuyonglong@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 26 Jul 2019 20:14:29 -0700
In-Reply-To: <f517dc69-6356-98fe-fb7a-0427728814bb@huawei.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
         <1564111502-15504-8-git-send-email-tanhuazhong@huawei.com>
         <a32ca755bfd69046cf89aeacbf67fd16313de768.camel@mellanox.com>
         <05602c954c689ffcd796e9468c52bca6fa4efe3f.camel@perches.com>
         <f517dc69-6356-98fe-fb7a-0427728814bb@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-07-27 at 10:28 +0800, liuyonglong wrote:
> On 2019/7/27 6:18, Joe Perches wrote:
> > On Fri, 2019-07-26 at 22:00 +0000, Saeed Mahameed wrote:
> > > On Fri, 2019-07-26 at 11:24 +0800, Huazhong Tan wrote:
> > > > From: Yonglong Liu <liuyonglong@huawei.com>
> > > > 
> > > > Some times just see the eth interface have been down/up via
> > > > dmesg, but can not know why the eth down. So adds some debug
> > > > messages to identify the cause for this.
> > []
> > > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > > []
> > > > @@ -459,6 +459,10 @@ static int hns3_nic_net_open(struct net_device
> > > > *netdev)
> > > >  		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
> > > >  
> > > >  	hns3_config_xps(priv);
> > > > +
> > > > +	if (netif_msg_drv(h))
> > > > +		netdev_info(netdev, "net open\n");
> > > > +
> > > 
> > > to make sure this is only intended for debug, and to avoid repetition.
> > > #define hns3_dbg(__dev, format, args...)			\
> > > ({								\
> > > 	if (netif_msg_drv(h))					\
> > > 		netdev_info(h->netdev, format, ##args);         \
> > > })
> > 
> > 	netif_dbg(h, drv, h->netdev, "net open\n")
> > 
> 
> Hi, Saeed && Joe:
> For our cases, maybe netif_info() can be use for HNS3 drivers?
> netif_dbg need to open dynamic debug options additional.

Your code, your choice.

I do think littering dmesg with "net open" style messages
and such may be unnecessary.  KERN_DEBUG seems a more
appropriate log level.


