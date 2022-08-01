Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751BC587080
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiHASst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiHASsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:48:47 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D0D237C0;
        Mon,  1 Aug 2022 11:48:45 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc12a.ng.seznam.cz (email-smtpc12a.ng.seznam.cz [10.23.11.105])
        id 2925978acd8944b428f836e4;
        Mon, 01 Aug 2022 20:47:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659379679; bh=DZl/zpDC4daeyZK5+yAdaWiaFpHk14LLzJ5mzlIQIT0=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=KBd1HmI8foVQT0ufUitgmsfk/ku+CiIOL/HD+dIBMsInW7nv1pgc4K6hV+/ZIGJ68
         RtvUv/iBPaIV92KYd+/KGpvI0WyscsLXCPzfA1Nj23MvqptxztsuV8YIN3PnA6vNYA
         zd0hfgT7zmueEuY+hkbo1qa8ifvYFeqX7/R5zoV4=
Received: from localhost.localdomain (2a02:8308:900d:2400:95cc:114a:1ae8:6a72 [2a02:8308:900d:2400:95cc:114a:1ae8:6a72])
        by email-relay1.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 01 Aug 2022 20:47:54 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v2 3/3] doc: ctucanfd: RX frames timestamping for platform devices
Date:   Mon,  1 Aug 2022 20:46:56 +0200
Message-Id: <20220801184656.702930-4-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <76f84256-b676-4728-b145-325ee172cef1>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the section about timestamping RX frames with instructions
how to enable it.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../device_drivers/can/ctu/ctucanfd-driver.rst      | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 40c92ea272af..05a7ce0c3d9e 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -386,8 +386,17 @@ The CTU CAN FD core reports the exact timestamp when the frame has been
 received. The timestamp is by default captured at the sample point of
 the last bit of EOF but is configurable to be captured at the SOF bit.
 The timestamp source is external to the core and may be up to 64 bits
-wide. At the time of writing, passing the timestamp from kernel to
-userspace is not yet implemented, but is planned in the future.
+wide.
+
+Both platform and PCI devices can report the timestamp.
+For platform devices, add another clock phandle for timestamping clock
+in device tree bindings. If you don't add another clock, the driver
+will assume the primary clock's frequency for timestamping.
+For PCI devices, the timestamping frequency is assumed to be equal to
+the bus frequency.
+
+Timestamp reporting is disabled by default, you have to enable it with
+SIOCSHWTSTAMP ioctl call first.
 
 Handling TX
 ~~~~~~~~~~~
-- 
2.25.1

