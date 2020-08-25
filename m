Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99EF250D9F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgHYAd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgHYAd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:33:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A452BC061574;
        Mon, 24 Aug 2020 17:33:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A87711294C70B;
        Mon, 24 Aug 2020 17:17:09 -0700 (PDT)
Date:   Mon, 24 Aug 2020 17:33:55 -0700 (PDT)
Message-Id: <20200824.173355.1151795672938918588.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, kuba@kernel.org,
        yanaijie@huawei.com, hkallweit1@gmail.com, mhabets@solarflare.com,
        mst@redhat.com, leon@kernel.org, colin.king@canonical.com,
        yuehaibing@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: atheros: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823080353.169306-1-christophe.jaillet@wanadoo.fr>
References: <20200823080353.169306-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:17:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 23 Aug 2020 10:03:53 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'atl1e_setup_ring_resources()' (atl1e_main.c),
> 'atl1_setup_ring_resources()' (atl1.c) and 'atl2_setup_ring_resources()'
> (atl2.c) GFP_KERNEL can be used because it can be called from a .ndo_open.
> 
> 'atl1_setup_ring_resources()' (atl1.c) can also be called from a
> '.set_ringparam' (see struct ethtool_ops) where sleep is also allowed.
> 
> Both cases are protected by 'rtnl_lock()' which is a mutex. So these
> function can sleep.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
