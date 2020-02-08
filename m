Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A011564C6
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 15:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBHO3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 09:29:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgBHO3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 09:29:06 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99164133F2061;
        Sat,  8 Feb 2020 06:29:04 -0800 (PST)
Date:   Sat, 08 Feb 2020 15:28:38 +0100 (CET)
Message-Id: <20200208.152838.322440086718054291.davem@davemloft.net>
To:     tharvey@gateworks.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rrichter@marvell.com,
        sgoutham@marvell.com, andrew@lunn.ch
Subject: Re: [PATCH] net: thunderx: use proper interface type for RGMII
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
References: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Feb 2020 06:29:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>
Date: Fri,  7 Feb 2020 12:40:26 -0800

> The configuration of the OCTEONTX XCV_DLL_CTL register via
> xcv_init_hw() is such that the RGMII RX delay is bypassed
> leaving the RGMII TX delay enabled in the MAC:
> 
> 	/* Configure DLL - enable or bypass
> 	 * TX no bypass, RX bypass
> 	 */
> 	cfg = readq_relaxed(xcv->reg_base + XCV_DLL_CTL);
> 	cfg &= ~0xFF03;
> 	cfg |= CLKRX_BYP;
> 	writeq_relaxed(cfg, xcv->reg_base + XCV_DLL_CTL);
> 
> This would coorespond to a interface type of PHY_INTERFACE_MODE_RGMII_RXID
> and not PHY_INTERFACE_MODE_RGMII.
> 
> Fixing this allows RGMII PHY drivers to do the right thing (enable
> RX delay in the PHY) instead of erroneously enabling both delays in the
> PHY.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Applied, thanks.
