Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A640D5193F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfFXREj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:04:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57584 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfFXREi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:04:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB7DC15061484;
        Mon, 24 Jun 2019 10:04:37 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:04:35 -0700 (PDT)
Message-Id: <20190624.100435.1535171955176516330.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCHv2 net] tipc: check msg->req data len in
 tipc_nl_compat_bearer_disable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <58c46f0c73a4c1aea970e52de69188e2dd20d3b4.1561393699.git.lucien.xin@gmail.com>
References: <58c46f0c73a4c1aea970e52de69188e2dd20d3b4.1561393699.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 10:04:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 25 Jun 2019 00:28:19 +0800

> This patch is to fix an uninit-value issue, reported by syzbot:
 ...
> TLV_GET_DATA_LEN() may return a negtive int value, which will be
> used as size_t (becoming a big unsigned long) passed into memchr,
> cause this issue.
> 
> Similar to what it does in tipc_nl_compat_bearer_enable(), this
> fix is to return -EINVAL when TLV_GET_DATA_LEN() is negtive in
> tipc_nl_compat_bearer_disable(), as well as in
> tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().
> 
> v1->v2:
>   - add the missing Fixes tags per Eric's request.
> 
> Fixes: 0762216c0ad2 ("tipc: fix uninit-value in tipc_nl_compat_bearer_enable")
> Fixes: 8b66fee7f8ee ("tipc: fix uninit-value in tipc_nl_compat_link_reset_stats")
> Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
