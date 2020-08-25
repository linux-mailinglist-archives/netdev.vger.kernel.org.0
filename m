Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683F5250D93
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgHYAdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbgHYAdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:33:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B184CC061574;
        Mon, 24 Aug 2020 17:33:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DC2E1294C709;
        Mon, 24 Aug 2020 17:16:48 -0700 (PDT)
Date:   Mon, 24 Aug 2020 17:33:33 -0700 (PDT)
Message-Id: <20200824.173333.548043755025064224.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     dave@thedillows.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] typhoon: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823061150.162135-1-christophe.jaillet@wanadoo.fr>
References: <20200823061150.162135-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:16:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 23 Aug 2020 08:11:50 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'typhoon_init_one()' GFP_KERNEL can be used
> because it is a probe function and no lock is acquired.
> 
> When memory is allocated in 'typhoon_download_firmware()', GFP_ATOMIC
> must be used because it can be called from a .ndo_tx_timeout function.
> So this function can be called with the 'netif_tx_lock' acquired.
> The call chain is:
>   --> typhoon_tx_timeout                 (.ndo_tx_timeout function)
>     --> typhoon_start_runtime
>       --> typhoon_download_firmware
> 
> While at is, update some comments accordingly.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
