Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814E3BEC48
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfIZHEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:04:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfIZHEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:04:33 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85ABD1264EFF1;
        Thu, 26 Sep 2019 00:04:32 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:04:30 +0200 (CEST)
Message-Id: <20190926.090430.262328590132958395.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to
 list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924050458.14223-1-vinicius.gomes@intel.com>
References: <20190924050458.14223-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:04:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 23 Sep 2019 22:04:58 -0700

> When removing a cbs instance when offloading is enabled, the crash
> below can be observed.
> 
> The problem happens because that when offloading is enabled, the cbs
> instance is not added to the list.
> 
> Also, the current code doesn't handle correctly the case when offload
> is disabled without removing the qdisc: if the link speed changes the
> credit calculations will be wrong. When we create the cbs instance
> with offloading enabled, it's not added to the notification list, when
> later we disable offloading, it's not in the list, so link speed
> changes will not affect it.
> 
> The solution for both issues is the same, add the cbs instance being
> created unconditionally to the global list, even if the link state
> notification isn't useful "right now".
> 
> Crash log:
 ...
> Fixes: e0a7683 ("net/sched: cbs: fix port_rate miscalculation")

Please use 12 significant digits for SHA1 IDs in the future in Fixes:
tags.

> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied and queued up for -stable.
