Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2A1B6704
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgDWWtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWWtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:49:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF36C09B042;
        Thu, 23 Apr 2020 15:49:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FE8F127E5B39;
        Thu, 23 Apr 2020 15:49:50 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:49:49 -0700 (PDT)
Message-Id: <20200423.154949.459034580485896359.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     andrew.hendry@gmail.com, kuba@kernel.org,
        gregkh@linuxfoundation.org, edumazet@google.com,
        allison@lohutok.net, tglx@linutronix.de, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu, tanxin.ctf@gmail.com
Subject: Re: [PATCH] net/x25: Fix x25_neigh refcnt leak when reveiving frame
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587618786-13481-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587618786-13481-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:49:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Thu, 23 Apr 2020 13:13:03 +0800

> x25_lapb_receive_frame() invokes x25_get_neigh(), which returns a
> reference of the specified x25_neigh object to "nb" with increased
> refcnt.
> 
> When x25_lapb_receive_frame() returns, local variable "nb" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one path of
> x25_lapb_receive_frame(). When pskb_may_pull() returns false, the
> function forgets to decrease the refcnt increased by x25_get_neigh(),
> causing a refcnt leak.
> 
> Fix this issue by calling x25_neigh_put() when pskb_may_pull() returns
> false.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable, thanks.
