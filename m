Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484C5A0CAF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfH1Vs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:48:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfH1Vs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:48:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD7D5153A41D0;
        Wed, 28 Aug 2019 14:48:28 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:48:28 -0700 (PDT)
Message-Id: <20190828.144828.397445517813949344.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] mld: fix memory leak in mld_del_delrec()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827103312.180258-1-edumazet@google.com>
References: <20190827103312.180258-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:48:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 27 Aug 2019 03:33:12 -0700

> Similar to the fix done for IPv4 in commit e5b1c6c6277d
> ("igmp: fix memory leak in igmpv3_del_delrec()"), we need to
> make sure mca_tomb and mca_sources are not blindly overwritten.
> 
> Using swap() then a call to ip6_mc_clear_src() will take care
> of the missing free.
 ...
> Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
> Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
