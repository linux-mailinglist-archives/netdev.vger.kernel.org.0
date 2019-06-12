Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB542C24
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440231AbfFLQZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:25:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37692 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437944AbfFLQZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:25:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCC581513DD13;
        Wed, 12 Jun 2019 09:25:14 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:25:07 -0700 (PDT)
Message-Id: <20190612.092507.915453305221203158.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612035715.166676-1-maowenan@huawei.com>
References: <20190612035715.166676-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:25:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Wed, 12 Jun 2019 11:57:15 +0800

> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index c4503073248b..b6a1b5334565 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -477,6 +477,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>  	struct inet_ehash_bucket *head;
>  	spinlock_t *lock;
>  	bool ret = true;
> +	struct sock *reqsk = NULL;

Please preserve the reverse christmas tree local variable ordering here.

Thank you.
