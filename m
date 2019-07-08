Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1786462C9E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfGHXXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:23:31 -0400
Received: from fieldses.org ([173.255.197.46]:38168 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfGHXXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 19:23:31 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id D396E7CB; Mon,  8 Jul 2019 19:23:30 -0400 (EDT)
Date:   Mon, 8 Jul 2019 19:23:30 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sunrpc/cache: remove the exporting of cache_seq_next
Message-ID: <20190708232330.GA13464@fieldses.org>
References: <20190708161423.31006-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708161423.31006-1-efremov@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Makes sense, thanks; apply for 5.3.--b.

On Mon, Jul 08, 2019 at 07:14:23PM +0300, Denis Efremov wrote:
> The function cache_seq_next is declared static and marked
> EXPORT_SYMBOL_GPL, which is at best an odd combination. Because the
> function is not used outside of the net/sunrpc/cache.c file it is
> defined in, this commit removes the EXPORT_SYMBOL_GPL() marking.
> 
> Fixes: d48cf356a130 ("SUNRPC: Remove non-RCU protected lookup")
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  net/sunrpc/cache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
> index 66fbb9d2fba7..6f1528f271ee 100644
> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@ -1375,7 +1375,6 @@ static void *cache_seq_next(struct seq_file *m, void *p, loff_t *pos)
>  				hlist_first_rcu(&cd->hash_table[hash])),
>  				struct cache_head, cache_list);
>  }
> -EXPORT_SYMBOL_GPL(cache_seq_next);
>  
>  void *cache_seq_start_rcu(struct seq_file *m, loff_t *pos)
>  	__acquires(RCU)
> -- 
> 2.21.0
