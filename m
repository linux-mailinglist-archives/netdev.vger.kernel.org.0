Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4CE5931A3
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiHOPSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243220AbiHOPSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:18:40 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C9826AF5;
        Mon, 15 Aug 2022 08:18:38 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id 5so2987221uay.5;
        Mon, 15 Aug 2022 08:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DIWrbZlEfd3/DW1QpNhOvoAtHCnXwPVvDcMVlPM1dEQ=;
        b=PjIiC7HNPU5Nsj8C3oCKOE98jQqGcPh7kjA3se8Kp9zQ67wBS3pPpkri9FEguyJKUK
         9x1BTGMFGUX3mhJV3MlAGfWcJavFHpHptpKdsIfy2N+MAcDMh61O+sB9aELY5zRKUaND
         G6+RZTyavNX3vCvp1npeWmaVKmJuhb2NtqJt6oK4/Nca/YO/dT/ra3+lTyD8bufSuCek
         LSAPA6RumHpYeIfmY/rSdh0jMo7VQ9DhrjiKDgLSBQYMJoJkf4uIiaxfAvIxkpHoC7cR
         GbvqTM9Jsp4xo+Q/FsyEBzv0qrNUC23b1YYIcFGJEzendKR6fZqf3eqFV2JkxgiMCHp6
         wjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DIWrbZlEfd3/DW1QpNhOvoAtHCnXwPVvDcMVlPM1dEQ=;
        b=sE641fDjELwaMpwFdQ0cHLipRb4g9IvCGdSxQMIi6aI27aHv3m89iR5mMWr2+B03bj
         TmwL1wnQ1Z3P8XPhvLlHDqwXTfMNhP87bSsKXw90VBEBHlt8cwm85eaXiduknZrhVu72
         6+PW5Uj7zPqRk8jesyDalMjYwHrV0VA803cX82IpC3bFrJxUw9etbXL2HONO0GeItuHh
         PtJQui1bQ6itLxzfsF3VBRsER6pH/ajQXye5eDUQa5TxZiW5LnrQvqV9IB3YdoAfYhZ6
         qXprXFaCl9ypbbTElI8L3hfYJfQs1LfSUJ6kJDGT32fOYsNeHsS+TQgYxgFBBw8JednP
         emNQ==
X-Gm-Message-State: ACgBeo0QbMf6uI/TtOHqdwnjj3Hvrhi+NqLZa13pmW3j5AuEjKVyjrOF
        Bukol6+GmLB2H/co/fyylls7u5YVrtMo4v32
X-Google-Smtp-Source: AA6agR7YC9NycKv5xOMUyAcalxUtBHGX97aONxdmgX/nEECSm1+Dl+GaD9zL7fEE+Ok6lGoZxuzbNA==
X-Received: by 2002:ab0:760d:0:b0:384:cea0:b24f with SMTP id o13-20020ab0760d000000b00384cea0b24fmr6828696uap.7.1660576717721;
        Mon, 15 Aug 2022 08:18:37 -0700 (PDT)
Received: from laptop.. ([2804:14c:71:8fe6:44c:4bb9:384e:eda5])
        by smtp.gmail.com with ESMTPSA id y18-20020ab02eb2000000b00390cbced44csm4574448uay.7.2022.08.15.08.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:18:37 -0700 (PDT)
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH stable 5.4.x] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 12:18:32 -0300
Message-Id: <20220815151832.319094-1-joalonsof@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 6fd2c17fb6e02a8c0ab51df1cfec82ce96b8e83d upstream.

This reverts commit 36a15e1cb134c0395261ba1940762703f778438c.

The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
versions that have no issues.

The FLAG_SEND_ZLP is not safe to use in this context.
See:
https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
The original problem needs another way to solve.

Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
Cc: stable@vger.kernel.org
Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
Link: https://bugs.archlinux.org/task/75491
Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5ee3e457a79c..ea9c8361bf46 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1690,7 +1690,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1703,7 +1703,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1716,7 +1716,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1729,7 +1729,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1742,7 +1742,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1755,7 +1755,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1768,7 +1768,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1781,7 +1781,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
-- 
2.37.1

