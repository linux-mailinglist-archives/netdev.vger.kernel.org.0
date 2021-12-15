Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF747620D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhLOTqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhLOTqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:46:39 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B45C061574;
        Wed, 15 Dec 2021 11:46:39 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id cf39so33079879lfb.8;
        Wed, 15 Dec 2021 11:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dJolCmf4MUVgCYYA2Jbj/PMnd+JT0PpWS6Os0v/lt74=;
        b=PZcfoML8xy5xqXKpnrWcvtm3MZrUDdXb2Rey2AZYi/btQFQSJ5ow6YeI0ckM+Q6Jcz
         GMN3kNoT82BDHic+BdkfW/BQmBRph0zWVukFnPxirtEr1RuU5vTxiPvggvSvvasBZguJ
         m+A4eNqFm7aJi08DaFvmwfK9yG3S9JiAQcVOmiIJZhZAdOGgm0/O9G+3zUXhW9GKPiXr
         rOE49oGreMOm+Nntd+Htn0nMN6HkoQ0ct2vOqGSwfNKAlkPcvl+RJUhiNH39o0gggxjH
         Qh+jA83jIo8tF7Idl928tk9DI/9nYADYLzlRtbiSSiy3gn+4OZf5u5/uXK0inhT03HJr
         3bkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dJolCmf4MUVgCYYA2Jbj/PMnd+JT0PpWS6Os0v/lt74=;
        b=UF43QQA0LTFMpZv0sz60gf1kCaIcL/RSkHccuYdAFuuLX9RN4Gd/OEsSLb6+9b+S2n
         9WD1IiiVpSKHu7GldQ3dbDOJ0ZmNvlhWvloCva67R7ipfkpQGs5sm4ZMskn5Ohh8Fpuc
         oGtBJJZjJfgAg6kQ13o9UAm9b4JeE6lurxUUsYJ/Mna+9u9NBU784qCfic/4vhzlKpL3
         pPluMJ2/K1KocjHGwXIibMqdSVOAMk1KIZQ2VDz5gOe1/eEYZO5MbGYD0O1mJBu8uqH6
         nwYa7BcbneLPLIGKu+99DisN5ZXnHrYVaGnIQ3NDvoWlKtfs06/vaR/gsx4c5pRpjoOY
         SI+g==
X-Gm-Message-State: AOAM531DgAhf+RuF165cUHrcdgspCCeb8Me5OnDAudYHes9bxGTMqQgL
        DZV+h8mQ5zkiOyrFw5FILqY=
X-Google-Smtp-Source: ABdhPJwc8S+cXlHy2naFT5lqwS5SApz4rRvbQkQSAzFLILenocl3lRHliyVky0Q9ucEUxsN7BFyqgQ==
X-Received: by 2002:a05:6512:22c7:: with SMTP id g7mr11338619lfu.417.1639597597383;
        Wed, 15 Dec 2021 11:46:37 -0800 (PST)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id h11sm622958ljb.42.2021.12.15.11.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 11:46:36 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Wed, 15 Dec 2021 20:46:34 +0100
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, RCU <rcu@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Axtens <dja@axtens.net>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Subject: Re: [PATCH] mlxsw: core: Switch to kvfree_rcu() API
Message-ID: <YbpGGiTtBvJnYvmZ@pc638.lan>
References: <20211215111845.2514-1-urezki@gmail.com>
 <20211215111845.2514-7-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215111845.2514-7-urezki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:18:43PM +0100, Uladzislau Rezki (Sony) wrote:
> Instead of invoking a synchronize_rcu() to free a pointer
> after a grace period we can directly make use of new API
> that does the same but in more efficient way.
> 
> TO: David S. Miller <davem@davemloft.net>
> TO: Jakub Kicinski <kuba@kernel.org>
> TO: netdev@vger.kernel.org
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index 3fd3812b8f31..47c29769759b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -2190,8 +2190,7 @@ void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
>  	if (!rxl_item)
>  		return;
>  	list_del_rcu(&rxl_item->list);
> -	synchronize_rcu();
> -	kfree(rxl_item);
> +	kvfree_rcu(rxl_item);
>  }
>  EXPORT_SYMBOL(mlxsw_core_rx_listener_unregister);
>  
> -- 
> 2.30.2
> 
+ David S. Miller <davem@davemloft.net>
+ Jakub Kicinski <kuba@kernel.org>
+ netdev@vger.kernel.org

--
Vlad Rezki
