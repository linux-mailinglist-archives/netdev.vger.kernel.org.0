Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F48E1D6C59
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgEQTej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:34:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4827CC061A0C;
        Sun, 17 May 2020 12:34:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBAB8128A077E;
        Sun, 17 May 2020 12:34:37 -0700 (PDT)
Date:   Sun, 17 May 2020 12:34:37 -0700 (PDT)
Message-Id: <20200517.123437.2084818619487673025.davem@davemloft.net>
To:     zhangshaokun@hisilicon.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jinyuqi@huawei.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, jiri@resnulli.us, nivedita@alum.mit.edu,
        peterz@infradead.org, edumazet@google.com, jiongwang@huawei.com
Subject: Re: [PATCH v2] net: revert "net: get rid of an signed integer
 overflow in ip_idents_reserve()"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589600809-18001-1-git-send-email-zhangshaokun@hisilicon.com>
References: <1589600809-18001-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:34:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Date: Sat, 16 May 2020 11:46:49 +0800

> From: Yuqi Jin <jinyuqi@huawei.com>
> 
> Commit adb03115f459 ("net: get rid of an signed integer overflow in ip_idents_reserve()")
> used atomic_cmpxchg to replace "atomic_add_return" inside the function
> "ip_idents_reserve". The reason was to avoid UBSAN warning.
> However, this change has caused performance degrade and in GCC-8,
> fno-strict-overflow is now mapped to -fwrapv -fwrapv-pointer
> and signed integer overflow is now undefined by default at all
> optimization levels[1]. Moreover, it was a bug in UBSAN vs -fwrapv
> /-fno-strict-overflow, so Let's revert it safely.
> 
> [1] https://gcc.gnu.org/gcc-8/changes.html
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Eric Dumazet <edumazet@google.com>
 ...
> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Applied, thanks.
