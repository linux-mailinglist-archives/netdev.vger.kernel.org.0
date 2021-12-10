Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D24446FC73
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbhLJIQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbhLJIQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:16:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F4C0617A1;
        Fri, 10 Dec 2021 00:12:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mvb0n-0003iA-9f; Fri, 10 Dec 2021 09:12:13 +0100
Date:   Fri, 10 Dec 2021 09:12:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     lizhe <sensor1010@163.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter/x_tables.c: Use kvalloc to make your code
 better
Message-ID: <20211210081213.GC26636@breakpoint.cc>
References: <20211210031244.13372-1-sensor1010@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210031244.13372-1-sensor1010@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lizhe <sensor1010@163.com> wrote:
> Use kvzalloc () instead of kvmalloc () and memset
> 
> Signed-off-by: lizhe <sensor1010@163.com>
> ---
>  net/netfilter/x_tables.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 25524e393349..8d6ffed7d526 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1189,11 +1189,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>  	if (sz < sizeof(*info) || sz >= XT_MAX_TABLE_SIZE)
>  		return NULL;
>  
> -	info = kvmalloc(sz, GFP_KERNEL_ACCOUNT);
> +	info = kvzalloc(sz, GFP_KERNEL_ACCOUNT);
>  	if (!info)
>  		return NULL;
>  
> -	memset(info, 0, sizeof(*info));

sz != sizeof(*info)
