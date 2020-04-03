Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9D619CE0D
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 03:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390164AbgDCBET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 21:04:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCBES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 21:04:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08B1812757499;
        Thu,  2 Apr 2020 18:04:17 -0700 (PDT)
Date:   Thu, 02 Apr 2020 18:04:17 -0700 (PDT)
Message-Id: <20200402.180417.804204103829966415.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net] net: sched: reduce amount of log messages in
 act_mirred
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a59f92670c72db738d91b639ecc72ef8daf69300.1585866258.git.marcelo.leitner@gmail.com>
References: <a59f92670c72db738d91b639ecc72ef8daf69300.1585866258.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 18:04:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu,  2 Apr 2020 19:26:12 -0300

> @@ -245,8 +245,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>  	}
>  
>  	if (unlikely(!(dev->flags & IFF_UP))) {
> -		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
> -				       dev->name);
> +		pr_notice_once("tc mirred: device %s is down\n",
> +			       dev->name);

This reduction is too extreme.

If someone causes this problem, reconfigures everything thinking that the
problem will be fixed, they won't see this message the second time and
mistakenly think it's working.
