Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4499E22D34C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgGYAb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgGYAb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:31:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C706FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:31:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E88412763AE5;
        Fri, 24 Jul 2020 17:14:43 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:31:27 -0700 (PDT)
Message-Id: <20200724.173127.26127623570599068.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com,
        bjorn.andersson@linaro.org, eric.dumazet@gmail.com
Subject: Re: [Patch net v2] qrtr: orphan socket in qrtr_release()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724164551.24109-1-xiyou.wangcong@gmail.com>
References: <20200724164551.24109-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 17:14:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 24 Jul 2020 09:45:51 -0700

> We have to detach sock from socket in qrtr_release(),
> otherwise skb->sk may still reference to this socket
> when the skb is released in tun->queue, particularly
> sk->sk_wq still points to &sock->wq, which leads to
> a UAF.
> 
> Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
> Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
