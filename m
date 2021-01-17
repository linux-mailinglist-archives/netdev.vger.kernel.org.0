Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA562F948B
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 19:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbhAQS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 13:27:47 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:33818 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726295AbhAQS1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 13:27:45 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 595F81800CA7D;
        Sun, 17 Jan 2021 18:27:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3870:3871:3873:4250:4321:5007:7576:7652:9036:10004:10400:10848:11232:11658:11783:11914:12043:12048:12296:12297:12438:12555:12740:12895:12986:13069:13311:13357:13894:13972:14181:14659:14721:21060:21080:21324:21365:21433:21451:21627:30029:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:15,LUA_SUMMARY:none
X-HE-Tag: goat17_180d3b827542
X-Filterd-Recvd-Size: 2401
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sun, 17 Jan 2021 18:27:02 +0000 (UTC)
Message-ID: <9fd72be8e628dba40fa83aeef65d80877ede86ca.camel@perches.com>
Subject: Re: [PATCH] arcnet: fix macro name when DEBUG is defined
From:   Joe Perches <joe@perches.com>
To:     trix@redhat.com, m.grzeschik@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 17 Jan 2021 10:27:01 -0800
In-Reply-To: <20210117181519.527625-1-trix@redhat.com>
References: <20210117181519.527625-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-01-17 at 10:15 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> When DEBUG is defined this error occurs
> 
> drivers/net/arcnet/com20020_cs.c:70:15: error: ‘com20020_REG_W_ADDR_HI’
>   undeclared (first use in this function);
>   did you mean ‘COM20020_REG_W_ADDR_HI’?
>        ioaddr, com20020_REG_W_ADDR_HI);
>                ^~~~~~~~~~~~~~~~~~~~~~
> 
> From reviewing the context, the suggestion is what is meant.
> 
> Fixes: 0fec65130b9f ("arcnet: com20020: Use arcnet_<I/O> routines")

Nice find thanks, especially seeing as how this hasn't been tested or
compiled in 5+ years...

	commit 0fec65130b9f11a73d74f47025491f97f82ba070
	Author: Joe Perches <joe@perches.com>
	Date:   Tue May 5 10:06:06 2015 -0700

Acked-by: Joe Perches <joe@perches.com>

> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/arcnet/com20020_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
> index cf607ffcf358..81223f6bebcc 100644
> --- a/drivers/net/arcnet/com20020_cs.c
> +++ b/drivers/net/arcnet/com20020_cs.c
> @@ -67,7 +67,7 @@ static void regdump(struct net_device *dev)
>  	/* set up the address register */
>  	count = 0;
>  	arcnet_outb((count >> 8) | RDDATAflag | AUTOINCflag,
> -		    ioaddr, com20020_REG_W_ADDR_HI);
> +		    ioaddr, COM20020_REG_W_ADDR_HI);
>  	arcnet_outb(count & 0xff, ioaddr, COM20020_REG_W_ADDR_LO);
>  
> 
>  	for (count = 0; count < 256 + 32; count++) {


