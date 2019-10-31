Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16685EB803
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJaTgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:36:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJaTgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:36:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C17D214FD0C63;
        Thu, 31 Oct 2019 12:36:04 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:36:04 -0700 (PDT)
Message-Id: <20191031.123604.1098090081443503807.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@mellanox.com, sfr@canb.auug.org.au, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] netdevsim: Fix use-after-free during device
 dismantle
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031162030.31158-1-idosch@idosch.org>
References: <20191031162030.31158-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:36:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 31 Oct 2019 18:20:30 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Commit da58f90f11f5 ("netdevsim: Add devlink-trap support") added
> delayed work to netdevsim that periodically iterates over the registered
> netdevsim ports and reports various packet traps via devlink.
> 
> While the delayed work takes the 'port_list_lock' mutex to protect
> against concurrent addition / deletion of ports, during device creation
> / dismantle ports are added / deleted without this lock, which can
> result in a use-after-free [1].
> 
> Fix this by making sure that the ports list is always modified under the
> lock.
 ...
> Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com

Applied.

> David, Stephen, this is going to conflict when you merge net into
> net-next. Should be resolved like this:
> https://github.com/idosch/linux/commit/a5ef0bd24450947570340a2b5caa9e01edc0612e

Thanks for the heads up.
