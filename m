Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6070582461
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfHESAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:00:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59974 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbfHESAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:00:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E1EC1540A48E;
        Mon,  5 Aug 2019 11:00:02 -0700 (PDT)
Date:   Mon, 05 Aug 2019 11:00:01 -0700 (PDT)
Message-Id: <20190805.110001.1510283366849683723.davem@davemloft.net>
To:     dmitrolin@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, vladbu@mellanox.com
Subject: Re: [PATCH] net: sched: use temporary variable for actions indexes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
References: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 11:00:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dmitrolin@mellanox.com
Date: Thu,  1 Aug 2019 13:02:51 +0000

> From: Dmytro Linkin <dmitrolin@mellanox.com>
> 
> Currently init call of all actions (except ipt) init their 'parm'
> structure as a direct pointer to nla data in skb. This leads to race
> condition when some of the filter actions were initialized successfully
> (and were assigned with idr action index that was written directly
> into nla data), but then were deleted and retried (due to following
> action module missing or classifier-initiated retry), in which case
> action init code tries to insert action to idr with index that was
> assigned on previous iteration. During retry the index can be reused
> by another action that was inserted concurrently, which causes
> unintended action sharing between filters.
> To fix described race condition, save action idr index to temporary
> stack-allocated variable instead on nla data.
> 
> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
> Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied and queued up for -stable, thanks.
