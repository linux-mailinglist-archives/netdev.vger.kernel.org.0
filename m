Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8D304B1D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbhAZEty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:49:54 -0500
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:51872 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbhAYJZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:25:15 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 02DE91801EC45;
        Mon, 25 Jan 2021 09:24:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:4321:4605:5007:6117:7576:7652:7903:10004:10234:10400:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12740:12895:13069:13311:13357:13439:13894:14181:14659:14721:21080:21212:21433:21611:21627:30046:30054:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: owner83_3a15a9227584
X-Filterd-Recvd-Size: 2076
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 25 Jan 2021 09:24:16 +0000 (UTC)
Message-ID: <6cad823891a9bb8aa5e9bc8712896898f9747fcd.camel@perches.com>
Subject: Re: [PATCH net-next 07/15] bnxt_en: log firmware debug notifications
From:   Joe Perches <joe@perches.com>
To:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Date:   Mon, 25 Jan 2021 01:24:15 -0800
In-Reply-To: <1611558501-11022-8-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
         <1611558501-11022-8-git-send-email-michael.chan@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-25 at 02:08 -0500, Michael Chan wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> Firmware is capable of generating asynchronous debug notifications.
> The event data is opaque to the driver and is simply logged. Debug
> notifications can be enabled by turning on hardware status messages
> using the ethtool msglvl interface.
[]
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
[]
> @@ -2072,6 +2073,13 @@ static int bnxt_async_event_process(struct bnxt *bp,
>  			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
>  		goto async_event_process_exit;
>  	}
> +	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
> +		if (netif_msg_hw(bp)) {
> +			netdev_notice(bp->dev,
> +				      "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
> +				      data1, data2);
> +		}

		netif_notice(bp, hw, bp->dev,
			     "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
			     data1, data2);

> +		goto async_event_process_exit;

>  	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
>  		struct bnxt_rx_ring_info *rxr;
>  		u16 grp_idx;


