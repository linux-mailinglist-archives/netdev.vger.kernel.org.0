Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D694A478C9
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 05:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfFQDmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 23:42:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55398 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQDmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 23:42:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C0CD14DB0333;
        Sun, 16 Jun 2019 20:42:43 -0700 (PDT)
Date:   Sun, 16 Jun 2019 20:42:40 -0700 (PDT)
Message-Id: <20190616.204240.717937021550114907.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] tipc: purge deferredq list for each grp member in
 tipc_group_delete
From:   David Miller <davem@davemloft.net>
In-Reply-To: <14ff2b79da7b9098fbff2919f0bc5a1afa33fe32.1560677047.git.lucien.xin@gmail.com>
References: <14ff2b79da7b9098fbff2919f0bc5a1afa33fe32.1560677047.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 20:42:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 16 Jun 2019 17:24:07 +0800

> Syzbot reported a memleak caused by grp members' deferredq list not
> purged when the grp is be deleted.
> 
> The issue occurs when more(msg_grp_bc_seqno(hdr), m->bc_rcv_nxt) in
> tipc_group_filter_msg() and the skb will stay in deferredq.
> 
> So fix it by calling __skb_queue_purge for each member's deferredq
> in tipc_group_delete() when a tipc sk leaves the grp.
> 
> Fixes: b87a5ea31c93 ("tipc: guarantee group unicast doesn't bypass group broadcast")
> Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
