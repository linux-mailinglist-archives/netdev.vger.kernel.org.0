Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314A954FC16
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382790AbiFQRT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiFQRT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:19:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CCE2AE04
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h1so4391458plf.11
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g39sl/bxWP+5Phb79mJioFx00vthSTWEl2jzD0DUt6M=;
        b=vNSPQ2ulr5sXURu6BBb/Xzh8d6qXhGofCeb/hhizLB0uUrnXSHMpcErA3pAHnm6CbN
         QKnYGyOJAjg1jh8X4ulIoDvIbKO3oANMrJEJGFDfu2A2/ZyFQsRSU8qHrBBvffn/oav5
         W10ppm94NlUkDwExYX+cHdJN59jHps1EKgLR1lesGy6qkw7jd7FnbGuav9fsN6aA/JDg
         Gvs954TYgp7QCJlroHtBMYOPZmDYo4BN8jUfUm0jgjRlBpTWMS1+LJEVw+NA8klIaGwY
         8dFalz+VjoX4SV0E9a65ug0LCZcoQW6mQAXBcwbLEGYyV6chSgEiCo9X5bn51NjXX7Ea
         orfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g39sl/bxWP+5Phb79mJioFx00vthSTWEl2jzD0DUt6M=;
        b=dvQQKz/JRxfST4kGdoYjWtTPEY/sDGSlV0e6i64R3YtnkKo74BwEWrqjG0kOT/1KV4
         ZfwIPIFliuANQLaYwkKBogwiM7RITgNBK6OwMT0oDtf/MET/ryYXLmKC7GDpKZRWCL/d
         tkOXX3b3c3z5Qbw/IEIbQxCI3gSJE/2PEOWQHiP3wVckIEyuQQzOSPkebQPS/22Xda3A
         14gxx1Uu+A87jWxqxnKE/GVNraNsHTO7JOhANL9VhZtEKI6KrNxpVQKbj5I9YJ3hdJ2Y
         O6nHSDPoLm5rt2aqdp7i+56GQe+BmYSJwO7xXVAW3jJVs0xjwZxB9UQ38DCiFAaFtz1B
         jb2w==
X-Gm-Message-State: AJIora+x8oOUvWifT5Nqol0mIo1jYdMBvmHwKO7xZBfY1ySROIHbCvQh
        lpCAe8nfEWATnwtfm1XexZHyyTJw3jEn0Wc4
X-Google-Smtp-Source: AGRyM1u0H1uWoEnZUv4wDhSaJt+nurydBQUwm2YHLepwS0Qh9dHXCVqIr5MmP66NdEX0c7ctTg7RHg==
X-Received: by 2002:a17:903:2488:b0:163:b2c0:7efe with SMTP id p8-20020a170903248800b00163b2c07efemr10592030plw.164.1655486396990;
        Fri, 17 Jun 2022 10:19:56 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o26-20020a63921a000000b00408a3724b38sm4074714pgd.76.2022.06.17.10.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:19:56 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/2] genl: fix duplicate include guard
Date:   Fri, 17 Jun 2022 10:19:52 -0700
Message-Id: <20220617171953.38720-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220617171953.38720-1-stephen@networkplumber.org>
References: <20220617171953.38720-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include guard should be unique per file.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 genl/genl_utils.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/genl/genl_utils.h b/genl/genl_utils.h
index 87b4f34c58d8..9fbeba75b4b8 100644
--- a/genl/genl_utils.h
+++ b/genl/genl_utils.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _TC_UTIL_H_
-#define _TC_UTIL_H_ 1
+#ifndef _GENL_UTILS_H_
+#define _GENL_UTILS_H_ 1
 
 #include <linux/genetlink.h>
 #include "utils.h"
-- 
2.35.1

