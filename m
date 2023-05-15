Return-Path: <netdev+bounces-2787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F312703F22
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 830621C20CDD
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3027F19E52;
	Mon, 15 May 2023 20:58:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260541B91D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:41 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1279EFF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:58:21 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfGj-0006kt-Vw
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:58:10 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id B3A151C5D25
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 597D91C5CCA;
	Mon, 15 May 2023 20:58:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bd9c85fd;
	Mon, 15 May 2023 20:58:02 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/22] can: length: make header self contained
Date: Mon, 15 May 2023 22:57:45 +0200
Message-Id: <20230515205759.1003118-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230515205759.1003118-1-mkl@pengutronix.de>
References: <20230515205759.1003118-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Include the headers that "can/length.h" depends on.

Fixes: bdd2e413192d ("can: dev: move length related code into seperate file")
Link: https://lore.kernel.org/all/20230509122854.350426-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/length.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 6995092b774e..69336549d24f 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -6,6 +6,9 @@
 #ifndef _CAN_LENGTH_H
 #define _CAN_LENGTH_H
 
+#include <linux/can.h>
+#include <linux/can/netlink.h>
+
 /*
  * Size of a Classical CAN Standard Frame
  *
-- 
2.39.2



