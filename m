Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33B1CE5C4
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgEKUlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:41:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A865BC061A0C;
        Mon, 11 May 2020 13:41:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0599311F5F667;
        Mon, 11 May 2020 13:41:17 -0700 (PDT)
Date:   Mon, 11 May 2020 13:41:17 -0700 (PDT)
Message-Id: <20200511.134117.1336222619714836904.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     robh+dt@kernel.org, matthias.bgg@gmail.com, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        arnd@arndb.de, fparent@baylibre.com, hkallweit1@gmail.com,
        edwin.peer@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        stephane.leprovost@mediatek.com, pedro.tsai@mediatek.com,
        andrew.perepech@mediatek.com, bgolaszewski@baylibre.com
Subject: Re: [PATCH v2 05/14] net: core: provide priv_to_netdev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511150759.18766-6-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
        <20200511150759.18766-6-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:41:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 11 May 2020 17:07:50 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Appropriate amount of extra memory for private data is allocated at
> the end of struct net_device. We have a helper - netdev_priv() - that
> returns its address but we don't have the reverse: a function which
> given the address of the private data, returns the address of struct
> net_device.
> 
> This has caused many drivers to store the pointer to net_device in
> the private data structure, which basically means storing the pointer
> to a structure in this very structure.
> 
> This patch proposes to add priv_to_netdev() - a helper which converts
> the address of the private data to the address of the associated
> net_device.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Sorry, please don't do this.  We had this almost two decades ago and
explicitly removed it intentionally.

Store the back pointer in your software state just like everyone else
does.
