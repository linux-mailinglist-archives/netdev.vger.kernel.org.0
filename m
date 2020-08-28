Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E63255B95
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH1NwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgH1Nvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:51:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6AEC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 06:51:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E0B31283CC18;
        Fri, 28 Aug 2020 06:34:54 -0700 (PDT)
Date:   Fri, 28 Aug 2020 06:51:40 -0700 (PDT)
Message-Id: <20200828.065140.160276758518093969.davem@davemloft.net>
To:     zhudi21@huawei.com
Cc:     kuba@kernel.org, ast@kernel.org, yhs@fb.com,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH] netlink: fix a data race in netlink_rcv_wake()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826120113.3244-1-zhudi21@huawei.com>
References: <20200826120113.3244-1-zhudi21@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhudi <zhudi21@huawei.com>
Date: Wed, 26 Aug 2020 20:01:13 +0800

> The data races were reported by KCSAN:
> BUG: KCSAN: data-race in netlink_recvmsg / skb_queue_tail
 ...
> Since the write is under sk_receive_queue->lock but the read
> is done as lockless. so fix it by using skb_queue_empty_lockless()
> instead of skb_queue_empty() for the read in netlink_rcv_wake()
> 
> Signed-off-by: zhudi <zhudi21@huawei.com>

Applied, thank you.
