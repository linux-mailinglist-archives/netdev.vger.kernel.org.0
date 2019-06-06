Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043443688B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFFABJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:01:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFFABJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:01:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95AB012D8C0ED;
        Wed,  5 Jun 2019 17:01:08 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:01:08 -0700 (PDT)
Message-Id: <20190605.170108.1814605190881194288.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: fix the check before getting the cookie in
 rt6_get_cookie
From:   David Miller <davem@davemloft.net>
In-Reply-To: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
References: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:01:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  2 Jun 2019 19:10:46 +0800

> In Jianlin's testing, netperf was broken with 'Connection reset by peer',
> as the cookie check failed in rt6_check() and ip6_dst_check() always
> returned NULL.
> 
> It's caused by Commit 93531c674315 ("net/ipv6: separate handling of FIB
> entries from dst based routes"), where the cookie can be got only when
> 'c1'(see below) for setting dst_cookie whereas rt6_check() is called
> when !'c1' for checking dst_cookie, as we can see in ip6_dst_check().
> 
> Since in ip6_dst_check() both rt6_dst_from_check() (c1) and rt6_check()
> (!c1) will check the 'from' cookie, this patch is to remove the c1 check
> in rt6_get_cookie(), so that the dst_cookie can always be set properly.
> 
> c1:
>   (rt->rt6i_flags & RTF_PCPU || unlikely(!list_empty(&rt->rt6i_uncached)))
> 
> Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
