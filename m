Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215496C9709
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjCZRA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjCZRA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:00:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB5459F1
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ek18so26611244edb.6
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GgdFnEC+G0UCGygoBkz7mAsO99oCv1F1QOJil/I+FSQ=;
        b=rSbRs0Ejz+MMl27sWojxGrzlH3aPN7wM/mRGklbiFbsSfzLE6SzDusJOrZmIGz89Sr
         eeVuXyjpeBnxO+O02Gwo/n6s8JMKjsR8vES1BqblAYE+XfmYSzIDvZ0MSK1jBWA8zHjU
         Lxsj9A8lpwGxaWjyg03HkOVceVnsFkzqERo1dxzw3LA49ehDc0jN2Vbw3Se+xao/NKpD
         TK354xn2UcUNSpsbFFJir3kjG2N0OzKLQqOrvNvQrz9lW9WPZtNOTMgA9vzBnVdOz8Y3
         lj9VUlRgNTOZdkshZ4ylCM1wy5XQEq2eefSjI2MkuHuIlT71o9Rx99zwAR0kZs/CdCZO
         oAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GgdFnEC+G0UCGygoBkz7mAsO99oCv1F1QOJil/I+FSQ=;
        b=YKD8P87Meft3kQoxMoaFWhE5emFAHWJf8Y2BT/I9z27Ii5Am/uDRgBoLX8CMoZlfQB
         iU2MFEhEw9ezQHwvzS3+FDEqUSjpZDNkx+i6MIVQwpYH+chhTQWlDaikKFCM4r1lSjTd
         ulpmudOi6HX8xaBQgmdpelystWJhS7QCcOUiq9QD9i7NcOPDS9t6zdRn0blcQXMw0C+k
         8mnxOBpUxby4fjZ/mzFmD8OmS1+TMuIdwZ20U16vuPGfCtuL3EyNrRVS+xt6WrkgMOLr
         q5iZP2zmLerQ6RXo+ai57aLFJLMd7OyeBHavD+XxOk9iEyQTaqPHfzQcWHhD2R0D5ZQK
         6irg==
X-Gm-Message-State: AAQBX9cElzCubnzVCvC16H2iAV/k0vPpEp7czb2ZrGiuGM3g8hW5M06i
        8FspMrRpzH5ltzqzcRZINxzdxh0ULG1Yvpm3iZ0=
X-Google-Smtp-Source: AKy350YyNS3KsH2kUfOS1O4CATRcNe1sskoWPr1JyRQV1IsigQ2KYF8G1P2M2bXOhaWZiVn1xP/x+g==
X-Received: by 2002:a17:907:3188:b0:8b1:781d:f9a4 with SMTP id xe8-20020a170907318800b008b1781df9a4mr10631709ejb.21.1679850055485;
        Sun, 26 Mar 2023 10:00:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 27-20020a170906319b00b0093ba099fe64sm6650424ejy.182.2023.03.26.10.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:00:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 1/7] dpll: make ops function args const
Date:   Sun, 26 Mar 2023 19:00:46 +0200
Message-Id: <20230326170052.2065791-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Make ops args passed over *_register() functions const.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_core.c | 25 ++++++++++++-------------
 include/linux/dpll.h     |  9 +++++----
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index d478ab5e2001..7f8442b73fd8 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -89,7 +89,7 @@ dpll_device_get_by_name(const char *bus_name, const char *device_name)
  */
 static int
 dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
-		    struct dpll_pin_ops *ops, void *priv)
+		    const struct dpll_pin_ops *ops, void *priv)
 {
 	struct dpll_pin_ref *ref;
 	unsigned long i;
@@ -189,7 +189,7 @@ dpll_xa_ref_pin_find(struct xarray *xa_pins, const struct dpll_pin *pin)
  */
 static int
 dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
-		     struct dpll_pin_ops *ops, void *priv)
+		     const struct dpll_pin_ops *ops, void *priv)
 {
 	struct dpll_pin_ref *ref;
 	unsigned long i;
@@ -385,8 +385,9 @@ EXPORT_SYMBOL_GPL(dpll_device_put);
  * * 0 on success
  * * -EINVAL on failure
  */
-int dpll_device_register(struct dpll_device *dpll, struct dpll_device_ops *ops,
-			 void *priv, struct device *owner)
+int dpll_device_register(struct dpll_device *dpll,
+			 const struct dpll_device_ops *ops, void *priv,
+			 struct device *owner)
 {
 	if (WARN_ON(!ops || !owner))
 		return -EINVAL;
@@ -551,7 +552,7 @@ EXPORT_SYMBOL_GPL(dpll_pin_put);
 
 static int
 __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
-		    struct dpll_pin_ops *ops, void *priv,
+		    const struct dpll_pin_ops *ops, void *priv,
 		    const char *rclk_device_name)
 {
 	int ret;
@@ -592,10 +593,9 @@ __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
  * * -EINVAL - missing dpll or pin
  * * -ENOMEM - failed to allocate memory
  */
-int
-dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
-		  struct dpll_pin_ops *ops, void *priv,
-		  struct device *rclk_device)
+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
+		      const struct dpll_pin_ops *ops, void *priv,
+		      struct device *rclk_device)
 {
 	const char *rclk_name = rclk_device ? dev_name(rclk_device) : NULL;
 	int ret;
@@ -661,10 +661,9 @@ EXPORT_SYMBOL_GPL(dpll_pin_unregister);
  * * -ENOMEM failed allocation
  * * -EPERM if parent is not allowed
  */
-int
-dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
-			 struct dpll_pin_ops *ops, void *priv,
-			 struct device *rclk_device)
+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
+			     const struct dpll_pin_ops *ops, void *priv,
+			     struct device *rclk_device)
 {
 	struct dpll_pin_ref *ref;
 	unsigned long i, stop;
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 2e516d91c343..496358df83a9 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -123,8 +123,9 @@ void dpll_device_put(struct dpll_device *dpll);
  * @owner: device struct of the owner
  *
  */
-int dpll_device_register(struct dpll_device *dpll, struct dpll_device_ops *ops,
-			 void *priv, struct device *owner);
+int dpll_device_register(struct dpll_device *dpll,
+			 const struct dpll_device_ops *ops, void *priv,
+			 struct device *owner);
 
 /**
  * dpll_device_unregister - deregister registered dpll
@@ -200,7 +201,7 @@ struct dpll_pin
  * * -EBUSY - couldn't allocate id for a pin.
  */
 int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
-		      struct dpll_pin_ops *ops, void *priv,
+		      const struct dpll_pin_ops *ops, void *priv,
 		      struct device *rclk_device);
 
 /**
@@ -244,7 +245,7 @@ void dpll_pin_put(struct dpll_pin *pin);
  * * -EEXIST - pin already registered with this parent pin,
  */
 int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
-			     struct dpll_pin_ops *ops, void *priv,
+			     const struct dpll_pin_ops *ops, void *priv,
 			     struct device *rclk_device);
 
 /**
-- 
2.39.0

