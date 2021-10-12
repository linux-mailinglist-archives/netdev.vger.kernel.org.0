Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4219242A865
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbhJLPkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:40:52 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42155 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbhJLPkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:40:49 -0400
Received: from smtpclient.apple (p4fefcb73.dip0.t-ipconnect.de [79.239.203.115])
        by mail.holtmann.org (Postfix) with ESMTPSA id 20798CECE1;
        Tue, 12 Oct 2021 17:38:46 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] Bluetooth: hci_sock: purge socket queues in the
 destruct() callback
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211007190424.196281-1-phind.uet@gmail.com>
Date:   Tue, 12 Oct 2021 17:38:45 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Content-Transfer-Encoding: 7bit
Message-Id: <8C82DF3C-98B1-4C41-B9D8-3415DD64138F@holtmann.org>
References: <20211007190424.196281-1-phind.uet@gmail.com>
To:     Nguyen Dinh Phi <phind.uet@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nguyen,

> The receive path may take the socket right before hci_sock_release(),
> but it may enqueue the packets to the socket queues after the call to
> skb_queue_purge(), therefore the socket can be destroyed without clear
> its queues completely.
> 
> Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
> issue, because nothing is referencing the socket at this point.
> 
> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
> Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
> ---
> net/bluetooth/hci_sock.c | 11 +++++++----
> 1 file changed, 7 insertions(+), 4 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

