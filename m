Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3374DD04F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406602AbfJRUbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:31:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40886 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391151AbfJRUbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=n+PX2A8dlV6ut6Pb+SGWEFOSYerkTlGrS73kgmEiYb4=; b=D4AvXCUe1nTdG7gA0MZh7HVsS
        3x+xoNpsVHSu5/ayPkjDfYhMxs9e8ZLUbqLGj42bCQfOqcyb9elKlDLpVEQb7ArRtd4mNY4W9aTVE
        Q2RcZ4QqJiJwJ8Op/hyBM9h/tT4AlKzcAvKIobmAmvbSZKINOqEA3JIjuWrJrzuTrNAPY8IuTxzzO
        8DAUt6RND7zLZb/4IBk/dOFC669+0LKhVBELcyQzm3V5GpDuoj+W/dhL9EUbRqqGLpF2c0qmrmyBb
        Tpv3BjlxLW7SIcXAbtxMVVok1eeX9T7YzSKX7id5mi/WYy5nNOmeCGxvFo2mQtH0n7FsGmNKDojVH
        eb6aFpdjw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:54996 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYuG-0001Tx-1z; Fri, 18 Oct 2019 21:31:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYuC-0000t8-A3; Fri, 18 Oct 2019 21:31:24 +0100
From:   Russell King <rmk@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linville@tuxdriver.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: [PATCH 3/3] ethtool: add 0x16 and 0x1c extended compliance codes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iLYuC-0000t8-A3@rmk-PC.armlinux.org.uk>
Date:   Fri, 18 Oct 2019 21:31:24 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

0x16 and 0x1c are 10G Base-T extended compliance codes.  Add these
to our decoding.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 sfpid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sfpid.c b/sfpid.c
index 3c50c456f93d..ded3be7337d8 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -185,10 +185,14 @@ static void sff8079_show_transceiver(const __u8 *id)
 		printf("%s Extended: 25G Base-CR CA-S\n", pfx);
 	if (id[36] == 0xd)
 		printf("%s Extended: 25G Base-CR CA-N\n", pfx);
+	if (id[36] == 0x16)
+		printf("%s Extended: 10Gbase-T with SFI electrical interface\n", pfx);
 	if (id[36] == 0x18)
 		printf("%s Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 10^(-12)\n", pfx);
 	if (id[36] == 0x19)
 		printf("%s Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 10^(-12)\n", pfx);
+	if (id[36] == 0x1c)
+		printf("%s Extended: 10Gbase-T Short Reach\n", pfx);
 }
 
 static void sff8079_show_encoding(const __u8 *id)
-- 
2.7.4

