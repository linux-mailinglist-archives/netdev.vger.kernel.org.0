Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1468E6C9710
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjCZRBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjCZRBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6635659C
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so26519997edb.10
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwW6oUpD5h8cj23E/vde86PKPUzMAEIVBwgEWSiD3uA=;
        b=maShE7hQ0xVsk01dePT8Gyl+ZzjKlPhD4CBzQJx8U5K+HL4vf+tAy2IyFHqgOLz7V9
         4au6EfidxkbYOBa8mB01sV8TLc2+RaUbM7pcXwv9/41bu0u0LJ/X52M090WluCeG5pN2
         3InXvbCpLGcWUlhj0jS8I53HT9I879VPJSOehlH9ERkRAOVvAEjSojNUOD8EUYXVjquN
         BnmnvLeF/HzvaFH9VAPlD1L0pzsFab6SabwqVfkTONYS0sANTpLe+QFACxNVzG88wAE7
         EQjd9w37QGfEdTrng5xsesLYMOJbBaF8anaWikTSAOPEshw8p5gbTWutIohked+ICaOJ
         3bNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bwW6oUpD5h8cj23E/vde86PKPUzMAEIVBwgEWSiD3uA=;
        b=akeffW4I8DzwCKRBTh0qAhyIWY7p1RlTVuVrkwxHHaOO6cpMT5W2w6l0D30vRm3qp/
         OriMWgUBOMRgpIGCowZgUrNwMdKbJ3jONSTfek6s084km2BvOCHW6Ez5gn7FUQAwIu+S
         b/RsvPt13khpc2Anee8RwcMDfuP2WYr+RMUXiW0SsEVITfACjPVpWOKCtCUIVkfUw8ud
         9Mxdjmrglwt0ZiqDrV/w7LoDOSLRhU1JwoQg157yTjgMnQOmq8ZWbTI5Za2JSX05g/64
         S23Q7qNIJdMbzV7/zICWM/UbljZ3uIsTYOAFauzDBdbIcrIl79T+JP8iD3B+S0DlOT2c
         zK+Q==
X-Gm-Message-State: AAQBX9fQGVg+zHoH4CPdTnRZi1bH8mQHxCcRl2rKizOYHRz/YPLrGx5X
        OjeQ8sEvo87UWWiNdSmocCtnRvH9BMhz72mBkTE=
X-Google-Smtp-Source: AKy350aAoyrIBElGGuBqNIPvfAlr7j+pHNViwWZzsB345Jd6yv4nK48yXBcBagk0NV05PxljKZpuCg==
X-Received: by 2002:a17:906:578c:b0:88f:a236:69e6 with SMTP id k12-20020a170906578c00b0088fa23669e6mr9545337ejq.7.1679850061356;
        Sun, 26 Mar 2023 10:01:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m27-20020a170906259b00b0093a3a663ebdsm7941215ejb.154.2023.03.26.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:01:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 5/7] dpll: export dpll_pin_notify()
Date:   Sun, 26 Mar 2023 19:00:50 +0200
Message-Id: <20230326170052.2065791-6-jiri@resnulli.us>
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

Export dpll_pin_notify() as it is needed to be called from drivers.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_netlink.c | 1 +
 drivers/dpll/dpll_netlink.h | 3 ---
 include/linux/dpll.h        | 4 ++++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 125dc3c7e643..cd77881ee1ec 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -1056,6 +1056,7 @@ int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
 {
 	return dpll_send_event_change(dpll, pin, NULL, attr);
 }
+EXPORT_SYMBOL_GPL(dpll_pin_notify);
 
 int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
 			   struct dpll_pin *parent, enum dplla attr)
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
index 072efa10f0e6..952e0335595e 100644
--- a/drivers/dpll/dpll_netlink.h
+++ b/drivers/dpll/dpll_netlink.h
@@ -20,9 +20,6 @@ int dpll_notify_device_create(struct dpll_device *dpll);
  */
 int dpll_notify_device_delete(struct dpll_device *dpll);
 
-int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
-		    enum dplla attr);
-
 int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
 			   struct dpll_pin *parent, enum dplla attr);
 
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index be5717e1da99..562b9b7bd001 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -287,5 +287,9 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
  */
 int dpll_device_notify(struct dpll_device *dpll, enum dplla attr);
 
+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+		    enum dplla attr);
+
+
 
 #endif
-- 
2.39.0

