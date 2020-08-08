Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32B23F593
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHHAlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgHHAlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:41:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874ABC061756;
        Fri,  7 Aug 2020 17:41:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BAC81276E70D;
        Fri,  7 Aug 2020 17:24:19 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:41:04 -0700 (PDT)
Message-Id: <20200807.174104.946455971597492292.davem@davemloft.net>
To:     r.czerwinski@pengutronix.de
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net/tls: allow MSG_CMSG_COMPAT in sendmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
References: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:24:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Date: Thu,  6 Aug 2020 08:49:06 +0200

> Trying to use ktls on a system with 32-bit userspace and 64-bit kernel
> results in a EOPNOTSUPP message during sendmsg:
> 
>   setsockopt(3, SOL_TLS, TLS_TX, …, 40) = 0
>   sendmsg(3, …, msg_flags=0}, 0) = -1 EOPNOTSUPP (Operation not supported)
> 
> The tls_sw implementation does strict flag checking and does not allow
> the MSG_CMSG_COMPAT flag, which is set if the message comes in through
> the compat syscall.
> 
> This patch adds MSG_CMSG_COMPAT to the flag check to allow the usage of
> the TLS SW implementation on systems using the compat syscall path.
> 
> Note that the same check is present in the sendmsg path for the TLS
> device implementation, however the flag hasn't been added there for lack
> of testing hardware.
> 
> Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>

I'll apply this, thank you.
