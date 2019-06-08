Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6BC39FCE
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfFHNEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:04:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43551 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfFHNDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:03:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so4735026wrm.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mfWLb0EWYPqM4Q0OC6o5kRcBWqGopiM+bcboQM4mLfY=;
        b=Kjox+jjQFn9+x5a9qAfJAGqAUhpaeRY1F/L3/7evo6akWelLG8Ucer2JFENbUAW+Rp
         BWvJ8353okkYHzMyqMX148MvMeJtlJtEFoBTnYaRJS+AqmTWsjsLKEH2OFeNgVCYqU7Q
         RLQtx8UEH9Uwk1Bp3sTSIxjj+/+mx1+rG12ryZ6+vTQEQDh+1diZd4nx2x7zvshRuEfH
         w7H1fCuECMydE3vwLs73bvUhaOCuc4gRaZEHHtUxIMjo5sc4rRtPpxLMQHn4HdMes5fs
         0pno25enDFT14KNiTAWC7lFn7qhi0E+VOsNlkvCju7v+TiFlaqWsS6rCCo/z3g/KYhEH
         TFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mfWLb0EWYPqM4Q0OC6o5kRcBWqGopiM+bcboQM4mLfY=;
        b=uIjJ+83yKMa8jJSatZIcRo2y+YfeYV1mG9sBoWRDgo4HfaYQyrkm9bqKbw7F0lmsJO
         Xp4zwM7ZaOhe2oWUpPwzCpkYh6xlhVTttSEt5vNwYn76trPlRK4C9OOxq7S1IH0z6mcu
         P7xKfsMWwxNIsR+bTffBW0VMCIxB4wIDe0LLsZZKwC4zrcbAlPTfP8Y6HTaSoDezwg7q
         S9CVytZ8ucOT7nxpfdlXgek2Wida/OFNatPYgc2PY7C/17JJOasDHkYq14nKPp2YtzGp
         RetmrtIuqfxRzgVIbHiVuF4DknznBuQPZ+cAys8Q9oBc2V3WmlM5z+j+SQ2xYVrIIM34
         pi+A==
X-Gm-Message-State: APjAAAXQ1hRSgiKlY0ciVAxYXQlDrWOOg50TMcYNdBoacAdL5dtuOlZo
        SzMISfcGsf1NS4BNMI6Ygac=
X-Google-Smtp-Source: APXvYqwAcxPxIdPiVXoE/kWu18Dath2NwCHg38/DiPymml9NnZ/eg38vACqEfnFP2cKGLEjuARTL0w==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr3112212wrm.55.1559999033240;
        Sat, 08 Jun 2019 06:03:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id 128sm4632766wme.12.2019.06.08.06.03.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:03:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/4] net: dsa: sja1105: Export the sja1105_inhibit_tx function
Date:   Sat,  8 Jun 2019 16:03:43 +0300
Message-Id: <20190608130344.661-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608130344.661-1-olteanv@gmail.com>
References: <20190608130344.661-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to stop egress traffic in .phylink_mac_link_up.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     |  2 ++
 drivers/net/dsa/sja1105/sja1105_spi.c | 14 ++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 38b6c7c7db86..ed66d00eb394 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -138,6 +138,8 @@ int sja1105_spi_send_long_packed_buf(const struct sja1105_private *priv,
 				     sja1105_spi_rw_mode_t rw, u64 base_addr,
 				     void *packed_buf, u64 buf_len);
 int sja1105_static_config_upload(struct sja1105_private *priv);
+int sja1105_inhibit_tx(const struct sja1105_private *priv,
+		       unsigned long port_bitmap, bool tx_inhibited);
 
 extern struct sja1105_info sja1105e_info;
 extern struct sja1105_info sja1105t_info;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d729a0f0b28e..d7ff74259b31 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -285,20 +285,22 @@ static int sja1105_cold_reset(const struct sja1105_private *priv)
 	return priv->info->reset_cmd(priv, &reset);
 }
 
-static int sja1105_inhibit_tx(const struct sja1105_private *priv,
-			      const unsigned long *port_bitmap)
+int sja1105_inhibit_tx(const struct sja1105_private *priv,
+		       unsigned long port_bitmap, bool tx_inhibited)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u64 inhibit_cmd;
-	int port, rc;
+	int rc;
 
 	rc = sja1105_spi_send_int(priv, SPI_READ, regs->port_control,
 				  &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
 	if (rc < 0)
 		return rc;
 
-	for_each_set_bit(port, port_bitmap, SJA1105_NUM_PORTS)
-		inhibit_cmd |= BIT(port);
+	if (tx_inhibited)
+		inhibit_cmd |= port_bitmap;
+	else
+		inhibit_cmd &= ~port_bitmap;
 
 	return sja1105_spi_send_int(priv, SPI_WRITE, regs->port_control,
 				    &inhibit_cmd, SJA1105_SIZE_PORT_CTRL);
@@ -415,7 +417,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	 * Tx on all ports and waiting for current packet to drain.
 	 * Otherwise, the PHY will see an unterminated Ethernet packet.
 	 */
-	rc = sja1105_inhibit_tx(priv, &port_bitmap);
+	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to inhibit Tx on ports\n");
 		return -ENXIO;
-- 
2.17.1

