Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8B1AF4EB
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgDRU0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgDRU0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:26:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC30C061A0C;
        Sat, 18 Apr 2020 13:26:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5574912753E8B;
        Sat, 18 Apr 2020 13:26:15 -0700 (PDT)
Date:   Sat, 18 Apr 2020 13:26:14 -0700 (PDT)
Message-Id: <20200418.132614.92642620154751485.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, tanxin.ctf@gmail.com
Subject: Re: [PATCH] tipc: Fix potential tipc_node refcnt leak in tipc_rcv
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1586940029-69994-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1586940029-69994-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 13:26:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Wed, 15 Apr 2020 16:40:28 +0800

> tipc_rcv() invokes tipc_node_find() twice, which returns a reference of
> the specified tipc_node object to "n" with increased refcnt.
> 
> When tipc_rcv() returns or a new object is assigned to "n", the original
> local reference of "n" becomes invalid, so the refcount should be
> decreased to keep refcount balanced.
> 
> The issue happens in some paths of tipc_rcv(), which forget to decrease
> the refcnt increased by tipc_node_find() and will cause a refcnt leak.
> 
> Fix this issue by calling tipc_node_put() before the original object
> pointed by "n" becomes invalid.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable.
