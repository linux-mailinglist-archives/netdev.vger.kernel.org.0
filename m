Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC05E19CE08
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 03:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390148AbgDCBCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 21:02:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCBCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 21:02:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1FB612757492;
        Thu,  2 Apr 2020 18:02:18 -0700 (PDT)
Date:   Thu, 02 Apr 2020 18:02:18 -0700 (PDT)
Message-Id: <20200402.180218.940555077368617365.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, arjan@linux.intel.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, itayav@mellanox.com
Subject: Re: [PATCH net] net/sched: Don't print dump stack in event of
 transmission timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402152336.538433-1-leon@kernel.org>
References: <20200402152336.538433-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 18:02:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu,  2 Apr 2020 18:23:36 +0300

> In event of transmission timeout, the drivers are given an opportunity
> to recover and continue to work after some in-house cleanups.
> 
> Such event can be caused by HW bugs, wrong congestion configurations
> and many more other scenarios. In such case, users are interested to
> get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> netdevice in trouble.
> 
> The dump stack printed later was added in the commit b4192bbd85d2
> ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> extra information, like list of the modules and which driver is involved.
> 
> While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> of modules rarely needed and can be collected later.
> 
> So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> large cluster setups.

Software bugs play into these situations and on at least two or three
occasions I know that the backtrace hinted at the cause of the bug.

I'm not applying this, sorry.
