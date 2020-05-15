Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F9E1D426E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgEOAw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgEOAw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:52:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E9CC061A0C;
        Thu, 14 May 2020 17:52:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F71814DB4EA4;
        Thu, 14 May 2020 17:52:28 -0700 (PDT)
Date:   Thu, 14 May 2020 17:52:27 -0700 (PDT)
Message-Id: <20200514.175227.2037292271312428281.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv4,appletalk: move SIOCADDRT and SIOCDELRT
 handling into ->compat_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514144535.3000410-5-hch@lst.de>
References: <20200514144535.3000410-1-hch@lst.de>
        <20200514144535.3000410-5-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:52:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 May 2020 16:45:35 +0200

>  #ifdef CONFIG_COMPAT
> +static int atalk_compat_routing_ioctl(struct sock *sk, unsigned int cmd,
> +		struct compat_rtentry __user *ur)
> +{
> +	struct rtentry rt;
> +	compat_uptr_t rtdev;
> +

Reverse christmas tree please.

>  static int atalk_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  {
> +	struct sock *sk = sock->sk;
> +	void __user *argp = compat_ptr(arg);

Likewise.

> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 6177c4ba00370..b99c5e36e0a8f 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -968,17 +969,42 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  EXPORT_SYMBOL(inet_ioctl);
>  
>  #ifdef CONFIG_COMPAT
> +static int inet_compat_routing_ioctl(struct sock *sk, unsigned int cmd,
> +		struct compat_rtentry __user *ur)
> +{
> +	struct rtentry rt;
> +	compat_uptr_t rtdev;

Likewise.
