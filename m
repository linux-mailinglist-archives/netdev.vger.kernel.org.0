Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357D21EEDFF
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgFDWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:55:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ADEC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:55:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8781911F5F8D1;
        Thu,  4 Jun 2020 15:55:13 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:55:12 -0700 (PDT)
Message-Id: <20200604.155512.1355727491425437227.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
Subject: Re: [PATCH] net: sched: make the watchdog functions more coherent
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603212113.11801-1-valentin@longchamp.me>
References: <20200603212113.11801-1-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:55:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>
Date: Wed,  3 Jun 2020 23:21:13 +0200

> Remove dev_watchdog_up() that directly called __netdev_watchdog_up() and
> rename dev_watchdog_down() to __netdev_watchdog_down() for symmetry.
> 
> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
> ---
>  net/sched/sch_generic.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 2efd5b61acef..f3cb740a2941 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -465,12 +465,7 @@ void __netdev_watchdog_up(struct net_device *dev)
>  	}
>  }
>  
> -static void dev_watchdog_up(struct net_device *dev)
> -{
> -	__netdev_watchdog_up(dev);
> -}
> -
> -static void dev_watchdog_down(struct net_device *dev)
> +static void __netdev_watchdog_down(struct net_device *dev)

This patch will not apply if I apply your symbol export patch because
the context above this function will be different.

Please don't do this.
