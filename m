Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8045814C496
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 03:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA2CXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 21:23:49 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46925 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgA2CXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 21:23:49 -0500
Received: by mail-qt1-f194.google.com with SMTP id e25so12061983qtr.13;
        Tue, 28 Jan 2020 18:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fmN/pVtssbxT3Pr5E1F9HLzDYsx7npNCg2efVd+HMmU=;
        b=OxoOoF+opyfGT2RgfPxdawFxkuh2UuO88c43wgqkxKX7h8VjOsaRzOUKTkvhcexFIm
         BkLKKb3QL6sMpivexvacVqQUGTZYj6RPSShoUTiBt6m/GEJRs47V9mXFLS3xzQH0fvkD
         Y3C3AZtIA71On7O5NoBWdcdBfIQs3fumTvYXe17lp/X0O2+2wysxhPv/yAdPEsVB3sAi
         BcYqk1Xj+p8rmjIbSeAYRXNiI3TXB3S77tzjPVg8TU2PQczyOlCyU8Od+OGZ/J4aN9ix
         2JZmHKb+5oizxYQL7QfYV1OKcQInAhL520+Th49xqlHGHaGaqZ7jv/aeJFvrdgn8v3hP
         WxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fmN/pVtssbxT3Pr5E1F9HLzDYsx7npNCg2efVd+HMmU=;
        b=IfPhHZ8w6u5qQd2DQoMSMr/Ee724WYi8PtFhdZ43iOccqYko/qznAjog0kspLnGHw6
         2w+dr6RWbIP2sijqHq+cFBvjk0Tk5iWvnuzsEbSZzRfNm/u4/q2u611JtoU6udivhij1
         D/eVrBH/PKomxj5Xi5ua0MKU+WFQjiWIoNSC6P8hjZATnnit3sZRD0dEhilSNy/UAs7d
         1e4xmNMLfUvQs0u4bu0+eQQRBmv7oAWvkgViotfmSsMNts5+PpEjp/xFpwF8NjdaS3bi
         f9r5fbyndBEvPHWNSPGjLvbT3pg1Bnu5n+5tLPTw04bIbnoZTp1pRbS+pvpb9/0/h2NV
         b/vg==
X-Gm-Message-State: APjAAAXJiq39CbQ9/ktCUZBxXJVK3PL1hsQxqznaTMtoaw9z8mEXaVE3
        UO6ahyZz6rkqx12EiowBnuQ=
X-Google-Smtp-Source: APXvYqwJNswIDThK6W3MZT1fUSKJlN04cThEvGug0a8dB7p3RuNSeFkYQCH79ohw24gi643c1UD/tw==
X-Received: by 2002:ac8:1e90:: with SMTP id c16mr24682771qtm.265.1580264627998;
        Tue, 28 Jan 2020 18:23:47 -0800 (PST)
Received: from localhost ([209.222.10.104])
        by smtp.gmail.com with ESMTPSA id x3sm300278qts.35.2020.01.28.18.23.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 18:23:47 -0800 (PST)
From:   Wu Bo <wubo.oduw@gmail.com>
Cc:     Wu Bo <wubo.oduw@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: m_can: the state change mistake
Date:   Wed, 29 Jan 2020 10:23:30 +0800
Message-Id: <20200129022330.21248-2-wubo.oduw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200129022330.21248-1-wubo.oduw@gmail.com>
References: <20200129022330.21248-1-wubo.oduw@gmail.com>
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new state is change to CAN_STATE_ERROR_WARNING, but the value of
switch case is CAN_STATE_ERROR_ACTIVE.

Signed-off-by: Wu Bo <wubo.oduw@gmail.com>
---
 drivers/net/can/m_can/m_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b7393..63887e23d89c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -665,7 +665,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	unsigned int ecr;
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cdev->can.can_stats.error_warning++;
 		cdev->can.state = CAN_STATE_ERROR_WARNING;
@@ -694,7 +694,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	__m_can_get_berr_counter(dev, &bec);
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL;
 		cf->data[1] = (bec.txerr > bec.rxerr) ?
-- 
2.17.1

