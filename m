Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE93F5F45
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfKIND2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:28 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40287 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfKIND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so8875662wmc.5
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I5NrnqHMz0H+o/yy3vUFASYNzpbn88bPQQg+Vg1+dg8=;
        b=OhAbvXvZbTQrRmevzgSoybqsEP67BMGZ/bUe2lCO7PILolKxWQGfqRJdKiwonuGKkB
         /wpXEn1H5eZchiaRtTXCQA1DR2+i06li3ugZyszKd0SqI247rZK0RFfddBagGDTux6TD
         IzZqYeMNJmYU2KZK0OwyrkAwvZowNgXGZFo3v48LYITNTwUyD15jbJbtgOFZZQrkMlRi
         Let2V1Fy7TS3kDStzjmMmdWC4pH1kQ/oNBCBQ4/wllBmI0q8JYQuDVZ/hj3nnOpYmXdC
         OS0dS9cuPioj1I5qU6W2w6wN+ytp0HKkD5R8BSa65e8LJqWVyXsxFLZQXfnOV2ACwQfT
         F50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I5NrnqHMz0H+o/yy3vUFASYNzpbn88bPQQg+Vg1+dg8=;
        b=tK/HmRLUkeO7uWFiZN9XhQiq/q0MPv5jhL1HwYC1LxiR9BjWFtn5hvAG87NzaLePAt
         gVmLSN18I87OwvR6xL1Blm5r0htGkFE1TLcqm3cJRFtFI2KNWuXzqLELhQ7nKP5nxOXm
         WBzi3ez+af8fE61p0EoBGTsOYcA4G0+RkybhSi5PS+7UrolE4t5TalWK5P6EABFeKaJa
         sVWXnVfo/nb+BYIH7O9VmOGjA7SmFe8IdvWrnP2TCgMDDWUyxQh6LeLADRewmsBGUwW1
         oHjRryEC+ATRaDmFs77khOCarrwGQLF+O3nrmVR65XwEM1MUkGy0NqcWn0dhMYMJioNu
         6t7g==
X-Gm-Message-State: APjAAAU+aU3EdwXP7qQ51BO7DX9OkQvI7LvN9K1jiuPCaHOUwTordvwI
        y+eOCJLttMaCgUERcSHnpwU=
X-Google-Smtp-Source: APXvYqxsLHRUtw7OVAGDU5zplo1a+VFrt6ft4ZwXqmExDBJsCyDfUc8j1txP21fK0iYpVhoBTfu+Eg==
X-Received: by 2002:a1c:16:: with SMTP id 22mr13534424wma.0.1573304604117;
        Sat, 09 Nov 2019 05:03:24 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/15] net: mscc: ocelot: change prototypes of hwtstamping ioctls
Date:   Sat,  9 Nov 2019 15:02:50 +0200
Message-Id: <20191109130301.13716-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is needed in order to present a simpler prototype to the DSA
front-end of ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3e03c4dd80a0..8b7d46693e49 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1062,17 +1062,17 @@ static int ocelot_get_port_parent_id(struct net_device *dev,
 	return 0;
 }
 
-static int ocelot_hwstamp_get(struct ocelot_port *port, struct ifreq *ifr)
+static int ocelot_hwstamp_get(struct ocelot *ocelot, int port,
+			      struct ifreq *ifr)
 {
-	struct ocelot *ocelot = port->ocelot;
-
 	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
 			    sizeof(ocelot->hwtstamp_config)) ? -EFAULT : 0;
 }
 
-static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
+static int ocelot_hwstamp_set(struct ocelot *ocelot, int port,
+			      struct ifreq *ifr)
 {
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct hwtstamp_config cfg;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
@@ -1085,16 +1085,16 @@ static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
 	/* Tx type sanity check */
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_ON:
-		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		ocelot_port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
 		 * need to update the origin time.
 		 */
-		port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
+		ocelot_port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
 		break;
 	case HWTSTAMP_TX_OFF:
-		port->ptp_cmd = 0;
+		ocelot_port->ptp_cmd = 0;
 		break;
 	default:
 		return -ERANGE;
@@ -1136,8 +1136,9 @@ static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
 
 static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 
 	/* The function is only used for PTP operations for now */
 	if (!ocelot->ptp)
@@ -1145,9 +1146,9 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
-		return ocelot_hwstamp_set(port, ifr);
+		return ocelot_hwstamp_set(ocelot, port, ifr);
 	case SIOCGHWTSTAMP:
-		return ocelot_hwstamp_get(port, ifr);
+		return ocelot_hwstamp_get(ocelot, port, ifr);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

