Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFA22F5BDC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbhANH6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbhANH6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:58:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D7C06138D
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUn-0007Zh-4G
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4A2105C36A2
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6FB455C3633;
        Thu, 14 Jan 2021 07:56:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 38ddc252;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 17/17] can: tcan4x5x: remove __packed attribute from struct tcan4x5x_map_buf
Date:   Thu, 14 Jan 2021 08:56:17 +0100
Message-Id: <20210114075617.1402597-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first member of struct tcan4x5x_map_buf is the struct tcan4x5x_buf_cmd,
which has a size of 4 bytes. It's followed by an array of u8. The compiler
places the array directly after the struct tcan4x5x_buf_cmd.

This patch removes the not needed attribute __packed from the struct
tcan4x5x_map_buf.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20210113203955.912916-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.h b/drivers/net/can/m_can/tcan4x5x.h
index 7bf264f8e81f..c66da829b795 100644
--- a/drivers/net/can/m_can/tcan4x5x.h
+++ b/drivers/net/can/m_can/tcan4x5x.h
@@ -25,7 +25,7 @@ struct __packed tcan4x5x_buf_cmd {
 	u8 len;
 };
 
-struct __packed tcan4x5x_map_buf {
+struct tcan4x5x_map_buf {
 	struct tcan4x5x_buf_cmd cmd;
 	u8 data[256 * sizeof(u32)];
 } ____cacheline_aligned;
-- 
2.29.2


