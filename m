Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD760F648
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiJ0Lfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiJ0LfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:35:25 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF7529820
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:35:19 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id l11so996630edb.4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AzdZHpKKZZPwJRfMRJ8wftbQ3WQ2gBJ+jR3YkWH1x8Q=;
        b=n0XmgSbz8od0+n9gp2zw5KPnVgTipSp/nNmypN2HEZPvWlXH51ber0ViZepLYR7DQ7
         TfcDntqAuJ45KK5hp458n9MTyI6IEqgOuj5l4P4O6v95ZngjwcXQWnGvoR9JxjJbDbQ4
         aWTxmXAApLHK+XGaErWlo1bZEcnwW1xrW2aOgiJOZZxElPHrFya7lFNYomZuk13OIrro
         hdltodac0Z42ANgs957FlUqbx8GsFRomRL6/dSv5FGg7doRebp/T6x8HQtFoR+eFGRd1
         87QvuDBgaF++uYqDCVNUevYJNdABS+F1isbWloQGfmMGtOTQxqLaDsLj3SRFt/NdsTmB
         dD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzdZHpKKZZPwJRfMRJ8wftbQ3WQ2gBJ+jR3YkWH1x8Q=;
        b=sClCBbuFEXfZQIydmPwHGd9qBhWO1PjIbNQprJNkn1Vpearw1RSBthDcWwb+BQ/zRs
         Kw6wAT0+mcNZJKR4HapM4eFITykWBAq40avA7p7z3Zh/Mi+lR5GM7nqRojAisNZvC6LE
         +biag2f2wroGlhtSYBqQJRMBmtRsyHFNlvVzy47v9kzTZIT2JplA2VZFM2ZA1pITvvVs
         YN70SZEnovVUUkYECjmQu6HwjNU5S8GUxMI/lg2n+4+Yv/wM9B1zZlbDZzySl4+TH6SF
         5IQWla63Ljhqsdij1MK9TQHW6c9nOc2MKKwWB3A/U8jTiYSpWe0QDiITBb6ofdblgga1
         4itg==
X-Gm-Message-State: ACrzQf0znqRKO48eDcHeA40kRRv74GU48c0MzxUaBMG5mRBQ/JJNbs0f
        p/0bnNg519ST218GXWG6l7Jh4ETrUQWXpg==
X-Google-Smtp-Source: AMsMyM7sEHowwsEYp0xrXQcuEMyZQZWYTjcK0bx9Fvk23pf2BNKRxmZtSnuFZWyVpBkpFEL0sSXCXA==
X-Received: by 2002:a05:6402:1052:b0:459:2c49:1aed with SMTP id e18-20020a056402105200b004592c491aedmr45231961edu.212.1666870518018;
        Thu, 27 Oct 2022 04:35:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id oz13-20020a170906cd0d00b007ad2da5668csm651413ejb.112.2022.10.27.04.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 04:35:17 -0700 (PDT)
Date:   Thu, 27 Oct 2022 14:35:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH v5 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221027113513.rqraayuo64zxugbs@skbuf>
References: <20221024175823.145894-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="soksh6li3vhvjwml"
Content-Disposition: inline
In-Reply-To: <20221024175823.145894-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--soksh6li3vhvjwml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sergei,

On Mon, Oct 24, 2022 at 08:58:23PM +0300, Sergei Antonov wrote:
> The ftmac100 controller considers packets >1518 (1500 + Ethernet + FCS)
> FTL (frame too long) and drops them. That is fine with mtu 1500 or less
> and it saves CPU time. When DSA is present, mtu is bigger (for VLAN
> tagging) and the controller's built-in behavior is not desired then. We
> can make the controller deliver FTL packets to the driver by setting
> FTMAC100_MACCR_RX_FTL. Then we have to check ftmac100_rxdes_frame_length()
> (packet length sans FCS) on packets marked with FTMAC100_RXDES0_FTL flag.
> 
> Check for mtu > 1500 in .ndo_open() and set FTMAC100_MACCR_RX_FTL to let
> the driver FTL packets. Implement .ndo_change_mtu() and check for
> mtu > 1500 to set/clear FTMAC100_MACCR_RX_FTL dynamically.
> 
> Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> ---

I think it's clear there are problems in communication between us, so
let me try differently.

