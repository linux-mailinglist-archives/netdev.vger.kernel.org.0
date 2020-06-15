Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE38F1FA186
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgFOUbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731529AbgFOUbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:31:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B6CC061A0E;
        Mon, 15 Jun 2020 13:31:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A520120ED49A;
        Mon, 15 Jun 2020 13:31:37 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:31:36 -0700 (PDT)
Message-Id: <20200615.133136.632752213609052484.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        kuba@kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        fparent@baylibre.com, stephane.leprovost@mediatek.com,
        pedro.tsai@mediatek.com, andrew.perepech@mediatek.com,
        bgolaszewski@baylibre.com
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: simplify interrupt
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611140139.17702-1-brgl@bgdev.pl>
References: <20200611140139.17702-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:31:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 11 Jun 2020 16:01:39 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> During development we tried to make the interrupt handling as fine-grained
> as possible with TX and RX interrupts being disabled/enabled independently
> and the counter registers reset from workqueue context.
> 
> Unfortunately after thorough testing of current mainline, we noticed the
> driver has become unstable under heavy load. While this is hard to
> reproduce, it's quite consistent in the driver's current form.
> 
> This patch proposes to go back to the previous approach of doing all
> processing in napi context with all interrupts masked in order to make the
> driver usable in mainline linux. This doesn't impact the performance on
> pumpkin boards at all and it's in line with what many ethernet drivers do
> in mainline linux anyway.
> 
> At the same time we're adding a FIXME comment about the need to improve
> the interrupt handling.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied.
