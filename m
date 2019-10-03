Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30214CAF0B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbfJCTRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:17:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47544 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729264AbfJCTRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:17:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EF90146D0E77;
        Thu,  3 Oct 2019 12:17:31 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:17:31 -0700 (PDT)
Message-Id: <20191003.121731.683396177943247555.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: PCI: Send EMAD traffic on a separate
 queue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003054449.8659-1-idosch@idosch.org>
References: <20191003054449.8659-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:17:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  3 Oct 2019 08:44:49 +0300

> From: Petr Machata <petrm@mellanox.com>
> 
> Currently mlxsw distributes sent traffic among all the available send
> queues. That includes control traffic as well as EMADs, which are used for
> configuration of the device.
> 
> However because all the queues have the same traffic class of 3, they all
> end up being directed to the same traffic class buffer. If the control
> traffic in the buffer cannot be serviced quickly enough, the EMAD traffic
> might be shut out, which causes transient failures, typically in FDB
> maintenance, counter upkeep and other periodic work.
> 
> To address this issue, dedicate SDQ 0 to EMAD traffic, with TC 0.
> Distribute the control traffic among the remaining queues, which are left
> with their current TC 3.
> 
> Suggested-by: Ido Schimmel <idosch@mellanox.com>
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Yeah dropping control traffic is not good.

Applied, thanks.
