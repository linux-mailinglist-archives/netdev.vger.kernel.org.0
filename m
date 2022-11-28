Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A5463B00E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiK1RsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiK1RrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:47:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A72DAA2;
        Mon, 28 Nov 2022 09:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2CC2B80EA3;
        Mon, 28 Nov 2022 17:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51BAC43470;
        Mon, 28 Nov 2022 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657318;
        bh=jUDzZJ+9gbnJSmwflUWjzcN0SysIAAV0qnVuBdR5qDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLTniWOfER29UviMA/3hXo4fxZajIRvgjOgZrxyRckBDy5x01EDYndMjGOESqdmLD
         i8z0uguqtoq/XXE1Oi5cQutxTOFuUFF7Xqvm+aTU4qnnehSfZ+KOzUMqdfHq83JgtH
         TPSTkZ4JcRwIsBeGNjple60BKwCBHNNkOuJggeyvaZ4RylIowuvzVl7IzHcZcYB8wm
         jjtTkCGnEYn0q7v1LWhklpFd0u7o8qm4vXi3KumtPQk1WQFeet37DYX1JXSXnUNOBz
         jKFn9vu2KP3hG9p5cca2Kiuqk1uxAGZ5FzIgDyYwi+SPlD9+dRT0b6xCpbgnMOAyTa
         LBcLxWQ/DrFpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Tronchin <davide.tronchin.94@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/19] net: usb: qmi_wwan: add u-blox 0x1342 composition
Date:   Mon, 28 Nov 2022 12:41:19 -0500
Message-Id: <20221128174120.1442235-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Tronchin <davide.tronchin.94@gmail.com>

[ Upstream commit a487069e11b6527373f7c6f435d8998051d0b5d9 ]

Add RmNet support for LARA-L6.

LARA-L6 module can be configured (by AT interface) in three different
USB modes:
* Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
interfaces
* RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
interfaces and 1 RmNet virtual network interface
* CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
interface and 1 CDC-ECM virtual network interface

In RmNet mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parset/alternative functions
If 4: RMNET interface

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index a1c9233e264d..f4218f604556 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1351,6 +1351,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
+	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.35.1

