Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497721E4D2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgGNAxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNAxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:53:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A4AC061755;
        Mon, 13 Jul 2020 17:53:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B741F12986EDE;
        Mon, 13 Jul 2020 17:53:31 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:53:30 -0700 (PDT)
Message-Id: <20200713.175330.150197545165980586.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, leon@kernel.org, natechancellor@gmail.com,
        snelson@pensando.io, vaibhavgupta40@gmail.com, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] amd8111e: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713195503.281339-1-christophe.jaillet@wanadoo.fr>
References: <20200713195503.281339-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:53:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 13 Jul 2020 21:55:03 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GPF_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'amd8111e_init_ring()', GFP_ATOMIC must be used
> because a spin_lock is hold.
> One of the call chains is:
>    amd8111e_open
>    ** spin_lock_irq(&lp->lock);
>    --> amd8111e_restart
>       --> amd8111e_init_ring
>    ** spin_unlock_irq(&lp->lock);
> 
> The rest of the patch is produced by coccinelle with a few adjustments to
> please checkpatch.pl.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
