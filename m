Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88A9F671A
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfKJDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:40:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfKJDkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 22:40:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52034153A7DDD;
        Sat,  9 Nov 2019 19:40:20 -0800 (PST)
Date:   Sat, 09 Nov 2019 19:40:19 -0800 (PST)
Message-Id: <20191109.194019.359068420637293689.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        idosch@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net] devlink: disallow reload operation during device
 cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191109102946.8772-1-jiri@resnulli.us>
References: <20191109102946.8772-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 19:40:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat,  9 Nov 2019 11:29:46 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> There is a race between driver code that does setup/cleanup of device
> and devlink reload operation that in some drivers works with the same
> code. Use after free could we easily obtained by running:
> 
> while true; do
>         echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/bind
>         devlink dev reload pci/0000:00:10.0 &
>         echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/unbind
> done
> 
> Fix this by enabling reload only after setup of device is complete and
> disabling it at the beginning of the cleanup process.
> 
> Reported-by: Ido Schimmel <idosch@mellanox.com>
> Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> This is -net version of fix, net-next fix was sent and is already applied.
> Also note that unlike net-next, in -net this is not reproducible with
> netdevsim, so the reproducer uses mlxsw driver instead. That is the only
> difference in the patch desctiption.

Applied and queued up for -stable.
