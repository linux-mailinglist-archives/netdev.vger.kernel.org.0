Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E552BC482
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 09:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgKVI1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 03:27:31 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:44948 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbgKVI1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 03:27:31 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4Cf3LR5mGKz3xRN;
        Sun, 22 Nov 2020 09:27:27 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Cf3LC1B9Nz2TRjV;
        Sun, 22 Nov 2020 09:27:15 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.14) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 22 Nov
 2020 09:26:52 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next 0/3] net: ptp: use common defines for PTP message types in further drivers
Date:   Sun, 22 Nov 2020 09:26:33 +0100
Message-ID: <20201122082636.12451-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.14]
X-RMX-ID: 20201122-092717-4Cf3LC1B9Nz2TRjV-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series replaces further driver internal enumeration / uses of magic
numbers with the newly introduced PTP_MSGTYPE_* defines.

On Friday, 20 November 2020, 23:39:10 CET, Vladimir Oltean wrote:
> On Fri, Nov 20, 2020 at 09:41:03AM +0100, Christian Eggers wrote:
> > This series introduces commen defines for PTP event messages. Driver
> > internal defines are removed and some uses of magic numbers are replaced
> > by the new defines.
> > [...]
> 
> I understand that you don't want to spend a lifetime on this, but I see
> that there are more drivers which you did not touch.
> 
> is_sync() in drivers/net/phy/dp83640.c can be made to
> 	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;
> 
> this can be removed from drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h:
> enum {
> 	MLXSW_SP_PTP_MESSAGE_TYPE_SYNC,
> 	MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ,
> 	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ,
> 	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP,
> };
I think that I have found an addtional one in the Microsemi VSC85xx PHY driver.



