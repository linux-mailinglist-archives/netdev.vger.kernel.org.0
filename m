Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D1225534
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgGTBNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTBNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:13:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BE8C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 18:13:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C35C012849A01;
        Sun, 19 Jul 2020 18:13:12 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:13:12 -0700 (PDT)
Message-Id: <20200719.181312.319765151742786503.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, kernel@linuxace.com
Subject: Re: [PATCH net v2] bonding: check error value of
 register_netdevice() immediately
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719121124.4182-1-ap420073@gmail.com>
References: <20200719121124.4182-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:13:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sun, 19 Jul 2020 12:11:24 +0000

> If register_netdevice() is failed, net_device should not be used
> because variables are uninitialized or freed.
> So, the routine should be stopped immediately.
> But, bond_create() doesn't check return value of register_netdevice()
> immediately. That will result in a panic because of using uninitialized
> or freed memory.
> 
> Test commands:
>     modprobe netdev-notifier-error-inject
>     echo -22 > /sys/kernel/debug/notifier-error-inject/netdev/\
> actions/NETDEV_REGISTER/error
>     modprobe bonding max_bonds=3
> 
> Splat looks like:
 ...
> Fixes: e826eafa65c6 ("bonding: Call netif_carrier_off after register_netdevice")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
