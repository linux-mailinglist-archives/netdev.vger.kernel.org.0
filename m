Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F11B1411
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgDTSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgDTSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:11:13 -0400
X-Greylist: delayed 226 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Apr 2020 11:11:13 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55EC061A0C;
        Mon, 20 Apr 2020 11:11:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB017127D487D;
        Mon, 20 Apr 2020 11:11:12 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:11:11 -0700 (PDT)
Message-Id: <20200420.111111.1335274381489892106.davem@davemloft.net>
To:     maz@kernel.org
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        khilman@baylibre.com, martin.blumenstingl@googlemail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: Add missing boundary to
 RGMII TX clock array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200418181457.3193175-1-maz@kernel.org>
References: <20200418181457.3193175-1-maz@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:11:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>
Date: Sat, 18 Apr 2020 19:14:57 +0100

> Running with KASAN on a VIM3L systems leads to the following splat
> when probing the Ethernet device:
> 
> ==================================================================
> BUG: KASAN: global-out-of-bounds in _get_maxdiv+0x74/0xd8
> Read of size 4 at addr ffffa000090615f4 by task systemd-udevd/139
> CPU: 1 PID: 139 Comm: systemd-udevd Tainted: G            E     5.7.0-rc1-00101-g8624b7577b9c #781
> Hardware name: amlogic w400/w400, BIOS 2020.01-rc5 03/12/2020
...
> Digging into this indeed shows that the clock divider array is
> lacking a final fence, and that the clock subsystems goes in the
> weeds. Oh well.
> 
> Let's add the empty structure that indicates the end of the array.
> 
> Fixes: bd6f48546b9c ("net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: stable@vger.kernel.org

Please do not CC: stable@vger.kernel.org for networking changes as per
netdev-FAQ

Applied and queued up for -stable, thanks.