Does the attached series of 3 patches work for you? I only compile
tested them.

I tried to keep as much of your work and authorship as possible, the
intention was to rewrite the justification in the commit message and to
fix the things which your patches didn't do (as separate patches).

--soksh6li3vhvjwml
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-ftmac100-prepare-data-path-for-receiving-single-.patch"

From 97be2778e5eec620d7b65c30cda3a70b9af0a88c Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 27 Oct 2022 13:54:21 +0300
Subject: [PATCH 1/3] net: ftmac100: prepare data path for receiving single
 segment packets > 1514

Eliminate one check in the data path and move it elsewhere, to where our
real limitation is. We'll want to start processing "too long" frames in
the driver (currently there is a hardware MAC setting which drops
theses).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 29 ++++++++++---------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..8013f85fc148 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -218,11 +218,6 @@ static bool ftmac100_rxdes_crc_error(struct ftmac100_rxdes *rxdes)
 	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_CRC_ERR);
 }
 
-static bool ftmac100_rxdes_frame_too_long(struct ftmac100_rxdes *rxdes)
-{
-	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_FTL);
-}
-
 static bool ftmac100_rxdes_runt(struct ftmac100_rxdes *rxdes)
 {
 	return rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_RUNT);
@@ -337,13 +332,7 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		error = true;
 	}
 
-	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
-		if (net_ratelimit())
-			netdev_info(netdev, "rx frame too long\n");
-
-		netdev->stats.rx_length_errors++;
-		error = true;
-	} else if (unlikely(ftmac100_rxdes_runt(rxdes))) {
+	if (unlikely(ftmac100_rxdes_runt(rxdes))) {
 		if (net_ratelimit())
 			netdev_info(netdev, "rx runt\n");
 
@@ -356,6 +345,11 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		netdev->stats.rx_length_errors++;
 		error = true;
 	}
+	/*
+	 * FTMAC100_RXDES0_FTL is not an error, it just indicates that the
+	 * frame is longer than 1518 octets. Receiving these is possible when
+	 * we told the hardware not to drop them, via FTMAC100_MACCR_RX_FTL.
+	 */
 
 	return error;
 }
@@ -400,12 +394,13 @@ static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
 		return true;
 	}
 
-	/*
-	 * It is impossible to get multi-segment packets
-	 * because we always provide big enough receive buffers.
-	 */
+	/* We don't support multi-segment packets for now, so drop them. */
 	ret = ftmac100_rxdes_last_segment(rxdes);
-	BUG_ON(!ret);
+	if (unlikely(!ret)) {
+		netdev->stats.rx_length_errors++;
+		ftmac100_rx_drop_packet(priv);
+		return true;
+	}
 
 	/* start processing */
 	skb = netdev_alloc_skb_ip_align(netdev, 128);
-- 
2.34.1


--soksh6li3vhvjwml
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-net-ftmac100-report-the-correct-maximum-MTU-of-1500.patch"

From 3574f1730e262154e901da140baca76463d0bc3f Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 27 Oct 2022 13:59:03 +0300
Subject: [PATCH 2/3] net: ftmac100: report the correct maximum MTU of 1500

The driver uses the MAX_PKT_SIZE (1518) for both MTU reporting and for
TX. However, the 2 places do not measure the same thing.

On TX, skb->len measures the entire L2 packet length (without FCS, which
software does not possess). So the comparison against 1518 there is
correct.

What is not correct is the reporting of dev->max_mtu as 1518. Since MTU
measures L2 *payload* length (excluding L2 overhead) and not total L2
packet length, it means that the correct max_mtu supported by this
device is the standard 1500. Anything higher than that will be dropped
on RX currently.

To fix this, subtract VLAN_ETH_HLEN from MAX_PKT_SIZE when reporting the
max_mtu, since that is the difference between L2 payload length and
total L2 length as seen by software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 8013f85fc148..7c571b4515a9 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1070,7 +1071,7 @@ static int ftmac100_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	netdev->ethtool_ops = &ftmac100_ethtool_ops;
 	netdev->netdev_ops = &ftmac100_netdev_ops;
-	netdev->max_mtu = MAX_PKT_SIZE;
+	netdev->max_mtu = MAX_PKT_SIZE - VLAN_ETH_HLEN;
 
 	err = platform_get_ethdev_address(&pdev->dev, netdev);
 	if (err == -EPROBE_DEFER)
