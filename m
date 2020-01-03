Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9880312F23C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgACAfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:35:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:35:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F6AA1572A419;
        Thu,  2 Jan 2020 16:35:08 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:35:07 -0800 (PST)
Message-Id: <20200102.163507.404343273086201773.davem@davemloft.net>
To:     wenyang@linux.alibaba.com
Cc:     toke@toke.dk, ldir@darbyshire-bryant.me.uk, toke@redhat.com,
        xiyou.wangcong@gmail.com, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sch_cake: avoid possible divide by zero in
 cake_enqueue()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102092143.8971-1-wenyang@linux.alibaba.com>
References: <20200102092143.8971-1-wenyang@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:35:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>
Date: Thu,  2 Jan 2020 17:21:43 +0800

> The variables 'window_interval' is u64 and do_div()
> truncates it to 32 bits, which means it can test
> non-zero and be truncated to zero for division.
> The unit of window_interval is nanoseconds,
> so its lower 32-bit is relatively easy to exceed.
> Fix this issue by using div64_u64() instead.
> 
> Fixes: 7298de9cd725 ("sch_cake: Add ingress mode")
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>

Applied and queued up for -stable.
