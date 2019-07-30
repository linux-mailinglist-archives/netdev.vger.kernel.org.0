Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728D07B524
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfG3Vk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:40:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG3Vk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:40:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A5DD14E340BE;
        Tue, 30 Jul 2019 14:40:26 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:40:26 -0700 (PDT)
Message-Id: <20190730.144026.1606872258602139673.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, lxin@redhat.com, shuali@redhat.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [net 1/1] tipc: fix unitilized skb list crash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564510750-19531-1-git-send-email-jon.maloy@ericsson.com>
References: <1564510750-19531-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:40:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 30 Jul 2019 20:19:10 +0200

> Our test suite somtimes provokes the following crash:
> 
> Description of problem:
 ...
> The reason is that the skb list tipc_socket::mc_method.deferredq only
> is initialized for connectionless sockets, while nothing stops arriving
> multicast messages from being filtered by connection oriented sockets,
> with subsequent access to the said list.
> 
> We fix this by initializing the list unconditionally at socket creation.
> This eliminates the crash, while the message still is dropped further
> down in tipc_sk_filter_rcv() as it should be.
> 
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied and queued up for -stable, thank you.
