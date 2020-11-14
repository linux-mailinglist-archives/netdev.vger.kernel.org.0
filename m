Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6C2B2BE4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 08:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKNHEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 02:04:02 -0500
Received: from namei.org ([65.99.196.166]:53158 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgKNHEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 02:04:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 0AE73uCd023314;
        Sat, 14 Nov 2020 07:03:56 GMT
Date:   Sat, 14 Nov 2020 18:03:56 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Paul Moore <paul@paul-moore.com>
cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH] netlabel: fix an uninitialized warning in
 netlbl_unlabel_staticlist()
In-Reply-To: <160530304068.15651.18355773009751195447.stgit@sifl>
Message-ID: <alpine.LRH.2.21.2011141803490.23236@namei.org>
References: <160530304068.15651.18355773009751195447.stgit@sifl>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020, Paul Moore wrote:

> Static checking revealed that a previous fix to
> netlbl_unlabel_staticlist() leaves a stack variable uninitialized,
> this patches fixes that.
> 
> Fixes: 866358ec331f ("netlabel: fix our progress tracking in netlbl_unlabel_staticlist()")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>


Reviewed-by: James Morris <jamorris@linux.microsoft.com>

> ---
>  net/netlabel/netlabel_unlabeled.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index fc55c9116da0..ccb491642811 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -1167,7 +1167,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
>  	u32 skip_bkt = cb->args[0];
>  	u32 skip_chain = cb->args[1];
>  	u32 skip_addr4 = cb->args[2];
> -	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
> +	u32 iter_bkt, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
>  	struct netlbl_unlhsh_iface *iface;
>  	struct list_head *iter_list;
>  	struct netlbl_af4list *addr4;
> 

-- 
James Morris
<jmorris@namei.org>

