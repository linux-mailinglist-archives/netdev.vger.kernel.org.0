Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F53115AF9
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfLGEs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:48:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfLGEs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:48:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E17511537A66D;
        Fri,  6 Dec 2019 20:48:25 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:48:25 -0800 (PST)
Message-Id: <20191206.204825.1293767323272186689.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        ncardwell@google.com, ycheng@google.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] tcp: md5: fix potential overestimation of TCP
 option space
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205181015.169651-1-edumazet@google.com>
References: <20191205181015.169651-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:48:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  5 Dec 2019 10:10:15 -0800

> Back in 2008, Adam Langley fixed the corner case of packets for flows
> having all of the following options : MD5 TS SACK
> 
> Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
> can be cooked from the remaining 8 bytes.
> 
> tcp_established_options() correctly sets opts->num_sack_blocks
> to zero, but returns 36 instead of 32.
> 
> This means TCP cooks packets with 4 extra bytes at the end
> of options, containing unitialized bytes.
> 
> Fixes: 33ad798c924b ("tcp: options clean up")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
