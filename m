Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7FE3EE2
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfJXWRB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 18:17:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbfJXWRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:17:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93CA414B79E35;
        Thu, 24 Oct 2019 15:17:00 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:16:59 -0700 (PDT)
Message-Id: <20191024.151659.1029282183844084836.davem@davemloft.net>
To:     Thomas.Haemmerle@wolfvision.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, m.tretter@pengutronix.de
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
        <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:17:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Hämmerle <Thomas.Haemmerle@wolfvision.net>
Date: Tue, 22 Oct 2019 13:06:35 +0000

> +	const u8 *mac;
> +
> +	val_rxcfg = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> +	val_micr = phy_read(phydev, MII_DP83867_MICR);
> +
> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
> +			    WAKE_BCAST)) {
> +		val_rxcfg |= DP83867_WOL_ENH_MAC;
> +		val_micr |= MII_DP83867_MICR_WOL_INT_EN;
> +
> +		if (wol->wolopts & WAKE_MAGIC) {
> +			mac = (const u8 *)ndev->dev_addr;

Please declare 'mac' non-const and get rid of this cast, as suggested by Heiner.
