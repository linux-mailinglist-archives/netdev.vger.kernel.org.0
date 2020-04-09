Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291051A38E0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDIR2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:28:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgDIR2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:28:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96E87128D8644;
        Thu,  9 Apr 2020 10:28:15 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:28:14 -0700 (PDT)
Message-Id: <20200409.102814.2035520677628509572.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        challa@noironetworks.com, linux-kernel@vger.kernel.org,
        taras.chornyi@plvision.eu
Subject: Re: [PATCH net v3] net: ipv4: devinet: Fix crash when add/del
 multicast IP with autojoin
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409172524.26385-1-vadym.kochan@plvision.eu>
References: <20200409172524.26385-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:28:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Thu,  9 Apr 2020 20:25:24 +0300

> From: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> When CONFIG_IP_MULTICAST is not set and multicast ip is added to the device
> with autojoin flag or when multicast ip is deleted kernel will crash.
> 
> steps to reproduce:
> 
> ip addr add 224.0.0.0/32 dev eth0
> ip addr del 224.0.0.0/32 dev eth0
> 
> or
> 
> ip addr add 224.0.0.0/32 dev eth0 autojoin
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
>  pc : _raw_write_lock_irqsave+0x1e0/0x2ac
>  lr : lock_sock_nested+0x1c/0x60
>  Call trace:
>   _raw_write_lock_irqsave+0x1e0/0x2ac
>   lock_sock_nested+0x1c/0x60
>   ip_mc_config.isra.28+0x50/0xe0
 ...
> Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

Applied and queued up for -stable, thanks.
