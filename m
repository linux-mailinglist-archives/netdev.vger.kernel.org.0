Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5592E2C1F15
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbgKXHpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:45:08 -0500
Received: from mailout10.rmx.de ([94.199.88.75]:60773 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgKXHpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:45:07 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CgGJb3wNSz2yLj;
        Tue, 24 Nov 2020 08:45:03 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CgGJL67sFz2xdT;
        Tue, 24 Nov 2020 08:44:50 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.100) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Nov
 2020 08:44:27 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next v2 0/3] net: ptp: use common defines for PTP message types in further drivers
Date:   Tue, 24 Nov 2020 08:44:15 +0100
Message-ID: <20201124074418.2609-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.100]
X-RMX-ID: 20201124-084452-4CgGJL67sFz2xdT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
----------------
- resend, as v1 was sent before the prerequisites were merged
- removed mismatch between From: and Signed-off-by:
- [2/3] Reviewed-by: Ido Schimmel <idosch@nvidia.com>
- [3/3] Reviewed-by: Antoine Tenart <atenart@kernel.org>
- [3/3] removed dead email addresses from Cc:


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




