Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEE0273C5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfEWBFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:05:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37262 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:05:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B93B1504394B;
        Wed, 22 May 2019 18:05:15 -0700 (PDT)
Date:   Wed, 22 May 2019 18:05:14 -0700 (PDT)
Message-Id: <20190522.180514.594797953150413853.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        liuhangbin@gmail.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipv4/igmp: fix another memory leak in
 igmpv3_del_delrec()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522235122.254262-1-edumazet@google.com>
References: <20190522235122.254262-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 18:05:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 May 2019 16:51:22 -0700

> syzbot reported memory leaks [1] that I have back tracked to
> a missing cleanup from igmpv3_del_delrec() when
> (im->sfmode != MCAST_INCLUDE)
> 
> Add ip_sf_list_clear_all() and kfree_pmc() helpers to explicitely
> handle the cleanups before freeing.
> 
> [1]
 ...
> Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
