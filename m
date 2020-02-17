Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F32E1608C3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBQDZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:25:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgBQDZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:25:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B24F156939A0;
        Sun, 16 Feb 2020 19:25:26 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:25:25 -0800 (PST)
Message-Id: <20200216.192525.1097551100928922122.davem@davemloft.net>
To:     arjunroy.kdev@gmail.com
Cc:     netdev@vger.kernel.org, arjunroy@google.com, soheil@google.com,
        edumazet@google.com
Subject: Re: [PATCH net-next 2/2] tcp-zerocopy: Return sk_err (if set)
 along with tcp receive zerocopy.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214233050.19429-2-arjunroy.kdev@gmail.com>
References: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
        <20200214233050.19429-2-arjunroy.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:25:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy.kdev@gmail.com>
Date: Fri, 14 Feb 2020 15:30:50 -0800

> From: Arjun Roy <arjunroy@google.com>
> 
> This patchset is intended to reduce the number of extra system calls
> imposed by TCP receive zerocopy. For ping-pong RPC style workloads,
> this patchset has demonstrated a system call reduction of about 30%
> when coupled with userspace changes.
> 
> For applications using epoll, returning sk_err along with the result
> of tcp receive zerocopy could remove the need to call
> recvmsg()=-EAGAIN after a spurious wakeup.
> 
> Consider a multi-threaded application using epoll. A thread may awaken
> with EPOLLIN but another thread may already be reading. The
> spuriously-awoken thread does not necessarily know that another thread
> 'won'; rather, it may be possible that it was woken up due to the
> presence of an error if there is no data. A zerocopy read receiving 0
> bytes thus would need to be followed up by recvmsg to be sure.
> 
> Instead, we return sk_err directly with zerocopy, so the application
> can avoid this extra system call.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied.
