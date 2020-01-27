Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2514A13E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgA0J4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:56:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:56:10 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA2F41502FC23;
        Mon, 27 Jan 2020 01:56:08 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:56:07 +0100 (CET)
Message-Id: <20200127.105607.566168953084755587.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH net] net_sched: ematch: reject invalid TCF_EM_SIMPLE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124225720.150449-1-edumazet@google.com>
References: <20200124225720.150449-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:56:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 24 Jan 2020 14:57:20 -0800

> It is possible for malicious userspace to set TCF_EM_SIMPLE bit
> even for matches that should not have this bit set.
> 
> This can fool two places using tcf_em_is_simple()
> 
> 1) tcf_em_tree_destroy() -> memory leak of em->data
>    if ops->destroy() is NULL
> 
> 2) tcf_em_tree_dump() wrongly report/leak 4 low-order bytes
>    of a kernel pointer.
> 
> BUG: memory leak
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com
> Cc: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Eric.
