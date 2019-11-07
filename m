Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5A8F3B85
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfKGWf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:35:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36766 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:35:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id c22so4297233wmd.1;
        Thu, 07 Nov 2019 14:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TMwoSxT/4GGDyCQoDNcUPurUcdE1c7+EMwGJUkqnzXs=;
        b=Pr0aFrdeeIUogR9T9xynvSArsLkK5HBwUlfII2BYxq1GMUW97cXSwG2h9ZmtdUGCKF
         A8vNOlVE23TGL044HBEUfE25Ngu0JjZh3ll3B/ktVfl36UYXVsndFsQN8XruCuYRLQrm
         RqQBkM7EX3oE0f2HsOTWq5UPpIQA9HiLbaneiuj481XMoq9D/y5wGaGxMu7b9iRak6G1
         VthNWZ32vdljxz+lvDPJ1JywpVoZEYRt0mj5X/9OWNkTc7GIVtBB0+N/SsTf7ldE9434
         7RH4NrA4Nv88zPk9dL35ffxvWcjirR8lZXmBIYIUXVQBcdLCvvzPwMT/XupS3ovnPi/m
         gMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TMwoSxT/4GGDyCQoDNcUPurUcdE1c7+EMwGJUkqnzXs=;
        b=Rz8dynkfAaZ2NhXfGlFOH2GfWRSA4OFOGpAWQPqkGPL5SisUH30iX8XpRpEArX9zTL
         AiS2zPs7Y76mPzIqWZQf46mqd9pLrwQSJegMqtrmYZ7clNirQhy/oLnO4y2pVMNIThp8
         KJYptZiI09TZm9hH+24GBmma2QJ/sU3ZT7JMttwsTxQbrG0XiNI8C+ga5Po8v6WQhWuB
         h6dGTuWgakiu9RjO3JIGJq3XWaMA0P6qaatKYD95j5hvAx6qsY8RdXNSVoeQSZltLxS2
         +1zQjCsvH3dIV7zws23d5Obt095NNIKjHAo/A9kJsfhINjSLzdJwOKDa/Fr2xedKey2O
         hr3Q==
X-Gm-Message-State: APjAAAWVA+de2WQyAbZpjZ2e87TD+pDBMf6cQfaNsAzssZwDfdwxLF96
        gIpPskps+KH/HFscSdCecD5U1/GX
X-Google-Smtp-Source: APXvYqx8xScYBJoXlzF05l83tJs3HriXDX4aeugdE/sGwVN+qr0AD4JgYK3ka5ZxR0To9ENvfMuatQ==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr5132600wmh.40.1573166150882;
        Thu, 07 Nov 2019 14:35:50 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6sm3667194wrw.6.2019.11.07.14.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 14:35:50 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Timur Tabi <timur@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: qcom/emac: Demote MTU change print to debug
Date:   Thu,  7 Nov 2019 14:35:37 -0800
Message-Id: <20191107223537.23440-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107223537.23440-1-f.fainelli@gmail.com>
References: <20191107223537.23440-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing the MTU can be a frequent operation and it is already clear
when (or not) a MTU change is successful, demote prints to debug prints.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index c84ab052ef26..98f92268cbaa 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -213,9 +213,9 @@ static int emac_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
-	netif_info(adpt, hw, adpt->netdev,
-		   "changing MTU from %d to %d\n", netdev->mtu,
-		   new_mtu);
+	netif_dbg(adpt, hw, adpt->netdev,
+		  "changing MTU from %d to %d\n", netdev->mtu,
+		  new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
-- 
2.17.1

