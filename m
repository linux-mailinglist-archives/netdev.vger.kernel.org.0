Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5A11D4267
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgEOAvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgEOAvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:51:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4DFC061A0C;
        Thu, 14 May 2020 17:51:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3D9714DAB337;
        Thu, 14 May 2020 17:51:22 -0700 (PDT)
Date:   Thu, 14 May 2020 17:51:22 -0700 (PDT)
Message-Id: <20200514.175122.554438066085502734.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ipv6: lift copy_from_user out of ipv6_route_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514144535.3000410-2-hch@lst.de>
References: <20200514144535.3000410-1-hch@lst.de>
        <20200514144535.3000410-2-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:51:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 May 2020 16:45:32 +0200

> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -542,19 +542,23 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  {
>  	struct sock *sk = sock->sk;
>  	struct net *net = sock_net(sk);
> +	void __user *argp = (void __user *)arg;

Please retain the reverse christmas tree ordering here.
