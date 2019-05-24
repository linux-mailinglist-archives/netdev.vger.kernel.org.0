Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4229FDF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404143AbfEXU2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:28:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404104AbfEXU2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:28:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48F1614E2A500;
        Fri, 24 May 2019 13:28:50 -0700 (PDT)
Date:   Fri, 24 May 2019 13:28:49 -0700 (PDT)
Message-Id: <20190524.132849.279938218485377665.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        ecree@solarflare.com, jiri@resnulli.us, pablo@netfilter.org,
        andy@greyhouse.net, jakub.kicinski@netronome.com,
        michael.chan@broadcom.com, vishal@chelsio.com, lucasb@mojatatu.com,
        roid@mellanox.com
Subject: Re: [PATCH net] net: sched: don't use tc_action->order during
 action dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523063231.11581-1-vladbu@mellanox.com>
References: <20190523063231.11581-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:28:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 23 May 2019 09:32:31 +0300

> Function tcf_action_dump() relies on tc_action->order field when starting
> nested nla to send action data to userspace. This approach breaks in
> several cases:
> 
> - When multiple filters point to same shared action, tc_action->order field
>   is overwritten each time it is attached to filter. This causes filter
>   dump to output action with incorrect attribute for all filters that have
>   the action in different position (different order) from the last set
>   tc_action->order value.
> 
> - When action data is displayed using tc action API (RTM_GETACTION), action
>   order is overwritten by tca_action_gd() according to its position in
>   resulting array of nl attributes, which will break filter dump for all
>   filters attached to that shared action that expect it to have different
>   order value.
> 
> Don't rely on tc_action->order when dumping actions. Set nla according to
> action position in resulting array of actions instead.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Applied and queued up for -stable.
