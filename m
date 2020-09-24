Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCA427658D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgIXBBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIXBBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:01:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ED5C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:01:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5B70125EFA9F;
        Wed, 23 Sep 2020 17:44:53 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:01:40 -0700 (PDT)
Message-Id: <20200923.180140.957870805702877808.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
Subject: Re: [PATCH v2] net: lantiq: Add locking for TX DMA channel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922214112.19591-1-hauke@hauke-m.de>
References: <20200922214112.19591-1-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:44:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 22 Sep 2020 23:41:12 +0200

> The TX DMA channel data is accessed by the xrx200_start_xmit() and the
> xrx200_tx_housekeeping() function from different threads. Make sure the
> accesses are synchronized by acquiring the netif_tx_lock() in the
> xrx200_tx_housekeeping() function too. This lock is acquired by the
> kernel before calling xrx200_start_xmit().
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, but...

You posted this really fast after my feedback, so I have to ask if you
actually functionally tested this patch?
