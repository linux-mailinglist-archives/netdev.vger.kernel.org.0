Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749836F041
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 19:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfGTRqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 13:46:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42195 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfGTRqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 13:46:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so17164093plb.9;
        Sat, 20 Jul 2019 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=L2J81KFMB9+2i2dCr/hG5bzUaIW4OMdMzoZ/0Z/JXXY=;
        b=Km81yo78w+rlAwT/gwFYfbv28Jgs5BCE1MgsQFEdhlhCgQmjldFaKcy3u0HTBYiloX
         L8XYW/LnaW6ORsZjO8+44qrXVhFzdUCUkEV8eURKJ+SkqB0At6u+qSYVIBIwiXjpTM/x
         7gmIG7cv4tJFKGtaNpt1pbUjJsWKyfSX04XSoIMkikNZ7T4JXBDCPK5lP7tR6KgYGew9
         X2ynm2oIHwy3DHRFm78hJguuTFf+gae7qCd2Iwx4GwZQb3lVfmvgExXMNB9Qz8KkCBgW
         /aqS1YpNQwnrsMTPeWPnYC+ymVRJtmHwMME+8W+cIYYvsvRg4aiq+MCJa1SC2V0Ng/By
         V0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=L2J81KFMB9+2i2dCr/hG5bzUaIW4OMdMzoZ/0Z/JXXY=;
        b=otzGIJpzqIu0XDfNr0siqTNPXlKSN1j9qofRdRDoAKVjxosqKqXFJ+Ni9uMVqG7H/x
         SU3JP9tf5CKBI/ttjN/hBpmBFgSk5G9jYsfCc0lzMsOsJg7Lf9O+ByTGaWf9P6f3MEhf
         NA7HpfTNViy4SBzxJp+9a6qHpjo64gnxFc8p4Ns1bOtll8UVA6pmJgNQwBA1kopzWQxu
         DTZZhmoptwOHMFQLkee+GC5hUWZnq09o3YG1Imrt6CgLnSiSVBJGbC62G/NVnjzISRUs
         prgmibjWu8q7vyM4+ck3rMxbfkab2YAM91+u6I6Eo38m/SvhX+M9XpzsFLGPj4VdQ68P
         aRaQ==
X-Gm-Message-State: APjAAAURb5M1oEYKTNxDvzMVsJMbERywJGx0lWByVisXNN1ciqiYNQQh
        N/JU3y71qFQsTkSjfr11A5A=
X-Google-Smtp-Source: APXvYqxlbLhnEFRhjszPBPUjtGhEt/AVHw3r7MRkvZSxpV9s5/OYqIpRYH0BMPO001+CgtH0WTAmNQ==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr63580645plb.295.1563644814133;
        Sat, 20 Jul 2019 10:46:54 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.86.126])
        by smtp.gmail.com with ESMTPSA id q69sm49590614pjb.0.2019.07.20.10.46.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 10:46:53 -0700 (PDT)
Date:   Sat, 20 Jul 2019 23:16:47 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rat_cs: Remove duplicate code
Message-ID: <20190720174613.GA31062@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code is same if translate is true/false in case invalid packet is
received.So remove else part.

Issue identified with coccicheck

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/net/wireless/ray_cs.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index cf37268..a51bbe7 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2108,29 +2108,16 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 #endif
 
 	if (!sniffer) {
-		if (translate) {
 /* TBD length needs fixing for translated header */
-			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
-			    rx_len >
-			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
-			     FCS_LEN)) {
-				pr_debug(
-				      "ray_cs invalid packet length %d received\n",
-				      rx_len);
-				return;
-			}
-		} else { /* encapsulated ethernet */
-
-			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
-			    rx_len >
-			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
-			     FCS_LEN)) {
-				pr_debug(
-				      "ray_cs invalid packet length %d received\n",
-				      rx_len);
-				return;
+		if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
+		    rx_len >
+		    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
+		     FCS_LEN)) {
+			pr_debug(
+			      "ray_cs invalid packet length %d received\n",
+			      rx_len);
+			return;
 			}
-		}
 	}
 	pr_debug("ray_cs rx_data packet\n");
 	/* If fragmented packet, verify sizes of fragments add up */
-- 
2.7.4

