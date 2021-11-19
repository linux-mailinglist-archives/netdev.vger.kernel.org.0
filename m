Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4F456CE3
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhKSKC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:02:26 -0500
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:57114 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229974AbhKSKC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 05:02:26 -0500
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id D737A182CED2A;
        Fri, 19 Nov 2021 09:59:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id AA7FBE0000B0;
        Fri, 19 Nov 2021 09:59:22 +0000 (UTC)
Message-ID: <72bc86af11bddf9226ed13978ef8d03fec51250c.camel@perches.com>
Subject: Re: [PATCH] net/core: remove useless type conversion to bool
From:   Joe Perches <joe@perches.com>
To:     Bernard Zhao <bernard@vivo.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Nov 2021 01:59:21 -0800
In-Reply-To: <20211119015421.108124-1-bernard@vivo.com>
References: <20211119015421.108124-1-bernard@vivo.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.62
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: AA7FBE0000B0
X-Stat-Signature: 9np1e8diwcuuafyca9kkrdj5tj4166g4
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+NQr1PVc1bOCB02F/3Wp9T1g/dhcLIZQU=
X-HE-Tag: 1637315962-971474
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-18 at 17:54 -0800, Bernard Zhao wrote:
> (ret == 0) is bool value, the type conversion to true/false value
> is not needed.
[]
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
[]
> @@ -398,7 +398,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
>  	else
>  		ret = ptr_ring_produce_bh(&pool->ring, page);
>  
> -	return (ret == 0) ? true : false;
> +	return (ret == 0);

This doesn't need the parentheses either.

Maybe:
	return !ret;
or
	return ret == 0;
?


