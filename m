Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194942B6C72
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgKQSAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbgKQSAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:00:49 -0500
X-Greylist: delayed 1452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Nov 2020 10:00:48 PST
Received: from moc6.cz (hosting.moc6.cz [IPv6:2a02:c60:c70:8900::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F30C0613CF;
        Tue, 17 Nov 2020 10:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=moc6.cz;
        s=mail20201116; h=Message-ID:Subject:Cc:To:From:Date:Reply-To:In-Reply-To;
        bh=ENyjSleBoxU28yUIVg6xq5vz4ZwZ5cArdcaoaBhpfbE=; b=cVbIbsG+tSCPSwrYkk4HoY14Ee
        rEONBpmJ5roN3oT7obH4zureIAKfrplrmDcQr/RW9LqVbQRM07D4XjGb+Eiy5sQ5PSyX8WsRe9F1g
        v7kD6GHYRw7vsQ0ZFn86do+5Qka9phHb4FySFeAYX5zoOGUjjNgtJlqMFcSLI2bCf3JgSCm4ez2Sq
        3LgLE7VjOIxRYJZpnax6OkzvoUN2UWTHO9dwexZi4Ffps+425xt7xBwnYDPbOVb096uS4aCtBycby
        vAiEJ8FJekPENATjDBc02c/vaC1hwAJp9Zdckg3ndztdeJPYBYj3vJLhzmNHbT/G0e0wCO3zhSQq9
        KILfQW5UAh3foJLXEO54hZahsu2OOwBascQTRy7G18HehymR7VxCvJ6RY8cQm72bkMtpbo4e1YGit
        5DENpDQ3RvMM5pU8kR1PrykmAsTzrAIzXGvL1gJFuF75ZTU8xKC8EkH4FdxbpZPP2isjYlBLksYCB
        QymVh2D608hITsTRLsqp2CO55NixmxTgCaeFQjUwSAyFNmxnUWm7qTxxG+Vriu89erF6ixMgbR0vc
        w17qfu7kQNCA5S6YugnsVgdpoJ7lHvoz0qeKdO3Y+dyTia/sCAYl466ivij4t8V70PW0xh53eU114
        CuBHAqzw2NTUk8L58Plj32sD5v620apozRfW4HT+0=;
Received: from Debian-exim by moc6.cz with local (Exim 4.94)
        (envelope-from <Debian-exim@moc6.cz>)
         authenticated: Debian-exim
        id 1kf4u7-002JN2-K6; Tue, 17 Nov 2020 18:36:31 +0100
Date:   Tue, 17 Nov 2020 18:36:31 +0100
From:   Filip Moc <dev@moc6.cz>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Filip Moc <dev@moc6.cz>
Subject: [PATCH] net: usb: qmi_wwan: Set DTR quirk for MR400
Message-ID: <20201117173631.GA550981@moc6.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LTE module MR400 embedded in TL-MR6400 v4 requires DTR to be set.

Signed-off-by: Filip Moc <dev@moc6.cz>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index afeb09b9624e..d166c321ee9b 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1047,7 +1047,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
 	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
-	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE  (China Mobile) */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE (China Mobile) */
 	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
 	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)},
-- 
2.28.0

