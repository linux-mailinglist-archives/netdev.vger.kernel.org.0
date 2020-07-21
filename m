Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2D22748F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgGUBcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:32:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24678C061794;
        Mon, 20 Jul 2020 18:32:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6C2A11FFCC3A;
        Mon, 20 Jul 2020 18:15:49 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:32:33 -0700 (PDT)
Message-Id: <20200720.183233.1523852489153157390.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     isdn@linux-pingi.de, sergey.senozhatsky@gmail.com,
        wangkefeng.wang@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mISDN: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200718103033.352247-1-christophe.jaillet@wanadoo.fr>
References: <20200718103033.352247-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:15:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 18 Jul 2020 12:30:33 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'setup_hw()' (hfcpci.c) GFP_KERNEL can be used
> because it is called from the probe function and no lock is taken.
> The call chain is:
>    hfc_probe()
>    --> setup_card()
>    --> setup_hw()
> 
> When memory is allocated in 'inittiger()' (netjet.c) GFP_ATOMIC must be
> used because a spin_lock is taken by the caller (i.e. 'nj_init_card()')
> This is also consistent with the other allocations done in the function.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
