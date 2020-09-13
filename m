Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDBF268179
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgIMVa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMVa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:30:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96279C06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 14:30:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05E4212806019;
        Sun, 13 Sep 2020 14:13:35 -0700 (PDT)
Date:   Sun, 13 Sep 2020 14:30:22 -0700 (PDT)
Message-Id: <20200913.143022.1949357995189636518.davem@davemloft.net>
To:     shayagr@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, sameehj@amazon.com, ndagan@amazon.com,
        amitbern@amazon.com
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log
 prefix to files
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913081640.19560-3-shayagr@amazon.com>
References: <20200913081640.19560-1-shayagr@amazon.com>
        <20200913081640.19560-3-shayagr@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 13 Sep 2020 14:13:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>
Date: Sun, 13 Sep 2020 11:16:34 +0300

> ENA logs are adjusted to display the full ENA representation to
> distinct each ENA device in case of multiple interfaces.
> Using dev_err/warn/info function family for logging provides uniform
> printing with clear distinction of the driver and device.
> 
> This patch changes all printing in ena_com files to use dev_* logging
> messages. It also adds some log messages to make driver debugging
> easier.
> 
> Signed-off-by: Amit Bernstein <amitbern@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

This device prefix is so much less useful than printing the actual
networking adapter that the ena_com operations are for.

So if you are going to do this, go all the way and pass the ena_adapter
or the netdev down into these ena_com routines so that you can use
the netdev_*() message helpers.

Thank you.
