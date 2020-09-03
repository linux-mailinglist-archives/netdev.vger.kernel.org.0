Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5D25CE91
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgICXye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgICXyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 19:54:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDDCC061244;
        Thu,  3 Sep 2020 16:54:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 004781288BB0D;
        Thu,  3 Sep 2020 16:37:45 -0700 (PDT)
Date:   Thu, 03 Sep 2020 16:54:32 -0700 (PDT)
Message-Id: <20200903.165432.788429825388438913.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH RESEND] smsc9420: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903201055.296320-1-christophe.jaillet@wanadoo.fr>
References: <20200903201055.296320-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 16:37:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu,  3 Sep 2020 22:10:55 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'smsc9420_probe()', GFP_KERNEL can be used
> because it is a probe function and no lock is acquired.
> 
> While at it, rewrite the size passed to 'dma_alloc_coherent()' the same way
> as the one passed to 'dma_free_coherent()'. This form is less verbose:
>    sizeof(struct smsc9420_dma_desc) * RX_RING_SIZE +
>    sizeof(struct smsc9420_dma_desc) * TX_RING_SIZE,
> vs
>    sizeof(struct smsc9420_dma_desc) * (RX_RING_SIZE + TX_RING_SIZE)
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
