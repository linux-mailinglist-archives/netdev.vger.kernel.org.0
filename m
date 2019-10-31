Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB86EAF2B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfJaLxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:53:39 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:47116 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbfJaLxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:53:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id D123D5DDB;
        Thu, 31 Oct 2019 11:53:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:4225:4321:5007:7576:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:30034:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: value36_76bb9bebfde10
X-Filterd-Recvd-Size: 2520
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 31 Oct 2019 11:53:35 +0000 (UTC)
Message-ID: <4541e77d257685c649f5f994e673a409a3634f50.camel@perches.com>
Subject: Re: [PATCH net-next 8/9] net: hns3: cleanup some print format
 warning
From:   Joe Perches <joe@perches.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        Guojia Liao <liaoguojia@huawei.com>
Date:   Thu, 31 Oct 2019 04:53:26 -0700
In-Reply-To: <1572521004-36126-9-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
         <1572521004-36126-9-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-31 at 19:23 +0800, Huazhong Tan wrote:
> From: Guojia Liao <liaoguojia@huawei.com>
> 
> Using '%d' for printing type unsigned int or '%u' for
> type int would cause static tools to give false warnings,
> so this patch cleanups this warning by using the suitable
> format specifier of the type of variable.
> 
> BTW, modifies the type of some variables and macro to
> synchronize with their usage.

What tool is this?

I think this static warning is excessive as macro
defines with a small positive number are common

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
[]
> @@ -72,7 +72,7 @@ enum hclge_mbx_vlan_cfg_subcode {
>  };
>  
>  #define HCLGE_MBX_MAX_MSG_SIZE	16
> -#define HCLGE_MBX_MAX_RESP_DATA_SIZE	8
> +#define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
>  #define HCLGE_MBX_RING_MAP_BASIC_MSG_NUM	3
>  #define HCLGE_MBX_RING_NODE_VARIABLE_NUM	3

like this one

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
[]
> @@ -57,68 +57,68 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
>  					   HNS3_RING_RX_RING_BASEADDR_H_REG);
>  		base_add_l = readl_relaxed(ring->tqp->io_base +
>  					   HNS3_RING_RX_RING_BASEADDR_L_REG);
> -		dev_info(&h->pdev->dev, "RX(%d) BASE ADD: 0x%08x%08x\n", i,
> +		dev_info(&h->pdev->dev, "RX(%u) BASE ADD: 0x%08x%08x\n", i,

so using %d is correct enough.


