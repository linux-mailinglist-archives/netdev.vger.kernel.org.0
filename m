Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5766C0808
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjCTBEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCTBDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:03:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5EC23C4D;
        Sun, 19 Mar 2023 17:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F22611FD;
        Mon, 20 Mar 2023 00:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E585AC4339B;
        Mon, 20 Mar 2023 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273790;
        bh=9tY99DwOS+XEkzwY5IdgPgQ6IL9ZaRmMz3bydicwHuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY/x89xy1/45FraW1PfVD6R/pO9T+GUvF1JE7Y52FMgx1ipvLNYhNw2mAS16o2/ql
         jJwfsekFZY8qvlLjrRFlD2lbx80hR8txsNI19otnd1DUeVWZg98n1MzaDa27cpx8kk
         JtxdwdcsRamNbLMlfezVZ+4RNScvdo9DBZUFDAc85rQ5aU1ZmqZWkLCKOlY1sLZ62C
         JO5Rc52qmp4Skv98N+KaxKIIJMgE3MBkNab+QRjjWmSeVJcXMYrz+XomNEEeKbClBv
         CJFsA8z0YrGPRJVRpkEDcDK8PHDVwDEAKJ+OjEVRHOus2FBC7gq/Z38Oujryerv7y1
         x2wRWKhhNpD/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, bjorn@mork.no,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/15] net: usb: qmi_wwan: add Telit 0x1080 composition
Date:   Sun, 19 Mar 2023 20:55:58 -0400
Message-Id: <20230320005559.1429040-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Sau <enrico.sau@gmail.com>

[ Upstream commit 382e363d5bed0cec5807b35761d14e55955eee63 ]

Add the following Telit FE990 composition:

0x1080: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Link: https://lore.kernel.org/r/20230306120528.198842-1-enrico.sau@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index bce151e3706a0..070910567c44e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1297,6 +1297,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.39.2

