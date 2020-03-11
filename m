Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1FB18230F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbgCKUCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:02:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgCKUCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 16:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jNQjYg41gX1jvyYVDHouohhUAxfetJtXXeRvUsSL/9I=; b=RM8OlNK4sEW8mge5ZTytutPfha
        H1f8cABzF7R1Lb3adEK+bHBtRsjeOEMchPO7wOkhAWF09+ondtVRNKHycv2W3BDaCOvgVzUWv2D+d
        LgBmhVw+a3OSisg8rK/iAKRywuXtYnEy5GwMgY5p0dPZFt8buvn6AgGbUdaYcAPZiVhs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jC7Z2-0006l8-ML; Wed, 11 Mar 2020 21:02:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: dsa: mv88e6xxx: Add missing mask of ATU occupancy register
Date:   Wed, 11 Mar 2020 21:02:31 +0100
Message-Id: <20200311200231.25937-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the bottom 12 bits contain the ATU bin occupancy statistics. The
upper bits need masking off.

Fixes: e0c69ca7dfbb ("net: dsa: mv88e6xxx: Add ATU occupancy via devlink resources")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8c9289549688..2f993e673ec7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2769,6 +2769,8 @@ static u64 mv88e6xxx_devlink_atu_bin_get(struct mv88e6xxx_chip *chip,
 		goto unlock;
 	}
 
+	occupancy &= MV88E6XXX_G2_ATU_STATS_MASK;
+
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.25.1

