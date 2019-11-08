Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121DFF5AA1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfKHWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:12:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:12:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16590153B4DCF;
        Fri,  8 Nov 2019 14:12:25 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:12:24 -0800 (PST)
Message-Id: <20191108.141224.1561483712458439557.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        idosch@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: disallow reload operation during
 device cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108204243.7241-1-jiri@resnulli.us>
References: <20191108204243.7241-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:12:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  8 Nov 2019 21:42:43 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> There is a race between driver code that does setup/cleanup of device
> and devlink reload operation that in some drivers works with the same
> code. Use after free could we easily obtained by running:
> 
> while true; do
>         echo 10 > /sys/bus/netdevsim/new_device
>         devlink dev reload netdevsim/netdevsim10 &
>         echo 10 > /sys/bus/netdevsim/del_device
> done
> 
> Fix this by enabling reload only after setup of device is complete and
> disabling it at the beginning of the cleanup process.
> 
> Reported-by: Ido Schimmel <idosch@mellanox.com>
> Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
