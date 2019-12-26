Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCD12AEF2
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLZVfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:35:23 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52217 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:35:23 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so3853896pjs.1
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JsC69g/dm6TU2TzB9WwH3npWL31daqcKnC5S4dcBCXU=;
        b=wG873mVVD1tuPddo4d6DXhNZ5yYQ1pOdewxelbCok8POL4dfjtOAy7cLGXzsynY0i2
         i5MU5CMd6wORfoEy6dpecA93TIEiurKBLnp3g8UKPqvkUjvq1TVX7zQM+LzOArpOobUq
         RP+WrVHak46kakscTsRx70DN01gjl2xVfkvLwWJxSC9u8m0miYf4IwDsMK3dSd1aO2sV
         dEJDQrAbkSgD6UNg8OOSUMskNrkpiI6t7X6n+apCyEcT1iro0caztgkUHniyZSS2aRcc
         TIi95fX8s3iUdLTy4x70lvkQkhARi8fh3/QhU72EoRwbwKhMOMGU7Mtahbcg/OI1rJt2
         CZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JsC69g/dm6TU2TzB9WwH3npWL31daqcKnC5S4dcBCXU=;
        b=bvMnC/rW95CnpF1eCM+7mE6XP1uGHqQmeiirP1SHE4WDYkjZZBCH2g+rXtgUhkicB7
         UonwlkyHxWv/KthIN8u8X//majBPwOuliiwRa+bEx/XTkGa9DU7GD4pEFQigXfuL9UNT
         IMPbQMDI3uyjAyih/Kn9/Xb7Th4xtnpR+u093NG0rCQ/qa0aGRrCaErNsrYcaVZJtqD8
         c70flAQbB9yilgMS0Pz6IAgkD7L+3UHARACY6gTV11rYZGO4Ju0WzZgwufnEUI4evNN2
         UvHN2DcQ3Z47FNSnvyuEfvTIgAHvv2g6XXrqn+QdEHKaV7/YeZHeCQllIjBM86dtqo1G
         9iTg==
X-Gm-Message-State: APjAAAXQPFzgcwx4qgppqLgPSoyjF7/8TWnu8RduoVZcjepN9R2IT93x
        9VmjAqzHTo0hD7P29s+9SeAdqRUM5QA=
X-Google-Smtp-Source: APXvYqzuHo5P9QZcd4H7y6/KxmuMPF2Qz9lO7IAoZHJqRLCPzbpvpfhYZQOrTikLjX5JR3wYfN36oQ==
X-Received: by 2002:a17:902:9048:: with SMTP id w8mr47730382plz.294.1577396122200;
        Thu, 26 Dec 2019 13:35:22 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id q6sm37996662pfh.127.2019.12.26.13.35.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 13:35:21 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH net-next 1/2] net: Documentation about deprecating NETIF_F_IP{V6}_CSUM
Date:   Thu, 26 Dec 2019 13:34:58 -0800
Message-Id: <1577396099-3831-2-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577396099-3831-1-git-send-email-tom@herbertland.com>
References: <1577396099-3831-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add text in netdev-features.txt documenting that NETIF_F_IP_CSUM and
NETIF_F_IPV6_CSUM are being deprecated in favor of NETIF_F_HW_CSUM.
Suggest that legacy drivers can be fixed by advertising NETIF_F_HW_CSUM
and checking skb->protocol.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 Documentation/networking/netdev-features.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/netdev-features.txt b/Documentation/networking/netdev-features.txt
index 58dd1c1..8500ada 100644
--- a/Documentation/networking/netdev-features.txt
+++ b/Documentation/networking/netdev-features.txt
@@ -106,7 +106,12 @@ For complete description, see comments near the top of include/linux/skbuff.h.
 
 Note: NETIF_F_HW_CSUM is a superset of NETIF_F_IP_CSUM + NETIF_F_IPV6_CSUM.
 It means that device can fill TCP/UDP-like checksum anywhere in the packets
-whatever headers there might be.
+whatever headers there might be. NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are
+deprecated in favor of NETIF_F_HW_CSUM. Legacy drivers can be converted
+by advertising NETIF_F_HW_CSUM and checking skb->protocol for ETH_P_IP or
+ETH_P_IPV6, if the device does not support checksum offload for the protocol
+in skb->protocol then it can call skb_checksum_help to perform the checksum
+on the host.
 
  * Transmit TCP segmentation offload
 
-- 
2.7.4

