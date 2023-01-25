Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5447467BB0F
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbjAYTvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbjAYTvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:51:09 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FFF589BF
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:08 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bk15so50540253ejb.9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMj657mIBfjdrk+ldR8wMbHCeTfGxrOBp5iVvF9MTxo=;
        b=EFj5BZjAFL8VzzzsMv8HLmG2IMjSc/WtgRSZNYk8gLngSYkDAB7eJ0/CCLwCKDaI8l
         uL+WH4aSlWtfVc22Wv6c8qjPoM+sYBY6mLCHZ7gdQcFQi5JeTiDfy4gtv54pZ7l6soPz
         gQqOL6bmeJip0Aj839wyJTatzTopDCW6oma33LKx2tWRNP7+NE6T1zYTt7WOKyxx0B8S
         qzEBX/o0L1jrYmx/lWwxUqgK3kfSiaFXGSFeUUUZxiIwHRvITJLCcZCjVM1HI8mSuqbW
         nEvIPqZQkpRs4Wm6SrBwyTohOrAoAXEcxldQwfcvvWBAV+gwQNILpSIq7q1/rASXR+v2
         MGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMj657mIBfjdrk+ldR8wMbHCeTfGxrOBp5iVvF9MTxo=;
        b=p+ahuAuBEeboG7G2phujtnuulWLRPNVGCm2YFZDAMq4AQh7WP1BAkns5hicu+wYKOv
         3oEYelLDQBzdOOj6Tqpd7g/qDLzFZcQc2N2sTI5x3pnAEO9xaCjRqUoCYMw5UhMfZ7rU
         /Kzqw6tOxClWgibydZkW0s/Y6lN/8BhvmM9GUhk0orQ6DdSc1Re05TVKsh1fWOG0vkmt
         y+n/wpDua1t8fVFOHL1wFW1Dvt0uphx2MX+aH835CrP2v1MCgSXPFWblR1IFW761Mw4s
         A4UdU8yzzQFWs/47oGFdj+qC7kw76jQwt/qHRuIFKrOyTB22BiuGtl6IGfXCpPyzYpnP
         dvqw==
X-Gm-Message-State: AFqh2koU90EWQDfSGV/IRUIAPLRLfstXrotZE+iLWLUIrbdM0yOdSiNG
        rKNACiD0iPTfNuR2JQWDS5txfQ==
X-Google-Smtp-Source: AMrXdXuix7QsoU2d1BVeDRHLLsHMUpywYIGfZKQCAfkvSm7YyMcgG+rSDb7g9hNSI6FN2I92yX2WIQ==
X-Received: by 2002:a17:906:644f:b0:877:6549:bb6 with SMTP id l15-20020a170906644f00b0087765490bb6mr27947745ejn.58.1674676267325;
        Wed, 25 Jan 2023 11:51:07 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:06 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 03/18] can: m_can: Remove repeated check for is_peripheral
Date:   Wed, 25 Jan 2023 20:50:44 +0100
Message-Id: <20230125195059.630377-4-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125195059.630377-1-msp@baylibre.com>
References: <20230125195059.630377-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge both if-blocks to fix this.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8ccf20f093f8..33abe938c30b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1592,10 +1592,8 @@ static int m_can_close(struct net_device *dev)
 		cdev->tx_skb = NULL;
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
-	}
-
-	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
+	}
 
 	close_candev(dev);
 
-- 
2.39.0

