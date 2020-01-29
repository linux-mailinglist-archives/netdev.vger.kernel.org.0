Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE1714C493
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 03:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgA2CXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 21:23:38 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39059 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgA2CXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 21:23:38 -0500
Received: by mail-qt1-f194.google.com with SMTP id c5so2570791qtj.6;
        Tue, 28 Jan 2020 18:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fmN/pVtssbxT3Pr5E1F9HLzDYsx7npNCg2efVd+HMmU=;
        b=QBgG2VEcnqZ+75WvmHHQDCu0DVOaEAm7gKkBtuRdPRSKVXgX7VybeZ6nSLCtbnBGtq
         UPVZ5p/NRTacrxdm5LOn4YTS2RVxkbdNuklfw+tLMQ+NiSlws8WfKkZwbZMzuIe9u+6Y
         rZgDvgO+PVkVs2vq8JRpRjJH1/MsHkCzVjaixUzXAbRKytiUfzhbhtLtshPPtoxy4GZW
         3aWiQyPZfblfd/QTJrOBONXR0xCc9BTQJ9o6cy3Ig6+BkO7WsfeO7+oBoR0E0Wt16W1X
         j+y8zzyP1Cpt+XsC/ZfbuZKwf7xX/PfmsyOXcchNJZBhN5LdhCDuYFpq5W/IyOBOUWsR
         6Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fmN/pVtssbxT3Pr5E1F9HLzDYsx7npNCg2efVd+HMmU=;
        b=t9bDXe4AykBwGpF6oD5ObnRVMfN4Wc+YG9oQDI1kuq2PCsGt9oinO5NLV/qJH5zfYC
         6eFBoVtDoG8tCTqqoIvE7Z27wqMDk9SMZpM2jErRmRtp2y3kD6vvJTNU5ChEoHgYFbMr
         2i1aKjvQFjT9auLz6hEMa0f3mgPVX8B8EISQ/toOwqMIpLcAHpgJDANuT8K5kgS4g3ZR
         n7VVEUysByw+WrcnW7Gk9JKovk34RT28MLo/9p8ujGRqB1arULeZsHJtvYe4JNmIKWq4
         BUBLe4hmEv1jeVxAK9WLhA7KrX2PkviPEn48xdKCBxxp58ITUfhajup/KEC8a7/YDKFD
         ghcw==
X-Gm-Message-State: APjAAAW16TcPd218SAqhSlmzcRvjYHPzgd7VVorN/nNwpaCGdtNrvBmA
        0uRrn59Cjlyt3Ox2ixFQOiQ=
X-Google-Smtp-Source: APXvYqyNA49ujrtKNcqXZwElb1RXS2xg+isb9ANhOquR30a4f55p2QQEwGGEfffQDYg2TuhvAW7OWg==
X-Received: by 2002:ac8:71cf:: with SMTP id i15mr24882255qtp.383.1580264617446;
        Tue, 28 Jan 2020 18:23:37 -0800 (PST)
Received: from localhost ([209.222.10.104])
        by smtp.gmail.com with ESMTPSA id f10sm241377qkk.70.2020.01.28.18.23.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 18:23:37 -0800 (PST)
From:   Wu Bo <wubo.oduw@gmail.com>
Cc:     Wu Bo <wubo.oduw@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: m_can: the state change mistake
Date:   Wed, 29 Jan 2020 10:23:29 +0800
Message-Id: <20200129022330.21248-1-wubo.oduw@gmail.com>
X-Mailer: git-send-email 2.17.1
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

