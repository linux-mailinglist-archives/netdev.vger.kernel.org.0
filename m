Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB624C32C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbfFSVla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:41:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfFSVla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:41:30 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48D78147D11D9;
        Wed, 19 Jun 2019 14:41:29 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:41:28 -0400 (EDT)
Message-Id: <20190619.174128.213376833708672164.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, khilman@baylibre.com
Subject: Re: [PATCH net-next v1] net: stmmac: initialize the reset delay
 array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618203927.5862-1-martin.blumenstingl@googlemail.com>
References: <20190618203927.5862-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:41:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 18 Jun 2019 22:39:27 +0200

> Commit ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct
> stmmac_mdio_bus_data") moved the reset delay array from struct
> stmmac_mdio_bus_data to a stack variable.
> The values from the array inside struct stmmac_mdio_bus_data were
> previously initialized to 0 because the struct was allocated using
> devm_kzalloc(). The array on the stack has to be initialized
> explicitly, else we might be reading garbage values.
> 
> Initialize all reset delays to 0 to ensure that the values are 0 if the
> "snps,reset-delays-us" property is not defined.
> This fixes booting at least two boards (MIPS pistachio marduk and ARM
> sun8i H2+ Orange Pi Zero). These are hanging during boot when
> initializing the stmmac Ethernet controller (as found by Kernel CI).
> Both have in common that they don't define the "snps,reset-delays-us"
> property.
> 
> Fixes: ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Applied, thanks.

> Please feel free to squash this into net-next commit ce4ab73ab0c27c.

We do not "squash" things into existing net-next commits, as commits in
my tree(s) are permanent and immutable.
