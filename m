Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DEA190B47
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCXKlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:41:05 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:56513 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbgCXKlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:41:04 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 121AF28009351;
        Tue, 24 Mar 2020 11:41:03 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id DBF9414E876; Tue, 24 Mar 2020 11:41:02 +0100 (CET)
Date:   Tue, 24 Mar 2020 11:41:02 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 08/14] net: ks8851: Use 16-bit read of RXFC register
Message-ID: <20200324104102.axlr6txhbgxhhw7k@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-9-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-9-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:57AM +0100, Marek Vasut wrote:
> The RXFC register is the only one being read using 8-bit accessors.
> To make it easier to support the 16-bit accesses used by the parallel
> bus variant of KS8851, use 16-bit accessor to read RXFC register as
> well as neighboring RXFCTR register.

This means that an additional 8 bits need to be transferred over the
SPI bus whenever a set of packets is read from the RX queue.  This
should be avoided.  I'd suggest adding a separate hook to read RXFC
and thus keep the 8-bit read function for the SPI variant.

Thanks,

Lukas
