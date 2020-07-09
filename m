Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD85B21A7D4
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgGITc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgGITc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:32:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739DFC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:32:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D119112792F7B;
        Thu,  9 Jul 2020 12:32:26 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:32:26 -0700 (PDT)
Message-Id: <20200709.123226.1790509373997909025.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: fix a memory leak in atm_tc_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709031359.11063-1-xiyou.wangcong@gmail.com>
References: <20200709031359.11063-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:32:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed,  8 Jul 2020 20:13:59 -0700

> When tcf_block_get() fails inside atm_tc_init(),
> atm_tc_put() is called to release the qdisc p->link.q.
> But the flow->ref prevents it to do so, as the flow->ref
> is still zero.
> 
> Fix this by moving the p->link.ref initialization before
> tcf_block_get().
> 
> Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
> Reported-and-tested-by: syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
