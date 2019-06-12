Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF242B30
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440092AbfFLPpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:45:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfFLPpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Qy8TClhLa7EX32zykzF7swlXEY3fJ7xn0wRbY2fjLGM=; b=VRLvGFbhJiBZIOhDf2UB3Puc0p
        F1DwbYd2kH7lND5cLoaSX+y4MD+wlbfH7a9rcZMGS+4ZPl4XI2XaJK5uIlKFkJK0Mk3xebXbbsac4
        /INL5O66v6UjtFxYsi6uvyxPzyIPZyhg28UmayFatB4uOntuJ+Ry9vYzvGdykWHMcPYI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5Qq-0005v4-2Q; Wed, 12 Jun 2019 17:45:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 3/3] net: ethtool: self_test: Mark interface in testing operative status
Date:   Wed, 12 Jun 2019 17:44:38 +0200
Message-Id: <20190612154438.22703-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612154438.22703-1-andrew@lunn.ch>
References: <20190612154438.22703-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an interface is executing a self test, put the interface into
operative status testing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/core/ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index d08b1e19ce9c..f86070effd61 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1765,7 +1765,9 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 	if (!data)
 		return -ENOMEM;
 
+	netif_testing_on(dev);
 	ops->self_test(dev, &test, data);
+	netif_testing_off(dev);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &test, sizeof(test)))
-- 
2.20.1

