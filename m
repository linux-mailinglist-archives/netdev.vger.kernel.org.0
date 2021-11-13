Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9144F262
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 10:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbhKMJ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 04:59:43 -0500
Received: from mg.ssi.bg ([193.238.174.37]:34048 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235742AbhKMJ7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Nov 2021 04:59:41 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 5186B147CC;
        Sat, 13 Nov 2021 11:56:47 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 99AAB14762;
        Sat, 13 Nov 2021 11:56:46 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 7434E3C0332;
        Sat, 13 Nov 2021 11:56:39 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 1AD9ubAJ016028;
        Sat, 13 Nov 2021 11:56:37 +0200
Date:   Sat, 13 Nov 2021 11:56:36 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     GuoYong Zheng <zhenggy@chinatelecom.cn>
cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: remove unused variable for ip_vs_new_dest
In-Reply-To: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
Message-ID: <25e945b7-9027-43cb-f79c-573fdce42a26@ssi.bg>
References: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 5 Nov 2021, GuoYong Zheng wrote:

> The dest variable is not used after ip_vs_new_dest anymore in
> ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.
> 
> Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>

	Looks good to me for -next, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index e62b40b..494399d 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -959,8 +959,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>   *	Create a destination for the given service
>   */
>  static int
> -ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
> -	       struct ip_vs_dest **dest_p)
> +ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>  {
>  	struct ip_vs_dest *dest;
>  	unsigned int atype, i;
> @@ -1020,8 +1019,6 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>  	spin_lock_init(&dest->stats.lock);
>  	__ip_vs_update_dest(svc, dest, udest, 1);
>  
> -	*dest_p = dest;
> -
>  	LeaveFunction(2);
>  	return 0;
>  
> @@ -1095,7 +1092,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>  		/*
>  		 * Allocate and initialize the dest structure
>  		 */
> -		ret = ip_vs_new_dest(svc, udest, &dest);
> +		ret = ip_vs_new_dest(svc, udest);
>  	}
>  	LeaveFunction(2);
>  
> -- 
> 1.8.3.1

Regards

--
Julian Anastasov <ja@ssi.bg>

