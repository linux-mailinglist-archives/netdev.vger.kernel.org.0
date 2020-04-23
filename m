Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAFF1B5700
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDWIOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 04:14:44 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:47392 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWIOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:14:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id F3D221801A88C;
        Thu, 23 Apr 2020 08:14:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3874:4250:4321:5007:6119:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12555:12740:12760:12895:12986:13019:13069:13095:13311:13357:13439:14181:14659:14721:21080:21212:21433:21451:21627:21660:21990:30054:30055:30056:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: foot95_6332a6b883714
X-Filterd-Recvd-Size: 2131
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu, 23 Apr 2020 08:14:41 +0000 (UTC)
Message-ID: <39759644335be80aa259f20f7cfc6108bd9de363.camel@perches.com>
Subject: Re: [PATCH] ipw2x00: Remove a memory allocation failure log message
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Thu, 23 Apr 2020 01:12:24 -0700
In-Reply-To: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
References: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-23 at 09:58 +0200, Christophe JAILLET wrote:
> Axe a memory allocation failure log message. This message is useless and
> incorrect (vmalloc is not used here for the memory allocation)
> 
> This has been like that since the very beginning of this driver in
> commit 43f66a6ce8da ("Add ipw2200 wireless driver.")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index 60b5e08dd6df..30c4f041f565 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
>  	struct pci_dev *dev = priv->pci_dev;
>  
>  	q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
> -	if (!q->txb) {
> -		IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
> +	if (!q->txb)
>  		return -ENOMEM;
> -	}
> +

This might avoid possible defects by using kcalloc instead too



