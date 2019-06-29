Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5022A5ACBF
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfF2Rvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 13:51:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2Rvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 13:51:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E47914B54555;
        Sat, 29 Jun 2019 10:51:49 -0700 (PDT)
Date:   Sat, 29 Jun 2019 10:51:48 -0700 (PDT)
Message-Id: <20190629.105148.1104113228238361709.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 10:51:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 26 Jun 2019 16:31:39 +0800

> Now when sctp_connect() is called with a wrong sa_family, it binds
> to a port but doesn't set bp->port, then sctp_get_af_specific will
> return NULL and sctp_connect() returns -EINVAL.
> 
> Then if sctp_bind() is called to bind to another port, the last
> port it has bound will leak due to bp->port is NULL by then.
> 
> sctp_connect() doesn't need to bind ports, as later __sctp_connect
> will do it if bp->port is NULL. So remove it from sctp_connect().
> While at it, remove the unnecessary sockaddr.sa_family len check
> as it's already done in sctp_inet_connect.
> 
> Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
> Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
