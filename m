Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5528CA41C8
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 04:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfHaCuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 22:50:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfHaCuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 22:50:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E44451550EE28;
        Fri, 30 Aug 2019 19:50:06 -0700 (PDT)
Date:   Fri, 30 Aug 2019 19:50:04 -0700 (PDT)
Message-Id: <20190830.195004.827507363244913502.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     efremov@linux.com, linux-kernel@vger.kernel.org, joe@perches.com,
        borisp@mellanox.com, netdev@vger.kernel.org, leon@kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 03/11] net/mlx5e: Remove unlikely() from WARN*()
 condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ad2ef15ddaec0033ce17d8ba252037ef70c7ac93.camel@mellanox.com>
References: <20190829165025.15750-1-efremov@linux.com>
        <20190829165025.15750-3-efremov@linux.com>
        <ad2ef15ddaec0033ce17d8ba252037ef70c7ac93.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 19:50:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 29 Aug 2019 21:23:30 +0000

> On Thu, 2019-08-29 at 19:50 +0300, Denis Efremov wrote:
>> "unlikely(WARN_ON_ONCE(x))" is excessive. WARN_ON_ONCE() already uses
>> unlikely() internally.
>> 
>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> Cc: Boris Pismenny <borisp@mellanox.com>
>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Cc: Joe Perches <joe@perches.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: netdev@vger.kernel.org
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git
>> a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
>> index 7833ddef0427..e5222d17df35 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
>> @@ -408,7 +408,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct
>> net_device *netdev,
>>  		goto out;
>>  
>>  	tls_ctx = tls_get_ctx(skb->sk);
>> -	if (unlikely(WARN_ON_ONCE(tls_ctx->netdev != netdev)))
>> +	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
>>  		goto err_out;
>>  
>>  	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Dave, you can take this one.

Ok, applied to net-next as well as the UDP patch.
