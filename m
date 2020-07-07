Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B4217971
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgGGUdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGUdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:33:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D60C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:33:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CF6F120F93E0;
        Tue,  7 Jul 2020 13:33:54 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:33:51 -0700 (PDT)
Message-Id: <20200707.133351.1107364856000095627.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net 00/11] mlx5 fixes 2020-07-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:33:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu,  2 Jul 2020 15:19:12 -0700

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

This needs more work.

I agree with Jakub that duplicating standard stats in ethtool -S is
and has always been a very bad idea.  We let people get away with it
initially in order to allow per-queue stats, but that was a mistake
and even if it was the right way forward it doesn't mean the rest of
the ip -s stats should have been duplicated as well.

Jakub's base argument is true, if we ever do something better in the
generic 'ip -s' stuff it will not propagate to all of the 'ethtool -S'
because it is duplicated around in every driver.

We let driver developers get away with a lot with ethtool custom
statistics and we're past due to perform some push back on this issue.

There also seems to be some necessary discussion about where the tc
reference count fix really belongs.
