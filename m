Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E552584C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359487AbiELX2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359472AbiELX2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:28:23 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6D34B81;
        Thu, 12 May 2022 16:28:21 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc17a.ng.seznam.cz (email-smtpc17a.ng.seznam.cz [10.23.18.18])
        id 3b4a8071dfe6534f3a97211f;
        Fri, 13 May 2022 01:28:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1652398093; bh=Irz5y4Fs6NYHzyfuWBHo/6l/ndZWpdRu3zSk1CvfZSg=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=d2ZQldvb9eKhCHkPsE+x6XnBv+m+PpcmvYKCwP8IdV9uq9EHzKSTwcO3VfP9BdLQM
         jBnV+nknzSoKA8KO86+3Xjn4lnQWw1ZSppN0WdysYBFFTm8TfyADsqQw/qJS02y9oH
         zjzvnWkbewYQWiG+MU5rRRpvLTucF5XxVuudP/gY=
Received: from localhost.localdomain (ip-89-176-234-80.net.upcbroadband.cz [89.176.234.80])
        by email-relay29.ng.seznam.cz (Seznam SMTPD 1.3.136) with ESMTP;
        Fri, 13 May 2022 01:28:08 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com,
        matej.vasilevski@seznam.cz
Subject: [RFC PATCH 3/3] doc: ctucanfd: RX frames timestamping for platform devices
Date:   Fri, 13 May 2022 01:27:07 +0200
Message-Id: <20220512232706.24575-4-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <86776cbb-31ff-433e-8494-c9ed56c96341>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the section about timestamping RX frames with instructions
how to enable it.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../networking/device_drivers/can/ctu/ctucanfd-driver.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 2fde5551e756..53ebdde3fffe 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -386,8 +386,12 @@ The CTU CAN FD core reports the exact timestamp when the frame has been
 received. The timestamp is by default captured at the sample point of
 the last bit of EOF but is configurable to be captured at the SOF bit.
 The timestamp source is external to the core and may be up to 64 bits
-wide. At the time of writing, passing the timestamp from kernel to
-userspace is not yet implemented, but is planned in the future.
+wide. Currently only timestamps from platform devices are supported,
+no support for PCI devices yet. To enable timestamping, recompile the
+kernel with CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS set to yes. You
+will also have to provide the timestamping counter frequency and bit
+width in the device tree, see the dt-bindings documentation for more
+details.
 
 Handling TX
 ~~~~~~~~~~~
-- 
2.25.1

