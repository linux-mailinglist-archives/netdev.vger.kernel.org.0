Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD71AF486
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgDRUMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728079AbgDRUMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:12:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020EEC061A0C;
        Sat, 18 Apr 2020 13:12:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 642E11273B3A2;
        Sat, 18 Apr 2020 13:12:19 -0700 (PDT)
Date:   Sat, 18 Apr 2020 13:11:00 -0700 (PDT)
Message-Id: <20200418.131100.1675181599729717011.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     ralf@linux-mips.org, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu, tanxin.ctf@gmail.com
Subject: Re: [PATCH] net: netrom: Fix potential nr_neigh refcnt leak in
 nr_add_node
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1586939780-69791-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1586939780-69791-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 13:12:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Wed, 15 Apr 2020 16:36:19 +0800

> nr_add_node() invokes nr_neigh_get_dev(), which returns a local
> reference of the nr_neigh object to "nr_neigh" with increased refcnt.
> 
> When nr_add_node() returns, "nr_neigh" becomes invalid, so the refcount
> should be decreased to keep refcount balanced.
> 
> The issue happens in one normal path of nr_add_node(), which forgets to
> decrease the refcnt increased by nr_neigh_get_dev() and causes a refcnt
> leak. It should decrease the refcnt before the function returns like
> other normal paths do.
> 
> Fix this issue by calling nr_neigh_put() before the nr_add_node()
> returns.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable, thanks.
