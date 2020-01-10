Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C8B136576
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbgAJCkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:40:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJCkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:40:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4AC01573F021;
        Thu,  9 Jan 2020 18:40:08 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:40:08 -0800 (PST)
Message-Id: <20200109.184008.1039668214219996565.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     arnd@arndb.de, andrew.hendry@gmail.com, edumazet@google.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/x25: fix nonblocking connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109063114.23195-1-ms@dev.tdt.de>
References: <CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com>
        <20200109063114.23195-1-ms@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:40:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Thu,  9 Jan 2020 07:31:14 +0100

> This patch fixes 2 issues in x25_connect():
> 
> 1. It makes absolutely no sense to reset the neighbour and the
> connection state after a (successful) nonblocking call of x25_connect.
> This prevents any connection from being established, since the response
> (call accept) cannot be processed.
> 
> 2. Any further calls to x25_connect() while a call is pending should
> simply return, instead of creating new Call Request (on different
> logical channels).
> 
> This patch should also fix the "KASAN: null-ptr-deref Write in
> x25_connect" and "BUG: unable to handle kernel NULL pointer dereference
> in x25_connect" bugs reported by syzbot.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
> Reported-by: syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
