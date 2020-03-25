Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BBB19C4AC
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388680AbgDBOsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:48:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388288AbgDBOsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:48:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9B9D128A8287;
        Thu,  2 Apr 2020 07:48:36 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:31:02 -0700 (PDT)
Message-Id: <20200325.113102.661246567769402013.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325022321.21944-1-edumazet@google.com>
References: <20200325022321.21944-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 07:48:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 24 Mar 2020 19:23:21 -0700

> TCP recvmsg() calls skb_copy_datagram_iter(), which
> calls an indirect function (cb pointing to simple_copy_to_iter())
> for every MSS (fragment) present in the skb.
> 
> CONFIG_RETPOLINE=y forces a very expensive operation
> that we can avoid thanks to indirect call wrappers.
> 
> This patch gives a 13% increase of performance on
> a single flow, if the bottleneck is the thread reading
> the TCP socket.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
