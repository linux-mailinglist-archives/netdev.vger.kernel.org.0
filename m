Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEFB1B8282
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgDXXn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgDXXn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:43:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24182C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:43:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10B9D14F39509;
        Fri, 24 Apr 2020 16:43:28 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:43:27 -0700 (PDT)
Message-Id: <20200424.164327.455293620342341833.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, sd@queasysnail.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] macsec: avoid to set wrong mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423134047.21644-1-ap420073@gmail.com>
References: <20200423134047.21644-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:43:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu, 23 Apr 2020 13:40:47 +0000

> When a macsec interface is created, the mtu is calculated with the lower
> interface's mtu value.
> If the mtu of lower interface is lower than the length, which is needed
> by macsec interface, macsec's mtu value will be overflowed.
> So, if the lower interface's mtu is too low, macsec interface's mtu
> should be set to 0.
> 
> Test commands:
>     ip link add dummy0 mtu 10 type dummy
>     ip link add macsec0 link dummy0 type macsec
>     ip link show macsec0
> 
> Before:
>     11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 4294967274
> After:
>     11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 0
> 
> Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable.
