Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890F13250C
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfFBVk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35516 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfFBVkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so6157201wml.0;
        Sun, 02 Jun 2019 14:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JBFtQTGEdtOewlByjetdV4IfH+7KdYrEQNHeO2lLAJQ=;
        b=V0g1x/fYeod4S3lJfHg/oeVhUJ5Hk9ff44MM0LZHmM6g/XkcAeoqNJ5i814G39eokZ
         vYNLb/Q4/5tGhBqi6IeVuKQIAeuib2nmLg6yIFpcGlThwzjoSrG4iAgHvZ+Nw3uQsPR1
         EFSvkfkasEVFqvtq/Z6XqIhDROCUnqbmJirNi9k6T/0Ol++kImGEM72z9yWmDgkXxmeZ
         jv7EBDd9cAYyEroCr59WIcPkeplJKr968EnRdnfOrLX0P8jW4QKSs9k9U3DE9pO/fs1n
         9ayRfxlUZAQvlyxsZ9Whup00QD5aWusIk8rAcR7gqiPeTc6Iim63h5c847bBfzGVn4cv
         RusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JBFtQTGEdtOewlByjetdV4IfH+7KdYrEQNHeO2lLAJQ=;
        b=Zq3bM6mQnORIMvDe8kM4VSP3CzPii2TAUqENr4jSo6KKmb8ExfX2zZ+IiLHr8jQJ3r
         18Yd55HSaxUtzO9ESo/SLbctIBSvOJ0/VKaoCdE8NfOpYPEgwfsIjPVhKfDB0cjOuXO0
         L2mFY+IsVeLmJRpMLRwaxr9norOzsO0cAEY8A9e2vN2hQYya6/PPf9DNuFUqwoto00CD
         wmwHD+LppAUtFQjspijPcfEtc8HgUBepI8enFvtDSzZ59xvKymcvD7+rnB+nXTJgV/mu
         nPbJnv5YMei6KgGcnEMfwhx8g1fIB6hkmQoJBHLMNRQht3i6oDE8oZ8EnYD9nnha0qB7
         3gvQ==
X-Gm-Message-State: APjAAAVoqD3IqGy/NDUDkN0JS+1PAEsObP6c1y5jAJ71vVqOnNCIliNk
        1rSboenR9IP1xFLXjstN/Rs=
X-Google-Smtp-Source: APXvYqwS7/jVWDxxdO3vFWFrJxk/rvAwgPzMxX/zUbyVu9vjR/PCWxENXVbavY/BXmQifut0dJuljQ==
X-Received: by 2002:a1c:44d4:: with SMTP id r203mr9924004wma.158.1559511630396;
        Sun, 02 Jun 2019 14:40:30 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 07/10] net: dsa: sja1105: Move sja1105_is_link_local to include/linux
Date:   Mon,  3 Jun 2019 00:39:23 +0300
Message-Id: <20190602213926.2290-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function will be reused from the .port_rxtstamp callback to see if
the received SKB can be timestamped by the switch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:

Patch is new.

 include/linux/dsa/sja1105.h | 15 +++++++++++++++
 net/dsa/tag_sja1105.c       | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e46e18c47d41..f3237afed35a 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -25,4 +25,19 @@ struct sja1105_port {
 	int mgmt_slot;
 };
 
+/* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
+static inline bool sja1105_is_link_local(const struct sk_buff *skb)
+{
+	const struct ethhdr *hdr = eth_hdr(skb);
+	u64 dmac = ether_addr_to_u64(hdr->h_dest);
+
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_A)
+		return true;
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_B_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_B)
+		return true;
+	return false;
+}
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d840a3749549..e0903028d1cd 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,21 +7,6 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
-/* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
-static inline bool sja1105_is_link_local(const struct sk_buff *skb)
-{
-	const struct ethhdr *hdr = eth_hdr(skb);
-	u64 dmac = ether_addr_to_u64(hdr->h_dest);
-
-	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
-		    SJA1105_LINKLOCAL_FILTER_A)
-		return true;
-	if ((dmac & SJA1105_LINKLOCAL_FILTER_B_MASK) ==
-		    SJA1105_LINKLOCAL_FILTER_B)
-		return true;
-	return false;
-}
-
 /* This is the first time the tagger sees the frame on RX.
  * Figure out if we can decode it, and if we can, annotate skb->cb with how we
  * plan to do that, so we don't need to check again in the rcv function.
-- 
2.17.1

