Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11448476F4
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfFPVRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:17:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52330 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfFPVRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:17:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95DB9151C3464;
        Sun, 16 Jun 2019 14:17:01 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:17:01 -0700 (PDT)
Message-Id: <20190616.141701.29050678945758813.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] neigh: fix use-after-free read in pneigh_get_next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615232848.60731-1-edumazet@google.com>
References: <20190615232848.60731-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:17:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 15 Jun 2019 16:28:48 -0700

> Nine years ago, I added RCU handling to neighbours, not pneighbours.
> (pneigh are not commonly used)
> 
> Unfortunately I missed that /proc dump operations would use a
> common entry and exit point : neigh_seq_start() and neigh_seq_stop()
> 
> We need to read_lock(tbl->lock) or risk use-after-free while
> iterating the pneigh structures.
> 
> We might later convert pneigh to RCU and revert this patch.
> 
> sysbot reported :
 ...
> Fixes: 767e97e1e0db ("neigh: RCU conversion of struct neighbour")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
