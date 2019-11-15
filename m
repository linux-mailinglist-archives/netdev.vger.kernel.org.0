Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB533FE62C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKOUKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:10:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOUKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:10:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F33014E0BEC2;
        Fri, 15 Nov 2019 12:10:53 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:10:50 -0800 (PST)
Message-Id: <20191115.121050.591805779332799354.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to avoid
 clock count mis-match
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112112830.27561-1-hslester96@gmail.com>
References: <20191112112830.27561-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:10:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue, 12 Nov 2019 19:28:30 +0800

> If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> automatically to disable clks.
> Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
> Add this check to avoid clock count mis-match caused by double-disable.
> 
> Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Your explanation in your reply to my feedback still doesn't explain the
situation to me.

For every clock enable done during probe, there must be a matching clock
disable during remove.

Period.

There is no CONFIG_PM guarding the clock enables during probe in this driver,
therefore there should be no reason to require CONFIG_PM guards to the clock
disables during the remove method,

You have to explain clearly, and in detail, why my logic and analysis of this
situation is not correct.

And when you do so, you will need to add those important details to
the commit message of this change and submit a v3.

Thank you.
