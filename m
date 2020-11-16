Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5614B2B53E0
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgKPVe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgKPVez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:34:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B063E2224F;
        Mon, 16 Nov 2020 21:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605562495;
        bh=lSGys+8LKdYd14eGCQNhlTPa72dn/l05p/h7XghfMf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y0bArRZ8uGQASEyaDNauaVUvPbxaTPo+0EXoOpgzEY+uHqEj0Qgg4lJCpYSkFxXlJ
         e8V49DOEGbOy+M7CQWCYm3JBmUkpPnntvjUqSe1gxktNJrdwzX0OgPzKfnUqug5+eE
         6DCYLttpGZP107kQhZP5uSy4XcAHoaDWiJ8DNK8E=
Date:   Mon, 16 Nov 2020 13:34:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115073533.1366-1-o.rempel@pengutronix.de>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 08:35:33 +0100 Oleksij Rempel wrote:
> +static const struct ar9331_mib_desc ar9331_mib[] = {
> +	MIB_DESC(1, 0x00, "RxBroad"),
> +	MIB_DESC(1, 0x04, "RxPause"),
> +	MIB_DESC(1, 0x08, "RxMulti"),
> +	MIB_DESC(1, 0x0c, "RxFcsErr"),
> +	MIB_DESC(1, 0x10, "RxAlignErr"),
> +	MIB_DESC(1, 0x14, "RxRunt"),
> +	MIB_DESC(1, 0x18, "RxFragment"),
> +	MIB_DESC(1, 0x1c, "Rx64Byte"),
> +	MIB_DESC(1, 0x20, "Rx128Byte"),
> +	MIB_DESC(1, 0x24, "Rx256Byte"),
> +	MIB_DESC(1, 0x28, "Rx512Byte"),
> +	MIB_DESC(1, 0x2c, "Rx1024Byte"),
> +	MIB_DESC(1, 0x30, "Rx1518Byte"),
> +	MIB_DESC(1, 0x34, "RxMaxByte"),
> +	MIB_DESC(1, 0x38, "RxTooLong"),
> +	MIB_DESC(2, 0x3c, "RxGoodByte"),
> +	MIB_DESC(2, 0x44, "RxBadByte"),
> +	MIB_DESC(1, 0x4c, "RxOverFlow"),
> +	MIB_DESC(1, 0x50, "Filtered"),
> +	MIB_DESC(1, 0x54, "TxBroad"),
> +	MIB_DESC(1, 0x58, "TxPause"),
> +	MIB_DESC(1, 0x5c, "TxMulti"),
> +	MIB_DESC(1, 0x60, "TxUnderRun"),
> +	MIB_DESC(1, 0x64, "Tx64Byte"),
> +	MIB_DESC(1, 0x68, "Tx128Byte"),
> +	MIB_DESC(1, 0x6c, "Tx256Byte"),
> +	MIB_DESC(1, 0x70, "Tx512Byte"),
> +	MIB_DESC(1, 0x74, "Tx1024Byte"),
> +	MIB_DESC(1, 0x78, "Tx1518Byte"),
> +	MIB_DESC(1, 0x7c, "TxMaxByte"),
> +	MIB_DESC(1, 0x80, "TxOverSize"),
> +	MIB_DESC(2, 0x84, "TxByte"),
> +	MIB_DESC(1, 0x8c, "TxCollision"),
> +	MIB_DESC(1, 0x90, "TxAbortCol"),
> +	MIB_DESC(1, 0x94, "TxMultiCol"),
> +	MIB_DESC(1, 0x98, "TxSingleCol"),
> +	MIB_DESC(1, 0x9c, "TxExcDefer"),
> +	MIB_DESC(1, 0xa0, "TxDefer"),
> +	MIB_DESC(1, 0xa4, "TxLateCol"),
> +};

You must expose relevant statistics via the normal get_stats64 NDO
before you start dumping free form stuff in ethtool -S.
