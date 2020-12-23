Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7752E1D56
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgLWOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728251AbgLWOP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:15:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4065423331;
        Wed, 23 Dec 2020 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608732918;
        bh=8kcJj7Lo6P8Yx3r8Ze6xv4FrAFZhiQyP2nsPWFkYvWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fH3GtIOh16iKkiwT0JJuvhm+MMAFN/aG19JDCj9FFFTEtc8Y3WNjD7hYxk8VHTdk1
         3zrrPLHAaiYpr7gRzfD0QuAmw440auTw3Ylw8H9vZSPTcmGT5U50/tmQve8oS8GRFk
         yKLwWem7OhjRyACzficat2i2rD4imLrcEF0HZu2HRMA/Q5ExUL8BR9wBcT00OsLItf
         /0J+eRRXcQtYj4lUWbrtzV0u9yRRPmdrWJdhpH5gHvkCyYZUfzz/P+fvZHykw0gn8W
         smmxUU1GzxvQZyBK4v1lKWQaFHquT4UodiqheujUisNLKu7rq0nChJCQdeKFcvxcup
         SYQ2jmgB5YVJg==
Date:   Wed, 23 Dec 2020 09:15:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 008/130] staging: wimax: depends on NET
Message-ID: <20201223141517.GD2790422@sasha-vm>
References: <20201223021813.2791612-1-sashal@kernel.org>
 <20201223021813.2791612-8-sashal@kernel.org>
 <X+Lx4wtqgIRwqaQO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <X+Lx4wtqgIRwqaQO@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 08:29:39AM +0100, Greg Kroah-Hartman wrote:
>On Tue, Dec 22, 2020 at 09:16:11PM -0500, Sasha Levin wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> [ Upstream commit 9364a2cf567187c0a075942c22d1f434c758de5d ]
>>
>> Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):
>>
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_alloc':
>> op-msg.c:(.text+0xa9): undefined reference to `__alloc_skb'
>> ld: op-msg.c:(.text+0xcc): undefined reference to `genlmsg_put'
>> ld: op-msg.c:(.text+0xfc): undefined reference to `nla_put'
>> ld: op-msg.c:(.text+0x168): undefined reference to `kfree_skb'
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_data_len':
>> op-msg.c:(.text+0x1ba): undefined reference to `nla_find'
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_send':
>> op-msg.c:(.text+0x311): undefined reference to `init_net'
>> ld: op-msg.c:(.text+0x326): undefined reference to `netlink_broadcast'
>> ld: drivers/staging/wimax/stack.o: in function `__wimax_state_change':
>> stack.c:(.text+0x433): undefined reference to `netif_carrier_off'
>> ld: stack.c:(.text+0x46b): undefined reference to `netif_carrier_on'
>> ld: stack.c:(.text+0x478): undefined reference to `netif_tx_wake_queue'
>> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_exit':
>> stack.c:(.exit.text+0xe): undefined reference to `genl_unregister_family'
>> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_init':
>> stack.c:(.init.text+0x1a): undefined reference to `genl_register_family'
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: netdev@vger.kernel.org
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Link: https://lore.kernel.org/r/20201102072456.20303-1-rdunlap@infradead.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/wimax/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>
>This isn't needed in any backported kernel as it only is relevant when
>the code moved to drivers/staging/

I'll drop it, thanks.

-- 
Thanks,
Sasha
