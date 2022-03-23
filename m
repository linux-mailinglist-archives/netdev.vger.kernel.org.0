Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4484E5B00
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345086AbiCWWB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 18:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345080AbiCWWB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 18:01:57 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C845B5AEE5;
        Wed, 23 Mar 2022 15:00:26 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-d6ca46da48so3121044fac.12;
        Wed, 23 Mar 2022 15:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=cCUJOW25CLr0CeLCnE62n9am59728Z8IpIAoIkTyH8w=;
        b=BrN0/8+UKuT/c/CxI6vxUQoH8bAOu5CLLGm0B1gaXmAlXGpD5RAIYpoQiv/g/PHo0n
         zgrW2NzOL21eJiKJMrksxsLY5cEzU8GdSIiMvX+jEo7JBJPVAJaX+cA6ixDdJ6xq1zKM
         TK6NO1/dGDclpceuyLpigdW8hUJim1AVc1Cykc564tB6rp3wjlFprtbbYbBsdyhomcch
         uJ+DH7iQUKJiujYBygCXWhVZozbUTzMXzFa96/0JIlqGvJZ6WisDrpGk2jy7OOcpGZXE
         U3cm/P9/4RmHUpiA+5v0jFwbTf4Pr8RHeaVsvtZduhILkPrc4CRMBMB9eKc61WSRwoDP
         sfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=cCUJOW25CLr0CeLCnE62n9am59728Z8IpIAoIkTyH8w=;
        b=wingd7PxZXTPptVSgziEAP5limmTh/KSJ8KmBaZZwskzbNPwtIuKrXuH47Q7A/nQS0
         6Zr29LA64CoZOpytCDkMfNLo9po1a9aBd1QrlJA7zM1ufgUTbquBu/EoD5Pz/QyenGyE
         qDYNYcJ39gG/3SBdo4HXCPSLxYpku28/ekBRzx72AkSJtE14knxVCHUHqTlgZO0cBlmK
         SB0i2Xk//gaj9m3lgpkmeRUTECz1IBhuDV8mf1jaPYK2FKD/rbGsNrhAXx0zBGvnHOPs
         fzVYc2vq2y+cT9VMq7TpT02wPvc2umk0g+tIPU5aFMcnYtUD1+J3NVMmYRPD6jp+w9Nk
         L/6Q==
X-Gm-Message-State: AOAM531ByyHBsXhMy6BidHpuBl9fIaUA6wyLPPJeAm+I2kPQ8/QErUzP
        VPMAkeVPf0OqCNOWLZ5YCvKe5GLjfGldcvOj
X-Google-Smtp-Source: ABdhPJxKYcohZLXbzIiEAcg3BmdYtw/mH4Ru7srghs3Ss4x/V6+R8kTndUbj/ELK42v6ZBNc50K2+w==
X-Received: by 2002:a05:6870:42d0:b0:dd:acbd:14dc with SMTP id z16-20020a05687042d000b000ddacbd14dcmr1041713oah.87.1648072825998;
        Wed, 23 Mar 2022 15:00:25 -0700 (PDT)
Received: from test-HP-EliteDesk-800-G1-SFF ([70.102.108.170])
        by smtp.gmail.com with ESMTPSA id w8-20020aca3008000000b002ef7e3ad3b8sm490262oiw.29.2022.03.23.15.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:00:25 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:00:24 -0700
From:   Greg Jesionowski <jesionowskigreg@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: ax88179_178a: add Allied Telesis AT-UMCs
Message-ID: <20220323220024.GA36800@test-HP-EliteDesk-800-G1-SFF>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the driver_info and IDs for the AX88179 based Allied Telesis AT-UMC
family of devices.

Cc: stable@vger.kernel.org
Signed-off-by: Greg Jesionowski <jesionowskigreg@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 51 ++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index a31098981a65..e2fa56b92685 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1872,6 +1872,45 @@ static const struct driver_info mct_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info at_umc2000_info = {
+	.description = "AT-UMC2000 USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter",
+	.bind   = ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset  = ax88179_reset,
+	.stop   = ax88179_stop,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
+static const struct driver_info at_umc200_info = {
+	.description = "AT-UMC200 USB 3.0/USB 3.1 Gen 1 to Fast Ethernet Adapter",
+	.bind   = ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset  = ax88179_reset,
+	.stop   = ax88179_stop,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
+static const struct driver_info at_umc2000sp_info = {
+	.description = "AT-UMC2000/SP USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter",
+	.bind   = ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset  = ax88179_reset,
+	.stop   = ax88179_stop,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1913,6 +1952,18 @@ static const struct usb_device_id products[] = {
 	/* Magic Control Technology U3-A9003 USB 3.0 Gigabit Ethernet Adapter */
 	USB_DEVICE(0x0711, 0x0179),
 	.driver_info = (unsigned long)&mct_info,
+}, {
+	/* Allied Telesis AT-UMC2000 USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter */
+	USB_DEVICE(0x07c9, 0x000e),
+	.driver_info = (unsigned long)&at_umc2000_info,
+}, {
+	/* Allied Telesis AT-UMC200 USB 3.0/USB 3.1 Gen 1 to Fast Ethernet Adapter */
+	USB_DEVICE(0x07c9, 0x000f),
+	.driver_info = (unsigned long)&at_umc200_info,
+}, {
+	/* Allied Telesis AT-UMC2000/SP USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter */
+	USB_DEVICE(0x07c9, 0x0010),
+	.driver_info = (unsigned long)&at_umc2000sp_info,
 },
 	{ },
 };
-- 
2.25.1

