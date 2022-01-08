Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5877348823F
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 09:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiAHIES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 03:04:18 -0500
Received: from relay030.a.hostedemail.com ([64.99.140.30]:57053 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230219AbiAHIER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 03:04:17 -0500
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id 493D823181;
        Sat,  8 Jan 2022 08:04:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 99E388000D;
        Sat,  8 Jan 2022 08:03:59 +0000 (UTC)
Message-ID: <fc1bf93d92bb5b2f99c6c62745507cc22f3a7b2d.camel@perches.com>
Subject: Re: [PATCH net-next] net: lantiq_etop: add blank line after
 declaration
From:   Joe Perches <joe@perches.com>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        kuba@kernel.org, rdunlap@infradead.org, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>
Date:   Sat, 08 Jan 2022 00:04:08 -0800
In-Reply-To: <20211228220031.71576-1-olek2@wp.pl>
References: <20211228220031.71576-1-olek2@wp.pl>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.60
X-Stat-Signature: jbmtwnzfrtn1yhcpqs5gfknehu8nhf8x
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 99E388000D
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18x/hM6NRUFwWh5VLK7ICvHa/RluF2ZJgU=
X-HE-Tag: 1641629039-985905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding John Crispin, the original submitter of this driver)

On Tue, 2021-12-28 at 23:00 +0100, Aleksander Jan Bajkowski wrote:
> This patch adds a missing line after the declaration and
> fixes the checkpatch warning:
> 
> WARNING: Missing a blank line after declarations
> +		int desc;
> +		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
[]
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
[]
> @@ -218,6 +218,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
>  		free_irq(ch->dma.irq, priv);
>  	if (IS_RX(ch->idx)) {
>  		int desc;
> +
>  		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
>  			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
>  	}

The change is innocuous and has already been applied but the code
doesn't seem to make sense.

Why is dev_kfree_skb_any called multiple times with the same argument?

Is there some missing logic here?  Maybe a missing ++?

Something like:

		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc++]);

Dunno, but the current code seems wrong.


