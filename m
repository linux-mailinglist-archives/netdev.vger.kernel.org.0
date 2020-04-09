Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4A1A38C7
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgDIRRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:17:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgDIRRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:17:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B739128C6D3A;
        Thu,  9 Apr 2020 10:17:05 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:17:04 -0700 (PDT)
Message-Id: <20200409.101704.1725996128523021782.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, antoine.tenart@bootlin.com
Subject: Re: [PATCH net] net: macsec: fix using wrong structure in
 macsec_changelink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409140808.29172-1-ap420073@gmail.com>
References: <20200409140808.29172-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:17:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  9 Apr 2020 14:08:08 +0000

> In the macsec_changelink(), "struct macsec_tx_sa tx_sc" is used to
> store "macsec_secy.tx_sc".
> But, the struct type of tx_sc is macsec_tx_sc, not macsec_tx_sa.
> So, the macsec_tx_sc should be used instead.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add macsec0 link dummy0 type macsec
>     ip link set macsec0 type macsec encrypt off
> 
> Splat looks like:
> [61119.963483][ T9335] ==================================================================
> [61119.964709][ T9335] BUG: KASAN: slab-out-of-bounds in macsec_changelink.part.34+0xb6/0x200 [macsec]
> [61119.965787][ T9335] Read of size 160 at addr ffff888020d69c68 by task ip/9335
 ...
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for v5.6 -stable, thank you.
