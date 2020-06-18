Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044581FF5D8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbgFROy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731135AbgFROy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 10:54:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4254FC06174E;
        Thu, 18 Jun 2020 07:54:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4AD8120ED481;
        Thu, 18 Jun 2020 07:54:56 -0700 (PDT)
Date:   Thu, 18 Jun 2020 07:54:56 -0700 (PDT)
Message-Id: <20200618.075456.550840877226409223.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/sched] Fix null pointer deref skb in tc_ctl_action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618014328.28668-1-gaurav1086@gmail.com>
References: <20200618014328.28668-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 07:54:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Wed, 17 Jun 2020 21:43:28 -0400

> Add null check for skb
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  net/sched/act_api.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 8ac7eb0a8309..fd584821d75a 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1473,9 +1473,12 @@ static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
>  static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
>  			 struct netlink_ext_ack *extack)
>  {
> +	if (!skb)
> +		return 0;
> +
>  	struct net *net = sock_net(skb->sk);

You're adding code before variable declarations, this is not correct.

I find your work to be very rushed and sloppy, please take your time
and submit well formed and tested changes.

Thank you.
