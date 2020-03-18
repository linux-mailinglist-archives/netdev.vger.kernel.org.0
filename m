Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25C018A981
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCRXw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:52:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgCRXw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:52:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8565015538DB4;
        Wed, 18 Mar 2020 16:52:26 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:52:26 -0700 (PDT)
Message-Id: <20200318.165226.1670056436692938282.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net-next] net: sched: Fix hw_stats_type setting in
 pedit loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318174229.25482-1-petrm@mellanox.com>
References: <20200318174229.25482-1-petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:52:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Wed, 18 Mar 2020 19:42:29 +0200

> In the commit referenced below, hw_stats_type of an entry is set for every
> entry that corresponds to a pedit action. However, the assignment is only
> done after the entry pointer is bumped, and therefore could overwrite
> memory outside of the entries array.
> 
> The reason for this positioning may have been that the current entry's
> hw_stats_type is already set above, before the action-type dispatch.
> However, if there are no more actions, the assignment is wrong. And if
> there are, the next round of the for_each_action loop will make the
> assignment before the action-type dispatch anyway.
> 
> Therefore fix this issue by simply reordering the two lines.
> 
> Fixes: 74522e7baae2 ("net: sched: set the hw_stats_type in pedit loop")
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Good catch, applied, thank you.
