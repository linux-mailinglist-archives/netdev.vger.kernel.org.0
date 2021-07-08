Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA793C1730
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhGHQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 12:43:42 -0400
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:42084 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229468AbhGHQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 12:43:41 -0400
Received: from omf10.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id EBABF1836B094;
        Thu,  8 Jul 2021 16:40:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf10.hostedemail.com (Postfix) with ESMTPA id 6FE7F2351FD;
        Thu,  8 Jul 2021 16:40:57 +0000 (UTC)
Message-ID: <03ad1f2319a608bbfe3fc09e901742455bf733a0.camel@perches.com>
Subject: Re: [PATCH] drivers: net: Follow the indentation coding standard on
 printks
From:   Joe Perches <joe@perches.com>
To:     Carlos Bilbao <bilbao@vt.edu>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Date:   Thu, 08 Jul 2021 09:40:56 -0700
In-Reply-To: <1884900.usQuhbGJ8B@iron-maiden>
References: <1884900.usQuhbGJ8B@iron-maiden>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.65
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 6FE7F2351FD
X-Stat-Signature: zngdy91cw3wz7ddhw6eyttrgy9u5sk6y
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19zv2tXbW5OqGgP2K6PyS/bo0LdRO0KyrM=
X-HE-Tag: 1625762457-507807
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-08 at 11:23 -0400, Carlos Bilbao wrote:
> Fix indentation of printks that start at the beginning of the line. Change this 
> for the right number of space characters, or tabs if the file uses them. 

The tulip and sb1000 code are from the 1990's.
Likely this doesn't need touching, but if you really want to:

> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
[]
> @@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
>  
> 
>      default:
>  	lp->tcount++;
> -printk("Huh?: media:%02x\n", lp->media);
> +	printk("Huh?: media:%02x\n", lp->media);

There should be a KERN_<LEVEL> here like KERN_WARNING/KERN_NOTICE

> diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
[]
> @@ -760,7 +760,7 @@ sb1000_rx(struct net_device *dev)
>  
> 
>  	insw(ioaddr, (unsigned short*) st, 1);
>  #ifdef XXXDEBUG
> -printk("cm0: received: %02x %02x\n", st[0], st[1]);
> +	printk("cm0: received: %02x %02x\n", st[0], st[1]);
>  #endif /* XXXDEBUG */

XXXDEBUG isn't defined anywhere so these could just be deleted.

> @@ -805,7 +805,7 @@ printk("cm0: received: %02x %02x\n", st[0], st[1]);
>  		/* get data length */
>  		insw(ioaddr, buffer, NewDatagramHeaderSize / 2);
>  #ifdef XXXDEBUG
> -printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
> +		printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
>  #endif /* XXXDEBUG */
>  		if (buffer[0] != NewDatagramHeaderSkip) {
>  			if (sb1000_debug > 1)


