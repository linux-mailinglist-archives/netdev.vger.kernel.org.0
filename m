Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A54773E9
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfGZWTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:19:04 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:54963 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbfGZWTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:19:03 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 3D0EC182251B2;
        Fri, 26 Jul 2019 22:19:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:4321:4605:5007:6119:7576:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21212:21433:21451:21627:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: pail14_4e54f40abf635
X-Filterd-Recvd-Size: 2393
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jul 2019 22:18:58 +0000 (UTC)
Message-ID: <05602c954c689ffcd796e9468c52bca6fa4efe3f.camel@perches.com>
Subject: Re: [PATCH V2 net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
From:   Joe Perches <joe@perches.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>
Date:   Fri, 26 Jul 2019 15:18:57 -0700
In-Reply-To: <a32ca755bfd69046cf89aeacbf67fd16313de768.camel@mellanox.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
         <1564111502-15504-8-git-send-email-tanhuazhong@huawei.com>
         <a32ca755bfd69046cf89aeacbf67fd16313de768.camel@mellanox.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-07-26 at 22:00 +0000, Saeed Mahameed wrote:
> On Fri, 2019-07-26 at 11:24 +0800, Huazhong Tan wrote:
> > From: Yonglong Liu <liuyonglong@huawei.com>
> > 
> > Some times just see the eth interface have been down/up via
> > dmesg, but can not know why the eth down. So adds some debug
> > messages to identify the cause for this.
[]
> > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> []
> > @@ -459,6 +459,10 @@ static int hns3_nic_net_open(struct net_device
> > *netdev)
> >  		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
> >  
> >  	hns3_config_xps(priv);
> > +
> > +	if (netif_msg_drv(h))
> > +		netdev_info(netdev, "net open\n");
> > +
> 
> to make sure this is only intended for debug, and to avoid repetition.
> #define hns3_dbg(__dev, format, args...)			\
> ({								\
> 	if (netif_msg_drv(h))					\
> 		netdev_info(h->netdev, format, ##args);         \
> })

	netif_dbg(h, drv, h->netdev, "net open\n")


