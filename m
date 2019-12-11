Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3641111A0DC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfLKBzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:55:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfLKBzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:55:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19F9615071D29;
        Tue, 10 Dec 2019 17:55:28 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:55:27 -0800 (PST)
Message-Id: <20191210.175527.1568596418475317538.davem@davemloft.net>
To:     netanel@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V2 net] net: ena: fix napi handler misbehavior when the
 napi budget is zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210112744.6301-1-netanel@amazon.com>
References: <20191210112744.6301-1-netanel@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:55:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>
Date: Tue, 10 Dec 2019 11:27:44 +0000

> In netpoll the napi handler could be called with budget equal to zero.
> Current ENA napi handler doesn't take that into consideration.
> 
> The napi handler handles Rx packets in a do-while loop.
> Currently, the budget check happens only after decrementing the
> budget, therefore the napi handler, in rare cases, could run over
> MAX_INT packets.
> 
> In addition to that, this moves all budget related variables to int
> calculation and stop mixing u32 to avoid ambiguity
> 
> Signed-off-by: Netanel Belgazal <netanel@amazon.com>
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Please place the Fixes: tag first in the list of tags next time.

Applied and queued up for -stable, thanks.
