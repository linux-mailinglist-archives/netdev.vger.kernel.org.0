Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5845354E5F1
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377185AbiFPPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiFPPXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:23:47 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A6421E0F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:23:46 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id x75so1211431qkb.12
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mtu.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uf2srz+jvUuBHVzeHSAw8LdbJCHtKsvu2sAafAia9yQ=;
        b=edJu7G4J3ImG0fR3ZwDCYQThhDqRjboD6CjK6OqPgfSVQd+yOL+zAtuxSkiTs6cuQ+
         tNtcqOMnQiysxZInQmPdjPM+XE6NBULDg0NmXyScAvf2r0UYfOqpOPipMmTw4JE4DDas
         +V/8DBgKhk/JDTuOiJcSzBEM3K6uB368O2J+iDwRojbODRsaDBRcpDmo0NdwtNktb/s3
         jIaujkjpwjxTjafHiFg3eygK71rA1O26SumVkqjoUUkaJ8ajm14TRRBYd7wt+NYlw2b6
         94xZtn1R9tEfqxvDgdtdi9ZrUqFQRefROHsJu1pZpJWx1AxWE6Ul5YHGC+LMtVbHQ4MB
         k5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uf2srz+jvUuBHVzeHSAw8LdbJCHtKsvu2sAafAia9yQ=;
        b=QZckX/kggZaGVyxvFrYLfn8cMIVuNtFnRVkX8gXutdINPbcDNcvGrx9IDxTTYw1X3A
         I/UO+K+CddQ+sGeUNYa0oFWiEfQ/GtC3hC4UUMu/y3BDdAE8SLo17xdRbd5QZDGQ+y02
         mOR9s/7Dve9I+tX9JyRAPRJ3OKvmiYqPwwl5461AqqTPgun8a9m6NmqxGVho+RzU2d9w
         r0CVx1UWxSqpV4zT6OMbgvCXhanaKwjx96x5aatafGxIamA8GBMi2qmn4TbCHFALGAU9
         jIstYEakR2PKmOgGr1aFcYxuousfGuwH0C114635R6thcYj4mepSG0KM3hA9nt7SxOJn
         hicg==
X-Gm-Message-State: AJIora9p4rVm97Mc8Ffu46ldptRsz376gsS36LHFLGF0Y2an35ET64i0
        fXBQ74IViGkNXx0VM/LFUpoWJw==
X-Google-Smtp-Source: AGRyM1s4xlVCkGrMLrNyd0BYyj/zbIMYf+az4x+5ozfFtKkrExWnFMej+TMq5+C4DA5CbVBzFXDCgQ==
X-Received: by 2002:a05:620a:4142:b0:6a7:59c9:c0b0 with SMTP id k2-20020a05620a414200b006a759c9c0b0mr3933642qko.13.1655393025281;
        Thu, 16 Jun 2022 08:23:45 -0700 (PDT)
Received: from Peter-Reagan-Desktop-VI.. (z205.pasty.net. [71.13.100.205])
        by smtp.googlemail.com with ESMTPSA id i3-20020a05622a08c300b002f92b74ba99sm1861240qte.13.2022.06.16.08.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 08:23:44 -0700 (PDT)
From:   Peter Lafreniere <pjlafren@mtu.edu>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org,
        Peter Lafreniere <pjlafren@mtu.edu>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v4] ax25: use GFP_KERNEL in ax25_dev_device_up()
Date:   Thu, 16 Jun 2022 11:23:33 -0400
Message-Id: <20220616152333.9812-1-pjlafren@mtu.edu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ax25_dev_device_up() is only called during device setup, which is
done in user context. In addition, ax25_dev_device_up()
unconditionally calls ax25_register_dev_sysctl(), which already
allocates with GFP_KERNEL.

Since it is allowed to sleep in this function, here we change
ax25_dev_device_up() to use GFP_KERNEL to reduce unnecessary
out-of-memory errors.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>
---
v3 -> v4:
 - Cleaned up coding style
    - Thanks to to Paolo Abeni

v2 -> v3:
 - Rebased for clean application to net-next

v1 -> v2:
 - Renamed patch from "ax25: use GFP_KERNEL over GFP_ATOMIC where possible"
 - Removed invalid changes to ax25_rt_add()

 net/ax25/ax25_dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index ab88b6ac5401..c5462486dbca 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -52,7 +52,8 @@ void ax25_dev_device_up(struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 
-	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_ATOMIC)) == NULL) {
+	ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_KERNEL);
+	if (!ax25_dev) {
 		printk(KERN_ERR "AX.25: ax25_dev_device_up - out of memory\n");
 		return;
 	}
@@ -60,7 +61,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
-	netdev_hold(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
+	netdev_hold(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
 	ax25_dev->forward = NULL;
 	ax25_dev->device_up = true;
 

base-commit: 5dcb50c009c9f8ec1cfca6a81a05c0060a5bbf68
-- 
2.36.1
