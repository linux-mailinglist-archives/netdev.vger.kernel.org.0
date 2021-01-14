Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2739A2F5BDF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhANH6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbhANH60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:58:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8760C0617BD
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUg-0007QJ-JW
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2F7465C3664
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 66B625C360F;
        Thu, 14 Jan 2021 07:56:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0bc4927c;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 10/17] can: length: canfd_sanitize_len(): add function to sanitize CAN-FD data length
Date:   Thu, 14 Jan 2021 08:56:10 +0100
Message-Id: <20210114075617.1402597-11-mkl@pengutronix.de>
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

The data field in CAN-FD frames have specifig frame length (0, 1, 2, 3, 4, 5,
6, 7, 8, 12, 16, 20, 24, 32, 48, 64). This function "rounds" up a given length
to the next valid CAN-FD frame length.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/length.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 156b9d17969a..b2313b2a0b02 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -45,4 +45,10 @@ u8 can_fd_dlc2len(u8 dlc);
 /* map the sanitized data length to an appropriate data length code */
 u8 can_fd_len2dlc(u8 len);
 
+/* map the data length to an appropriate data link layer length */
+static inline u8 canfd_sanitize_len(u8 len)
+{
+	return can_fd_dlc2len(can_fd_len2dlc(len));
+}
+
 #endif /* !_CAN_LENGTH_H */
-- 
2.29.2


