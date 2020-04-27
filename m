Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE91BAD37
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgD0Su5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgD0Su4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:50:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9DC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:50:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C9A415D586B2;
        Mon, 27 Apr 2020 11:50:55 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:50:54 -0700 (PDT)
Message-Id: <20200427.115054.551269197453508231.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com,
        Jason@zx2c4.com
Subject: Re: [PATCH net] sch_sfq: validate silly quantum values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427011907.160247-1-edumazet@google.com>
References: <20200427011907.160247-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:50:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun, 26 Apr 2020 18:19:07 -0700

> syzbot managed to set up sfq so that q->scaled_quantum was zero,
> triggering an infinite loop in sfq_dequeue()
> 
> More generally, we must only accept quantum between 1 and 2^18 - 7,
> meaning scaled_quantum must be in [1, 0x7FFF] range.
> 
> Otherwise, we also could have a loop in sfq_dequeue()
> if scaled_quantum happens to be 0x8000, since slot->allot
> could indefinitely switch between 0 and 0x8000.
> 
> Fixes: eeaeb068f139 ("sch_sfq: allow big packets and be fair")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks Eric.
