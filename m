Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CEE6C54CA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCVTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCVTV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:21:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B011F637E0;
        Wed, 22 Mar 2023 12:21:26 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id y14so18216880wrq.4;
        Wed, 22 Mar 2023 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679512885;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJENhm8ShO0PGzLw3S99cPmiVxD1DZ2HE0JEziChhl8=;
        b=OeXlljxwgtvGbBkwUfhHaORzvJTxBN3WOP00Do+v7XDi9ICYzhtwrVH8YazkLsL9cq
         0ejnDRJwhJ/xf0rxcVJE+/ipoIfE03WQFsItUOa77GK21LyUHvT5bMil6uPNxR5m+OTv
         CE1/Leb7/lId5w3Oa5wJqT3d94QhTvSBApjO2caHbm90kYleVSf/PXro7l75blpCew49
         e5nMLmCw+vfKuQWMcHrGsVFQJ8vbddqnzyaM14F8tibc+/tqQuQMymZRG9Zdi4NCdTAQ
         7Z+z+an9viYNOwOGLlSIJ9tmMX9OFCuEFailgMwUxgClacgP9S7z6lvgFsCISIshSOTc
         dr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679512885;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJENhm8ShO0PGzLw3S99cPmiVxD1DZ2HE0JEziChhl8=;
        b=nMXFEXHF2IqyZ7fjcQ4MatV8jxDsGo49hOiuYQL3KHxoFIzN0wBQ3eEKwd7qTlr/rU
         VEosBI0I4oPdazz546KZbOHIFlQAYyYPZqZ8HY5tf4Qx1HOhXuFNYWEU4lqxfoOALmFC
         YSAnM3KL4pnZBFOKwCEoNdMBVTwvBi6CS4wM9ME7ev3LOA2CW3Y+gEfIjfjN8A9/USfs
         4Q36lvm+XpOiZH7D61dM8NourDakYYe7G8IFZMi6yg6NObF+CeP5uqjHOpfSisJC/ohy
         1JFdno5cY9y5+CJuh23gajT6liir/KFPH5bzVaCxN2rx/KT+if6Ip2fDXj9RfvafyR3M
         I4rw==
X-Gm-Message-State: AAQBX9eKy/oKvvj8XO1n5Oj6W3fXFnnvHZCupbIWEuPssK9Q6P4cVJpk
        S/X1DGLcKFxyd6zaHc0Zry94ziHJPLx4kIjX
X-Google-Smtp-Source: AKy350bnyPGFwFAGEI3db5guKJe9Ckq4bHVhrNmOKxHrndmmnvcLhbdDU5ftfgrIuVX0lTNfWv6xtQ==
X-Received: by 2002:a5d:570e:0:b0:2d1:e3b7:26ad with SMTP id a14-20020a5d570e000000b002d1e3b726admr709815wrv.61.1679512884832;
        Wed, 22 Mar 2023 12:21:24 -0700 (PDT)
Received: from khadija-virtual-machine ([39.41.14.14])
        by smtp.gmail.com with ESMTPSA id r10-20020adfce8a000000b002cefcac0c62sm14595548wrn.9.2023.03.22.12.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:21:24 -0700 (PDT)
Date:   Thu, 23 Mar 2023 00:21:22 +0500
From:   Khadija Kamran <kamrankhadijadj@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: avoid multiple assignments
Message-ID: <ZBtVMs1wHWyyl2A6@khadija-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux kernel coding style does not allow multiple assignments on a
single line.
Avoid multiple assignments by assigning value to each variable in a
separate line.

Signed-off-by: Khadija Kamran <kamrankhadijadj@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1ead7793062a..b35fb7db2a77 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4085,7 +4085,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	int i;
 
 	/* Get RX stats. */
-	pkts = mcast = dropped = errors = bytes = 0;
+	pkts = 0;
+	mcast = 0;
+	dropped = 0;
+	errors = 0;
+	bytes = 0;
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
 		pkts += rx_ring->rx_packets;
 		bytes += rx_ring->rx_bytes;
@@ -4100,7 +4104,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	ndev->stats.multicast = mcast;
 
 	/* Get TX stats. */
-	pkts = errors = bytes = 0;
+	pkts = 0;
+	errors = 0;
+	bytes = 0;
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
 		pkts += tx_ring->tx_packets;
 		bytes += tx_ring->tx_bytes;
-- 
2.34.1

