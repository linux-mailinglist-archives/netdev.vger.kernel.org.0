Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E02D0BD4
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLGIeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:34:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44600 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgLGIeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 03:34:31 -0500
X-Greylist: delayed 3295 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 03:34:31 EST
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 95B3E4D09BF8F;
        Mon,  7 Dec 2020 00:33:49 -0800 (PST)
Date:   Mon, 07 Dec 2020 00:33:45 -0800 (PST)
Message-Id: <20201207.003345.926564522711614096.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, pablo@netfilter.org,
        gnault@redhat.com
Subject: Re: [PATCH net] udp: fix the proto value passed to
 ip_protocol_deliver_rcu for the segments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f8ad5904d273443f4c52ce4895f6d08d0f2ed18e.1607327740.git.lucien.xin@gmail.com>
References: <f8ad5904d273443f4c52ce4895f6d08d0f2ed18e.1607327740.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 07 Dec 2020 00:33:49 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  7 Dec 2020 15:55:40 +0800

> Guillaume noticed that: for segments udp_queue_rcv_one_skb() returns the
> proto, and it should pass "ret" unmodified to ip_protocol_deliver_rcu().
> Otherwize, with a negtive value passed, it will underflow inet_protos.
> 
> This can be reproduced with IPIP FOU:
> 
>   # ip fou add port 5555 ipproto 4
>   # ethtool -K eth1 rx-gro-list on
> 
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks!
