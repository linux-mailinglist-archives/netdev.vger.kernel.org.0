Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6760C1E365E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgE0DTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgE0DTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:19:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39830C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:19:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19CCB12739B59;
        Tue, 26 May 2020 20:19:00 -0700 (PDT)
Date:   Tue, 26 May 2020 20:18:59 -0700 (PDT)
Message-Id: <20200526.201859.755046542854273149.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, mptcp@lists.01.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] mptcp: avoid NULL-ptr derefence on fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d7d7f946ab9c43e96720d97e68645e38fb8b233c.1590417507.git.pabeni@redhat.com>
References: <d7d7f946ab9c43e96720d97e68645e38fb8b233c.1590417507.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:19:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 25 May 2020 16:38:47 +0200

> In the MPTCP receive path we must cope with TCP fallback
> on blocking recvmsg(). Currently in such code path we detect
> the fallback condition, but we don't fetch the struct socket
> required for fallback.
> 
> The above allowed syzkaller to trigger a NULL pointer
> dereference:
 ...
> Address the issue initializing the struct socket reference
> before entering the fallback code.
> 
> Reported-and-tested-by: syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com
> Suggested-by: Ondrej Mosnacek <omosnace@redhat.com>
> Fixes: 8ab183deb26a ("mptcp: cope with later TCP fallback")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
