Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33F6123F53
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRF7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:59:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRF7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:59:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0493F14FFADB8;
        Tue, 17 Dec 2019 21:59:30 -0800 (PST)
Date:   Tue, 17 Dec 2019 21:59:30 -0800 (PST)
Message-Id: <20191217.215930.1954562133511895718.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, lucien.xin@gmail.com,
        kent.overstreet@gmail.com, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream
 initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 21:59:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 16 Dec 2019 22:01:16 -0300

> syzbot reported a memory leak when an allocation fails within
> genradix_prealloc() for output streams. That's because
> genradix_prealloc() leaves initialized members initialized when the
> issue happens and SCTP stack will abort the current initialization but
> without cleaning up such members.
> 
> The fix here is to always call genradix_free() when genradix_prealloc()
> fails, for output and also input streams, as it suffers from the same
> issue.
> 
> Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> Fixes: 2075e50caf5e ("sctp: convert to genradix")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
