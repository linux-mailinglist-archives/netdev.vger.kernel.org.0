Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD777BCB
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbfG0UZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:25:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0UZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:25:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F21F71533FE89;
        Sat, 27 Jul 2019 13:25:10 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:25:10 -0700 (PDT)
Message-Id: <20190727.132510.1416371792799706738.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ipv4: Fix a possible null-pointer dereference
 in inet_csk_rebuild_route()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726022534.24994-1-baijiaju1990@gmail.com>
References: <20190726022534.24994-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:25:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Fri, 26 Jul 2019 10:25:34 +0800

> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index f5c163d4771b..27d9d80f3401 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1073,7 +1073,10 @@ static struct dst_entry *inet_csk_rebuild_route(struct sock *sk, struct flowi *f
>  		sk_setup_caps(sk, &rt->dst);
>  	rcu_read_unlock();
>  
> -	return &rt->dst;
> +	if (rt)
> +		return &rt->dst;
> +	else
> +		return NULL;

If rt is NULL, &rt->dst is also NULL as has been pointed out to you.

Please fix your automated tools to understand this case before submitting
more changes.

Thank you.
