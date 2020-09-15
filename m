Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6262B26B310
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgIOW72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgIOW7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:59:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC6CC06174A;
        Tue, 15 Sep 2020 15:59:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C70C713B635E9;
        Tue, 15 Sep 2020 15:42:30 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:59:17 -0700 (PDT)
Message-Id: <20200915.155917.2106978581769780446.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, kuba@kernel.org, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chelsio/chtls: Re-add dependencies on CHELSIO_T4 to
 fix modular CHELSIO_T4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915093551.29368-1-geert+renesas@glider.be>
References: <20200915093551.29368-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:42:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue, 15 Sep 2020 11:35:51 +0200

> As CHELSIO_INLINE_CRYPTO is bool, and CHELSIO_T4 is tristate, the
> dependency of CHELSIO_INLINE_CRYPTO on CHELSIO_T4 is not sufficient to
> protect CRYPTO_DEV_CHELSIO_TLS and CHELSIO_IPSEC_INLINE.  The latter two
> are also tristate, hence if CHELSIO_T4=n, they cannot be builtin, as
> that would lead to link failures like:
> 
>     drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:259: undefined reference to `cxgb4_port_viid'
> 
> and
> 
>     drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:752: undefined reference to `cxgb4_reclaim_completed_tx'
> 
> Fix this by re-adding dependencies on CHELSIO_T4 to tristate symbols.
> The dependency of CHELSIO_INLINE_CRYPTO on CHELSIO_T4 is kept to avoid
> asking the user.
> 
> Fixes: 6bd860ac1c2a0ec2 ("chelsio/chtls: CHELSIO_INLINE_CRYPTO should depend on CHELSIO_T4")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thank you.
