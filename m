Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D809E26817D
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIMVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMVdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:33:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334DDC06174A;
        Sun, 13 Sep 2020 14:33:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6BBA12814447;
        Sun, 13 Sep 2020 14:16:22 -0700 (PDT)
Date:   Sun, 13 Sep 2020 14:33:08 -0700 (PDT)
Message-Id: <20200913.143308.2042080994542358655.davem@davemloft.net>
To:     ttoukan.linux@gmail.com
Cc:     luojiaxing@huawei.com, kuba@kernel.org, idos@mellanox.com,
        ogerlitz@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value
 to ring_cons but not used it anymore in mlx4_en_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
References: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
        <20200912.182219.1013721666435098048.davem@davemloft.net>
        <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 13 Sep 2020 14:16:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <ttoukan.linux@gmail.com>
Date: Sun, 13 Sep 2020 13:12:05 +0300

> 
> 
> On 9/13/2020 4:22 AM, David Miller wrote:
>> From: Luo Jiaxing <luojiaxing@huawei.com>
>> Date: Sat, 12 Sep 2020 16:08:15 +0800
>> 
>>> We found a set but not used variable 'ring_cons' in mlx4_en_xmit(), it
>>> will
>>> cause a warning when build the kernel. And after checking the commit
>>> record
>>> of this function, we found that it was introduced by a previous patch.
>>>
>>> So, We delete this redundant assignment code.
>>>
>>> Fixes: 488a9b48e398 ("net/mlx4_en: Wake TX queues only when there's
>>> enough room")
>>>
>>> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
>> Looks good, applied, thanks.
>> 
> 
> Hi Luo,
> 
> I didn't get a chance to review it during the weekend.

Tariq, what are you even commenting on?  Are you responding to this patch
which removes a %100 obviously unused variable set, or on the commit
mentioned in the Fixes: tag?

> The ring_cons local variable is used in line 903:
> https://elixir.bootlin.com/linux/v5.9-rc4/source/drivers/net/ethernet/mellanox/mlx4/en_tx.c#L903

He is removing an assignment to ring_cons much later in the function
and therefore has no effect on this line.

> 1. Your patch causes a degradation to the case when MLX4_EN_PERF_STAT
> is defined.

This is not true, see above.
