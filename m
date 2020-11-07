Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F8A2AA873
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgKGXs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 18:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGXs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 18:48:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56D7A208E4;
        Sat,  7 Nov 2020 23:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604792906;
        bh=UEQAx7ThAkEj+lGWM1ZP6Rs0yMp9byk0fls6a9lSeZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SW5K5UbliLNZJXmTmY60h3zawqQAeU5WSR/hIcyD/p+QFHnsB4KEuB/cwF/FuMWdw
         xqKFy5uA6cm0gFG8/XogMiEbNveLDUFElGPYJI5udwhHIU6FMpA5BoY/IeKA1ti7EO
         HrTngA47BDF2ykhl9nxkeJXafIb2Nmi7mbdok4VI=
Date:   Sat, 7 Nov 2020 15:48:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: ipv4: remove redundant initialization in
 inet_rtm_deladdr
Message-ID: <20201107154825.7e878d9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 01:42:37 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for 'err' with '-EINVAL' is redundant and
> can be removed, as it is updated soon.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

How many changes like this are there in the kernel right now?

I'm afraid that if there are too many it's not worth the effort.

Also - what tool do you use to find those, we need to make sure new
instances don't get into the tree.

> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 123a6d3..847cb18 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -651,7 +651,7 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct ifaddrmsg *ifm;
>  	struct in_ifaddr *ifa;
>  

You can remove this empty line while at it.

> -	int err = -EINVAL;
> +	int err;
>  
>  	ASSERT_RTNL();
>  

