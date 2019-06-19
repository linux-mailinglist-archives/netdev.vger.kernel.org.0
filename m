Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F044AF2D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 02:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfFSAt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 20:49:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFSAt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 20:49:56 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C069149CD337;
        Tue, 18 Jun 2019 17:49:44 -0700 (PDT)
Date:   Tue, 18 Jun 2019 20:49:38 -0400 (EDT)
Message-Id: <20190618.204938.1560433170435338986.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        suyj.fnst@cn.fujitsu.com, dsahern@gmail.com,
        syzkaller-bugs@googlegroups.com, dvyukov@google.com,
        pshelar@nicira.com
Subject: Re: [PATCH net 0/3] net: fix quite a few dst_cache crashes
 reported by syzbot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 17:49:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jun 2019 21:34:12 +0800

> There are two kinds of crashes reported many times by syzbot with no
> reproducer. Call Traces are like:
 ...
> They were caused by the fib_nh_common percpu member 'nhc_pcpu_rth_output'
> overwritten by another percpu variable 'dev->tstats' access overflow in
> tipc udp media xmit path when counting packets on a non tunnel device.
> 
> The fix is to make udp tunnel work with no tunnel device by allowing not
> to count packets on the tstats when the tunnel dev is NULL in Patches 1/3
> and 2/3, then pass a NULL tunnel dev in tipc_udp_tunnel() in Patch 3/3.

Series applied and queued up for -stable.

Thanks for putting all of those syzbot reported by tags in there.
