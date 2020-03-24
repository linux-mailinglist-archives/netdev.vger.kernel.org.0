Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429DB191D55
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgCXXPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:15:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCXXPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:15:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AB00159F3F40;
        Tue, 24 Mar 2020 16:15:16 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:15:15 -0700 (PDT)
Message-Id: <20200324.161515.1787662512822595061.davem@davemloft.net>
To:     ye.zh-yuan@socionext.com
Cc:     netdev@vger.kernel.org, okamoto.satoru@socionext.com,
        kojima.masahisa@socionext.com, vinicius.gomes@intel.com,
        kuba@kernel.org
Subject: Re: [PATCH net v3] net: cbs: Fix software cbs to consider packet
 sending time
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324082825.3095-1-ye.zh-yuan@socionext.com>
References: <20200324082825.3095-1-ye.zh-yuan@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:15:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zh-yuan Ye <ye.zh-yuan@socionext.com>
Date: Tue, 24 Mar 2020 17:28:25 +0900

> Currently the software CBS does not consider the packet sending time
> when depleting the credits. It caused the throughput to be
> Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
> Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
> is expected. In order to fix the issue above, this patch takes the time
> when the packet sending completes into account by moving the anchor time
> variable "last" ahead to the send completion time upon transmission and
> adding wait when the next dequeue request comes before the send
> completion time of the previous packet.
> 
> changelog:
> V2->V3:
>  - remove unnecessary whitespace cleanup
>  - add the checks if port_rate is 0 before division
> 
> V1->V2:
>  - combine variable "send_completed" into "last"
>  - add the comment for estimate of the packet sending
> 
> Fixes: 585d763af09c ("net/sched: Introduce Credit Based Shaper (CBS) qdisc")
> Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied and queued up for -stable, thank you.
