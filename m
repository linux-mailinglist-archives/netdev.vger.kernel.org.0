Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C31154450
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 13:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBFMyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 07:54:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFMyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 07:54:24 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE39514C36B28;
        Thu,  6 Feb 2020 04:54:21 -0800 (PST)
Date:   Thu, 06 Feb 2020 13:54:18 +0100 (CET)
Message-Id: <20200206.135418.602918242715627740.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org
Subject: Re: [PATCH net 1/2] net: ipv6: seg6_iptunnel: set tunnel headroom
 to zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204173019.4437-2-alex.aring@gmail.com>
References: <20200204173019.4437-1-alex.aring@gmail.com>
        <20200204173019.4437-2-alex.aring@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 04:54:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Tue,  4 Feb 2020 12:30:18 -0500

> diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
> index ab7f124ff5d7..5b6e88f16e2d 100644
> --- a/net/ipv6/seg6_iptunnel.c
> +++ b/net/ipv6/seg6_iptunnel.c
> @@ -449,8 +449,6 @@ static int seg6_build_state(struct nlattr *nla,
>  	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP)
>  		newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
>  
> -	newts->headroom = seg6_lwt_headroom(tuninfo);
> -
>  	*ts = newts;
>  
>  	return 0;

Even if this change is correct, you are eliminating the one and only
user of seg6_lwt_headroom() so you would have to kill that in this
patch as well.