-- 
2.34.1


--soksh6li3vhvjwml
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-net-ftmac100-allow-increasing-MTU-to-make-most-use-o.patch"

From 893e534e7196ba1dee398e1f77e906d76e8c5a3f Mon Sep 17 00:00:00 2001
From: Sergei Antonov <saproj@gmail.com>
Date: Thu, 27 Oct 2022 14:06:59 +0300
Subject: [PATCH 3/3] net: ftmac100: allow increasing MTU to make most use of
 single-segment buffers

If the FTMAC100 is used as a DSA master, then it is expected that frames
which are MTU sized on the wire facing the external switch port (1500
octets in L2 payload, plus L2 header) also get a DSA tag when seen by
the host port.

This extra tag increases the length of the packet as the host port sees
it, and the FTMAC100 is not prepared to handle frames whose length
exceeds 1518 octets (including FCS) at all.

Only a minimal rework is needed to support this configuration. Since
MTU-sized DSA-tagged frames still fit within a single buffer (RX_BUF_SIZE),
we just need to optimize the resource management rather than implement
multi buffer RX.

In ndo_change_mtu(), we toggle the FTMAC100_MACCR_RX_FTL bit to tell the
hardware to drop (or not) frames with an L2 payload length larger than
1500. We need to replicate the MACCR configuration in ftmac100_start_hw()
as well, since there is a hardware reset there which clears previous
settings.

The advantage of dynamically changing FTMAC100_MACCR_RX_FTL is that when
dev->mtu is at the default value of 1500, large frames are automatically
dropped in hardware and we do not spend CPU cycles dropping them.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 33 +++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 7c571b4515a9..6c8c78018ce6 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -28,8 +29,8 @@
 #define RX_QUEUE_ENTRIES	128	/* must be power of 2 */
 #define TX_QUEUE_ENTRIES	16	/* must be power of 2 */
 
-#define MAX_PKT_SIZE		1518
 #define RX_BUF_SIZE		2044	/* must be smaller than 0x7ff */
+#define MAX_PKT_SIZE		RX_BUF_SIZE /* multi-segment not supported */
 
 #if MAX_PKT_SIZE > 0x7ff
 #error invalid MAX_PKT_SIZE
@@ -160,6 +161,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 static int ftmac100_start_hw(struct ftmac100 *priv)
 {
 	struct net_device *netdev = priv->netdev;
+	unsigned int maccr = MACCR_ENABLE_ALL;
 
 	if (ftmac100_reset(priv))
 		return -EIO;
@@ -176,7 +178,11 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
 
 	ftmac100_set_mac(priv, netdev->dev_addr);
 
-	iowrite32(MACCR_ENABLE_ALL, priv->base + FTMAC100_OFFSET_MACCR);
+	 /* See ftmac100_change_mtu() */
+	if (netdev->mtu > ETH_DATA_LEN)
+		maccr |= FTMAC100_MACCR_RX_FTL;
+
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
 	return 0;
 }
 
@@ -1033,6 +1039,28 @@ static int ftmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int c
 	return generic_mii_ioctl(&priv->mii, data, cmd, NULL);
 }
 
+static int ftmac100_change_mtu(struct net_device *netdev, int mtu)
+{
+	struct ftmac100 *priv = netdev_priv(netdev);
+	unsigned int maccr;
+
+	maccr = ioread32(priv->base + FTMAC100_OFFSET_MACCR);
+	if (mtu > ETH_DATA_LEN) {
+		/* process long packets in the driver */
+		maccr |= FTMAC100_MACCR_RX_FTL;
+	} else {
+		/* Let the controller drop incoming packets greater
+		 * than 1518 (that is 1500 + 14 Ethernet + 4 FCS).
+		 */
+		maccr &= ~FTMAC100_MACCR_RX_FTL;
+	}
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
+
+	netdev->mtu = mtu;
+
+	return 0;
+}
+
 static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_open		= ftmac100_open,
 	.ndo_stop		= ftmac100_stop,
@@ -1040,6 +1068,7 @@ static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_eth_ioctl		= ftmac100_do_ioctl,
+	.ndo_change_mtu		= ftmac100_change_mtu,
 };
 
 /******************************************************************************
-- 
2.34.1


--soksh6li3vhvjwml--
