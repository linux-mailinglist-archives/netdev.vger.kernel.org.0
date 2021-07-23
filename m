Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A853D3471
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhGWF2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:28:47 -0400
Received: from verein.lst.de ([213.95.11.211]:37126 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhGWF2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:28:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CBA9367373; Fri, 23 Jul 2021 08:09:17 +0200 (CEST)
Date:   Fri, 23 Jul 2021 08:09:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com
Subject: Re: [PATCH v5 net-next 23/36] net: Add to ulp_ddp support for
 fallback flow
Message-ID: <20210723060917.GB32369@lst.de>
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-24-borisp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110325.371-24-borisp@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:03:12PM +0300, Boris Pismenny wrote:
>  	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
>  	void (*ddp_teardown_done)(void *ddp_ctx);
> +	/* NIC request ulp to calculate the ddgst and store it in pdu_info->ddgst */
> +	void (*ddp_ddgst_fallback)(struct ulp_ddp_pdu_info *pdu_info);

Overly long line.  More importantly this whole struct should probably
use a kerneldoc comment anyway.

>  } EXPORT_SYMBOL(ulp_ddp_get_pdu_info);

> +	if (!pdu_info || !between(seq, pdu_info->start_seq, pdu_info->end_seq - 1)) {

More overly lone lines.  Please make sure to stick to 80 character lines
unless you have a really good to go over that.

> +	//check if this skb contains ddgst field

Plase avoid //-style comments.

> +	return ulp_ddp_fallback_skb(ctx, skb, sk);
> +} EXPORT_SYMBOL(ulp_ddp_validate_xmit_skb);

This is not how EXPORT_SYMBOLs are place.  Also please export any
such deep internal interfaces using EXPORT_SYMBOL_GPL.
